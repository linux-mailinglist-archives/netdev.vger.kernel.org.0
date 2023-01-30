Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29D65681696
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235698AbjA3Qkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237621AbjA3Qkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:40:46 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2048.outbound.protection.outlook.com [40.107.220.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF3E40C4
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 08:40:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cik6Sqi8E9Yda7HQeSFqnYIOIb8isXbq8ycvx0QU2heRHUUum4Rz4nY3+iEKqOMYeghgEdbWzUjckZvCAqeuNndYRKx/doK25gRMg9mtj9Jl2q+sso9ZElP1kN/l2vbwKNfZswb23DFgxBDb+NuR5Jd4if/0Y+cL0bn1lkoPtOHPegKfWtNS5oEmpWgkFc7Nnf1EdU/X5a7BQvL+mdQ5T6irr8AhZL8yyaJZP1OQ0MRy7PTDKCOhtxhgWuclCSnXva5Nf1kLtZgCxCcOBskeNupYnVWP3YLP6zEJO0idQV/7/SQuxXhecxSgj+vUlYePZjFjUH739ymZrFGM6e/aRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YVsFCc/nsup7p+Sd9txXhLXNeS6c5RVkA6klVXWfCFg=;
 b=h6umfNCkF5o19cIalVCFc7jcikim/4pYEBUtqJUEmbsRbkNML1ZdDPtuUAd1Ijgejy+7ovNO8w+bUIHvQnTo/OcQdoVImqDIjWHwAGFpRJLxze36BidVZUjDTmr59MN8a+kwLNLWaxojqj6Oe3BUDXSRYPA7uRegPPpdkB3T9hN2fcm3C/1V+sVOZSZE+xu2X+g3AqS8nEJLD6A2Gy5DptAgQQJTIFXY/GqSCQ4xasO8FARIVwgmUh2E99Pd0l2sHt9rPXSCx7v90aoPUvocKQ/plNPJdPUqOEMjzkxxg32ax/Nfeuq9ljAnvaS/VTjdWjN/YEppHJ1jBST84F6MTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YVsFCc/nsup7p+Sd9txXhLXNeS6c5RVkA6klVXWfCFg=;
 b=NmA6wWcvc4qVc/WuLuGNGE3v6RHlrB/K3jXiJCkFZ2ZsM35nR6p2sgdnm9FY3ojepRYZGvcbCDfZ/I/B4sDw3/SUUOMVcgpmmTMC4Z1jcUx5CAw5siJyMe5Ttfzs/Ch1XEWTEKrNYqOJMPC9O8J6IxMZgeY30UTWJJwtHpNawJq+2LK2OYv+U7uDoiEAOfeul/MCIumYHRqkzNbCe/uF1UUog33TFk//33kYcDnwE0+nsroyPOElQMRT14jJqWqCrUBEnsLMaOiiHGkxxoOSn2iujx19/vvyD3+XsmkzCSM25hs2MV4sHEbXcgnSg3L28auaymR4km0Yw4Suk6fkAA==
Received: from MW4P220CA0014.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::19)
 by SA3PR12MB7999.namprd12.prod.outlook.com (2603:10b6:806:312::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Mon, 30 Jan
 2023 16:40:42 +0000
Received: from CO1NAM11FT089.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::14) by MW4P220CA0014.outlook.office365.com
 (2603:10b6:303:115::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36 via Frontend
 Transport; Mon, 30 Jan 2023 16:40:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT089.mail.protection.outlook.com (10.13.175.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.23 via Frontend Transport; Mon, 30 Jan 2023 16:40:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 30 Jan
 2023 08:40:26 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 30 Jan
 2023 08:40:24 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 1/4] selftests: mlxsw: qos_dscp_bridge: Convert from lldptool to dcb
Date:   Mon, 30 Jan 2023 17:40:01 +0100
Message-ID: <2bcd10cead610dc8739730d850d0c16c0df1fd8a.1675096231.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1675096231.git.petrm@nvidia.com>
References: <cover.1675096231.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT089:EE_|SA3PR12MB7999:EE_
X-MS-Office365-Filtering-Correlation-Id: 86e63685-c553-437c-6c3f-08db02e0b9ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NkimGjVYaQRTZ7z+o0dOHkCZ7HFoKWEIXRAyUxmoyzAxriOepiDW/Zzm6kllavh0RP04kGLlf+UHjV3fkjEaNCExN0DGD5gJpxYFseS3hR572DPNklt4qiDA4UrkwTIDlRfryJJvT9rW6gCNALwJSFj0f8T0ee1jkXnuy3q4gNjEh72qW1zvUNZdmpaN7nm/MrBmpmkV+lmnu8R5fsIEQ4w8bzIXReZGImCjaXTh756NMmHfyjUchMEV7A5boUgNECLRIitln48fGrN2hs+6zPGU3k+xRZu4qQLggk2DcnKqxHj9y5dMbMCuruYjpSqWlbN0/axY5zvgbiHM3wv7x3m1ZaTsq7fuIac3Zz0NvDb7RlTiuFgx0LTeTEimufgnrseVN7ffTJQwdIiqz0ujO+8LTDCN6v2XVcZsq1TSWzOyXvs+7Je/AGCsaxyzAkYt740QNrM8qmIQIrU7KQ9x3jFJUwhxs+lLefg6GyIetF0jxrzxgLGyhiV9MkjysPlon73gcH0/OJGL9Is9fa+496KMUR1UWKYgL/6AOlitY8aASUwoFHTjax/IReMH8DVG420h1WiS+eoZGwYghLZk7N6u8gVM5h7JAk2LD389G7JDFjU5t16FMOIfXq9k2mkq2e/Gj5uRi3CpHaa9yuT1Q8Wz//3rOHIrrPqdPqR5M0PVmIfcDZ9oVI8bcsIpElSQif1dL2DzAgPW7IQh7eG07w==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(346002)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(86362001)(7636003)(82740400003)(356005)(36860700001)(36756003)(4326008)(70586007)(41300700001)(8676002)(70206006)(54906003)(110136005)(316002)(82310400005)(426003)(40480700001)(5660300002)(2906002)(47076005)(83380400001)(336012)(2616005)(478600001)(6666004)(8936002)(16526019)(186003)(26005)(107886003)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 16:40:41.6703
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86e63685-c553-437c-6c3f-08db02e0b9ec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT089.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7999
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set up DSCP prioritization through the iproute2 dcb tool, which is easier
to understand and manage.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
---
 .../drivers/net/mlxsw/qos_dscp_bridge.sh      | 23 ++++---------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_bridge.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_bridge.sh
index 28a570006d4d..87c41f5727c9 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_bridge.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_bridge.sh
@@ -20,7 +20,7 @@
 # | SW |                                                                |     |
 # |  +-|----------------------------------------------------------------|-+   |
 # |  | + $swp1                       BR                           $swp2 + |   |
-# |  |   APP=0,5,10 .. 7,5,17                      APP=0,5,20 .. 7,5,27   |   |
+# |  |   dcb dscp-prio 10:0...17:7            dcb dscp-prio 20:0...27:7   |   |
 # |  +--------------------------------------------------------------------+   |
 # +---------------------------------------------------------------------------+
 
@@ -62,16 +62,6 @@ h2_destroy()
 	simple_if_fini $h2 192.0.2.2/28
 }
 
