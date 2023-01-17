Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3687A670E1A
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjAQXwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbjAQXvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:51:54 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2042.outbound.protection.outlook.com [40.107.14.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B204FAC6
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 15:03:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZF3wFzjgh2Pd//VdSLiYzHB7gC+IEXUXX+LYK7FqO28DjjoQDChkiGQ6rEDKIsNiXpM9HlYqafCNzHRGGgjA259dpAte6Mfl16uhu/z5kZTpXe/8VO6hiJpXiStP8BtxZpVLPCIhGgYs6d4R66pdbbLYXp6uiCUeuFNVUunleTgulLJBiaaNKxOJK5SbSgVUb9BlB0LcnhMKh/4OsyfEHPbjEC0BIykafhGVPsXGY0SU3rR1d0D6HJgWeEyj9TebbMBZXYMorwUjH9Y8Qr2xMa29VmGuscH7etrCJA+j0lZyuHaQnyFRbtVj3PTtp9LOlSNRpGGcn9mcx+gf4u8iZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cAaVi/1S9hewz5Z2Z1GeO4lPYrDqiRRZgO/pAzNvBIc=;
 b=QJvuf4GMSE9FPTZYNvhqdRXGz3Wvegw9r1u1myxj3kYO5tXTAXdf+XGH5hfg/+bBgVbHy8lnGJR8hhJt9dA82blz2uwTFy1yTCc6+W5q4A51nJl4lzXQWfqinJqU1aOk9ghvODW9qH9Q6I4Wf9AZaMkBbKBog12is7MnQpxAOAvlHi6xN8s70uyEZOuBB06m96TbwmB6sOvMsgGKyl6a4SGQRLlBIG95L/R8q/U5hRUjqoD6h5rivb8SCbO0To1PuYBwDHYmQquLJkVRilMKp6TeyXSb47I5npg7tMaFP+Gim1syShq35sKDfQhkEcaOX/4igEoVNcpLqXDKEJ7f4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAaVi/1S9hewz5Z2Z1GeO4lPYrDqiRRZgO/pAzNvBIc=;
 b=qqbXI5uI8x4e0Jo2JHnveu6C+FbOPZa+XzSL0jDNnPTlCzXhuGbJV6Uht4rf80WZ9x3TrxJJ2EWAjuzA+U5AuIkmHAM/Cj2DMOsWcujbAjPoF6wTq2C6k779cXqCerLjNo1gtNEpgQU4K3MUhma1P7IQVRU2rmJpFVMnpqjsrhA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB6808.eurprd04.prod.outlook.com (2603:10a6:20b:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 23:03:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 23:03:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next 07/12] net: enetc: split ring resource allocation from assignment
Date:   Wed, 18 Jan 2023 01:02:29 +0200
Message-Id: <20230117230234.2950873-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117230234.2950873-1-vladimir.oltean@nxp.com>
References: <20230117230234.2950873-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P195CA0002.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB6808:EE_
X-MS-Office365-Filtering-Correlation-Id: c3b76311-2404-496b-3581-08daf8df046c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J8/S+NbYR1veZmwYB0o04JMTiSFIA4vnRV+fi+03hO71zsZwqCpRNQvdF1xy9IiZ5YOWGRDBvDqOtKiE7QwokYmUYvscJzlr7jWTp99WNkhroXE3zxs8rDuQIhFX4OtIeaOksGuFm79IeNfNESdy2FgsEJesbj6yhLLpEsr0DM9of/Z6YlCJHq0vE+NwWrOTznpSQg0PvJfdVDRSijyr5gs8dAVK7yHZkUr0SwWj5+LQJxeFDAOgNQhi6SXWZyUgWO3d/rwqhHtBBg2phqNl4dV2P30Z5qp04iz36gK+A9/EhYaYz9jYGLTU0J3G8dIaubmti5+39SddjTuChVfPCQlxwDYAhZ8iVfiBaJ/vU+iXJCMZ+3oW1CThMbEOxhjV8PUFu9PweuFjoVUSpui0jZp3+Y1uXfXufyZGID/s5QKjsNf2Ixu2NnNQans0FgYHCJ7ZBqGFNCM9MVFHCEK4oTQwu6ecJE5tBVObWkvf9m3Wzt5uC1vppVMCR+XTdYRJn+yIzaMIlcmOGkbPpwmHpVCS03zkxGlphP7hcnmuZJrjm4eZMeW7FaSWAM+Q487uvzGYQ/pP6WaOHmZVP3f786GRa/osrmzv5lKAkZmDauj8B8hzwmspXiGRHKX/8/VYPf8WwlTWaPNlnkx/9wOgAjnxsIVKuGyAf1IkcfM+KbyV2EOPUPLSkXVe3evZwgwky7jXal+MaypiEYeIJMqcew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199015)(86362001)(36756003)(38350700002)(6512007)(30864003)(8936002)(44832011)(41300700001)(5660300002)(66556008)(66476007)(8676002)(66946007)(6916009)(316002)(4326008)(2906002)(2616005)(52116002)(83380400001)(38100700002)(186003)(478600001)(26005)(6666004)(6506007)(1076003)(6486002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eOWbbzJHVOfhTg4pV0UwEIfROP/mjVxK/gJjsT9HB4qj6xraAME8BVbWaaq+?=
 =?us-ascii?Q?JsqDaUxowqw/BS1orV37oCR3kTVBFxMEYv8XumvURmJq3i4Iry2Flzj+VZyG?=
 =?us-ascii?Q?e77rYotYZYrOKkeGW/9O8QOrzewgZVUYzCPFLEv061DSjp959Zr8u/Yxmzw7?=
 =?us-ascii?Q?8oOzXHP/VKhUn68k3l0NR9s4MDvVsqfm2TS9qk+wVlKyxBcyKbSyPN0DBr7O?=
 =?us-ascii?Q?ga9L4pjZE9ahuXJNREkjjYI1QsqahhzOeP+/5L+PsftlfrIAJOgSKNPMSjlU?=
 =?us-ascii?Q?0qr198FBqmvRdvyQyKpjXLWNRoaN2kO+ifbdc0Fant4gbHtDqT58z/gpqM6l?=
 =?us-ascii?Q?BDf0/bqhm1AyB3EncrY1clkGDVJnwoscfuqQzffrs/yez0ZxfJuqIOGL4hzC?=
 =?us-ascii?Q?4Lwf/yGCC+E/Y0pAV1P9GmvPkxYdhOctr3+7dfKsiPxe4iMO6h4HE6ICZdtQ?=
 =?us-ascii?Q?zgBwJkwgAvA8HxRjjUrvpMy0LZG2fplKFBz/BN0IGsnCdcbFHwmBtWE4baB7?=
 =?us-ascii?Q?iwBia6EfJ427goBw30Q+d2iGWmeintkNteDacU6ABAia3ZUsrFOLph3g0h90?=
 =?us-ascii?Q?1uPXF6IyHCMVgQod1iNDttfx6MsY6GQxm6snBNTBbVchE0owtiDHDCjYn3ql?=
 =?us-ascii?Q?S56H/Y0+LtWEvt/tQJ72ClNr/BOSMT896MtImpN5Lxy23nxY/DEm/2JFe5TP?=
 =?us-ascii?Q?wh+FnsML8eB4AWthYh0sdGaVi5eINQmQ2G0eA142emIN0S6kO2OBw7SJ6j/f?=
 =?us-ascii?Q?C/joH1+/YqByTfRjQU2EoYPnPz1ltqf20Nla00lkcxXktRGJzICpwz9VhJIq?=
 =?us-ascii?Q?KMcOK58M/cSSUJv8/3vMxsDs4lyQ2iEal72jJAljghL+z9x8CTbkccib5fWv?=
 =?us-ascii?Q?pl2bQI+xRUXPWUiMbmzF+rNoPprIumWMVQ21pv3hp/Kmh3eWVDo8qna8izA6?=
 =?us-ascii?Q?haAwrgo3D3Yd1sYIroFc1+3RLykJKMYQ4G+MZAdexn06/wJNyNm5BM8uQmTY?=
 =?us-ascii?Q?qSa0CMl+jsdoiyxgq1GG0merqebFJFeuf+MQEuCUK4b9B6AaXgJHmBuFVIx8?=
 =?us-ascii?Q?3TxZwIu7+Xmu/p1ahK1YoMYUBWL7aJvvKefeOMwcGy10pjWptBhhQDYTbdSM?=
 =?us-ascii?Q?5BC5Oahb4BpZWtuTM6INC/tv7k+UfO66CGY1vwekdPRCG3eJ3WyFhUzvSWUI?=
 =?us-ascii?Q?kgTY+9q4vpYF4TEcEguF4uruI6aZ4V6QQpUlC74KizfpydU/oOMguPgNPu6j?=
 =?us-ascii?Q?OQJLxc9bUUhXbeM1FV5uLtDmqkoSk2zQoL35Zwc3UzM1I/O/62MDTXpnY1nD?=
 =?us-ascii?Q?AklwWGcWKOACMfRQiRWaFZHK0JrD0QNVuAPQ6nySLO7QWqCOOsahrtqozQo3?=
 =?us-ascii?Q?DBJIiF2fFUEX4oj9cIPbSUwyjg8RcmkjAbO7whmblyn646lF8qHPI5Lg+vAx?=
 =?us-ascii?Q?O/Aig6fDy8IJ6GP92vgP5C8kVSU4q9ds0vcMS+rTj5mFeud/pjdUZ/KLGjI7?=
 =?us-ascii?Q?N+lqu/3c/edMERaKX8/1aFOAVj42zWVrna3084/5W05s5x25RWHxH9Mo6rDi?=
 =?us-ascii?Q?/GUM7XC2J0RSKwUhgqoOGpdk8Lmv7jH3tyafIeEV2JJchiR+AqJAgL3O2R2F?=
 =?us-ascii?Q?aw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3b76311-2404-496b-3581-08daf8df046c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 23:03:16.5692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JEHSviYnogkNnQByl2HqSfmkyIUPe0fftU0F64mincIVb6w9n7+M+e96bY2RXtDzd6b542+P5oIyVSif1+1xMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6808
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have a few instances in the enetc driver where the ring resources
(BD ring iomem, software BD ring, software TSO headers, basically
everything except RX buffers) need to be reallocated. For example, when
RX timestamping is enabled, the RX BD format changes to an extended one
(twice as large).

Currently, this is done using a simplistic enetc_close() -> enetc_open()
procedure. But this is quite crude, since it also invokes phylink_stop()
-> phylink_start(), the link is lost, and a few seconds need to pass for
autoneg to complete again.

In fact it's bad also due to the improper (yolo) error checking. In case
we fail to allocate new resources, we've already freed the old ones, so
the interface is more or less stuck.

To avoid that, we need a system where reconfiguration is possible in a
way in which resources are allocated upfront. This means that there will
be a higher memory usage temporarily, but the assignment of resources to
rings can be done when both the old and new resources are still available.

Introduce a struct enetc_bdr_resource which holds the resources for a
ring, be it RX or TX. This structure duplicates a lot of fields from
struct enetc_bdr (and access to the same fields in the ring structure
was left duplicated, to not change cache characteristics in the fast
path).

When enetc_alloc_tx_resources() runs, it returns an array of resource
elements (one per TX ring), in addition to the existing priv->tx_res.
To populate priv->tx_res with that array, one must call
enetc_assign_tx_resources(), and this also frees the old resources.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 231 +++++++++++++------
 drivers/net/ethernet/freescale/enetc/enetc.h |  19 ++
 2 files changed, 180 insertions(+), 70 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 67471c8ea447..543ae8875bc9 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1715,47 +1715,54 @@ void enetc_get_si_caps(struct enetc_si *si)
 		si->hw_features |= ENETC_SI_F_PSFP;
 }
 
