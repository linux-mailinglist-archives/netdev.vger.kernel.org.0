Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0521E1530
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 22:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390141AbgEYUZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 16:25:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389665AbgEYUZg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 16:25:36 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13578206D5;
        Mon, 25 May 2020 20:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590438336;
        bh=D3w8i/IyirA1Ye2hSxc0L3KeeoY3n/XjJsJx3/aagIE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qT8RRe8lwFWLqNl/1Q6HEHPqcK8ds7XF9b/9cbxbnGnuE/d3pwW7zKjUow7PrIP+Q
         hb/AncreJXK/qQx+5lOta/WXrAKRYibinZswdb6jzVf3ZFOJXBaXin6/+5igjmSwfK
         2aP3zLdQr6xui7TA6m+O7S7NvGNGOMml6iqLQv/s=
Date:   Mon, 25 May 2020 13:25:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [PATCH net-next,v2] net/tls: fix race condition causing kernel
 panic
Message-ID: <20200525132534.1eeb2f55@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200522201031.32516-1-vinay.yadav@chelsio.com>
References: <20200522201031.32516-1-vinay.yadav@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 May 2020 01:40:31 +0530 Vinay Kumar Yadav wrote:
> tls_sw_recvmsg() and tls_decrypt_done() can be run concurrently.
> // tls_sw_recvmsg()
> 	if (atomic_read(&ctx->decrypt_pending))
> 		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
> 	else
> 		reinit_completion(&ctx->async_wait.completion);
> 
> //tls_decrypt_done()
>   	pending = atomic_dec_return(&ctx->decrypt_pending);
> 
>   	if (!pending && READ_ONCE(ctx->async_notify))
>   		complete(&ctx->async_wait.completion);
> 
> Consider the scenario tls_decrypt_done() is about to run complete()
> 
> 	if (!pending && READ_ONCE(ctx->async_notify))
> 
> and tls_sw_recvmsg() reads decrypt_pending == 0, does reinit_completion(),
> then tls_decrypt_done() runs complete(). This sequence of execution
> results in wrong completion. Consequently, for next decrypt request,
> it will not wait for completion, eventually on connection close, crypto
> resources freed, there is no way to handle pending decrypt response.
> 
> This race condition can be avoided by having atomic_read() mutually
> exclusive with atomic_dec_return(),complete().Intoduced spin lock to
> ensure the mutual exclution.
> 
> Addressed similar problem in tx direction.
> 
> v1->v2:
> - More readable commit message.
> - Corrected the lock to fix new race scenario.
> - Removed barrier which is not needed now.
> 
> Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>

The tree should have been net, since this is a fix for:

Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records for performance")

but admittedly it's not very urgent.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

We can try the trick with recording async_notify as a large bias 
on crypt_pending if the spin lock slows things down.
