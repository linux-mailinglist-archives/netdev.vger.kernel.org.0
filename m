Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5744AC94DE
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbfJBXe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:34:56 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36378 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbfJBXe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 19:34:56 -0400
Received: by mail-wm1-f66.google.com with SMTP id m18so585817wmc.1
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 16:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=hl8UETHarieeI4t2FcbAJcKHUr1QHu+lOq8qQPfuh1s=;
        b=UchHWZk8uSmE5mh3BJBChQyjs+WuMPenfIt1E6OL0iuiFHBNe+h1HYN7cGCOL7ZJns
         +r9Y/OdboxMjFN2+5hBLdXyIz+epADFZg2sZd40mCvkIBPpJUQ1PixstS48pDqDLJaWD
         Q8MjJlKDbonHlK13/2t0eGxvGWcKAfzS5LiOgjV5fF/26BMF6j8s9lhV1lc6mO6obAhx
         HylpS0VIyG0Ek+h7mYi+AYw0ehluGBLbk9ZxnlLO44JX277bJC3hTPckNLmtmJcALI3T
         tRoQCzW35rCqCZtAgXur0tjvxlQjk3VL+vmLAFnEtmE7PFzwV5jGZflEW8KXnyMw8MaW
         abKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hl8UETHarieeI4t2FcbAJcKHUr1QHu+lOq8qQPfuh1s=;
        b=R0km/jscXi3E5O7b1mZsC8KovUoRZVOaUwxBlLFKRVAueqSVx2nB0u9atC8SyS1C/u
         /wdEFDrDEuv10oWJAW+RfE6Y9hh4BPnzjLYEOAQbAFH0Rx7z2O6GtqjFqC6dE2zr11wX
         mlKpM7KiCw9SmtycPGPmau2Gm1aFDTkQNV1VE89ticNaPJrBPUqY5VIEsywJxKLJG8rK
         //cfXFwJYG2IdWjJx9aOs05dqHAiH1lR3X8aMCTCLzzAgrttrzt2pqICFqFlzhXnaMze
         wuKxbOELIuoxyCUouuAeyFwupvT8m6RHk7y3fGgCY+vGhTqARPEio1qu+Jd4vqJNgxGx
         jXhw==
X-Gm-Message-State: APjAAAUVksFVXuV80rqo6UfKhFLrNv33SG5KZ2haiOXvxI6Jw3c1Y42l
        QknCE4k1GckyACQsfD9OXjg=
X-Google-Smtp-Source: APXvYqw2slqes6LeaICjdaAtCwgBsieQBhUvp5m3hvTp/QNW1Zq5bRSZWAfzRk+3lgdRhrb0DJmwcw==
X-Received: by 2002:a05:600c:10cc:: with SMTP id l12mr4538216wmd.165.1570059293309;
        Wed, 02 Oct 2019 16:34:53 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id 26sm601451wmf.20.2019.10.02.16.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 16:34:52 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next] net: dsa: sja1105: Add support for port mirroring
Date:   Thu,  3 Oct 2019 02:34:43 +0300
Message-Id: <20191002233443.12345-1-olteanv@gmail.com>
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
 drivers/net/dsa/sja1105/sja1105_main.c | 87 ++++++++++++++++++++++++--
 1 file changed, 83 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index e95039727c1c..3795feb9177a 100644
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
@@ -2069,6 +2069,83 @@ static int sja1105_port_setup_tc(struct dsa_switch *ds, int port,
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
+			"Delete mirroring rules towards port %d first", to);
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
@@ -2102,6 +2179,8 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_rxtstamp		= sja1105_port_rxtstamp,
 	.port_txtstamp		= sja1105_port_txtstamp,
 	.port_setup_tc		= sja1105_port_setup_tc,
+	.port_mirror_add	= sja1105_mirror_add,
+	.port_mirror_del	= sja1105_mirror_del,
 };
 
 static int sja1105_check_device_id(struct sja1105_private *priv)
-- 
2.17.1

