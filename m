Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC466E32EA
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 19:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjDORgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 13:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjDORgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 13:36:17 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2045.outbound.protection.outlook.com [40.107.15.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DF84EC5;
        Sat, 15 Apr 2023 10:36:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ifv6xZGW5pYrcdIF2ccJaTiPgKagTtU6IzjoPen1MmbbgQ3+NXrI54uTykfQ+bxcduJaAopLeBjZXjrLCK2VN1s/o3l9/z7Nn3AvnqVLKKVmwwfCZ+wd0E44XnTT0QTa+CZAf2jle5BETJw6I7EYK2eRsHGalavZFFU3yjCIYhGuRJtJlc49MrPVYOaf4PzsPwyrXqrUdZO0kZwRn31lPRTRsb9OEyelMJCd87R04O8tsEQzL/UFoKSi9Ig22rDZoytEbKv6hhPlIySVydp3kwAhZJa0mRCKYBoDlT5SobnU/DQicpAraxmsxpGrHT8laJAso6FBYSTwu/rGYpkxMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=djx9s4StOzchqIprWsTAWDvMggpPNPgl3/lqTPAuDCI=;
 b=agbWG6uOY/5q1O46h+yk66RXlVzXx9F+y/8VIJsQF00K+kJzK2bUWSYM5yKbSnKrspkRbOIHjWoU8OeZttCv/aGaqZV+XFkJhlvFPJdRZ/iEAt47lzUqKZRrixzPwYnsQISvmbhNwLBGq4oDjIl9SEVlO3/txCwVOZoKWXE0BQNwIOlOnWdZmEu9GwLXGVzpF1eyO7IPZl+/PGT1h5boQd+6cPUlxXfsSyI7kdR23heOEmXBnNl4vOJKgvhZddO2kwpTEycFyMor+o1QkpDMJgss+1n8/0JBV3Xd0wTdn2Mu512CSf48hSVTt+/cXTdE9O7rAv7RNCQeb8DATp8GCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=djx9s4StOzchqIprWsTAWDvMggpPNPgl3/lqTPAuDCI=;
 b=RY4LRiOQrEf2re5wCpv8XgGPbfZVAZq7epD5ebyOQLJmJuG+lOahuqA4/lXPO/RELLaMeGR2MNZ8p03NScFGbyIaUOb+KyXXGn8l4SOehicefzoTnyOp3W8FD8zbcnrnuVuEaXk1ZPdCvB1/+77LONmt7vfbHN15cG0osQoJD3A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM9PR04MB8322.eurprd04.prod.outlook.com (2603:10a6:20b:3e3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Sat, 15 Apr
 2023 17:35:57 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Sat, 15 Apr 2023
 17:35:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] net: enetc: fix MAC Merge layer remaining enabled until a link down event
Date:   Sat, 15 Apr 2023 20:34:53 +0300
Message-Id: <20230415173454.3970647-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230415173454.3970647-1-vladimir.oltean@nxp.com>
References: <20230415173454.3970647-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0156.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::17) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM9PR04MB8322:EE_
X-MS-Office365-Filtering-Correlation-Id: e656bbfb-1672-4b2c-2478-08db3dd7dec7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +0bZ4+eoTWSkt7mKkj+cMJCdjnxB81y0WlnyaEFPqff6GpEqLOWED4nx26R54eLJC+IaH7YfPaEfvNRJyT97e0cfgeP40WHIItVKg5xvLAu2EqaNutOzVEQqBNizYbKDFKp45M0DWKsTl8tHakmOemcBNkNo5zanIMIAxOI1D5SVBPBGjzkiiUgu5nYzYRA5iCVQ8BMb2nuoVJubiEwpT+YfLQhRGYbwLyPnTLZbN7vhGAeTr7yuWzqrVPiu6GWgLsJAzTyjEHSKb7CE6/f6EHp/toIFq17rjscWfkVCoVKpFJBGJ9kdJGiVTuoZ5Yr4p3eYyfKrTFksQ8Ssh+HSPUff1AeYWhYueHOGNkcKnYE1yFrgITXKubNd/NOzBhnHzx1ccBKvofnOgldIrPpfblXBtRH8l7Mstuabkyd+ov4Pr2BkuMHIXpl3Kg0dKRiMsf22byj50zW9Dwuot47M+7QftfzZtFkbzq6Ykjy17S2ktmC0VL8KF6mOYQh83JfIlK3PtI/zvdvsUmOVPVXgECTFgs+J099iD04KjjA0umpdBiWL/uAc6f/z+N76X1bdKJWMXCoeMryRqzAzxw8Qd/WbXsgpIsW8dM6abDTCrFluA7kcoZ0CvN2+8zbkRF0S
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199021)(54906003)(478600001)(83380400001)(1076003)(2616005)(6506007)(38100700002)(186003)(36756003)(6512007)(26005)(38350700002)(86362001)(6486002)(6666004)(2906002)(41300700001)(66476007)(316002)(66556008)(66946007)(4326008)(6916009)(44832011)(8676002)(8936002)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E+ks8fsNouY4ldrdvEDGzBPaLSpgn52X4+HicP2ZyOrl9aIeKfRXmiyCr0Q3?=
 =?us-ascii?Q?GIdHsWOHEVz0Rtd66ZEbuxTmMN7+7ZleKeTC+4hXateyZ3dpqzlhCXeXrYbL?=
 =?us-ascii?Q?E+XQgVhHyKwRNf0AGpuxY4u91Yt6L4/q7TgG8tBlwhfNPyB0WgYxjb5nSYKA?=
 =?us-ascii?Q?OkHi7Te7lUo5Rkld+/Gp0CKCZ2j+yhZ5RT7miR10FiLQsSUgTc2uRXMd0ld3?=
 =?us-ascii?Q?w+CjTxTR6/TBMnkYcoNZWGIRxH/XfkIsu2V5fMK+nWazIzTjGY3foxtLCpRS?=
 =?us-ascii?Q?87cedldk2GJTtE0/Qsmdawv9ySTTO6SaW52eVdvalKNK6nQjBIsa6jYk005S?=
 =?us-ascii?Q?HdxJDxGjR2GNGlnvF1tO6V1RLJ5eWxGoJbTevpLojMEBwht3Pg8Kve2IbxDm?=
 =?us-ascii?Q?bcZT4456u47gCprNVxcHtLvKdfThHug6mUXDWNdj5fVNGZ/WI1sYzlgtYiFJ?=
 =?us-ascii?Q?WEeKANHdmsq1uHK6jjr39xyJndhIM+RnwrFjsijpJ4qz3X4nLToBuxwuWPf9?=
 =?us-ascii?Q?6AGGnJ1vCCH0qsVnG6mLUXBRTA081hFqpKeBukw4kFsiuAF6OqZpYa31booc?=
 =?us-ascii?Q?qTocsj+qFbbq98OSHnvvrUGWZze3/bjO7VMgPgce/Gihp5855ki+4dEHCFgi?=
 =?us-ascii?Q?SBRcexnbw/6hbZRnapBCPUU3fO7ak27b4Sae6DduGbLQekLL6+tgAmcnT9Fy?=
 =?us-ascii?Q?ifEKCdi7Vv6r1L+84lmk5k/KO9ptLRIZtTS/kIgj4BT9oO/Qn9HxLAF9wdRw?=
 =?us-ascii?Q?9GUBPZnL4g3sGYD0hHiSMM2a3moQjEkDYSasHtA5aP7YvkLEOqJyn1PjQ54t?=
 =?us-ascii?Q?vF4OojMTn4OlOFyJitJeIJUvtiWBLFh5SsmvJrbptaIThnYx0s0EimQSfhuE?=
 =?us-ascii?Q?Bohx159wI+FrUl+qE3dYV0IkWDIupHm0w3uZ+WSizsXsD/hSN5e0VLlwwBnt?=
 =?us-ascii?Q?py963YjtVy1ZHaof0kaJ4hI0ZLyI+aZAwLhLxHBEcSHlpwwWdcASVkSlh0XE?=
 =?us-ascii?Q?1CwURrShZyoVIedAuIflJuSKfkCIzc+oOWBdVUdUT7t4lI8060XgaZU1xgAr?=
 =?us-ascii?Q?wvc2kXAVtaO4dtCKgNw+Jv5gCYDWBVLtF+kU2Ob4h+mXXpVt6Rd7LQCxZM+Z?=
 =?us-ascii?Q?4Bo6FA6dMLQEHVJ3XnyWjpZCAKkvHaRnKZdujJxzhLLcU3wubXJtSiiKF2pd?=
 =?us-ascii?Q?Xee1UV800uEiPo27JYYdFTJTTRC/Qi8ZPMScNY0rRUVb4Z44Ng12AGVDEhft?=
 =?us-ascii?Q?Ae6Swu3U5a6965pwSLl7T7hVxIuB+aIpUNVbYdvGvuLkmCxgPmOkWciRabXg?=
 =?us-ascii?Q?WVO/2usBBPlLxCHsfg95httQ6nNBMPB/4PBwMXRl3cVzPWJiFlHwBtNdfMje?=
 =?us-ascii?Q?fgNIGpjmyE/yvL4u0m0/2yKPzZCVqstqb0fM72v4ilObNPltxz8uVybeyyU/?=
 =?us-ascii?Q?ZmEG2FESCwICRzncz+QHhkQnro/axRPrfPn8GhnO5o+vdjnPUKGliJJ88Lv9?=
 =?us-ascii?Q?w1wNnnXoGXC4TO6j/SlgSK6I7h0l+JC00cv9ssUaCXKaGa30i6ADlphdfiIK?=
 =?us-ascii?Q?9+aPNDQBLZxq/hqbARfLS+0LAiLRQgqYfQW0+iZF88jlV7UJ8zyZPCD8thSC?=
 =?us-ascii?Q?uQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e656bbfb-1672-4b2c-2478-08db3dd7dec7
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2023 17:35:56.9770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: blcHeQwRUYxRXkFNVB3FmSzYKPeaUlnJ+BjJekFhQkrX8QrzDpdr1NA8wCtaYM/k3vfcUE4pvUSftYqJmT5fPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8322
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current enetc_set_mm() is designed to set the priv->active_offloads bit
ENETC_F_QBU for enetc_mm_link_state_update() to act on, but if the link
is already up, it modifies the ENETC_MMCSR_ME ("Merge Enable") bit
directly.

