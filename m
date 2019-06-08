Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFB7E39FCC
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 15:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbfFHND6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 09:03:58 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40728 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727204AbfFHND4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 09:03:56 -0400
Received: by mail-wr1-f66.google.com with SMTP id p11so4748952wre.7
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 06:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=39QNo9ECHkyXqHs4cTZCq8XeZ66f1WCzkbq6hIAJpWI=;
        b=Zt2pvhAJDapQMr+PbTvSpM03OKAxnjuXBrrk1/9ohuq/7kULtT9s7s3cOyxAMyGfhB
         sEXhdqNMIpjsEicTie7vpCBZaHlJ9SNj7K80HavTWipMFWC5wgvZjw/18OcO9usfdajt
         B7Z4wsCPgXMFaH6Cbpa3lTrNMy5AUDdy0qpfCL7mEUGXHBdueE0QS0O0dGO1U53DjBbx
         bfOKt33alGvHwjTB6BE6ZpRahdyBI5frSiUVgA4uyo4HhGmyhYSaFtiKhdNPQcWnDNNl
         TsFvUAPvP6K7Ui05xw+oxPgKxuKUGiORUkR9KGQYZ5cmgjVQdyS33ruOGukHIrU9psmr
         +GDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=39QNo9ECHkyXqHs4cTZCq8XeZ66f1WCzkbq6hIAJpWI=;
        b=UI8oK+PwErRCQTLuYoRpSNr2QytZbG+EnUjrwZNYJakRrvx65ptOVi+xxuFfCRpKLK
         njGIIPWgoqrUkHjoZGZfk65s64+miiEIjVFZGs7MaUWIMWl3GbIjYsRBjXoec1mRR+VN
         rQf5lqzx0UV3KuV21rVZPhNefov1TLr+ur0ar/HNBfoLN+Bz/8ssFQ44x5iSowDwjrAo
         59fIEgi/eIQfxsaIivy4W9L07i8GtIhSBLfLvM5jh1KCKUKpnbIhivfZZ1UXrXYEcBjU
         sMaGq6jSd7G+q3GWpHB9J2QW81p6bfQo6x3JKt4/JBnLJhBjejOAciI5AhBb0VEKRSTM
         4jNA==
X-Gm-Message-State: APjAAAXd6G666dr/v5gV+0fWc0LkUqObwadujhZEtlPi3a6SRkIoefa5
        kff+mYVosOEXHuiy9XGE82Z+njwwf8w=
X-Google-Smtp-Source: APXvYqz/uKpD6Z7F86lW2TepJvwUwev26c87sxeYnDhizvBbArXv0KSiP2TJb1RtIwLHZ4iAoJaXiA==
X-Received: by 2002:a5d:6709:: with SMTP id o9mr24073523wru.301.1559999034235;
        Sat, 08 Jun 2019 06:03:54 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id 128sm4632766wme.12.2019.06.08.06.03.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 06:03:53 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 4/4] net: dsa: sja1105: Rethink the PHYLINK callbacks
Date:   Sat,  8 Jun 2019 16:03:44 +0300
Message-Id: <20190608130344.661-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190608130344.661-1-olteanv@gmail.com>
References: <20190608130344.661-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first fact that needs to be stated is that the per-MAC settings in
SJA1105 called EGRESS and INGRESS do *not* disable egress and ingress on
the MAC. They only prevent non-link-local traffic from being
sent/received on this port.

So instead of having .phylink_mac_config essentially mess with the STP
state and force it to DISABLED/BLOCKING (which also brings useless
complications in sja1105_static_config_reload), simply add the
.phylink_mac_link_down and .phylink_mac_link_up callbacks which inhibit
TX at the MAC level, while leaving RX essentially enabled.

Also stop from trying to put the link down in .phylink_mac_config, which
is incorrect.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 114 +++++++++----------------
 1 file changed, 40 insertions(+), 74 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index d7f4dbfdb15d..56b357a421de 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -695,18 +695,10 @@ static int sja1105_speed[] = {
 	[SJA1105_SPEED_1000MBPS]	= SPEED_1000,
 };
 
