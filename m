Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E23967EDB2
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 19:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234843AbjA0Sj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 13:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235088AbjA0SjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 13:39:23 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3B86E96;
        Fri, 27 Jan 2023 10:39:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oTXS11/YiJRwO1pOCXS67qkFyAVYTg3chVjuyFotpLaOFJI/Cs3Z2E33Q6smY6drZEQ86LtsZtp22SHtGqzaVJtrTStSLugxIQBueFo0AZisCY1fCdV4/sNHWQP0WMaLjcSFwNM9N+EBtPtgi/3e53ApoT6AJjpQ42AXDhKyKO+QLBc4Y8r25X6QHmD3sW5ZKko0kCSHFskObPIZCP/L0nwvBXaMkwrnSmkYa/lDMQGbqPqka9UDRB+rElGpDmtzg3EuQcrP12m8RsOniIhdqAxz+p8H9ExwGRGwU8qG0bOQR0SerELOL9Sl15Z0GuGqwu2MNjgLZfUsHleMBBeWvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jiEHwNRseUOKk2qsnr28Ib/6wkMAHi8nqCcurGrTgE8=;
 b=SWM9Qrc+IPZ+9/yqVQyIFsa3YuX5UZ4KPFl4BUUuRtEf6RK7Dmu3oGlpe8beD8vW4yIVzO+U+BIoNnG3Mu6urJkgfdCGW/xp8PK/YDN0aZBWcC/YlxChYIe0cqvS8F8v71a94Rp2C29BNo/GbLk4WXV2IBJTlujboczRFs5UeevRbBgcocxkzoRFMQI6sEJQMOgIbmQYc9xAaTmPlEsUUy0TGznQ9Ft76eiq52aXsc33dftWEyFXPRdhiPj3yiyUgH4dMd84UQg+txfsjpsp3YbEj2Pv43tBJL68dveD5lExIQoSoLLdzV15UtUmavPA+75NNwv4LwIE40wMK5DfnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jiEHwNRseUOKk2qsnr28Ib/6wkMAHi8nqCcurGrTgE8=;
 b=ikfLJ9zDLsvN2Mcumg+03CiLNXggsHjmJmo07+N3j1HO3wUqLeela1r1Itu9r62CaQqq72tRbfuxz9ThzTed2/rL+lM3EyM6hd2+QvHmzeY+MewA32Qj2WXmO2SBvXEDqkpN+rYc8FMAYRUG/HQCSuWepaKZHGF7jmx71sRgaLd5nX8ZkbKS2KfUiWMqA9erQfNzyE4HZoTPsZqDSM8C9z0BgO0n2Te62xuWq6Ju94b21zvANx1XmyvGI9AoTFN7sc/1nOg2vRiDlihyQm3SbmUZ4pPY+Ue0SOyVxs4QA9qbTh657g2VImJKD1s8YWaNycPB+UMFLEFyobXdiF8NtQ==
