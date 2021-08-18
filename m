Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13E243EFB41
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240178AbhHRGKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:10:01 -0400
Received: from inva021.nxp.com ([92.121.34.21]:60110 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239189AbhHRGJJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 02:09:09 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 85278204922;
        Wed, 18 Aug 2021 08:08:33 +0200 (CEST)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 4CE9D204928;
        Wed, 18 Aug 2021 08:08:33 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 3295C183AD15;
        Wed, 18 Aug 2021 14:08:31 +0800 (+08)
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
Subject: [RFC v2 net-next 1/8] net: mscc: ocelot: add MAC table write and lookup operations
Date:   Wed, 18 Aug 2021 14:19:15 +0800
Message-Id: <20210818061922.12625-2-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210818061922.12625-1-xiaoliang.yang_1@nxp.com>
References: <20210818061922.12625-1-xiaoliang.yang_1@nxp.com>
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
---
 drivers/net/ethernet/mscc/ocelot.c | 47 ++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index adfb9781799e..0241272e9ce9 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -102,6 +102,53 @@ int ocelot_mact_forget(struct ocelot *ocelot,
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
-- 
2.17.1

