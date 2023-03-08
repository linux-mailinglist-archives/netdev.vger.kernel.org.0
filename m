Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 136726B0889
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 14:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbjCHNWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 08:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbjCHNVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 08:21:42 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2043.outbound.protection.outlook.com [40.107.244.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2D613DC3
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 05:17:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ji1lZtHtI3ZRaFWbQsC5VUpYQ1uNkCOrOUtO5AclsffLSQV3bCjYhW5KspHqL044f8TxrrIY/vaScxCb079sA7SFltTU5PpJk2Q44z0I3qO++WiW9+oBLrZLKid/wHIdYGX16nbIsdzH4yIOKb2ctIIzy+YgEznqe5hQg2Km1IgUdgcr0XMoU5OLkVG2PIA92O3WgXSuCWfMhi0KwSCJ6bdg2ufMh1VhCp7AjiGrck3FqT959pLo9NHC77WdIv/klkKw+tzCiufAFZaQa3pYZ2xDwTXNBUWc6WnQaYzJEbuEBsjp7JBEHQNjQxlIOJAbzozWoDHt3lyD2IyNzFqt9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=icJVeZjoUz/yDW2sSE7+pGoFOhel9IVL4Xk/O9lfBxo=;
 b=CANVv3jOmY0ND61xOTRlKbmcQaKlqbLBvNYMGAKUDG2vkQwr4DgTF/wmIHfxN4JXu1oR7PLdmDoQ8Yq+J+Wr6EXmzuEdtHNyelaP8qp4N98CeXWInmXhCqoOZt/e9FsVJH/PpQZ8ubqwKyftaF2VOoTul0FlnD7yyI+JG3fM6vVeyzJHMN+jgJV506dGted+7xE53i/r+EjgW10RrjNenxBbkJhe6+2iDOJRRxS0I2XfM1VtfJd0nsDmUEnwlxzvFxxskWGgRA1bhtEH1n2zSSqqGYBBeoRltFcFl7Ly6gf8LfUMdaHuZUjhu1dXKNudEPiq8iJHc7Sguv13SBhxEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=icJVeZjoUz/yDW2sSE7+pGoFOhel9IVL4Xk/O9lfBxo=;
 b=D7Re2MDrLbAoKrfOiLGgkoYdSIdARfs3IXqj7TyllPzAW3YNZjGHkqCrEgaULFVkqnM3019X6/b4xqGYZWTIKPs9cMU6G2xJ/KnFA3qyFfvi2ZvAQf/tITwINEXVnZovy6yl3LQA5JG5OnKszBJsbkrdmO8QAOwUo1Neb5/cP6lHc5U83/lNscYE3AxvAED2DrZARF0px/EN/DUWjG481voW36BE0DfIcA1f2FZPXqJf3Z6BDtiprv492bhkGihfh4Ofmw4Xm6u7aw11z+3WLfX/WPyPHV/AZGwlAMihQ0YKXJH4yl4s7Qzif5rYBQKqSP9WTwItqg9I7LKeD32VNw==
Received: from CYZPR20CA0013.namprd20.prod.outlook.com (2603:10b6:930:a2::13)
 by SA1PR12MB6947.namprd12.prod.outlook.com (2603:10b6:806:24e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 13:17:17 +0000
Received: from CY4PEPF0000C97F.namprd02.prod.outlook.com
 (2603:10b6:930:a2:cafe::75) by CYZPR20CA0013.outlook.office365.com
 (2603:10b6:930:a2::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17 via Frontend
 Transport; Wed, 8 Mar 2023 13:17:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000C97F.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.13 via Frontend Transport; Wed, 8 Mar 2023 13:17:16 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 8 Mar 2023
 05:17:05 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Wed, 8 Mar 2023 05:17:04 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.5 via Frontend
 Transport; Wed, 8 Mar 2023 05:17:03 -0800
From:   Gal Pressman <gal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next v2 1/2] skbuff: Replace open-coded skb_propagate_pfmemalloc()s
Date:   Wed, 8 Mar 2023 15:17:19 +0200
Message-ID: <20230308131720.2103611-2-gal@nvidia.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230308131720.2103611-1-gal@nvidia.com>
References: <20230308131720.2103611-1-gal@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C97F:EE_|SA1PR12MB6947:EE_
X-MS-Office365-Filtering-Correlation-Id: b5415cf3-b255-48d6-8450-08db1fd7707a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IL3vZIIwqhw/u4gxWwzMxfwE6w4EUuaEHu9o7zEncJ50ge/20i9yJ6eHXE6JCxLNrBlPyKroevOlC7QNL4pSey23rmjlohhkN0z26Wsct463xeMpAWQBer5IJjQs67C5Roz2siZZwfHzoJAlyPIyb8IaG8qZ0WN4/xx4oKcDSZ4Xe8L4Q6lCLw3KRgIy5QP+tUL62URFbaXnasXesOBjuTlKNb8LHJzM10PUQFGz+vKl2ecPuez/h0GjO2AwdeDZcSjZ0bx/QDoy5LFnZAPvc7hzGSsehLGl+nvcmCyAjXosSSIcsx2raXBVSuYLFYbO4+4doJ6eVX/rZ4oSXk+DNVFk5LYq+nCqFOKiG7zFEhnVuHI4T3T4SjNUzLO6/a+kZGdPQ5gLjrB8UBo0ppnMLhSGLqamj/8pnKoYACMCDOxyD5yLdZGqe0ct/wkQn454TE/yHuuak560fW8bAlcX4fnauj0Dc1PmxqnK9eSdQujkl6DaQhvU127ggkYatgHrpIw0XFxmfGO71ore+uO9sNhZu45+5o51BTShWKx5zObF0Tdpt0Rq2KAPQzt4J+5GUJ/Iy3Oyltx9Nv0ydvG+Ziyj11Lsg4HTiViZ0GkC4odNUE/bwUyYhHgg7TjmFHSd09bUTIbVl1rRyBuZZaL/ecpBOGurzgMgP/Pq+2zhaGC5w6eGeyDIeVPosHZQFRUndvhueLatsMJ9tZ18M4V7zQ==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(136003)(396003)(346002)(451199018)(46966006)(36840700001)(40470700004)(1076003)(26005)(110136005)(54906003)(40480700001)(36860700001)(478600001)(5660300002)(336012)(36756003)(40460700003)(107886003)(6666004)(4744005)(86362001)(7636003)(8936002)(356005)(7696005)(82310400005)(2906002)(70586007)(70206006)(8676002)(4326008)(426003)(47076005)(186003)(316002)(83380400001)(2616005)(41300700001)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 13:17:16.7626
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5415cf3-b255-48d6-8450-08db1fd7707a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C97F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6947
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
index eb7d33b41e71..5c1a65cc2f39 100644
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
2.39.1

