Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2F330F895
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 17:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238136AbhBDQwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 11:52:33 -0500
Received: from mail-eopbgr130072.outbound.protection.outlook.com ([40.107.13.72]:22438
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237939AbhBDQvL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 11:51:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JeNnrebQWvXMdgGHf65nqzJzFEzhCj4Mv02YfMLFO4Cd0JGGblLq+5AJ91I183O2VQSMDVuUWGZ70rF5QS1YIJY2ygFkem1Ud7aDdOMuHyuhhk+/GtvqJf+1dUOtz/hnO0TtGqPblPoHaPQL3GSAHjvT5lkak/oIq59sPgtvhO8RHSyApbD1UnDm1vhbv7PbYexmcLeEoBBuUBZnO1ypPSqFcgaeX+0ojZKk07n90OVcBt6+HPU3cE90E1N7GPKAtt+86o4Qsk0conoR/ZwUMd/tldkuKtALMBWMeOd4s0JSNvxseNQRtB4sRBVha1wn1LoiT9aEsBT9ucLwDY8W2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lKBjZ0wvRKv+2bZtWIPXg1l25PnWe6NmVluXgXvIpgk=;
 b=VuVZemYAKkVfhxfvRyNTGUSPZ9A65YQipwq4lt9euW8AcX9U+ABJh8+1ARwt0GfihXowS2eWfu04itnsEglfwPcaZgAj0dfauinUAWkogzIEiiBFxuXtDF9pEV+DaIha0hhSZC4Jl/TC8osfwIdHVmetc+iKYK6C6TDO7p4Bzm/jerptf0HYpjT3LDl9nfN/QOdblytCKPBHGXly9LazEIYMgQr2vkurSdowATNbQKbq2IIRjJ7dvrz3VsRZdEOa6zQ/un3/KmUToMzXtsdH0wNx0b4t+PkgW1NH/VF7G1sNR3l3rezaMGreO+T+TEnXt2scDfJ2gJERbI+eOxgSAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lKBjZ0wvRKv+2bZtWIPXg1l25PnWe6NmVluXgXvIpgk=;
 b=A0eKiyCCtTvi7vwxtsiFIokCSahQZrueyy9STUidH7ZRBSEfWrQZ1KS9V9Gh9NksXUgMmhCk5QJW8MDHOyo1RuDk1tDWaHh4L3elZrz8hE7HbIYFLgY/2e16g2tNUuhXrLILP+ICM5Y2cSTr86OW9FboYzNyII7eXe1S/R3bR0w=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR04MB6206.eurprd04.prod.outlook.com (2603:10a6:803:fa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Thu, 4 Feb
 2021 16:50:20 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::6ccd:7fa9:bada:4]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::6ccd:7fa9:bada:4%7]) with mapi id 15.20.3805.027; Thu, 4 Feb 2021
 16:50:20 +0000
From:   Camelia Groza <camelia.groza@nxp.com>
To:     kuba@kernel.org, davem@davemloft.net, maciej.fijalkowski@intel.com
Cc:     madalin.bucur@oss.nxp.com, netdev@vger.kernel.org,
        Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net v2 1/3] dpaa_eth: reserve space for the xdp_frame under the A050385 erratum
