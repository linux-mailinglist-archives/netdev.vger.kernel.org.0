Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0935E7EDD
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbiIWPrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbiIWPqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:46:44 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140041.outbound.protection.outlook.com [40.107.14.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB21EEEA9;
        Fri, 23 Sep 2022 08:46:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n6TaFk/BGxquJbGNtQPjJOzRFMg9eVOIGuzJ19BcWESlIekHlB2CS2MOQpwWK9nPXI0G01Y1bfFNrAOuzYdQwGf6ewwDnQTeAfvrcDxvnSpBip87YdWMxaags/mLgYA3vGrK+2za3SS/1Tb5KkePTezntTjFwhLrlU24Lno6mhxqiLZqzJ3F/eUC/arS24b9K77qgbJncCSWfTt9sJi6nGLMLrojtYAM/5hLvBCvQAw+h1t9h00GEwGir5A+IgHRkYtAL3jVI+6lhZU5MHKzS4z8lPvQMQoqhSOwf7ZuOFJCamR5+FpsNvDWl4zaq7XbZh5l6bTCbu4rbr/cQIrCTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+8eJ7yWHziSfb726kvIjhWxXFJ9cMO8kur2oOM8JYcA=;
 b=P0PxO0tWufFcnPoTgv4LVdHKMCGwIGh1XGm20xH0eFoMjh2glgE1lOGGRYY8AUS7IX4TSA6EJWpnpmcjadeGmxWUwtwljx+SOCmEyUh+y/o3XjWqcPWvwtPHvuLIFaTeINd+Lofkbl0njROpYQgmNUnQ/e41QzYGLpbS5AGdyLROQ29mayZquH1Ot4VPu5Y3pkghnEVwhiyr94FF5cUs/btPckdFaw5QbxRc0XonQFd+zUByID1Gopspi8heoxNldjKZikClzXsUM5q6wsyeD/Yhlk9LVt7lx9XwvGhiOEZw/5xz8vV1+wQ1KXWFQLABvr9lIhmVTZAZN+m7w9ciEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8eJ7yWHziSfb726kvIjhWxXFJ9cMO8kur2oOM8JYcA=;
 b=IElYZjRmXVgyR+7pIMwaZ91Ehjq/fxXq3reWnsbBKhBsJQRKs0kBogb+EFQKGaHgz+t2HzkRs95fPkCaK3bEX36LE5h1Eb4hYJcK4hKX875F6T75TM9UO0pVelgeAPCr3trv62cUKqi5jsKeR2D065dG/ozuj4WOA7hFtcYfPjw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8996.eurprd04.prod.outlook.com (2603:10a6:20b:42f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 15:46:39 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15%4]) with mapi id 15.20.5654.018; Fri, 23 Sep 2022
 15:46:39 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 01/12] net: dpaa2-eth: add support to query the number of queues through ethtool
