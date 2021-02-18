Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0510C31EF85
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 20:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234119AbhBRTQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 14:16:13 -0500
Received: from mail-db8eur05on2072.outbound.protection.outlook.com ([40.107.20.72]:27968
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230408AbhBRSWT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 13:22:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e1u8kw6Fe8GTskGrXD+j8bBEevdFC0uafbbfYa3dFGUO5DqJl9I3TpsHKjUSSZJGeDqu0XX2AkCZOP5RjLWxK/2cepf8bCZwWw+2ur8WyVo8xZvuZfkvOCsK45BgFM/5OdBGE9Q4WuBUhGAPi53fSAqwGgFH7mQt5v+8k/wWXFcLReEkPOcRDiV3T3npfe3Xm7zV+xZ7pnHnrRWgvWjUqXeDPhn28zwWqlly7bUAyyGixKYKEvBwypDPfXlNwV6/wX1+TD08Rwff6U/rWmYvai9enanDKXqGZR7zptlTFS6DWrmqUXygVOtYLWwt+jAD7Bgx9mRrx5dURk4gkYO3Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k9G6UQ/PrzQM/orEQYPSy1Gp1qanwmQBv9mPPoNMaAU=;
 b=BiAsl2LifvNd4Crt2uo3uTleGLKcG2zGLwJGpfP+PJLFBjVuFldFq5cN2XdskrL2OFhy4rPzoRUFO1y9VObHnaZ9/+4gzKjoIgwP7k20TN/JnhFr4h3DXwCEwCkkIf1w6Arz9ydf2Fvfn+v9eO4J7jB1MxTpKTdLHjmd/XniUoESbVatdAtOa/yVt4PUnXMlrJIAOEbxfNHMySx7R/7xV0fN/risn39pvFfyMF9Njyck8hhmviYxlezLc0qmINzLqoxnqlH/32m47UvRkq2G+lui/FWLfyGCSYRKJuWySlidXUYHxADD4A8Cto+UyDg11KTHxaDIXFBepfXSVROREw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k9G6UQ/PrzQM/orEQYPSy1Gp1qanwmQBv9mPPoNMaAU=;
 b=X8Ao7lkIIjeRz3F89v7xaYfBFV5kAdQuDLevCE0G3IKdmej9GP+jI/LoCSOoDPSH9KrPTYeB90nQEuFHbGw156gcIkVkJl+huW1DU4JEFZV/cICmIjn0hfSCLEvcGk28FzcXTCdUHpLC1yuVE5c1KJFvHX10VVhj5hY77j2uwpg=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR04MB5799.eurprd04.prod.outlook.com (2603:10a6:20b:a9::20)
 by AM6PR04MB5430.eurprd04.prod.outlook.com (2603:10a6:20b:94::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Thu, 18 Feb
 2021 18:21:28 +0000
Received: from AM6PR04MB5799.eurprd04.prod.outlook.com
 ([fe80::b0f6:6642:8a2f:138]) by AM6PR04MB5799.eurprd04.prod.outlook.com
 ([fe80::b0f6:6642:8a2f:138%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 18:21:28 +0000
From:   Camelia Groza <camelia.groza@nxp.com>
To:     kuba@kernel.org, davem@davemloft.net, s.hauer@pengutronix.de
Cc:     brouer@redhat.com, madalin.bucur@oss.nxp.com,
        netdev@vger.kernel.org, Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net] dpaa_eth: fix the access method for the dpaa_napi_portal
Date:   Thu, 18 Feb 2021 20:21:06 +0200
Message-Id: <20210218182106.22613-1-camelia.groza@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: FR2P281CA0010.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::20) To AM6PR04MB5799.eurprd04.prod.outlook.com
 (2603:10a6:20b:a9::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15136.swis.ro-buh01.nxp.com (83.217.231.2) by FR2P281CA0010.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.8 via Frontend Transport; Thu, 18 Feb 2021 18:21:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7590aca8-cddb-4313-b266-08d8d43a0220
X-MS-TrafficTypeDiagnostic: AM6PR04MB5430:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB54304CAFF67EED287C6EA65AF2859@AM6PR04MB5430.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ESMpaYPDbdOn1YjLq/A6dndhrivYYn+hNIVTTQnM26f6pAFv0OxefwugE5D7AbZMisarjcg61cQnqR3bUHZo5kRK6WsRmBQ/bIundXpZr7ed6rfcAWmQtYSQw8jTgyDeZQh4L0ieWURHMn3HGT0GvvQISBxG5G1mrgWPepfyII+7zMOQwlM3IUMxPpgZ878m3oWF3h53OECLYyyOR0uYUXt4inMF+N/wHKMDsjggJNK+M8c4ewOSYEi0Vf6qdpeapXP0n+NG6gEUcfti67TE61ja8odbzYwxHkvzYO7dJ7vbSbKX+jbpu9A2LdyFa80NuXKams4SH3czXRoul/hh0Nmp58wTWIWGqiSHo64BeeTxnnW9jI/A016XAVc/ht4E8FDU23uAQMa24AyAqc84vcHtwKQQMzxooxyfOsOSrOlgfjnAsTfudaoH8gSzU7Cc4qEC3J/l6eg9scTXiyP24BQgMGxL0W5f8j+WbzJJ3T96f3bGrHLIgOXw0UBltreSaqITbvSR2DQS5xtV+PxTSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(376002)(366004)(39860400002)(2906002)(8936002)(7696005)(44832011)(316002)(6486002)(83380400001)(2616005)(8676002)(186003)(16526019)(1076003)(5660300002)(6666004)(52116002)(86362001)(66556008)(26005)(66946007)(478600001)(66476007)(4326008)(36756003)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?NA2JaPRlIkJy/J85blS7nn/xaJlV89V76VwJE00Cvr8zsZCrYHIgmgrJGt1G?=
 =?us-ascii?Q?wZR2K/AGsJ6/t337DPuN2B2+0e0cMeQOedXR4k0GkRToY2WODOvkDuOYYvSn?=
 =?us-ascii?Q?CVvRzcYRx3IFdf20WkY6nGIRL2fbyuS+AY+tsJHB310IeMZuiH3h2154B40A?=
 =?us-ascii?Q?7s+KQ0A2Wusde5LC3+I5rHiJm++abhmve0U7O17vIzIkqiNRvhPEw17xSaBJ?=
 =?us-ascii?Q?qFs2foCVTNAhmdWLouKOqJDhIhGBFFAVKtsNEbwsd62b4PMVFEp4bL7AfNTh?=
 =?us-ascii?Q?knELwoVUJ9dDP4QzDvSJyj2rcDiO/I6XFim/hv+PVujYDvGNr4AZurutvEH7?=
 =?us-ascii?Q?OFUvx1kjggnVP6cuhbocgolP12yMyRr4RJqE8dEjzZZdKN+4VijZYbFyR9ao?=
 =?us-ascii?Q?u6XS6914Mm9+MD5rzZZkpCDHDrPo9vehQrNP4/kqiSngESQGhwOvk/TjNCdI?=
 =?us-ascii?Q?fEJbJvPvRkvawT66juXV3m2dHzR/KrPwC0p51/YT5/nHkZGgXrVklD63PFJ0?=
 =?us-ascii?Q?xF1R5Hr5RzW0YfVfuH1G85a1yunLJLIYD8nW5dCaBWNPWWEy3KGWtDpkK5bl?=
 =?us-ascii?Q?jmvyFnMxbasho6hzkF2qV6n35QXiYjDc6BoHWk60Du1Fcg6JK1AupeXlzU7B?=
 =?us-ascii?Q?Fd00Wpi6NUggJjPFZgHeOjJ8tZiNdOlfeqac0ZsBoDNbEZs5m9ySAd/mcnSv?=
 =?us-ascii?Q?dy3syt1rQEuW89epaEqmAhr92u3wJPuLY1X0Et91Rvj9o0aEe2fi27E7Xmsn?=
 =?us-ascii?Q?zQUHM0IizIAh/va0moRarI5mfgs5jaZ9HORCDZL3g1Vz+cWL1+0VZ6id+Rli?=
 =?us-ascii?Q?WEB7EUiyHNnFYVIEFRLCNXxd+yrEsfyivlnz3MfdnokAD0HTmIQ95PX7JsEz?=
 =?us-ascii?Q?+TMpy+VLkcSLiIW5qdKjPXJyLuRc/KA192rOgLE7U7iS4ce07VDw+icx7HxA?=
 =?us-ascii?Q?GxN2IlY5KZfblfNXGUtAGHgSulrh1rTP8cIgdeDYhaTUnz/08hfI5u/sRiqs?=
 =?us-ascii?Q?TEWyhA3XVkps1cfJM4h0ZaR62rs0i1w3jAMq5YFHef5QTMNMYfeOA9N/8ClC?=
 =?us-ascii?Q?fKeoh7P6oirGuzj3NNLjH3Q36aq3W+VQPzfOcmeDvC/HfIvTKPaRI45DfvUM?=
 =?us-ascii?Q?cvxOyLpQBwcT73TbgxeGDL2WzDoKrunRsovVUdrW4XS4TJXlbTSgE/0Bv+qM?=
 =?us-ascii?Q?G8wNGBKcnnJBDi6ScFcFb7T7WWjqgnUpt9gqH5gDNMsPKGvhwjoEtMe25wc4?=
 =?us-ascii?Q?METUpkYea/6aknZIHQ/HdSF6sDZ6+XTOQ9w/RnBqKsOf2k7+X6oAgFEHb4S6?=
 =?us-ascii?Q?rE962w84y915sXMQqz9Hm/iw?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7590aca8-cddb-4313-b266-08d8d43a0220
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 18:21:28.3643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1oHr35um+11lIsV4RC2aKSb6fnKfvSAN82OGPfnAgPhIFp1nbp0fAkFVnpB0ZwHwuYZVDZrnJcwUokvqa4Hpow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5430
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current use of container_of is flawed and unnecessary. Obtain
the dpaa_napi_portal reference from the private percpu data instead.

Fixes: a1e031ffb422 ("dpaa_eth: add XDP_REDIRECT support")
Reported-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 6faa20bed488..9905caeaeee3 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2672,7 +2672,6 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 	u32 hash;
 	u64 ns;
 
-	np = container_of(&portal, struct dpaa_napi_portal, p);
 	dpaa_fq = container_of(fq, struct dpaa_fq, fq_base);
 	fd_status = be32_to_cpu(fd->status);
 	fd_format = qm_fd_get_format(fd);
@@ -2687,6 +2686,7 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 
 	percpu_priv = this_cpu_ptr(priv->percpu_priv);
 	percpu_stats = &percpu_priv->stats;
+	np = &percpu_priv->np;
 
 	if (unlikely(dpaa_eth_napi_schedule(percpu_priv, portal, sched_napi)))
 		return qman_cb_dqrr_stop;
-- 
2.17.1

