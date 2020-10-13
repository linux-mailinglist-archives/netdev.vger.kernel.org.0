Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B1C28CF74
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 15:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387866AbgJMNtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 09:49:15 -0400
Received: from mail-eopbgr140045.outbound.protection.outlook.com ([40.107.14.45]:35766
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726796AbgJMNtN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 09:49:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I6REAyqQ7rryH4AhyOAgnP9n6rP7rNGgec3ozElNlK/E6VixDhbleVX/yvBvv82yDcFhdslouUB1cyZST8m/XmEgSYJ7t9ZCF/OJ2C/xZ6Gkziguyo9AGjEtg0CpJ0ec7caj89j675yocAxeIM5HeEfyXApe3V+nwYYec/TQ7rxQVf0yjcFES2sJlaLyxGCPi/6q4CnlhTJJJUFGRzTRiLlPzVPefMDCMnQN9QtqN+I1EGVDfUG7Xos7mvgmcIlJS+QedrtLFbnxSYewiZhBIMnwVuDYpWz3Rmn6RE2KUIrhNRS7qEopsy3GRTQlkelj/UQLnsmHlbHmGktSszpJjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lWfw8RGT+5/Qe8Hu0zonZon/gRmN9B3Un53tcPjYxQA=;
 b=RD+asltDR5G4e4bo1eZz45xHOH+j0kbHjUHPSA2S9Z3dY8sNAwFByOAiavHTzkcbGZah+eb4b2mvOWyvAv5OLJOnHFB7P08831xGPbJSxWqXB2H77wejvXfg+5nHA2todonSiNbQ3AmeE41MHzX2oJjgF5wRxPYqkFy0nC++bmBJICgoljAtq/lZS5jHjhGoRaMf4HSFLllq77lzeGR6Gi8nj3twevx+O1zlHgOagqGL7gjA71zmnxwpVeyRsBPRr9uUg/4ue6z1xj3SZMjVDuDwsa36YTT+7kjAps+t1kIhJsjAgW6i3BRMLIZobANMw96dhOrxGf5NWfvE6pQGgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lWfw8RGT+5/Qe8Hu0zonZon/gRmN9B3Un53tcPjYxQA=;
 b=oVgBUL/WdblRZXxpodkhi4MLeqDjRO68k46cKfCsSXLpafn3ItTh7Hp31SH9f5i4O3ysPYix9B6qrQegb2zAO84ENpeMgO6Y2sjZx6/82gqPR6rkbYxJhGBwlOoz9NpQmM0HTxvWppc/DFMg7pPhEc6FPhGab4oCb/zqQWTuZJU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Tue, 13 Oct
 2020 13:49:09 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.020; Tue, 13 Oct 2020
 13:49:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH 01/10] net: mscc: ocelot: auto-detect packet buffer size and number of frame references
