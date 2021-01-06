Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9A52EBD5E
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 12:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbhAFL5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 06:57:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:55310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726212AbhAFL5S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 06:57:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A840823117;
        Wed,  6 Jan 2021 11:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609934197;
        bh=rFfL+XSU9J75HjhfdCxVnZNvEcVjNZtY5TneG90oZ+U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bglL2FQ7SsqwoukEQpNtRrJcf/wARTvsRoD5THNW27ziqNMTqaSkKRiXYkO4JVdLq
         4SDTh3QQNd7AThVfyPwxfO5KcuNrM4JQcxjVgLMHvEVP59PjQ4zmB7bYJeBvo3BN+m
         Yd8vARFNxinENTXEHg261BS1cKgT7nv/xPAKI31sdBAVdjGOCGmcqG6QpvQ/4HQo2l
         UMqOte1ZErXlbex5ceRf1ndSq/PuKTgf/0KhTa/DXtXw7gRGPgqJH67QiimmoLxm1Q
         rv3oALfegfHDqB/xpMeMN7lARkSE72bNK9bzqLVeprQUJ39jNmdO5AtAodLLhErGHc
         HwEVx8vGU7OUQ==
Date:   Wed, 6 Jan 2021 12:56:08 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Sven Auhagen <sven.auhagen@voleatech.de>, netdev@vger.kernel.org,
        davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Matteo Croce <mcroce@microsoft.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH net-next] net: mvpp2: increase MTU limit when XDP
 enabled
Message-ID: <20210106125608.5f6fab6f@kernel.org>
In-Reply-To: <X/TKNlir5Cyimjn3@lunn.ch>
References: <20210105171921.8022-1-kabel@kernel.org>
        <20210105172437.5bd2wypkfw775a4v@svensmacbookair.sven.lan>
        <20210105184308.1d2b7253@kernel.org>
        <X/TKNlir5Cyimjn3@lunn.ch>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Jan 2021 21:21:10 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> On Tue, Jan 05, 2021 at 06:43:08PM +0100, Marek Beh=C3=BAn wrote:
> > On Tue, 5 Jan 2021 18:24:37 +0100
> > Sven Auhagen <sven.auhagen@voleatech.de> wrote:
> >  =20
> > > On Tue, Jan 05, 2021 at 06:19:21PM +0100, Marek Beh=C3=BAn wrote: =20
> > > > Currently mvpp2_xdp_setup won't allow attaching XDP program if
> > > >   mtu > ETH_DATA_LEN (1500).
> > > >=20
> > > > The mvpp2_change_mtu on the other hand checks whether
> > > >   MVPP2_RX_PKT_SIZE(mtu) > MVPP2_BM_LONG_PKT_SIZE.
> > > >=20
> > > > These two checks are semantically different.
> > > >=20
> > > > Moreover this limit can be increased to MVPP2_MAX_RX_BUF_SIZE, sinc=
e in
> > > > mvpp2_rx we have
> > > >   xdp.data =3D data + MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM;
> > > >   xdp.frame_sz =3D PAGE_SIZE;
> > > >=20
> > > > Change the checks to check whether
> > > >   mtu > MVPP2_MAX_RX_BUF_SIZE   =20
> > >=20
> > > Hello Marek,
> > >=20
> > > in general, XDP is based on the model, that packets are not bigger th=
an 1500.
> > > I am not sure if that has changed, I don't believe Jumbo Frames are u=
pstreamed yet.
> > > You are correct that the MVPP2 driver can handle bigger packets witho=
ut a problem but
> > > if you do XDP redirect that won't work with other drivers and your pa=
ckets will disappear. =20
> >=20
> > At least 1508 is required when I want to use XDP with a Marvell DSA
> > switch: the DSA header is 4 or 8 bytes long there.
> >=20
> > The DSA driver increases MTU on CPU switch interface by this length
> > (on my switches to 1504).
> >=20
> > So without this I cannot use XDP with mvpp2 with a Marvell switch with
> > default settings, which I think is not OK. =20
>=20
> Hi Marek
>=20
> You are running XDP programs on the master interface? So you still
> have the DSA tag? What sort of programs are you running? I guess DOS
> protection could work, once the program understands the DSA tag. To
> forward the frame out another interface you would have to remove the
> tag. Or i suppose you could modify the tag and send it back to the
> switch? Does XDP support that sort of hairpin operation?
>=20
> 	Andrew

Andrew,

I am using bpf_fib_lookup to route the packets between switch
interfaces.
Here's the program for Marvell CN9130 CRB
https://blackhole.sk/~kabel/src/xdp_mvswitch_route.c
(This is just to experiment with XDP, so please excuse code quality.)

I found out that on Turris MOX I am able to route 2.5gbps (at MTU 1500)
with XDP. But when not using XDP, when the packets go via kernel's
stack, MOX is able to route less than 1gbps (cca 800mbps, at MTU
1500, and the CPU is at 100%).

I also to write a simple NAT masquerading program. I think XDP can
increase NAT throughput to 2.5gbps as well.

> Or i suppose you could modify the tag and send it back to the
> switch? Does XDP support that sort of hairpin operation?

You can modify the packet, prepend it with another headers (up to 256
bytes in some drivers, in mvpp2 only 224), append trailers... Look at
my program above, I am popping vlan tag, for example.

Marek
