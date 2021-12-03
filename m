Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00695467C5E
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 18:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353259AbhLCRXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 12:23:24 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:51763 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353408AbhLCRXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 12:23:22 -0500
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 3A31E200007;
        Fri,  3 Dec 2021 17:19:56 +0000 (UTC)
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next v4 1/4] net: ocelot: export ocelot_ifh_port_set() to setup IFH
Date:   Fri,  3 Dec 2021 18:19:13 +0100
Message-Id: <20211203171916.378735-2-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211203171916.378735-1-clement.leger@bootlin.com>
References: <20211203171916.378735-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FDMA will need this code to prepare the injection frame header when
sending SKBs. Move this code into ocelot_ifh_port_set() and add
conditional IFH setting for vlan and rew op if they are not set.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 18 +++++++++++++-----
 include/soc/mscc/ocelot.h          |  1 +
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index e6c18b598d5c..59943835d18c 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1076,6 +1076,18 @@ bool ocelot_can_inject(struct ocelot *ocelot, int grp)
 }
 EXPORT_SYMBOL(ocelot_can_inject);
 
+void ocelot_ifh_port_set(void *ifh, int port, u32 rew_op, u32 vlan_tag)
+{
+	ocelot_ifh_set_bypass(ifh, 1);
+	ocelot_ifh_set_dest(ifh, BIT_ULL(port));
+	ocelot_ifh_set_tag_type(ifh, IFH_TAG_TYPE_C);
+	if (vlan_tag)
+		ocelot_ifh_set_vlan_tci(ifh, vlan_tag);
+	if (rew_op)
+		ocelot_ifh_set_rew_op(ifh, rew_op);
+}
+EXPORT_SYMBOL(ocelot_ifh_port_set);
+
 void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 			      u32 rew_op, struct sk_buff *skb)
 {
@@ -1085,11 +1097,7 @@ void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 	ocelot_write_rix(ocelot, QS_INJ_CTRL_GAP_SIZE(1) |
 			 QS_INJ_CTRL_SOF, QS_INJ_CTRL, grp);
 
-	ocelot_ifh_set_bypass(ifh, 1);
-	ocelot_ifh_set_dest(ifh, BIT_ULL(port));
-	ocelot_ifh_set_tag_type(ifh, IFH_TAG_TYPE_C);
-	ocelot_ifh_set_vlan_tci(ifh, skb_vlan_tag_get(skb));
-	ocelot_ifh_set_rew_op(ifh, rew_op);
+	ocelot_ifh_port_set(ifh, port, rew_op, skb_vlan_tag_get(skb));
 
 	for (i = 0; i < OCELOT_TAG_LEN / 4; i++)
 		ocelot_write_rix(ocelot, ifh[i], QS_INJ_WR, grp);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index fef3a36b0210..4bdaf7520fba 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -754,6 +754,7 @@ void __ocelot_target_write_ix(struct ocelot *ocelot, enum ocelot_target target,
 bool ocelot_can_inject(struct ocelot *ocelot, int grp);
 void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 			      u32 rew_op, struct sk_buff *skb);
+void ocelot_ifh_port_set(void *ifh, int port, u32 rew_op, u32 vlan_tag);
 int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **skb);
 void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp);
 
-- 
2.34.1

