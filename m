Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38632195F5D
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 20:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgC0T4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 15:56:11 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:34669 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727707AbgC0T4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 15:56:03 -0400
Received: by mail-wm1-f52.google.com with SMTP id 26so10918652wmk.1
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 12:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WU8fgyt/A2+RKEqo/Lk0bcP7KJgtI0/oic7Yhd6SHe8=;
        b=gqWHro9VAzg9FuyIQAuY+Q9THjnCFR2RH+t1a/75PBHnEPHAK94ZUx9lbP/5rUgMck
         F6aK4tGyoYGwEhY7xpBFH0bxZunx1HbCbwITkmNmDVheeeekjzYs+9tljOybmdBqFZq/
         prbEg3NwebIA/P386Dr9Vy8Yoyt3KxNGBMJW4s3UqD9Gt6bn+ZKoS/0bK0cor8zO66p6
         VMPdXmkaJBrmUFPI49dlyyk60UVFBLV7x6bPm66iHitxwCLIrxA/JOmnqxcv4gJxgrJy
         hIO0MV731oSezkaRYhPCcAves0jzfUBdqIEfB4n2rncXEcjztBkby2OlHEHhoiLNNu37
         ouQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WU8fgyt/A2+RKEqo/Lk0bcP7KJgtI0/oic7Yhd6SHe8=;
        b=U+PUdrCNltHFxEcK9f9Qh+DXmgl2xn7YPp9TUBt0o8PAhskQ86fT2SzdLwsV96SUZd
         NB0TXXTC65vZfxPTV6nCHbE7vsIen1/68Jn79qmnIhHrSVs4fPcMZniMw4x/DQdbY8aO
         EAJPpNd9gSasohXAkhqFeFXs2L/Ny1KlLDPTOR7s9qXIQtRnB1qB3fkfACkcg/gRsPry
         rQt2xsMoBPrFLJnMDrf12Bh/SG9YHWnYYhFNJsTLgzLs4uU9wV2jk3wMqxpiJbFM1oyw
         +svBTcW1YEG/lhSd1owkaMk28Lvjmb4lnu6+JFAjK7oxIqqs4sKtVSI9K8YXhnxabs9I
         Ri9w==
X-Gm-Message-State: ANhLgQ1mrfTNROq22Q9L7baDgv8OeuXGFETxfzo0Y83Pafdzo6kj9oAC
        oqm64YG6TybfjxvvewIGfZg1Ihx70AUcPA==
X-Google-Smtp-Source: ADFU+vuXOr6OkRX/gCnjY4z4ar7DhaWvzVFKGkmwL8ZsoPNP6Y9LUE3ZUurGd0DD4VdGt4QV8XTj0g==
X-Received: by 2002:a1c:8149:: with SMTP id c70mr358705wmd.123.1585338961819;
        Fri, 27 Mar 2020 12:56:01 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id z19sm10089479wrg.28.2020.03.27.12.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 12:56:01 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: [PATCH v4 net-next 6/8] net: dsa: sja1105: implement the port MTU callbacks
Date:   Fri, 27 Mar 2020 21:55:45 +0200
Message-Id: <20200327195547.11583-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200327195547.11583-1-olteanv@gmail.com>
References: <20200327195547.11583-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

On this switch, the frame length enforcements are performed by the
ingress policers. There are 2 types of those: regular L2 (also called
best-effort) and Virtual Link policers (an ARINC664/AFDX concept for
defining L2 streams with certain QoS abilities). To avoid future
confusion, I prefer to call the reset reason "Best-effort policers",
even though the VL policers are not yet supported.

We also need to change the setup of the initial static config, such that
DSA calls to .change_mtu (which are expensive) become no-ops and don't
reset the switch 5 times.

A driver-level decision is to unconditionally allow single VLAN-tagged
traffic on all ports. The CPU port must accept an additional VLAN header
for the DSA tag, which is again a driver-level decision.

The policers actually count bytes not only from the SDU, but also from
the Ethernet header and FCS, so those need to be accounted for as well.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v4:
None.

Changes in v3:
Now setting the ds->mtu_enforcement_ingress variable to true.

