Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4C25B8BFE
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiINPeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiINPeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:34:12 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2074.outbound.protection.outlook.com [40.107.20.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1004D80F70;
        Wed, 14 Sep 2022 08:34:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rka+cbUS9kdcTG/ZSoDswOjpGOgQQ2MO/ycM3ESxkkgcmvIsO/Hl+/HomqpHfpI8Ypk2LOCvOlB5GjkoqXnXbVvKFumaiqjZrmk7PqWaR4lrkEPMOb8A7hl7Rb3sFdcr3qixTUrtZl8yT/LNY1Wem9qRL3kUopLA+n1t6P82BHUlok1bNhX5OkS9skWhWVSwZUkJzQ0sxhud0tzPQFI386XxJNCfVbXDcrDlqNU0h/RB9kEJK9n2VqqkHqKDIB7+k61TnbsrU2InrYa/HS3fBhWmvREMhmnYBF0OsTaWpTbGiSeBBZjWpZrdTgJyv70vlz6q/KbPkgc/5AMviEfU+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nyMSdRGGI3RUrclLvPKsdhMBO1YIiP4dg5TVeoWkHBc=;
 b=bP29WfoOGZvDFsu10JVuQ6UmusZoYOGtIMhak6qUrnPb7JRTzY1JRjFH5DtE7cdjYhWrg5OCOKwY+aCp35KDNVjq5Q2kV8R17h6e1683OliLBgG+Q9GF3O2vVes3lr6FHWNMU0KlfBx4zn7Vlxz7ZIbhUL9jm88TrW5SvpU+oeFv2rIVDGvblyY8cAbZ6K9Cqxld7uXPQqzWPPt36SxdAy4xDlR9z4YFmXOuhiZ+SOYq2cCSBxLuHCdtOo/ZovtS6qiS9NkqmSs8jx/yOKtaT4qad6lVeBIzZD6aIoNvnRKEWbZwFzfpK2psiaW8jfHTgGS6rJcsSFFmXZojYvtuLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nyMSdRGGI3RUrclLvPKsdhMBO1YIiP4dg5TVeoWkHBc=;
 b=bownMam7tBrtn87PYoz9kct9EDMajeCcvQAHduXHUQgXrLWD/A8IsPXp91oL+/XEaB598xZKtCtpIFun1DY1F1EsYFQRFu4ZPJVfXYFdj9ivbvD28LnOf0Xjgrxu4Cld3hc7HfpJxvgc/sJeE63ao6fT491JIje/2Rdq2VV9hao=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7908.eurprd04.prod.outlook.com (2603:10a6:20b:24c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 15:34:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 15:34:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 13/13] net: am65-cpsw: deny tc-taprio changes to per-tc max SDU
Date:   Wed, 14 Sep 2022 18:33:03 +0300
Message-Id: <20220914153303.1792444-14-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P250CA0023.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7908:EE_
X-MS-Office365-Filtering-Correlation-Id: 47a7de7d-0457-4acb-b991-08da96668c1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ymWneJcyEZczRImMOo+giHK0BFWEydNYGP16psG4XOVVx/z5oeB3h3Imv4iBIr6CCCJbiWR2ut8vfCtE6PZzG4WJLEwDImu1hwIhm124nh6WEOvoQyqKeonIQBXpH9VpMadFpP7rknSyrKDOigGSUZcmKD1dvsObmHDGk/5DQ+O5e9O/SzXWIta3cXsGvyt3+30mdkUEreOTphSQkUy9NYNu3LNqdDMLWo/2wGyP+JASpxykUAO4bkhZWabrejjWSaQzOKSinQqn64KIzZL805+Szm3iSn58HjeKE8C4c3HvxC7S+17XyjOqUCMPyBID/2SvAqHKuFCFc4aZbbGZDWRXljDR5il/8yTaOUHKm6/scFrbyQs2dWGxQMr//O0ngWhS9QsGtJVhMBSMbeH8lFt7Pz8d4GxN98ZZHUWJBXgFQz4qeJgh6ugg9bs+2GhRvoHtotPsJ6JD09B18IUTtpvfhRzC76QdCuRoVoKnBhJKX6Hmpnay3W8Of8vRiTA4qzFznMyyFAABO/cK2kvq/UVMNjqK+r5IyZbXKsfnBwcXp1DWxy6FmP/EbpXyRzAy55JmAu4RX/8gYRKQcihe9tmpOCUwDSc73XMQLEhlEycZxnt2RFsgaoB/A3G+FWJMhtb0C57trgiTr/1QLPx6Rb64Zhrfd8KojwbalbmfxV0adp0VROptbnhVqUJt7YNHqVoOxiumGKqUZmPJTweYt9qE31Uz6EaxuDMXcc3nMIRkK4aJ7A8wdzbde6SjaR366dPAgmVwQGLVfulJQvU/ykCBpuk7qT8M2QpOia7SjenNLzIpT16hX4hAooQfHOGc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(366004)(136003)(346002)(451199015)(6486002)(83380400001)(186003)(2616005)(1076003)(8676002)(66476007)(6916009)(54906003)(44832011)(4326008)(5660300002)(66556008)(86362001)(52116002)(66946007)(6506007)(7416002)(6512007)(38100700002)(316002)(8936002)(38350700002)(478600001)(2906002)(36756003)(41300700001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y1+d+TKKdlE3bHdT8ZGloONkFdoeQA9/MwyMt1LcwMdUe7Yw07qUJ+Q3BoXs?=
 =?us-ascii?Q?LLrNroU6EBBLYsfeBH4nzWqWiPNMWpyP0PLXtEf/9zc5X7mxFpJWKMygpQZf?=
 =?us-ascii?Q?DmVWpqwW8ZValknjbLmx1og/uquAswmFE2xn30bDIGNu+Y219fPLChPy8ox0?=
 =?us-ascii?Q?bHqb61b7oj8P41GK3n7VsQ8WsUxNrQOAlzMFWBjgnvAhaWEt3HSVLkBgdYYc?=
 =?us-ascii?Q?kNarBoxqViWj42wYeQutGc5kDUIFmGdwigrLJPhX0cLpiOExb+rpk0cVig9G?=
 =?us-ascii?Q?jXs3bq1a28kmheldUSrStVVukTkQSvFmJP7d7bU1YgBQOUR+xV9tfB5nMQpy?=
 =?us-ascii?Q?4ffr2JR1a99tghtsbHAEkPf3640sd0gi2i3LEIee3HlRZmjX5NZtdAGff3fi?=
 =?us-ascii?Q?rEzZv7nlMjmSi3ipaZ+769aFi4dXTRDx0FlFwatwG+qrPxLvFpOXRKJG9VGD?=
 =?us-ascii?Q?DHfViCqv5woQInJlYgmYeq39nBp/MnGwuJ1ozd5mr5DQi0wUSXMFn/uJ8IJb?=
 =?us-ascii?Q?cfRo+fQTXIi9aRPLI7q7bL7IXWqVCpsBXe2PukLJWhGTlZMsTyvHQ58bc+cc?=
 =?us-ascii?Q?TX/MDR04UokZv2vZxiOaRDBdSiCzGoLI9cc0QMH9mNBD8pv5+FTxxDR3mA4S?=
 =?us-ascii?Q?9bYSgCGlFwBI5T1AkNak/5BBnaJqDiAnthSwskCVClzsThEZA8c4WijVsenl?=
 =?us-ascii?Q?yl9nfx2rNpEqDzGgKreBCvk6NmKFGr+gOMii6z7xvtDWqU3edt49hkEzr1Eh?=
 =?us-ascii?Q?yNtWvj+9h882k1GItbzL/cJB1uDUXGfKXprknN+sPC8mdcZ+jefFn1xv41Ts?=
 =?us-ascii?Q?Of/mAkYWIevsQ0/AqCkQqBgsDP/GnQcqQX/q5LQelMnbsU+3N5X22r2uDAfD?=
 =?us-ascii?Q?dg29SKxYYHJvcTrCPJcgMtZLN3y2umeLxP6e9sWYRIXOerqnLJZPsQUUOVV0?=
 =?us-ascii?Q?CrGUYieAhumssaF2FZCejqUSPcwkTCiwKJJro44eUAH+EsVMlobUtbEzHAvx?=
 =?us-ascii?Q?BgIOW/x4nNKg7FruPGyDzAe8MYzydzV91OkycgXb3pKpU9RQzvIgyyW/fR6A?=
 =?us-ascii?Q?5N/rsAVvYu3nxsySQVlUYq2DH6nZ/ZTWRd/OOcDF/TIYnMTDgNo5rpn3JlK8?=
 =?us-ascii?Q?ZOkCrUn5yMC8hrHT5xql+1xWW6QbceJJZ/RHWMZ7mvA4i39tRuiS7Hpqcmzr?=
 =?us-ascii?Q?UrcS9kDOINelzqwT7UFQ/yUBYwuLmmY49MR3L9MzxEF54slqnGLXivs0nSOX?=
 =?us-ascii?Q?7nY6dtE1NyIQOz5HthoCMHMuBh42cE/7Q85dPWcEwY+qAWO+xHhs8VuoIX2X?=
 =?us-ascii?Q?IMe8vA3ejy8V7ngFWCvs2qhJoTNsybUXWe6bFKVuluoJiyGhy98oyb7qX9po?=
 =?us-ascii?Q?Ld5den36QFjC9al6HwDm7wmRhBIB4c3VflBNzPQgcI+SXK8oIoZQKIPaq4I7?=
 =?us-ascii?Q?HO1/MnNfWZ6LCP4EOm5uqeTf+hiG7hP8SM4soiNtan/Paf2XNdXb4yw9ApD/?=
 =?us-ascii?Q?fNPOUlIH0bpHZ6hl2H+Dc946tCMnoRxzraRbc8GBaa2X7eyHt5/8+TuttN3A?=
 =?us-ascii?Q?KPPykOfgwKYIBfKqXFmpyGvs1PboYUYEKw64BISkwhTH0Yuk3F8Cx5QhCLEW?=
 =?us-ascii?Q?HA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47a7de7d-0457-4acb-b991-08da96668c1f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 15:34:00.9941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QwAcLvbwVaUYXSmmV822IBtMuEEFPF31Mtdj5ggB1wY3YyZRWBF9F7GuMfk90lMOmvCkpPZ2OHDBZtfFdKGodA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7908
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the driver does not act upon the max_sdu argument, deny any other
values except the default all-zeroes, which means that all traffic
classes should use the same MTU as the port itself.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/ti/am65-cpsw-qos.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-qos.c b/drivers/net/ethernet/ti/am65-cpsw-qos.c
index e162771893af..bd3b425083aa 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-qos.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-qos.c
@@ -503,7 +503,11 @@ static int am65_cpsw_set_taprio(struct net_device *ndev, void *type_data)
 	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
 	struct tc_taprio_qopt_offload *taprio = type_data;
 	struct am65_cpsw_est *est_new;
-	int ret = 0;
+	int tc, ret = 0;
+
+	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
+		if (taprio->max_sdu[tc])
+			return -EOPNOTSUPP;
 
 	if (taprio->cycle_time_extension) {
 		dev_err(&ndev->dev, "Failed to set cycle time extension");
-- 
2.34.1

