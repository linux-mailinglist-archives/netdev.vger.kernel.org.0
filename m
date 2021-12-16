Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 994E147678C
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 02:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbhLPBvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 20:51:07 -0500
Received: from mail-dm3nam07lp2042.outbound.protection.outlook.com ([104.47.56.42]:31166
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229555AbhLPBvH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 20:51:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cdnmYdQm2wJJGK0K0JEsmCGpf8wdIS0ecRmFZZmBjxcx0PnSi5d2veyCHnrAXk/QQhl0I1/xK65C1dx7pAdp43y82R3FUZHS1TXfFi2+RplInEWKq43wYw6M/DKX4WsREpLvB1/cMxiOGjqlGyER1NfnRl9/TSIq1niEVfJtHjrpn3+E/PzuuQS1hDgVeO6Bokh1+G1n5MxkI7tzrr8lU/YBX5o1QOejzwyT6xZejhxe4gSj60FcSazaCLfyprmm5hp2P/Etp4AhbU4K6TtQ39rEmXtn2YhHqnYMQ7+GeUJ5zEn8uY0CFrNgHE9uD9Nkd/UHV12/P8RFODivXXwjXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KnFt6jaCEr7G1dLVl00UfAYrxq0dq4HNDNwoha1akp8=;
 b=D/fC36kcoDH76wVU7r3/Y8mqH8UN/PzVQQ3kEIhexhQCEjDBqaUfjkxIt6BwHGmU6VQqvU2bB8C097sRziw4//s6xf8dpIi/Ta+X8pTBw4vYAFrX9HXL85saHZFM7DMhfjXu0YHgC+51Tsk+eC+Q1PXf86WJNjVuYGHiOiAKH53CEmXRCgpMHZAwb82ndBMsUF0UinfwFFA4x/xC7Db42Og9yZBn5Mo70TpC9Ur+KjsN0Fy6wPoXXxSYnledEL7FvZ25RSrOhZUfJVSoIrZA3/JRJarlJDzPUm1034TIXaARq+FLTnvtJ92Lloa6s9Ocph1RzP0lyOASmiVczihiJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KnFt6jaCEr7G1dLVl00UfAYrxq0dq4HNDNwoha1akp8=;
 b=wfX+Agn/5TSY0YRtamqG/F6KLfXqLOCk/bNM2niod4+BmWM2mvp4Ydx0OyrCPIaKSM8JRgNFRzMrGVy4F4hQ2N3Ok3mH1y0pVvr+JwCSX2XikURHA2eR9Cp5eyzGb73hJIen5uyVNaFFM3+KkO0f6cu7LGsmz57tsfe+iYcBqGQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by DM6PR13MB2620.namprd13.prod.outlook.com (2603:10b6:5:138::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Thu, 16 Dec
 2021 01:51:05 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::21e5:6f6b:6197:2122]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::21e5:6f6b:6197:2122%8]) with mapi id 15.20.4801.014; Thu, 16 Dec 2021
 01:51:05 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next] nfp: flower: refine the use of circular buffer
Date:   Wed, 15 Dec 2021 20:37:01 -0500
Message-Id: <1639618621-5857-1-git-send-email-yinjun.zhang@corigine.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0024.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::36)
 To DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c173511-096e-4d7f-5ece-08d9c0368593
