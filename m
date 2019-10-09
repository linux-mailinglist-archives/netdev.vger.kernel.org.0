Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFFACD0BF1
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 11:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbfJIJ4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 05:56:41 -0400
Received: from mail.online.net ([62.210.16.11]:42218 "EHLO mail.online.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729471AbfJIJ4k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 05:56:40 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.online.net (Postfix) with ESMTP id 2C8B2F2B8CBE;
        Wed,  9 Oct 2019 11:56:39 +0200 (CEST)
Received: from mail.online.net ([127.0.0.1])
        by localhost (mail.online.net [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id iqWFfD610U0C; Wed,  9 Oct 2019 11:56:39 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mail.online.net (Postfix) with ESMTP id 0ADFEF2B8CCB;
        Wed,  9 Oct 2019 11:56:39 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.online.net 0ADFEF2B8CCB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=online.net;
        s=4EC61654-9574-11E8-870F-3D38CA7095BF; t=1570614999;
        bh=ktGOlct2yhztgrleZeTwRptSrpAFR7kmEskFGJBufHc=;
        h=Mime-Version:From:Date:Message-Id:To;
        b=Fg/U2fUKlDMy//JrIypshelmLkKAwNfW6Yrw255aXnDlcW/qQyplX6ULobNgUKNv3
         sKP30C+IRwGpY5J9SLzob6tQASYikEWGVU3nbscsJXIr5Gx8xqW12RVh/qnH4bycbv
         7bcPtFjZVWVyfNSs6uod7yVLL35Au94qVza3RBOCWbE4/+0FGRbGpZQH5Rd5K4Sjhr
         218ynK5xMoKMme4wqq88co7Pfg1oZn+cEzSDPygq3BMkWVHRiJOlX5055BqC6RY2zO
         AO3sLvNWMwkvt1l07h24/XXuJxXkHcz5BGMSvZee0Np5CxpeY1WnoIihasdys2Q9A9
         ALv8jFTToeFNQ==
X-Virus-Scanned: amavisd-new at mail.online.net
Received: from mail.online.net ([127.0.0.1])
        by localhost (mail.online.net [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id i4pjMdiA-ND3; Wed,  9 Oct 2019 11:56:38 +0200 (CEST)
Received: from [10.33.104.30] (unknown [195.154.229.35])
        by mail.online.net (Postfix) with ESMTPSA id E6970F2B8CBE;
        Wed,  9 Oct 2019 11:56:38 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.0 \(3445.100.39\))
Subject: Re: ip doesn't handle vxlan id and group correctly
From:   Alexis Bauvin <abauvin@online.net>
In-Reply-To: <6761460a-6cd7-ec86-da72-db1efb4a0dd9@vshosting.cz>
Date:   Wed, 9 Oct 2019 11:56:38 +0200
Cc:     netdev@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BD89B7A5-AEA1-4DBD-BF4E-7330558162EF@online.net>
References: <6761460a-6cd7-ec86-da72-db1efb4a0dd9@vshosting.cz>
To:     =?utf-8?B?T25kxZllaiBGbMOtZHI=?= <flidr@vshosting.cz>
X-Mailer: Apple Mail (2.3445.100.39)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

That=E2=80=99s because the vxlan driver only relies on the vni to =
discriminate
packets beween vxlan interface.
If you need several vxlan interfaces with the same vni, your best bet
currently is to place them in separate network namespaces, e.g.

ip netns add group-10
ip netns add group-20

echo "vxlan 101 - group 10, id 101"
ip -netns group-10 link add vxlan101 type vxlan id 101 group 239.0.3.10 =
dstport 8472 port 32768 61000
echo "vxlan 102 - group 10, id 102"
ip -netns group-10 link add vxlan102 type vxlan id 102 group 239.0.3.10 =
dstport 8472 port 32768 61000
echo "vxlan 201 - group 20, id 101"
ip -netns group-20 link add vxlan201 type vxlan id 101 group 239.0.3.20 =
dstport 8472 port 32768 61000

Note however this requires more setup with veths to forward the proper
traffic between netns: at least one for the underlay bridged to bond0
and possibly another one for the overlay, if your application cannot run
in a netns / requires access to all vnis.

Alexis Bauvin

(re-send for netdev as somehow the first one contained html)

> Le 7 oct. 2019 =C3=A0 13:39, Ond=C5=99ej Fl=C3=ADdr =
<flidr@vshosting.cz> a =C3=A9crit :
>=20
> Hello,
>=20
> it seems that ip doesn't handle combination of vxlan id and group
> correctly. As you can see in attached script, I'm trying to create
> multiple vxlans all with different combination of group and vxlan id. =
I
> can create vxlans with different ids in same group, different ids in
> different groups but I cannot create vxlan with same id in different
> group, creation ends with "Error: A VXLAN device with the specified =
VNI
> already exists.". Tested on current version 5.3.0 on arch linux.
>=20
> Best regards,
>=20
> Ondrej Flidr
>=20
>=20
> <vxlantest.sh>

