Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF5F40B574
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 18:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbhINQ5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 12:57:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230458AbhINQ5k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 12:57:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74BD5610CE;
        Tue, 14 Sep 2021 16:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631638582;
        bh=tzD7m8aLR61v3LuS9ow5WZqrwhz6BFGLtYre4/WV5pQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ip7kbtEHLuNio2ylRy8LYnmSHcUtYu1AUoS1K6J5hzrojee+JTZ07m2DaU7U1Z8TU
         nITLG29Fxtjok8u3HlBavSQeNIvgxYiRYJb2rcV5Z6J0h1cX2Mq4pfw7hwR3POb5hA
         cukAH9ZwCvMvT6wYBuGxsaTNNuZa6v3Zjoozn1njUK57M3kq+Z/ZtSe5CeW1AGdLpu
         VWfKA+qPyQD87F/LFeO0iUcqYBL4PYTcDizGcXtQz7s7csK6MhdPPczZwk6zy+sDCg
         IPLCusTNw/FjGOOrlIqvSozTrjLSIN5s1bjIdyWwBpJYoH8DvcDQS6jayWAMLbwFWj
         cd7He2OfU/hlg==
Date:   Tue, 14 Sep 2021 09:56:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     willemb@google.com, netdev@vger.kernel.org
Subject: Re: [RFC net] net: stream: don't purge sk_error_queue without
 holding its lock
Message-ID: <20210914095621.5fa08637@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c945d4ee-591c-7c38-8322-3fb9db0f104f@gmail.com>
References: <20210913223850.660578-1-kuba@kernel.org>
        <3b5549a2-cb0e-0dc1-3cb3-00d15a74873b@gmail.com>
        <20210914071836.46813650@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c945d4ee-591c-7c38-8322-3fb9db0f104f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Sep 2021 09:32:09 -0700 Eric Dumazet wrote:
> On 9/14/21 7:18 AM, Jakub Kicinski wrote:
> > On Mon, 13 Sep 2021 22:14:00 -0700 Eric Dumazet wrote:  

> >> This should not be needed.
> >>
> >> By definition, sk_stream_kill_queues() is only called when there is no
> >> more references on the sockets.
> >>
> >> So all outstanding packets must have been orphaned or freed.  
> > 
> > I don't see the wait anywhere, would you mind spelling it out?
> > My (likely flawed) understanding is that inet_sock_destruct() gets
> > called when refs are gone (via sk->sk_destruct).  
> >
> > But tcp_disconnect() + tcp_close() seem to happily call
> > inet_csk_destroy_sock() -> sk_stream_kill_queues() with outstanding
> > sk_wmem_alloc refs.  
> 
> tcp_disconnect() should probably leave the error queue as is.
> 
> For some reason I thought your report was about inet_sock_destruct()
> 
> tcp_disconnect() has always been full of bugs, it is surprising real applications
> (not fuzzers) are still trying to use it.

I think I hit it because app sets SOCK_LINGER && !sk->sk_lingertime.
I don't think the app disconnects explicitly, but "same difference".

> >> Anyway, Linux-2.6.12-rc2 had no timestamps yet.  
> > 
> > I see, thanks, if some form of the patch stands perhaps:
> > 
> > Fixes: cb9eff097831 ("net: new user space API for time stamping of incoming and outgoing packets")
> >   
> 
> Except that this patch wont prevent a packet being added to sk_error_queue
> right after skb_queue_purge(&sk->sk_error_queue).

Right, but then inet_sock_destruct() also purges the err queue, again.
I was afraid of regressions but we could just remove the purging 
from sk_stream_kill_queues(), and target net-next?

> If you think there is a bug, it must be fixed in another way.
> 
> IMO, preventing err packets from a prior session being queued after a tcp_disconnect()
> is rather hard. We should not even try (packets could be stuck for hours in a qdisc)

Indeed, we could rearrange the SOCK_DEAD check in sock_queue_err_skb()
to skip queuing and put it under the err queue lock (provided we make
sk_stream_kill_queues() take that lock as well). But seems like an
overkill. I'd lean towards the existing patch or removing the purge from
sk_stream_kill_queues(). LMK what you prefer, this is not urgent.
