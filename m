Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94073327565
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 00:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbhB1Xx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 18:53:28 -0500
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:35363 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbhB1Xx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 18:53:27 -0500
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 8F39B891AF;
        Mon,  1 Mar 2021 12:52:44 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1614556364;
        bh=R1I1rdfCVOZ9Dwjkd8YsP7a/MROOQpBPBX4KkGaVHdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=d3vRFqIU8b4BXYqR4Vj1IUc0FcNgcD6NvthdQU5BXc3UHQJkYntryAEvmLf6kvXvM
         WhfR4o//zM0T7nLqw+HjeEKrbTpoPqT+c481c4PkyqN7koii0zJFc62wIj3Hz3Jr3L
         QzF6M/uDzhcQipG3rBtyyHZ6xxZGuAxbNY6rCYpNNtP843gHVEKT6Mkv2yZQsSWBu6
         anFdeg90PfXEYuFr4k3DBj7FC0xGZYhzPg+vjK80AiarFhtcUX6Dn5OFe8rTEi0LEN
         PtViU915wG/HTVeGRyrlMaHSsfcUq0o6242raT7/7cJJKhwYTnQILPRYLd6LnrHRLv
         orYGn7G1s2gVg==
Received: from smtp (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B603c2ccc0000>; Mon, 01 Mar 2021 12:52:44 +1300
Received: from henrys-dl.ws.atlnz.lc (henrys-dl.ws.atlnz.lc [10.33.23.26])
        by smtp (Postfix) with ESMTP id D453F13EF08;
        Mon,  1 Mar 2021 12:52:54 +1300 (NZDT)
Received: by henrys-dl.ws.atlnz.lc (Postfix, from userid 1052)
        id 6A4F74E19B6; Mon,  1 Mar 2021 12:52:44 +1300 (NZDT)
From:   Henry Shen <henry.shen@alliedtelesis.co.nz>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        chris.packham@alliedtelesis.co.nz,
        Henry Shen <henry.shen@alliedtelesis.co.nz>
Subject: [PATCH] net:ipv4: Packet is not forwarded when ingress interface is not configured with bc_forwarding
Date:   Mon,  1 Mar 2021 12:52:24 +1300
Message-Id: <20210228235224.30445-2-henry.shen@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210228235224.30445-1-henry.shen@alliedtelesis.co.nz>
References: <20210228235224.30445-1-henry.shen@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=C7uXNjH+ c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=dESyimp9J3IA:10 a=oz0IKz0CpFWYgAwaLeAA:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an IPv4 packet with a destination address of broadcast is received
on an ingress interface, it will not be forwarded out of the egress
interface if the ingress interface is not configured with bc_forwarding=20
but the egress interface is. If both the ingress and egress interfaces
are configured with bc_forwarding, the packet can be forwarded successful=
ly.

This patch is to be inline with Cisco's implementation that packet can be=
=20
forwarded if ingress interface is NOT configured with bc_forwarding,=20
but egress interface is.
---
 net/ipv4/route.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 02d81d79deeb..d082b199b8c6 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2101,6 +2101,8 @@ static int ip_route_input_slow(struct sk_buff *skb,=
 __be32 daddr, __be32 saddr,
 	struct rtable	*rth;
 	struct flowi4	fl4;
 	bool do_cache =3D true;
+	struct in_device *out_dev;
+	int		rcv_local =3D 0;
=20
 	/* IP on this device is disabled. */
=20
@@ -2176,12 +2178,20 @@ static int ip_route_input_slow(struct sk_buff *sk=
b, __be32 daddr, __be32 saddr,
 	}
=20
 	if (res->type =3D=3D RTN_BROADCAST) {
+		out_dev =3D in_dev_get(FIB_RES_DEV(*res));
+		if (!out_dev)
+			goto out;
+
+		if (in_dev =3D=3D out_dev)
+			rcv_local =3D 1;
+		in_dev_put(out_dev);
 		if (IN_DEV_BFORWARD(in_dev))
 			goto make_route;
 		/* not do cache if bc_forwarding is enabled */
 		if (IPV4_DEVCONF_ALL(net, BC_FORWARDING))
 			do_cache =3D false;
-		goto brd_input;
+		if (rcv_local)
+			goto brd_input;
 	}
=20
 	if (res->type =3D=3D RTN_LOCAL) {
@@ -2197,7 +2207,8 @@ static int ip_route_input_slow(struct sk_buff *skb,=
 __be32 daddr, __be32 saddr,
 		goto no_route;
 	}
 	if (res->type !=3D RTN_UNICAST)
-		goto martian_destination;
+		if (res->type !=3D RTN_BROADCAST)
+			goto martian_destination;
=20
 make_route:
 	err =3D ip_mkroute_input(skb, res, in_dev, daddr, saddr, tos, flkeys);
--=20
2.30.1

