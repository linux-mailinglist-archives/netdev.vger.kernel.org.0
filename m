Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30DB46D7F5B
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 16:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238395AbjDEO0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 10:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238372AbjDEO0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 10:26:17 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A376A40
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 07:25:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QR7QS5MizF/GzUrjmsJRCyYFEUSLC5EhGFdxkdkm9g1F8SFogFxsK418fLsVnuU+Wq98e/+Z0IKRNFJI5t7HoAG7q/V6GLM/7M9GfLAwTA5tSwaDR2/dCVulELvxrv4Z5g4FmRPpzCSqVUMBXan0NqPbq2h5JeOu6JIaQqOnshehnvNIkEAoXlQScMvIpym0QR+2ybYfULM/bUoAHVIi82kLref7RNdrmYdtQJiaKhTu/T20WCUIA2t/jH1BYWukwJtt1EjiGvfBbsp97FWzlRCNuD4gpT5t/JYtCBhf+SEdmp1eh7XKyGnJg5pjZ0rWESO6AWiR/R6MA//tOD7osw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J9VamRhj1RbzKcbs69z8j5lwCIU7PI2awL2GB6Z4VXM=;
 b=YTrw+E1Tzs+wAl8mjte0Dwbu9T2DLGg8ORuR8bwwhRAvXR9x0HP9GpH9HA0WMj5Z0auko6qntA3Uc0P0Tg3rxsmGxenFle3086CnFWdJ5voDPjN/Z83bZBeUyhn9MbWU2SciGsOre6erT+Fnk+irFx6jKZPWFO8V5LQ5DlpKNpAH6v6o06+rvXyIJtkk5aIZ21V9Ql/7FNKTpDbXiNaKQBK/z8x0trcPVJ0+QEaESD+ruvu9JWZ2MAWlfyO05XZ6UolQ7dQ9kOUEiWCPA1ebYNWOesDRY0n5BnFfMB33eV+QzLuz5gTz6FzXFYo+odTL3qEnCMRS1Lz7IMteUQbHtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J9VamRhj1RbzKcbs69z8j5lwCIU7PI2awL2GB6Z4VXM=;
 b=LVInGsScGXSn20oFmn+f353AbJAsr3QKMWPSkEuKN4zU0yrOLHxZzaMM2+Yna9Bsr+A3xSA2IOhPZLmE0z6EmY/wnDp0U7WHlWexvmqkwXUb/TNgptBOLm/PRjcEqlUY4qokjo2/5EJr2+9eYX3XaKY7MPoMMUmaq5O210963ombFOmPhqiueSeWgzhg7DkKmwaYdrtG7ir+sBZTqv36nK3mLmulDmv4TA3yRikb09XfqJy1nJYiwxmqvxnRUHJ0yW1+kpBujSw390uGXglIiID21nBHdiZWCnied2vFAChSkZzbCPpxKoXkdelSbklc/b7kIaKvuU+FuaeE9TBIEg==
