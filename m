Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630C841D4BB
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 09:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348860AbhI3HwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 03:52:01 -0400
Received: from inva020.nxp.com ([92.121.34.13]:43724 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348849AbhI3Hv7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 03:51:59 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id DBF841A0B75;
        Thu, 30 Sep 2021 09:50:15 +0200 (CEST)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 72A5A1A0B69;
        Thu, 30 Sep 2021 09:50:15 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id BBCA2183AC94;
        Thu, 30 Sep 2021 15:50:12 +0800 (+08)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, vinicius.gomes@intel.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, kuba@kernel.org,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, matthias.bgg@gmail.com,
        horatiu.vultur@microchip.com
Subject: [PATCH v6 net-next 2/8] net: mscc: ocelot: add MAC table stream learn and lookup operations
Date:   Thu, 30 Sep 2021 15:59:42 +0800
Message-Id: <20210930075948.36981-3-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210930075948.36981-1-xiaoliang.yang_1@nxp.com>
References: <20210930075948.36981-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ocelot_mact_learn_streamdata() can be used in VSC9959 to overwrite an
FDB entry with stream data. The stream data includes SFID and SSID which
can be used for PSFP and FRER set.

ocelot_mact_lookup() can be used to check if the given {DMAC, VID} FDB
entry is exist, and also can retrieve the DEST_IDX and entry type for
the FDB entry.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 79 ++++++++++++++++++++++++++++--
 drivers/net/ethernet/mscc/ocelot.h | 13 -----
 include/soc/mscc/ocelot.h          | 22 +++++++++
 3 files changed, 98 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 61ac49751230..0e07ea5f851c 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -61,9 +61,9 @@ static void ocelot_mact_select(struct ocelot *ocelot,
 
 }
 
-int ocelot_mact_learn(struct ocelot *ocelot, int port,
-		      const unsigned char mac[ETH_ALEN],
-		      unsigned int vid, enum macaccess_entry_type type)
+static int __ocelot_mact_learn(struct ocelot *ocelot, int port,
+			       const unsigned char mac[ETH_ALEN],
+			       unsigned int vid, enum macaccess_entry_type type)
 {
 	u32 cmd = ANA_TABLES_MACACCESS_VALID |
 		ANA_TABLES_MACACCESS_DEST_IDX(port) |
@@ -96,6 +96,19 @@ int ocelot_mact_learn(struct ocelot *ocelot, int port,
 
 	return err;
 }
+
+int ocelot_mact_learn(struct ocelot *ocelot, int port,
+		      const unsigned char mac[ETH_ALEN],
+		      unsigned int vid, enum macaccess_entry_type type)
+{
+	int ret;
+
+	mutex_lock(&ocelot->mact_lock);
+	ret = __ocelot_mact_learn(ocelot, port, mac, vid, type);
+	mutex_unlock(&ocelot->mact_lock);
+
+	return ret;
+}
 EXPORT_SYMBOL(ocelot_mact_learn);
 
 int ocelot_mact_forget(struct ocelot *ocelot,
@@ -120,6 +133,66 @@ int ocelot_mact_forget(struct ocelot *ocelot,
 }
 EXPORT_SYMBOL(ocelot_mact_forget);
 
+int ocelot_mact_lookup(struct ocelot *ocelot, int *dst_idx,
+		       const unsigned char mac[ETH_ALEN],
+		       unsigned int vid, enum macaccess_entry_type *type)
+{
+	int val;
+
+	mutex_lock(&ocelot->mact_lock);
+
+	ocelot_mact_select(ocelot, mac, vid);
+
+	/* Issue a read command with MACACCESS_VALID=1. */
+	ocelot_write(ocelot, ANA_TABLES_MACACCESS_VALID |
+		     ANA_TABLES_MACACCESS_MAC_TABLE_CMD(MACACCESS_CMD_READ),
+		     ANA_TABLES_MACACCESS);
+
+	if (ocelot_mact_wait_for_completion(ocelot)) {
+		mutex_unlock(&ocelot->mact_lock);
+		return -ETIMEDOUT;
+	}
+
+	/* Read back the entry flags */
+	val = ocelot_read(ocelot, ANA_TABLES_MACACCESS);
+
+	mutex_unlock(&ocelot->mact_lock);
+
+	if (!(val & ANA_TABLES_MACACCESS_VALID))
+		return -ENOENT;
+
+	*dst_idx = ANA_TABLES_MACACCESS_DEST_IDX_X(val);
+	*type = ANA_TABLES_MACACCESS_ENTRYTYPE_X(val);
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_mact_lookup);
+
+int ocelot_mact_learn_streamdata(struct ocelot *ocelot, int dst_idx,
+				 const unsigned char mac[ETH_ALEN],
+				 unsigned int vid,
+				 enum macaccess_entry_type type,
+				 int sfid, int ssid)
+{
+	int ret;
+
+	mutex_lock(&ocelot->mact_lock);
+
+	ocelot_write(ocelot,
+		     (sfid < 0 ? 0 : ANA_TABLES_STREAMDATA_SFID_VALID) |
+		     ANA_TABLES_STREAMDATA_SFID(sfid) |
+		     (ssid < 0 ? 0 : ANA_TABLES_STREAMDATA_SSID_VALID) |
+		     ANA_TABLES_STREAMDATA_SSID(ssid),
+		     ANA_TABLES_STREAMDATA);
+
+	ret = __ocelot_mact_learn(ocelot, dst_idx, mac, vid, type);
+
+	mutex_unlock(&ocelot->mact_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(ocelot_mact_learn_streamdata);
+
 static void ocelot_mact_init(struct ocelot *ocelot)
 {
 	/* Configure the learning mode entries attributes:
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 1952d6a1b98a..a77050b13d18 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -54,19 +54,6 @@ struct ocelot_dump_ctx {
 	int idx;
 };
 
-/* MAC table entry types.
- * ENTRYTYPE_NORMAL is subject to aging.
- * ENTRYTYPE_LOCKED is not subject to aging.
- * ENTRYTYPE_MACv4 is not subject to aging. For IPv4 multicast.
- * ENTRYTYPE_MACv6 is not subject to aging. For IPv6 multicast.
- */
-enum macaccess_entry_type {
-	ENTRYTYPE_NORMAL = 0,
-	ENTRYTYPE_LOCKED,
-	ENTRYTYPE_MACv4,
-	ENTRYTYPE_MACv6,
-};
-
 /* A (PGID) port mask structure, encoding the 2^ocelot->num_phys_ports
  * possibilities of egress port masks for L2 multicast traffic.
  * For a switch with 9 user ports, there are 512 possible port masks, but the
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 682cd058096c..d9129b478c6a 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -589,6 +589,19 @@ enum ocelot_sb_pool {
 	OCELOT_SB_POOL_NUM,
 };
 
+/* MAC table entry types.
+ * ENTRYTYPE_NORMAL is subject to aging.
+ * ENTRYTYPE_LOCKED is not subject to aging.
+ * ENTRYTYPE_MACv4 is not subject to aging. For IPv4 multicast.
+ * ENTRYTYPE_MACv6 is not subject to aging. For IPv6 multicast.
+ */
+enum macaccess_entry_type {
+	ENTRYTYPE_NORMAL = 0,
+	ENTRYTYPE_LOCKED,
+	ENTRYTYPE_MACv4,
+	ENTRYTYPE_MACv6,
+};
+
 #define OCELOT_QUIRK_PCS_PERFORMS_RATE_ADAPTATION	BIT(0)
 #define OCELOT_QUIRK_QSGMII_PORTS_MUST_BE_UP		BIT(1)
 
@@ -907,6 +920,15 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
 				bool tx_pause, bool rx_pause,
 				unsigned long quirks);
 
+int ocelot_mact_lookup(struct ocelot *ocelot, int *dst_idx,
+		       const unsigned char mac[ETH_ALEN],
+		       unsigned int vid, enum macaccess_entry_type *type);
+int ocelot_mact_learn_streamdata(struct ocelot *ocelot, int dst_idx,
+				 const unsigned char mac[ETH_ALEN],
+				 unsigned int vid,
+				 enum macaccess_entry_type type,
+				 int sfid, int ssid);
+
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
 int ocelot_mrp_add(struct ocelot *ocelot, int port,
 		   const struct switchdev_obj_mrp *mrp);
-- 
2.17.1

