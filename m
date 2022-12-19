Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71AE4650603
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 02:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbiLSBGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 20:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiLSBGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 20:06:30 -0500
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88D825E2
        for <netdev@vger.kernel.org>; Sun, 18 Dec 2022 17:06:26 -0800 (PST)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id B22442C04E6;
        Mon, 19 Dec 2022 14:06:23 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1671411983;
        bh=SmxTgPqi/CiMEf055mHB+0SxdnvM1wex2CECQqt0cy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RwgKlV3dVwE2/tn/8zvjHH8KEgZ3cInmlByVG9a1PyGLUjetXNtQMy5cam4dGsGWV
         zYXUTZDarH4jPXF4iIfhX8Nfr0u12Q25FELZV0IwfZpMdCEZRj6a5WF5v+VoGzq/3H
         stvzTJjekwgf8V4a6UvMNDXUNCFhorJJpN+nmx/2uJR+u1AQ0ZC5V9RIQ8p/+EM33Q
         ln47f/3j51wDTlFDxtTZNDuV9YULZqNDQhIlZ4LXDfS5cd27gZt5BHBMBp2269cOS7
         6wsvcMqfEjcF+ZXj4xhHY5e5cgSQP4qfW68II/Wm4uOoSigkwL3/NiAuBnA5iwkdcX
         zLd9foDqVmGIA==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B639fb90f0002>; Mon, 19 Dec 2022 14:06:23 +1300
Received: from thomaswi-dl.ws.atlnz.lc (thomaswi-dl.ws.atlnz.lc [10.33.25.46])
        by pat.atlnz.lc (Postfix) with ESMTP id 6AD6B13EE82;
        Mon, 19 Dec 2022 14:06:23 +1300 (NZDT)
Received: by thomaswi-dl.ws.atlnz.lc (Postfix, from userid 1719)
        id 6ACC73E5133; Mon, 19 Dec 2022 14:06:23 +1300 (NZDT)
From:   Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, a@unstable.cc, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
Subject: [PATCH 2/2] ip/ip6_gre: Fix non-point-to-point tunnel not generating IPv6 link local address
Date:   Mon, 19 Dec 2022 14:06:19 +1300
Message-Id: <20221219010619.1826599-3-Thomas.Winter@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221219010619.1826599-1-Thomas.Winter@alliedtelesis.co.nz>
References: <20221219010619.1826599-1-Thomas.Winter@alliedtelesis.co.nz>
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
index e9d7ec03316d..a51fb106fa4a 100644
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

