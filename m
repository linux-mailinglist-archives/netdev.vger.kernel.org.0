Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48F1D136E2
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 03:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbfEDBTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 21:19:10 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35536 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727244AbfEDBSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 21:18:50 -0400
Received: by mail-wr1-f66.google.com with SMTP id h15so4214200wrb.2;
        Fri, 03 May 2019 18:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=u8pB9pyoxRn1MnVVmPZp2ReBr/rRxljvZbKQ55zY18M=;
        b=puSOgNxfxKKuMeEsG5MDg4++K+r2Y/aFrzVdHPxyA+UJtH+hMtbrtq4sK50pR12G/d
         QvYLiEgzRpM2L2KLMvDlxs2GNhieeqVPGljM7BTV5F147XOpE3j9Vqv6vJ8aNKQ0LXIx
         aGzZRuwuKrAZN7vUAPbLh8uPBaH47iMtEXuwB0tws5JkHFOdJUDBOJ6IGzkfRgblKSzc
         09YLegJljHf5Hw4dp/KJAtKa5u4fKEi7cXNZ0OjCpFIfjEMC95O5y5DIVWUV6D3JONyM
         m/qSNcjJvnTYcRMgVUgIKo8QxIXIsd8AxMncFwowxdwXvEEemaiULgfooY5/pA3yrzGp
         0Hzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=u8pB9pyoxRn1MnVVmPZp2ReBr/rRxljvZbKQ55zY18M=;
        b=mnFTBD1XXdC6jR/8q0uedUlHjChNCWidXGud1zKERvnj35gWgYCC1yHVZ2jMtwQwOg
         7ekkL/gKOnIjqe2vxYGUMD+7Q1SVbFTVkpOIe8vCFXySb96jCD/Cg9pPovHYHAaC5JOR
         Fiv+MWlPbkgA0SYl//WWmiZAzqioC4G5HQaJgI9i1Amv9LQ9b260pMvP+KZwruqjem6C
         5ihlA5imi6LzsjmvDe6ZeEaJocRYkqHv/i08t+7uuyJd+tqgQ+uI020dTaV7qOjMJzKf
         90vkLENWO9WhN7jHvjijTU6k8LxFmCrpGfByZL9IWtVhaGkwxJspUyFBGrU583pIJwaU
         lJ3g==
X-Gm-Message-State: APjAAAUgQiePl5hOByoj4fvEa/FYBRKXOlAZG6FTxBKUnr10tgGgbvMD
        zLI4xZL6g1Z5VfgI1h9tLHQ=
X-Google-Smtp-Source: APXvYqzCAHakxHgO/sz8j/bNwJFtGhGj0RwBJEtIlHqwtI/NXYph8HunYTw34RkoyIGfOpinc4Oq1w==
X-Received: by 2002:adf:dc08:: with SMTP id t8mr8740602wri.220.1556932727468;
        Fri, 03 May 2019 18:18:47 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id t1sm3937639wro.34.2019.05.03.18.18.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 18:18:47 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 8/9] net: dsa: sja1105: Add support for Spanning Tree Protocol
Date:   Sat,  4 May 2019 04:18:25 +0300
Message-Id: <20190504011826.30477-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190504011826.30477-1-olteanv@gmail.com>
References: <20190504011826.30477-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While not explicitly documented as supported in UM10944, compliance with
the STP states can be obtained by manipulating 3 settings at the
(per-port) MAC config level: dynamic learning, inhibiting reception of
regular traffic, and inhibiting transmission of regular traffic.

In all these modes, transmission and reception of special BPDU frames
from the stack is still enabled (not inhibited by the MAC-level
settings).

On ingress, BPDUs are classified by the MAC filter as link-local
(01-80-C2-00-00-00) and forwarded to the CPU port.  This mechanism works
under all conditions (even without the custom 802.1Q tagging) because
the switch hardware inserts the source port and switch ID into bytes 4
and 5 of the MAC-filtered frames. Then the DSA .rcv handler needs to put
back zeroes into the MAC address after decoding the source port
information.

On egress, BPDUs are transmitted using management routes from the xmit
worker thread. Again this does not require switch tagging, as the switch
port is programmed through SPI to hold a temporary (single-fire) route
for a frame with the programmed destination MAC (01-80-C2-00-00-00).