X-MS-TrafficTypeDiagnostic: DM6PR13MB2620:EE_
X-Microsoft-Antispam-PRVS: <DM6PR13MB26206A051EB03F9BF5F39D4FFC779@DM6PR13MB2620.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1c6CLWOOl8gc8fnBYCJpBtHaygao0cKumPpcLoxLf/eUFn+A6JJruopXd5Kh2G9EYgNBQS4KFmwjzngv14JPELZbFeM7mljFLSFowR/Mz3ajQiIiOm5DiBHYtGTEdY4SvCHMm7FYlLLUi204LGmWUgjS7gMnO4kbp1PB6aW3fxes+RaiCk4kco2c1saD0ev3Xy7/2YyR5r53N1OZze/O7oYq3vQ4OGpuJy2DSLiNC/B+0EVnjvb6eZLu38Nzu3T9d0BrEBsPT79fKj4rdCM6L9S+31IBussJUqsW2UedS3zZ1MgPM/oZ1JrPiXva+SlYA4g70KWmSguNjgEOdEqsva/ITphCVKGRa/av1a1m6ImGjxejwe5jq4VCHCJBaRqY/3mKHAjzuDfZiHce6nkc0xmnvWzdhmaHLy8hU1LUjqyr5Ml+s+97xWakbtHWwtkJozGp6KOWMT3x2SE0PrGfZBdNptwZfpFPczIE1Nxe2qHENfnUoUTaiwFbXkKPjMZL20KU3jmCZiG3Pn+PhNPi+vgGKv8aqrO+k/XRMCOL1WE3F/Hr3UH5ZLYhXmmIGu0YDRVtFoxSioyxhCa8wUFR8xUfUZf+bf/v5jsl+Ub+HFHmSPgJmln6OBc6J/TiKPv8u8ATcdviYcSSaBQmWebR+BOisfiXoIiASHSR+A4iVhnTLEQZrlp1LIP/lx+5JgQWFuPVR2P17Km8S5ldOFvNIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(54906003)(8936002)(36756003)(66476007)(26005)(52116002)(66556008)(38350700002)(8676002)(66946007)(107886003)(38100700002)(2616005)(6666004)(83380400001)(6486002)(316002)(508600001)(5660300002)(6506007)(6512007)(44832011)(86362001)(2906002)(186003)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3QOpC89RMl+YrONP8Qomt+Ypo0zLK01lUgr6lhBLAPEU8JtJ3JhAVLFd/I0/?=
 =?us-ascii?Q?BRlc93ZaWs9Pt067MNV78O+MROZjnJK/Ohn21AdUjlOEjrxIhQT8+VKbRI3T?=
 =?us-ascii?Q?vI0bJljMIb3VPAP0pYVz2JvGw8VCeAH9/FrXPz27YIK/foX7GsACGAeCFbD5?=
 =?us-ascii?Q?rbxmeaCMnISv7QQZ/ERUXWkbukrz2XzvFE3r+7EE8couwed0vBoe40hEDYPa?=
 =?us-ascii?Q?7Y6dDimjhvNpEEjiaHlVb4/uyIVlg59pZMa6GjmfSsUyy79fWK07hJ3vgujw?=
 =?us-ascii?Q?ULuXqHEDPjduxruQaqV5Dys+zaiP2MeXghwLUttjE4TSEZm2AybxauujvWe2?=
 =?us-ascii?Q?Uv5ddkGYQ1MzxAkne1qifX3cljwFJwMnQ934IJMvW5nMp6qapfTl7mftAYoA?=
 =?us-ascii?Q?CAxxwCNNFOhWPa63tLn3JdunlUm02AiX6wmJVlw8CMcI3hDZxO7bmSdhGG/v?=
 =?us-ascii?Q?v76FKuMe6H5AkPf+RB8rakih4C3/zz+LiIEffgH/cX5VVO5s2RQXJ1xCVi+j?=
 =?us-ascii?Q?QUEsPBS0fHEA5nG5dLSCZkxXJgtaT/rioEdrjocXUzpehn6L+/M4PwizBNtT?=
 =?us-ascii?Q?l9uRmFtndr8es6BPMSn5eZfnwBc8anKhQz2pIN+xJrWKLUEBPO2cjMQDbMTU?=
 =?us-ascii?Q?Vx+bmsEcINP9lfbtuQiQKvRdKDN67kkuCLEz3pawHY40+RYzJD0jxX4hGioR?=
 =?us-ascii?Q?iQqY51lpXRpgyjlEy4IyHMOABHApANb0DHFmlTqfLO6OkVM4ZMX2x0HNxMk0?=
 =?us-ascii?Q?4OZK644amQn9QCWKEvcX3TZdEnOthpgUBifkRC4/l2r+XoXPIaRz3RAQeKcH?=
 =?us-ascii?Q?ZVMg7lr6cy/Y2XhRtZ1wcOY7MmZ9plMjdFm3zCX2E2EPAJFyfvvX8/KPTK0E?=
 =?us-ascii?Q?FmaNrrHTlfWX99U0FF0nU72NowGq/bUZbUfT3zK1dw2hLl+Rq0cAfxnf9uXO?=
 =?us-ascii?Q?3Cq3BUd3Ki4vxZ67M8j+LFB9+Tmp4iiSZpjBhtBtWspBXVtKi8lE/sAfvwjA?=
 =?us-ascii?Q?OXwHT8yq6Xt70OsWUgRfi4hblh6z6MvpoyiUzavIBlCWhb5JzcMlYlW/cj+Y?=
 =?us-ascii?Q?ZZPyxV7r07HPLfjPuf5fJMNPvG/6ayeUzWfuAxh4EyyXP4SWOy2AUHykIZim?=
 =?us-ascii?Q?XACHCdwoaupRk+4MFGh7xioQmnOZQCimWgH3obCND8GM1CDixK2JjmELnbuQ?=
 =?us-ascii?Q?1CkigAwsCEIrhTfIyob4fZqe3TpBdY00k1oDo2mMiLmO9+DI6JQ3KGph9tn0?=
 =?us-ascii?Q?HzDjzLz0uUNhMZsFnm5luSDOIaZLXXAR39nMDR1OMZp9T35ySMPmlPZCax1H?=
 =?us-ascii?Q?XvqBXQbO60WG6xsrf0tN9Tencc0bKOxW8jKEAX6iH8Hq2rU5rHiOaeLzNf6g?=
 =?us-ascii?Q?YD0InMITtOhPx/pzLcvzcy93z0DiT28Ux16GM9N5wuev7L3j1kKd6xTgdqPb?=
 =?us-ascii?Q?tU/zalhmeTXlkKTu52aquW+ttRYPM7tW/Ld+3ovH3h6fgCzuhmNPkPRQx0Fp?=
 =?us-ascii?Q?/kDb/SpPkusEUbVPVSp1VTt4t+kS2YRnAjNlPY8s2rb0eKiFsYsPpNCNsRAW?=
 =?us-ascii?Q?DhO20XNArC+VwhkzwNr0Ki05rlkoBGElLYZiMHqKQHjnvkHdP01B5i3OKa4+?=
 =?us-ascii?Q?sxlVMl0hQdJalNlQrjWR5nfn9cTCvs+2u4H9v6EZfVQCPSqFPBk8AqNzKEUQ?=
 =?us-ascii?Q?ZvqgcQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c173511-096e-4d7f-5ece-08d9c0368593
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 01:51:05.3431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GZTNB4u0mXyrZI/B20XwU28jqnlCbDuVS2EhGUZ889Tus0w2hQJq4lj3hym1FX/8cFsBnlKnXu+S/WcWd12LFLyBWcueyW/pjN7ErL0lhcM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB2620
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current use of circular buffer to manage stats_context_id is
very obscure, and it will cause problem if its element size is
not power of two. So change the use more straightforward and
scalable, and also change that for mask_id to keep consistency.

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../net/ethernet/netronome/nfp/flower/metadata.c   | 50 ++++++++++++++--------
 1 file changed, 31 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/metadata.c b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
