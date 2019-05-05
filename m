Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAAE91426A
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 23:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbfEEVPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 17:15:50 -0400
Received: from mx2.mailbox.org ([80.241.60.215]:29010 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbfEEVPt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 17:15:49 -0400
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx2.mailbox.org (Postfix) with ESMTPS id C1538A0130;
        Sun,  5 May 2019 23:15:47 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id fjD0nuCexfgg; Sun,  5 May 2019 23:15:38 +0200 (CEST)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 5/5] net: dsa: lantiq: Add Forwarding Database access
Date:   Sun,  5 May 2019 23:15:17 +0200
Message-Id: <20190505211517.25237-6-hauke@hauke-m.de>
In-Reply-To: <20190505211517.25237-1-hauke@hauke-m.de>
References: <20190505211517.25237-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds functions to add and remove static entries to and from the
forwarding database and dump the full forwarding database.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/dsa/lantiq_gswip.c | 98 ++++++++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 7ce6f92650f4..96c3035c7e0c 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1289,6 +1289,101 @@ static void gswip_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 			  GSWIP_PCE_PCTRL_0p(port));
 }
 
+static int gswip_port_fdb(struct dsa_switch *ds, int port,
+			  const unsigned char *addr, u16 vid, bool add)
+{
+	struct gswip_priv *priv = ds->priv;
+	struct net_device *bridge = dsa_to_port(ds, port)->bridge_dev;
+	struct gswip_pce_table_entry mac_bridge = {0,};
+	unsigned int cpu_port = priv->hw_info->cpu_port;
+	int fid = -1;
+	int i;
+	int err;
+
+	if (!bridge)
+		return -EINVAL;
+
+	for (i = cpu_port; i < ARRAY_SIZE(priv->vlans); i++) {
+		if (priv->vlans[i].bridge == bridge) {
+			fid = priv->vlans[i].fid;
+			break;
+		}
+	}
+
+	if (fid == -1) {
+		dev_err(priv->dev, "Port not part of a bridge\n");
+		return -EINVAL;
+	}
+
+	mac_bridge.table = 0x0b;
+	mac_bridge.key_mode = true;
+	mac_bridge.key[0] = addr[5] | (addr[4] << 8);
+	mac_bridge.key[1] = addr[3] | (addr[2] << 8);
+	mac_bridge.key[2] = addr[1] | (addr[0] << 8);
+	mac_bridge.key[3] = fid;
+	mac_bridge.val[0] = add ? BIT(port) : 0; /* port map */
+	mac_bridge.val[1] = 0x01; /* static entry */
+	mac_bridge.valid = add;
+
+	err = gswip_pce_table_entry_write(priv, &mac_bridge);
+	if (err)
+		dev_err(priv->dev, "failed to write mac brigde: %d\n", err);
+
+	return err;
+}
+
+static int gswip_port_fdb_add(struct dsa_switch *ds, int port,
+			      const unsigned char *addr, u16 vid)
+{
+	return gswip_port_fdb(ds, port, addr, vid, true);
+}
+
+static int gswip_port_fdb_del(struct dsa_switch *ds, int port,
+			      const unsigned char *addr, u16 vid)
+{
+	return gswip_port_fdb(ds, port, addr, vid, false);
+}
+
+static int gswip_port_fdb_dump(struct dsa_switch *ds, int port,
+			       dsa_fdb_dump_cb_t *cb, void *data)
+{
+	struct gswip_priv *priv = ds->priv;
+	struct gswip_pce_table_entry mac_bridge = {0,};
+	unsigned char addr[6];
+	int i;
+	int err;
+
+	for (i = 0; i < 2048; i++) {
+		mac_bridge.table = 0x0b;
+		mac_bridge.index = i;
+
+		err = gswip_pce_table_entry_read(priv, &mac_bridge);
+		if (err) {
+			dev_err(priv->dev, "failed to write mac brigde: %d\n",
+				err);
+			return err;
+		}
+
+		if (!mac_bridge.valid)
+			continue;
+
+		addr[5] = mac_bridge.key[0] & 0xff;
+		addr[4] = (mac_bridge.key[0] >> 8) & 0xff;
+		addr[3] = mac_bridge.key[1] & 0xff;
+		addr[2] = (mac_bridge.key[1] >> 8) & 0xff;
+		addr[1] = mac_bridge.key[2] & 0xff;
+		addr[0] = (mac_bridge.key[2] >> 8) & 0xff;
+		if (mac_bridge.val[1] & 0x01) {
+			if (mac_bridge.val[0] & BIT(port))
+				cb(addr, 0, true, data);
+		} else {
+			if (((mac_bridge.val[0] & GENMASK(7, 4)) >> 4) == port)
+				cb(addr, 0, false, data);
+		}
+	}
+	return 0;
+}
+
 static void gswip_phylink_validate(struct dsa_switch *ds, int port,
 				   unsigned long *supported,
 				   struct phylink_link_state *state)
@@ -1504,6 +1599,9 @@ static const struct dsa_switch_ops gswip_switch_ops = {
 	.port_vlan_add		= gswip_port_vlan_add,
 	.port_vlan_del		= gswip_port_vlan_del,
 	.port_stp_state_set	= gswip_port_stp_state_set,
+	.port_fdb_add		= gswip_port_fdb_add,
+	.port_fdb_del		= gswip_port_fdb_del,
+	.port_fdb_dump		= gswip_port_fdb_dump,
 	.phylink_validate	= gswip_phylink_validate,
 	.phylink_mac_config	= gswip_phylink_mac_config,
 	.phylink_mac_link_down	= gswip_phylink_mac_link_down,
-- 
2.20.1