Date:   Thu,  4 Feb 2021 18:49:26 +0200
Message-Id: <ee72008efcee3bc52d25811a73c685d055e39b47.1612456902.git.camelia.groza@nxp.com>
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
Received: from lsv15136.swis.ro-buh01.nxp.com (83.217.231.2) by FR2P281CA0026.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.10 via Frontend Transport; Thu, 4 Feb 2021 16:50:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 102f5db6-6427-432a-10dd-08d8c92cf528
X-MS-TrafficTypeDiagnostic: VI1PR04MB6206:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6206C42175E344CF838230F7F2B39@VI1PR04MB6206.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yaB8VDwZgE9696XCA9USQ1dfEZq5QUEIdXPPwNuV7sv0FWSOENlh6Auv9GWEq3NxnhzHAPBXgq9lAuJEkpqZcI9Hqhh+vJ1Kt/omcf8jhx8If2Wjc6NNDg2E0IIGIyA0juZpv/+i8ADK1Icvyk0ArO+ldKcdIicvUcPDAX9Tuc1DLkl2X51PbvHKc/QPggDsxF/Lll7sKclhM/4Jdz8tDp2ry87cvA9QjcgXVfBY7gBToFLcZ4O/RJ4wt2qfev0xrlebMpY+gbYuFymrM2vp+2m2w3FCMJLcerXP5XwVGl0N057plwE9MyyJdKs6h+IRqF7cm/NfCcElyCgdBKs6EIJCtorzsj2c9Gc1vpcU2SfLY2sccbPXtxQF8EA1KDW/5BKm2dtLk0KgIViTmj25K770/TfxOXa2azzQUvc/MNsMZkWaG+da+w3mu75Y6u6NQ8EO0NNEP1T5+NGBuzqEt+JF33T2Js5ycXABo/0SX9r+fO7QhXujcb4lag1aZlv44N14AuATxhVWHVGHm5Tf0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(39860400002)(396003)(136003)(478600001)(83380400001)(2616005)(2906002)(66556008)(6486002)(956004)(66476007)(44832011)(7696005)(86362001)(4326008)(186003)(52116002)(5660300002)(16526019)(316002)(66946007)(8936002)(26005)(6666004)(36756003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Cp2CI8jI7vtZZwt5pY26lvI75umbvrvRbFFQBmEOsEvZF/3Axj/Np72lmVLl?=
 =?us-ascii?Q?QVow9de4tfh82FYQKHqsEVoNxXkF5UbUdY096xqk5s20wqR/s0b8JV9dJOCq?=
 =?us-ascii?Q?7SRqlD26QOjun0Bwh6jTyhnKenxjlW8GNcNPpV+F9ml1oZeDX55srh8kYps2?=
 =?us-ascii?Q?psLBjzU5mXtCeuvxjidDURYnjOlenfhw3zdclWnvkjNT9f1gaE9uZdFirg9d?=
 =?us-ascii?Q?KCqGBNxpWYgTPEQmFC4jem5+8RyAEiuazLTwJtT5lvBRbPowwe6onsBtep5k?=
 =?us-ascii?Q?BKIVYJq5zNqDmuZbRVlv6Sl1ZTff7WFGLRmfnl7pfw7OycwwvEmfST0BRZV5?=
 =?us-ascii?Q?HduN/oz0sjzpzZio3H/wvttaneo7Y0VUZAJVhol4KrJ2h33vJTJ1+PHjeRTo?=
 =?us-ascii?Q?5DX2XN2QusPZ3yUVaFogIO2EpJ2RZS4pP0imM9wl75toJuvAIpYa7pfGbbH5?=
 =?us-ascii?Q?+lGZUozWoK2946o48+SnLgXtarj12fbGp835RB0k0GZ3KB8ck2uparm1BNmG?=
 =?us-ascii?Q?jzDaGZL8470cvJ72vtij1DiY7M3qwiTPvSjQX1p/5zhsGLoHzVoQWWLb7X5l?=
 =?us-ascii?Q?LWartShRVuqiACT5ExLHpbYS1M3kGZ5jAo/PNgvh9KBMvjb5xoIXc0blrzmX?=
 =?us-ascii?Q?UFfNJHAyNQCdkOt1CP3y7WIz758oIShfgNLCQZmsDMoFr4N8d3EG7yS6cvVS?=
 =?us-ascii?Q?s6nNdPJXnlfzZiixSJjOSZvSCGTvFnpF/64DfDYLwVVpwvEPf5qH4I8pchj3?=
 =?us-ascii?Q?XoZ7dA9iIz8ldwHTa638ft8cD/qmOcSKbcoa81cRU97yY+MACpKuVU8yd4wO?=
 =?us-ascii?Q?obw4azD9s1PgI4CBAKR4OHRT6etA0uccMqIfNW4KpcyFIaUXLyZu2eTL5poo?=
 =?us-ascii?Q?6zd7WB+JhiQn3e/DOLQLthgAZzhWyXYieo0m/ANii9QTOhjfJxN3tB+9ZOUW?=
 =?us-ascii?Q?Gtgi0oHIsQtmb/T/5K3M6bfB36dNytH2zLmvXmdAeUNi+FfonB+496e8MTy/?=
 =?us-ascii?Q?dK2QZZIVHFydVVvVLQuW0zak5Ni4F4DKLQnV+VNsGcH1S7F8JA+4HaGtmpOW?=
 =?us-ascii?Q?3huLTWFHYPIYXo27lo1mhBRB/q4ChYMjXnFJjW2jb/hRoswKAyJdnxq/+9mL?=
 =?us-ascii?Q?MLARUOgRcygJV7yIvVvCVPv+xYEAHRxJR/Vlw5DRJ6Qd51sreVDogLRRKcaT?=
 =?us-ascii?Q?5Tj3h3Pcfe4vCVLgJkOtzqC+8rkqlT6WOl4uRUT78mk7I8VTX6dGxHlIqXvf?=
 =?us-ascii?Q?M/eJdoKJLYj90ezAcT+OpKEB31lYJygm8ourW6E0e14/htYbp4370Rog6Zct?=
 =?us-ascii?Q?RT6NeN4NM2Lq1GDbheJxOvhe?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 102f5db6-6427-432a-10dd-08d8c92cf528
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 16:50:20.3421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sl1QFY5q7JjPmV2a+Pulm+cpmMnANzmIwDTD3Ve6TUXu212hNVtbUrSuBwpfgMsmBhMGcpdsJQenNZgAGmyZLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6206
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
Changes in v2:
- guarantee enough tailroom is available for the shared_info

 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 20 +++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 4360ce4d3fb6..f3a879937d8d 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2182,6 +2182,7 @@ static int dpaa_a050385_wa_xdpf(struct dpaa_priv *priv,
 	struct xdp_frame *new_xdpf, *xdpf = *init_xdpf;
 	void *new_buff;
 	struct page *p;
+	int headroom;

 	/* Check the data alignment and make sure the headroom is large
 	 * enough to store the xdpf backpointer. Use an aligned headroom
@@ -2197,19 +2198,34 @@ static int dpaa_a050385_wa_xdpf(struct dpaa_priv *priv,
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
+	/* Assure the extended headroom and data don't overflow the buffer,
+	 * while maintaining the mandatory tailroom.
+	 */
+	if (headroom + xdpf->len > DPAA_BP_RAW_SIZE -
+			SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
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