index 0c60a436a8f2..f448c5682594 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/metadata.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
@@ -43,15 +43,14 @@ static int nfp_release_stats_entry(struct nfp_app *app, u32 stats_context_id)
 	struct circ_buf *ring;
 
 	ring = &priv->stats_ids.free_list;
-	/* Check if buffer is full. */
-	if (!CIRC_SPACE(ring->head, ring->tail,
-			priv->stats_ring_size * NFP_FL_STATS_ELEM_RS -
-			NFP_FL_STATS_ELEM_RS + 1))
+	/* Check if buffer is full, stats_ring_size must be power of 2 */
+	if (!CIRC_SPACE(ring->head, ring->tail, priv->stats_ring_size))
 		return -ENOBUFS;
 
-	memcpy(&ring->buf[ring->head], &stats_context_id, NFP_FL_STATS_ELEM_RS);
-	ring->head = (ring->head + NFP_FL_STATS_ELEM_RS) %
-		     (priv->stats_ring_size * NFP_FL_STATS_ELEM_RS);
+	/* Each increment of head represents size of NFP_FL_STATS_ELEM_RS */
+	memcpy(&ring->buf[ring->head * NFP_FL_STATS_ELEM_RS],
+	       &stats_context_id, NFP_FL_STATS_ELEM_RS);
+	ring->head = (ring->head + 1) & (priv->stats_ring_size - 1);
 
 	return 0;
 }
@@ -86,11 +85,14 @@ static int nfp_get_stats_entry(struct nfp_app *app, u32 *stats_context_id)
 		return -ENOENT;
 	}
 
