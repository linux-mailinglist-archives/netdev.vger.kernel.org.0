Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0CAEF9AB
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 15:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfD3NOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 09:14:47 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:33255 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727390AbfD3NOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 09:14:45 -0400
X-Originating-IP: 90.88.149.145
Received: from mc-bl-xps13.lan (aaubervilliers-681-1-29-145.w90-88.abo.wanadoo.fr [90.88.149.145])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 837AD1BF20E;
        Tue, 30 Apr 2019 13:14:40 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 2/4] net: mvpp2: cls: Use a bitfield to represent the flow_type
Date:   Tue, 30 Apr 2019 15:14:27 +0200
Message-Id: <20190430131429.19361-3-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190430131429.19361-1-maxime.chevallier@bootlin.com>
References: <20190430131429.19361-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As of today, the classification code is used only for RSS. We split the
incoming traffic into multiple flows, that correspond to the ethtool
flow_type parameter.

We don't want to use the ethtool flow definitions such as TCP_V4_FLOW,
for several reason :

 - We want to decorrelate the driver code from ethtool as much as
   possible, so that we can easily use other interfaces such as tc flower,

 - We want the flow_type to be a bitfield, so that we can match flows
   embedded into each other, such as TCP4 which is a subset of IP4.

This commit does the conversion to the newer type.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_cls.c    | 164 ++++++++++--------
 .../net/ethernet/marvell/mvpp2/mvpp2_cls.h    |  14 ++
 2 files changed, 109 insertions(+), 69 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index ca32ccdab68a..2bbd4c294fc9 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -24,300 +24,300 @@
 
 static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 	/* TCP over IPv4 flows, Not fragmented, no vlan tag */
