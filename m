Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C946504E1
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 22:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbiLRV5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 16:57:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiLRV5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 16:57:30 -0500
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51D1CE33
        for <netdev@vger.kernel.org>; Sun, 18 Dec 2022 13:57:28 -0800 (PST)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id CBAD22C04D0;
        Mon, 19 Dec 2022 10:57:23 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1671400643;
        bh=MM+uE5Zc3dz1eyoEKPaZ4JK4dExyhoj2OoMElRXlEpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2xYbdLQLi/AHbPJKijyVPKvSFAFe9MR0bJXtU6dt29c4iWXNnKGRmWiKvSbbCzXAa
         gppJexYDE7LofQzMvz0eq46/ufYqHgWOIUM7tTW6uOKwLYdaDJbQN3EtwofGptBenT
         zbAh6bJmgpCCFaxvbm3hDxIjRtkDVztLRno2VG53K59WGb+hgrIDytCGh7xDToKn+T
         EGm2XQORyKS9ox+JqsPY6hx9atuvM83OVD6QBXQ8/UDZh1cgiy7LB0GLy0CfRT7mTP
         Dkl/tw2TRcMgC3GNqykQ8/xF8VC6Bt5wiesfdVb4EDvNe9762OImvNzj8EG7FfpluL
         NxChfsBw0YC/A==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B639f8cc30002>; Mon, 19 Dec 2022 10:57:23 +1300
Received: from thomaswi-dl.ws.atlnz.lc (thomaswi-dl.ws.atlnz.lc [10.33.25.46])
        by pat.atlnz.lc (Postfix) with ESMTP id 7A27B13EE82;
        Mon, 19 Dec 2022 10:57:23 +1300 (NZDT)
Received: by thomaswi-dl.ws.atlnz.lc (Postfix, from userid 1719)
        id 766B93E5133; Mon, 19 Dec 2022 10:57:23 +1300 (NZDT)
From:   Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, a@unstable.cc, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
Subject: [PATCH 2/2] ip/ip6_gre: Fix non-point-to-point tunnel not generating IPv6 link local address
Date:   Mon, 19 Dec 2022 10:57:18 +1300
Message-Id: <20221218215718.1491444-3-Thomas.Winter@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221218215718.1491444-1-Thomas.Winter@alliedtelesis.co.nz>
References: <20221218215718.1491444-1-Thomas.Winter@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=X/cs11be c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=sHyYjHe8cH0A:10 a=Bk4KLNytfi6p_AlvEHIA:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously, addrconf_gre_config always would call addrconf_addr_gen
and generate a EUI64 link local address for the tunnel.
Then commit e5dd729460ca changed the code path so that add_v4_addrs
is called but this only generates a compat IPv6 address for
non-point-to-point tunnels.

I assume the compat address is specifically for SIT tunnels so
have kept that only for SIT - GRE tunnels now always generate link
local addresses.

Fixes: e5dd729460ca ("ip/ip6_gre: use the same logic as SIT interfaces wh=
en computing v6LL address")
Signed-off-by: Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
---
 net/ipv6/addrconf.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 9c0d085fb9af..12126601093d 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3129,17 +3129,17 @@ static void add_v4_addrs(struct inet6_dev *idev)
 		offset =3D sizeof(struct in6_addr) - 4;
 	memcpy(&addr.s6_addr32[3], idev->dev->dev_addr + offset, 4);
=20
-	if (idev->dev->flags&IFF_POINTOPOINT) {
+	if (!(idev->dev->flags & IFF_POINTOPOINT) && idev->dev->type =3D=3D ARP=
HRD_SIT) {
+		scope =3D IPV6_ADDR_COMPATv4;
+		plen =3D 96;
+		pflags |=3D RTF_NONEXTHOP;
+	} else {
 		if (idev->cnf.addr_gen_mode =3D=3D IN6_ADDR_GEN_MODE_NONE)
 			return;
=20
 		addr.s6_addr32[0] =3D htonl(0xfe800000);
 		scope =3D IFA_LINK;
 		plen =3D 64;
-	} else {
-		scope =3D IPV6_ADDR_COMPATv4;
-		plen =3D 96;
-		pflags |=3D RTF_NONEXTHOP;
 	}
=20
 	if (addr.s6_addr32[3]) {
--=20
2.37.3

