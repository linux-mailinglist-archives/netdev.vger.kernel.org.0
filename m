Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C7540B06E
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 16:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbhINOT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 10:19:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:50164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233572AbhINOTy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 10:19:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 575FD60EE3;
        Tue, 14 Sep 2021 14:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631629117;
        bh=hmk3l8uKly2hIllU1EA55mQcty/hncGCVOc8H5Nf8Pc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oa2985r3Yene7SIl37cxsjV6+5rvnA6HsWnuo5w6MhazW0Ehktn7S7WnnI6T6IPkU
         yZxVmSvUfyuSY7h5HEpxSAiUkeKlxR7IvL7TsgdTaVQH9ypy5nGmLOS2AnVROCzXAu
         rtnNdVupBaUapjBcqf4mexZmjI2CUkfoIXiKiB0vV5eHCP6dFJ27VbQ5Vsr9Ka9gRq
         NlMiIqcM9xwOhf7b/wDu45OG2A5w/a8tzMxBYZ/rjvvCY/SCTqXNS/0z21FaAAAPx7
         Cq4ZYUQHD6eTSlXpUFnJJgSXDAcfT6mF+GTgU/Oa0q5XZ6UvsNuTZDYf3offz8aura
         EXpViVXLuyS9A==
Date:   Tue, 14 Sep 2021 07:18:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     willemb@google.com, netdev@vger.kernel.org
Subject: Re: [RFC net] net: stream: don't purge sk_error_queue without
 holding its lock
Message-ID: <20210914071836.46813650@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3b5549a2-cb0e-0dc1-3cb3-00d15a74873b@gmail.com>
References: <20210913223850.660578-1-kuba@kernel.org>
        <3b5549a2-cb0e-0dc1-3cb3-00d15a74873b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Sep 2021 22:14:00 -0700 Eric Dumazet wrote:
> On 9/13/21 3:38 PM, Jakub Kicinski wrote:
> > sk_stream_kill_queues() can be called when there are still
> > outstanding skbs to transmit. Those skbs may try to queue
> > notifications to the error queue (e.g. timestamps).
> > If sk_stream_kill_queues() purges the queue without taking
> > its lock the queue may get corrupted.
> > 
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> > Sending as an RFC for review, compile-tested only.
> > 
> > Seems far more likely that I'm missing something than that
> > this has been broken forever and nobody noticed :S
> > ---
> >  net/core/stream.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/core/stream.c b/net/core/stream.c
> > index 4f1d4aa5fb38..7c585088f394 100644
> > --- a/net/core/stream.c
> > +++ b/net/core/stream.c
> > @@ -196,7 +196,7 @@ void sk_stream_kill_queues(struct sock *sk)
> >  	__skb_queue_purge(&sk->sk_receive_queue);
> >  
> >  	/* Next, the error queue. */
> > -	__skb_queue_purge(&sk->sk_error_queue);
> > +	skb_queue_purge(&sk->sk_error_queue);
> >  
> >  	/* Next, the write queue. */
> >  	WARN_ON(!skb_queue_empty(&sk->sk_write_queue));
> 
> This should not be needed.
> 
> By definition, sk_stream_kill_queues() is only called when there is no
> more references on the sockets.
> 
> So all outstanding packets must have been orphaned or freed.

I don't see the wait anywhere, would you mind spelling it out?
My (likely flawed) understanding is that inet_sock_destruct() gets
called when refs are gone (via sk->sk_destruct).

But tcp_disconnect() + tcp_close() seem to happily call
inet_csk_destroy_sock() -> sk_stream_kill_queues() with outstanding
sk_wmem_alloc refs.

> Anyway, Linux-2.6.12-rc2 had no timestamps yet.

I see, thanks, if some form of the patch stands perhaps:

Fixes: cb9eff097831 ("net: new user space API for time stamping of incoming and outgoing packets")
