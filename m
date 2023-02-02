Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEDB168725E
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 01:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjBBAhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 19:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjBBAgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 19:36:51 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2071.outbound.protection.outlook.com [40.107.22.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16AD873758
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 16:36:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=biKDtlLjemOvTXQKkeAM91tpJXdJPMPSkgv5lTx8gwVMoiV9chiSoRxus08v9pyoIuYigbQhd3C1OrpNgB+Bx/eCT9ut6nbsdKmC0R4QY4jujwIjChov/Hbxg5mA6sGHnP00PR8jb+ql1BRxN9V9ycXdekiMMIPcsuKTuQ0fsoF8Qbqda8aUj/zEEHMkN/Yb7k8hS2oxDUzID53HoZVdlW73Aygz6y9x3UQiJRgomHIIHhBjt+5gDaU6CX9lAv7y7nJ5M3ftek3hK7fnUL7aQafuFMi993M6td+gKdD6nlR53JFEmkjMnfJ/drmPCLAzyDySjTfvEoVSawrNKHLf8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TTTZTvyVNe41cKDA4uBXDcAKiM8yQQaQ/28SH2xi6KQ=;
 b=iYlNEXNzV9l3kTOUXNbKzyfJ0Rgm14y/hjNw7dLPULfAVLpOxASyKr7A/PEwtRwz4mFjCCtD63XJqX+kdO2UcYwn0wadIx+kCq55Yiikf3Wh4NbtOGJVALMXmRp6rOIWOVRmAprAEVEJsUQMXKeLqTOCKNYIKl9BwcPOPQVS5fvFtofP7dbSeh0wqCkYypQXH+l3z6afDThGB1vzdN7kHjroxPl7aZ08520TrlsMB5A2tqnGESZLN8CJrGKXKu3fSxGhCUM9BDqYVQyMzmRyLyKiMyy2REiOoKM6SEE7MJd/PKuZU+BlR9Q7GfyHqjjtsXhomoalxWDl8+VGfkok7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TTTZTvyVNe41cKDA4uBXDcAKiM8yQQaQ/28SH2xi6KQ=;
 b=BaZ0UtoN1nKGfI0y7q0//eXBTF97P0n/atD+BXd7Wlrcu6M5he1pgETQFla+wpOq03gERETB/2XtxOsxM5S/pzkLi1+1iTE1DRo8d38htI7Q5Js5mWUmKq8pVqVswbMg7rcsRpstMzZcA/sUoSLg5Q4Br49ljz8IWGheRL/dxiE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8789.eurprd04.prod.outlook.com (2603:10a6:10:2e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 00:36:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%3]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 00:36:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v5 net-next 03/17] net: enetc: recalculate num_real_tx_queues when XDP program attaches
Date:   Thu,  2 Feb 2023 02:36:07 +0200
Message-Id: <20230202003621.2679603-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
References: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0032.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:22::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8789:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dc755c9-b3aa-4821-8f06-08db04b5907d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xjs/gbfpx0NfS2v4pYfEnOhZjtUfSuGeUy/RUmSRjxbXiE1DP3cHlNRQx75+pfmWirv7TdOmbMhSaSHmbhe1VuJUTE1LiKZT29XWIrgbm+XEMRu0Rkk0FBWq5PIYdXzfVnvBfYVx43P3dmJkONBaphHhReSYkG97NrZTe7hziPRXpTVMDlgyGdJm7yeFqi92uasuZC9A4BHSKh56TuHr4kT/mVYx6L2Z9hapah0Nj+rXWG3i7hZURHg+K8t0rw7T85fBWL3ZqUSdC8P23vR9hDQHvrgcquzKD/Dcpuv6xm5kMxMc5F2lOhAuwJ+SyjFSzeev6Rm1xEHBU0OuCWNYt/utFPCAQV1ApaYUvlO4b+iU79D5hAbvGa9ih0jVdceuFq1lIIl+RfsWgF9j4hVLV69Zk04ofVynT9VoegAUsD9N+y9cVp2KS9KpbZHveNX9yvBDgEZ4HNShmR6JsL1EPJOLobLkpLurjDCYAthBhGqpBPWe/I2Jvo6BanZoeYMsphJnGckMBH6bTkvTRYdGccPYyttlEl6FsaILcbgb7KBDYQu5FhBN1e7FpsD0NEiWT4WtITc5cifl89R/7V6IGoNypEKSylcFF7/hkLt4PU6o7m7+OxeW+Qx8UktzmwLxhloezF7PRNLBbdfLNePTdGU/+Q4vKPoRU3sfYCLe/kWq1G8GVaob1yurgWtCD7FDpgN/b97hSSJaAN3N185Raw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199018)(36756003)(2616005)(7416002)(6666004)(52116002)(478600001)(2906002)(6486002)(38350700002)(86362001)(38100700002)(8936002)(54906003)(1076003)(6506007)(66556008)(8676002)(5660300002)(316002)(6916009)(41300700001)(44832011)(66476007)(66946007)(4326008)(6512007)(26005)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tibdi7dNyzemsE1OYmqYIkKPdoA2hc7VSM/5wyncuO6O1L/mC6pan/aX1Tfu?=
 =?us-ascii?Q?rropoN99oa0I7qE2xHBdgCKpGKNrTTt/io+U+eVjE41LDla6ujxhhdTPbG78?=
 =?us-ascii?Q?B65lWUYUWJFhOZIx9b57gWycnecOBvkPi3rVQ4nHBG7Y6M6SQmok06hrKPar?=
 =?us-ascii?Q?L5VK2Ztf3tvrMpIMKEzY8WQRi99imVzh+N5+o++3077472wv5blyZSAHDfX4?=
 =?us-ascii?Q?w3aPvDzFfWyXCSYCVcxJ2rwYuRLCBXPmMZ41ftJKYPkyLNzpFwGGa/STlCHI?=
 =?us-ascii?Q?kxefoLAbItc/afr25Ck9l6s3pGtv76C0jVPj3vlFvHShfU57v6NM+tDlOFkK?=
 =?us-ascii?Q?mmUKrla+LkauYETa0zPEe6PeAKryGV/vIYh2JCzjyYQKBskKyHem4/kfuF6n?=
 =?us-ascii?Q?VgXadBGfprb1iU1Hk2N+ZehcrfFgvmd7Pl4Tp0alGhgr2zW8SSxBhAZNe+zG?=
 =?us-ascii?Q?x3iqDvwl5R8NKXICVQG63ITGeGYJLuWwW5cpTEamPvw392fPCdw2GuiuzOH3?=
 =?us-ascii?Q?zd+LS+HjvAVTaaBGEA7Ja/b34dT5Kq5YGrxiJ2NeC8bpEqboHIAdTzrwqIGT?=
 =?us-ascii?Q?3zG8Bz6X1P5hQ6qEQvW22NAcmtOeKbAtXXaJDQrJJbxrcBWPCEG95T2aaBt+?=
 =?us-ascii?Q?KtvWNVj5crB3qn7uS6Op5SEMhlA/69R5g1tRfGQEYXbODStO9pD2WODBJ4ZU?=
 =?us-ascii?Q?G86XGOzOSVePvxp1Fg9k10uxnWbE928a/LYq7qzmudsb3YucMV9583RQTBrK?=
 =?us-ascii?Q?7Hvwbm7Fn1st7xvbuPriUtFrlKKICuEs0bpx0IQ8kOEYZvcV/l051zFPg1UT?=
 =?us-ascii?Q?lR9jP6720CLAbg5ygwnDUgr+L8zLSlGi5z7KgBy10sslC1HdKGajopaWkZdI?=
 =?us-ascii?Q?JytIEh7S0H/a/soLHF961oiFgWuiluFk2XvVy3yNWLJVhnduXIz+uzzjyQVt?=
 =?us-ascii?Q?DMj+WoAE0P/FA6dX9EWbp1c710xMrHB4tpdL87uFyTKLVms7ToKZNlZp09/L?=
 =?us-ascii?Q?gPapS45dgWn/uFtB+8zuJSfuqMO/U8lYtn4gfGUMaqR26uX6iOwg9GRvlTRX?=
 =?us-ascii?Q?FDRGa/XzvVqyzxu89WptbcQ5cYRReqIgWY5cbj8BMNXzRZDoLXxTFapoRuho?=
 =?us-ascii?Q?w8YD6qw6lD4JFf2kmfZM3E1D7sMQUM8QxY1JPZrf2CwNf0SWZZikqhdaRus9?=
 =?us-ascii?Q?2XDooQa8v3hhZWlAFh3VrOS2sB3YEMoqjPSSL9s2dZW+jZzYBVww0A8a8qvL?=
 =?us-ascii?Q?JrTyeP7VWTmbs0vHaPgzKxxs6K3a0zIrmWY1zNUkY8KqqIzqgt7ytsK8oBuG?=
 =?us-ascii?Q?EbtknQolp9juU/7+vNT2aez0P+SoKAw8+DGMXok8iomBgl3B/zZErrOy1yeD?=
 =?us-ascii?Q?+kdQi2Zq5g5zhsgL1lMWMbvogsK95Dy7oWNU559WayXK/Q9hxWzl/a7vr1uu?=
 =?us-ascii?Q?EMMRYgrH5xMur9R4f5dom6hK3rfAkkx0fexPoLwbniDQePZ/6ZYICpdI2m7g?=
 =?us-ascii?Q?8GhJ+8Lh+zOMAmtYUoz16996MP4EAUmXvxVBJtn93bpkCjwCcsAc3+bcaInq?=
 =?us-ascii?Q?gXkptDLW4Rt3EgprlDpmj/VONU9i2Cvdj/KlHjfCk8Pm7YZhD2vW/rrMTpiT?=
 =?us-ascii?Q?KQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dc755c9-b3aa-4821-8f06-08db04b5907d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 00:36:46.6077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WZ8obsED4KtsoWshq6TXqsFU2EsKEQYo4ApuoltRXCaZoEsyYcnnF7RRvcJ8sLn5i+xfH3uBdgo582MBU5jphw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8789
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the blamed net-next commit, enetc_setup_xdp_prog() no longer goes
through enetc_open(), and therefore, the function which was supposed to
detect whether a BPF program exists (in order to crop some TX queues
from network stack usage), enetc_num_stack_tx_queues(), no longer gets
called.

