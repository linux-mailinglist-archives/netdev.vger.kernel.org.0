Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94313EFB43
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240246AbhHRGKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:10:09 -0400
Received: from inva021.nxp.com ([92.121.34.21]:60274 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239298AbhHRGJK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 02:09:10 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 6412620491C;
        Wed, 18 Aug 2021 08:08:35 +0200 (CEST)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id EBC37204929;
        Wed, 18 Aug 2021 08:08:34 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id D2B54183ACDE;
        Wed, 18 Aug 2021 14:08:32 +0800 (+08)
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
Subject: [RFC v2 net-next 2/8] net: mscc: ocelot: export MAC table lookup and write
Date:   Wed, 18 Aug 2021 14:19:16 +0800
Message-Id: <20210818061922.12625-3-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210818061922.12625-1-xiaoliang.yang_1@nxp.com>
References: <20210818061922.12625-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Felix DSA needs to use these operations as well, for its stream
identification functions, so export them in preparation of that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c |  6 ------
 drivers/net/ethernet/mscc/ocelot.h | 13 -------------
 include/soc/mscc/ocelot.h          | 24 ++++++++++++++++++++++++
 3 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 0241272e9ce9..fe6378ecb66d 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -14,12 +14,6 @@
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
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index db6b1a4c3926..24a676b5abd6 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -57,19 +57,6 @@ struct ocelot_dump_ctx {
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
index 2f5ce4d4fdbf..1bbba424c189 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -695,6 +695,25 @@ struct ocelot_skb_cb {
 	u8 ts_id;
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
 #define OCELOT_SKB_CB(skb) \
 	((struct ocelot_skb_cb *)((skb)->cb))
 
@@ -893,6 +912,11 @@ int ocelot_sb_occ_tc_port_bind_get(struct ocelot *ocelot, int port,
 				   unsigned int sb_index, u16 tc_index,
 				   enum devlink_sb_pool_type pool_type,
 				   u32 *p_cur, u32 *p_max);
+int ocelot_mact_lookup(struct ocelot *ocelot, const unsigned char mac[ETH_ALEN],
+		       unsigned int vid, int *row, int *col);
+void ocelot_mact_write(struct ocelot *ocelot, int port,
+		       const struct ocelot_mact_entry *entry,
+		       int row, int col);
 
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
 int ocelot_mrp_add(struct ocelot *ocelot, int port,
-- 
2.17.1