Date:   Fri, 23 Sep 2022 18:45:45 +0300
Message-Id: <20220923154556.721511-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220923154556.721511-1-ioana.ciornei@nxp.com>
References: <20220923154556.721511-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0152.eurprd05.prod.outlook.com
 (2603:10a6:207:3::30) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|AS8PR04MB8996:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c0f2288-d524-4985-1068-08da9d7ace1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XqcrJuNLZKcHog6ATpCmR1EKNBFO3K98tg4TT3Atff6NWlGM6v2B81ygQAGD3U2mHn0/8EOo9X38APTZAX8dDf9P2Axxc/bmbHClR2bK6d0VnPyrXjEikotV2erooYPooHSE2r+68dFVWexkjI2E+bXiaDzmN/hS6GADJhATEsJKfXbYJTRf6oebPdg9uFyJ+opzJMff25d9mVGyUBxoTmJm1PzwLz7G2/EsY6ZB1P9otuAWLLZLoxvKGIexArazwJNWf5l+Qk7ijbusE1UUQBU7Urd3N+tCrDQVIY+AQJ6jbshZhGqwfIEUOxPpZY/3g/ilwnZh0Q2693Rn/WLAYPh9OjLBoi/emC2cIYnRSKk4w2ZjMQulmhiuARcmoSegP8fb37fA5C2Ld3qVaXEPeuccBVSb5Mc21ITIrVkXasmCCvrMmaWCezqLClE9ixT6/NkjlGfZLbYRs94wFm74wSeduc7lu7WInGNYyAJNCEhCSd4E6VJM4NyeO2q9Qqyw+vb04vClD/XVvDuQU2PXM/0RPWtrf3Bx5DGn6fGgJ6LCTu/cwmbUiXiKyrkE7DFZ5uoBu31Jfk4B+8VrKWF3QA79yTCEtUO9L1z85WhscVRxwujcRrmcAzYjJP1Xt0V0h6MlfznbzZ9DQph/bR47T3yYp77Rcr9Nb4WcUroZpxgkhsdrHs6ilZIfOfy9XvJd1feHI5olrV2ZaRkJHfTIJzH4d7OR2N7SxEd93aZYp2fxMG8gKTttt6MS1SfPd/uBOvdQuT3Rp++ndDRnXRMg8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(451199015)(6486002)(36756003)(316002)(54906003)(2616005)(4326008)(38350700002)(1076003)(38100700002)(6512007)(26005)(86362001)(52116002)(66476007)(110136005)(186003)(6506007)(83380400001)(6666004)(66946007)(2906002)(66556008)(478600001)(8676002)(41300700001)(5660300002)(44832011)(8936002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vFeVuvcHgEd7QUrw37za5aWuvUC+IsgASddXCrevIGNI6jUGjZiJYMcGBuGl?=
 =?us-ascii?Q?dlbgJuz5L8WWeCgTQ1IUft0Mei2gvQw+mSVMKUkm4ELP1/yfznIpY23O5gvJ?=
 =?us-ascii?Q?elhMKVWQ8Z91eBqKFCF0NV0VhxW8rFbCbnsFBy1jNcvgLoKJfPaO0kIPkI+m?=
 =?us-ascii?Q?lQgl5k2NSATFBkbxA3BbzIlpw5JS+QtMCPdyex8JvbdLIrHj/JqdBpAN+3Gv?=
 =?us-ascii?Q?GzAIozz99+iB5N68h4Cr0FVhyhxL8asnonTspYcvl27g3hs9LSByBbtia2wf?=
 =?us-ascii?Q?1YIFfy8q/uAP7Ql2VcK26mDG48XuTbRkrjXjruDQ4fEuQ9azj+PUHxqI2NPC?=
 =?us-ascii?Q?hP5TsS7m/dXkoopWalq8DNNLDI47rPYUp/Xm+8ve2G46J9joOZksf+E9P5GH?=
 =?us-ascii?Q?IHh8MyOarsz3x7zgBuqh89OPUc15fjmV89O12LnN4XP+cucqQoIXFYRCs9dV?=
 =?us-ascii?Q?+kIIkVNXte2NTfUyY4QSVGDB37hDhlhmXZxjTYS9K7RFllT71EgXtxu1YYRa?=
 =?us-ascii?Q?pNbZEv8Hxvws3Xp/ZTh/qtMmYvueVSJ/uWK2q0YjLkEClxRJuZtSXu8Y7gRY?=
 =?us-ascii?Q?bXBmT9PCJVhV15z2Cd+LfSxgeMDv76oNZwvUSKIn0Zh4Vp/qV3jS2urlMHF7?=
 =?us-ascii?Q?QYaoHYGp0JHBDwEgWH3YABxNKpRPhhN4vQlzlq58faI3lpijwd8TrFNAfRHt?=
 =?us-ascii?Q?eoazBkiCThRVch2lkF+3uotNua7D6rP6X8Ig55Gd5WLjPElEFWj8gW9KC+nv?=
 =?us-ascii?Q?fZFMfpUCJQ3FznJlKLyFl7fyBASf6ljJ4jglco6EGJylH+t0HnooZsYSmdmM?=
 =?us-ascii?Q?an/KsVZFN1Xk/t7N6HkAu91NJu/MavYE96dVRPrMb2d0ABWIxrgeuhp09emo?=
 =?us-ascii?Q?ahbMvFOSqbX5jHfz4j7xgKMjne74qtIgPVK1BWcSnq+FhOjw+rR04+ZTl36W?=
 =?us-ascii?Q?y+RyiZYwezP8jlgkMUVOAQu5+0tcP1Y5YT+i6qx7JHQZEDKpUwvgBdHNdXV9?=
 =?us-ascii?Q?OywgRkfMO2BV3SilczCup3IAJu5fc0JP3iOkMs8wXpmbRbua6C+axbHMCosm?=
 =?us-ascii?Q?Gw3wDctelLgWyzFdnSCKpZuDXmfY9C9YYDLs4IFwS/MsKju/F788YBoz86yZ?=
 =?us-ascii?Q?fvQLvJ31foNYirFNhPAWOpHHOBk7eCqpTKTF/USMpxZG/Kq3kkizOev2RbCN?=
 =?us-ascii?Q?Bvf4wJvZYRtEgpYSHOPVu4txxyZ2IIoj25mAsO8w/45G0sCcN3xanEPRNNbU?=
 =?us-ascii?Q?WcsOCkX0CNyaMqMB/O0HacewDhHvNHvgFGucRcDO8zjY8RlLghTICgLT3iEz?=
 =?us-ascii?Q?S+mbnOLfO9Gi+w8pskKfLHVlEKYaBCEAXWqW2hZe5uQEstLc8Rgjerw+/45G?=
 =?us-ascii?Q?S34xHMOWH7kUP5YbgcnyGsag276NFvl5EzxloPdegAoa949wt3L2I6toZRh8?=
 =?us-ascii?Q?p782YuFc+n8OAGqwo5FLkFJHNW60PMPmLH1yFrJnI7bFBjDKYhywPf+0ZrgA?=
 =?us-ascii?Q?m4vsXDk05cuOQmfgH8pQE9bzOBtjTMHcIl4n6HCYuqd9WXkYqr1U7yYDECt/?=
 =?us-ascii?Q?YCraQRR03RHQn2dh/EC5WY6T2jNE+OkQGRGNUdBg?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c0f2288-d524-4985-1068-08da9d7ace1b
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 15:46:39.7374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xUabvRsaYFh7h4E76IFZDjYu2J6GD+1S8Cs5tCwplxbTCh7ZeRiqDZDqe21DjTuSJYRk5xCpM7dF6AkfhKqpxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8996
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>

The .get_channels() ethtool_ops callback is implemented and exports the
number of queues: Rx, Tx, Tx conf and Rx err.
The last two ones, Tx confirmation and Rx err, are counted as 'others'.

The .set_channels() callback is not implemented since the DPAA2
software/firmware architecture does not allow the dynamic
reconfiguration of the number of queues.

Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  | 27 +++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index eea7d7a07c00..97ec2adf5dc5 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
 /* Copyright 2014-2016 Freescale Semiconductor Inc.
- * Copyright 2016 NXP
- * Copyright 2020 NXP
+ * Copyright 2016-2022 NXP
  */
 
 #include <linux/net_tstamp.h>
@@ -876,6 +875,29 @@ static int dpaa2_eth_set_coalesce(struct net_device *dev,
 	return err;
 }
 
+static void dpaa2_eth_get_channels(struct net_device *net_dev,
+				   struct ethtool_channels *channels)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+	int queue_count = dpaa2_eth_queue_count(priv);
+
+	channels->max_rx = queue_count;
+	channels->max_tx = queue_count;
+	channels->rx_count = queue_count;
+	channels->tx_count = queue_count;
+
+	/* Tx confirmation and Rx error */
+	channels->max_other = queue_count + 1;
+	channels->max_combined = channels->max_rx +
+				 channels->max_tx +
+				 channels->max_other;
+	/* Tx conf and Rx err */
+	channels->other_count = queue_count + 1;
+	channels->combined_count = channels->rx_count +
+				   channels->tx_count +
+				   channels->other_count;
+}
+
 const struct ethtool_ops dpaa2_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS |
 				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
@@ -896,4 +918,5 @@ const struct ethtool_ops dpaa2_ethtool_ops = {
 	.set_tunable = dpaa2_eth_set_tunable,
 	.get_coalesce = dpaa2_eth_get_coalesce,
 	.set_coalesce = dpaa2_eth_set_coalesce,
+	.get_channels = dpaa2_eth_get_channels,
 };
-- 
2.25.1