Received: from MW4PR04CA0271.namprd04.prod.outlook.com (2603:10b6:303:89::6)
 by DM6PR12MB4217.namprd12.prod.outlook.com (2603:10b6:5:219::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 14:25:50 +0000
Received: from CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::3d) by MW4PR04CA0271.outlook.office365.com
 (2603:10b6:303:89::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20 via Frontend
 Transport; Wed, 5 Apr 2023 14:25:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT014.mail.protection.outlook.com (10.13.175.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.30 via Frontend Transport; Wed, 5 Apr 2023 14:25:49 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 5 Apr 2023
 07:25:38 -0700
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 5 Apr 2023
 07:25:36 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Shuah Khan <shuah@kernel.org>,
        Danielle Ratson <danieller@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, <mlxsw@nvidia.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next] selftests: forwarding: hw_stats_l3: Detect failure to install counters
Date:   Wed, 5 Apr 2023 16:25:12 +0200
Message-ID: <a86817961903cca5cb0aebf2b2a06294b8aa7dea.1680704172.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT014:EE_|DM6PR12MB4217:EE_
X-MS-Office365-Filtering-Correlation-Id: 97349657-5f6e-46e5-1d8f-08db35e1a76c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VNQnUQh/lUUBG535waXa3ctTewaPRFfyS7l+NEBqsXfMZiIAdVAdOrIREGP1Qd1w2wg59rW2i4V2unkyjpuJnfk/CGhyrYaExcpJFnhV1IrsPPRW06LPnqo2eJH+UllBs6YWFfZH1zWpg9ykY/h266raZL7J6P8ziB2FvYQ5PbSSwROZU/JaT54pYLbGNEz5LscZtRUMwQ4XfdxgxQTGy0NLdmE7DVc2U1xXy+QvoAe4grDsPT1ofpIpuudXTvUIZ+vKlU/lmiJjGwr5mj7o91ARxfLFuXyTmQVG8ed+bFVbMAoKGp2wfu1hOqoQRLzYyWuwk6KCTXEXaC9kx3yhrDBvR6MlxQZiy9qXfdNmkvxcKh/Cau0MsuT11oXzZEt7LWD2g4yU7wlro2ZhKAb52KBKHW8JtJohXZz421c/gGI0ldGhbr9hbXLW4vHCuf+BsigtxFDdTgYt10api8reI63R8UmOP40cB/vLIzW+X500SNclpGJmto9Y0AzC9skK6akG4Xdcgcqgida0SQed8WffzjzfYw7uE8GXCZFX2qLz305P/0jv8Y/o02jBI3WEn68d7Lv+eq2ytVlyiAFWGYbUgueoNKD7k3zJ5KnWJUVnXQjHYUAQMCWhGK+Mx/B180EQ3DV/Lghm8IrMfuFFxG0/IOI4/3K5mMcErAO/YESUOXCm1fqiuLgeUYzGHVxRXWC2YEggsUxkYTQe5+kMbTpj99ZkP01vLaaIu4aeXVOTWITlUGu3+3xei5IfdtkT
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(396003)(346002)(376002)(451199021)(46966006)(36840700001)(40470700004)(82740400003)(356005)(7636003)(36860700001)(82310400005)(40480700001)(36756003)(40460700003)(86362001)(26005)(6666004)(70206006)(70586007)(4326008)(8676002)(41300700001)(2906002)(54906003)(478600001)(5660300002)(8936002)(316002)(110136005)(83380400001)(47076005)(2616005)(186003)(16526019)(426003)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 14:25:49.4445
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97349657-5f6e-46e5-1d8f-08db35e1a76c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4217
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Running this test makes little sense if the enabled l3_stats are not
actually reported as "used". This can signify a failure of a driver to
install the necessary counters, or simply lack of support for enabling
in-HW counters on a given netdevice. It is generally impossible to tell
from the outside which it is. But more likely than not, if somebody is
running this on veth pairs, they do not intend to actually test that a
certain piece of HW can install in-HW counters for the veth. It is more
likely they are e.g. running the test by mistake.

Therefore detect that the counter has not been actually installed. In that
case, if the netdevice is one end of a veth pair, SKIP. Otherwise FAIL.

Suggested-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
---
 .../selftests/net/forwarding/hw_stats_l3.sh       | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/hw_stats_l3.sh b/tools/testing/selftests/net/forwarding/hw_stats_l3.sh
index 9c1f76e108af..432fe8469851 100755
--- a/tools/testing/selftests/net/forwarding/hw_stats_l3.sh
+++ b/tools/testing/selftests/net/forwarding/hw_stats_l3.sh
@@ -319,6 +319,19 @@ trap cleanup EXIT
 setup_prepare
 setup_wait
 
-tests_run
+used=$(ip -j stats show dev $rp1.200 group offload subgroup hw_stats_info |
+	   jq '.[].info.l3_stats.used')
+kind=$(ip -j -d link show dev $rp1 |
+	   jq -r '.[].linkinfo.info_kind')
+if [[ $used != true ]]; then
+	if [[ $kind == veth ]]; then
+		log_test_skip "l3_stats not offloaded on veth interface"
+		EXIT_STATUS=$ksft_skip
+	else
+		RET=1 log_test "l3_stats not offloaded"
+	fi
+else
+	tests_run
+fi
 
 exit $EXIT_STATUS
-- 
2.39.0

