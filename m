Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A501697B99
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 13:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbjBOMRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 07:17:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234047AbjBOMRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 07:17:41 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7DA93252D
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 04:17:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NNopBEChA9L+HnfAqEEqjioHcywoSKWdPyU+GyuvTdg7ftp79jotgb8STAcke/AzKHBxNswfXbcO9hz0HGWV1ZcZQkRXLnrz+EzEGqrrRCerwmVFsLewVRKEN5R7N41Q8dH1OTiVlXsUHQOzjIWx3E+q5hA/BUVj2hNGaFKlG3Ecam5+vrTe3TQT5o3Bmorsq0a5tvjwwh8paK5zasZMNY/IZR6UVaabKWNbUtnDaz0wnSN2hxSTo+OY0lkn0kMRbfIu5FSegCGfe2NaP1wTF3PdbxkV8Vcqb0ersGhIGyYwiZeXsig/kiBocYaRsD5efhWAgk292U1OoCPEQSf+Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IQCzSmBq77mMbtekYTQLM0X0vi6Y5faJ4M5pa4X7Bpo=;
 b=c0uyZC7ZBC0zGgSjQIXm81zdf+IG+uVWmRcNz3NTnBcz8xOJOxiOAlpRfHlwjBrvvtysSwC60e5x7UyFRLIfj9T/AuowZ3g5ZhKz+oRzCI1epgYmr95sFYZVqIyOr3O/lKUAAJ2dkLnT5luyqvt96/Du2g5nnDMYVO4yJpA3rfOJOnO/03T6Wf6NXGRx8t/BWRL81X2qD0wueMysuObzJmaTmzzMw0EchtGPCPNmYsuV5uv7ky6KHqfZ6awHXGMXDRuz8Zp1xhylchLRAuyBN+MIejCnZDIfxo4382ZN0rK6eyi4mrjTHYSAtH54ovcWVL4cncmIaTQI/n/7JeGFAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IQCzSmBq77mMbtekYTQLM0X0vi6Y5faJ4M5pa4X7Bpo=;
 b=Xkm7zj6+jV2cNmH8cRvPn2y4xUbZJDKHg0KeHXPPYNbkSJ/baiBR1M+o+KQ5800zyMTKKRJhrKIrZUgi9pDrL0j3eplH9/0obcwJgZIJnHaauwJ/qMQHOZKAe6GvJgGZl0BSF278FpAd8ZABwq8Rm5klxK1jRGna7XPFPKI82YdKMn4rSJKb8SEv12WHH7vxQOSvQcL2hX1ZBdAi2Pt4g/0fjY0hWMZIeJs7JIKZL08/x5Zan0I4UZ3GgMQTTFk/V9vaUwbZc7zakAy9aB+ijAoVJTZgeEekbXF5jec8Dm+h1AQNLrCB4QH6JRW3VEK9DvgItFhX+mCRjzFfdQhkPQ==
Received: from DS7PR06CA0034.namprd06.prod.outlook.com (2603:10b6:8:54::18) by
 IA0PR12MB7601.namprd12.prod.outlook.com (2603:10b6:208:43b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.22; Wed, 15 Feb
 2023 12:17:38 +0000
Received: from DS1PEPF0000B078.namprd05.prod.outlook.com
 (2603:10b6:8:54:cafe::d0) by DS7PR06CA0034.outlook.office365.com
 (2603:10b6:8:54::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Wed, 15 Feb 2023 12:17:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000B078.mail.protection.outlook.com (10.167.17.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.8 via Frontend Transport; Wed, 15 Feb 2023 12:17:37 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 04:17:29 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 04:17:29 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Wed, 15 Feb
 2023 04:17:27 -0800
From:   Gal Pressman <gal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 2/2] skbuff: Add likely to skb pointer in build_skb()
Date:   Wed, 15 Feb 2023 14:17:07 +0200
Message-ID: <20230215121707.1936762-3-gal@nvidia.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230215121707.1936762-1-gal@nvidia.com>
References: <20230215121707.1936762-1-gal@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B078:EE_|IA0PR12MB7601:EE_
X-MS-Office365-Filtering-Correlation-Id: 97641193-69cf-4c46-4d01-08db0f4ea0a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FlwkUnH0wk1lgRhoNmTpZyxRmzm7S3M2wh0IzvhbOAYQ9EGAOGldqH3/MEyOXqn2d6rgdYkjKRNCxtZ9hlMoII6zmLVV26x9zicYSE6htbNRULaz+oXEHHEhXCQRgWzTEz/K9p24DK0skerNQ9hwYcVqNTJjrPQviwMvpeFwL3WAVxZr5N58n5sdjtEqRutqWzjwu4DET1Oq4RPbx/+MDEFqXNcaha7gmio+lZHnsIlwRG3Rj5FzvZ69ccUIlpgmWMdefwzorHRWFcKGBpGi+SLmRLv32IMsNYZXOsE02GnxhEbpfSREYoyTdPWYnlgn/da5Ysj1LcelQMYPxm5/3LwTeB9A5MfEbuA7dVx41XsYGit+QDQBtIF8yHDOkmheubRASizECIkwO+EvZyjXgtPyixgOPolsNKx5rX0ceG7SAWT+RfBf8W9QioG/ZNCnhJ76AWJkNsnSqr1F+/Qg8Ew6ip4/cDUXzuovTmzRmLJTPCpV7q5tGUhFXmH3WGRYq9B+My+fXofmEfYxqcgEahXs7/pvZKQVlyeWPiHxQfeFfM7TvWdUtMuiPRL4fgNyBVy8M6xwc60jFqrdjw+EytXLC+F54A8uqlmlP5K4XLfmEP5Dk+x/Qg2AkpIAaGJy6QhJkdo9tQCijMzbaHNd2lOK2HZhg8oaJy6qT/wpFWEkYyVVKWfInH3Vz1aqnPAQgrinwpOz1yY7HtXCFXDZSg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(396003)(136003)(376002)(451199018)(40470700004)(36840700001)(46966006)(6666004)(26005)(186003)(1076003)(336012)(47076005)(426003)(478600001)(7696005)(2616005)(82740400003)(86362001)(356005)(107886003)(83380400001)(7636003)(4326008)(36860700001)(40480700001)(5660300002)(36756003)(2906002)(4744005)(70206006)(8936002)(8676002)(110136005)(40460700003)(41300700001)(316002)(54906003)(82310400005)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 12:17:37.8482
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97641193-69cf-4c46-4d01-08db0f4ea0a4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B078.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7601
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similarly to napi_build_skb(), it is likely the skb allocation in
build_skb() succeeded.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 069604b9ff9d..3aa9687d7546 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -420,7 +420,7 @@ struct sk_buff *build_skb(void *data, unsigned int frag_size)
 {
 	struct sk_buff *skb = __build_skb(data, frag_size);
 
-	if (skb && frag_size) {
+	if (likely(skb) && frag_size) {
 		skb->head_frag = 1;
 		skb_propagate_pfmemalloc(virt_to_head_page(data), skb);
 	}
-- 
2.39.0

