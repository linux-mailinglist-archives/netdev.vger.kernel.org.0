Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DE51D5C82
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbgEOWtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:49:24 -0400
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:33656
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726247AbgEOWtW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 18:49:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aqu0nfoFd9mTVa7MDbhqJqY0A2aTLnvEj6yWu+a+IiyAzROOCF4bClYruIkVokeInd8V4M9S//t6KTz8jYze1ATXXW70hff16ev+jFYVBTrlhMH/X8FE55d1q775R8gGGh8zwKHyzcYMgYyv4AwUVsDFTSNJgL6xCEvAG/xFr+Q0rBABWfpj1Tx/8jMKlAN0+67zqL+QP8mJ6d+RL8nPb+E45Yw8EXB5/y91MCQ97xnxjEEYPtzeJwJuSMpIjCh/VDbl2tIvpGriamKyMs4H4NZCzeJtMHK6vkR4MCisI+77vCw89dlraZLzgCxYanSgFBgJMKsZ0SHcqABoOZcJJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c0pEh7VWmnJJbYPz/GSd1gHtMmZiT9aicz8pjW96oyU=;
 b=enccyQkI28RVXBE4I8U9Te5XvAIAjSQSP+Tal/LYojjEmLH9KJE3CD0FKszWz/5ySKF/ADdSs7SkOqArjvtsDY7rKiLHGtDZ6Xn1V1alafvHkuv+eX3n59L04Q5D2/sxng4iIaQ/IgQ8q1KdCFPvI04BY6wUKmfSHm07GTky1Dg9406eskm0MpG+V0X1nTUElfymDCDZ89TuYHANan5NWxd8qRGsUejx23QYElpP0fNNY17a5kob0ZVzR4INYtr4nIFhkoRCwamoQRYajU/ntuTC7j20GZtSts7jDAeKEAP3YURJ1CqpDjmkA1iXbdia88sRVEIlmLoc8nT+zK9QWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c0pEh7VWmnJJbYPz/GSd1gHtMmZiT9aicz8pjW96oyU=;
 b=Q3d3Iuq3UODnE9X6T7+zC4HA5E493p/8ZLjAnE1U6xQYAj0nOsiDJnNRsQ9EpxjZDdtV4BcV3Q7wGvHVgCuTUUsitFCuUIFwK0fpa51mAKyiyJgdxxyr+r6+RJMPa/EJJRwXbqUWJgPJLKC3fGRRtfMPAqfvRjlcCbME18tmeYU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3200.eurprd05.prod.outlook.com (2603:10a6:802:1b::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24; Fri, 15 May
 2020 22:49:18 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 22:49:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/11] net/mlx5: Dedicate fw page to the requesting function
