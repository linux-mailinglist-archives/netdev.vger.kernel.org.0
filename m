Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E472604CB
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 20:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbgIGSk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 14:40:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728343AbgIGSk6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 14:40:58 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2705E2067C;
        Mon,  7 Sep 2020 18:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599504057;
        bh=N9H0myqp/soa1vEOvfkx5sjWDeZabTKFYKovdFuQ+Rs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LUt0kaLdEsnqQuvG5rHGDKZG2ncFqCf7eTs+Od5gXQGHXa8xFEdYU+0zSC6aWZQHB
         IbMFZ4cc8aKyEYww7sNLSwe4/Pj8aE7ydzZazK/7wusr/d8SZXT1wRgI00IlxDnFev
         Z6eMpGU0wj4UF9HzEjon0juhH8fqHgS3Ug+qKlyY=
Date:   Mon, 7 Sep 2020 11:40:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBl?= =?UTF-8?B?bA==?= 
        <bjorn.topel@gmail.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, magnus.karlsson@intel.com,
        davem@davemloft.net, john.fastabend@gmail.com,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next 0/6] xsk: exit NAPI loop when AF_XDP Rx ring is
 full
Message-ID: <20200907114055.27c95483@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1d2e781e-b26d-4cf0-0178-25b8835dbe26@intel.com>
References: <20200904135332.60259-1-bjorn.topel@gmail.com>
        <20200904162751.632c4443@carbon>
        <27e05518-99c6-15e2-b801-cbc0310630ef@intel.com>
        <20200904165837.16d8ecfd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1d2e781e-b26d-4cf0-0178-25b8835dbe26@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Sep 2020 15:37:40 +0200 Bj=C3=B6rn T=C3=B6pel wrote:
>  > I've been pondering the exact problem you're solving with Maciej
>  > recently. The efficiency of AF_XDP on one core with the NAPI processin=
g.
>  >
>  > Your solution (even though it admittedly helps, and is quite simple)
>  > still has the application potentially not able to process packets
>  > until the queue fills up. This will be bad for latency.
>  >
>  > Why don't we move closer to application polling? Never re-arm the NAPI
>  > after RX, let the application ask for packets, re-arm if 0 polled.
>  > You'd get max batching, min latency.
>  >
>  > Who's the rambling one now? :-D
>  > =20
>=20
> :-D No, these are all very good ideas! We've actually experimented
> with it with the busy-poll series a while back -- NAPI busy-polling
> does exactly "application polling".
>=20
> However, I wonder if the busy-polling would have better performance
> than the scenario above (i.e. when the ksoftirqd never kicks in)?
> Executing the NAPI poll *explicitly* in the syscall, or implicitly
> from the softirq.
>=20
> Hmm, thinking out loud here. A simple(r) patch enabling busy poll;
> Exporting the napi_id to the AF_XDP socket (xdp->rxq->napi_id to
> sk->sk_napi_id), and do the sk_busy_poll_loop() in sendmsg.
>=20
> Or did you have something completely different in mind?

My understanding is that busy-polling is allowing application to pick
up packets from the ring before the IRQ fires.

What we're more concerned about is the IRQ firing in the first place.

 application:   busy    | needs packets | idle
 -----------------------+---------------+----------------------
   standard   |         |   polls NAPI  | keep polling? sleep?
   busy poll  | IRQ on  |    IRQ off    |  IRQ off      IRQ on
 -------------+---------+---------------+----------------------
              |         |   polls once  |
    AF_XDP    | IRQ off |    IRQ off    |  IRQ on


So busy polling is pretty orthogonal. It only applies to the
"application needs packets" time. What we'd need is for the application
to be able to suppress NAPI polls, promising the kernel that it will
busy poll when appropriate.

> As for this patch set, I think it would make sense to pull it in since
> it makes the single-core scenario *much* better, and it is pretty
> simple. Then do the application polling as another, potentially,
> improvement series.

Up to you, it's extra code in the driver so mostly your code to
maintain.

I think that if we implement what I described above - everyone will
use that on a single core setup, so this set would be dead code
(assuming RQ is sized appropriately). But again, your call :)
