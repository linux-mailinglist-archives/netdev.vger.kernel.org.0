Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1FB6641ED
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 14:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238555AbjAJNcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 08:32:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238025AbjAJNbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 08:31:34 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645CF3AA9D;
        Tue, 10 Jan 2023 05:31:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1W/xsFSdO/VATzWdDYq9QGC2H0ps2tlJT5Oq+quSlJrx9I7mgLINVlWXJTs22cr0U63FrDJO9rpDoyC6wSpcB0z1A/A/ucA9IF02YN7Vg+AmvPv6toqepBhwEg/yrK/v2i0AW3MsDTrEG0zpbfiEmBJydgn0LUcPPI0hxeaoSOQCETUA8c6htBtOuO4VvmDb3Q6yrt/mgE9g2ON0Q4O+TPMeLwgYYMaKSxCerGRPclbq4EsipfZoH5yJ+y6033Ky1eRYy5Q10RTqUodwGWR1XDMxVMDCVtPKVW0SGlTzElgDH+NHOUsthovnK6I2PZCn7lxxp5aa1cjJU5HIKbGtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9hEkvfNid554/edezqmJkbmWBn+U9LvTjp4jBTLeAy0=;
 b=JsbW9jOXFN8IoTA5W2po4VoioMEisdSUtNgZiuNwPHpLSRxXthxAFW4DpBCdvECBFybVo2QG+v17f2aBrengDbOrMb3oY4pwW5/Xl0uOspNzXhr9sRcXy539a1qzjlNNLdzvFnMLoUnCaDPNA3wi6SvrADUR2JygqouIJRVUT23wrWtTJE5UfXT8WSnaVJhsCK2jWiRuO1H+oSlzr7McuxPjZ0w5fCAhev2tZlwo0mZO2DIdI2Avw11S8ybqXdmtWB1HaRvRHaAIwK40khUmJ0Qid6s7UjKwkIMNXUJ0V5WHFyco8nXYm4hUIZ3a5jdvJaQMQRDqBnjzUGGhMwshvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9hEkvfNid554/edezqmJkbmWBn+U9LvTjp4jBTLeAy0=;
 b=EQ/0TJkfYguopSD/tALFnTtR366ZHb2+IMe6yM/aWI5itPsjFlHhfDfkOZGg/HeOhOLdH9ToD0WOwdzR5xQImAAh7iH6eJZ5KUSMUgI0KIpphw9LDwayyJFt2wfDYbSNTHkL6HaIgaUCvLPRbAQjRYV4BC4cJ4ktoW7GXXYckcCUhymVPn7YncH3G4YknGw4rLv1+cQqqP+H2ywQ/fhJiuYh4rdtaeq2MT6psyRQTxMccG8BMSfg6Nn7RvMy8CF2FUmr9PTZXYiZGqgULfoalMnTvEZ+I519Lj/hFh6hhEGrrvgriiKgVkMDhQCRABbWwddF467lm7RnJ7ucCZa4bw==
Received: from BN9PR03CA0589.namprd03.prod.outlook.com (2603:10b6:408:10d::24)
 by DM4PR12MB5359.namprd12.prod.outlook.com (2603:10b6:5:39e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 13:31:30 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10d:cafe::8a) by BN9PR03CA0589.outlook.office365.com
 (2603:10b6:408:10d::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Tue, 10 Jan 2023 13:31:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18 via Frontend Transport; Tue, 10 Jan 2023 13:31:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 10 Jan
 2023 05:31:10 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 10 Jan
 2023 05:31:09 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 10 Jan
 2023 05:31:06 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v1 3/7] netfilter: flowtable: allow unidirectional rules
Date:   Tue, 10 Jan 2023 14:30:19 +0100
Message-ID: <20230110133023.2366381-4-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230110133023.2366381-1-vladbu@nvidia.com>
References: <20230110133023.2366381-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT052:EE_|DM4PR12MB5359:EE_
X-MS-Office365-Filtering-Correlation-Id: 616705fb-bdc5-4291-bebf-08daf30efb2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 43HST3juNSpJOJ9QfNsEeeyF9eMzrxqstQs/BBhATXtildrLe/BxwP6klFlZ/Gvget13Q4fMg5VR7F/4lyvKPJXyHZLqjvBQrEG4WLmmcJK27sVtW25OXyntjhoSgrdbaswbqm0InD9mnccw3CGZ6cVjMlCKG9qaIrqdZMmro522rO85AdNAD2vlq6LBxpqUHs9O77TDOmg+vRCkhphDttUFEVmIouX5q2PAyEtmHfwCee1eSuE+7ps3MVBxRYcbnid5b5b/yxjeHYguJl8AXzT3AwVzBqSRosZ1MC+VWNBYjODy6DkDLtUlrGFNjSsat5f4e1FrmHA5xxP5AIPOU8vowCDsgyI0KWDiSDo8jmdh0cEghNCzMyKWJSi7TyoHxUmcer92dz96zZiLUbRGwlIVafeZ84PB/bkF1EtcREGLsbso0yJIuoxM0pVGoQ9I1ybvMvYE4PlxUewD/RBf7w4ORqH4/eQUq354R5p0+p6yplrjVj5zVFBWc1LM9HbBGJMiobiYuEdk+vGyYYwrKFoAyHmZawcos1uUDJGvUd39N+iBOfO7JR/NYWskdmItSqsA7HcrEuxOINsJEmbHclNDlVBZr+V+U56tg+wthQX0pUJLsgvwG4RJ7KrRAlop4U9/I3Rwh4yRTPARKHHTlsGK5fSSukv3qvrI0c8dD4rPiATKnMhoBSHN39ziecQ/XiHyqbhlR54nv+ZvxNye/FimlupettP5atEPPTbmrJA=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(346002)(376002)(451199015)(36840700001)(40470700004)(46966006)(1076003)(7416002)(316002)(40480700001)(5660300002)(26005)(7696005)(186003)(478600001)(2616005)(47076005)(426003)(40460700003)(41300700001)(110136005)(54906003)(70586007)(4326008)(70206006)(336012)(8676002)(82310400005)(8936002)(83380400001)(86362001)(36756003)(6666004)(107886003)(36860700001)(82740400003)(2906002)(356005)(7636003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 13:31:29.3642
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 616705fb-bdc5-4291-bebf-08daf30efb2d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5359
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
offload reply direction when the flag is not set. This infrastructure
change is necessary to support offloading UDP NEW connections in original
direction in following patches in series.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 include/net/netfilter/nf_flow_table.h |  1 +
 net/netfilter/nf_flow_table_offload.c | 12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index cd982f4a0f50..88ab98ab41d9 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -164,6 +164,7 @@ enum nf_flow_flags {
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