STP is activated using the following commands and was tested by
connecting two front-panel ports together and noticing that switching
loops were prevented (one port remains in the blocking state):

$ ip link add name br0 type bridge stp_state 1 && ip link set br0 up
$ for eth in $(ls /sys/devices/platform/soc/2100000.spi/spi_master/spi0/spi0.1/net/);
  do ip link set ${eth} master br0 && ip link set ${eth} up; done

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 108 ++++++++++++++++++++++---
 1 file changed, 99 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 785bb42cb993..50ff625c85d6 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -92,8 +92,10 @@ static int sja1105_init_mac_settings(struct sja1105_private *priv)
 		.drpuntag = false,
 		/* Don't retag 802.1p (VID 0) traffic with the pvid */
 		.retag = false,
-		/* Enable learning and I/O on user ports by default. */
-		.dyn_learn = true,
+		/* Disable learning and I/O on user ports by default -
+		 * STP will enable it.
+		 */
+		.dyn_learn = false,
 		.egress = false,
 		.ingress = false,
 	};
@@ -119,8 +121,17 @@ static int sja1105_init_mac_settings(struct sja1105_private *priv)
 
 	mac = table->entries;
 
-	for (i = 0; i < SJA1105_NUM_PORTS; i++)
+	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
 		mac[i] = default_mac;
+		if (i == dsa_upstream_port(priv->ds, i)) {
+			/* STP doesn't get called for CPU port, so we need to
+			 * set the I/O parameters statically.
+			 */
+			mac[i].dyn_learn = true;
+			mac[i].ingress = true;
+			mac[i].egress = true;
+		}
+	}
 
 	return 0;
 }
@@ -655,12 +666,14 @@ static sja1105_speed_t sja1105_get_speed_cfg(unsigned int speed_mbps)
  * for a specific port.
  *
  * @speed_mbps: If 0, leave the speed unchanged, else adapt MAC to PHY speed.
- * @enabled: Manage Rx and Tx settings for this port. Overrides the static
- *	     configuration settings.
+ * @enabled: Manage Rx and Tx settings for this port. If false, overrides the
+ *	     settings from the STP state, but not persistently (does not
+ *	     overwrite the static MAC info for this port).
  */
 static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 				      int speed_mbps, bool enabled)
 {
+	struct sja1105_mac_config_entry dyn_mac;
 	struct sja1105_xmii_params_entry *mii;
 	struct sja1105_mac_config_entry *mac;
 	struct device *dev = priv->ds->dev;
@@ -693,12 +706,13 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 	 * the code common, we'll use the static configuration tables as a
 	 * reasonable approximation for both E/T and P/Q/R/S.
 	 */
-	mac[port].ingress = enabled;
-	mac[port].egress  = enabled;
+	dyn_mac = mac[port];
+	dyn_mac.ingress = enabled && mac[port].ingress;
+	dyn_mac.egress  = enabled && mac[port].egress;
 
 	/* Write to the dynamic reconfiguration tables */
 	rc = sja1105_dynamic_config_write(priv, BLK_IDX_MAC_CONFIG,
-					  port, &mac[port], true);
+					  port, &dyn_mac, true);
 	if (rc < 0) {
 		dev_err(dev, "Failed to write MAC config: %d\n", rc);
 		return rc;
@@ -986,6 +1000,50 @@ static int sja1105_bridge_member(struct dsa_switch *ds, int port,
 					    port, &l2_fwd[port], true);
 }
 
