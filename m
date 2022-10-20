Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67C0605780
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 08:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiJTGn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 02:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiJTGnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 02:43:24 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E61F1BFBAA
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 23:43:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JBk7N+dDwlpSjEl85fkSU40wIujhvywlRL0lxwA6k+VMSdyaUO+ehN2Vwyb6dN/Ns7CP2kf/TcsBaRPmi/W/rFL3yTPJLPUeWGA9QpNJThuNlMr5DpGByaUUDhXtvcyxn+IGUh6GehMFXmZTfSWCxIkUGkN6bJckqrlT3mH6M+jzp9nwD34h8dCbDgnrh2zauvg8BvND+UVrZhccS5K7aLNF4gtvvEJFG65j3CK4YcuaVHQvs45MUXmpgSBqREpoguQPdhAC80iyCgJIclpvxu9qBkp0y7uZiP/IsQifNkUwYElyAZ6MnK1XBMbUxtgGvTYRIQBtY+pJXaDFIbsxXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jM8SpFAi172q98LtoWEDFoSgnLEfEL9H0rLK3TqQAqA=;
 b=ZgO7tHtYBvvNyyontm6stzaBq9Lf6SI9Ne5hGt9rsoShuDKeXJHHD1dJEpzNvu0z4n4qfNZZ2HAbEQIhosuCiP+MjdTNFMWUN2tgkrZGhZ8smnFPkAMhBQpdzbOwyJy9EmUZAE+4p2G8T4A213tZ50HLX3D65dJyJvSgQWvoJdDoU72tDXFmpM1HiLa/zqR1gieuDkJ+9fSSqVxB9zq5BO6DssU7qlAYC+B/dfuWFzZGDAYdg62fma9Sry5NMqZ9SNqs87EDACwfjFPM6fNkSmNcAs3t6DCz/F/PEiCfQmnCsEOJ7PXzCN/9qmVH25q5/WJzwpZxAAVYRN/Md0Exag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jM8SpFAi172q98LtoWEDFoSgnLEfEL9H0rLK3TqQAqA=;
 b=YyHjUDb+P9Qc1MlEYUleQqHJuNhjw1xd185NJYtdaF9uVRIek7V70KlGof1fbNlXRSH1p8r9Q5lFjua0cwievObY4IF2NOpIecX+L5oDW/w4tkWmNj5oQ1vtVTOWA0m+5JhvGcygZVf8AsKITqmDzIDSwGXlE11HpSQxfkwaCQg=
