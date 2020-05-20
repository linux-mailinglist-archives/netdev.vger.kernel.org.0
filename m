Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE20F1DBF37
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 21:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgETT6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 15:58:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728304AbgETT6r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 15:58:47 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0E34207E8;
        Wed, 20 May 2020 19:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590004726;
        bh=A3nWAiWt/bsDMIIM/0R0P4Tr8tnr59JNXajHVqwwFzE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vaUVuI7D4eJlLubcvlqrGAX5HM2Wq4VpU10SGdP4ddTjDxVrqKVL3hlLn0OjBti7A
         3NPKwQti9i6yFmXuAqIGJlT06BCYyqTb9L6DjkXGXxzNwAQg3mGwbIl1sh8cpweseV
         zoDn5PS7Fxo76XNoeGQaTrHgO7n2O37L6Y7soUZ4=
Date:   Wed, 20 May 2020 12:58:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        secdev@chelsio.com
Subject: Re: [PATCH net-next] net/tls: fix race condition causing kernel
 panic
Message-ID: <20200520125844.20312413@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <99faf485-2f28-0a45-7442-abaaee8744aa@chelsio.com>
References: <20200519074327.32433-1-vinay.yadav@chelsio.com>
        <20200519.121641.1552016505379076766.davem@davemloft.net>
        <99faf485-2f28-0a45-7442-abaaee8744aa@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 22:39:11 +0530 Vinay Kumar Yadav wrote:
> On 5/20/2020 12:46 AM, David Miller wrote:
> > From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
> > Date: Tue, 19 May 2020 13:13:27 +0530
> >  
> >> +		spin_lock_bh(&ctx->encrypt_compl_lock);
> >> +		pending = atomic_read(&ctx->encrypt_pending);
> >> +		spin_unlock_bh(&ctx->encrypt_compl_lock);  
> > The sequence:
> >
> > 	lock();
> > 	x = p->y;
> > 	unlock();
> >
> > Does not fix anything, and is superfluous locking.
> >
> > The value of p->y can change right after the unlock() call, so you
> > aren't protecting the atomic'ness of the read and test sequence
> > because the test is outside of the lock.  
> 
> Here, by using lock I want to achieve atomicity of following statements.
> 
> pending = atomic_dec_return(&ctx->decrypt_pending);
>        if (!pending && READ_ONCE(ctx->async_notify))
>             complete(&ctx->async_wait.completion);
> 
> means, don't want to read (atomic_read(&ctx->decrypt_pending))
> in middle of two statements
> 
> atomic_dec_return(&ctx->decrypt_pending);
> and
> complete(&ctx->async_wait.completion);
> 
> Why am I protecting only read, not test ?

Protecting code, not data, is rarely correct, though.

> complete() is called only if pending == 0
> if we read atomic_read(&ctx->decrypt_pending) = 0
> that means complete() is already called and its okay to
> initialize completion (reinit_completion(&ctx->async_wait.completion))
> 
> if we read atomic_read(&ctx->decrypt_pending) as non zero that means:
> 1- complete() is going to be called or
> 2- complete() already called (if we read atomic_read(&ctx->decrypt_pending) == 1, then complete() is called just after unlock())
> for both scenario its okay to go into wait (crypto_wait_req(-EINPROGRESS, &ctx->async_wait))

First of all thanks for the fix, this completion code is unnecessarily
complex and brittle if you ask me.

That said I don't think your fix is 100%.

Consider this scenario:

# 1. writer queues first record on CPU0
# 2. encrypt completes on CPU1

 	pending = atomic_dec_return(&ctx->decrypt_pending);
	# pending is 0
 
# IRQ comes and CPU1 goes off to do something else with spin lock held
# writer proceeds to encrypt next record on CPU0
# writer is done, enters wait 

	smp_store_mb(ctx->async_notify, true);

# Now CPU1 is back from the interrupt, does the check

 	if (!pending && READ_ONCE(ctx->async_notify))
 		complete(&ctx->async_wait.completion);

# and it completes the wait, even though the atomic decrypt_pending was
#   bumped back to 1 

You need to hold the lock around the async_notify false -> true
transition as well. The store no longer needs to have a barrier.

For async_notify true -> false transitions please add a comment 
saying that there can be no concurrent accesses, since we have no
pending crypt operations.


Another way to solve this would be to add a large value to the pending
counter to indicate that there is a waiter:

	if (atomic_add_and_fetch(&decrypt_pending, 1000) > 1000)
		wait();
	else
		reinit();
	atomic_sub(decrypt_pending, 1000)

completion:

	if (atomic_dec_return(&decrypt_pending) == 1000)
		complete()