+static void sja1105_bridge_stp_state_set(struct dsa_switch *ds, int port,
+					 u8 state)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_mac_config_entry *mac;
+
+	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
+
+	switch (state) {
+	case BR_STATE_DISABLED:
+	case BR_STATE_BLOCKING:
+		/* From UM10944 description of DRPDTAG (why put this there?):
+		 * "Management traffic flows to the port regardless of the state
+		 * of the INGRESS flag". So BPDUs are still be allowed to pass.
+		 * At the moment no difference between DISABLED and BLOCKING.
+		 */
+		mac[port].ingress   = false;
+		mac[port].egress    = false;
+		mac[port].dyn_learn = false;
+		break;
+	case BR_STATE_LISTENING:
+		mac[port].ingress   = true;
+		mac[port].egress    = false;
+		mac[port].dyn_learn = false;
+		break;
+	case BR_STATE_LEARNING:
+		mac[port].ingress   = true;
+		mac[port].egress    = false;
+		mac[port].dyn_learn = true;
+		break;
+	case BR_STATE_FORWARDING:
+		mac[port].ingress   = true;
+		mac[port].egress    = true;
+		mac[port].dyn_learn = true;
+		break;
+	default:
+		dev_err(ds->dev, "invalid STP state: %d\n", state);
+		return;
+	}
+
+	sja1105_dynamic_config_write(priv, BLK_IDX_MAC_CONFIG, port,
+				     &mac[port], true);
+}
+
 static int sja1105_bridge_join(struct dsa_switch *ds, int port,
 			       struct net_device *br)
 {
@@ -998,6 +1056,23 @@ static void sja1105_bridge_leave(struct dsa_switch *ds, int port,
 	sja1105_bridge_member(ds, port, br, false);
 }
 
+static u8 sja1105_stp_state_get(struct sja1105_private *priv, int port)
+{
+	struct sja1105_mac_config_entry *mac;
+
+	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
+
+	if (!mac[port].ingress && !mac[port].egress && !mac[port].dyn_learn)
+		return BR_STATE_BLOCKING;
+	if (mac[port].ingress && !mac[port].egress && !mac[port].dyn_learn)
+		return BR_STATE_LISTENING;
+	if (mac[port].ingress && !mac[port].egress && mac[port].dyn_learn)
+		return BR_STATE_LEARNING;
+	if (mac[port].ingress && mac[port].egress && mac[port].dyn_learn)
+		return BR_STATE_FORWARDING;
+	return -EINVAL;
+}
+
 /* For situations where we need to change a setting at runtime that is only
  * available through the static configuration, resetting the switch in order
  * to upload the new static config is unavoidable. Back up the settings we
@@ -1008,16 +1083,27 @@ static int sja1105_static_config_reload(struct sja1105_private *priv)
 {
 	struct sja1105_mac_config_entry *mac;
 	int speed_mbps[SJA1105_NUM_PORTS];
+	u8 stp_state[SJA1105_NUM_PORTS];
 	int rc, i;
 
 	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
 
 	/* Back up settings changed by sja1105_adjust_port_config and
-	 * and restore their defaults.
+	 * sja1105_bridge_stp_state_set and restore their defaults.
 	 */
 	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
 		speed_mbps[i] = sja1105_speed[mac[i].speed];
 		mac[i].speed = SJA1105_SPEED_AUTO;
+		if (i == dsa_upstream_port(priv->ds, i)) {
+			mac[i].ingress = true;
+			mac[i].egress = true;
+			mac[i].dyn_learn = true;
+		} else {
+			stp_state[i] = sja1105_stp_state_get(priv, i);
+			mac[i].ingress = false;
+			mac[i].egress = false;
+			mac[i].dyn_learn = false;
+		}
 	}
 
 	/* Reset switch and send updated static configuration */
@@ -1036,6 +1122,9 @@ static int sja1105_static_config_reload(struct sja1105_private *priv)
 	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
 		bool enabled = (speed_mbps[i] != 0);
 
+		if (i != dsa_upstream_port(priv->ds, i))
+			sja1105_bridge_stp_state_set(priv->ds, i, stp_state[i]);
+
 		rc = sja1105_adjust_port_config(priv, i, speed_mbps[i],
 						enabled);
 		if (rc < 0)
@@ -1433,6 +1522,7 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_fdb_del		= sja1105_fdb_del,
 	.port_bridge_join	= sja1105_bridge_join,
 	.port_bridge_leave	= sja1105_bridge_leave,
+	.port_stp_state_set	= sja1105_bridge_stp_state_set,
 	.port_vlan_prepare	= sja1105_vlan_prepare,
 	.port_vlan_filtering	= sja1105_vlan_filtering,
 	.port_vlan_add		= sja1105_vlan_add,
-- 
2.17.1