Received: from DS7PR07CA0001.namprd07.prod.outlook.com (2603:10b6:5:3af::10)
 by DM6PR12MB4154.namprd12.prod.outlook.com (2603:10b6:5:21d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Thu, 20 Oct
 2022 06:43:17 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3af:cafe::b3) by DS7PR07CA0001.outlook.office365.com
 (2603:10b6:5:3af::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34 via Frontend
 Transport; Thu, 20 Oct 2022 06:43:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Thu, 20 Oct 2022 06:43:16 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 20 Oct
 2022 01:43:13 -0500
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <thomas.lendacky@amd.com>, <Shyam-sundar.S-k@amd.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <Rajesh1.Kumar@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>
Subject: [PATCH v3 net 3/5] amd-xgbe: enable PLL_CTL for fixed PHY modes only
Date:   Thu, 20 Oct 2022 12:12:13 +0530
Message-ID: <20221020064215.2341278-4-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221020064215.2341278-1-Raju.Rangoju@amd.com>
References: <20221020064215.2341278-1-Raju.Rangoju@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT038:EE_|DM6PR12MB4154:EE_
X-MS-Office365-Filtering-Correlation-Id: 6188cb4f-cc72-42dc-a0a7-08dab2665e55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n324TD41E975J9az7wPRQWkkn8bR8iJOSmB04BDyOY6F5OsGCcTwqUzBeclIxTYKaCfMua1oDYu4gJSmDgHzIObUL8RhR8FcwkqGeyZ23GOjJqnAqXv2dmGWoEvNjHhUo/2zdVVStaM2ZrFSnssLxBag3PylugUwA4devhXMjrPtScVa7+LqjRjtjo1GzaW9B5eGirIF13l+bpnbRw75OXf9FTSJoc+WHt41zP2hAQV+bqrYUhqhFhqSz7eGgPkI6dTtMiz4F3dhgMxRm56DaN/tbkHFcpWL0Y1QsEgL0QAj2bJmkHNnE7xjE9ZOUeI84+qPl7fSiAv6NRmoeXyZmhXg0Pk6ArbRR7eQbRjGHcCjlj/fDD7Lt6wjLKvBCC5eqhNLVCEzKI33CHYFf0Bg3z4M/TIb2wl2zvv5OHRSpInUU7oa9OCW/Mmks3Ktl2T30LNPRkGh3CuwYaJEiy7LrF8i6vETBFGphLx0RTi2BAd3ecNarPitIMzSxCvWyFTfab3DGVe6468UTTgbNL6MDvJADugLe3UMBrblsZsf0h5BwvfeFNbmzMwjCe8KieDZzzc+Bq/Y0g0T0b6avi9cwOugLMukBVj/rtHxT2wdKHz1n70qNfVq4IEseM36pLqdBobU8V50SATISxTr0b6K/O+AzXmxyynbDqDJSIeKdEkA9J+/V3BLDFeAui1Eu7WP/4DJx0HgZrUz5g0jQ0sV2Wr6bjLM2RyGimF0bVnU9vNo7K26/AVAx2bA21aK4nKU+NnhWlnX7m8zLmd/E62Jy6BXveLLHM0B/Qgmh0i73ImBa0WFs4im9sx7YRwl9N3Y
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(136003)(376002)(451199015)(36840700001)(46966006)(40470700004)(336012)(16526019)(186003)(2616005)(426003)(40480700001)(2906002)(1076003)(81166007)(356005)(36756003)(86362001)(40460700003)(82740400003)(82310400005)(83380400001)(47076005)(7696005)(36860700001)(26005)(70206006)(70586007)(316002)(41300700001)(8676002)(4326008)(478600001)(110136005)(54906003)(8936002)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 06:43:16.3862
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6188cb4f-cc72-42dc-a0a7-08dab2665e55
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4154
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PLL control setting(RRC) is needed only in fixed PHY configuration to
fix the peer-peer issues. Without the PLL control setting, the link up
takes longer time in a fixed phy configuration.

Driver implements SW RRC for Autoneg On configuration, hence PLL control
setting (RRC) is not needed for AN On configuration, and can be skipped.

Also, PLL re-initialization is not needed for PHY Power Off and RRC
commands. Otherwise, they lead to mailbox errors. Added the changes
accordingly.

Fixes: daf182d360e5 ("net: amd-xgbe: Toggle PLL settings during rate change")
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
---
Changes since v2:
 - update the POWER_OFF and RRC enumerations
 - updated the commit message to use RRC instead of RRCM

Changes since v1:
- used enums for all mailxbox command and subcommands, pre-patch to this
  contains the enum updates
- updated the comment section to include RRC command
- updated the commit message to use RRC instead of RRCM

 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 8cf5d81fca36..349ba0dc1fa2 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -1979,6 +1979,10 @@ static void xgbe_phy_rx_reset(struct xgbe_prv_data *pdata)
 
 static void xgbe_phy_pll_ctrl(struct xgbe_prv_data *pdata, bool enable)
 {
+	/* PLL_CTRL feature needs to be enabled for fixed PHY modes (Non-Autoneg) only */
+	if (pdata->phy.autoneg != AUTONEG_DISABLE)
+		return;
+
 	XMDIO_WRITE_BITS(pdata, MDIO_MMD_PMAPMD, MDIO_VEND2_PMA_MISC_CTRL0,
 			 XGBE_PMA_PLL_CTRL_MASK,
 			 enable ? XGBE_PMA_PLL_CTRL_ENABLE
@@ -2029,8 +2033,10 @@ static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
 	xgbe_phy_rx_reset(pdata);
 
 reenable_pll:
-	/* Enable PLL re-initialization */
-	xgbe_phy_pll_ctrl(pdata, true);
+	/* Enable PLL re-initialization, not needed for PHY Power Off and RRC cmds */
+	if (cmd != XGBE_MB_CMD_POWER_OFF &&
+	    cmd != XGBE_MB_CMD_RRC)
+		xgbe_phy_pll_ctrl(pdata, true);
 }
 
 static void xgbe_phy_rrc(struct xgbe_prv_data *pdata)
-- 
2.25.1

