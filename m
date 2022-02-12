Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 411A04B3424
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 10:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbiBLJ6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 04:58:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbiBLJ6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 04:58:35 -0500
Received: from smtp.smtpout.orange.fr (smtp09.smtpout.orange.fr [80.12.242.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B47F24BEA
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 01:58:30 -0800 (PST)
Received: from pop-os.home ([90.126.236.122])
        by smtp.orange.fr with ESMTPA
        id IpAhndzDgtSo5IpAhneZDI; Sat, 12 Feb 2022 10:58:29 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 12 Feb 2022 10:58:29 +0100
X-ME-IP: 90.126.236.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH] net: bridge: Slightly optimize br_stp_change_bridge_id()
Date:   Sat, 12 Feb 2022 10:58:20 +0100
Message-Id: <73f674075ae5279e3d2fa07d61a0a75bc50790f3.1644659879.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ether_addr_equal_64bits() can easy be used in place of ether_addr_equal()
here.
Padding in the 'net_bridge_port' structure is already there because it is a
huge structure and the required fields are not at the end.
'oldaddr' is local to the function. So add the required padding
explicitly and simplify its definition.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This patch is more a POC for me.

I'm unsure that using ether_addr_equal_64bits() is really useful. The
speedup should be mostly un-noticeable.

To make sure that we have the required padding, we either need to waste
some space or rely on the fact that the address is embedded in a large
enough structure. (which is the case here)

So, it looks fragile to me and not future-proof.

Feed-back highly appreciated to see if such patches are welcome and if I
should spend some time on it.
---
 net/bridge/br_private.h |  5 +++++
 net/bridge/br_stp_if.c  | 12 +++++++-----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 2661dda1a92b..2f78090574c9 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -363,6 +363,11 @@ struct net_bridge_port {
 	unsigned char			config_pending;
 	port_id				port_id;
 	port_id				designated_port;
+	/*
+	 * designated_root and designated_bridge must NOT be at the end of the
+	 * structure because ether_addr_equal_64bits() requires 2 bytes of
+	 * padding.
+	 */
 	bridge_id			designated_root;
 	bridge_id			designated_bridge;
 	u32				path_cost;
diff --git a/net/bridge/br_stp_if.c b/net/bridge/br_stp_if.c
index 75204d36d7f9..1bf0aaf29e5e 100644
--- a/net/bridge/br_stp_if.c
+++ b/net/bridge/br_stp_if.c
@@ -221,9 +221,11 @@ int br_stp_set_enabled(struct net_bridge *br, unsigned long val,
 /* called under bridge lock */
 void br_stp_change_bridge_id(struct net_bridge *br, const unsigned char *addr)
 {
-	/* should be aligned on 2 bytes for ether_addr_equal() */
-	unsigned short oldaddr_aligned[ETH_ALEN >> 1];
-	unsigned char *oldaddr = (unsigned char *)oldaddr_aligned;
+	/*
+	 * should be aligned on 2 bytes and have 2 bytes of padding for
+	 * ether_addr_equal_64bits()
+	 */
+	unsigned char oldaddr[ETH_ALEN + 2] __aligned(2);
 	struct net_bridge_port *p;
 	int wasroot;
 
@@ -236,10 +238,10 @@ void br_stp_change_bridge_id(struct net_bridge *br, const unsigned char *addr)
 	eth_hw_addr_set(br->dev, addr);
 
 	list_for_each_entry(p, &br->port_list, list) {
-		if (ether_addr_equal(p->designated_bridge.addr, oldaddr))
+		if (ether_addr_equal_64bits(p->designated_bridge.addr, oldaddr))
 			memcpy(p->designated_bridge.addr, addr, ETH_ALEN);
 
-		if (ether_addr_equal(p->designated_root.addr, oldaddr))
+		if (ether_addr_equal_64bits(p->designated_root.addr, oldaddr))
 			memcpy(p->designated_root.addr, addr, ETH_ALEN);
 	}
 
-- 
2.32.0

