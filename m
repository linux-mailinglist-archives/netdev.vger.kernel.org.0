Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A077E31548A
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 18:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbhBIQ76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 11:59:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:50228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232758AbhBIQ7w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 11:59:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5F9364DFF;
        Tue,  9 Feb 2021 16:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612889951;
        bh=8K5ejtn/yPTDA8lFr2UcKkYnKPVUdZcXXOHzTB6me4E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FgWHapvhi2j4xC0E6ZIEaJxUrYq3zTpyvvunu7eK7uxeibjPQxzsPKXLfbeofZ7Bq
         Ak71FX8P4Sg+ZcGFxTVAluNwpPbk8avPQb/d7HAO+gs7Q0Bwir+iI9Y/NjKxbv/7+w
         uUYGCXVSpWnrWaFmU6GIGJAZUjKtV4lGn7yCs1TJSgutELKiDnw/0t719JMMrXah2N
         +F+HvXoNOAP9UtVjPRplNDqZBuQRfvJHy454YnDNzxeuWaRhC9XYCO4c1eUep5EEmz
         O9MNtuxh+juwmyw8vHevJxztd8UDPtCkDNj5UtbXdrCEwuYN5jv4x4IuBvdUeAmREi
         TNeQpozgp5SZw==
Date:   Tue, 9 Feb 2021 08:59:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Arjun Roy <arjunroy.kdev@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, arjunroy@google.com, edumazet@google.com,
        soheil@google.com
Subject: Re: [net-next v2] tcp: Explicitly mark reserved field in
 tcp_zerocopy_receive args.
Message-ID: <20210209085909.32d27f0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <af35d535-8d58-3cf3-60e3-1764e409308b@gmail.com>
References: <20210206203648.609650-1-arjunroy.kdev@gmail.com>
        <20210206152828.6610da2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210207082654.GC4656@unreal>
        <20210208104143.60a6d730@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <09fa284e-ea02-a6ca-cd8f-6d90dff2fa00@gmail.com>
        <20210208185323.11c2bacf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <af35d535-8d58-3cf3-60e3-1764e409308b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Feb 2021 20:20:29 -0700 David Ahern wrote:
> On 2/8/21 7:53 PM, Jakub Kicinski wrote:
> > On Mon, 8 Feb 2021 19:24:05 -0700 David Ahern wrote:  
> >> That would be the case for new userspace on old kernel. Extending the
> >> check to the end of the struct would guarantee new userspace can not ask
> >> for something that the running kernel does not understand.  
> > 
> > Indeed, so we're agreeing that check_zeroed_user() is needed before
> > original optlen from user space gets truncated?
> 
> I thought so, but maybe not. To think through this ...
> 
> If current kernel understands a struct of size N, it can only copy that
> amount from user to kernel. Anything beyond is ignored in these
> multiplexed uAPIs, and that is where the new userspace on old kernel falls.
> 
> Known value checks can only be done up to size N. In this case, the
> reserved field is at the end of the known struct size, so checking just
> the field is fine. Going beyond the reserved field has implications for
> extensions to the API which should be handled when those extensions are
> added.

Let me try one last time.

There is no check in the kernels that len <= N. User can pass any
length _already_. check_zeroed_user() forces the values beyond the
structure length to be known (0) rather than anything. It can only 
avoid breakages in the future.

> So, in short I think the "if (zc.reserved)" is correct as Leon noted.

If it's correct to check some arbitrary part of the buffer is zeroed 
it should be correct to check the entire tail is zeroed.