-	MVPP2_DEF_FLOW(TCP_V4_FLOW, MVPP2_FL_IP4_TCP_NF_UNTAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_NF_UNTAG,
 		       MVPP22_CLS_HEK_IP4_5T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4 |
 		       MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
-	MVPP2_DEF_FLOW(TCP_V4_FLOW, MVPP2_FL_IP4_TCP_NF_UNTAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_NF_UNTAG,
 		       MVPP22_CLS_HEK_IP4_5T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OPT |
 		       MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
-	MVPP2_DEF_FLOW(TCP_V4_FLOW, MVPP2_FL_IP4_TCP_NF_UNTAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_NF_UNTAG,
 		       MVPP22_CLS_HEK_IP4_5T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OTHER |
 		       MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	/* TCP over IPv4 flows, Not fragmented, with vlan tag */
-	MVPP2_DEF_FLOW(TCP_V4_FLOW, MVPP2_FL_IP4_TCP_NF_TAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_NF_TAG,
 		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_OPT_VLAN,
 		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
-	MVPP2_DEF_FLOW(TCP_V4_FLOW, MVPP2_FL_IP4_TCP_NF_TAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_NF_TAG,
 		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_OPT_VLAN,
 		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
-	MVPP2_DEF_FLOW(TCP_V4_FLOW, MVPP2_FL_IP4_TCP_NF_TAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_NF_TAG,
 		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_OPT_VLAN,
 		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	/* TCP over IPv4 flows, fragmented, no vlan tag */
-	MVPP2_DEF_FLOW(TCP_V4_FLOW, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4 |
 		       MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
-	MVPP2_DEF_FLOW(TCP_V4_FLOW, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OPT |
 		       MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
-	MVPP2_DEF_FLOW(TCP_V4_FLOW, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OTHER |
 		       MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	/* TCP over IPv4 flows, fragmented, with vlan tag */
-	MVPP2_DEF_FLOW(TCP_V4_FLOW, MVPP2_FL_IP4_TCP_FRAG_TAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_OPT_VLAN,
 		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
-	MVPP2_DEF_FLOW(TCP_V4_FLOW, MVPP2_FL_IP4_TCP_FRAG_TAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_OPT_VLAN,
 		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
-	MVPP2_DEF_FLOW(TCP_V4_FLOW, MVPP2_FL_IP4_TCP_FRAG_TAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_OPT_VLAN,
 		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	/* UDP over IPv4 flows, Not fragmented, no vlan tag */
-	MVPP2_DEF_FLOW(UDP_V4_FLOW, MVPP2_FL_IP4_UDP_NF_UNTAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_NF_UNTAG,
 		       MVPP22_CLS_HEK_IP4_5T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4 |
 		       MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
-	MVPP2_DEF_FLOW(UDP_V4_FLOW, MVPP2_FL_IP4_UDP_NF_UNTAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_NF_UNTAG,
 		       MVPP22_CLS_HEK_IP4_5T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OPT |
 		       MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
-	MVPP2_DEF_FLOW(UDP_V4_FLOW, MVPP2_FL_IP4_UDP_NF_UNTAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_NF_UNTAG,
 		       MVPP22_CLS_HEK_IP4_5T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OTHER |
 		       MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	/* UDP over IPv4 flows, Not fragmented, with vlan tag */
-	MVPP2_DEF_FLOW(UDP_V4_FLOW, MVPP2_FL_IP4_UDP_NF_TAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_NF_TAG,
 		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_OPT_VLAN,
 		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
-	MVPP2_DEF_FLOW(UDP_V4_FLOW, MVPP2_FL_IP4_UDP_NF_TAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_NF_TAG,
 		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_OPT_VLAN,
 		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
-	MVPP2_DEF_FLOW(UDP_V4_FLOW, MVPP2_FL_IP4_UDP_NF_TAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_NF_TAG,
 		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_OPT_VLAN,
 		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	/* UDP over IPv4 flows, fragmented, no vlan tag */
-	MVPP2_DEF_FLOW(UDP_V4_FLOW, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4 |
 		       MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
-	MVPP2_DEF_FLOW(UDP_V4_FLOW, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OPT |
 		       MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
-	MVPP2_DEF_FLOW(UDP_V4_FLOW, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OTHER |
 		       MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	/* UDP over IPv4 flows, fragmented, with vlan tag */
-	MVPP2_DEF_FLOW(UDP_V4_FLOW, MVPP2_FL_IP4_UDP_FRAG_TAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_OPT_VLAN,
 		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
-	MVPP2_DEF_FLOW(UDP_V4_FLOW, MVPP2_FL_IP4_UDP_FRAG_TAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_OPT_VLAN,
 		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
-	MVPP2_DEF_FLOW(UDP_V4_FLOW, MVPP2_FL_IP4_UDP_FRAG_TAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_OPT_VLAN,
 		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	/* TCP over IPv6 flows, not fragmented, no vlan tag */
-	MVPP2_DEF_FLOW(TCP_V6_FLOW, MVPP2_FL_IP6_TCP_NF_UNTAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_NF_UNTAG,
 		       MVPP22_CLS_HEK_IP6_5T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP6 |
 		       MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
-	MVPP2_DEF_FLOW(TCP_V6_FLOW, MVPP2_FL_IP6_TCP_NF_UNTAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_NF_UNTAG,
 		       MVPP22_CLS_HEK_IP6_5T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP6_EXT |
 		       MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	/* TCP over IPv6 flows, not fragmented, with vlan tag */
-	MVPP2_DEF_FLOW(TCP_V6_FLOW, MVPP2_FL_IP6_TCP_NF_TAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_NF_TAG,
 		       MVPP22_CLS_HEK_IP6_5T | MVPP22_CLS_HEK_OPT_VLAN,
 		       MVPP2_PRS_RI_L3_IP6 | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
-	MVPP2_DEF_FLOW(TCP_V6_FLOW, MVPP2_FL_IP6_TCP_NF_TAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_NF_TAG,
 		       MVPP22_CLS_HEK_IP6_5T | MVPP22_CLS_HEK_OPT_VLAN,
 		       MVPP2_PRS_RI_L3_IP6_EXT | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	/* TCP over IPv6 flows, fragmented, no vlan tag */
-	MVPP2_DEF_FLOW(TCP_V6_FLOW, MVPP2_FL_IP6_TCP_FRAG_UNTAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP6_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP6 |
 		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
-	MVPP2_DEF_FLOW(TCP_V6_FLOW, MVPP2_FL_IP6_TCP_FRAG_UNTAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP6_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP6_EXT |
 		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	/* TCP over IPv6 flows, fragmented, with vlan tag */
-	MVPP2_DEF_FLOW(TCP_V6_FLOW, MVPP2_FL_IP6_TCP_FRAG_TAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_OPT_VLAN,
 		       MVPP2_PRS_RI_L3_IP6 | MVPP2_PRS_RI_IP_FRAG_TRUE |
 		       MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
-	MVPP2_DEF_FLOW(TCP_V6_FLOW, MVPP2_FL_IP6_TCP_FRAG_TAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_OPT_VLAN,
 		       MVPP2_PRS_RI_L3_IP6_EXT | MVPP2_PRS_RI_IP_FRAG_TRUE |
 		       MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	/* UDP over IPv6 flows, not fragmented, no vlan tag */
-	MVPP2_DEF_FLOW(UDP_V6_FLOW, MVPP2_FL_IP6_UDP_NF_UNTAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_NF_UNTAG,
 		       MVPP22_CLS_HEK_IP6_5T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP6 |
 		       MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
-	MVPP2_DEF_FLOW(UDP_V6_FLOW, MVPP2_FL_IP6_UDP_NF_UNTAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_NF_UNTAG,
 		       MVPP22_CLS_HEK_IP6_5T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP6_EXT |
 		       MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	/* UDP over IPv6 flows, not fragmented, with vlan tag */
-	MVPP2_DEF_FLOW(UDP_V6_FLOW, MVPP2_FL_IP6_UDP_NF_TAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_NF_TAG,
 		       MVPP22_CLS_HEK_IP6_5T | MVPP22_CLS_HEK_OPT_VLAN,
 		       MVPP2_PRS_RI_L3_IP6 | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
-	MVPP2_DEF_FLOW(UDP_V6_FLOW, MVPP2_FL_IP6_UDP_NF_TAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_NF_TAG,
 		       MVPP22_CLS_HEK_IP6_5T | MVPP22_CLS_HEK_OPT_VLAN,
 		       MVPP2_PRS_RI_L3_IP6_EXT | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	/* UDP over IPv6 flows, fragmented, no vlan tag */
-	MVPP2_DEF_FLOW(UDP_V6_FLOW, MVPP2_FL_IP6_UDP_FRAG_UNTAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP6_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP6 |
 		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
-	MVPP2_DEF_FLOW(UDP_V6_FLOW, MVPP2_FL_IP6_UDP_FRAG_UNTAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP6_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP6_EXT |
 		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	/* UDP over IPv6 flows, fragmented, with vlan tag */
-	MVPP2_DEF_FLOW(UDP_V6_FLOW, MVPP2_FL_IP6_UDP_FRAG_TAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_OPT_VLAN,
 		       MVPP2_PRS_RI_L3_IP6 | MVPP2_PRS_RI_IP_FRAG_TRUE |
 		       MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
-	MVPP2_DEF_FLOW(UDP_V6_FLOW, MVPP2_FL_IP6_UDP_FRAG_TAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_FRAG_TAG,
 		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_OPT_VLAN,
 		       MVPP2_PRS_RI_L3_IP6_EXT | MVPP2_PRS_RI_IP_FRAG_TRUE |
 		       MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	/* IPv4 flows, no vlan tag */
-	MVPP2_DEF_FLOW(IPV4_FLOW, MVPP2_FL_IP4_UNTAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_IP4, MVPP2_FL_IP4_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4,
 		       MVPP2_PRS_RI_VLAN_MASK | MVPP2_PRS_RI_L3_PROTO_MASK),
-	MVPP2_DEF_FLOW(IPV4_FLOW, MVPP2_FL_IP4_UNTAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_IP4, MVPP2_FL_IP4_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OPT,
 		       MVPP2_PRS_RI_VLAN_MASK | MVPP2_PRS_RI_L3_PROTO_MASK),
-	MVPP2_DEF_FLOW(IPV4_FLOW, MVPP2_FL_IP4_UNTAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_IP4, MVPP2_FL_IP4_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OTHER,
 		       MVPP2_PRS_RI_VLAN_MASK | MVPP2_PRS_RI_L3_PROTO_MASK),
 
 	/* IPv4 flows, with vlan tag */
-	MVPP2_DEF_FLOW(IPV4_FLOW, MVPP2_FL_IP4_TAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_IP4, MVPP2_FL_IP4_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_OPT_VLAN,
 		       MVPP2_PRS_RI_L3_IP4,
 		       MVPP2_PRS_RI_L3_PROTO_MASK),
-	MVPP2_DEF_FLOW(IPV4_FLOW, MVPP2_FL_IP4_TAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_IP4, MVPP2_FL_IP4_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_OPT_VLAN,
 		       MVPP2_PRS_RI_L3_IP4_OPT,
 		       MVPP2_PRS_RI_L3_PROTO_MASK),
-	MVPP2_DEF_FLOW(IPV4_FLOW, MVPP2_FL_IP4_TAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_IP4, MVPP2_FL_IP4_TAG,
 		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_OPT_VLAN,
 		       MVPP2_PRS_RI_L3_IP4_OTHER,
 		       MVPP2_PRS_RI_L3_PROTO_MASK),
 
 	/* IPv6 flows, no vlan tag */
-	MVPP2_DEF_FLOW(IPV6_FLOW, MVPP2_FL_IP6_UNTAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_IP6, MVPP2_FL_IP6_UNTAG,
 		       MVPP22_CLS_HEK_IP6_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP6,
 		       MVPP2_PRS_RI_VLAN_MASK | MVPP2_PRS_RI_L3_PROTO_MASK),
-	MVPP2_DEF_FLOW(IPV6_FLOW, MVPP2_FL_IP6_UNTAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_IP6, MVPP2_FL_IP6_UNTAG,
 		       MVPP22_CLS_HEK_IP6_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP6,
 		       MVPP2_PRS_RI_VLAN_MASK | MVPP2_PRS_RI_L3_PROTO_MASK),
 
 	/* IPv6 flows, with vlan tag */
-	MVPP2_DEF_FLOW(IPV6_FLOW, MVPP2_FL_IP6_TAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_IP6, MVPP2_FL_IP6_TAG,
 		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_OPT_VLAN,
 		       MVPP2_PRS_RI_L3_IP6,
 		       MVPP2_PRS_RI_L3_PROTO_MASK),
-	MVPP2_DEF_FLOW(IPV6_FLOW, MVPP2_FL_IP6_TAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_IP6, MVPP2_FL_IP6_TAG,
 		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_OPT_VLAN,
 		       MVPP2_PRS_RI_L3_IP6,
 		       MVPP2_PRS_RI_L3_PROTO_MASK),
 
 	/* Non IP flow, no vlan tag */
-	MVPP2_DEF_FLOW(ETHER_FLOW, MVPP2_FL_NON_IP_UNTAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_ETHERNET, MVPP2_FL_NON_IP_UNTAG,
 		       0,
 		       MVPP2_PRS_RI_VLAN_NONE,
 		       MVPP2_PRS_RI_VLAN_MASK),
 	/* Non IP flow, with vlan tag */
-	MVPP2_DEF_FLOW(ETHER_FLOW, MVPP2_FL_NON_IP_TAG,
+	MVPP2_DEF_FLOW(MVPP22_FLOW_ETHERNET, MVPP2_FL_NON_IP_TAG,
 		       MVPP22_CLS_HEK_OPT_VLAN,
 		       0, 0),
 };
@@ -539,6 +539,26 @@ void mvpp2_cls_c2_read(struct mvpp2 *priv, int index,
 	c2->valid = !(val & MVPP22_CLS_C2_TCAM_INV_BIT);
 }
 
+static int mvpp2_cls_ethtool_flow_to_type(int flow_type)
+{
+	switch (flow_type & ~(FLOW_EXT | FLOW_MAC_EXT | FLOW_RSS)) {
+	case TCP_V4_FLOW:
+		return MVPP22_FLOW_TCP4;
+	case TCP_V6_FLOW:
+		return MVPP22_FLOW_TCP6;
+	case UDP_V4_FLOW:
+		return MVPP22_FLOW_UDP4;
+	case UDP_V6_FLOW:
+		return MVPP22_FLOW_UDP6;
+	case IPV4_FLOW:
+		return MVPP22_FLOW_IP4;
+	case IPV6_FLOW:
+		return MVPP22_FLOW_IP6;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 /* Initialize the flow table entries for the given flow */
 static void mvpp2_cls_flow_init(struct mvpp2 *priv,
 				const struct mvpp2_cls_flow *flow)
@@ -565,7 +585,7 @@ static void mvpp2_cls_flow_init(struct mvpp2 *priv,
 
 	mvpp2_cls_flow_eng_set(&fe, MVPP22_CLS_ENGINE_C2);
 	mvpp2_cls_flow_port_id_sel(&fe, true);
-	mvpp2_cls_flow_lu_type_set(&fe, MVPP2_CLS_LU_ALL);
+	mvpp2_cls_flow_lu_type_set(&fe, MVPP22_FLOW_ETHERNET);
 
 	/* Add all ports */
 	for (i = 0; i < MVPP2_MAX_PORTS; i++)
@@ -810,7 +830,7 @@ static void mvpp2_port_c2_cls_init(struct mvpp2_port *port)
 
 	/* Match on Lookup Type */
 	c2.tcam[4] |= MVPP22_CLS_C2_TCAM_EN(MVPP22_CLS_C2_LU_TYPE(MVPP2_CLS_LU_TYPE_MASK));
-	c2.tcam[4] |= MVPP22_CLS_C2_LU_TYPE(MVPP2_CLS_LU_ALL);
+	c2.tcam[4] |= MVPP22_CLS_C2_LU_TYPE(MVPP22_FLOW_ETHERNET);
 
 	/* Update RSS status after matching this entry */
 	c2.act = MVPP22_CLS_C2_ACT_RSS_EN(MVPP22_C2_UPD_LOCK);
@@ -997,19 +1017,22 @@ void mvpp22_rss_fill_table(struct mvpp2_port *port, u32 table)
 int mvpp2_ethtool_rxfh_set(struct mvpp2_port *port, struct ethtool_rxnfc *info)
 {
 	u16 hash_opts = 0;
+	u32 flow_type;
 
-	switch (info->flow_type) {
-	case TCP_V4_FLOW:
-	case UDP_V4_FLOW:
-	case TCP_V6_FLOW:
-	case UDP_V6_FLOW:
+	flow_type = mvpp2_cls_ethtool_flow_to_type(info->flow_type);
+
+	switch (flow_type) {
+	case MVPP22_FLOW_TCP4:
+	case MVPP22_FLOW_UDP4:
+	case MVPP22_FLOW_TCP6:
+	case MVPP22_FLOW_UDP6:
 		if (info->data & RXH_L4_B_0_1)
 			hash_opts |= MVPP22_CLS_HEK_OPT_L4SIP;
 		if (info->data & RXH_L4_B_2_3)
 			hash_opts |= MVPP22_CLS_HEK_OPT_L4DIP;
 		/* Fallthrough */
-	case IPV4_FLOW:
-	case IPV6_FLOW:
+	case MVPP22_FLOW_IP4:
+	case MVPP22_FLOW_IP6:
 		if (info->data & RXH_L2DA)
 			hash_opts |= MVPP22_CLS_HEK_OPT_MAC_DA;
 		if (info->data & RXH_VLAN)
@@ -1026,15 +1049,18 @@ int mvpp2_ethtool_rxfh_set(struct mvpp2_port *port, struct ethtool_rxnfc *info)
 	default: return -EOPNOTSUPP;
 	}
 
-	return mvpp2_port_rss_hash_opts_set(port, info->flow_type, hash_opts);
+	return mvpp2_port_rss_hash_opts_set(port, flow_type, hash_opts);
 }
 
 int mvpp2_ethtool_rxfh_get(struct mvpp2_port *port, struct ethtool_rxnfc *info)
 {
 	unsigned long hash_opts;
+	u32 flow_type;
 	int i;
 
-	hash_opts = mvpp2_port_rss_hash_opts_get(port, info->flow_type);
+	flow_type = mvpp2_cls_ethtool_flow_to_type(info->flow_type);
+
+	hash_opts = mvpp2_port_rss_hash_opts_get(port, flow_type);
 	info->data = 0;
 
 	for_each_set_bit(i, &hash_opts, MVPP22_CLS_HEK_N_FIELDS) {
@@ -1097,10 +1123,10 @@ void mvpp22_port_rss_init(struct mvpp2_port *port)
 	mvpp22_rss_fill_table(port, port->id);
 
 	/* Configure default flows */
-	mvpp2_port_rss_hash_opts_set(port, IPV4_FLOW, MVPP22_CLS_HEK_IP4_2T);
-	mvpp2_port_rss_hash_opts_set(port, IPV6_FLOW, MVPP22_CLS_HEK_IP6_2T);
-	mvpp2_port_rss_hash_opts_set(port, TCP_V4_FLOW, MVPP22_CLS_HEK_IP4_5T);
-	mvpp2_port_rss_hash_opts_set(port, TCP_V6_FLOW, MVPP22_CLS_HEK_IP6_5T);
-	mvpp2_port_rss_hash_opts_set(port, UDP_V4_FLOW, MVPP22_CLS_HEK_IP4_5T);
-	mvpp2_port_rss_hash_opts_set(port, UDP_V6_FLOW, MVPP22_CLS_HEK_IP6_5T);
+	mvpp2_port_rss_hash_opts_set(port, MVPP22_FLOW_IP4, MVPP22_CLS_HEK_IP4_2T);
+	mvpp2_port_rss_hash_opts_set(port, MVPP22_FLOW_IP6, MVPP22_CLS_HEK_IP6_2T);
+	mvpp2_port_rss_hash_opts_set(port, MVPP22_FLOW_TCP4, MVPP22_CLS_HEK_IP4_5T);
+	mvpp2_port_rss_hash_opts_set(port, MVPP22_FLOW_TCP6, MVPP22_CLS_HEK_IP6_5T);
+	mvpp2_port_rss_hash_opts_set(port, MVPP22_FLOW_UDP4, MVPP22_CLS_HEK_IP4_5T);
+	mvpp2_port_rss_hash_opts_set(port, MVPP22_FLOW_UDP6, MVPP22_CLS_HEK_IP6_5T);
 }
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
index 96304ffc5d49..284a16225370 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
@@ -107,6 +107,20 @@ struct mvpp2_cls_c2_entry {
 	u8 valid;
 };
 
+#define MVPP22_FLOW_ETHER_BIT	BIT(0)
+#define MVPP22_FLOW_IP4_BIT	BIT(1)
+#define MVPP22_FLOW_IP6_BIT	BIT(2)
+#define MVPP22_FLOW_TCP_BIT	BIT(3)
+#define MVPP22_FLOW_UDP_BIT	BIT(4)
+
+#define MVPP22_FLOW_TCP4	(MVPP22_FLOW_ETHER_BIT | MVPP22_FLOW_IP4_BIT | MVPP22_FLOW_TCP_BIT)
+#define MVPP22_FLOW_TCP6	(MVPP22_FLOW_ETHER_BIT | MVPP22_FLOW_IP6_BIT | MVPP22_FLOW_TCP_BIT)
+#define MVPP22_FLOW_UDP4	(MVPP22_FLOW_ETHER_BIT | MVPP22_FLOW_IP4_BIT | MVPP22_FLOW_UDP_BIT)
+#define MVPP22_FLOW_UDP6	(MVPP22_FLOW_ETHER_BIT | MVPP22_FLOW_IP6_BIT | MVPP22_FLOW_UDP_BIT)
+#define MVPP22_FLOW_IP4		(MVPP22_FLOW_ETHER_BIT | MVPP22_FLOW_IP4_BIT)
+#define MVPP22_FLOW_IP6		(MVPP22_FLOW_ETHER_BIT | MVPP22_FLOW_IP6_BIT)
+#define MVPP22_FLOW_ETHERNET	(MVPP22_FLOW_ETHER_BIT)
+
 /* Classifier C2 engine entries */
 #define MVPP22_CLS_C2_N_ENTRIES		256
 
-- 
2.20.1

