Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E260410802C
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 20:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfKWTtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 14:49:41 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40218 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfKWTtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 14:49:41 -0500
Received: by mail-wr1-f65.google.com with SMTP id 4so9334993wro.7
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 11:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vwQMLl7gobZyvlR/Z6qjQAhUVz61ZBqI+5QriW89Mn0=;
        b=DJBKHwdQQaLX67QnsuOZLmVi4kD8T61o1VCtWEQMNF0FzHaYDdIIpXr2OU8wv/R1KL
         6NhPXtWU0Kcg2ViA21W8A2cOTAwca5AsSxgYBxnWAPOAF+H2Prw4KxDNHTywDdgQNGSu
         wnkGDfLdsEIYqBFZtbr2IV++zs9HNcBhNTdVzCzva+fD1ohU1k8jLAumrfQ+qrIqYRS4
         LXZWR1h6WjsdcRIfAwhtPNItNAhjCjidDgGzKadM2i6aI+7kSBRiFNDmmt6mjq80XcIA
         T/VNpQdpIncIaDTxLRSwgdiXU2UUKbG6f7aBSTxebPD5sO4XQ+/AYuyKDsErzaqpvgeA
         H8Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vwQMLl7gobZyvlR/Z6qjQAhUVz61ZBqI+5QriW89Mn0=;
        b=SsjeZs4Av9Cgc6UU9JJu0japvlhuH6V4RTlCdc8qXUu4YDm0wBhOiyc7s1LZJSFjtn
         KmJxWqxzp09T7DBP03erwnQ5Cg7qPtkI5JaWRtzIEbvtqWw3Lt7gIDKnNeARiktuk3Ph
         3TY/Pg1JYw6k/VXjtvuMVKf/crT5khgNXYqxQYk+amhpHoyxGFUgdCB/x9YLpQrBIhi+
         PleVwaBkfg5DK+v7rlvlsuz3SvdeAmNCSP9348pZrAuf/pB457GDAIdIquTIVzTzJsSR
         vFdHAX+aP2Sz4zFE5aIc4V3qsowNCFwi17QA/4oxIl+NXWnbzEIQ0Ihr+t06Sp/pCd2s
         ZUpw==
X-Gm-Message-State: APjAAAXJOxcWvl12W0PEV4oqjMul2wkBBxMhuIzI/wpoftSQTKJtwWZP
        shGul4YwuIIblWenFx9EaW6lWyP+
X-Google-Smtp-Source: APXvYqwEb81YHRD2ucNIlKI3kuNu0Cztv4Yc0TwUyxEuxMJ71wRyQOREdXiAGbGfmOBd7tFUEPlU5Q==
X-Received: by 2002:adf:f344:: with SMTP id e4mr24117652wrp.365.1574538578441;
        Sat, 23 Nov 2019 11:49:38 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id j10sm3300569wrx.30.2019.11.23.11.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 11:49:37 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 2/3] net: dsa: sja1105: Implement the port MTU callbacks
Date:   Sat, 23 Nov 2019 21:48:43 +0200
Message-Id: <20191123194844.9508-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191123194844.9508-1-olteanv@gmail.com>
References: <20191123194844.9508-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |  1 +
 drivers/net/dsa/sja1105/sja1105_main.c | 48 +++++++++++++++++++++++---
 2 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index d801fc204d19..3a5c8acb6e2a 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -122,6 +122,7 @@ enum sja1105_reset_reason {
 	SJA1105_RX_HWTSTAMPING,
 	SJA1105_AGEING_TIME,
 	SJA1105_SCHEDULING,
+	SJA1105_BEST_EFFORT_POLICING,
 };
 
 int sja1105_static_config_reload(struct sja1105_private *priv,
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b60224c55244..3d55dd3c7e83 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -459,12 +459,12 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
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
 
@@ -496,12 +496,16 @@ static int sja1105_init_l2_policing(struct sja1105_private *priv)
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
@@ -1346,6 +1350,7 @@ static const char * const sja1105_reset_reasons[] = {
 	[SJA1105_RX_HWTSTAMPING] = "RX timestamping",
 	[SJA1105_AGEING_TIME] = "Ageing time",
 	[SJA1105_SCHEDULING] = "Time-aware scheduling",
+	[SJA1105_BEST_EFFORT_POLICING] = "Best-effort policing",
 };
 
 /* For situations where we need to change a setting at runtime that is only
@@ -1886,6 +1891,39 @@ static int sja1105_set_ageing_time(struct dsa_switch *ds,
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
@@ -1981,6 +2019,8 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.setup			= sja1105_setup,
 	.teardown		= sja1105_teardown,
 	.set_ageing_time	= sja1105_set_ageing_time,
+	.change_mtu		= sja1105_change_mtu,
+	.get_max_mtu		= sja1105_get_max_mtu,
 	.phylink_validate	= sja1105_phylink_validate,
 	.phylink_mac_config	= sja1105_mac_config,
 	.phylink_mac_link_up	= sja1105_mac_link_up,
-- 
2.17.1

