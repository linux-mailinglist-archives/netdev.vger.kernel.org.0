Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF52B45587D
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 11:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245397AbhKRKER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 05:04:17 -0500
Received: from inva021.nxp.com ([92.121.34.21]:59578 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245393AbhKRKCw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 05:02:52 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A2A6B200913;
        Thu, 18 Nov 2021 10:59:51 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 3C0892033C4;
        Thu, 18 Nov 2021 10:59:51 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id C7EED183AD0B;
        Thu, 18 Nov 2021 17:59:48 +0800 (+08)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, vinicius.gomes@intel.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, po.liu@nxp.com, leoyang.li@nxp.com,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, matthias.bgg@gmail.com,
        horatiu.vultur@microchip.com, vladimir.oltean@nxp.com,
        kuba@kernel.org, mingkai.hu@nxp.com
Subject: [PATCH v7 net-next 1/8] net: mscc: ocelot: add MAC table stream learn and lookup operations
Date:   Thu, 18 Nov 2021 18:11:57 +0800
Message-Id: <20211118101204.4338-2-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211118101204.4338-1-xiaoliang.yang_1@nxp.com>
References: <20211118101204.4338-1-xiaoliang.yang_1@nxp.com>
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
 drivers/net/ethernet/mscc/ocelot.c | 81 +++++++++++++++++++++++++++---
 drivers/net/ethernet/mscc/ocelot.h | 13 -----
 include/soc/mscc/ocelot.h          | 22 ++++++++
 3 files changed, 97 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index e6c18b598d5c..9e981913d6ba 100644
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
@@ -83,8 +83,6 @@ int ocelot_mact_learn(struct ocelot *ocelot, int port,
 	if (mc_ports & BIT(ocelot->num_phys_ports))
 		cmd |= ANA_TABLES_MACACCESS_MAC_CPU_COPY;
 
-	mutex_lock(&ocelot->mact_lock);
-
 	ocelot_mact_select(ocelot, mac, vid);
 
 	/* Issue a write command */
@@ -92,9 +90,20 @@ int ocelot_mact_learn(struct ocelot *ocelot, int port,
 
 	err = ocelot_mact_wait_for_completion(ocelot);
 
+	return err;
+}
+
+int ocelot_mact_learn(struct ocelot *ocelot, int port,
+		      const unsigned char mac[ETH_ALEN],
+		      unsigned int vid, enum macaccess_entry_type type)
+{
+	int ret;
+
+	mutex_lock(&ocelot->mact_lock);
+	ret = __ocelot_mact_learn(ocelot, port, mac, vid, type);
 	mutex_unlock(&ocelot->mact_lock);
 
-	return err;
+	return ret;
 }
 EXPORT_SYMBOL(ocelot_mact_learn);
 
@@ -120,6 +129,66 @@ int ocelot_mact_forget(struct ocelot *ocelot,
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
index e43da09b8f91..1eb0b5ad51e9 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -55,19 +55,6 @@ struct ocelot_dump_ctx {
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
index fef3a36b0210..1d5ff11e4100 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -593,6 +593,19 @@ enum ocelot_sb_pool {
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
 
@@ -870,6 +883,15 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
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

