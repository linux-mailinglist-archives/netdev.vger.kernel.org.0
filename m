Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E047046B6B9
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 10:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbhLGJOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 04:14:15 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51191 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233506AbhLGJON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 04:14:13 -0500
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 6E5C3E0008;
        Tue,  7 Dec 2021 09:10:41 +0000 (UTC)
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
Subject: [PATCH net-next v5 1/4] net: ocelot: export ocelot_ifh_port_set() to setup IFH
Date:   Tue,  7 Dec 2021 10:08:50 +0100
Message-Id: <20211207090853.308328-2-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211207090853.308328-1-clement.leger@bootlin.com>
References: <20211207090853.308328-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FDMA will need this code to prepare the injection frame header when
sending SKBs. Move this code into ocelot_ifh_port_set() and add
conditional IFH setting for vlan and rew op if they are not set.

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 18 +++++++++++++-----
 include/soc/mscc/ocelot.h          |  1 +
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index b1856d8c944b..b5ec8ce7f4dd 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1164,6 +1164,18 @@ bool ocelot_can_inject(struct ocelot *ocelot, int grp)
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
@@ -1173,11 +1185,7 @@ void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
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
index 33f2e8c9e88b..9b99cfd39a59 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -794,6 +794,7 @@ void __ocelot_target_write_ix(struct ocelot *ocelot, enum ocelot_target target,
 bool ocelot_can_inject(struct ocelot *ocelot, int grp);
 void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 			      u32 rew_op, struct sk_buff *skb);
+void ocelot_ifh_port_set(void *ifh, int port, u32 rew_op, u32 vlan_tag);
 int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **skb);
 void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp);
 
-- 
2.34.1

