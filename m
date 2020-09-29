Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7675B27C20C
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 12:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbgI2KLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 06:11:23 -0400
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:9902
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728238AbgI2KLB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 06:11:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bdt+6SXSLjntGCE1LDcmuaZNKfzx8N0BveJU6wzZ2foP3tvY/WrwHcAPkKCCKZYLeffRhC5j5DM78lA5ivmuYc4/OhO63M/847665Jp66OaORl3Q7cBXb+8NZYjfFTI1VdhXcGGMWeLveQeJhB/oGQzanZsWE4nk749WlYTWm+GbQM7Kfp9H/mCRpbyciQVwijoFNSQriYMzivzzi60mOfF405jJEPWgafRZ57Y3c7bU+4IU67K6KS07QMNmsEx6w/O/o0owlDq/q6ZhZ04nAtFYRIed17iNA633CF1QrXmr4tmhDPAsCM0BgYB0bgw9YFeTVacj0y2TNQuoF8yjQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kkUcYB6pljnifJp9cThcnbxfQn4z67m0/uJY+AkJHsw=;
 b=avCB7miL7tTYyloXZ7yM6kxVUGb5S4x67vqUwgHBYNU4Ue82mFNpK8tV+W+OFg9Vbdhomolkr1DPHJkdyMLONE+Lw/9zk5IWiNAKg5patqVJL/vsknC6ofncsreGVU/+Cuco4cF+XMLCT1J+9gY31jKyu/Nr8lx6f3JlHEZy0lT4Di3pOFT6SqD5nuKH0XRXu9uyiMuUlq77+e2DXwMqNDIhdndgufRbWbr6h74/bvkn7N79PKwP6TcsSD47jpmWFD5tuRlgtW8cAZ/Ckspsf8ZGc20f0P0mRyZ6RqI93wJPpWQBWgPLK8TgFfma+e0e8rwOQbOhLSCO+181+LM5nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kkUcYB6pljnifJp9cThcnbxfQn4z67m0/uJY+AkJHsw=;
 b=W3EoZvfm9Ja2CQ81X2tysMdmauA4OgX97Bvc0KM+CuxoR2UAAqxK4S3DrsODbM5o5jdJFi398KSjtyg4j87NGPXTXgEnxNWHfp2oipyIpVkd7goRLi8Iq3BHNp/OaPOad62ed90WpUEdAUiA3NfcnVVV9ugTvr0VhpaDgHA41fE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Tue, 29 Sep
 2020 10:10:37 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 10:10:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 04/21] net: mscc: ocelot: auto-detect packet buffer size and number of frame references