-/* Set link speed and enable/disable traffic I/O in the MAC configuration
- * for a specific port.
- *
- * @speed_mbps: If 0, leave the speed unchanged, else adapt MAC to PHY speed.
- * @enabled: Manage Rx and Tx settings for this port. If false, overrides the
- *	     settings from the STP state, but not persistently (does not
- *	     overwrite the static MAC info for this port).
- */
+/* Set link speed in the MAC configuration for a specific port. */
 static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
-				      int speed_mbps, bool enabled)
+				      int speed_mbps)
 {
-	struct sja1105_mac_config_entry dyn_mac;
 	struct sja1105_xmii_params_entry *mii;
 	struct sja1105_mac_config_entry *mac;
 	struct device *dev = priv->ds->dev;
@@ -714,8 +706,14 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 	sja1105_speed_t speed;
 	int rc;
 
-	mii = priv->static_config.tables[BLK_IDX_XMII_PARAMS].entries;
+	/* On P/Q/R/S, one can read from the device via the MAC reconfiguration
+	 * tables. On E/T, MAC reconfig tables are not readable, only writable.
+	 * We have to *know* what the MAC looks like.  For the sake of keeping
+	 * the code common, we'll use the static configuration tables as a
+	 * reasonable approximation for both E/T and P/Q/R/S.
+	 */
 	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
+	mii = priv->static_config.tables[BLK_IDX_XMII_PARAMS].entries;
 
 	switch (speed_mbps) {
 	case SPEED_UNKNOWN:
@@ -736,26 +734,16 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 		return -EINVAL;
 	}
 
-	/* If requested, overwrite SJA1105_SPEED_AUTO from the static MAC
-	 * configuration table, since this will be used for the clocking setup,
-	 * and we no longer need to store it in the static config (already told
-	 * hardware we want auto during upload phase).
+	/* Overwrite SJA1105_SPEED_AUTO from the static MAC configuration
+	 * table, since this will be used for the clocking setup, and we no
+	 * longer need to store it in the static config (already told hardware
+	 * we want auto during upload phase).
 	 */
 	mac[port].speed = speed;
 
-	/* On P/Q/R/S, one can read from the device via the MAC reconfiguration
-	 * tables. On E/T, MAC reconfig tables are not readable, only writable.
-	 * We have to *know* what the MAC looks like.  For the sake of keeping
-	 * the code common, we'll use the static configuration tables as a
-	 * reasonable approximation for both E/T and P/Q/R/S.
-	 */
-	dyn_mac = mac[port];
-	dyn_mac.ingress = enabled && mac[port].ingress;
-	dyn_mac.egress  = enabled && mac[port].egress;
-
 	/* Write to the dynamic reconfiguration tables */
-	rc = sja1105_dynamic_config_write(priv, BLK_IDX_MAC_CONFIG,
-					  port, &dyn_mac, true);
+	rc = sja1105_dynamic_config_write(priv, BLK_IDX_MAC_CONFIG, port,
+					  &mac[port], true);
 	if (rc < 0) {
 		dev_err(dev, "Failed to write MAC config: %d\n", rc);
 		return rc;
@@ -767,9 +755,6 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 	 * the clock setup does interrupt the clock signal for a certain time
 	 * which causes trouble for all PHYs relying on this signal.
 	 */
-	if (!enabled)
-		return 0;
-
 	phy_mode = mii->xmii_mode[port];
 	if (phy_mode != XMII_MODE_RGMII)
 		return 0;
@@ -784,9 +769,24 @@ static void sja1105_mac_config(struct dsa_switch *ds, int port,
 	struct sja1105_private *priv = ds->priv;
 
 	if (!state->link)
-		sja1105_adjust_port_config(priv, port, SPEED_UNKNOWN, false);
-	else
-		sja1105_adjust_port_config(priv, port, state->speed, true);
+		return;
+
+	sja1105_adjust_port_config(priv, port, state->speed);
+}
+
+static void sja1105_mac_link_down(struct dsa_switch *ds, int port,
+				  unsigned int mode,
+				  phy_interface_t interface)
+{
+	sja1105_inhibit_tx(ds->priv, BIT(port), true);
+}
+
+static void sja1105_mac_link_up(struct dsa_switch *ds, int port,
+				unsigned int mode,
+				phy_interface_t interface,
+				struct phy_device *phydev)
+{
+	sja1105_inhibit_tx(ds->priv, BIT(port), false);
 }
 
 static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
@@ -1241,27 +1241,6 @@ static void sja1105_bridge_leave(struct dsa_switch *ds, int port,
 	sja1105_bridge_member(ds, port, br, false);
 }
 
-static u8 sja1105_stp_state_get(struct sja1105_private *priv, int port)
-{
-	struct sja1105_mac_config_entry *mac;
-
-	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
-
-	if (!mac[port].ingress && !mac[port].egress && !mac[port].dyn_learn)
-		return BR_STATE_BLOCKING;
-	if (mac[port].ingress && !mac[port].egress && !mac[port].dyn_learn)
-		return BR_STATE_LISTENING;
-	if (mac[port].ingress && !mac[port].egress && mac[port].dyn_learn)
-		return BR_STATE_LEARNING;
-	if (mac[port].ingress && mac[port].egress && mac[port].dyn_learn)
-		return BR_STATE_FORWARDING;
-	/* This is really an error condition if the MAC was in none of the STP
-	 * states above. But treating the port as disabled does nothing, which
-	 * is adequate, and it also resets the MAC to a known state later on.
-	 */
-	return BR_STATE_DISABLED;
-}
-
 /* For situations where we need to change a setting at runtime that is only
  * available through the static configuration, resetting the switch in order
  * to upload the new static config is unavoidable. Back up the settings we
@@ -1272,27 +1251,18 @@ static int sja1105_static_config_reload(struct sja1105_private *priv)
 {
 	struct sja1105_mac_config_entry *mac;
 	int speed_mbps[SJA1105_NUM_PORTS];
-	u8 stp_state[SJA1105_NUM_PORTS];
 	int rc, i;
 
 	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
 
-	/* Back up settings changed by sja1105_adjust_port_config and
-	 * sja1105_bridge_stp_state_set and restore their defaults.
+	/* Back up the dynamic link speed changed by sja1105_adjust_port_config
+	 * in order to temporarily restore it to SJA1105_SPEED_AUTO - which the
+	 * switch wants to see in the static config in order to allow us to
+	 * change it through the dynamic interface later.
 	 */
 	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
 		speed_mbps[i] = sja1105_speed[mac[i].speed];
 		mac[i].speed = SJA1105_SPEED_AUTO;
-		if (i == dsa_upstream_port(priv->ds, i)) {
-			mac[i].ingress = true;
-			mac[i].egress = true;
-			mac[i].dyn_learn = true;
-		} else {
-			stp_state[i] = sja1105_stp_state_get(priv, i);
-			mac[i].ingress = false;
-			mac[i].egress = false;
-			mac[i].dyn_learn = false;
-		}
 	}
 
 	/* Reset switch and send updated static configuration */
@@ -1309,13 +1279,7 @@ static int sja1105_static_config_reload(struct sja1105_private *priv)
 		goto out;
 
 	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
-		bool enabled = (speed_mbps[i] != SPEED_UNKNOWN);
-
-		if (i != dsa_upstream_port(priv->ds, i))
-			sja1105_bridge_stp_state_set(priv->ds, i, stp_state[i]);
-
-		rc = sja1105_adjust_port_config(priv, i, speed_mbps[i],
-						enabled);
+		rc = sja1105_adjust_port_config(priv, i, speed_mbps[i]);
 		if (rc < 0)
 			goto out;
 	}
@@ -1933,6 +1897,8 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.set_ageing_time	= sja1105_set_ageing_time,
 	.phylink_validate	= sja1105_phylink_validate,
 	.phylink_mac_config	= sja1105_mac_config,
+	.phylink_mac_link_up	= sja1105_mac_link_up,
+	.phylink_mac_link_down	= sja1105_mac_link_down,
 	.get_strings		= sja1105_get_strings,
 	.get_ethtool_stats	= sja1105_get_ethtool_stats,
 	.get_sset_count		= sja1105_get_sset_count,
-- 
2.17.1

