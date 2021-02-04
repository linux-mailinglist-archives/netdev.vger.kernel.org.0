Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5AC530F89B
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 17:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238212AbhBDQx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 11:53:58 -0500
Received: from mail-eopbgr80089.outbound.protection.outlook.com ([40.107.8.89]:44686
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237971AbhBDQwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 11:52:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGJdMtGtP8Sm2YTbDzN6wZDxM51yuqNmtgNVnC4tCfk93APJm06zguxk2d+Puf8YAYB0sudbN6Uq9YTPOih2TIRX2mmoH6hQBbazvMiIUWPThct7kv3lkmu1pDCKk7dADoizCYRZnYba/UkPHOBIppUET4t5qF1QMT5s6xGVoIcM/KwydTg0aBZI9aE1HVg5MhtI55lsgZfCiPWJFfdK+NNzp7rR4Vuy1NzYioV6B90J/NYRS1NZHh7KdiU3PjBQHYSMX7kVljgkBHYqaZCqXWx2e9DLow88wcI2ZsSBuv21hN41pZjvK3CQfmtinBtErgoYunOvzA+AUqA5nYD8TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yx0XsD26H2BNYAdlt+zxoZWZPuY1erzo+GEGjuFbSEM=;
 b=IIob3hUQzGnWS3hJ4vfoxfYrvTY+s7w+e+2NIvSdlewC4Wmi8FgsRiwtRE9TPEGg9zE3xJsA/hnMzCzcRtdMPZw/YSaP/77nntAMXufyIsNBZK5K07F4YemKNbgz2Q45C+ophr1Kq0ULcGtgfAacF5iXqAhKNCCldz+TV7ADA8/5vf2xYEt+73roKXIl1RKNNkenL3HIp0qVJGEhcO3lgUq0yXigoXx4+tkqTy072T2jcZZXdHI7Bagp9USZpm3ngg7uoM1ZlQRIXAUv7CfHEj7XJtmXTeCL3ZGRW3WmaMWYzGBT6LjFxFPLm5085viMJkfzAg4YnVONIXIMmNdxWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yx0XsD26H2BNYAdlt+zxoZWZPuY1erzo+GEGjuFbSEM=;
 b=bFKWxtekfAuh7WGRTAD2susl66sfjKhVFxodWz5pjJUGekYXs+CC/M73G4XZRE09Jjdb62hVOY3SaRqfrEBIFiSp8fEG/0MQT4nrBvZVAuACbpSMOPDwKtNgDOP5POI1z+Au7hno/G8laiVZ8u4wy885oLd6uKIyezwOvs4aXaQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR0402MB3454.eurprd04.prod.outlook.com (2603:10a6:803:a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.22; Thu, 4 Feb
 2021 16:50:43 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::6ccd:7fa9:bada:4]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::6ccd:7fa9:bada:4%7]) with mapi id 15.20.3805.027; Thu, 4 Feb 2021
 16:50:43 +0000
From:   Camelia Groza <camelia.groza@nxp.com>
To:     kuba@kernel.org, davem@davemloft.net, maciej.fijalkowski@intel.com
Cc:     madalin.bucur@oss.nxp.com, netdev@vger.kernel.org,
        Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net v2 3/3] dpaa_eth: try to move the data in place for the A050385 erratum
