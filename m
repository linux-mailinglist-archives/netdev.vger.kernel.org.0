Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D116C5138
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbjCVQvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbjCVQuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:50:50 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2080.outbound.protection.outlook.com [40.107.220.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357415D895
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 09:50:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mA85EdnsfO5U6mDoi17XbocM6xxUysZvNmbHI+8nDYECg8Q6kIwgayRoR8cSonaFMbD6dRhacapE7S5lW0qbcnqaCv8HarA12XicccbPHAXSjCN153jMHZ8p7Rioi8JWFcppYpXjqJ0tmtrF+UxVahg4X2F2Vq0FYxMowikSfiHUjyeakSduEmUwmnqBvTGwRw6wQBraz/dzFWo3hXg/NneMcVcM10gGGuJtycXmICmU33nAoMlXoClW5r1SWkPxLjju2C6hE31S3qY54bWo4QGf/VvyCwa4c9AmuevTwqcqSbRQSisLCSZ+8MXOfYqeylI/ghfhOyYKuNRGh0Vsnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Xb0nkMWPQAMMT1Iqiw3RITXf49jUuUfoDrTkmP7naY=;
 b=DWWHP5FgvDck7zsJ33mXwbkKJd1TBVomwplddAgavgDIZhg4BIViyquY0+QeNqPP/DsVRPPSc0UImzMRWcezvmz82z6a9zqWRQLastHc8zgitv48H0OgbtffZWKskq0aw9f8QPw5jr1NGvZMULAfZPaMrG4+qBegJB1kpmZTNAI2l83/k82smDUlWLRS5P8tXaUCu/PODx52Ms1hVVftD4JfLDMbWUuOvTk9mfZmus6ZtbRF/7gThLt5XwSY0volzTXs/r4dAIotBkWheplCMoABz+YDZ8km8KHBXkEZI9LOMq7Pp3JERGtW1yXe0SXE+w9VasSyMTnDzFmuKLPdRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Xb0nkMWPQAMMT1Iqiw3RITXf49jUuUfoDrTkmP7naY=;
 b=SWPLqq50zf79+bKtxtUvqfI9Dg6/iV7exOHdWzcaa7bknInSmyZa/qjw7YMoJihpm5XCeHrJXC1/7+PcoY5MMZnhyMWJwo2uA4AFQZdTevWHvb1fTx/DajS4tnsPnYj1ZPfL/expp6eZPc9Rp4/w29OTHiynafCe67rNOPUD8GodorSyZFHLWyiuTZw2DE03D+NYEeQL0S4qeMIBH0QC58uP1cyZ19NiXzqHHv50M7RWFtsit9nEbmrlRzBUug+gqanZFiOfbtrPpdToX5ANT9uSS1AEL/5PKpGyrMGBIi+bowJc0/eQt86rEI71CwOs6rcU/3svHLrGS8oxf8WnzA==
Received: from DS7PR07CA0023.namprd07.prod.outlook.com (2603:10b6:5:3af::28)
 by PH7PR12MB7844.namprd12.prod.outlook.com (2603:10b6:510:27b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 16:50:35 +0000
Received: from DS1PEPF0000B076.namprd05.prod.outlook.com
 (2603:10b6:5:3af:cafe::dc) by DS7PR07CA0023.outlook.office365.com
 (2603:10b6:5:3af::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 16:50:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000B076.mail.protection.outlook.com (10.167.17.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Wed, 22 Mar 2023 16:50:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 22 Mar 2023
 09:50:22 -0700
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 22 Mar
 2023 09:50:19 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 3/6] mlxsw: Extend MRSR pack() function to support new commands
Date:   Wed, 22 Mar 2023 17:49:32 +0100
Message-ID: <57356b6bcd2e32661ad7e2bb5b57ce3adf2315eb.1679502371.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1679502371.git.petrm@nvidia.com>
References: <cover.1679502371.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B076:EE_|PH7PR12MB7844:EE_
X-MS-Office365-Filtering-Correlation-Id: a11f957c-b6c1-47ad-b077-08db2af58e6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FmAYHesR2OSNiyZj76iwitfmsGICsmQsZNQjU9L1oMPVR+Vyke2g1ma9r5Q4bqu4N3iTjPHtF/UQ9W9xHGK1N+UNKY6ZGLcRdd/SZk9sWWxOfU7esEHpYhlxfmrq/wLeKtYK17Q+PFM1Hs2dEoz6hWSngP2q8mVynYyidWavZcGSJ/2wXoEbcyUx+JgmMdUU82zzep6PPhWCn5oylwgnJW18O8JA24MbIpTP0KFd71jWvjpRWnKAjdZJVCicE5+GcsCicl7IzumXBHAVUQBiFuCef997tiPz2Xyn2gXPjTY3akaJo7BuAPrXEWH+xUsa0RClQw1dFt2kFFSTDJ09KGLXDI5tg2+SHJzqIdjPojdsLFCU0QZY6wwT1DvbjZjhuO6cDSD9yLZzFbwvhtVjQ8XtoHK50sbIk2b2zY9wgb679h4t8PVOFVbUN04CCRUZY0edsei3Jf57nbe5mL5x5Mfm7VASexEHb1EyzgIry8lpTXKyWhxiaS+k+fvYi/45t3GwaCoA94aeYsjcyTC3iA8OmJI3sSo+DkHCaUOgWHjIa7rdxcGH4+Z+P1xkykjPm4o8wbIHDI1wxbkUc2Kybje/pL9tTnjRSIWL2mpk/LG8lKgzbrysau3wjgr0tSEHXtPZ/kqKJDYGW9GIoLXbCLBLzFqky0Uk6fI0ow8culXVAihFYzaDRJjRrimgEYjfwTg3ZMoGbfBFC2VqTK0Q+2eWw0rcGqiV2HUNbYpiVU0a7cEtKh5FxsOL5CFfv736
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(136003)(376002)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(2906002)(83380400001)(356005)(7636003)(86362001)(107886003)(336012)(40480700001)(186003)(8936002)(6666004)(5660300002)(2616005)(82310400005)(41300700001)(16526019)(40460700003)(26005)(8676002)(478600001)(316002)(36756003)(110136005)(426003)(54906003)(36860700001)(47076005)(4326008)(82740400003)(70586007)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 16:50:34.6622
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a11f957c-b6c1-47ad-b077-08db2af58e6e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B076.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7844
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently mlxsw_reg_mrsr_pack() always sets 'command=1'. As preparation for
support of new reset flow, pass the command as an argument to the
function and add an enum for this field.

For now, always pass 'command=1' to the pack() function.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 14 ++++++++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index c968309657dd..3c6d5f37c743 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1474,7 +1474,7 @@ static int mlxsw_pci_sw_reset(struct mlxsw_pci *mlxsw_pci,
 		return err;
 	}
 
-	mlxsw_reg_mrsr_pack(mrsr_pl);
+	mlxsw_reg_mrsr_pack(mrsr_pl, MLXSW_REG_MRSR_COMMAND_SOFTWARE_RESET);
 	err = mlxsw_reg_write(mlxsw_pci->core, MLXSW_REG(mrsr), mrsr_pl);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index c4446085ebc5..6bf8e4446e7e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -10070,6 +10070,15 @@ mlxsw_reg_mgir_unpack(char *payload, u32 *hw_rev, char *fw_info_psid,
 
 MLXSW_REG_DEFINE(mrsr, MLXSW_REG_MRSR_ID, MLXSW_REG_MRSR_LEN);
 
+enum mlxsw_reg_mrsr_command {
+	/* Switch soft reset, does not reset PCI firmware. */
+	MLXSW_REG_MRSR_COMMAND_SOFTWARE_RESET = 1,
+	/* Reset will be done when PCI link will be disabled.
+	 * This command will reset PCI firmware also.
+	 */
+	MLXSW_REG_MRSR_COMMAND_RESET_AT_PCI_DISABLE = 6,
+};
+
 /* reg_mrsr_command
  * Reset/shutdown command
  * 0 - do nothing
@@ -10078,10 +10087,11 @@ MLXSW_REG_DEFINE(mrsr, MLXSW_REG_MRSR_ID, MLXSW_REG_MRSR_LEN);
  */
 MLXSW_ITEM32(reg, mrsr, command, 0x00, 0, 4);
 
-static inline void mlxsw_reg_mrsr_pack(char *payload)
+static inline void mlxsw_reg_mrsr_pack(char *payload,
+				       enum mlxsw_reg_mrsr_command command)
 {
 	MLXSW_REG_ZERO(mrsr, payload);
-	mlxsw_reg_mrsr_command_set(payload, 1);
+	mlxsw_reg_mrsr_command_set(payload, command);
 }
 
 /* MLCR - Management LED Control Register
-- 
2.39.0

