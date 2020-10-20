Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200F52935CC
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 09:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405165AbgJTHcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 03:32:41 -0400
Received: from inva020.nxp.com ([92.121.34.13]:36566 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405152AbgJTHci (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 03:32:38 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D8C981A03AC;
        Tue, 20 Oct 2020 09:32:36 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B61771A0693;
        Tue, 20 Oct 2020 09:32:28 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id A56E5402BE;
        Tue, 20 Oct 2020 09:32:18 +0200 (CEST)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, vinicius.gomes@intel.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, kuba@kernel.org,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com
Subject: [PATCH v1 net-next 1/5] net: mscc: ocelot: add and export MAC table lookup operations
Date:   Tue, 20 Oct 2020 15:23:17 +0800
Message-Id: <20201020072321.36921-2-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201020072321.36921-1-xiaoliang.yang_1@nxp.com>
References: <20201020072321.36921-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ocelot_mact_lookup() function to retrieve the row and column at
which an FDB entry with the given {DMAC, VID} key is found.

This function is needed in felix DSA driver, so export it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 33 ++++++++++++++++++++++++------
 drivers/net/ethernet/mscc/ocelot.h | 13 ------------
 include/soc/mscc/ocelot.h          | 22 ++++++++++++++++++++
 3 files changed, 49 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 70bf8c67d7ef..5571867a11db 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -12,12 +12,6 @@
 #define TABLE_UPDATE_SLEEP_US 10
 #define TABLE_UPDATE_TIMEOUT_US 100000
 
-struct ocelot_mact_entry {
-	u8 mac[ETH_ALEN];
-	u16 vid;
-	enum macaccess_entry_type type;
-};
-
 static inline u32 ocelot_mact_read_macaccess(struct ocelot *ocelot)
 {
 	return ocelot_read(ocelot, ANA_TABLES_MACACCESS);
@@ -87,6 +81,33 @@ int ocelot_mact_forget(struct ocelot *ocelot,
 }
 EXPORT_SYMBOL(ocelot_mact_forget);
 
+int ocelot_mact_lookup(struct ocelot *ocelot, const unsigned char mac[ETH_ALEN],
+		       unsigned int vid, int *row, int *col)
+{
+	int val;
+
+	ocelot_mact_select(ocelot, mac, vid);
+
+	/* Issue a read command with MACACCESS_VALID=1. */
+	ocelot_write(ocelot, ANA_TABLES_MACACCESS_VALID |
+		     ANA_TABLES_MACACCESS_MAC_TABLE_CMD(MACACCESS_CMD_READ),
+		     ANA_TABLES_MACACCESS);
+
+	if (ocelot_mact_wait_for_completion(ocelot))
+		return -ETIMEDOUT;
+
+	/* Read back the entry flags */
+	val = ocelot_read(ocelot, ANA_TABLES_MACACCESS);
+	if (!(val & ANA_TABLES_MACACCESS_VALID))
+		return -ENOENT;
+
+	ocelot_field_read(ocelot, ANA_TABLES_MACTINDX_M_INDEX, row);
+	ocelot_field_read(ocelot, ANA_TABLES_MACTINDX_BUCKET, col);
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_mact_lookup);
+
 static void ocelot_mact_init(struct ocelot *ocelot)
 {
 	/* Configure the learning mode entries attributes:
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index abb407dff93c..44e39683a5a4 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -74,19 +74,6 @@ struct ocelot_dump_ctx {
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
 int ocelot_port_fdb_do_dump(const unsigned char *addr, u16 vid,
 			    bool is_static, void *data);
 int ocelot_mact_learn(struct ocelot *ocelot, int port,
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 1e9db9577441..31da33fdb7ac 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -659,6 +659,28 @@ struct ocelot_policer {
 	u32 burst; /* bytes */
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
+struct ocelot_mact_entry {
+	u8 mac[ETH_ALEN];
+	u16 vid;
+	enum macaccess_entry_type type;
+};
+
+int ocelot_mact_lookup(struct ocelot *ocelot, const unsigned char mac[ETH_ALEN],
+		       unsigned int vid, int *row, int *col);
+
 #define ocelot_read_ix(ocelot, reg, gi, ri) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
 #define ocelot_read_gix(ocelot, reg, gi) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi))
 #define ocelot_read_rix(ocelot, reg, ri) __ocelot_read_ix(ocelot, reg, reg##_RSZ * (ri))
-- 
2.17.1

