Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66020650606
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 02:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbiLSBGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 20:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiLSBGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 20:06:30 -0500
X-Greylist: delayed 11339 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 18 Dec 2022 17:06:26 PST
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [202.36.163.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36E425DF
        for <netdev@vger.kernel.org>; Sun, 18 Dec 2022 17:06:26 -0800 (PST)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id A7BDF2C04D0;
        Mon, 19 Dec 2022 14:06:23 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1671411983;
        bh=b5Vys3RZgCf8hr5WBLGbUPkgO7Lub5HlKnK0lTDDKWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0L1vTGFFuihgrO6xhxMMXJ7EUjDQ83q/nTBjGwXrtFUltOJaTr1UFSenijUDqNkUj
         uVnDHQD/LoSIGZRs6FVw2AVCiO+Pf/ZruV/qjiwHMK1OpiOXAR1bfR0+7ejoDkv5AF
         YzL8DSEN2v46HKMkwx412UCuvsGAfnp1evZQUw200Canu+IGST3JRapGzy6MlfNW5r
         iQqLXEnTecLDcikYYsBhJj5HnIWZuvifUR2XlZ0HT6K/CspLpoaZKs2Gh+H5VhqdtI
         zo/fp2eZ7ORVVevBKkaz+lz2HV7rICW2Hlb9TOrtFuH2xR0sIBNdWD6zhWxuHiuUkI
         I7bYktqed1ikg==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B639fb90f0001>; Mon, 19 Dec 2022 14:06:23 +1300
Received: from thomaswi-dl.ws.atlnz.lc (thomaswi-dl.ws.atlnz.lc [10.33.25.46])
        by pat.atlnz.lc (Postfix) with ESMTP id 69BFF13EE7B;
        Mon, 19 Dec 2022 14:06:23 +1300 (NZDT)
Received: by thomaswi-dl.ws.atlnz.lc (Postfix, from userid 1719)
        id 68AE73E512F; Mon, 19 Dec 2022 14:06:23 +1300 (NZDT)
From:   Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, a@unstable.cc, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
Subject: [PATCH 1/2] ip/ip6_gre: Fix changing addr gen mode not generating IPv6 link local address
Date:   Mon, 19 Dec 2022 14:06:18 +1300
Message-Id: <20221219010619.1826599-2-Thomas.Winter@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221219010619.1826599-1-Thomas.Winter@alliedtelesis.co.nz>
References: <20221219010619.1826599-1-Thomas.Winter@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=X/cs11be c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=sHyYjHe8cH0A:10 a=sxvoXph97cTEOaL2aYsA:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit e5dd729460ca changed the code path so that GRE tunnels
generate an IPv6 address based on the tunnel source address.
It also changed the code path so GRE tunnels don't call addrconf_addr_gen
in addrconf_dev_config which is called by addrconf_sysctl_addr_gen_mode
when the IN6_ADDR_GEN_MODE is changed.

This patch aims to fix this issue by moving the code in addrconf_notify
which calls the addr gen for GRE and SIT into a separate function
and calling it in the places that expect the IPv6 address to be
generated.

The previous addrconf_dev_config is renamed to addrconf_eth_config
since it only expected eth type interfaces and follows the
addrconf_gre/sit_config format.

Fixes: e5dd729460ca ("ip/ip6_gre: use the same logic as SIT interfaces wh=
en computing v6LL address")
Signed-off-by: Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
---
 net/ipv6/addrconf.c | 47 +++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 6dcf034835ec..e9d7ec03316d 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3355,7 +3355,7 @@ static void addrconf_addr_gen(struct inet6_dev *ide=
v, bool prefix_route)
 	}
 }
=20
-static void addrconf_dev_config(struct net_device *dev)
+static void addrconf_eth_config(struct net_device *dev)
 {
 	struct inet6_dev *idev;
=20
@@ -3447,6 +3447,30 @@ static void addrconf_gre_config(struct net_device =
*dev)
 }
 #endif
=20
+static void addrconf_dev_config(struct net_device *dev)
+{
+	switch (dev->type) {
+#if IS_ENABLED(CONFIG_IPV6_SIT)
+	case ARPHRD_SIT:
+		addrconf_sit_config(dev);
+		break;
+#endif
+#if IS_ENABLED(CONFIG_NET_IPGRE) || IS_ENABLED(CONFIG_IPV6_GRE)
+	case ARPHRD_IP6GRE:
+	case ARPHRD_IPGRE:
+		addrconf_gre_config(dev);
+		break;
+#endif
+	case ARPHRD_LOOPBACK:
+		init_loopback(dev);
+		break;
+
+	default:
+		addrconf_eth_config(dev);
+		break;
+	}
+}
+
 static int fixup_permanent_addr(struct net *net,
 				struct inet6_dev *idev,
 				struct inet6_ifaddr *ifp)
@@ -3611,26 +3635,7 @@ static int addrconf_notify(struct notifier_block *=
this, unsigned long event,
 			run_pending =3D 1;
 		}
=20
-		switch (dev->type) {
-#if IS_ENABLED(CONFIG_IPV6_SIT)
-		case ARPHRD_SIT:
-			addrconf_sit_config(dev);
-			break;
-#endif
-#if IS_ENABLED(CONFIG_NET_IPGRE) || IS_ENABLED(CONFIG_IPV6_GRE)
-		case ARPHRD_IP6GRE:
-		case ARPHRD_IPGRE:
-			addrconf_gre_config(dev);
-			break;
-#endif
-		case ARPHRD_LOOPBACK:
-			init_loopback(dev);
-			break;
-
-		default:
-			addrconf_dev_config(dev);
-			break;
-		}
+		addrconf_dev_config(dev);
=20
 		if (!IS_ERR_OR_NULL(idev)) {
 			if (run_pending)
--=20
2.37.3

