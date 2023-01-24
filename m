Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFE62678EF3
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 04:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbjAXDV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 22:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232137AbjAXDVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 22:21:23 -0500
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8A139B81
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 19:21:21 -0800 (PST)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 3FD352C0382;
        Tue, 24 Jan 2023 16:21:17 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1674530477;
        bh=ui64NQiE46HAaxcvftxz384jJGVakZIhHVS3AZGc4Fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XKrVyFMKiLHSGDgVmKps7Ed+tbM8w9ygC8pkW/peOj7w4Z2n2/GP1VVgIXg6Q++wH
         BcVQqYNSIdBhKECmmH9Ry6Qe58QMNm6SHdzupq6HhrlQ6lZ0jYZzMHzZjjVUZvD6VX
         2+wFXkUyYaWPKwdQnrpLJizmb/LiCKiZlGHo1Bm4anO7M9G1Srr1+5mOfW4f2o5NUi
         H9sZ6FE1QM8fvcawJ5lBlY4F76Pkx3gFy2FORmwFDLa0it/IJ4qIdfExPqNMr/dxwd
         DFKpLXYaY8KJHA7OicJoxMm6ZLbal8vPMv73PuYwmmu04BqtJfd4jnlvM/0/LwDIhw
         VwMlpeLiKOJnw==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B63cf4ead0001>; Tue, 24 Jan 2023 16:21:17 +1300
Received: from thomaswi-dl.ws.atlnz.lc (thomaswi-dl.ws.atlnz.lc [10.33.25.46])
        by pat.atlnz.lc (Postfix) with ESMTP id 0624313EDFA;
        Tue, 24 Jan 2023 16:21:17 +1300 (NZDT)
Received: by thomaswi-dl.ws.atlnz.lc (Postfix, from userid 1719)
        id 01D953E079C; Tue, 24 Jan 2023 16:21:16 +1300 (NZDT)
From:   Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        pabeni@redhat.com, edumazet@google.com, kuba@kernel.org,
        a@unstable.cc, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
Subject: [PATCH 1/2] ip/ip6_gre: Fix changing addr gen mode not generating IPv6 link local address
Date:   Tue, 24 Jan 2023 16:21:02 +1300
Message-Id: <20230124032105.79487-2-Thomas.Winter@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124032105.79487-1-Thomas.Winter@alliedtelesis.co.nz>
References: <20230124032105.79487-1-Thomas.Winter@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=a6lOCnaF c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=RvmDmJFTN0MA:10 a=HROInG98OEpMAGfJxuYA:9
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
 net/ipv6/addrconf.c | 51 +++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f7a84a4acffc..0065b38fc85b 100644
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
+static void addrconfig_init_auto_addrs(struct net_device *dev)
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
@@ -3615,26 +3639,7 @@ static int addrconf_notify(struct notifier_block *=
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
+		addrconfig_init_auto_addrs(dev);
=20
 		if (!IS_ERR_OR_NULL(idev)) {
 			if (run_pending)
@@ -6397,7 +6402,7 @@ static int addrconf_sysctl_addr_gen_mode(struct ctl=
_table *ctl, int write,
=20
 			if (idev->cnf.addr_gen_mode !=3D new_val) {
 				idev->cnf.addr_gen_mode =3D new_val;
-				addrconf_dev_config(idev->dev);
+				addrconfig_init_auto_addrs(idev->dev);
 			}
 		} else if (&net->ipv6.devconf_all->addr_gen_mode =3D=3D ctl->data) {
 			struct net_device *dev;
@@ -6408,7 +6413,7 @@ static int addrconf_sysctl_addr_gen_mode(struct ctl=
_table *ctl, int write,
 				if (idev &&
 				    idev->cnf.addr_gen_mode !=3D new_val) {
 					idev->cnf.addr_gen_mode =3D new_val;
-					addrconf_dev_config(idev->dev);
+					addrconfig_init_auto_addrs(idev->dev);
 				}
 			}
 		}
--=20
2.39.0