Received: from CY5PR20CA0026.namprd20.prod.outlook.com (2603:10b6:930:3::23)
 by BL0PR12MB4994.namprd12.prod.outlook.com (2603:10b6:208:1ca::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 18:39:15 +0000
Received: from CY4PEPF0000B8EE.namprd05.prod.outlook.com
 (2603:10b6:930:3:cafe::e9) by CY5PR20CA0026.outlook.office365.com
 (2603:10b6:930:3::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25 via Frontend
 Transport; Fri, 27 Jan 2023 18:39:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000B8EE.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.3 via Frontend Transport; Fri, 27 Jan 2023 18:39:15 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 10:39:10 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 10:39:10 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Fri, 27 Jan
 2023 10:39:06 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v5 3/7] netfilter: flowtable: allow unidirectional rules
Date:   Fri, 27 Jan 2023 19:38:41 +0100
Message-ID: <20230127183845.597861-4-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230127183845.597861-1-vladbu@nvidia.com>
References: <20230127183845.597861-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EE:EE_|BL0PR12MB4994:EE_
X-MS-Office365-Filtering-Correlation-Id: 895ce540-d825-4bfc-2cea-08db0095ca8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xoJ4gFeZk6sBdT2SAVoTE3cxI8PCjnubTo+9by7HwsVeC5esxIsNTWWZn3syhIySkOD5nlGngiL2S6+Gsk2RM5Ia3C0CmeWjCAJZfpTca8spVmx7cBmJsFgNz25oXfNnHHPqIY6FxhPdiHnmQ1hBlOlhEnb66MGl3/m5WgWFv7QM0bS3K/9/46VFmIQc9lF2FLrhSIHIxQ90sPaudK3LnirxVYqlxQFFAoZ4VXBVq8Og3iWrRIYHkN7bfv59ig1k/OSbr6hj72eV+j+bZXLy0PGcy19ioLhZ9bYnZbvoPPXy6ekatVEQQDABAv8HEY+FlvXbxSoYSE4rFJbB399ThbX6NS0T7UUWDlMk0y3euIALTHSnJLzxm/zPmFBlQz/nvZJexjbszvWP2DKn/p/cIAPlfoxuGi8KNCOW29G6X2MeKz/fgvl4ikQnF+xdTVTbdHAuO0WZfz55UqflD9tLUjFPHnnY4iBIVFzm2M3ar6HoNNUhIwJjtcY//jCff6o3wcgvBArx5dV/FU7ThZprxcBrYxN4pZTYFMB3BCz0BYmc708d3sz3ZFvAXDn9D//Gw4lCuLm94fPrdzUQ7ry0A4EV9WggPh9WhvpR0Te4Vub0k63shL6fghPzOpazPcAnX8uTiAsFAhTNCihFO8EMuGqRxA6Yv+edkFsjkifSYclKVK9YMU1Chj08mKVuqWAD
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(136003)(376002)(396003)(451199018)(36840700001)(46966006)(478600001)(7696005)(316002)(6666004)(107886003)(54906003)(110136005)(2906002)(5660300002)(1076003)(36756003)(7416002)(2616005)(40480700001)(426003)(83380400001)(86362001)(82310400005)(336012)(47076005)(186003)(26005)(7636003)(8676002)(356005)(8936002)(70586007)(41300700001)(70206006)(4326008)(36860700001)(82740400003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 18:39:15.0143
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 895ce540-d825-4bfc-2cea-08db0095ca8a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4994
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify flow table offload to support unidirectional connections by
extending enum nf_flow_flags with new "NF_FLOW_HW_BIDIRECTIONAL" flag. Only
offload reply direction when the flag is set. This infrastructure change is
necessary to support offloading UDP NEW connections in original direction
in following patches in series.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---

Notes:
    Changes V2 -> V3:
    
    - Fix error in commit message (spotted by Marcelo).

 include/net/netfilter/nf_flow_table.h |  1 +
 net/netfilter/nf_flow_table_offload.c | 12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index a3e4b5127ad0..103798ae10fc 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -167,6 +167,7 @@ enum nf_flow_flags {
 	NF_FLOW_HW_DYING,
 	NF_FLOW_HW_DEAD,
 	NF_FLOW_HW_PENDING,
+	NF_FLOW_HW_BIDIRECTIONAL,
 };
 
 enum flow_offload_type {
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 4d9b99abe37d..8b852f10fab4 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -895,8 +895,9 @@ static int flow_offload_rule_add(struct flow_offload_work *offload,
 
 	ok_count += flow_offload_tuple_add(offload, flow_rule[0],
 					   FLOW_OFFLOAD_DIR_ORIGINAL);
-	ok_count += flow_offload_tuple_add(offload, flow_rule[1],
-					   FLOW_OFFLOAD_DIR_REPLY);
+	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
+		ok_count += flow_offload_tuple_add(offload, flow_rule[1],
+						   FLOW_OFFLOAD_DIR_REPLY);
 	if (ok_count == 0)
 		return -ENOENT;
 
@@ -926,7 +927,8 @@ static void flow_offload_work_del(struct flow_offload_work *offload)
 {
 	clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
 	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
-	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
+	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
+		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
 	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
 }
 
@@ -946,7 +948,9 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
 	u64 lastused;
 
 	flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_ORIGINAL, &stats[0]);
-	flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_REPLY, &stats[1]);
+	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
+		flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_REPLY,
+					 &stats[1]);
 
 	lastused = max_t(u64, stats[0].lastused, stats[1].lastused);
 	offload->flow->timeout = max_t(u64, offload->flow->timeout,
-- 
2.38.1

