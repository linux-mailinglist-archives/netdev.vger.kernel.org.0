Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE7017E9C9
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 21:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgCIUQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 16:16:18 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51316 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbgCIUQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 16:16:17 -0400
Received: by mail-wm1-f67.google.com with SMTP id a132so936673wme.1
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 13:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FD0mDEpsea8VECEMnvUDPdGgQcj6vPwqMx54ti64lQQ=;
        b=qFFnpyRRF2vQq72WJn4NwTirj1K1GvInoyyykv5B6fSn/6kmse7iSW+SII5Db9Ilp4
         yEWttcO6h4pw3kRG6HD8lz2LSAx9derIzKjIMcekpRu3Q8xQwRugulxLWoZrYyPjGvZp
         tW/EYLvjoTUziZ/Vx+GGLsB1XzzLO0kpgnFVpPHCVNvSPU15/yWpzEa8UmH5YbNtjQh0
         1+5nxu9n6VU8VNsA7NW0nMHpHOYKSEDDJtVTQ2FWz8fKLe9Tl56MiHjmlZ8/Ukgfbf7e
         VzHOxLgkbI3ICgz+YTW7C9i0+QMUoyFK/b2eHKtCUjajqwCeg8JpyfPfioDEA8zA42S2
         0EAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FD0mDEpsea8VECEMnvUDPdGgQcj6vPwqMx54ti64lQQ=;
        b=mdZX3SL7TwnW2DUOZkVPY/046LpGoFGQ9BaFEUqiNBXA7eQbRep+n56BIv327Y72sR
         z1F7gCQ2fhjGU/eI+PG861MA+QQbUUN7VtQsp/w6swo3Sa0BRF6hjiqV4YAsCtmc4rwT
         sjbtZwUcaos+wjCvQGHLiicajugl7AS16jirB6fNPyQOcxbBCZwQFAb/pQqz9/mB+DUc
         f5ld4m1j/qwj7LzjuAjZtAV6AHKBsOdW2JBohQ3k1fk6SRt+SIrSgyh5fapc9C8hDNdj
         J1u0iQnxDjTSn56Ybko2kt8UZZPDpD/qUUdi87QG6EJskE/7+pSUumalH9X948SFuB84
         5CVQ==
X-Gm-Message-State: ANhLgQ0SqyaBr49u21Q3caP4YZpcaaiJ3UetV14aVVLMF5QwkPqcYTTk
        0hNrrzw9gRb72jAjJqzYBNM=
X-Google-Smtp-Source: ADFU+vu3MfoOqUM3JMJd5xQDhpRM5WU/S6z1gGf3OI4Gzr/BRzOX93FUWv1IlZYYQMwQZGGb75CrDg==
X-Received: by 2002:a7b:c92e:: with SMTP id h14mr977019wml.90.1583784975297;
        Mon, 09 Mar 2020 13:16:15 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id o10sm15842689wru.38.2020.03.09.13.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 13:16:14 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com
Subject: [PATCH net] net: mscc: ocelot: properly account for VLAN header length when setting MRU
Date:   Mon,  9 Mar 2020 22:16:08 +0200
Message-Id: <20200309201608.14420-1-olteanv@gmail.com>
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
 drivers/net/ethernet/mscc/ocelot.c | 28 +++++++++++++++++-----------
 include/soc/mscc/ocelot_dev.h      |  2 +-
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index cd4dd885f038..6e4cca34a04f 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2188,24 +2188,29 @@ static int ocelot_init_timestamp(struct ocelot *ocelot)
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
@@ -2234,9 +2239,10 @@ void ocelot_init_port(struct ocelot *ocelot, int port)
 			   DEV_MAC_HDX_CFG);
 
 	/* Set Max Length and maximum tags allowed */
-	ocelot_port_set_mtu(ocelot, port, VLAN_ETH_FRAME_LEN);
+	ocelot_port_set_maxlen(ocelot, port, ETH_DATA_LEN);
 	ocelot_port_writel(ocelot_port, DEV_MAC_TAGS_CFG_TAG_ID(ETH_P_8021AD) |
 			   DEV_MAC_TAGS_CFG_VLAN_AWR_ENA |
+			   DEV_MAC_TAGS_CFG_VLAN_DBL_AWR_ENA |
 			   DEV_MAC_TAGS_CFG_VLAN_LEN_AWR_ENA,
 			   DEV_MAC_TAGS_CFG);
 
@@ -2329,18 +2335,18 @@ void ocelot_configure_cpu(struct ocelot *ocelot, int npi,
 			 ANA_PORT_PORT_CFG, cpu);
 
 	if (npi >= 0 && npi < ocelot->num_phys_ports) {
-		int mtu = VLAN_ETH_FRAME_LEN + OCELOT_TAG_LEN;
+		int sdu = ETH_DATA_LEN + OCELOT_TAG_LEN;
 
 		ocelot_write(ocelot, QSYS_EXT_CPU_CFG_EXT_CPUQ_MSK_M |
 			     QSYS_EXT_CPU_CFG_EXT_CPU_PORT(npi),
 			     QSYS_EXT_CPU_CFG);
 
 		if (injection == OCELOT_TAG_PREFIX_SHORT)
-			mtu += OCELOT_SHORT_PREFIX_LEN;
+			sdu += OCELOT_SHORT_PREFIX_LEN;
 		else if (injection == OCELOT_TAG_PREFIX_LONG)
-			mtu += OCELOT_LONG_PREFIX_LEN;
+			sdu += OCELOT_LONG_PREFIX_LEN;
 
-		ocelot_port_set_mtu(ocelot, npi, mtu);
+		ocelot_port_set_maxlen(ocelot, npi, sdu);
 
 		/* Enable NPI port */
 		ocelot_write_rix(ocelot,
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

