Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80777329303
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 21:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234883AbhCAU47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 15:56:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:57298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243950AbhCAUxr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 15:53:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D08EC64DDF;
        Mon,  1 Mar 2021 20:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614629874;
        bh=dVXnXZWWWaD5FsOrA1WmWQKSOINB4WZNQclu0ClkGlQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lGIv/CH/fYaoAjabek75Bs+57zDsGCHJpzW4tmG39uQ44yA8/2yqtDyyOG85B8EHR
         5UKuCzaYHeYYEUFEEwRCeGFh7ywwpu6MW98Y1sToNZGuUqZOaBMJPKS5unRulMreTb
         dtSH/qBU03VDQ0NpHDs88l1rPSGM8bdKPWs0tJdjGplN+cuVWyswalFxzVNlOV77EB
         WYR5XSyo+/Cpc/129WRO8Xv0kzoG050vxv9MGRF75qoglL4CvDsfzR5H9krmb8ossu
         nt953wqQrHtDszWTkHYQf9WB+zELn4xPg4pjioLz+s+C9vongq4Z37zq9nJKix+2B8
         BrAvpeY7Gffmw==
Date:   Mon, 1 Mar 2021 12:17:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Markus =?UTF-8?B?QmzDtmNobA==?= <Markus.Bloechl@ipetronik.com>,
        Michael Walle <michael@walle.cc>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net 5/6] net: enetc: don't disable VLAN filtering in
 IFF_PROMISC mode
Message-ID: <20210301121752.0b836afa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210301170251.wz524j2pv4ahytwo@skbuf>
References: <20210225121835.3864036-6-olteanv@gmail.com>
        <20210226152836.31a0b1bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210226234244.w7xw7qnpo3skdseb@skbuf>
        <20210226154922.5956512b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210227001651.geuv4pt2bxkzuz5d@skbuf>
        <7bb61f7190bebadb9b6281cb02fa103d@walle.cc>
        <20210228224804.2zpenxrkh5vv45ph@skbuf>
        <bfb5a084bfb17f9fdd0ea05ba519441b@walle.cc>
        <20210301150852.ejyouycigwu6o5ht@skbuf>
        <20210301162653.xwfi7qoxdegi66x5@ipetronik.com>
        <20210301170251.wz524j2pv4ahytwo@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Mar 2021 19:02:51 +0200 Vladimir Oltean wrote:
> On Mon, Mar 01, 2021 at 05:26:53PM +0100, Markus Bl=C3=B6chl wrote:
> > The main problem here could also just be that almost everybody _thinks_
> > that promiscuity means receiving all frames and no one is aware of the
> > standards definition.
> > In fact, I can't blame them, as the standard is hard to come by and not
> > enjoyable to read, imho. And all secondary documentation I could find
> > on the internet explain promiscuous mode as a "mode of operation" in wh=
ich
> > "the card accepts every Ethernet packet sent on the network" or similar.
> > Even libpcap, which I consider the reference on network sniffing, thinks
> > that "Promiscuous mode [...] sniffs all traffic on the wire."
> >=20
> > Thus I still think that this issue is also fixable by proper
> > documentation of promiscuity.
> > At least the meaning and guarantees of IFF_PROMISC in this kernel should
> > be clearly defined - in one way or the other - such that users with
> > different expectations can be directed there and drivers with different
> > behavior can be fixed with that definition as justification. =20
>=20
> If Jakub and/or David give us the ACK, I will go ahead and update the
> documentation (probably Documentation/networking/netdevices.rst) to
> mention what does IFF_PROMISC cover, _separate_ from this series.

How do we do this in practical terms?

It'd definitely be very useful to write up the discussions but we=20
can't expect that all existing drivers get converted, and incorrect
documentation is worse than none at all.

IIRC Ido also pointed out that the bridge driver follows the "promisc
includes VLAN", so SW drivers would need to be updated as well.

I personally agree with the interpretation that PROMISC =3D=3D disable DA
filter, but we can't reasonably expect all drivers to follow it.
All I can think of is documenting that the driver _may_ not disable
VLAN filter, and that's our recommendation for new drivers, therefore
users who want "vlan promisc" _must_ disable rx-vlan but the inverse is
not guaranteed (rx-vlan on + PROMISC =3D=3D only frames for known VLANs).

What's your thinking?
