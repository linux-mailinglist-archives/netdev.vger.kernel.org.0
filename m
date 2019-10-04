Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9B1CB2CA
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 02:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729819AbfJDAd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 20:33:59 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43623 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729032AbfJDAd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 20:33:59 -0400
Received: by mail-wr1-f68.google.com with SMTP id j18so4035509wrq.10
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 17:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4UHQi6jGH10ZGm8YI9jH1RE/Bpki5qSulOVKRpBmNGw=;
        b=MbkBsKdaKm5uARmmmRIG66vHWjrGoDP3wEM0ZSRmyB5/rF2FirDAH7L0N4MYo/ov/7
         vOmDOt7XsfvEulAGKnARELZ0tMueA/xNXTUsd03st6RAktuVfgHpQRacmi57DrzYTwR3
         49CryozCcQ1Ts01k/VVFJRc04kJgFpikSBmcCZyr5AL52PnF3YB4ow/lTsbWccg8c+OL
         ZWylRs0uCd8bBROuatDpyHC8z8sFzmS2R8Fyv2V6NBlbZe1q0s5OX0wFQYK2b7qR2yPS
         UCGCi63J/7XearMokQhQj1x3d0qJyTuv1GacGW97syzNp05yigMYPXr/XD86E6i01RzJ
         nvqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4UHQi6jGH10ZGm8YI9jH1RE/Bpki5qSulOVKRpBmNGw=;
        b=Cy/lPVDtpHnQvO5/Kb5toxcoyIoUJrGxSug54KaZ6eN6PgrNO/ISuIrE7+Wki+6OvE
         2g+XfTFUn/oDV37tipq9PQzyoW6FBFOHQuoKe6K2fyPH/BJWS65paRLcaww8Uis5TR7v
         FIqozF5gZ3Of8vK/D/Fgq1PLMtv42JvCwhaGGmKPAVrytxV1WLPqFM52txuby4HFIaTW
         PgbESelSaPhithb51gbWkAx4VfxxXy3A0WDYGjjOR3wVCpQzrohRF4D2DiRM+aZ93lVT
         vec/KtAWNGdP3JB544ABgo+pPuCj8gD2nHF6ZFMnHg3GsyRgyDj8QTE/TRax0GKERD+S
         ZDBg==
X-Gm-Message-State: APjAAAWn2MRa5m4SL7Z3+3ycJlrbl7V8XHp99GKngkpyWiP26putopJb
        PLUsbIhUGijI+s5yra5PSHg=
X-Google-Smtp-Source: APXvYqzJQZANofXtqxNd9bKKXy+QLxoanF83yS0lM6SO+7iFkb1qs1sV/flYiw5FnYwz9XAQebP+pw==
X-Received: by 2002:adf:fa0e:: with SMTP id m14mr4511025wrr.11.1570149236187;
        Thu, 03 Oct 2019 17:33:56 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id a2sm5231660wrp.11.2019.10.03.17.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 17:33:55 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next] net: dsa: sja1105: Add support for port mirroring
Date:   Fri,  4 Oct 2019 03:33:47 +0300
Message-Id: <20191004003347.17523-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amazingly, of all features, this does not require a switch reset.

Tested with:

tc qdisc add dev swp2 clsact
tc filter add dev swp2 ingress matchall skip_sw \
	action mirred egress mirror dev swp3
