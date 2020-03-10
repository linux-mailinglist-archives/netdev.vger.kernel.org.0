Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC4017EE00
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgCJB2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:28:40 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39786 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgCJB2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 21:28:40 -0400
Received: by mail-wr1-f66.google.com with SMTP id r15so8676748wrx.6
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 18:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=hpgXiYl1U4EvGwISmu/jK8M27Hry/615/I8pNUlv5AA=;
        b=m3gU9UbOTgc6E+hEM8k2s4q1YFOHYL+edmnPdm+WwVhajwKZ5lQgiy0FpoZ2Yv3wdh
         IrnO0ueWiQmORurV4JvOEWR8+sc88cE7nl163zeHkugZxeshqvYvYVJlnsKoS42WNXF5
         LsRdjOighNXPnCJOd1ERowsxk4ultlEyrEvkPLouT6UtRr52tk3rntX4ZH6JRsFUnXCn
         tdH4mSHsuuoN1jpZA9oAfPJBVua9n3O8p7R2ZC8gs+DUmNURhH9d2bQXPY/6PCGhwLj/
         crOD5IJm4VazH6EzFFcOoV0EChdGKPOav/D/zZmbe2xRcQ+KjsgHTTga2CgqFJ/dy8KX
         Lhzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hpgXiYl1U4EvGwISmu/jK8M27Hry/615/I8pNUlv5AA=;
        b=Jdgiu0+bKw4dwRW023dCJFmIxFDDWec2XOuP0AqRWQdymF/tp8xvNsioBOKnVCJBfL
         u1cO+4XLnPwClEpgB9mbpTsQ9O0Az0k4MasR9HO85/pSbkRhZXC6tfYe4hWLmwc73+d/
         SAcikN6Sdrzj69zfO3xyF2yi7h/2R6hGIeFdAY153HFGu+7Aobfc75/cT1TKM1qM1drG
         7FaDuGKAomrgOTBfnJhMhXVKRzDZ1YDtZsAA+9EO6ZaNQHy55X0jS2ozUpkO5vOfJkKZ
         Zj6IJ/KNQUntIlNJvaUgX6koPgMcMCKtflj++tngT7HcLmxWRJNpUHja1DK32bdw/zPm
         r5dw==
X-Gm-Message-State: ANhLgQ3DdBn1FutctR6cK/qm9Jyot6R6To/A8mW92sK3IZbvdNXSVPgh
        HF+LvDBb23Awa02kpc/4218=
X-Google-Smtp-Source: ADFU+vvmKsLUc5hf6+Bmf4M6o+S8iQkPYBbXVsAnw8jdBs8WNlMly5/S5FoSkpR1SZ5Gi0BgZioA7g==
X-Received: by 2002:a5d:5690:: with SMTP id f16mr24212901wrv.266.1583803718268;
        Mon, 09 Mar 2020 18:28:38 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id c13sm3658326wro.96.2020.03.09.18.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 18:28:37 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com
Subject: [PATCH v2 net] net: mscc: ocelot: properly account for VLAN header length when setting MRU
Date:   Tue, 10 Mar 2020 03:28:18 +0200
Message-Id: <20200310012818.22892-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

What the driver writes into MAC_MAXLEN_CFG does not actually represent
VLAN_ETH_FRAME_LEN but instead ETH_FRAME_LEN + ETH_FCS_LEN. Yes they are
numerically equal, but the difference is important, as the switch treats
VLAN-tagged traffic specially and knows to increase the maximum accepted
frame size automatically. So it is always wrong to account for VLAN in
the MAC_MAXLEN_CFG register.

Unconditionally increase the maximum allowed frame size for
double-tagged traffic. Accounting for the additional length does not
mean that the other VLAN membership checks aren't performed, so there's
no harm done.

Also, stop abusing the MTU name for configuring the MRU. There is no
support for configuring the MRU on an interface at the moment.

Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
Fixes: fa914e9c4d94 ("net: mscc: ocelot: create a helper for changing the port MTU")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Rebased on net tree.

 drivers/net/ethernet/mscc/ocelot.c | 28 +++++++++++++++++-----------
 include/soc/mscc/ocelot_dev.h      |  2 +-
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 04f3153b94e4..602936fafb52 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2181,24 +2181,29 @@ static int ocelot_init_timestamp(struct ocelot *ocelot)
 	return 0;
 }
 
-static void ocelot_port_set_mtu(struct ocelot *ocelot, int port, size_t mtu)
+/* Configure the maximum SDU (L2 payload) on RX to the value specified in @sdu.
+ * The length of VLAN tags is accounted for automatically via DEV_MAC_TAGS_CFG.
+ */
+static void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	int maxlen = sdu + ETH_HLEN + ETH_FCS_LEN;
 	int atop_wm;
 