Date:   Tue, 13 Oct 2020 16:48:40 +0300
Message-Id: <20201013134849.395986-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201013134849.395986-1-vladimir.oltean@nxp.com>
References: <20201013134849.395986-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.174.215]
X-ClientProxiedBy: AM0PR01CA0084.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::25) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.174.215) by AM0PR01CA0084.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Tue, 13 Oct 2020 13:49:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b8d15abc-df8c-4f05-d5f0-08d86f7ec209
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB710425C9B7EF4976E750C768E0040@VI1PR04MB7104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9nB4MFgTW+RVECzhJl/2aR1R5NMJErHggW0LkfeezrPAowL4kco/NCf2RjcOhhrr9VWA9Q+oPg2EhMXg7lkmGzk7dgmiA4Iug7yeDRA6+Vq+dWrY9YxJI9pEEmIapHiurk8Nk4g/eOj+v/5ltfcImWiQqPBI64Qi+L+tqcWaTqcmvYotlM206dd+d9NzxQX3QyND8yhLQy6XYeOqlCxk4NENiFZfLMbMGDaoJPE+sMqSOJ4z1Bwg1qRGxCy5+jLn3CLJoi70scHRdwATpvLITNovjXXRe6dIlscDKqDKwVl/G6EFy51QK7BnoyYmxcXZeXDx+2VyhP2RJKjhEKsn8vGz62uUH2oBauQ7Ol4fEH8JKJwX9lO+WaNbvF61tk2w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(39850400004)(376002)(396003)(478600001)(83380400001)(6506007)(8936002)(69590400008)(6486002)(66556008)(66476007)(6666004)(66946007)(5660300002)(1076003)(316002)(4326008)(36756003)(956004)(8676002)(86362001)(2616005)(186003)(6916009)(16526019)(26005)(52116002)(44832011)(2906002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: CsAp28nkxoD+guO6fIyjcWg0QecwEVHCR9sjS0i6xG1B/mEl/xwA2mz1/nN3++OzX33qIK0s5+uWm2RLYDmN+CIU/AxfL5WrSSxbB8yibnFCupAfBIpV4lTxr6KYB/wpruabHgfrfhlp8+5UDjkqgywUEi8BUObhneGliyQKy3Nf9nNVpPjOT9cOVEOhFD5USsZi21Sxz6Ehe1DCYRMRhJMxZbbCurO+3Q3C/mUz1tB7EElGM0VTVdmYmJ7io2RlAFOHknIUbcK/x6eK3oK4IlpmEgbcB2TzCot01gT1ztvH+5Vh5PIYYwnjCo9a2jEDPj2bjt/vOtHRnGC6I8+DlQ/8BkuxeOg/w58wSJc+WWTB6YBtnrOey3432X0AWzflNS9dcAyosf4WTuivsxJDKx0muqAPRB/0wspxEQIlJieWl3J2GqEJS/ybO8M1/3YWGtTyGJaiY4jpWHw6k5Jcuu4bPlvc40vL73N6UdRoBynXa9WaI6TYvlg1opw55FfM9eHwewYaf7AVFxgT/l/nyCteE9wLLaBmlxZcEMin3mx+C74dM1f1AGg3rjNH4TXl6EnDBGzC24GOw0XyKo+0MGXyMiGfzRtoREQQ1+UwjZDVvnhyQ/SVgWzWiuvqOhuIuKwpWJjKiiPI0tDDf4XDiA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8d15abc-df8c-4f05-d5f0-08d86f7ec209
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2020 13:49:08.8490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dDrcJmm431D9L4+XfKl8WQ5kmnbJ1ZrkeE+95afPNUA506ivW/kNX6uPnXf5DXIJf7rtttE0UoXXIdXIwyB+sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of reading these values from the reference manual and writing
them down into the driver, it appears that the hardware gives us the
option of detecting them dynamically.

The number of frame references corresponds to what the reference manual
notes, however it seems that the frame buffers are reported as less than
the books would indicate. On VSC9959 (Felix), the books say it should
have 128KB of packet buffer, but the registers indicate only 103872 bytes.
Interesting...

Not having anything better to do with these values at the moment* (this
will change soon), let's just print them.

*The frame buffer size is, in fact, used to calculate the tail dropping
watermarks.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c             |  1 -
 drivers/net/dsa/ocelot/felix.h             |  1 -
 drivers/net/dsa/ocelot/felix_vsc9959.c     |  1 -
 drivers/net/dsa/ocelot/seville_vsc9953.c   |  1 -
 drivers/net/ethernet/mscc/ocelot.c         | 22 +++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  1 -
 include/soc/mscc/ocelot.h                  |  3 ++-
 include/soc/mscc/ocelot_qsys.h             |  3 +++
 8 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index f791860d495f..29ccc3315863 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -432,7 +432,6 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	ocelot->map		= felix->info->map;
 	ocelot->stats_layout	= felix->info->stats_layout;
 	ocelot->num_stats	= felix->info->num_stats;
-	ocelot->shared_queue_sz	= felix->info->shared_queue_sz;
 	ocelot->num_mact_rows	= felix->info->num_mact_rows;
 	ocelot->vcap		= felix->info->vcap;
 	ocelot->ops		= felix->info->ops;
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 4c717324ac2f..5434fe278d2c 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -15,7 +15,6 @@ struct felix_info {
 	const struct reg_field		*regfields;
 	const u32 *const		*map;
 	const struct ocelot_ops		*ops;
-	int				shared_queue_sz;
 	int				num_mact_rows;
 	const struct ocelot_stat_layout	*stats_layout;
 	unsigned int			num_stats;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 3e925b8d5306..a2d5a9a8baf1 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1356,7 +1356,6 @@ static const struct felix_info felix_info_vsc9959 = {
 	.stats_layout		= vsc9959_stats_layout,
 	.num_stats		= ARRAY_SIZE(vsc9959_stats_layout),
 	.vcap			= vsc9959_vcap_props,
-	.shared_queue_sz	= 128 * 1024,
 	.num_mact_rows		= 2048,
 	.num_ports		= 6,
 	.num_tx_queues		= FELIX_NUM_TC,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 76576cf0ba8a..dbf2bb951761 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1181,7 +1181,6 @@ static const struct felix_info seville_info_vsc9953 = {
 	.stats_layout		= vsc9953_stats_layout,
 	.num_stats		= ARRAY_SIZE(vsc9953_stats_layout),
 	.vcap			= vsc9953_vcap_props,
-	.shared_queue_sz	= 2048 * 1024,
 	.num_mact_rows		= 2048,
 	.num_ports		= 10,
 	.mdio_bus_alloc		= vsc9953_mdio_bus_alloc,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index fcbb3165ae7f..fc6fe5022719 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1305,7 +1305,7 @@ void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
 			    pause_stop);
 
 	/* Tail dropping watermarks */
-	atop_tot = (ocelot->shared_queue_sz - 9 * maxlen) /
+	atop_tot = (ocelot->packet_buffer_size - 9 * maxlen) /
 		   OCELOT_BUFFER_CELL_SZ;
 	atop = (9 * maxlen) / OCELOT_BUFFER_CELL_SZ;
 	ocelot_write_rix(ocelot, ocelot->ops->wm_enc(atop), SYS_ATOP, port);
@@ -1418,6 +1418,24 @@ static void ocelot_cpu_port_init(struct ocelot *ocelot)
 			 ANA_PORT_VLAN_CFG, cpu);
 }
 
+static void ocelot_detect_features(struct ocelot *ocelot)
+{
+	int mmgt, eq_ctrl;
+
+	/* SYS:MMGT:MMGT:FREECNT holds the number of 192-byte
+	 * free memory words.
+	 */
+	mmgt = ocelot_read(ocelot, SYS_MMGT);
+	ocelot->packet_buffer_size = 192 * SYS_MMGT_FREECNT(mmgt);
+
+	eq_ctrl = ocelot_read(ocelot, QSYS_EQ_CTRL);
+	ocelot->num_frame_refs = QSYS_MMGT_EQ_CTRL_FP_FREE_CNT(eq_ctrl);
+
+	dev_info(ocelot->dev,
+		 "Detected %d bytes of packet buffer and %d frame references\n",
+		 ocelot->packet_buffer_size, ocelot->num_frame_refs);
+}
+
 int ocelot_init(struct ocelot *ocelot)
 {
 	char queue_name[32];
@@ -1452,6 +1470,8 @@ int ocelot_init(struct ocelot *ocelot)
 	if (!ocelot->stats_queue)
 		return -ENOMEM;
 
+	ocelot_detect_features(ocelot);
+
 	INIT_LIST_HEAD(&ocelot->multicast);
 	ocelot_mact_init(ocelot);
 	ocelot_vlan_init(ocelot);
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index dc00772950e5..5a07f0c23f42 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -517,7 +517,6 @@ static int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
 	ocelot->map = ocelot_regmap;
 	ocelot->stats_layout = ocelot_stats_layout;
 	ocelot->num_stats = ARRAY_SIZE(ocelot_stats_layout);
-	ocelot->shared_queue_sz = 224 * 1024;
 	ocelot->num_mact_rows = 1024;
 	ocelot->ops = ops;
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 1e9db9577441..da3e50efcf96 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -604,7 +604,8 @@ struct ocelot {
 	const struct ocelot_stat_layout	*stats_layout;
 	unsigned int			num_stats;
 
-	int				shared_queue_sz;
+	int				packet_buffer_size;
+	int				num_frame_refs;
 	int				num_mact_rows;
 
 	struct net_device		*hw_bridge_dev;
diff --git a/include/soc/mscc/ocelot_qsys.h b/include/soc/mscc/ocelot_qsys.h
index a814bc2017d8..b7b263a19068 100644
--- a/include/soc/mscc/ocelot_qsys.h
+++ b/include/soc/mscc/ocelot_qsys.h
@@ -77,6 +77,9 @@
 #define QSYS_RES_STAT_MAXUSE(x)                           ((x) & GENMASK(11, 0))
 #define QSYS_RES_STAT_MAXUSE_M                            GENMASK(11, 0)
 
+#define QSYS_MMGT_EQ_CTRL_FP_FREE_CNT(x)                  ((x) & GENMASK(15, 0))
+#define QSYS_MMGT_EQ_CTRL_FP_FREE_CNT_M                   GENMASK(15, 0)
+
 #define QSYS_EVENTS_CORE_EV_FDC(x)                        (((x) << 2) & GENMASK(4, 2))
 #define QSYS_EVENTS_CORE_EV_FDC_M                         GENMASK(4, 2)
 #define QSYS_EVENTS_CORE_EV_FDC_X(x)                      (((x) & GENMASK(4, 2)) >> 2)
-- 
2.25.1