We can move the netif_set_real_num_rx_queues() call to enetc_alloc_msix()
(probe time), since it is a runtime invariant. We can do the same thing
with netif_set_real_num_tx_queues(), and let enetc_reconfigure_xdp_cb()
explicitly recalculate and change the number of stack TX queues.

Fixes: c33bfaf91c4c ("net: enetc: set up XDP program under enetc_reconfigure()")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v2->v5: none
v1->v2: patch is new

 drivers/net/ethernet/freescale/enetc/enetc.c | 35 ++++++++++++--------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 5d7eeb1b5a23..e18a6c834eb4 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2454,7 +2454,6 @@ int enetc_open(struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct enetc_bdr_resource *tx_res, *rx_res;
-	int num_stack_tx_queues;
 	bool extended;
 	int err;
 
@@ -2480,16 +2479,6 @@ int enetc_open(struct net_device *ndev)
 		goto err_alloc_rx;
 	}
 
-	num_stack_tx_queues = enetc_num_stack_tx_queues(priv);
-
-	err = netif_set_real_num_tx_queues(ndev, num_stack_tx_queues);
-	if (err)
-		goto err_set_queues;
-
-	err = netif_set_real_num_rx_queues(ndev, priv->num_rx_rings);
-	if (err)
-		goto err_set_queues;
-
 	enetc_tx_onestep_tstamp_init(priv);
 	enetc_assign_tx_resources(priv, tx_res);
 	enetc_assign_rx_resources(priv, rx_res);
