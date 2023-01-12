Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02FF1668479
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 21:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240688AbjALUx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 15:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240172AbjALUwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 15:52:55 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4122C1006C
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 12:26:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h3BAzZWng9wZehsg3iMozDmVcT9fgmJHN+lIOInb8el6K1Zhx9WpJtYzJthwTl6RARsCw1KWSKLmvliHJKREbSm/uAWLbsIt0vWzQsfINwV4lNA/rFWfX2nP1Mw5RYj9Pymr1BeGA6yUeVtZpIIT0arxAtjS6hHcQgVF0x97XWzQOmh5TQMWCUUazhPLElmGTWRgxYDayJSgeg5nrvu0oPFKk08qzOwaUOcUX47LsF/wVCj5Y2uDzDTNVKZT3XcJbyevEvbz+RfbUGDokEEdVH6usjj25mjcxAYULyxoLQPsLxNGgym4okgRvFfRuJVpGA12TedrsDDNn6UUMPdS6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rsl9Qj0utKnVp1CyOm+REWQcq+jh95nXMmKk3SMSS4U=;
 b=AhFvkiAP569QfYggmlKipM/SLox2aKTxgB9W2NBH+tt/eNhNj+2//wxWuKQ3lOG3jQTPwjxUkMKwWY1WyKs/8hs2AyejS6V04QI02El3He/oeNH4GgOcDrbCkAkZK/iUSD3ECdYw98VacNcmrXpnswjKrUqxXAsEItqfucgTBSaQHMHwSmOMQqayDT20hPUEhvnUsr0o/uBHHaxctIJu3RLFyI9yF+pSQ0IYFSwAPTVsMVw0tOiTOkgkO+Pa5740huDQf56QetiYyiLihXO9EXM5ZTdPkqGN+s5V1JuTZ1f7BuRXkX9uBy57zJ09ogZIgVDARmifap8m0lLWNxrFjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rsl9Qj0utKnVp1CyOm+REWQcq+jh95nXMmKk3SMSS4U=;
 b=jQTr6dzaRfsx6bsDs2Dpz40a0DOdQPAGzqzjERuJBSKPoGRoTcc0cQpI4SPyiGt30pXDW1R7iJ1fmcxyyVBjqzKwQIMXBxTF5/8VC3By//R6E3EJDDWfP+LOZIEDTnHPHOZ6i/+80Js5Cj1b3zegcPcHJHDO8z4nppMywO9EdsvisDi2sWw9TUBDAJeCwMk00cBQMvP3L2ATSi7A5zN9oF70OTVLvF4zxeGeUE0h/uf3HcAiScuPtdT6Ep+dQrTnEAqULIG+l5Qf9WV51E+M5b7ixMbB1KGnoGBmEm4QKfduuwJNEVuzx5eA4ShEpJBTYwF9ayBgkQY6u9+1CyXdpQ==
Received: from DM6PR03CA0047.namprd03.prod.outlook.com (2603:10b6:5:100::24)
 by DS7PR12MB8081.namprd12.prod.outlook.com (2603:10b6:8:e6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 12 Jan
 2023 20:26:33 +0000
Received: from DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:100:cafe::73) by DM6PR03CA0047.outlook.office365.com
 (2603:10b6:5:100::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13 via Frontend
 Transport; Thu, 12 Jan 2023 20:26:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT096.mail.protection.outlook.com (10.13.173.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Thu, 12 Jan 2023 20:26:33 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 12 Jan
 2023 12:26:28 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 12 Jan 2023 12:26:27 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 12 Jan 2023 12:26:26 -0800
From:   David Thompson <davthompson@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <cai.huoqing@linux.dev>, <brgl@bgdev.pl>,
        <limings@nvidia.com>, <chenhao288@hisilicon.com>,
        <huangguangbin2@huawei.com>,
        David Thompson <davthompson@nvidia.com>,
        "Asmaa Mnebhi" <asmaa@nvidia.com>
Subject: [PATCH net-next v3 3/4] mlxbf_gige: add "set_link_ksettings" ethtool callback
Date:   Thu, 12 Jan 2023 15:26:08 -0500
Message-ID: <20230112202609.21331-4-davthompson@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230112202609.21331-1-davthompson@nvidia.com>
References: <20230112202609.21331-1-davthompson@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT096:EE_|DS7PR12MB8081:EE_
X-MS-Office365-Filtering-Correlation-Id: cee6d7fc-dc39-4554-7ee8-08daf4db4be2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FlC2gFqaYDUM+E2jX0T5fuaHVlVVYDhvDKjFdBk85MQz9xULBqDV0+ak3SHPyrr3jhlNDhsB2n9fz8mz/Rk3Y0mciIdHgqLGGA+8i7yWbcFuiTJoFgo1a+ruuiruV27XIADyABZ5Xb/bXR/P3DfqJzoXPdTSUeo1eXc0wkcms3fZ+k+NFbxp7PhAJMhVyX+NCzVzFZXPC8N/ey30DrbN6jNUe5Tk4NvbgawLurZslsWJqR8/G7QfBK2Nhj6DlPnENELOligczuwYhGX9VI6+ytR5afkSpklCDVGh0ciJLlpds6BdU3J+UAqyPlCkDE1tYyYRiNHWMiAaK3Kiq2N0G8JQTbSfZE6174T2Ow+vzqnaturpmva5XUWjpX8WXaHv2z1PYY/W61bB2MGHUde88IeLEedn6EV8HcUTEo3hyxWGAbEC82rueSUIh535jh30nH19qU3GXOcg3hhjky9Qm9LDo9YMkORbs09VSwGvOo/m6bA3KAPpXuo2K3R56xLw7QtEk/55vi1AmSkwfLGb5JPf+/q28oi9jqUnFhQ7cTEox75EYlsrLA7vsT2qiph7W5og7dUe7J9o5K26mwWq2i1Xcn+BlQePU3iWSw+E7Bkmx0okxrmEgHkJVD7p9wScnnWIK5yjgWwYyNuBYq8yFbg90d9gqHJ5qzu916dDslvREIZ2dH76HkzCYx8R/wWXO8ETOUo//iLJFPUoV/sj0Q==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(396003)(376002)(451199015)(40470700004)(36840700001)(46966006)(47076005)(36860700001)(426003)(82740400003)(7636003)(2906002)(8936002)(82310400005)(5660300002)(41300700001)(356005)(6666004)(40480700001)(478600001)(1076003)(316002)(8676002)(107886003)(186003)(40460700003)(2616005)(336012)(26005)(4326008)(86362001)(54906003)(70206006)(110136005)(7696005)(70586007)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 20:26:33.3090
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cee6d7fc-dc39-4554-7ee8-08daf4db4be2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8081
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends the "ethtool_ops" data structure to
include the "set_link_ksettings" callback. This change
enables configuration of the various interface speeds
that the BlueField-3 supports (10Mbps, 100Mbps, and 1Gbps).

Signed-off-by: David Thompson <davthompson@nvidia.com>
Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
index 41ebef25a930..253d7ad9b809 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
@@ -135,4 +135,5 @@ const struct ethtool_ops mlxbf_gige_ethtool_ops = {
 	.nway_reset		= phy_ethtool_nway_reset,
 	.get_pauseparam		= mlxbf_gige_get_pauseparam,
 	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
+	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
 };
-- 
2.30.1

