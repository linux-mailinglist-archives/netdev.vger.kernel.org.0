Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C2F30C80C
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 18:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237733AbhBBRjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 12:39:43 -0500
Received: from mail-eopbgr70088.outbound.protection.outlook.com ([40.107.7.88]:57602
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234011AbhBBRhO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 12:37:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZBUtPuVPaTeZ1JUA1eZ4OOMgg7xF8AM81NqGvdeBcAM5duNzwPdJw9jQogDjysZZIfAYLKaJBiHDsR4o3hErzcglzOGaJCgUvXGYaF+UtrZtMbB1uwwbOojXsrWOj5CT+SepvqJCvpjoYWpq8+MXS3DAtxFrF/DXkyvPQc/vEEKCxyU4RYB+aZxrPNQnKnTRdbDEULl1vzvAFthwGHG2EGBtV0wA/ICsamDYcEsDtUCjpMePIySMjyKteqpvid9WUjr8vnPLdY+JWOo1gLt7ZMfd3EqG5YAM33hp9Iy4iHoLKrL/X6yrJeWyNdcGtJl61sASD8LlTLYcojmLBmtAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H62vxHvJ6GZBK5bLU/N9mBnjJJ4lA9+/vOTxuhxvbHs=;
 b=BPl0OPDz32QUTWzMH5q3VF8s4aHll0WW4dF9PqcEV9Gp8eZFSRObM0NN5fwhNWvYKa1MLgUXLpcGkv0cJtDarx9OgYQhEpcp1Tr2/5CEIY59GcVU6W5xBSH3FkA3G6e5Pjnx3aClBWHbVcIuNcu0O0o0h/Uvt3W3Lrab1iBsx7v5OmSROg/QSNflssXepIi84op6RspwSZBGOXJqYiZ50USwfvUKqjXRdX8of6xi/6X2AnoqacEoeXWjecb1iJrJgBXlGOkR6YTgBIDLTQZihos+1vL4l/qiM2aqnHDhvwwlkgsUgK3nvD9lQ33CXlsazwgpKdE+Rs6pbRm7Aj3+/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H62vxHvJ6GZBK5bLU/N9mBnjJJ4lA9+/vOTxuhxvbHs=;
 b=VrqEfswE2EasD87d2NDswm/bcYqWdNOyKQjDW421jdQZ5DRbUQQH42rTerbcDw6cFC7eVrHv/gru9T+mJsAsCq4U261+iKjEnH7drn+uaXACfMhiSNvB5T1mDEi08nhKC5ulwAk/qv7z9e0btM4FQWSklvcr23auvbBdr7nv4Ss=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VE1PR04MB6462.eurprd04.prod.outlook.com (2603:10a6:803:11c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Tue, 2 Feb
 2021 17:35:36 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::6ccd:7fa9:bada:4]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::6ccd:7fa9:bada:4%7]) with mapi id 15.20.3805.027; Tue, 2 Feb 2021
 17:35:36 +0000
From:   Camelia Groza <camelia.groza@nxp.com>
To:     kuba@kernel.org, davem@davemloft.net, maciej.fijalkowski@intel.com
Cc:     madalin.bucur@oss.nxp.com, netdev@vger.kernel.org,
        Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net 2/3] dpaa_eth: reduce data alignment requirements for the A050385 erratum
