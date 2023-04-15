Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F5B6E32B0
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 19:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbjDORGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 13:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjDORGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 13:06:13 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2052.outbound.protection.outlook.com [40.107.8.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B56930C1;
        Sat, 15 Apr 2023 10:06:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MWlgtE0pPGJjQz9xW2hFxCvsLi1z60ROIiDlw1kBJyiE8LEltB2V6UZjI2wf/anrZDRqY+zJp8LSLt2icvOflnfDga77LIvPl5eRS+joldtCl/Kjx01WrOvx9xQbpdR1GgoEm+YsPKVSGpZwk8MZI6lWup3CjpUU8VkFupClWfsTJnpQ9swi2FVyTJ/zKlxRYvsG1TZUHlDD8TelyfkNSfoPfpJGGRRjPFmOXrZ+I4jgKAgF6ZlVS49oyK69P6C0JM6zTpFBLMihbJNMn/vwkFuhhQtNeEEBHv6UhNvN3IJ4x2/dtvnrQ2nJXWxKQLqZu4S3lZAGZ2KaV2s3ULMKJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bppP70At0MbklMKoGSAcgyzNzS3CHZbdqmc6OBpaO5w=;
 b=dxcWWKwTx+Ce9WVmOREVDp3PnVeGeK7fCSCSvUt28yM9g86REaWzh+EP26MWFR5UYyANvEL/qdtGSU2laFq2N8MKDFv3B/xlkNW+xAhhRyBIKzdmsbGojhHlR/lK4AcDpSVIraLxPMqmf7UX0SFZK3GmrZw9Iy/qez1tg6v69Sx6UHqi7T+bYG7zY0Y8SeZ7N6BKizvXFkrdO3nX1x6RdAMq8GHh6Proc/PFeKiA1+25uVcCXdEtkOg8D/pJXIgm7aMmeh/M58oIkfK63VjmWpF4z3kB1/3WtnNNlYnwX/Dz5E12lU2M4fItbHleH/FUf2gcihnkcSt4l6X2Bkxnag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bppP70At0MbklMKoGSAcgyzNzS3CHZbdqmc6OBpaO5w=;
 b=bETW4OT6fn2LqEuiVdpdZO7B7jx5nYvIiAeeg2jIOkIhh6LDLVAkTY4Ts7nW31IToDAjAdksBXi2ySRUFDrGD51VvNtJOkrBNytQFZQZfh24DGpNDIN3Z4z8FYgvDK0tUsCw0DouQQWdvw/0YzFwOMnzUNH9BJCaiG0o++UV8zg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8158.eurprd04.prod.outlook.com (2603:10a6:102:1c3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Sat, 15 Apr
 2023 17:06:05 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Sat, 15 Apr 2023
 17:06:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/7] net: mscc: ocelot: remove struct ocelot_mm_state :: lock
Date:   Sat, 15 Apr 2023 20:05:46 +0300
Message-Id: <20230415170551.3939607-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230415170551.3939607-1-vladimir.oltean@nxp.com>
References: <20230415170551.3939607-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0100.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::6) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8158:EE_
X-MS-Office365-Filtering-Correlation-Id: 91838f5a-7c4c-4caf-851b-08db3dd3b2d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6+i2nL9SYfPdSsZCpC613Y8kfL0kDLuTfPDRKcxNApgFNG9sFlNpc6gO1ATBekCeFO2BGd/cxvUZRVG5bSMFyYdlwD8DaztapIDqlBbTJ5YPuUxJZrhRmUGUGUAYBMwxrx1ztGWC8PLykeynDfG1zkqAG6bEEmyJsFz95fUNo5xOavcmva0o42iEtjTsHx/YvkK8kRuErGKfvkhcOoPP5ul5oqzsC4WFSoL6hknEuFpmQImclYh9NriofpeDOTciSLvq8pWveUwsGhKL06i+UPTJ/7lWtNjK6uewaShOwWGPAciavSaDTMI5cdX8Wlkph6pUIJE67ovrMvOv73r2hgjsbod8V2Vyi4WVCQXR6bKbaL3znCVL/U3NJhU/HgURYvNr5QY3DfLkz4Q96872GcLCJvTQOnI5TrKz6CJ93hN+8STyb9F1jLzeQMSAx4CCB7UAUWYNmKrcyW3Dn85BGtzMRR60z/Lf6F16TZ+x4lba9wFyGOJdHQLs8BW1zq7CHB0uw1G9U0uQNilw6htoXKaP4Zw1LNH78XPBN2rIDvFg6XdvnbxfVYxiu2n0If8uKxCl2NjrSoYpiFeSlek+QDXmGyaWRR1bMr2UiLqCSV3n3nBU3SSbcFiHSB3J+NmC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199021)(316002)(4326008)(38100700002)(38350700002)(6916009)(66556008)(66946007)(66476007)(5660300002)(44832011)(2616005)(6666004)(52116002)(36756003)(86362001)(6486002)(41300700001)(54906003)(1076003)(186003)(6506007)(26005)(6512007)(2906002)(8676002)(7416002)(8936002)(83380400001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P2ugV9ipetwg1WndQcRIgnzR9CTmOwzk/ITeEM74/9Z9SL7Ew4nT8vIdNEpd?=
 =?us-ascii?Q?vem+pIew9wto2YbvugJ9VK/ypP0SdUw3fe/z1mPRUTswQXYQjjfWV1LJlogt?=
 =?us-ascii?Q?NM+UVWR55ThpNt4lzO6/Hj/TKIZGtV0ajX2fGlRhzj9LKh+wnyTiZVPid8ht?=
 =?us-ascii?Q?HdiT4W4PJ3P7uZgtwE1O4CAD9Fw7teAWCmwyLfwIrCLZkLPKTGWZCfnL0z10?=
 =?us-ascii?Q?cM13d/kPMXAn3em+mbPdbaSbPMgsaTF4rifj2oqkzSmm3LgRomsofIjFiwi7?=
 =?us-ascii?Q?bZaILmRsqIPOuCieRz/ewxihNENqjAJ2BHacYL5W34kl5+Chsmb8dP22FDUy?=
 =?us-ascii?Q?ZAJcOFJ2rUmE6WMoAZr9g2Jl99DcUTsCjIhrZNOCSTXaDCbSR7tYZ7SakqBW?=
 =?us-ascii?Q?6qztPtLJQm13Rfa73WoDqclvxEJb+xYd7v7ndBDMxncUzy7DTHcniTzMfbBD?=
 =?us-ascii?Q?ggBV2lCZFwVZdBWgcliBrlGbEVqIha9etH0HWfd+2zTCaEOsStzWMc/xw9cW?=
 =?us-ascii?Q?PKypOPB/TlBuuuqEqWbpz5zyz049NVM/7nvaaflLDRcn6nsHPxNDrfzSDjVU?=
 =?us-ascii?Q?upUBWMP4H4GqjVpWJtW1cWFp9J0a8052Rlmt6VcEyaPtPv5TBjlciZ5VOB1a?=
 =?us-ascii?Q?OAZ2G449esh4+3kjCjb3VNkDvl8Y8pg1o3SW6hWUV8ty1VU0RYN39dE+9eoK?=
 =?us-ascii?Q?8gES/eQfsgpzF0ADEN/LcNh+PvSLEXu8OiCK9D5z4L215giVVtYRpC+BT+jo?=
 =?us-ascii?Q?G9nuK9bpEP9wDTRIifphwOALt3aq8tvGkr1jClyHHlIfYxxNB6HARb2+zB8u?=
 =?us-ascii?Q?KCNQne/WvNuPsiXqvcgSkim5a/KOdcWaWxi6Ou6eWbBaY+xhxe7/sZtzzlxY?=
 =?us-ascii?Q?Da5Oc8E7FcLbmzpPK+8ApPgsATLl0nCeBTrjjPAB/UeHGuRPs4kXeENOHry6?=
 =?us-ascii?Q?Qez60VcK0UOJ9ccnGGtGy437x0UtZ0A8EhteEOdKrFQmrDMZeXJgzDLmJYSY?=
 =?us-ascii?Q?PpT+R4eSYtr7W32nEwBSpfl3JpzlspHLpFeAfge8jHFuP00J8r+ey1Lq/HAl?=
 =?us-ascii?Q?tcWhhG+BJwx/6slQeNKxODLUKqTX8dr1s0SnFSnCG4ueUue3mjBK86hp9SoS?=
 =?us-ascii?Q?4lAFic2+vQaIkvvzGBheCl+MSmdKDIoWVRHyK2vyKOmyIUJ1CNUQZuxI4gsg?=
 =?us-ascii?Q?OtEjwXcx2iZvNoiB/V/cx3nKAIWCAMkhZcyCPQlec+PJv46+xGgwFnWNB7+9?=
 =?us-ascii?Q?c00DXhmjugCRgRCBdNUpWVAlrH5Srg8eR7oPA1Q8at5MP78uDF9bQsvN4Sg+?=
 =?us-ascii?Q?kd3McvzQh3wBe9xT2w1ZmvedqCTJmnTGhmkj/775iY7ytrycLGdC+G+ggdj9?=
 =?us-ascii?Q?NXCgdgSA0sGlo6d/tBOxZN7i6A7H9j2f3FeKgtDSJlPHX18M1tF02sjlnzc5?=
 =?us-ascii?Q?FBPjM0y+JCR+HXC9Qf2qvWDINy2WPgvyJL/8WXECNVUnsL51tuYk9pWLJkoj?=
 =?us-ascii?Q?IhDcvh/zlCVVNShuVIqSyo7N5O/SNqd0r0+DO0VQS9Bm0921gh+qF5T33luH?=
 =?us-ascii?Q?YZSBKSO+gLCEHwVNJpQEuaLXUZCcx7DbN1bG2645GYYWBH+QkPNuXJvKzJTP?=
 =?us-ascii?Q?bA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91838f5a-7c4c-4caf-851b-08db3dd3b2d8
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2023 17:06:05.2751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iWjyO6MyGhAcGf0V4NVOYof1GbKhItGTD5Am9BxUF/owh8h/KipFMsy9ap0niduJvrXPePAFgGVk9goSVqsQGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8158
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unfortunately, the workarounds for the hardware bugs make it pointless
to keep fine-grained locking for the MAC Merge state of each port.

Our vsc9959_cut_through_fwd() implementation requires
ocelot->fwd_domain_lock to be held, in order to serialize with changes
to the bridging domains and to port speed changes (which affect which
ports can be cut-through). Simultaneously, the traffic classes which can
be cut-through cannot be preemptible at the same time, and this will
depend on the MAC Merge layer state (which changes from threaded
interrupt context).

Since vsc9959_cut_through_fwd() would have to hold the mm->lock of all
ports for a correct and race-free implementation with respect to
ocelot_mm_irq(), in practice it means that any time a port's mm->lock is
held, it would potentially block holders of ocelot->fwd_domain_lock.

In the interest of simple locking rules, make all MAC Merge layer state
changes (and preemptible traffic class changes) be serialized by the
ocelot->fwd_domain_lock.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Diff: patch is new.

 drivers/net/ethernet/mscc/ocelot_mm.c | 20 ++++++++------------
 include/soc/mscc/ocelot.h             |  1 -
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_mm.c b/drivers/net/ethernet/mscc/ocelot_mm.c
index ddaf1fb05e48..d2df47e6f8f6 100644
--- a/drivers/net/ethernet/mscc/ocelot_mm.c
+++ b/drivers/net/ethernet/mscc/ocelot_mm.c
@@ -56,8 +56,6 @@ static void ocelot_mm_update_port_status(struct ocelot *ocelot, int port)
 	enum ethtool_mm_verify_status verify_status;
 	u32 val;
 
-	mutex_lock(&mm->lock);
-
 	val = ocelot_port_readl(ocelot_port, DEV_MM_STATUS);
 
 	verify_status = ocelot_mm_verify_status(val);
@@ -88,16 +86,18 @@ static void ocelot_mm_update_port_status(struct ocelot *ocelot, int port)
 	}
 
 	ocelot_port_writel(ocelot_port, val, DEV_MM_STATUS);