Date:   Tue, 29 Sep 2020 13:09:59 +0300
Message-Id: <20200929101016.3743530-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
References: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: VI1PR08CA0112.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::14) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by VI1PR08CA0112.eurprd08.prod.outlook.com (2603:10a6:800:d4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 10:10:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dd1fa8d3-6f0f-4e3f-e8b2-08d8645fe96a
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5295A2D16AFE829FFF539277E0320@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m4mIUKpRoqVV7UpGM3Nxtg7PgW1ZD8IsYPIezvfnwuW40FdteXXDwzto1l9wWvN4keljwFvhbjrZ1UUz2isFyf5HvrpPh0Cur0aeNrKOR+2LSvB9nq8K7e+vRJjLox/zzDUZepIa7C0BTQdNcLawczTf1BmPnrfQFF2puOyqD0sWkb++w4I9dHcsuNz5bm+Tqa5i7lldL9zBbzQIzPrDHNDO/aLH53dEJvX0DCSiibbR1X8Fk/2GVbS66wizlUkMprj0cztZ3xW2ckVQL9V02QsKdrNLNBCFXZRDTvY1YURp4iv/Xnbh4cQBl8IFt6j9b0vekHsB9DNWttq5FPWN7tw+ozOSryS06SSWVc8rxNxwZaNAfqLzBxMsa5Aze/kH9LG5d9usfv+twyZHqVwHGGChf9Qs/7+qnwVeEzZR2q1w360GnRxRqHBk7jcavqhO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(83380400001)(69590400008)(66946007)(4326008)(8936002)(86362001)(36756003)(1076003)(5660300002)(316002)(6666004)(7416002)(52116002)(2616005)(44832011)(956004)(66556008)(8676002)(6486002)(66476007)(6506007)(478600001)(16526019)(6916009)(186003)(26005)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6DlHjXgrnyVHACgZglAzSYX4149mfgJA9z0S37uxKw911NA0HiY7eW1JVij4gcMmGzQ5uXrBUwBVF++ElYzFINr26VcYz0GMzVE54Dj5d18eqGVq5ltkLc6u9kjbJ3whsQh1OXS97dQh4jRzx1F7CAYCUskandZMhOwek+vxC2Cx8d27tAI/CXyUWiFj6QM7KgVCadHZnkZl8UXEthaf4eT+0w6rB9ImLVJgc+6nL0+Ai8PQMGrqnyzcpLuXns1E5PQKcJaftVYoa+frq0yzXHRV0Pf/fC3xphTEY3dz6DvYJ3Tbm9NeJSGYMC1b1PXZoSYa0tn566KnkeV/RqM2N20hHW6Zz/qqNqy20Y2SncHLfpxV8J3qpa0n8bcB5voq6ryUWHIESfvfK3NaYOBL9m9n95qAng7ztMyQJEBvizLb557NnKCmfkfduGrp09tKUKP5cHYB6tJT1YjlOSMaRZ6ni2ZZmyHkcmGi5A4QmSYZCBCgchywevUYHEI4w1lU60IeKyq347cGJtkt07qzFvlzX12YxnAYkluA68wtKLuQe/vB695RkayJJ6Cl+LVLqP60DA5NOMpAMxpzY+HARFdGvPw5QJlR6PhvsnRkSecYqC78bHpMoi8sttFsFNwKF/Q0B7F8I7khVmT/buavHA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd1fa8d3-6f0f-4e3f-e8b2-08d8645fe96a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 10:10:37.5362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tonzl9BGJE3ASCI1ahqE69Y96TeYW8skdsBJ+DWohYJOAurgZ7jI1wRcEkNvUQOG69+Le+600TB0SBHz4fFGqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since we can read these parameters from hardware, let's do that and
avoid errors in the future.

Rename the confusing "shared queue size" to "packet buffer size" while
at it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

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
index da54363b5c92..9c81be370114 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -433,7 +433,6 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	ocelot->map		= felix->info->map;
 	ocelot->stats_layout	= felix->info->stats_layout;
 	ocelot->num_stats	= felix->info->num_stats;
-	ocelot->shared_queue_sz	= felix->info->shared_queue_sz;
 	ocelot->num_mact_rows	= felix->info->num_mact_rows;
 	ocelot->vcap		= felix->info->vcap;
 	ocelot->ops		= felix->info->ops;
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index ec4a8e939bcd..6f6383904cc9 100644
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
index b4011a2101b4..5d750f9ffc0c 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1190,7 +1190,6 @@ static const struct felix_info felix_info_vsc9959 = {
 	.stats_layout		= vsc9959_stats_layout,
 	.num_stats		= ARRAY_SIZE(vsc9959_stats_layout),
 	.vcap			= vsc9959_vcap_props,
-	.shared_queue_sz	= 128 * 1024,
 	.num_mact_rows		= 2048,
 	.num_ports		= 6,
 	.num_tx_queues		= FELIX_NUM_TC,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 35c4dc2799c0..70ce36f3b2a5 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1037,7 +1037,6 @@ static const struct felix_info seville_info_vsc9953 = {
 	.stats_layout		= vsc9953_stats_layout,
 	.num_stats		= ARRAY_SIZE(vsc9953_stats_layout),
 	.vcap			= vsc9953_vcap_props,
-	.shared_queue_sz	= 2048 * 1024,
 	.num_mact_rows		= 2048,
 	.num_ports		= 10,
 	.mdio_bus_alloc		= vsc9953_mdio_bus_alloc,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index b9375d96cdbc..f001cba4eb7a 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1267,7 +1267,7 @@ void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
 			    pause_stop);
 
 	/* Tail dropping watermark */
-	atop_wm = (ocelot->shared_queue_sz - 9 * maxlen) /
+	atop_wm = (ocelot->packet_buffer_size - 9 * maxlen) /
 		   OCELOT_BUFFER_CELL_SZ;
 	ocelot_write_rix(ocelot, ocelot->ops->wm_enc(9 * maxlen),
 			 SYS_ATOP, port);
@@ -1380,6 +1380,24 @@ static void ocelot_cpu_port_init(struct ocelot *ocelot)
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
@@ -1394,6 +1412,8 @@ int ocelot_init(struct ocelot *ocelot)
 		}
 	}
 
+	ocelot_detect_features(ocelot);
+
 	ocelot->lags = devm_kcalloc(ocelot->dev, ocelot->num_phys_ports,
 				    sizeof(u32), GFP_KERNEL);
 	if (!ocelot->lags)
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index f9b7673dab2e..3622753ae4d9 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -508,7 +508,6 @@ static int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
 	ocelot->map = ocelot_regmap;
 	ocelot->stats_layout = ocelot_stats_layout;
 	ocelot->num_stats = ARRAY_SIZE(ocelot_stats_layout);
-	ocelot->shared_queue_sz = 224 * 1024;
 	ocelot->num_mact_rows = 1024;
 	ocelot->ops = ops;
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index f5264f27379e..45c7dc7b54b6 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -589,7 +589,8 @@ struct ocelot {
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

