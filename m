Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277483FC18F
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 05:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239611AbhHaDgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 23:36:16 -0400
Received: from inva021.nxp.com ([92.121.34.21]:53198 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239526AbhHaDgF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 23:36:05 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 13CC62003B5;
        Tue, 31 Aug 2021 05:35:10 +0200 (CEST)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 9AF1F200451;
        Tue, 31 Aug 2021 05:35:09 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 80BDF183AD07;
        Tue, 31 Aug 2021 11:35:07 +0800 (+08)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, vinicius.gomes@intel.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, kuba@kernel.org,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com
Subject: [PATCH v3 net-next 2/8] net: mscc: ocelot: add MAC table write and lookup operations
Date:   Tue, 31 Aug 2021 11:45:30 +0800
Message-Id: <20210831034536.17497-3-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210831034536.17497-1-xiaoliang.yang_1@nxp.com>
References: <20210831034536.17497-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

ocelot_mact_write() can be used for directly modifying an FDB entry
situated at a given row and column, as opposed to the current
ocelot_mact_learn() which calculates the row and column indices
automatically (based on a 11-bit hash derived from the {DMAC, VID} key).

ocelot_mact_lookup() can be used to retrieve the row and column at which
an FDB entry with the given {DMAC, VID} key is found.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 47 ++++++++++++++++++++++++++++++
 include/soc/mscc/ocelot.h          |  6 ++++
 2 files changed, 53 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 39a5cee81677..689c800caa54 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -96,6 +96,53 @@ int ocelot_mact_forget(struct ocelot *ocelot,
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
+/* Like ocelot_mact_learn, except at a specific row and col. */
+void ocelot_mact_write(struct ocelot *ocelot, int port,
+		       const struct ocelot_mact_entry *entry,
+		       int row, int col)
+{
+	ocelot_mact_select(ocelot, entry->mac, entry->vid);
+
+	ocelot_field_write(ocelot, ANA_TABLES_MACTINDX_M_INDEX, row);
+	ocelot_field_write(ocelot, ANA_TABLES_MACTINDX_BUCKET, col);
+
+	ocelot_write(ocelot, ANA_TABLES_MACACCESS_VALID |
+		     ANA_TABLES_MACACCESS_ENTRYTYPE(entry->type) |
+		     ANA_TABLES_MACACCESS_DEST_IDX(port) |
+		     ANA_TABLES_MACACCESS_MAC_TABLE_CMD(MACACCESS_CMD_WRITE),
+		     ANA_TABLES_MACACCESS);
+
+	ocelot_mact_wait_for_completion(ocelot);
+}
+EXPORT_SYMBOL(ocelot_mact_write);
+
 static void ocelot_mact_init(struct ocelot *ocelot)
 {
 	/* Configure the learning mode entries attributes:
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 32b3c60d6046..babaa5b0c026 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -923,6 +923,12 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
 				bool tx_pause, bool rx_pause,
 				unsigned long quirks);
 
+int ocelot_mact_lookup(struct ocelot *ocelot, const unsigned char mac[ETH_ALEN],
+		       unsigned int vid, int *row, int *col);
+void ocelot_mact_write(struct ocelot *ocelot, int port,
+		       const struct ocelot_mact_entry *entry,
+		       int row, int col);
+
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
 int ocelot_mrp_add(struct ocelot *ocelot, int port,
 		   const struct switchdev_obj_mrp *mrp);
-- 
2.17.1