-
-	mutex_unlock(&mm->lock);
 }
 
 void ocelot_mm_irq(struct ocelot *ocelot)
 {
 	int port;
 
+	mutex_lock(&ocelot->fwd_domain_lock);
+
 	for (port = 0; port < ocelot->num_phys_ports; port++)
 		ocelot_mm_update_port_status(ocelot, port);
+
+	mutex_unlock(&ocelot->fwd_domain_lock);
 }
 EXPORT_SYMBOL_GPL(ocelot_mm_irq);
 
@@ -107,14 +107,11 @@ int ocelot_port_set_mm(struct ocelot *ocelot, int port,
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u32 mm_enable = 0, verify_disable = 0, add_frag_size;
-	struct ocelot_mm_state *mm;
 	int err;
 
 	if (!ocelot->mm_supported)
 		return -EOPNOTSUPP;
 
-	mm = &ocelot->mm[port];
-
 	err = ethtool_mm_frag_size_min_to_add(cfg->tx_min_frag_size,
 					      &add_frag_size, extack);
 	if (err)
@@ -129,7 +126,7 @@ int ocelot_port_set_mm(struct ocelot *ocelot, int port,
 	if (!cfg->verify_enabled)
 		verify_disable = DEV_MM_CONFIG_VERIF_CONFIG_PRM_VERIFY_DIS;
 
-	mutex_lock(&mm->lock);
+	mutex_lock(&ocelot->fwd_domain_lock);
 
 	ocelot_port_rmwl(ocelot_port, mm_enable,
 			 DEV_MM_CONFIG_ENABLE_CONFIG_MM_TX_ENA |
@@ -148,7 +145,7 @@ int ocelot_port_set_mm(struct ocelot *ocelot, int port,
 		       QSYS_PREEMPTION_CFG,
 		       port);
 
-	mutex_unlock(&mm->lock);
+	mutex_unlock(&ocelot->fwd_domain_lock);
 
 	return 0;
 }
@@ -166,7 +163,7 @@ int ocelot_port_get_mm(struct ocelot *ocelot, int port,
 
 	mm = &ocelot->mm[port];
 
-	mutex_lock(&mm->lock);
+	mutex_lock(&ocelot->fwd_domain_lock);
 
 	val = ocelot_port_readl(ocelot_port, DEV_MM_ENABLE_CONFIG);
 	state->pmac_enabled = !!(val & DEV_MM_CONFIG_ENABLE_CONFIG_MM_RX_ENA);
@@ -185,7 +182,7 @@ int ocelot_port_get_mm(struct ocelot *ocelot, int port,
 	state->verify_status = mm->verify_status;
 	state->tx_active = mm->tx_active;
 
-	mutex_unlock(&mm->lock);
+	mutex_unlock(&ocelot->fwd_domain_lock);
 
 	return 0;
 }
@@ -209,7 +206,6 @@ int ocelot_mm_init(struct ocelot *ocelot)
 		u32 val;
 
 		mm = &ocelot->mm[port];
-		mutex_init(&mm->lock);
 		ocelot_port = ocelot->ports[port];
 
 		/* Update initial status variable for the
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index eb8e3935375d..9599be6a0a39 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -744,7 +744,6 @@ struct ocelot_mirror {
 };
 
 struct ocelot_mm_state {
-	struct mutex lock;
 	enum ethtool_mm_verify_status verify_status;
 	bool tx_active;
 };
-- 
2.34.1