Changes in v2:
None.

 drivers/net/dsa/sja1105/sja1105.h      |  1 +
 drivers/net/dsa/sja1105/sja1105_main.c | 50 +++++++++++++++++++++++---
 2 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index a358fc89a6db..0e5b739b2fe8 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -126,6 +126,7 @@ enum sja1105_reset_reason {
 	SJA1105_RX_HWTSTAMPING,
 	SJA1105_AGEING_TIME,
 	SJA1105_SCHEDULING,
+	SJA1105_BEST_EFFORT_POLICING,
 };
 
 int sja1105_static_config_reload(struct sja1105_private *priv,
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index e0c99bb63cdf..763ae1d3bca8 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -519,12 +519,12 @@ static int sja1105_init_avb_params(struct sja1105_private *priv)
 #define SJA1105_RATE_MBPS(speed) (((speed) * 64000) / 1000)
 
 static void sja1105_setup_policer(struct sja1105_l2_policing_entry *policing,
-				  int index)
+				  int index, int mtu)
 {
 	policing[index].sharindx = index;
 	policing[index].smax = 65535; /* Burst size in bytes */
 	policing[index].rate = SJA1105_RATE_MBPS(1000);
-	policing[index].maxlen = ETH_FRAME_LEN + VLAN_HLEN + ETH_FCS_LEN;
+	policing[index].maxlen = mtu;
 	policing[index].partition = 0;
 }
 
@@ -556,12 +556,16 @@ static int sja1105_init_l2_policing(struct sja1105_private *priv)
 	 */
 	for (i = 0, k = 0; i < SJA1105_NUM_PORTS; i++) {
 		int bcast = (SJA1105_NUM_PORTS * SJA1105_NUM_TC) + i;
+		int mtu = VLAN_ETH_FRAME_LEN + ETH_FCS_LEN;
+
+		if (dsa_is_cpu_port(priv->ds, i))
+			mtu += VLAN_HLEN;
 
 		for (j = 0; j < SJA1105_NUM_TC; j++, k++)
-			sja1105_setup_policer(policing, k);
+			sja1105_setup_policer(policing, k, mtu);
 
 		/* Set up this port's policer for broadcast traffic */
-		sja1105_setup_policer(policing, bcast);
+		sja1105_setup_policer(policing, bcast, mtu);
 	}
 	return 0;
 }
@@ -1544,6 +1548,7 @@ static const char * const sja1105_reset_reasons[] = {
 	[SJA1105_RX_HWTSTAMPING] = "RX timestamping",
 	[SJA1105_AGEING_TIME] = "Ageing time",
 	[SJA1105_SCHEDULING] = "Time-aware scheduling",
+	[SJA1105_BEST_EFFORT_POLICING] = "Best-effort policing",
 };
 
 /* For situations where we need to change a setting at runtime that is only
@@ -1952,6 +1957,8 @@ static int sja1105_setup(struct dsa_switch *ds)
 	/* Advertise the 8 egress queues */
 	ds->num_tx_queues = SJA1105_NUM_TC;
 
+	ds->mtu_enforcement_ingress = true;
+
 	/* The DSA/switchdev model brings up switch ports in standalone mode by
 	 * default, and that means vlan_filtering is 0 since they're not under
 	 * a bridge, so it's safe to set up switch tagging at this time.
@@ -2120,6 +2127,39 @@ static int sja1105_set_ageing_time(struct dsa_switch *ds,
 	return sja1105_static_config_reload(priv, SJA1105_AGEING_TIME);
 }
 
+static int sja1105_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
+{
+	int bcast = (SJA1105_NUM_PORTS * SJA1105_NUM_TC) + port;
+	struct sja1105_l2_policing_entry *policing;
+	struct sja1105_private *priv = ds->priv;
+	int tc;
+
+	new_mtu += VLAN_ETH_HLEN + ETH_FCS_LEN;
+
+	if (dsa_is_cpu_port(ds, port))
+		new_mtu += VLAN_HLEN;
+
+	policing = priv->static_config.tables[BLK_IDX_L2_POLICING].entries;
+
+	/* We set all 9 port policers to the same value, so just checking the
+	 * broadcast one is fine.
+	 */
+	if (policing[bcast].maxlen == new_mtu)
+		return 0;
+
+	for (tc = 0; tc < SJA1105_NUM_TC; tc++)
+		policing[port * SJA1105_NUM_TC + tc].maxlen = new_mtu;
+
+	policing[bcast].maxlen = new_mtu;
+
+	return sja1105_static_config_reload(priv, SJA1105_BEST_EFFORT_POLICING);
+}
+
+static int sja1105_get_max_mtu(struct dsa_switch *ds, int port)
+{
+	return 2043 - VLAN_ETH_HLEN - ETH_FCS_LEN;
+}
+
 static int sja1105_port_setup_tc(struct dsa_switch *ds, int port,
 				 enum tc_setup_type type,
 				 void *type_data)
@@ -2215,6 +2255,8 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.setup			= sja1105_setup,
 	.teardown		= sja1105_teardown,
 	.set_ageing_time	= sja1105_set_ageing_time,
+	.port_change_mtu	= sja1105_change_mtu,
+	.port_max_mtu		= sja1105_get_max_mtu,
 	.phylink_validate	= sja1105_phylink_validate,
 	.phylink_mac_link_state	= sja1105_mac_pcs_get_state,
 	.phylink_mac_config	= sja1105_mac_config,
-- 
2.17.1

