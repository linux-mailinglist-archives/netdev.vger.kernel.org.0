Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F39D192C32
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgCYPWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:22:35 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46345 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727795AbgCYPW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 11:22:26 -0400
Received: by mail-wr1-f68.google.com with SMTP id j17so3551020wru.13
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 08:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GeVf3fQzH9gcbauzoYvkMwZZ9VMyZ4wuUQxj+oR+kpc=;
        b=VcAvgwpA1/t5Ape8rb+fn1TmvDhzaRv1pqA+mAWs9mpxuYHsOmOwGTUmsOXw8BPDdm
         iJ2X5N3Trjt/RG35f4a9y5gwqnYiQ9prpiyIgOD8tN2Yg1VMrmbXRxXvf3VdSlJEVFBu
         jrZ27Gj1Emym6eeU5MT3SqYLBQKUyF7fvZMEJeDH36rsPU4vvKP5GhbniEIZKrACqir3
         ljJrmkatKDP9UATqjaflNzP3CwuAvi8VxkB7I1Zt8RFG+wJ/eZGaIbCMauNJfFtXMdza
         YtITtuAmZziPaQY0Z7BKHtm/vhL9i916teWfU9BGS797130S+nm3SRptC1lIybSkDAdU
         wWUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GeVf3fQzH9gcbauzoYvkMwZZ9VMyZ4wuUQxj+oR+kpc=;
        b=Byp0e4IjAt2IRtyUObIxIPwCsiftC5bWpRaPkWoX6tWEur+tmwvX82ODfYAyC0a+ai
         KUF4+Tz797GQBZKDJiVIpGbOyrisT+M6YWXH0iB1EZqPU+I5CucVMHtUkXS2vxtQqTDy
         63vnw04+MbnN/tCQoTB3DCIe2iF7NsHCsmSICNV/T5einz9Q4OGz8tU9V06jJnIH17C8
         e7+eBllMJcVVXnAIhWOdygTl/VeM7yjlgfmQHEJlDEn1BXQuL6Z/Iv6m0JBy7EVIxnGm
         2G4E1GHZORzYteRknoaaV1Qkscl0NlbgLUvHRXg7ik//UG8fW23u3Z02c+Ag3l3NBrzC
         7+bg==
X-Gm-Message-State: ANhLgQ26pV3zWJSOvLx26zKMk2mVqxNOVeeenY0bf/UM3iuulpxjdz0l
        PzSaVDPL4IlHG47kt62hGXU=
X-Google-Smtp-Source: ADFU+vunwQ5d1FqsncOXncZDJgUIOWEfsQm/drbwddxH0kVTjQZOnfe938MTJxw5DpADz/UZcdqWQg==
X-Received: by 2002:adf:8165:: with SMTP id 92mr4239691wrm.217.1585149743637;
        Wed, 25 Mar 2020 08:22:23 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id n9sm6309165wru.50.2020.03.25.08.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 08:22:23 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 07/10] net: dsa: sja1105: Implement the port MTU callbacks
Date:   Wed, 25 Mar 2020 17:22:06 +0200
Message-Id: <20200325152209.3428-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200325152209.3428-1-olteanv@gmail.com>
References: <20200325152209.3428-1-olteanv@gmail.com>
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
---
 drivers/net/dsa/sja1105/sja1105.h      |  1 +
 drivers/net/dsa/sja1105/sja1105_main.c | 48 +++++++++++++++++++++++---
 2 files changed, 45 insertions(+), 4 deletions(-)

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
index e0c99bb63cdf..5f3392e5678b 100644
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
@@ -2120,6 +2125,39 @@ static int sja1105_set_ageing_time(struct dsa_switch *ds,
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
@@ -2215,6 +2253,8 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
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

