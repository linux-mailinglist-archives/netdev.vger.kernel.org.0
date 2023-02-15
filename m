Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E49697B98
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 13:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbjBOMRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 07:17:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233588AbjBOMRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 07:17:36 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2047.outbound.protection.outlook.com [40.107.96.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822A69EF3
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 04:17:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MEAAkxU80mlwb2/VVamfCxhyllpjVXFlI0Rzn8lrXQXtpPvyBnhFG0ZJh1pHXyrxbbvu04lQDP2xWRiKaUgb8PR12839yVTEGK3DNZfKzmLlTKpyni1HbZsG03iNuJLEZ4sM9vntVIb7fsyxh8y+8rtFLh1PT8RbGirKJeNcz8nsiq9wj8tkMAnZycirth6cod3KITxeBGgE/s4UFE4Zn+00Au3RFtN858XdYhfBLupBJUwf3ArYZS3YzKCYSJflGa4gb+NgKygl07dFP0O3sA9x/WNGfjdoKGzfqjPxSCOGBc0FEZJBURwcfe5eVCj2ZkUnOHwNPfe8Y0AkDFgJSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cMtUoHYCHzcDwTsOliInrJB5GYXZphDeMNGQxWUYhvE=;
 b=ldrbLgh+EKnq1sGJd9/IMfG38x4rXZ10xUQ+yZZ0ea6rWdS/2WsoPsKRDbiYX+zC/CPhWJSi+TpH65ZIRu026n43HK2n1EnWcJP7Gil+pQTs+kTqrpybhHpc0BLjPmygIpKZCJu9VXupN2hD3dVhThiNqdxGVu+1fNzspTi5A5zZeMtjfNIi0dolCzy9z5gm/ovIBosWtByoWeEELJym2qY50NH0DhmDXbjeH/IAZOGDbePbXATNUf1HldrRTj5StErEASlwpEAN8dnzkjZ+FiXrjRcAXoA2N7VmZOmKFCeKnVUl03qHQChmQXYMWG1D06Z5by4Ujp4oN1asTRDHow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cMtUoHYCHzcDwTsOliInrJB5GYXZphDeMNGQxWUYhvE=;
 b=jKkxoIwzBizVOxcgGEhQxVMw19hZyikMf9oUbdDdDPhRZ5CV7AjQ+9LB/dvlTY0Kg6El8R1BvvCUUmdU3CASlUofQMOQR+1HO1TlAF/X0eoayjae34gwp8gO91jZg9t51c4YwJACPyvb0Chkj+0n2VNE3TvItMk+eImRw8s3CapNGlv+9m4SwMypqCOUZg28V3QL3jEPU69gELYGvmTyP5TWsLGMc4P48OrQxSs3eXq1nkFDFOsHtF+uKFhtI4flth9SsIdDmLWBod2E6jioZhp4eKtZODqIX2XSqTrKOY7xG4SMHnBoWgJ50ylJbvohY0yvOxgihN5jvkaPuqmdgA==
Received: from DM6PR06CA0101.namprd06.prod.outlook.com (2603:10b6:5:336::34)
 by CH0PR12MB5089.namprd12.prod.outlook.com (2603:10b6:610:bc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 12:17:34 +0000
Received: from DS1PEPF0000B07A.namprd05.prod.outlook.com
 (2603:10b6:5:336:cafe::2) by DM6PR06CA0101.outlook.office365.com
 (2603:10b6:5:336::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Wed, 15 Feb 2023 12:17:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000B07A.mail.protection.outlook.com (10.167.17.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.8 via Frontend Transport; Wed, 15 Feb 2023 12:17:33 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 04:17:21 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 04:17:21 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Wed, 15 Feb
 2023 04:17:19 -0800
From:   Gal Pressman <gal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 1/2] skbuff: Replace open-coded skb_propagate_pfmemalloc()s
Date:   Wed, 15 Feb 2023 14:17:06 +0200
Message-ID: <20230215121707.1936762-2-gal@nvidia.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230215121707.1936762-1-gal@nvidia.com>
References: <20230215121707.1936762-1-gal@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B07A:EE_|CH0PR12MB5089:EE_
X-MS-Office365-Filtering-Correlation-Id: 3976a084-73bb-435c-c9ad-08db0f4e9e3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0WDLcj+absaQ5bZzVd/UG9NT6gz6yLzBELwUtnDsi27CKinHTUV98ZDYr1WtDmNdUWj0Tyc88q8JkGCZ6dAgn8Mq1jTytlKUQyqssUqJOFcDjNMpAfNJrXZb/mgOoM1/npddIpI5lDkXohIXUjycR2f2Tqk8M0ph/lDPB2m5EASjxPGTMjtMrEh9BuVMGYw2tulGLoya4h48gytIroQtkZiecQeT4/bFsLB3Dr3x/5clGpE8Wfs3q/vt73s13eyxwqVGQZuGpBskCZTKEryAPt6AxJfjEygvxoOKwUF6cFWzp2nOvWFeILp59B6NoS+OZunVMMK7KXpmk1P6NS0m1KOwGROK1N3G1fyoI7PHNipe9tTOvSbxAL39VwWD0Gy+/WhJhwZMosnBSo8+PKXqKnTfQzFUmzj5XZXINiBmdCSfa4Ew3DnJtjBwaRPUWifH3e/nRY4i5A5i0bFmTW0PQreDJBK3yslZXhQRVmcpyfolDZtxGYz3p9JChHOTmDbONhDAwwxqM296GuDIg0Jg68J27mDac64e3Ke7HzqaOVPtMg1voV28TBwL5pfMxXUtjkTbAaiEoBh4cEhgXMv2CpcyM+kaNF0KQVFKYooazpEzcrxfoTENz8RGa5jKg0tx5Y09VQlJEPRMDiCv84ZdcQvmKmPK0kyeK1qnXt1Sx64+NWK/QvZCp7cOjv45z4PtZgIQeENFlACkNef8VCSp8A==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(39860400002)(396003)(451199018)(36840700001)(46966006)(40470700004)(82310400005)(47076005)(36756003)(1076003)(40460700003)(40480700001)(86362001)(7636003)(186003)(36860700001)(82740400003)(2616005)(336012)(356005)(426003)(83380400001)(26005)(54906003)(478600001)(107886003)(6666004)(316002)(7696005)(110136005)(8676002)(4326008)(70586007)(41300700001)(4744005)(70206006)(8936002)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 12:17:33.8340
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3976a084-73bb-435c-c9ad-08db0f4e9e3f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B07A.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5089
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use skb_propagate_pfmemalloc() in build_skb()/build_skb_around() instead
of open-coding it.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
---
 net/core/skbuff.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 13ea10cf8544..069604b9ff9d 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -422,8 +422,7 @@ struct sk_buff *build_skb(void *data, unsigned int frag_size)
 
 	if (skb && frag_size) {
 		skb->head_frag = 1;
-		if (page_is_pfmemalloc(virt_to_head_page(data)))
-			skb->pfmemalloc = 1;
+		skb_propagate_pfmemalloc(virt_to_head_page(data), skb);
 	}
 	return skb;
 }
@@ -445,8 +444,7 @@ struct sk_buff *build_skb_around(struct sk_buff *skb,
 
 	if (frag_size) {
 		skb->head_frag = 1;
-		if (page_is_pfmemalloc(virt_to_head_page(data)))
-			skb->pfmemalloc = 1;
+		skb_propagate_pfmemalloc(virt_to_head_page(data), skb);
 	}
 	return skb;
 }
-- 
2.39.0

