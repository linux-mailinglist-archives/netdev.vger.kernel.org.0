Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B44A71426C
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 23:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbfEEVPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 17:15:54 -0400
Received: from mx2.mailbox.org ([80.241.60.215]:29094 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727765AbfEEVPx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 17:15:53 -0400
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx2.mailbox.org (Postfix) with ESMTPS id A95A9A0172;
        Sun,  5 May 2019 23:15:51 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id FonkmvfPwgiD; Sun,  5 May 2019 23:15:38 +0200 (CEST)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 4/5] net: dsa: lantiq: Add fast age function
Date:   Sun,  5 May 2019 23:15:16 +0200
Message-Id: <20190505211517.25237-5-hauke@hauke-m.de>
In-Reply-To: <20190505211517.25237-1-hauke@hauke-m.de>
References: <20190505211517.25237-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fast aging per port is not supported directly by the hardware, it is
only possible to configure a global aging time.

Do the fast aging by iterating over the MAC forwarding table and remove
all dynamic entries for a given port.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/dsa/lantiq_gswip.c | 38 ++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index c6864fc301f9..7ce6f92650f4 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1221,6 +1221,43 @@ static int gswip_port_vlan_del(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static void gswip_port_fast_age(struct dsa_switch *ds, int port)
+{
+	struct gswip_priv *priv = ds->priv;
+	struct gswip_pce_table_entry mac_bridge = {0,};
+	int i;
+	int err;
+
+	for (i = 0; i < 2048; i++) {
+		mac_bridge.table = GSWIP_TABLE_MAC_BRIDGE;
+		mac_bridge.index = i;
+
+		err = gswip_pce_table_entry_read(priv, &mac_bridge);
+		if (err) {
+			dev_err(priv->dev, "failed to read mac brigde: %d\n",
+				err);
+			return;
+		}
+
+		if (!mac_bridge.valid)
+			continue;
+
+		if (mac_bridge.val[1] & 0x01)
+			continue;
+
+		if (((mac_bridge.val[0] & GENMASK(7, 4)) >> 4) != port)
+			continue;
+
+		mac_bridge.valid = false;
+		err = gswip_pce_table_entry_write(priv, &mac_bridge);
+		if (err) {
+			dev_err(priv->dev, "failed to write mac brigde: %d\n",
+				err);
+			return;
+		}
+	}
+}
+
 static void gswip_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 {
 	struct gswip_priv *priv = ds->priv;
@@ -1461,6 +1498,7 @@ static const struct dsa_switch_ops gswip_switch_ops = {
 	.port_disable		= gswip_port_disable,
 	.port_bridge_join	= gswip_port_bridge_join,
 	.port_bridge_leave	= gswip_port_bridge_leave,
+	.port_fast_age		= gswip_port_fast_age,
 	.port_vlan_filtering	= gswip_port_vlan_filtering,
 	.port_vlan_prepare	= gswip_port_vlan_prepare,
 	.port_vlan_add		= gswip_port_vlan_add,
-- 
2.20.1