Date:   Tue,  2 Feb 2021 19:34:43 +0200
Message-Id: <6e534e4b2da14bb57331446e950a49f237f979c0.1612275417.git.camelia.groza@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1612275417.git.camelia.groza@nxp.com>
References: <cover.1612275417.git.camelia.groza@nxp.com>
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM3PR07CA0093.eurprd07.prod.outlook.com
 (2603:10a6:207:6::27) To VI1PR04MB5807.eurprd04.prod.outlook.com
 (2603:10a6:803:ec::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15136.swis.ro-buh01.nxp.com (83.217.231.2) by AM3PR07CA0093.eurprd07.prod.outlook.com (2603:10a6:207:6::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.8 via Frontend Transport; Tue, 2 Feb 2021 17:35:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c37a2247-0447-4a15-ddc4-08d8c7a0f358
X-MS-TrafficTypeDiagnostic: VE1PR04MB6462:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6462F8EB943E7D966696F262F2B59@VE1PR04MB6462.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gho7gDza694r4co8U2zHCJjqrYUsFZxu+fT+HP3luEdfewEHNg7kZfd4rKcDihUPQckQ3NuN1wytQlwVJ7nm/5w4/fm6EmQNdgqYtM75BTpMwIfRSm8S0YVX6KX6DPP9qGUEdKg19YKd9Kc5GKd1SWeoAhsVGYIpe/ooiVFWfbjMT6fxMVVh5FnYET3LSbo0hL+PK0gX33amsZR+1ov5q63rXhTl5Px7FUudOp1cXW1GIZMyqK0j3gzWxQc9JrTY6y5F4O8uW9H5RkWyvzVTH32z4QdkumABOwvD7dyq0LX+QOWaDYfGzq9e9/yXvBmVgf2OS5NAoXsYU+q11qKJi5xjErLva4F0ikp4ioNstzcW91sj/reAsQlKOh+wNjXS9b7G92IJxguMkKCXlKu59PPKav5OJdSRqW5Sis6eBo9+cOOAS3hes1ZbD4rkB9HhxL93QMgJw90RCi/MW4Qi+tSVds9U0UWeMS+MKMRC2wEqiSs/iN80+UMVL+k8dl7gW9kL8zI/afj7fIxjGO4uOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(5660300002)(26005)(6486002)(52116002)(86362001)(186003)(44832011)(316002)(36756003)(478600001)(8936002)(16526019)(8676002)(66946007)(2906002)(956004)(6666004)(2616005)(83380400001)(7696005)(4326008)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hpkuuUw4nfbe/Apk2OHwSRDJTt73qdOYFtxcGF9QLv3D+gy/r9cdpjP6axoN?=
 =?us-ascii?Q?nYO4AyV2nCOovPa8hx2emTtqyfABKYYX1CEXgSB4eRHl248CgPXPtrgV6KzE?=
 =?us-ascii?Q?hYfmrDq73DlPfDi8Cby6sLMbcW0eOP2oCzXw9f/DCOcN7XmNpKLT26Kpx+kp?=
 =?us-ascii?Q?g0ABXDv6o0Ytbg8Iqpc8Hy5YsnngnqNsHMbYMoNNLYc0KkEVUAAplTAwymbz?=
 =?us-ascii?Q?LN4AZQGnd5W2VRLRHd+gt7ncS497ArOjpCOn4sm40ve9Mgy3D5jxk3ynZq8L?=
 =?us-ascii?Q?aecbSyuJOtvCk7pLZEPvnmrlY5qs1BaLS+FmBReG/ijCQ9MnTvwHYh8azJbG?=
 =?us-ascii?Q?KC6S6C/SrmHh01zsyrE0AgPpl6MprIlgUW7FfJ2HDTIyLmMvCkg33IQUcHpP?=
 =?us-ascii?Q?gv4Y1WGZIsEvQ1w9xJnessVV9Jplt11sZgSMtrqPlXBNLiWSq+RSpkAX9t8B?=
 =?us-ascii?Q?JO91jklgZeTNRW2VLIpkUGRGhk6LL6pexb+PEn1H2GpxRnCBZL0f+2SpaO5o?=
 =?us-ascii?Q?+dkgPQyn5JUjDZ9EX+WZZJGrrE6rCH7Vkbs90U49grOMRgEuDJ1cVrBdMdbH?=
 =?us-ascii?Q?lOL4buKhO90VZEhLjH6p16G13QU4gYrhKLYkfp/LN9yVvUXkKgs9xqI3M07o?=
 =?us-ascii?Q?2zKDf3s0QqAx/etkx3D2rS2rc7G4OYh0iHxm8BmXvovxfQRGacdelpYPH/tP?=
 =?us-ascii?Q?LcAEhrht39uVhy6VfFhWGQrMoqdxKXEUDENfo9phcB39YtRzdHTef359nl5w?=
 =?us-ascii?Q?B/fkuzDgbdvgd0lEZenPu891lwrDgIe8kBmiuQ/R4hLipBXbqob+wG4nZBaE?=
 =?us-ascii?Q?/9+z41LY5DKtLc1Bx2J7SE9q89kY16XWnVZgTAnAqec0srxURJ/ae9nyYeD/?=
 =?us-ascii?Q?FIkg9TfDDr0X/SOCYvUWe/JeR5Fyhskzp5ZxMoT4fvSiwr/IRuWcK4e48kY8?=
 =?us-ascii?Q?IDEEOb5gGD6lMw/SORhOLz7Qff76gGm1agvEJLmgSX1yD2Qm9X8+gvkBUROw?=
 =?us-ascii?Q?jv/DKw25XS68Fjfq1rWkKtbiEbwKekvv8L4jGX2SSSqd4Q/dGe/HnBPQN/FU?=
 =?us-ascii?Q?9K1jt9N7k3bMObZrB1K8dAaj4i0/5JHB9soy10k7Xx/+IEQVvM3sGE0T3Y8o?=
 =?us-ascii?Q?vBJlX7YmC98qWuXQ3JFEp2E77u3ZQ97zFMn1ZqZUAG0VR/jlLr4Ej9rnRruL?=
 =?us-ascii?Q?nTou1bsu2sGRoq6JxTAeD+u6F7BqrAfFGRIMQuSeEOCxlHzns+I/sWDA8nBV?=
 =?us-ascii?Q?xFXeWYR9wvx4SMsScibHutz56on9ZqSgqCzmMY47JF8x+mWAOOQNV79BQen5?=
 =?us-ascii?Q?ofisDouXW0TgdnhLlUnMP63V?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c37a2247-0447-4a15-ddc4-08d8c7a0f358
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2021 17:35:36.6086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iiv9IcLwl95TqXNdvH+1XeXbErubRHIrCek0jO5opDj1g2lgiklbIKGouFk4KF2YICcP+zgYiLpLnwtLGE9Urg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6462
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 256 byte data alignment is required for preventing DMA transaction
splits when crossing 4K page boundaries. Since XDP deals only with page
sized buffers or less, this restriction isn't needed. Instead, the data
only needs to be aligned to 64 bytes to prevent DMA transaction splits.

These lessened restrictions can increase performance by widening the pool
of permitted data alignments and preventing unnecessary realignments.

Fixes: ae680bcbd06a ("dpaa_eth: implement the A050385 erratum workaround for XDP")
Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index e1d041c35ad9..78dfa05f6d55 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2192,7 +2192,7 @@ static int dpaa_a050385_wa_xdpf(struct dpaa_priv *priv,
 	 * byte frame headroom. If the XDP program uses all of it, copy the
 	 * data to a new buffer and make room for storing the backpointer.
 	 */
-	if (PTR_IS_ALIGNED(xdpf->data, DPAA_A050385_ALIGN) &&
+	if (PTR_IS_ALIGNED(xdpf->data, DPAA_FD_DATA_ALIGNMENT) &&
 	    xdpf->headroom >= priv->tx_headroom) {
 		xdpf->headroom = priv->tx_headroom;
 		return 0;
-- 
2.17.1

