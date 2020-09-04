Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4112725E46D
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 01:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgIDX6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 19:58:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726277AbgIDX6j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 19:58:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD6E3206CB;
        Fri,  4 Sep 2020 23:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599263919;
        bh=XtGzJW4VFXok9FC1vkT42Cwb4ib3m7FQWch4BrbhHT0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yZWxdRYeR3vwcHTj/rE42tWZGXJKfNFCfIv7XzRAL7QCl3lliRU/7i7RJNd672ort
         Z4tpPBjXFVF2bOI8w2OJz3PeakkQoD5aHAC24dZAvoLnSKahL7Dq5UKQR55hHK0GNb
         v7v4Fk/RpE3BEMcpk8LHqde9lz8IFGXhyX/TXCqE=
Date:   Fri, 4 Sep 2020 16:58:37 -0700
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
Message-ID: <20200904165837.16d8ecfd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <27e05518-99c6-15e2-b801-cbc0310630ef@intel.com>
References: <20200904135332.60259-1-bjorn.topel@gmail.com>
        <20200904162751.632c4443@carbon>
        <27e05518-99c6-15e2-b801-cbc0310630ef@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Sep 2020 16:32:56 +0200 Bj=C3=B6rn T=C3=B6pel wrote:
> On 2020-09-04 16:27, Jesper Dangaard Brouer wrote:
> > On Fri,  4 Sep 2020 15:53:25 +0200
> > Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:
> >  =20
> >> On my machine the "one core scenario Rx drop" performance went from
> >> ~65Kpps to 21Mpps. In other words, from "not usable" to
> >> "usable". YMMV. =20
> >=20
> > We have observed this kind of dropping off an edge before with softirq
> > (when userspace process runs on same RX-CPU), but I thought that Eric
> > Dumazet solved it in 4cd13c21b207 ("softirq: Let ksoftirqd do its job").
> >=20
> > I wonder what makes AF_XDP different or if the problem have come back?
> >  =20
>=20
> I would say this is not the same issue. The problem is that the softirq=20
> is busy dropping packets since the AF_XDP Rx is full. So, the cycles=20
> *are* split 50/50, which is not what we want in this case. :-)
>=20
> This issue is more of a "Intel AF_XDP ZC drivers does stupid work", than=
=20
> fairness. If the Rx ring is full, then there is really no use to let the=
=20
> NAPI loop continue.
>=20
> Would you agree, or am I rambling? :-P

I wonder if ksoftirqd never kicks in because we are able to discard=20
the entire ring before we run out of softirq "slice".


I've been pondering the exact problem you're solving with Maciej
recently. The efficiency of AF_XDP on one core with the NAPI processing.

Your solution (even though it admittedly helps, and is quite simple)
still has the application potentially not able to process packets=20
until the queue fills up. This will be bad for latency.

Why don't we move closer to application polling? Never re-arm the NAPI=20
after RX, let the application ask for packets, re-arm if 0 polled.=20
You'd get max batching, min latency.

Who's the rambling one now? :-D
