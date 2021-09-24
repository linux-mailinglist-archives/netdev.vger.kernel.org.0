Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66D6416F4C
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 11:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245356AbhIXJoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 05:44:37 -0400
Received: from inva020.nxp.com ([92.121.34.13]:44914 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245228AbhIXJoV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 05:44:21 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id EBE5C1A3059;
        Fri, 24 Sep 2021 11:42:46 +0200 (CEST)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 54D1D1A3049;
        Fri, 24 Sep 2021 11:42:46 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 750ED183AC8B;
        Fri, 24 Sep 2021 17:42:43 +0800 (+08)
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
Subject: [PATCH v5 net-next 3/9] net: mscc: ocelot: add MAC table stream learn and lookup operations
Date:   Fri, 24 Sep 2021 17:52:20 +0800
Message-Id: <20210924095226.38079-4-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210924095226.38079-1-xiaoliang.yang_1@nxp.com>
References: <20210924095226.38079-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

ocelot_mact_learn_streamdata() can be used in VSC9959 to overwrite an
FDB entry with stream data. The stream data includes SFID and SSID which
can be used for PSFP and FRER set.

ocelot_mact_lookup() can be used to check if the given {DMAC, VID} FDB
entry is exist, and also can retrieve the DEST_IDX and entry type for
the FDB entry.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 50 ++++++++++++++++++++++++++++++
 include/soc/mscc/ocelot.h          |  5 +++
 2 files changed, 55 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 35006b0fb963..dc65247b91be 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -114,6 +114,56 @@ int ocelot_mact_forget(struct ocelot *ocelot,
 }
 EXPORT_SYMBOL(ocelot_mact_forget);
 
+int ocelot_mact_lookup(struct ocelot *ocelot, int *dst_idx,
+		       struct ocelot_mact_entry *entry)
+{
+	int val;
+
+	mutex_lock(&ocelot->mact_lock);
+
+	ocelot_mact_select(ocelot, entry->mac, entry->vid);
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
+	entry->type = ANA_TABLES_MACACCESS_ENTRYTYPE_X(val);
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_mact_lookup);
+
+int ocelot_mact_learn_streamdata(struct ocelot *ocelot, int dst_idx,
+				 struct ocelot_mact_entry *entry, u32 data)
+{
+	int ret;
+
+	mutex_lock(&ocelot->mact_lock);
+	ocelot_write(ocelot, data, ANA_TABLES_STREAMDATA);
+	mutex_unlock(&ocelot->mact_lock);
+
+	ret = ocelot_mact_learn(ocelot, dst_idx, entry->mac, entry->vid,
+				entry->type);
+
+	return ret;
+}
+EXPORT_SYMBOL(ocelot_mact_learn_streamdata);
+
 static void ocelot_mact_init(struct ocelot *ocelot)
 {
 	/* Configure the learning mode entries attributes:
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index e6773f4d09ce..455293652257 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -926,6 +926,11 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
 				bool tx_pause, bool rx_pause,
 				unsigned long quirks);
 
+int ocelot_mact_lookup(struct ocelot *ocelot, int *dst_idx,
+		       struct ocelot_mact_entry *entry);
+int ocelot_mact_learn_streamdata(struct ocelot *ocelot, int dst_idx,
+				 struct ocelot_mact_entry *entry, u32 data);
+
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
 int ocelot_mrp_add(struct ocelot *ocelot, int port,
 		   const struct switchdev_obj_mrp *mrp);
-- 
2.17.1