@@ -2498,8 +2487,6 @@ int enetc_open(struct net_device *ndev)
 
 	return 0;
 
-err_set_queues:
-	enetc_free_rx_resources(rx_res, priv->num_rx_rings);
 err_alloc_rx:
 	enetc_free_tx_resources(tx_res, priv->num_tx_rings);
 err_alloc_tx:
@@ -2683,9 +2670,18 @@ EXPORT_SYMBOL_GPL(enetc_setup_tc_mqprio);
 static int enetc_reconfigure_xdp_cb(struct enetc_ndev_priv *priv, void *ctx)
 {
 	struct bpf_prog *old_prog, *prog = ctx;
-	int i;
+	int num_stack_tx_queues;
+	int err, i;
 
 	old_prog = xchg(&priv->xdp_prog, prog);
+
+	num_stack_tx_queues = enetc_num_stack_tx_queues(priv);
+	err = netif_set_real_num_tx_queues(priv->ndev, num_stack_tx_queues);
+	if (err) {
+		xchg(&priv->xdp_prog, old_prog);
+		return err;
+	}
+
 	if (old_prog)
 		bpf_prog_put(old_prog);
 
@@ -2906,6 +2902,7 @@ EXPORT_SYMBOL_GPL(enetc_ioctl);
 int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 {
 	struct pci_dev *pdev = priv->si->pdev;
+	int num_stack_tx_queues;
 	int first_xdp_tx_ring;
 	int i, n, err, nvec;
 	int v_tx_rings;
@@ -2982,6 +2979,16 @@ int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 		}
 	}
 
+	num_stack_tx_queues = enetc_num_stack_tx_queues(priv);
+
+	err = netif_set_real_num_tx_queues(priv->ndev, num_stack_tx_queues);
+	if (err)
+		goto fail;
+
+	err = netif_set_real_num_rx_queues(priv->ndev, priv->num_rx_rings);
+	if (err)
+		goto fail;
+
 	first_xdp_tx_ring = priv->num_tx_rings - num_possible_cpus();
 	priv->xdp_tx_ring = &priv->tx_ring[first_xdp_tx_ring];
 
-- 
2.34.1