The problem is that it only *sets* ENETC_MMCSR_ME if the link is up, it
doesn't *clear* it if needed. So subsequent enetc_get_mm() calls still
see tx-enabled as true, up until a link down event, which is when
enetc_mm_link_state_update() will get called.

This is not a functional issue as far as I can assess. It has only come
up because I'd like to uphold a simple API rule in core ethtool code:
the pMAC cannot be disabled if TX is going to be enabled. Currently,
the fact that TX remains enabled for longer than expected (after the
enetc_set_mm() call that disables it) is going to violate that rule,
which is how it was caught.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 838750a03cf6..ee1ea71fe79e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -1041,10 +1041,13 @@ static int enetc_set_mm(struct net_device *ndev, struct ethtool_mm_cfg *cfg,
 	else
 		priv->active_offloads &= ~ENETC_F_QBU;
 
-	/* If link is up, enable MAC Merge right away */
-	if (!!(priv->active_offloads & ENETC_F_QBU) &&
-	    !(val & ENETC_MMCSR_LINK_FAIL))
-		val |= ENETC_MMCSR_ME;
+	/* If link is up, enable/disable MAC Merge right away */
+	if (!(val & ENETC_MMCSR_LINK_FAIL)) {
+		if (!!(priv->active_offloads & ENETC_F_QBU))
+			val |= ENETC_MMCSR_ME;
+		else
+			val &= ~ENETC_MMCSR_ME;
+	}
 
 	val &= ~ENETC_MMCSR_VT_MASK;
 	val |= ENETC_MMCSR_VT(cfg->verify_time);
-- 
2.34.1