-static int enetc_dma_alloc_bdr(struct enetc_bdr *r, size_t bd_size)
+static int enetc_dma_alloc_bdr(struct enetc_bdr_resource *res)
 {
-	r->bd_base = dma_alloc_coherent(r->dev, r->bd_count * bd_size,
-					&r->bd_dma_base, GFP_KERNEL);
-	if (!r->bd_base)
+	size_t bd_base_size = res->bd_count * res->bd_size;
+
+	res->bd_base = dma_alloc_coherent(res->dev, bd_base_size,
+					  &res->bd_dma_base, GFP_KERNEL);
+	if (!res->bd_base)
 		return -ENOMEM;
 
 	/* h/w requires 128B alignment */
-	if (!IS_ALIGNED(r->bd_dma_base, 128)) {
-		dma_free_coherent(r->dev, r->bd_count * bd_size, r->bd_base,
-				  r->bd_dma_base);
+	if (!IS_ALIGNED(res->bd_dma_base, 128)) {
+		dma_free_coherent(res->dev, bd_base_size, res->bd_base,
+				  res->bd_dma_base);
 		return -EINVAL;
 	}
 
 	return 0;
 }
 
-static void enetc_dma_free_bdr(struct enetc_bdr *r, size_t bd_size)
+static void enetc_dma_free_bdr(const struct enetc_bdr_resource *res)
 {
-	dma_free_coherent(r->dev, r->bd_count * bd_size, r->bd_base,
-			  r->bd_dma_base);
-	r->bd_base = NULL;
+	size_t bd_base_size = res->bd_count * res->bd_size;
+
+	dma_free_coherent(res->dev, bd_base_size, res->bd_base,
+			  res->bd_dma_base);
 }
 
-static int enetc_alloc_txbdr(struct enetc_bdr *txr)
+static int enetc_alloc_tx_resource(struct enetc_bdr_resource *res,
+				   struct device *dev, size_t bd_count)
 {
 	int err;
 
-	txr->tx_swbd = vzalloc(txr->bd_count * sizeof(struct enetc_tx_swbd));
-	if (!txr->tx_swbd)
+	res->dev = dev;
+	res->bd_count = bd_count;
+	res->bd_size = sizeof(union enetc_tx_bd);
+
+	res->tx_swbd = vzalloc(bd_count * sizeof(*res->tx_swbd));
+	if (!res->tx_swbd)
 		return -ENOMEM;
 
-	err = enetc_dma_alloc_bdr(txr, sizeof(union enetc_tx_bd));
+	err = enetc_dma_alloc_bdr(res);
 	if (err)
 		goto err_alloc_bdr;
 
-	txr->tso_headers = dma_alloc_coherent(txr->dev,
-					      txr->bd_count * TSO_HEADER_SIZE,
-					      &txr->tso_headers_dma,
+	res->tso_headers = dma_alloc_coherent(dev, bd_count * TSO_HEADER_SIZE,
+					      &res->tso_headers_dma,
 					      GFP_KERNEL);
-	if (!txr->tso_headers) {
+	if (!res->tso_headers) {
 		err = -ENOMEM;
 		goto err_alloc_tso;
 	}
@@ -1763,109 +1770,183 @@ static int enetc_alloc_txbdr(struct enetc_bdr *txr)
 	return 0;
 
 err_alloc_tso:
-	enetc_dma_free_bdr(txr, sizeof(union enetc_tx_bd));
+	enetc_dma_free_bdr(res);
 err_alloc_bdr:
-	vfree(txr->tx_swbd);
-	txr->tx_swbd = NULL;
+	vfree(res->tx_swbd);
+	res->tx_swbd = NULL;
 
 	return err;
 }
 
-static void enetc_free_txbdr(struct enetc_bdr *txr)
+static void enetc_free_tx_resource(const struct enetc_bdr_resource *res)
 {
-	dma_free_coherent(txr->dev, txr->bd_count * TSO_HEADER_SIZE,
-			  txr->tso_headers, txr->tso_headers_dma);
-	txr->tso_headers = NULL;
-
-	enetc_dma_free_bdr(txr, sizeof(union enetc_tx_bd));
-
-	vfree(txr->tx_swbd);
-	txr->tx_swbd = NULL;
+	dma_free_coherent(res->dev, res->bd_count * TSO_HEADER_SIZE,
+			  res->tso_headers, res->tso_headers_dma);
+	enetc_dma_free_bdr(res);
+	vfree(res->tx_swbd);
 }
 
-static int enetc_alloc_tx_resources(struct enetc_ndev_priv *priv)
+static struct enetc_bdr_resource *
+enetc_alloc_tx_resources(struct enetc_ndev_priv *priv)
 {
+	struct enetc_bdr_resource *tx_res;
 	int i, err;
 
+	tx_res = kcalloc(priv->num_tx_rings, sizeof(*tx_res), GFP_KERNEL);
+	if (!tx_res)
+		return ERR_PTR(-ENOMEM);
+
 	for (i = 0; i < priv->num_tx_rings; i++) {
-		err = enetc_alloc_txbdr(priv->tx_ring[i]);
+		struct enetc_bdr *tx_ring = priv->tx_ring[i];
 
+		err = enetc_alloc_tx_resource(&tx_res[i], tx_ring->dev,
+					      tx_ring->bd_count);
 		if (err)
 			goto fail;
 	}
 
-	return 0;
+	return tx_res;
 
 fail:
 	while (i-- > 0)
-		enetc_free_txbdr(priv->tx_ring[i]);
+		enetc_free_tx_resource(&tx_res[i]);
 
-	return err;
+	kfree(tx_res);
+
+	return ERR_PTR(err);
 }
 
-static void enetc_free_tx_resources(struct enetc_ndev_priv *priv)
+static void enetc_free_tx_resources(const struct enetc_bdr_resource *tx_res,
+				    size_t num_resources)
 {
-	int i;
+	size_t i;
 
-	for (i = 0; i < priv->num_tx_rings; i++)
-		enetc_free_txbdr(priv->tx_ring[i]);
+	for (i = 0; i < num_resources; i++)
+		enetc_free_tx_resource(&tx_res[i]);
+
+	kfree(tx_res);
 }
 
-static int enetc_alloc_rxbdr(struct enetc_bdr *rxr, bool extended)
+static int enetc_alloc_rx_resource(struct enetc_bdr_resource *res,
+				   struct device *dev, size_t bd_count,
+				   bool extended)
 {
-	size_t size = sizeof(union enetc_rx_bd);
 	int err;
 
-	rxr->rx_swbd = vzalloc(rxr->bd_count * sizeof(struct enetc_rx_swbd));
-	if (!rxr->rx_swbd)
-		return -ENOMEM;
-
+	res->dev = dev;
+	res->bd_count = bd_count;
+	res->bd_size = sizeof(union enetc_rx_bd);
 	if (extended)
-		size *= 2;
+		res->bd_size *= 2;
 
-	err = enetc_dma_alloc_bdr(rxr, size);
+	res->rx_swbd = vzalloc(bd_count * sizeof(struct enetc_rx_swbd));
+	if (!res->rx_swbd)
+		return -ENOMEM;
+
+	err = enetc_dma_alloc_bdr(res);
 	if (err) {
-		vfree(rxr->rx_swbd);
+		vfree(res->rx_swbd);
 		return err;
 	}
 
 	return 0;
 }
 
-static void enetc_free_rxbdr(struct enetc_bdr *rxr)
+static void enetc_free_rx_resource(const struct enetc_bdr_resource *res)
 {
-	enetc_dma_free_bdr(rxr, sizeof(union enetc_rx_bd));
-
-	vfree(rxr->rx_swbd);
-	rxr->rx_swbd = NULL;
+	enetc_dma_free_bdr(res);
+	vfree(res->rx_swbd);
 }
 
-static int enetc_alloc_rx_resources(struct enetc_ndev_priv *priv, bool extended)
+static struct enetc_bdr_resource *
+enetc_alloc_rx_resources(struct enetc_ndev_priv *priv, bool extended)
 {
+	struct enetc_bdr_resource *rx_res;
 	int i, err;
 
+	rx_res = kcalloc(priv->num_rx_rings, sizeof(*rx_res), GFP_KERNEL);
+	if (!rx_res)
+		return ERR_PTR(-ENOMEM);
+
 	for (i = 0; i < priv->num_rx_rings; i++) {
-		err = enetc_alloc_rxbdr(priv->rx_ring[i], extended);
+		struct enetc_bdr *rx_ring = priv->rx_ring[i];
 
+		err = enetc_alloc_rx_resource(&rx_res[i], rx_ring->dev,
+					      rx_ring->bd_count, extended);
 		if (err)
 			goto fail;
 	}
 
-	return 0;
+	return rx_res;
 
 fail:
 	while (i-- > 0)
-		enetc_free_rxbdr(priv->rx_ring[i]);
+		enetc_free_rx_resource(&rx_res[i]);
 
-	return err;
+	kfree(rx_res);
+
+	return ERR_PTR(err);
+}
+
+static void enetc_free_rx_resources(const struct enetc_bdr_resource *rx_res,
+				    size_t num_resources)
+{
+	size_t i;
+
+	for (i = 0; i < num_resources; i++)
+		enetc_free_rx_resource(&rx_res[i]);
+
+	kfree(rx_res);
 }
 
-static void enetc_free_rx_resources(struct enetc_ndev_priv *priv)
+static void enetc_assign_tx_resource(struct enetc_bdr *tx_ring,
+				     const struct enetc_bdr_resource *res)
+{
+	tx_ring->bd_base = res ? res->bd_base : NULL;
+	tx_ring->bd_dma_base = res ? res->bd_dma_base : 0;
+	tx_ring->tx_swbd = res ? res->tx_swbd : NULL;
+	tx_ring->tso_headers = res ? res->tso_headers : NULL;
+	tx_ring->tso_headers_dma = res ? res->tso_headers_dma : 0;
+}
+
+static void enetc_assign_rx_resource(struct enetc_bdr *rx_ring,
+				     const struct enetc_bdr_resource *res)
+{
+	rx_ring->bd_base = res ? res->bd_base : NULL;
+	rx_ring->bd_dma_base = res ? res->bd_dma_base : 0;
+	rx_ring->rx_swbd = res ? res->rx_swbd : NULL;
+}
+
+static void enetc_assign_tx_resources(struct enetc_ndev_priv *priv,
+				      const struct enetc_bdr_resource *res)
 {
 	int i;
 
-	for (i = 0; i < priv->num_rx_rings; i++)
-		enetc_free_rxbdr(priv->rx_ring[i]);
+	if (priv->tx_res)
+		enetc_free_tx_resources(priv->tx_res, priv->num_tx_rings);
+
+	for (i = 0; i < priv->num_tx_rings; i++) {
+		enetc_assign_tx_resource(priv->tx_ring[i],
+					 res ? &res[i] : NULL);
+	}
+
+	priv->tx_res = res;
+}
+
+static void enetc_assign_rx_resources(struct enetc_ndev_priv *priv,
+				      const struct enetc_bdr_resource *res)
+{
+	int i;
+
+	if (priv->rx_res)
+		enetc_free_rx_resources(priv->rx_res, priv->num_rx_rings);
+
+	for (i = 0; i < priv->num_rx_rings; i++) {
+		enetc_assign_rx_resource(priv->rx_ring[i],
+					 res ? &res[i] : NULL);
+	}
+
+	priv->rx_res = res;
 }
 
 static void enetc_free_tx_ring(struct enetc_bdr *tx_ring)
@@ -2306,6 +2387,7 @@ void enetc_start(struct net_device *ndev)
 int enetc_open(struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_bdr_resource *tx_res, *rx_res;
 	int num_stack_tx_queues;
 	bool extended;
 	int err;
@@ -2320,13 +2402,17 @@ int enetc_open(struct net_device *ndev)
 	if (err)
 		goto err_phy_connect;
 
-	err = enetc_alloc_tx_resources(priv);
-	if (err)
+	tx_res = enetc_alloc_tx_resources(priv);
+	if (IS_ERR(tx_res)) {
+		err = PTR_ERR(tx_res);
 		goto err_alloc_tx;
+	}
 
-	err = enetc_alloc_rx_resources(priv, extended);
-	if (err)
+	rx_res = enetc_alloc_rx_resources(priv, extended);
+	if (IS_ERR(rx_res)) {
+		err = PTR_ERR(rx_res);
 		goto err_alloc_rx;
+	}
 
 	num_stack_tx_queues = enetc_num_stack_tx_queues(priv);
 
@@ -2339,15 +2425,17 @@ int enetc_open(struct net_device *ndev)
 		goto err_set_queues;
 
 	enetc_tx_onestep_tstamp_init(priv);
+	enetc_assign_tx_resources(priv, tx_res);
+	enetc_assign_rx_resources(priv, rx_res);
 	enetc_setup_bdrs(priv, extended);
 	enetc_start(ndev);
 
 	return 0;
 
 err_set_queues:
-	enetc_free_rx_resources(priv);
+	enetc_free_rx_resources(rx_res, priv->num_rx_rings);
 err_alloc_rx:
-	enetc_free_tx_resources(priv);
+	enetc_free_tx_resources(tx_res, priv->num_tx_rings);
 err_alloc_tx:
 	if (priv->phylink)
 		phylink_disconnect_phy(priv->phylink);
@@ -2391,8 +2479,11 @@ int enetc_close(struct net_device *ndev)
 	if (priv->phylink)
 		phylink_disconnect_phy(priv->phylink);
 	enetc_free_rxtx_rings(priv);
-	enetc_free_rx_resources(priv);
-	enetc_free_tx_resources(priv);
+
+	/* Avoids dangling pointers and also frees old resources */
+	enetc_assign_rx_resources(priv, NULL);
+	enetc_assign_tx_resources(priv, NULL);
+
 	enetc_free_irqs(priv);
 
 	return 0;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 416e4138dbaf..fd161a60a797 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -85,6 +85,23 @@ struct enetc_xdp_data {
 #define ENETC_TX_RING_DEFAULT_SIZE	2048
 #define ENETC_DEFAULT_TX_WORK		(ENETC_TX_RING_DEFAULT_SIZE / 2)
 
+struct enetc_bdr_resource {
+	/* Input arguments saved for teardown */
+	struct device *dev; /* for DMA mapping */
+	size_t bd_count;
+	size_t bd_size;
+
+	/* Resource proper */
+	void *bd_base; /* points to Rx or Tx BD ring */
+	dma_addr_t bd_dma_base;
+	union {
+		struct enetc_tx_swbd *tx_swbd;
+		struct enetc_rx_swbd *rx_swbd;
+	};
+	char *tso_headers;
+	dma_addr_t tso_headers_dma;
+};
+
 struct enetc_bdr {
 	struct device *dev; /* for DMA mapping */
 	struct net_device *ndev;
@@ -344,6 +361,8 @@ struct enetc_ndev_priv {
 	struct enetc_bdr **xdp_tx_ring;
 	struct enetc_bdr *tx_ring[16];
 	struct enetc_bdr *rx_ring[16];
+	const struct enetc_bdr_resource *tx_res;
+	const struct enetc_bdr_resource *rx_res;
 
 	struct enetc_cls_rule *cls_rules;
 
-- 
2.34.1

