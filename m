Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD714743CB
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 14:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhLNNpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 08:45:41 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:41910 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234547AbhLNNpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 08:45:39 -0500
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639489537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7c1q737MIaJzZBoq6YffHEZqPideAxTTceFWstseay4=;
        b=U0RCk0L4warEcKiIuvlaGb6UHl+Mvx2N6tQ2ghkwrB+obW7ht2dFeFlAB7/jkKeGs/weDc
        RG/vl2VXiYoJMjw8htI3s8FhdWsa51pg41pBdGVo9uyBucP2ekZcaZ61nm7FsJGeDfsbPR
        noSpLQHjXQJnjbk6ydQD2BEat8ELOCkJpX8xD0Nj3eij6LncwLPCGPGdXL8EnrbOEj+lv4
        T6ZzH0ZPN7K2KaelQx7OdNh5y9UlXPwPgxDj1SAmitPKKS6l8zrZ9kMnt9pcN8lBVfMIkP
        TVXlSG15tlthksiSvrlLrOlgLl4/yLo3JX8NiCDRbVCx0zEmEjfr3StNbysqMQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639489537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7c1q737MIaJzZBoq6YffHEZqPideAxTTceFWstseay4=;
        b=yUTvughUIAtrgnH9HgNIwvabJHMZFga6pemZ8KPAVb7yrZ/rDKym7A/uLmq9n+ggkJgopr
        E8D0K9XWxrcenmDw==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next v2 4/4] net: dsa: hellcreek: Add missing PTP via UDP rules
Date:   Tue, 14 Dec 2021 14:45:08 +0100
Message-Id: <20211214134508.57806-5-kurt@linutronix.de>
In-Reply-To: <20211214134508.57806-1-kurt@linutronix.de>
References: <20211214134508.57806-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch supports PTP for UDP transport too. Therefore, add the missing static
FDB entries to ensure correct forwarding of these packets.

Fixes: ddd56dfe52c9 ("net: dsa: hellcreek: Add PTP clock support")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 64 ++++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index cc0e4465bbbf..726f267cb228 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1053,7 +1053,7 @@ static void hellcreek_setup_tc_identity_mapping(struct hellcreek *hellcreek)
 
 static int hellcreek_setup_fdb(struct hellcreek *hellcreek)
 {
-	static struct hellcreek_fdb_entry ptp = {
+	static struct hellcreek_fdb_entry l2_ptp = {
 		/* MAC: 01-1B-19-00-00-00 */
 		.mac	      = { 0x01, 0x1b, 0x19, 0x00, 0x00, 0x00 },
 		.portmask     = 0x03,	/* Management ports */
@@ -1064,7 +1064,29 @@ static int hellcreek_setup_fdb(struct hellcreek *hellcreek)
 		.reprio_tc    = 6,	/* TC: 6 as per IEEE 802.1AS */
 		.reprio_en    = 1,
 	};
-	static struct hellcreek_fdb_entry p2p = {
+	static struct hellcreek_fdb_entry udp4_ptp = {
+		/* MAC: 01-00-5E-00-01-81 */
+		.mac	      = { 0x01, 0x00, 0x5e, 0x00, 0x01, 0x81 },
+		.portmask     = 0x03,	/* Management ports */
+		.age	      = 0,
+		.is_obt	      = 0,
+		.pass_blocked = 0,
+		.is_static    = 1,
+		.reprio_tc    = 6,
+		.reprio_en    = 1,
+	};
+	static struct hellcreek_fdb_entry udp6_ptp = {
+		/* MAC: 33-33-00-00-01-81 */
+		.mac	      = { 0x33, 0x33, 0x00, 0x00, 0x01, 0x81 },
+		.portmask     = 0x03,	/* Management ports */
+		.age	      = 0,
+		.is_obt	      = 0,
+		.pass_blocked = 0,
+		.is_static    = 1,
+		.reprio_tc    = 6,
+		.reprio_en    = 1,
+	};
+	static struct hellcreek_fdb_entry l2_p2p = {
 		/* MAC: 01-80-C2-00-00-0E */
 		.mac	      = { 0x01, 0x80, 0xc2, 0x00, 0x00, 0x0e },
 		.portmask     = 0x03,	/* Management ports */
@@ -1075,6 +1097,28 @@ static int hellcreek_setup_fdb(struct hellcreek *hellcreek)
 		.reprio_tc    = 6,	/* TC: 6 as per IEEE 802.1AS */
 		.reprio_en    = 1,
 	};
+	static struct hellcreek_fdb_entry udp4_p2p = {
+		/* MAC: 01-00-5E-00-00-6B */
+		.mac	      = { 0x01, 0x00, 0x5e, 0x00, 0x00, 0x6b },
+		.portmask     = 0x03,	/* Management ports */
+		.age	      = 0,
+		.is_obt	      = 0,
+		.pass_blocked = 1,
+		.is_static    = 1,
+		.reprio_tc    = 6,
+		.reprio_en    = 1,
+	};
+	static struct hellcreek_fdb_entry udp6_p2p = {
+		/* MAC: 33-33-00-00-00-6B */
+		.mac	      = { 0x33, 0x33, 0x00, 0x00, 0x00, 0x6b },
+		.portmask     = 0x03,	/* Management ports */
+		.age	      = 0,
+		.is_obt	      = 0,
+		.pass_blocked = 1,
+		.is_static    = 1,
+		.reprio_tc    = 6,
+		.reprio_en    = 1,
+	};
 	static struct hellcreek_fdb_entry stp = {
 		/* MAC: 01-80-C2-00-00-00 */
 		.mac	      = { 0x01, 0x80, 0xc2, 0x00, 0x00, 0x00 },
@@ -1089,10 +1133,22 @@ static int hellcreek_setup_fdb(struct hellcreek *hellcreek)
 	int ret;
 
 	mutex_lock(&hellcreek->reg_lock);
-	ret = __hellcreek_fdb_add(hellcreek, &ptp);
+	ret = __hellcreek_fdb_add(hellcreek, &l2_ptp);
+	if (ret)
+		goto out;
+	ret = __hellcreek_fdb_add(hellcreek, &udp4_ptp);
+	if (ret)
+		goto out;
+	ret = __hellcreek_fdb_add(hellcreek, &udp6_ptp);
+	if (ret)
+		goto out;
+	ret = __hellcreek_fdb_add(hellcreek, &l2_p2p);
+	if (ret)
+		goto out;
+	ret = __hellcreek_fdb_add(hellcreek, &udp4_p2p);
 	if (ret)
 		goto out;
-	ret = __hellcreek_fdb_add(hellcreek, &p2p);
+	ret = __hellcreek_fdb_add(hellcreek, &udp6_p2p);
 	if (ret)
 		goto out;
 	ret = __hellcreek_fdb_add(hellcreek, &stp);
-- 
2.30.2