-dscp_map()
-{
-	local base=$1; shift
-	local prio
-
-	for prio in {0..7}; do
-		echo app=$prio,5,$((base + prio))
-	done
-}
-
 switch_create()
 {
 	ip link add name br1 type bridge vlan_filtering 1
@@ -81,17 +71,14 @@ switch_create()
 	ip link set dev $swp2 master br1
 	ip link set dev $swp2 up
 
-	lldptool -T -i $swp1 -V APP $(dscp_map 10) >/dev/null
-	lldptool -T -i $swp2 -V APP $(dscp_map 20) >/dev/null
-	lldpad_app_wait_set $swp1
-	lldpad_app_wait_set $swp2
+	dcb app add dev $swp1 dscp-prio 10:0 11:1 12:2 13:3 14:4 15:5 16:6 17:7
+	dcb app add dev $swp2 dscp-prio 20:0 21:1 22:2 23:3 24:4 25:5 26:6 27:7
 }
 
 switch_destroy()
 {
-	lldptool -T -i $swp2 -V APP -d $(dscp_map 20) >/dev/null
-	lldptool -T -i $swp1 -V APP -d $(dscp_map 10) >/dev/null
-	lldpad_app_wait_del
+	dcb app del dev $swp2 dscp-prio 20:0 21:1 22:2 23:3 24:4 25:5 26:6 27:7
+	dcb app del dev $swp1 dscp-prio 10:0 11:1 12:2 13:3 14:4 15:5 16:6 17:7
 
 	ip link set dev $swp2 down
 	ip link set dev $swp2 nomaster
-- 
2.39.0