Date:   Thu,  4 Feb 2021 18:49:28 +0200
Message-Id: <883f775dabac981c0f46b6296b134a87cc74ca83.1612456902.git.camelia.groza@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1612456902.git.camelia.groza@nxp.com>
References: <cover.1612456902.git.camelia.groza@nxp.com>
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: FR2P281CA0026.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::13) To VI1PR04MB5807.eurprd04.prod.outlook.com
 (2603:10a6:803:ec::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15136.swis.ro-buh01.nxp.com (83.217.231.2) by FR2P281CA0026.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.10 via Frontend Transport; Thu, 4 Feb 2021 16:50:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 74c7eb7d-4560-48f8-4d24-08d8c92d02d8
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3454:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3454578F6E037E32177B180BF2B39@VI1PR0402MB3454.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QqZN8TqH7LfBEW33KM7wt8KZ6UFXqt6aZQr/m1aPHTN6dVCYLophFkv9ilF7OJ0dvjhy3XLVvuH8hAdPx4/rI2FmpfV0gWUZ04FB4WkgXMBqSSjWmyfuc5vmkQLEbrRhXoxmUETGxbudzIqkCJ6q9OjD+7fKKZndg9tQOfBtw8Qe7TGXoYNX2/OGqGDBSNPr1Vt9w8XlgC89Udzh+mUw2g+ffgZ5xqpngYXWGkedwFsCvCC0Q5EhOZyzfQbML/S8ocGaNy1hAnCXrdOXaWWWzwbWLIeE2M9syMJwDzJcESDkc9TEkky6uxh3EfkE6aKrWxYIKvOCFRTEVqiyfWL4fJtAne+oELF6nmQN3wV7A7+Q1osZt2L1/jpSIJOJAND7WbINJN3+FTXM8aH7PDsOhE/RoEsGaPZ+nAVMhlgoIhyT9J6ag4cDRoHbU4x5SWTsKWBQbMjK6eb8GBH1wo47z8YC2YYOysfPcu1QIKztCB21Sjb5+OJXcue2zpRTqRALdN3XRR2bXdf74gEGOhmiog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(366004)(66476007)(956004)(4326008)(66556008)(6666004)(2616005)(6486002)(2906002)(52116002)(66946007)(44832011)(5660300002)(478600001)(36756003)(26005)(16526019)(186003)(8936002)(8676002)(316002)(7696005)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jSXQsr8+UbbTUEMHuo7fJv10F932ORHPeQ4LmVE8+23GSYrqeZMNYDRmBRNf?=
 =?us-ascii?Q?vIddkjH+gBNFYmSG08R91Y72aEvJwUFGKqXvAfcCxS879VBBSCBo0Z6RaRmy?=
 =?us-ascii?Q?XYQ/InOQObD4ZT0ccxbNIGuf6J0nhS/UjCDo2BwlhyMwu3V+M0SFrgabTRfq?=
 =?us-ascii?Q?CVMjgu7svLJNDslxA5sg3K0zokYJ6jYz12NKf7l7j3ooZaKqy5c7RWLGv51U?=
 =?us-ascii?Q?80pFSL0UEtty3EViqoLiKEp04es9l1TqR2SsEbkxjfp1ACjBl0Afec8jfqId?=
 =?us-ascii?Q?6aXstaDC8Y4QjavpmJq4hfUsWINv/ixnF6v3EYkw9+GHufxLOzvt+Myoi7h8?=
 =?us-ascii?Q?6uFXcVuJIlFnL/6s5Fa/jLKb2A1adK5IbuPxe/n1+9MBsCy/NzNCnN+L6IRM?=
 =?us-ascii?Q?V/ZvkqZXHgXG1V9TNePnMuXq1KPfsRdTCWIjE7jInpRFFY14zFwhAXOVJeyL?=
 =?us-ascii?Q?Inmw6+xbE9HSBg4vrtiA+ySPFBJxJXgV4+gg+oSqlVr29PYcb0P95jrADKV+?=
 =?us-ascii?Q?SqsqyqeFUI+gbTnpIGTF0YJd25x1dwSwqRaXiusOAXQC5flglt8cDKiLUtob?=
 =?us-ascii?Q?a3S3WS7gRhJTAE8AcpeynVlGFU+OBmkl835895leehjbIIiLA500UNAYve9N?=
 =?us-ascii?Q?bgQa+iqFuj13WACyMxhSCFJmdW9gd5rMVmS5zWeUvPcKlPB6eZu9CXEp9nlg?=
 =?us-ascii?Q?Qx3QBhljiqF6SVrQ2DReqb4vPhXX5UV/7L3l3JuUelkdRfIaOAe1l1GRYktC?=
 =?us-ascii?Q?1kDvgUvpxylldtKkFjGRK9YQABRm2SanCVQZKoaNr233MeZwQXOFLZdNr0lJ?=
 =?us-ascii?Q?tWUAX5a06eyjANqbT3yzpdMWUwdACsRjSLZW38bI4QN4GqJWAzXY1Csm7RlP?=
 =?us-ascii?Q?syMS8bvxEAZ70CZWvxLipb4g0tVROX43bXVHp4VuGv/qAGsFSt4zp2lNVu/9?=
 =?us-ascii?Q?JsrWNdZx2y9MoyChLqrJCZC+XcZH0kMRo1jYmFFnCkKqBYOeC1o4+FhA3w9a?=
 =?us-ascii?Q?eNlARdyjAGK1UyMKD7Cb5iy494B21NUYjetCYWp9PxZHDTLg5jZI7o07WANd?=
 =?us-ascii?Q?xnJ1MKHFvFEzIXUIuoAJaNWmGn/N4Q1FxEWdLTv8Pj+vPkIO6/SePSAMjWET?=
 =?us-ascii?Q?Bx62h5NVMJ/LrmowvK2OveXMmqGfSM4q0r27y8Ckw2Rl9K7++229+oT6m35q?=
 =?us-ascii?Q?QdSWbxWDdxkOhFBybs91YYNJo7UR40t6QPp+lkw5SQapY8kslf81yfEmtp8H?=
 =?us-ascii?Q?mEi2Qy5onbXasM6JHNSpUV1RWJPNlxUkl/VmCePtFNfCKzy8DI+mrvxIjWEi?=
 =?us-ascii?Q?1aqv2mloLGyX6XnuSJh++A3o?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74c7eb7d-4560-48f8-4d24-08d8c92d02d8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 16:50:43.3185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w7fU0bdFYX9AsjyvbcQHO/j5K9ybapCcKDwrORGTCJNUqLgDnEiBSvZfX9xz8coFV5MAhslt9Ue1XTe/BOQ/1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3454
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The XDP frame's headroom might be large enough to accommodate the
xdpf backpointer as well as shifting the data to an aligned address.

Try this first before resorting to allocating a new buffer and copying
the data.

Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 20 ++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 2a2c7db23407..6faa20bed488 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2180,8 +2180,9 @@ static int dpaa_a050385_wa_xdpf(struct dpaa_priv *priv,
 				struct xdp_frame **init_xdpf)
 {
 	struct xdp_frame *new_xdpf, *xdpf = *init_xdpf;
-	void *new_buff;
+	void *new_buff, *aligned_data;
 	struct page *p;
+	u32 data_shift;
 	int headroom;
 
 	/* Check the data alignment and make sure the headroom is large
@@ -2198,6 +2199,23 @@ static int dpaa_a050385_wa_xdpf(struct dpaa_priv *priv,
 		return 0;
 	}
 
+	/* Try to move the data inside the buffer just enough to align it and
+	 * store the xdpf backpointer. If the available headroom isn't large
+	 * enough, resort to allocating a new buffer and copying the data.
+	 */
+	aligned_data = PTR_ALIGN_DOWN(xdpf->data, DPAA_FD_DATA_ALIGNMENT);
+	data_shift = xdpf->data - aligned_data;
+
+	/* The XDP frame's headroom needs to be large enough to accommodate
+	 * shifting the data as well as storing the xdpf backpointer.
+	 */
+	if (xdpf->headroom  >= data_shift + priv->tx_headroom) {
+		memmove(aligned_data, xdpf->data, xdpf->len);
+		xdpf->data = aligned_data;
+		xdpf->headroom = priv->tx_headroom;
+		return 0;
+	}
+
 	/* The new xdp_frame is stored in the new buffer. Reserve enough space
 	 * in the headroom for storing it along with the driver's private
 	 * info. The headroom needs to be aligned to DPAA_FD_DATA_ALIGNMENT to
-- 
2.17.1