Date:   Fri, 15 May 2020 15:48:44 -0700
Message-Id: <20200515224854.20390-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200515224854.20390-1-saeedm@mellanox.com>
References: <20200515224854.20390-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0053.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::30) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0053.namprd06.prod.outlook.com (2603:10b6:a03:14b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Fri, 15 May 2020 22:49:16 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4a2dd4d4-f589-4a32-84b3-08d7f92232f4
X-MS-TrafficTypeDiagnostic: VI1PR05MB3200:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB32000F0FE980280106888D5CBEBD0@VI1PR05MB3200.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +h/+sWi2au+biM5+ZIW2CnIPM2An8l+oU7Jtx7f004i1/d/L5rjYcnJ2acKTba9tknc1nPZa1LPHUdaYrrtFRquSNwKurgND0dS86Wy73OANzYizjcoOAdIv1rApGuGvghZos+NX9CGAAQJBt/jekqmWm9HympwCOnLYymSy9bIRSZRGlK8QNS1SRBGHOj/V+3rkbIU/QlH/HxE9OtaYxwZ9xWgu57lCgYebwYM3Yp7jdkBusgdtiNiYP6wvmPnmv5AB5PkqkeaNzkF59pewAUJsnfQ8B4VPxNh7t93mPu5SiK5MXoYamh9X7kZg+Kgu3cKfHWFMK4KDiLTnFioLATrK2tXMDiW9fCt6yKBy2V/8mwgPZf2lC2OH9stIRCplTlhE7javt1EyMDFsi1lOuxDp95GuVxMrk+fnmBdiUR6XSHZ8H/vqCDZTArVApmdophE32mgrrFCnE7+HrE7axaglIdP5U4MpvcoEoD22kGY30SKAUzH8p9kYTVQteB6e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(16526019)(26005)(107886003)(4326008)(6512007)(6486002)(6666004)(478600001)(66476007)(2616005)(66946007)(66556008)(54906003)(956004)(52116002)(316002)(6506007)(186003)(1076003)(86362001)(5660300002)(8936002)(8676002)(2906002)(36756003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 0clxcG31Tlcm0tOPfWzx2fQfaXU+vDUzgFkq/jQHWFp/o0brNi3Xrlqqeeune+3cwLjmj+BR9rL4Rt1oqJI5gn88XXDnEugc+Wf/KY2IBIhJXDWWOFpvjdK/tjop2Qbk42SWRkIoFJBpkOBdlJuNGnVbsWiUxB1V82sWyhwbDXt0BoTb/hChfEa8UmBhjukor8HH1gEc4NEQnwWBS1zetHIoY8W3j+yBRdEuUj+6Brloy2lm88Zjk5+Pn7IKaREEnKa+10qC+HHwJo2e17WB0Yrvp5Ya/kTnnsQSAHr/k9XA/U6FfPPZVShJGHP21nb2B/IT20LZ4sqA1Tfq0DqoD7KFPnUYRc6Jj5D2BasC2LRQW3SscJiFyeBWcDNwcDqT4hyUgGzni2iv/70bH4UclpyIB+1FXA/hlG8xDJPFXFogrUZhP3PkqCmvmuuCgX4b88Labac9JYXHIoujsWFH9i8QjoAniIAcTOlefQL1vOU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a2dd4d4-f589-4a32-84b3-08d7f92232f4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 22:49:17.9741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mjqni3zvg8Ahi/XJwL0OirciDC1C60hGo2Rv7xxvydr3nDEiinsKA/hWjmREJF474WIb0MnI7AKNz9Lg84erSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

The cited patch assumes that all chuncks in a fw page belong to the same
function, thus the driver must dedicate fw page to the requesting
function, which is actually what was intedned in the original fw pages
allocator design, hence the fwp->func_id !

Up until the cited patch everything worked ok, but now "relase all pages"
is broken on systems with page_size > 4k.

Fix this by dedicating fw page to the requesting function id via adding a
func_id parameter to alloc_4k() function.

Fixes: c6168161f693 ("net/mlx5: Add support for release all pages event")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c  | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 8ce78f42dfc0..84f6356edbf8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -156,15 +156,21 @@ static int mlx5_cmd_query_pages(struct mlx5_core_dev *dev, u16 *func_id,
 	return err;
 }
 
-static int alloc_4k(struct mlx5_core_dev *dev, u64 *addr)
+static int alloc_4k(struct mlx5_core_dev *dev, u64 *addr, u16 func_id)
 {
-	struct fw_page *fp;
+	struct fw_page *fp = NULL;
+	struct fw_page *iter;
 	unsigned n;
 
-	if (list_empty(&dev->priv.free_list))
+	list_for_each_entry(iter, &dev->priv.free_list, list) {
+		if (iter->func_id != func_id)
+			continue;
+		fp = iter;
+	}
+
+	if (list_empty(&dev->priv.free_list) || !fp)
 		return -ENOMEM;
 
-	fp = list_entry(dev->priv.free_list.next, struct fw_page, list);
 	n = find_first_bit(&fp->bitmask, 8 * sizeof(fp->bitmask));
 	if (n >= MLX5_NUM_4K_IN_PAGE) {
 		mlx5_core_warn(dev, "alloc 4k bug\n");
@@ -295,7 +301,7 @@ static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 
 	for (i = 0; i < npages; i++) {
 retry:
-		err = alloc_4k(dev, &addr);
+		err = alloc_4k(dev, &addr, func_id);
 		if (err) {
 			if (err == -ENOMEM)
 				err = alloc_system_page(dev, func_id);
-- 
2.25.4