-	memcpy(&temp_stats_id, &ring->buf[ring->tail], NFP_FL_STATS_ELEM_RS);
+	/* Each increment of tail represents size of NFP_FL_STATS_ELEM_RS */
+	memcpy(&temp_stats_id, &ring->buf[ring->tail * NFP_FL_STATS_ELEM_RS],
+	       NFP_FL_STATS_ELEM_RS);
 	*stats_context_id = temp_stats_id;
-	memcpy(&ring->buf[ring->tail], &freed_stats_id, NFP_FL_STATS_ELEM_RS);
-	ring->tail = (ring->tail + NFP_FL_STATS_ELEM_RS) %
-		     (priv->stats_ring_size * NFP_FL_STATS_ELEM_RS);
+	memcpy(&ring->buf[ring->tail * NFP_FL_STATS_ELEM_RS], &freed_stats_id,
+	       NFP_FL_STATS_ELEM_RS);
+	/* stats_ring_size must be power of 2 */
+	ring->tail = (ring->tail + 1) & (priv->stats_ring_size - 1);
 
 	return 0;
 }
@@ -138,13 +140,18 @@ static int nfp_release_mask_id(struct nfp_app *app, u8 mask_id)
 	struct circ_buf *ring;
 
 	ring = &priv->mask_ids.mask_id_free_list;
-	/* Checking if buffer is full. */
+	/* Checking if buffer is full,
+	 * NFP_FLOWER_MASK_ENTRY_RS must be power of 2
+	 */
 	if (CIRC_SPACE(ring->head, ring->tail, NFP_FLOWER_MASK_ENTRY_RS) == 0)
 		return -ENOBUFS;
 
-	memcpy(&ring->buf[ring->head], &mask_id, NFP_FLOWER_MASK_ELEMENT_RS);
-	ring->head = (ring->head + NFP_FLOWER_MASK_ELEMENT_RS) %
-		     (NFP_FLOWER_MASK_ENTRY_RS * NFP_FLOWER_MASK_ELEMENT_RS);
+	/* Each increment of head represents size of
+	 * NFP_FLOWER_MASK_ELEMENT_RS
+	 */
+	memcpy(&ring->buf[ring->head * NFP_FLOWER_MASK_ELEMENT_RS], &mask_id,
+	       NFP_FLOWER_MASK_ELEMENT_RS);
+	ring->head = (ring->head + 1) & (NFP_FLOWER_MASK_ENTRY_RS - 1);
 
 	priv->mask_ids.last_used[mask_id] = ktime_get();
 
@@ -171,7 +178,11 @@ static int nfp_mask_alloc(struct nfp_app *app, u8 *mask_id)
 	if (ring->head == ring->tail)
 		goto err_not_found;
 
-	memcpy(&temp_id, &ring->buf[ring->tail], NFP_FLOWER_MASK_ELEMENT_RS);
+	/* Each increment of tail represents size of
+	 * NFP_FLOWER_MASK_ELEMENT_RS
+	 */
+	memcpy(&temp_id, &ring->buf[ring->tail * NFP_FLOWER_MASK_ELEMENT_RS],
+	       NFP_FLOWER_MASK_ELEMENT_RS);
 	*mask_id = temp_id;
 
 	reuse_timeout = ktime_add_ns(priv->mask_ids.last_used[*mask_id],
@@ -180,9 +191,10 @@ static int nfp_mask_alloc(struct nfp_app *app, u8 *mask_id)
 	if (ktime_before(ktime_get(), reuse_timeout))
 		goto err_not_found;
 
-	memcpy(&ring->buf[ring->tail], &freed_id, NFP_FLOWER_MASK_ELEMENT_RS);
-	ring->tail = (ring->tail + NFP_FLOWER_MASK_ELEMENT_RS) %
-		     (NFP_FLOWER_MASK_ENTRY_RS * NFP_FLOWER_MASK_ELEMENT_RS);
+	memcpy(&ring->buf[ring->tail * NFP_FLOWER_MASK_ELEMENT_RS], &freed_id,
+	       NFP_FLOWER_MASK_ELEMENT_RS);
+	/* NFP_FLOWER_MASK_ENTRY_RS must be power of 2 */
+	ring->tail = (ring->tail + 1) & (NFP_FLOWER_MASK_ENTRY_RS - 1);
 
 	return 0;
 
-- 
1.8.3.1

