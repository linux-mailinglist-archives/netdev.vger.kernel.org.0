Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486E6668483
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 21:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240717AbjALUyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 15:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240216AbjALUwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 15:52:55 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2040.outbound.protection.outlook.com [40.107.220.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CF21277C
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 12:26:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6dgAhwL+VPsfZMW1g8/6Iwc5UtB2+QgtC2ppL89n09O/vcxeiLe1aU5ppBS8dVM5vo18I6mA+U2+BvulW0iDYlYQ77H6U6v3JYF1yx06ESHaJZjmLaT//24nAdRxIFsOZLJQ668wBC/HQxDirs6R7uJuN9Rl0CA29bxoFs2ZzBIn0JzfWpQ9Cd3Dm9wNjat8jsKy62truUAmCJJFr9GF5mqLmj2RuXEP6Izndso8pT8Azlm9xL6YxPJPVOYAsK+CHBtxONUEpXDqGaBm2Z7gHtHv5OQM1a6IST2qhjQU5p1PWjfbx/P1gXWwa3ndD6lAZHSIHKFdvOkeO5YqzFp5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jma4LBx0HGUmu0WrqiGuzZM9SiUGSdhCJFATbcwkybk=;
 b=DdsSsy0sVD3qRNrkOH7xv/hHveLYDOVskWiJ21Dza5k21FNEsBEYNQ/kYmKvY+3DPoZm1TqOJTiCJjuaFkNSUXHlC9Ng11hlz6Qgs0MhyF3Bn3wQd2QoSefxNm+G6GFhf/zLtz2syjC/6AQOg+b+0m3oce19/x4SQnPYsFVdu+Z8H6So/e08PTkcysBmXV2Epn214PuR/jjLhJT5Jl90f7HuyIECpHB7N4c8cnQovA80db8ecJrs1W4iwu19bvZhcXfB42R6uyUeMgrpFv42KCn8QuhtHVeYq6vkw5nHq7I3Wtel58vo9jKZcjE7PUHTU+Xy10BeaATbhIPfeThQlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jma4LBx0HGUmu0WrqiGuzZM9SiUGSdhCJFATbcwkybk=;
 b=kbJt4U/cKmyFblmcUPynIjFJGL5mb1/NiJef6UUlt4AtUzEbWFEoi9Fds9F8MrQhiUd2VIeuy8U/mW1DRXgmhOr7YIM0FyDSljxmWTJUui+daeBF2eyhcDgIY5sDkcP2OBIZbevzoa/i7hnN0jzY9CypiQifeyC3vY6YfVRNIkIcHQo7vDHRCNKc8+ZZDQ6tF28m23jdV1K820hNTTpukHFFPY7ybSaZpiQiuGyv0FzWncyLkI9lXDFb0IOTULSpiaMPSVMRFOvzCfYlWIrHSAxFakjU2UB/uZUnMt/RAb/wj4AcBxs2Aqhz5LgNYR2kf4TkCaLwiIPv/vpekCT7oQ==
Received: from BN9P221CA0023.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::11)
 by MW4PR12MB7382.namprd12.prod.outlook.com (2603:10b6:303:22b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 12 Jan
 2023 20:26:40 +0000
Received: from BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10a:cafe::45) by BN9P221CA0023.outlook.office365.com
 (2603:10b6:408:10a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13 via Frontend
 Transport; Thu, 12 Jan 2023 20:26:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN8NAM11FT031.mail.protection.outlook.com (10.13.177.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Thu, 12 Jan 2023 20:26:39 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 12 Jan
 2023 12:26:31 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 12 Jan 2023 12:26:31 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 12 Jan 2023 12:26:30 -0800
From:   David Thompson <davthompson@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <cai.huoqing@linux.dev>, <brgl@bgdev.pl>,
        <limings@nvidia.com>, <chenhao288@hisilicon.com>,
        <huangguangbin2@huawei.com>,
        David Thompson <davthompson@nvidia.com>,
        "Asmaa Mnebhi" <asmaa@nvidia.com>
Subject: [PATCH net-next v3 4/4] mlxbf_gige: fix white space in mlxbf_gige_eth_ioctl
Date:   Thu, 12 Jan 2023 15:26:09 -0500
Message-ID: <20230112202609.21331-5-davthompson@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230112202609.21331-1-davthompson@nvidia.com>
References: <20230112202609.21331-1-davthompson@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT031:EE_|MW4PR12MB7382:EE_
X-MS-Office365-Filtering-Correlation-Id: 32656396-8bdd-499b-d7a3-08daf4db4f99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yFaWfZbm7FQBUd04toqZc46ryiSICqRofW9a9Yv5TJpY9tnNfwFWz7ieQJPFEGEbj0tkm2n9E9zQfo9NN0PqL2g1Mt0cGjuOh/pmsHGBH4v6XuoDWsR5q82G36xYmXNep2SQg4QHjSWQZbC6rbeE/D3j8wWRELhdTDxhnfM0p+fYDr3pE+RqiGcv720eupGc8GGtEfAREyQ6gITavHt790w3+dYp1s1Vk39VD3GFKD/4wiZR3MBmPRzcFjJTkmXnZs2tO659734P5qtiDcfI0ownibVQmnXavq+mbq2lwQTHhkmAtx2xTHCC1zouXF0P4kh+l441bhpLARmw898/WMqpzzHD//RBCNE4vq8PA4u3PQWl6BA8wDAlMRG9ho71YiImbVQZPnSTC2Lt4l0ZZUXxmq6ij04zoXZRHiyml4b+v5UTfJL+SNIgb3Md6Th7IClmWWTQw2FWVozWGcSeFWqt7nTku4zeQnEjIMGafZ/b117bXHvPFfjgIjZEuKB5d7BY3UtYs8vs16ZQMRXLcrj1333DFPlqblU3zc5Tuejn0b6OkFyB7btAO+ZhV9ahwXFuu9ChJMu5EfY8ln7KKjHRFu1wW4cCmSAvyN68pIOfIMDnO+J7oVEv9ln9l7aeWsp3RVjOTiSkEYWLvAm86FWTyskmKyiemK4owZCvP6jcSxsmxBKqoYCNUdRWgebwkN2PBNn+N/QFyLemoGStlQ==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(70206006)(47076005)(40460700003)(41300700001)(40480700001)(426003)(4326008)(1076003)(110136005)(70586007)(2616005)(8676002)(83380400001)(336012)(54906003)(36756003)(316002)(86362001)(36860700001)(7636003)(356005)(5660300002)(8936002)(82310400005)(4744005)(82740400003)(2906002)(6666004)(478600001)(186003)(26005)(107886003)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 20:26:39.4812
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32656396-8bdd-499b-d7a3-08daf4db4f99
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7382
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the white space issue raised by checkpatch:
CHECK: Alignment should match open parenthesis
+static int mlxbf_gige_eth_ioctl(struct net_device *netdev,
+                              struct ifreq *ifr, int cmd)

Signed-off-by: David Thompson <davthompson@nvidia.com>
Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index 32d7030eb2cf..694de9513b9f 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -205,7 +205,7 @@ static int mlxbf_gige_stop(struct net_device *netdev)
 }
 
 static int mlxbf_gige_eth_ioctl(struct net_device *netdev,
-			       struct ifreq *ifr, int cmd)
+				struct ifreq *ifr, int cmd)
 {
 	if (!(netif_running(netdev)))
 		return -EINVAL;
-- 
2.30.1