tc filter show dev swp2 ingress
tc filter del dev swp2 ingress pref 49152

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v2:
- Reworked the error message to print the mirror port correctly.

 drivers/net/dsa/sja1105/sja1105_main.c | 88 ++++++++++++++++++++++++--
 1 file changed, 84 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index e95039727c1c..06fcd45a6099 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -382,8 +382,8 @@ static int sja1105_init_l2_forwarding_params(struct sja1105_private *priv)
 static int sja1105_init_general_params(struct sja1105_private *priv)
 {
 	struct sja1105_general_params_entry default_general_params = {
-		/* Disallow dynamic changing of the mirror port */
-		.mirr_ptacu = 0,
+		/* Allow dynamic changing of the mirror port */
+		.mirr_ptacu = true,
 		.switchid = priv->ds->index,
 		/* Priority queue for link-local management frames
 		 * (both ingress to and egress from CPU - PTP, STP etc)
@@ -403,8 +403,8 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		 * by installing a temporary 'management route'
 		 */
 		.host_port = dsa_upstream_port(priv->ds, 0),
-		/* Same as host port */
-		.mirr_port = dsa_upstream_port(priv->ds, 0),
+		/* Default to an invalid value */
+		.mirr_port = SJA1105_NUM_PORTS,
 		/* Link-local traffic received on casc_port will be forwarded
 		 * to host_port without embedding the source port and device ID
 		 * info in the destination MAC address (presumably because it
@@ -2069,6 +2069,84 @@ static int sja1105_port_setup_tc(struct dsa_switch *ds, int port,
 	}
 }
 
+/* We have a single mirror (@to) port, but can configure ingress and egress
+ * mirroring on all other (@from) ports.
+ * We need to allow mirroring rules only as long as the @to port is always the
+ * same, and we need to unset the @to port from mirr_port only when there is no
+ * mirroring rule that references it.
+ */
+static int sja1105_mirror_apply(struct sja1105_private *priv, int from, int to,
+				bool ingress, bool enabled)
+{
+	struct sja1105_general_params_entry *general_params;
+	struct sja1105_mac_config_entry *mac;
+	struct sja1105_table *table;
+	bool already_enabled;
+	u64 new_mirr_port;
+	int rc;
+
+	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
+	general_params = table->entries;
+
+	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
+
+	already_enabled = (general_params->mirr_port != SJA1105_NUM_PORTS);
+	if (already_enabled && enabled && general_params->mirr_port != to) {
+		dev_err(priv->ds->dev,
+			"Delete mirroring rules towards port %llu first\n",
+			general_params->mirr_port);
+		return -EBUSY;
+	}
+
+	new_mirr_port = to;
+	if (!enabled) {
+		bool keep = false;
+		int port;
+
+		/* Anybody still referencing mirr_port? */
+		for (port = 0; port < SJA1105_NUM_PORTS; port++) {
+			if (mac[port].ing_mirr || mac[port].egr_mirr) {
+				keep = true;
+				break;
+			}
+		}
+		/* Unset already_enabled for next time */
+		if (!keep)
+			new_mirr_port = SJA1105_NUM_PORTS;
+	}
+	if (new_mirr_port != general_params->mirr_port) {
+		general_params->mirr_port = new_mirr_port;
+
+		rc = sja1105_dynamic_config_write(priv, BLK_IDX_GENERAL_PARAMS,
+						  0, general_params, true);
+		if (rc < 0)
+			return rc;
+	}
+
+	if (ingress)
+		mac[from].ing_mirr = enabled;
+	else
+		mac[from].egr_mirr = enabled;
+
+	return sja1105_dynamic_config_write(priv, BLK_IDX_MAC_CONFIG, from,
+					    &mac[from], true);
+}
+
+static int sja1105_mirror_add(struct dsa_switch *ds, int port,
+			      struct dsa_mall_mirror_tc_entry *mirror,
+			      bool ingress)
+{
+	return sja1105_mirror_apply(ds->priv, port, mirror->to_local_port,
+				    ingress, true);
+}
+
+static void sja1105_mirror_del(struct dsa_switch *ds, int port,
+			       struct dsa_mall_mirror_tc_entry *mirror)
+{
+	sja1105_mirror_apply(ds->priv, port, mirror->to_local_port,
+			     mirror->ingress, false);
+}
+
 static const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_tag_protocol	= sja1105_get_tag_protocol,
 	.setup			= sja1105_setup,
@@ -2102,6 +2180,8 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_rxtstamp		= sja1105_port_rxtstamp,
 	.port_txtstamp		= sja1105_port_txtstamp,
 	.port_setup_tc		= sja1105_port_setup_tc,
+	.port_mirror_add	= sja1105_mirror_add,
+	.port_mirror_del	= sja1105_mirror_del,
 };
 
 static int sja1105_check_device_id(struct sja1105_private *priv)
-- 
2.17.1