-	ocelot_port_writel(ocelot_port, mtu, DEV_MAC_MAXLEN_CFG);
+	ocelot_port_writel(ocelot_port, maxlen, DEV_MAC_MAXLEN_CFG);
 
 	/* Set Pause WM hysteresis
-	 * 152 = 6 * mtu / OCELOT_BUFFER_CELL_SZ
-	 * 101 = 4 * mtu / OCELOT_BUFFER_CELL_SZ
+	 * 152 = 6 * maxlen / OCELOT_BUFFER_CELL_SZ
+	 * 101 = 4 * maxlen / OCELOT_BUFFER_CELL_SZ
 	 */
 	ocelot_write_rix(ocelot, SYS_PAUSE_CFG_PAUSE_ENA |
 			 SYS_PAUSE_CFG_PAUSE_STOP(101) |
 			 SYS_PAUSE_CFG_PAUSE_START(152), SYS_PAUSE_CFG, port);
 
 	/* Tail dropping watermark */
-	atop_wm = (ocelot->shared_queue_sz - 9 * mtu) / OCELOT_BUFFER_CELL_SZ;
-	ocelot_write_rix(ocelot, ocelot_wm_enc(9 * mtu),
+	atop_wm = (ocelot->shared_queue_sz - 9 * maxlen) /
+		   OCELOT_BUFFER_CELL_SZ;
+	ocelot_write_rix(ocelot, ocelot_wm_enc(9 * maxlen),
 			 SYS_ATOP, port);
 	ocelot_write(ocelot, ocelot_wm_enc(atop_wm), SYS_ATOP_TOT_CFG);
 }
@@ -2227,9 +2232,10 @@ void ocelot_init_port(struct ocelot *ocelot, int port)
 			   DEV_MAC_HDX_CFG);
 
 	/* Set Max Length and maximum tags allowed */
-	ocelot_port_set_mtu(ocelot, port, VLAN_ETH_FRAME_LEN);
+	ocelot_port_set_maxlen(ocelot, port, ETH_DATA_LEN);
 	ocelot_port_writel(ocelot_port, DEV_MAC_TAGS_CFG_TAG_ID(ETH_P_8021AD) |
 			   DEV_MAC_TAGS_CFG_VLAN_AWR_ENA |
+			   DEV_MAC_TAGS_CFG_VLAN_DBL_AWR_ENA |
 			   DEV_MAC_TAGS_CFG_VLAN_LEN_AWR_ENA,
 			   DEV_MAC_TAGS_CFG);
 
@@ -2315,18 +2321,18 @@ void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
 	 * Only one port can be an NPI at the same time.
 	 */
 	if (cpu < ocelot->num_phys_ports) {
-		int mtu = VLAN_ETH_FRAME_LEN + OCELOT_TAG_LEN;
+		int sdu = ETH_DATA_LEN + OCELOT_TAG_LEN;
 
 		ocelot_write(ocelot, QSYS_EXT_CPU_CFG_EXT_CPUQ_MSK_M |
 			     QSYS_EXT_CPU_CFG_EXT_CPU_PORT(cpu),
 			     QSYS_EXT_CPU_CFG);
 
 		if (injection == OCELOT_TAG_PREFIX_SHORT)
-			mtu += OCELOT_SHORT_PREFIX_LEN;
+			sdu += OCELOT_SHORT_PREFIX_LEN;
 		else if (injection == OCELOT_TAG_PREFIX_LONG)
-			mtu += OCELOT_LONG_PREFIX_LEN;
+			sdu += OCELOT_LONG_PREFIX_LEN;
 
-		ocelot_port_set_mtu(ocelot, cpu, mtu);
+		ocelot_port_set_maxlen(ocelot, cpu, sdu);
 	}
 
 	/* CPU port Injection/Extraction configuration */
diff --git a/include/soc/mscc/ocelot_dev.h b/include/soc/mscc/ocelot_dev.h
index 0a50d53bbd3f..7c08437061fc 100644
--- a/include/soc/mscc/ocelot_dev.h
+++ b/include/soc/mscc/ocelot_dev.h
@@ -74,7 +74,7 @@
 #define DEV_MAC_TAGS_CFG_TAG_ID_M                         GENMASK(31, 16)
 #define DEV_MAC_TAGS_CFG_TAG_ID_X(x)                      (((x) & GENMASK(31, 16)) >> 16)
 #define DEV_MAC_TAGS_CFG_VLAN_LEN_AWR_ENA                 BIT(2)
-#define DEV_MAC_TAGS_CFG_PB_ENA                           BIT(1)
+#define DEV_MAC_TAGS_CFG_VLAN_DBL_AWR_ENA                 BIT(1)
 #define DEV_MAC_TAGS_CFG_VLAN_AWR_ENA                     BIT(0)
 
 #define DEV_MAC_ADV_CHK_CFG                               0x2c
-- 
2.17.1

