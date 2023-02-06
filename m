Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94C468C7E5
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 21:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjBFUrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 15:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjBFUrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 15:47:53 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2086.outbound.protection.outlook.com [40.107.244.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71AFD8681
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 12:47:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dMewl+yVTYnNKsQjshSTJ+1oYKbY8GIOzAayqVzlm/kxqeVLcaSrY/4pUO0cO6tRx3y5UihXkpnZJle5i7LOfzqlzu1lsDazJBl42+11xyR6NZufq/RjR9XQkzrI82eMsztIBVwLAfVqFo/FKdG3Bsa3JG6M6pq5ASUKbzoc3et9hB8vhWAHjcxXAUoC53lmM+lewnGhVIo+/J4lTOVUf1rilXUCaKDHjUQqlMw5x/B25Z/HJtjlIayRBi9vUF9Jzm4/YmYlsd0AczCmawT9Fg94LmIqAy1ihB5BlpLklE03ht5h5/1k+fOgOaQZ+uED4Nd2U7WClR+bZRErCWEVZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SGVD5D7b6XsFPDp6wwb375J8s9JOly/Kp51Xc249Atk=;
 b=IK6K87EE8D5DngjH7bhRKFYEDizFYFwCcquuVq9yIyprt90QjMnKhWDAD/AzQa5ST2xHy2GpATdxdN2UW1SUemvCPrRcRtOaymJdqTKizuBo4E52NqF/6bJANKCu+UAs7VsiamHIgmLHUrs2U8DxeGZi9VGLTrRMvThcvq/94oclqDWVFa7jcw7mmoQjQkgr2wZBG7RyQP3XHynFNxC72fRnKKE3+LdYPc2/P2CKNJp3KmgoLLhO/NZ3KyrhC6f+sq9ZZm00y4FHzDmodKN9mIuYoRwpj3YzcTTtDa0+QaDucwLCvrylzkWu003qfHEfmt6fftn8CwQFHBCiBhWexg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SGVD5D7b6XsFPDp6wwb375J8s9JOly/Kp51Xc249Atk=;
 b=HIkMKO9oQfJZ9xXnuvzMLAbMSwwzSnrxc4rtaB4+HxrWvoVEZ1CzjWY9udlmUd7PyQxl7N7amVzaP/v4esbc6qzh5blvczRKASxdofT2IjnWUci1ad/QNTLP5jj2B7WxSef+TsR3O+M7P3clTJUYZCg+m8uNxUhBtUEljl3m9z6H5lFjgNbMPJDBSgvIpyHA4aDNjyiDS6FUCYX4TkRdzYw3gl+Bem5SfL/IQs+fT1w/34O4GkSrKkMjAkQ/nQGmp0RrVO5swaydOPrAqU1V2r/obegYg/u50e0JvRUuZYUU2nhahAQSikchLlZdNvhfwvAJTQu9+/KDUp1rcrva/A==
Received: from DS7PR03CA0206.namprd03.prod.outlook.com (2603:10b6:5:3b6::31)
 by BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 20:47:48 +0000
Received: from DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b6:cafe::e5) by DS7PR03CA0206.outlook.office365.com
 (2603:10b6:5:3b6::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Mon, 6 Feb 2023 20:47:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT009.mail.protection.outlook.com (10.13.173.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34 via Frontend Transport; Mon, 6 Feb 2023 20:47:48 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 12:47:37 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 12:47:36 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Mon, 6 Feb
 2023 12:47:33 -0800
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "John Crispin" <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>
CC:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net: ethernet: mtk_eth_soc: fix wrong parameters order in __xdp_rxq_info_reg()
Date:   Mon, 6 Feb 2023 22:47:03 +0200
Message-ID: <20230206204703.904533-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT009:EE_|BN9PR12MB5259:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ada6e6b-6036-42af-970d-08db08836810
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jznhxGzqjyrgLMgePTN4LUMLKp+5CSB0ms09z5XV3E1lsBnX2GDDrhbn8Cw9jXnnMz3N2NYkvmgxHSutrQo6ifhtT5X+S74vePqFnsmtRE76+X3OQ0pKa/NYuTV7oit1lNhNRzXZgE9CGvC5Kxt/UDHSFQyxfzrdEqWQDzmC1JO/GRHKeJPBKHaSxOaqEup5pz4eb5P3k5Az+Ewq9x3I7BMICovQq3wSaqRo0eUmeLQpYFfl3nvY7LLqchgkpzFOkK8x9j1e7lTNOQerbhL5ERq+j1iJkz34YUqCrnkI+ZJM3yrk56HWBgOz1o8wyTfl5gC7fmHFhLjCXdJxqcRyDPYlT1P7rPCFOn7ShEQBrOOc+A0LZ7eLaXWKvmEAifX6rCQlzAf0X3PwcihgSdtwOskbdwheUOkQe2MsdFS7+kDnF2QlAEST34gHhLfM9vVrNZw/r6iWc48c+dUBJNBw2hIo9PHH+Os182cXg61aIO0fSdSgheJnU+M/fhCIYRwnU6bHwwTr9As9zu9DYHuENw+XG9r5AIZze42uQlEqCgZa+ALCiKieYjc38h+G/cFx452BsAxGqWRCd7Z1jd/7hNX9fvX3R5mNi0OXR86NlUdB7KdOjwLjvyohaKyUYz4mZzEGUp9jG7sGteEA1MgXpVX1QbW9hlwv4v4dHHgOcUlCYQx8CnV9mdU1frHB2JyUwhaenVGPfmTgCBcbE3c4Sw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(376002)(39860400002)(346002)(451199018)(46966006)(40470700004)(36840700001)(40460700003)(36756003)(7696005)(54906003)(316002)(6666004)(110136005)(8676002)(478600001)(7416002)(1076003)(4744005)(5660300002)(2906002)(70206006)(70586007)(41300700001)(4326008)(8936002)(107886003)(82740400003)(7636003)(26005)(36860700001)(356005)(86362001)(40480700001)(186003)(336012)(83380400001)(426003)(2616005)(82310400005)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 20:47:48.1150
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ada6e6b-6036-42af-970d-08db08836810
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5259
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Parameters 'queue_index' and 'napi_id' are passed in a swapped order.
Fix it here.

Fixes: 23233e577ef9 ("net: ethernet: mtk_eth_soc: rely on page_pool for single page buffers")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index d56eda6397a4..fa2fa170dcb9 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1570,8 +1570,8 @@ static struct page_pool *mtk_create_page_pool(struct mtk_eth *eth,
 	if (IS_ERR(pp))
 		return pp;
 
-	err = __xdp_rxq_info_reg(xdp_q, &eth->dummy_dev, eth->rx_napi.napi_id,
-				 id, PAGE_SIZE);
+	err = __xdp_rxq_info_reg(xdp_q, &eth->dummy_dev, id,
+				 eth->rx_napi.napi_id, PAGE_SIZE);
 	if (err < 0)
 		goto err_free_pp;
 
-- 
2.34.1

