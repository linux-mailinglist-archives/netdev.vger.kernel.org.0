Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79D88196D23
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 13:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbgC2Lwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 07:52:38 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41562 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728196AbgC2Lw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 07:52:26 -0400
Received: by mail-wr1-f67.google.com with SMTP id h9so17476409wrc.8;
        Sun, 29 Mar 2020 04:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GWPOe59LHIKdAmiAjeERrH01p8Y2C8a8+ZhT7kK8E5k=;
        b=XjnNuppOSguzOLkkMQkOwOm/etTpbmd/cqehuil9Ji6wl90GLnCUw0X1FvMVF7pirv
         64PhXpFqIvm5/PgfUDAp46Z/AEPUzhwj8TXF49u93qscxrgF6UZq5eSwdJw362Yx/dSB
         +ccgYRVhI1zUQgIX0UuU3EhKzIjJBvm2fEJVaI1nDRzCiKNZraRZnPINo4RDAw+3DhE5
         aCyCQtEPeM9JUdhu1eeZ0dySmfD5Aiuvpo2UFFIWJC8gkJbrWYJl9fmYVbOmR/pc8CDe
         UtQCCrNgS549wr1A+g2wyxFPXpaztm0KZofbCVzuU0GftQZpqNcEFUBRcjI4tdb3uaem
         tvew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GWPOe59LHIKdAmiAjeERrH01p8Y2C8a8+ZhT7kK8E5k=;
        b=fvLkTAGV5PGwKaPqKyb5xUJLQufTIEWNkXW7XeIFXy6aHYJdXs+ieK3b7uaa883XL8
         6UqucBg60dy2E8QiO8fdOxB/IryRTY3gwpiU1GUUIc05pO6HK//Ht17VyuZPloAYu6PP
         8zcqtJ6NQ/YQq5qhahw+UeZVW+l63MiFkFKT/WpkdQYgituVC+9P6iLl0CGAIpg7tpwC
         8BO1XruHDtvQOx5FzzcgFTw8dVVJqGNPqOao1yHStKoBxR5Nr8r+HWNnbPiHpC/kyutx
         qQ2ArKsu12jaYsXORzmPMyeRMkz+csZOvu0GuyEKp/aLecRhAu5S5fAq2OuY8TrPXZZd
         elSw==
X-Gm-Message-State: ANhLgQ3qhjdJsVTv3+LD5A/NoUKUGUMeDwsfCpEg0gxuuAQYL5q5URcL
        zqTzcS9VzAMI8C+2dZt1TmM=
X-Google-Smtp-Source: ADFU+vvb77Krof0GOdGpMm8tWTUxbCXQcp0RV7pEmviptY+xwzFDKwYI/I2ejXKD7jCr/L/Otq8j9Q==
X-Received: by 2002:adf:83c4:: with SMTP id 62mr10049559wre.105.1585482744428;
        Sun, 29 Mar 2020 04:52:24 -0700 (PDT)
Received: from localhost.localdomain (5-12-96-237.residential.rdsnet.ro. [5.12.96.237])
        by smtp.gmail.com with ESMTPSA id 5sm14424108wrs.20.2020.03.29.04.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 04:52:23 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, xiaoliang.yang_1@nxp.com,
        linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, UNGLinuxDriver@microchip.com,
        yangbo.lu@nxp.com, alexandru.marginean@nxp.com, po.liu@nxp.com,
        claudiu.manoil@nxp.com, leoyang.li@nxp.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH v2 net-next 5/6] net: dsa: sja1105: add configuration of port policers
Date:   Sun, 29 Mar 2020 14:52:01 +0300
Message-Id: <20200329115202.16348-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200329115202.16348-1-olteanv@gmail.com>
References: <20200329115202.16348-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This adds partial configuration support for the L2 Policing Table. Out
of the 45 policing entries, only 5 are used (one for each port), in a
shared manner. All 8 traffic classes, and the broadcast policer, are
redirected to a common instance which belongs to the ingress port.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 drivers/net/dsa/sja1105/sja1105_main.c | 132 +++++++++++++++++++------
 1 file changed, 100 insertions(+), 32 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 763ae1d3bca8..81d2e5e5ce96 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -516,23 +516,56 @@ static int sja1105_init_avb_params(struct sja1105_private *priv)
 	return 0;
 }
 
+/* The L2 policing table is 2-stage. The table is looked up for each frame
+ * according to the ingress port, whether it was broadcast or not, and the
+ * classified traffic class (given by VLAN PCP). This portion of the lookup is
+ * fixed, and gives access to the SHARINDX, an indirection register pointing
+ * within the policing table itself, which is used to resolve the policer that
+ * will be used for this frame.
+ *
+ *  Stage 1                              Stage 2
+ * +------------+--------+              +---------------------------------+
+ * |Port 0 TC 0 |SHARINDX|              | Policer 0: Rate, Burst, MTU     |
+ * +------------+--------+              +---------------------------------+
+ * |Port 0 TC 1 |SHARINDX|              | Policer 1: Rate, Burst, MTU     |
+ * +------------+--------+              +---------------------------------+
+ *    ...                               | Policer 2: Rate, Burst, MTU     |
+ * +------------+--------+              +---------------------------------+
+ * |Port 0 TC 7 |SHARINDX|              | Policer 3: Rate, Burst, MTU     |
+ * +------------+--------+              +---------------------------------+
+ * |Port 1 TC 0 |SHARINDX|              | Policer 4: Rate, Burst, MTU     |
+ * +------------+--------+              +---------------------------------+
+ *    ...                               | Policer 5: Rate, Burst, MTU     |
+ * +------------+--------+              +---------------------------------+
+ * |Port 1 TC 7 |SHARINDX|              | Policer 6: Rate, Burst, MTU     |
+ * +------------+--------+              +---------------------------------+
+ *    ...                               | Policer 7: Rate, Burst, MTU     |
+ * +------------+--------+              +---------------------------------+
+ * |Port 4 TC 7 |SHARINDX|                 ...
+ * +------------+--------+
+ * |Port 0 BCAST|SHARINDX|                 ...
+ * +------------+--------+
+ * |Port 1 BCAST|SHARINDX|                 ...
+ * +------------+--------+
+ *    ...                                  ...
+ * +------------+--------+              +---------------------------------+
+ * |Port 4 BCAST|SHARINDX|              | Policer 44: Rate, Burst, MTU    |
+ * +------------+--------+              +---------------------------------+
+ *
+ * In this driver, we shall use policers 0-4 as statically alocated port
+ * (matchall) policers. So we need to make the SHARINDX for all lookups
+ * corresponding to this ingress port (8 VLAN PCP lookups and 1 broadcast
+ * lookup) equal.
+ * The remaining policers (40) shall be dynamically allocated for flower
+ * policers, where the key is either vlan_prio or dst_mac ff:ff:ff:ff:ff:ff.
+ */
 #define SJA1105_RATE_MBPS(speed) (((speed) * 64000) / 1000)
 
-static void sja1105_setup_policer(struct sja1105_l2_policing_entry *policing,
-				  int index, int mtu)
-{
-	policing[index].sharindx = index;
-	policing[index].smax = 65535; /* Burst size in bytes */
-	policing[index].rate = SJA1105_RATE_MBPS(1000);
-	policing[index].maxlen = mtu;
-	policing[index].partition = 0;
-}
-
 static int sja1105_init_l2_policing(struct sja1105_private *priv)
 {
 	struct sja1105_l2_policing_entry *policing;
 	struct sja1105_table *table;
-	int i, j, k;
+	int port, tc;
 
 	table = &priv->static_config.tables[BLK_IDX_L2_POLICING];
 
@@ -551,22 +584,29 @@ static int sja1105_init_l2_policing(struct sja1105_private *priv)
 
 	policing = table->entries;
 
-	/* k sweeps through all unicast policers (0-39).
-	 * bcast sweeps through policers 40-44.
-	 */
-	for (i = 0, k = 0; i < SJA1105_NUM_PORTS; i++) {
-		int bcast = (SJA1105_NUM_PORTS * SJA1105_NUM_TC) + i;
+	/* Setup shared indices for the matchall policers */
+	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
+		int bcast = (SJA1105_NUM_PORTS * SJA1105_NUM_TC) + port;
+
+		for (tc = 0; tc < SJA1105_NUM_TC; tc++)
+			policing[port * SJA1105_NUM_TC + tc].sharindx = port;
+
+		policing[bcast].sharindx = port;
+	}
+
+	/* Setup the matchall policer parameters */
+	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
 		int mtu = VLAN_ETH_FRAME_LEN + ETH_FCS_LEN;
 
-		if (dsa_is_cpu_port(priv->ds, i))
+		if (dsa_is_cpu_port(priv->ds, port))
 			mtu += VLAN_HLEN;
 
-		for (j = 0; j < SJA1105_NUM_TC; j++, k++)
-			sja1105_setup_policer(policing, k, mtu);
-
-		/* Set up this port's policer for broadcast traffic */
-		sja1105_setup_policer(policing, bcast, mtu);
+		policing[port].smax = 65535; /* Burst size in bytes */
+		policing[port].rate = SJA1105_RATE_MBPS(1000);
+		policing[port].maxlen = mtu;
+		policing[port].partition = 0;
 	}
+
 	return 0;
 }
 
@@ -2129,10 +2169,8 @@ static int sja1105_set_ageing_time(struct dsa_switch *ds,
 
 static int sja1105_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
-	int bcast = (SJA1105_NUM_PORTS * SJA1105_NUM_TC) + port;
 	struct sja1105_l2_policing_entry *policing;
 	struct sja1105_private *priv = ds->priv;
-	int tc;
 
 	new_mtu += VLAN_ETH_HLEN + ETH_FCS_LEN;
 
@@ -2141,16 +2179,10 @@ static int sja1105_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 
 	policing = priv->static_config.tables[BLK_IDX_L2_POLICING].entries;
 
-	/* We set all 9 port policers to the same value, so just checking the
-	 * broadcast one is fine.
-	 */
-	if (policing[bcast].maxlen == new_mtu)
+	if (policing[port].maxlen == new_mtu)
 		return 0;
 
-	for (tc = 0; tc < SJA1105_NUM_TC; tc++)
-		policing[port * SJA1105_NUM_TC + tc].maxlen = new_mtu;
-
-	policing[bcast].maxlen = new_mtu;
+	policing[port].maxlen = new_mtu;
 
 	return sja1105_static_config_reload(priv, SJA1105_BEST_EFFORT_POLICING);
 }
@@ -2250,6 +2282,40 @@ static void sja1105_mirror_del(struct dsa_switch *ds, int port,
 			     mirror->ingress, false);
 }
 
+static int sja1105_port_policer_add(struct dsa_switch *ds, int port,
+				    struct dsa_mall_policer_tc_entry *policer)
+{
+	struct sja1105_l2_policing_entry *policing;
+	struct sja1105_private *priv = ds->priv;
+
+	policing = priv->static_config.tables[BLK_IDX_L2_POLICING].entries;
+
+	/* In hardware, every 8 microseconds the credit level is incremented by
+	 * the value of RATE bytes divided by 64, up to a maximum of SMAX
+	 * bytes.
+	 */
+	policing[port].rate = div_u64(512 * policer->rate_bytes_per_sec,
+				      1000000);
+	policing[port].smax = div_u64(policer->rate_bytes_per_sec *
+				      PSCHED_NS2TICKS(policer->burst),
+				      PSCHED_TICKS_PER_SEC);
+
+	return sja1105_static_config_reload(priv, SJA1105_BEST_EFFORT_POLICING);
+}
+
+static void sja1105_port_policer_del(struct dsa_switch *ds, int port)
+{
+	struct sja1105_l2_policing_entry *policing;
+	struct sja1105_private *priv = ds->priv;
+
+	policing = priv->static_config.tables[BLK_IDX_L2_POLICING].entries;
+
+	policing[port].rate = SJA1105_RATE_MBPS(1000);
+	policing[port].smax = 65535;
+
+	sja1105_static_config_reload(priv, SJA1105_BEST_EFFORT_POLICING);
+}
+
 static const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_tag_protocol	= sja1105_get_tag_protocol,
 	.setup			= sja1105_setup,
@@ -2288,6 +2354,8 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_setup_tc		= sja1105_port_setup_tc,
 	.port_mirror_add	= sja1105_mirror_add,
 	.port_mirror_del	= sja1105_mirror_del,
+	.port_policer_add	= sja1105_port_policer_add,
+	.port_policer_del	= sja1105_port_policer_del,
 };
 
 static int sja1105_check_device_id(struct sja1105_private *priv)
-- 
2.17.1

