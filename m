Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19F935F10F
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 11:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346406AbhDNJub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 05:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbhDNJua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 05:50:30 -0400
Received: from mail.wizdom.nu (unknown [IPv6:2a02:58:5a:b401::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4FFC061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 02:50:09 -0700 (PDT)
Received: from mail.wizdom.nu (localhost.localdomain [127.0.0.1])
        by mail.wizdom.nu (Proxmox) with ESMTP id 6087841031
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 11:50:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wizdom.nu; h=cc
        :content-transfer-encoding:content-type:content-type:date:from
        :from:in-reply-to:message-id:mime-version:references:reply-to
        :subject:subject:to:to; s=mail; bh=OSU4fCAh6r/JUTjUhnhkGlbJ1idtR
        pg48LY05jKOuew=; b=NGmI9oQQc5w1H+ix576HAzPXb8dpZ/ssm9svx6pGLIAvo
        thqUwSBRG2I8uqksQv/X18AvmSW9oln5xhLX4BBkdzLORO8jMjDpGz5HYJ7dXvZL
        lRVk1gvGeWJDfGE3r/TnDMXK4sqXqCGsqHC9Wj8R7+DvwDUtFeHSphTWCjl5pvgT
        CxdZ/8tXYhGIwIJFVGe+MPia3tbSQnAb0j5OraCJkP3J7nKplNwhT38AfZsz0ZjF
        19oKUS7hp/wMNqEqkSyoQ/Bs4YNnULtgIBmDjbkF8hbuMtAp5Bt0phOmK4J0VXAI
        y67kZElnl5HHoCnAWB867LnKp39ba8TbbBEU2mn6A==
Received: from rdxfp01.wizdom.nu (RDXFP01.wizdom.nu [IPv6:2a02:58:5a:b410:9599:5020:d017:f71a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.wizdom.nu (Proxmox) with ESMTPS id 9E8114031E
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 11:50:03 +0200 (CEST)
Received: from RDXFP01.wizdom.nu (2a02:58:5a:b410:9599:5020:d017:f71a) by
 RDXFP01.wizdom.nu (2a02:58:5a:b410:9599:5020:d017:f71a) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.721.2; Wed, 14 Apr 2021 11:50:03 +0200
Received: from RDXFP01.wizdom.nu ([fe80::9599:5020:d017:f71a]) by
 RDXFP01.wizdom.nu ([fe80::9599:5020:d017:f71a%7]) with mapi id
 15.02.0721.013; Wed, 14 Apr 2021 11:50:03 +0200
From:   Sietse van Zanen <sietse@wizdom.nu>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: FW: IGMP messages leading to MRT_NOCACHE upcalls
Thread-Topic: IGMP messages leading to MRT_NOCACHE upcalls
Thread-Index: AdcxD4v1PSmnrt2rTvqyheRnEqKPMAAA7LbA
Date:   Wed, 14 Apr 2021 09:50:03 +0000
Message-ID: <15f4f9a9d98540819ac6976daaa8ae48@wizdom.nu>
References: <9f410455349143a78f2cfc38d7d0f39c@wizdom.nu>
In-Reply-To: <9f410455349143a78f2cfc38d7d0f39c@wizdom.nu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2a02:58:5a:b411:20c0:d22:e419:dad3]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

IGMP packets are eligible to be forwarded by the kernel, leading to MRT_NOC=
ACHE upcalls to userspace. I decided to check into this, because there was =
a notable difference in multicast mrt between FreeBSD (which "arguably" has=
 the better network stack) and Linux using the exact same user space daemon=
 on the exact same network.

I decided to quickly patch ipmr.c to log what is eligible to be forwarded (=
in ip_mr_input()):
=A0=A0 if (ip_hdr(skb)->ttl <=3D 1 || (ntohl(ip_hdr(skb)->daddr) & IGMP_LOC=
AL_GROUP_MASK)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 =3D=3D IGMP_LOCAL_GROUP) {
=A0=A0=A0=A0=A0=A0=A0 pr_err("ipmr: packet from 0x%x with ttl %u to 0x%x pr=
oto %d\n", ntohl(ip_hdr(skb)->saddr), ip_hdr(skb)->ttl, ntohl(ip_hdr(skb)->=
daddr), ip_hdr(skb)->protocol);
=A0=A0=A0 }

And surely:
[ 4621.488211] ipmr: packet from 0xc0a80190 with ttl 1 to 0xeffffffa proto =
17
[ 4621.514365] ipmr: packet from 0xa001464 with ttl 1 to 0xeffffffa proto 1=
7
[ 4621.692470] ipmr: packet from 0xc0a80190 with ttl 1 to 0xeffffffa proto =
17
[ 4621.767651] ipmr: packet from 0xc0a80190 with ttl 1 to 0xeffffffa proto =
17
[ 4625.497651] ipmr: packet from 0xc0a8018f with ttl 1 to 0xeffffffa proto =
2
[ 4626.021713] ipmr: packet from 0xc0a8018f with ttl 1 to 0xe1004701 proto =
2
[ 4650.288509] ipmr: packet from 0xa001401 with ttl 1 to 0xe1004701 proto 2
[ 4651.288419] ipmr: packet from 0xa001401 with ttl 1 to 0xe1004701 proto 2

Looking at the FreeBSD source code (from sys/netinet/ip_mroute.c X_ip_mforw=
ard()), here these packets are rightly and correctly discarded even before =
an mrt cache lookup is made.
/*
=A0=A0 * Don't forward a packet with time-to-live of zero or one,
=A0=A0=A0=A0 * or a packet destined to a local-only group.
=A0=A0=A0=A0 */
=A0=A0=A0 if (ip->ip_ttl <=3D 1 || IN_LOCAL_GROUP(ntohl(ip->ip_dst.s_addr))=
) {
=A0=A0=A0=A0=A0=A0 MFC_UNLOCK();
=A0=A0=A0=A0=A0=A0 VIF_UNLOCK();
=A0=A0=A0=A0=A0=A0 return 0;

The following comment in ipmr.c also makes absolutely no sense to me:
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* IGMPv1 (and broken IGMPv2 implementati=
ons sort of
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Cisco IOS <=3D 11.2(8)) do not put r=
outer alert
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * option to IGMP packets destined to r=
outable
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0* groups. It is very bad, because it me=
ans
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * that we can forward NO IGMP messages=
.

IGMP messages, as per rfc1112, rfc2236 and rfc3376 are sent with ttl of 1 a=
nd hence must not be forwarded. IGMP pertains to the local network only, an=
d will be seriously broken if routed. Also multicast forwarding rules clear=
ly specify that packets should only be forwarded if their ttl is greater th=
an the interface threshold, which is impossible for packets with ttl of 1.=
=20
Network trace shows that these packets are not actually forwarded, only mar=
ked as eligible in ip_mr_input().

The following questions therefor deserve an answer:
1. Why are packets with a ttl of 1 eligible to be forwarded and not immedia=
tely discarded?
2. Why are IGMP packets eligible to be forwarded?
3. Why are IGMP packets resulting in MRT_NOCACHE upcalls at all?=20
Userspace daemon is already receiving the IGMP packets themselves and has n=
o way for discerning the resulting upcalls leading to routes being incorrec=
tly added.
4. Would it not be better (or would it break stuff) if these packets will b=
e discarded on earliest convenience in ip_mr_input(), as FreeBSD does:
if (ip_hdr(skb)->ttl <=3D 1 || (ntohl(ip_hdr(skb)->daddr) & IGMP_LOCAL_GROU=
P_MASK)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 =3D=3D IGMP_LOCAL_GROUP) {
       goto don't_forward;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }


