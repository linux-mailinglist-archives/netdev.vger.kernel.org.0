Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641FF30C805
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 18:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237660AbhBBRia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 12:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237633AbhBBRgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 12:36:23 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0600.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B6BCC06174A
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 09:35:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KLByCX7D74g4b015V50TsG1TbWhhYro7VSJvGxad/I9h8ihaU/7LG/q2hWHHefrhezewuPkBnUytys+wLliTt0CmonWjBaxu6F6680ngpfRk2X0eD1gD2cT6NW6Bxe1oYRkN3SqhQg8IKGSg1DacxPecHr/FdHwG4x98RkT8kgf6kNnEsRnrDE291pS9ScIVQFOz3URPZiSAmfhs4XgP92IsOlsdIh9WDteJEaILWajlXMbV9TCRP1LlDsTv0xtrpa35mNTn0fGQ5VL8aEek2CzgMt5anT1L15XZO0I/myPybexAQk//CLZm8iFzqeyFjylwiTCGZCmJC0aLj5053Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/opQK1JsT0Y3WffcPTa1zoLMSaAeUoUqPdViq5yNbEM=;
 b=QrD9YtBTyNymkTUXMrR2QZ2Cu4J0vqsqxLD/2sXWe5r7wqhwwaftxxQjR1uVSNYY8czNaFLBQICkZJ3LZ4XPLg7pHql7+lml9T/Pn6DppSef5VJId3ljEUzHmVsQlq/yHGsplBQrUy5taSRD1pKPANRIbJIiX32dOEKeXnbdoW3jvC7fKKhNKJmuCoqDqlT5q563W8Czaqnamrf8rt6ncZh6FSPe5I8tyWLsMjNsz1kPmOmKj7w+9oNV9J8fJCd82sxzIE02xrsg1d2OS/72XiLE6m+06+JDGdpcRlWWM905YT0IHh+I43Cr7mao3cCWC8lVQaraxTo6w6N9RyzyRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/opQK1JsT0Y3WffcPTa1zoLMSaAeUoUqPdViq5yNbEM=;
 b=VscVZpvHqrhRdFxcwHqPhF+llYaWg8h2mbe9gNH66EFDSZlvL8pf5FpeoyOPAmRaruRU1FVqNucbWHSZ6KFVYdwbnqL3rf5Un2KGey4cCBUHUDmRyaEHyEzz4p76JcD76PEQiyCW2C3K7TV9K1ogEYHExuLjnR2qnPtsdlefzls=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VE1PR04MB6462.eurprd04.prod.outlook.com (2603:10a6:803:11c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Tue, 2 Feb
 2021 17:35:34 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::6ccd:7fa9:bada:4]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::6ccd:7fa9:bada:4%7]) with mapi id 15.20.3805.027; Tue, 2 Feb 2021
 17:35:34 +0000
From:   Camelia Groza <camelia.groza@nxp.com>
To:     kuba@kernel.org, davem@davemloft.net, maciej.fijalkowski@intel.com
Cc:     madalin.bucur@oss.nxp.com, netdev@vger.kernel.org,
        Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net 1/3] dpaa_eth: reserve space for the xdp_frame under the A050385 erratum
Date:   Tue,  2 Feb 2021 19:34:42 +0200
Message-Id: <b2e61a1ac55004ecbbe326cd878cd779df22aae8.1612275417.git.camelia.groza@nxp.com>
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
Received: from lsv15136.swis.ro-buh01.nxp.com (83.217.231.2) by AM3PR07CA0093.eurprd07.prod.outlook.com (2603:10a6:207:6::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.8 via Frontend Transport; Tue, 2 Feb 2021 17:35:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e8bc220d-4eb9-4e14-e300-08d8c7a0f1f8
X-MS-TrafficTypeDiagnostic: VE1PR04MB6462:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6462A5F0DD98477718CA40BCF2B59@VE1PR04MB6462.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ASUXITgb0P9kcvx2ALH5fNy28rkS+zc8AFqfr83lENVc8QdHh2R9xAo8oGdDtPsGS0PDIlvPOpURfuj51430EZmU0VIDZ3sBQpH+0xO4PCAAE5DaJ/1kFSn+rgCyHjvhzpD7y8QHReQIfwH1G1bPAN4h8jDsW04NnTrnGCJApx0cwtXBn8aripyl4GCNxW8WTaBnoNYwPWj4rXvloY4ckfS+5IYQBK9UQbYqShik8Mts1Yd482RGb99une7AfpW9QyDkB0Ab93sf+uUH0VBMkqj5N2nCiGPyIkiB+5/cgc5MyixrkTlby7AVuc8I+/8KpbGhZ6yaX1bChuh9pLmdpmZJ4OJN37lRDtA6gMfQbruc4jDr85W+v/zRqsu5yrl4UdCqu0qnwuLT1mUyB/L5YKAqN9hkVGMVB+hIvS//hA4EVZAguZZRO/FHRQJZ2+HE62jmhF37VVVx7wSGeY+JbQKMKdVpMb/0BiLv/4ZdL/Z0pCLjyjSKzoEudoFhH5CbhAX6GQvOf8Iwljhu08LEIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(5660300002)(26005)(6486002)(52116002)(86362001)(186003)(44832011)(316002)(36756003)(478600001)(8936002)(16526019)(8676002)(66946007)(2906002)(956004)(6666004)(2616005)(83380400001)(7696005)(4326008)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hcN3BpWgqBZ4dNhIDqCT9Trj9Vrk81F/+XANNCytvy+NuUO8te6OJNvltHGU?=
 =?us-ascii?Q?0I/y+IdiE8/FZSPA6PTrpeJ5hfJA/N3tKYT4A/0n3hLXRA4Hb3wdEQLftvD1?=
 =?us-ascii?Q?vZmNO4bFlHrGIuTaot+ta+Zf0CTcI6e36+RMNt+4r05RyW2b7O7dtX4hkBzP?=
 =?us-ascii?Q?iW4WXNX7BMUyXexJ8lYJhLoIiU4y2g5miUAI2Cc/Z1iEUtx8nNiO4YneZgQI?=
 =?us-ascii?Q?yZyh+Ofqkvlez66bfKm6Q3iBAHsmZtv4nFCaivyAtFyTDbLbczTqxsRt21Up?=
 =?us-ascii?Q?tWf3sZKDBKCDvjDukD5Z3b17slm6+8Mz/SwcfSFJDYIWkQHC2jG6SvZO7zNI?=
 =?us-ascii?Q?Ce0CgtIPG6+RllFEvAeRb/f5vIINUVhCS+uIV5d2imJaFz5SbsgkR71295yC?=
 =?us-ascii?Q?hbjsElz6clZeESA5ZQKZylF88iqSevvidi7BCGPTNP9Z+FMyy2zrJTb0U0oo?=
 =?us-ascii?Q?Wp8xD24UznKcVxFjDwRoS8ig+K8tZ5m5VF81tNOarwn17U094xxn/hwv0nke?=
 =?us-ascii?Q?z7//umxX2H+GumhWvvCnNeeTOHtMsSflYyqVqmWmuDPzgkF8IZpeJZOCybzv?=
 =?us-ascii?Q?sVb3qGhxT/F/hnniKbwOF8LxzIu44dsvvBkrcuvjMSlrI9mQW4bp4yU97rfw?=
 =?us-ascii?Q?c9e23sZBaHyYNhrdzEnL64+0di2hPZsVB+x1iJ+yLERUM/OEUdXnzn/Jv6ux?=
 =?us-ascii?Q?4X8cXwmZCceCagyGcZ5UYaKngd3U/6eTW1sptXDQtal4bVIhKedifVAsGwJ3?=
 =?us-ascii?Q?WwiaU+ys82ol6g4waJWp1x0itmmDWXvpBXDE8TlF2cQm1xXGmDHcaA4tZDh4?=
 =?us-ascii?Q?ssYG0cdXG1+BuGKaDa//C97T71SzGk9okJp/hddNj9DAbJXjiAnPgD3KKxan?=
 =?us-ascii?Q?K866b8lBjbf+nfqOjgi53tt/NI4X6/5J2jNCZN45A4TuqHxpjTR5sCsi17oh?=
 =?us-ascii?Q?SysDbWWZd3JNpT+WYXNT8H72Ef/7iVDMrAxjuCdDZD8y5nLTy3iEWxlLEpz6?=
 =?us-ascii?Q?ra78rg0zucON+HvYhBud4ANMiMNW6HA770z38eOfeP6h3lyjB2rRTb0rIJaJ?=
 =?us-ascii?Q?HJOe1ngRJPqhyqp2NsHPXZmE7yvxZpGvmcbv0lUKC1uyM++QTyNJzovSE5hR?=
 =?us-ascii?Q?LJn+PfTILxa/5fzfX7gT7SDXcRMXqgyYJ8o0Hrwn0mTVlIxGVpSwOIhdxwym?=
 =?us-ascii?Q?0E1xOtVq5p3rjKV55N3br6rbBEA3RJdSu4WA/OR4OjAM9mWPiFf1RX0m1BgA?=
 =?us-ascii?Q?ZiBtIbXo1xYLVJ5D1ObFXHFKS8KZeDhW3WIvxvy8bRRFYeZQn7/2CQi0Eyfg?=
 =?us-ascii?Q?tLBTZ8x5Gy4XPhp4sPUlc7zF?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8bc220d-4eb9-4e14-e300-08d8c7a0f1f8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2021 17:35:34.2829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wbmOwNDhZyiDEbyh7gD1pbNGZNMirn1Ael8KbmPH8RiscGd2M2c5nuRx90i2rpM0gbgY4HHki/CIVfkOH9/YKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6462
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the erratum workaround is triggered, the newly created xdp_frame
structure is stored at the start of the newly allocated buffer. Avoid
the structure from being overwritten by explicitly reserving enough
space in the buffer for storing it.

Account for the fact that the structure's size might increase in time by
aligning the headroom to DPAA_FD_DATA_ALIGNMENT bytes, thus guaranteeing
the data's alignment.

Fixes: ae680bcbd06a ("dpaa_eth: implement the A050385 erratum workaround for XDP")
Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 4360ce4d3fb6..e1d041c35ad9 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2182,6 +2182,7 @@ static int dpaa_a050385_wa_xdpf(struct dpaa_priv *priv,
 	struct xdp_frame *new_xdpf, *xdpf = *init_xdpf;
 	void *new_buff;
 	struct page *p;
+	int headroom;
 
 	/* Check the data alignment and make sure the headroom is large
 	 * enough to store the xdpf backpointer. Use an aligned headroom
@@ -2197,19 +2198,31 @@ static int dpaa_a050385_wa_xdpf(struct dpaa_priv *priv,
 		return 0;
 	}
 
+	/* The new xdp_frame is stored in the new buffer. Reserve enough space
+	 * in the headroom for storing it along with the driver's private
+	 * info. The headroom needs to be aligned to DPAA_FD_DATA_ALIGNMENT to
+	 * guarantee the data's alignment in the buffer.
+	 */
+	headroom = ALIGN(sizeof(*new_xdpf) + priv->tx_headroom,
+			 DPAA_FD_DATA_ALIGNMENT);
+
+	/* Assure the extended headroom and data fit in a one-paged buffer */
+	if (headroom + xdpf->len > DPAA_BP_RAW_SIZE)
+		return -ENOMEM;
+
 	p = dev_alloc_pages(0);
 	if (unlikely(!p))
 		return -ENOMEM;
 
 	/* Copy the data to the new buffer at a properly aligned offset */
 	new_buff = page_address(p);
-	memcpy(new_buff + priv->tx_headroom, xdpf->data, xdpf->len);
+	memcpy(new_buff + headroom, xdpf->data, xdpf->len);
 
 	/* Create an XDP frame around the new buffer in a similar fashion
 	 * to xdp_convert_buff_to_frame.
 	 */
 	new_xdpf = new_buff;
-	new_xdpf->data = new_buff + priv->tx_headroom;
+	new_xdpf->data = new_buff + headroom;
 	new_xdpf->len = xdpf->len;
 	new_xdpf->headroom = priv->tx_headroom;
 	new_xdpf->frame_sz = DPAA_BP_RAW_SIZE;
-- 
2.17.1

