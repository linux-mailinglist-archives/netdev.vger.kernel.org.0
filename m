Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1194A686BC4
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbjBAQbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:31:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbjBAQbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:31:45 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2046.outbound.protection.outlook.com [40.107.244.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAC179225;
        Wed,  1 Feb 2023 08:31:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gvCa578uYGgIe9ExAOTyDd7RRjEac2MqdgU2XCpf7hPny+kNQ26e/Tqr1H0L9D9SMnEXUpIL4vwM3GpgcxlG8q5r7EKHr7UopdX205vYeWZDLCM7+I8YXTr38eFZffjzn72Cf5QjM2593OUqrxTAWRjWu+lSEV1YX/K1Zdx1tw6i7QiyuGDsnyfwDzNhjegndo4pXS4iUNFKEGXdTcLwA9QQik0Anb9gooQvCaQSTHkZJkQKxmi7Akq5BSh8kql/eFPPg7jSg/PQe6ETRtbtR8Sd5phKz33IO8GmZgV28bcJi61QVa4PlPYaLR9Q5Ohprnggsri2BRv0XrCYFdwjug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RJeW/5XL6gYeYwPc2MxzVrvJZqcGbC83ng9KlEa7AGs=;
 b=eTFS7Z/3OPyWDHghxqws9W+q0AfDVvy8lfTXx8jHoBsKPsRTpPWHQTDhCR2nWuD4ow/HhH7gDiGMEgPTYA51r031F/dVXfpIplOvSxssznbchxsf0rj7b/ZNSOMtGruRIFqVA6ibrghoj21cTS9+s+2GpnQOV8xxEdFsfqXbFzYQ46d+reGzHOg2BsLId68Na6HGdsIYqLRsoNH/K4cOMV5hgQHPa4c3bDRO0jGObM6x+K+aYu84AC/ROUhBires/kEFmwelkRz5+aKK2OMdceQLOOewpF7VQfdJKS1GpM1v2MkRYi5ApsMDuUAf54m5VafA0Dvya5T3WhP8LQU6AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJeW/5XL6gYeYwPc2MxzVrvJZqcGbC83ng9KlEa7AGs=;
 b=t7Sw8niOKCAu9pGurZMiRR+p3hraV6XQaCth9l1TCL3aa0+ru2jlXvd2AoxlQ360cadeCc/qy1t4F/b9JWW3MP4nTKQ5bjKcuGt/0ue5JJ0ZfC2iD6IfWxkCSxVFU5b5tm5FUrK1inZNQCvepxRHTbgeYawsoJFRxN6QJJjBQcFZsHyYpKcE3lUg9y1S8sskjPxpPl1dpnaUBwo+dUyZ9QoyWIessW/Fv97guJVeQIgTMPPwQNcYky/lZy20OQVrXvAURyEeewe5GuUjP+erYuPRuWc76CIcaxDSFsvY3yrIHJiMwdIeAJgtUvO8kMBs1Xns1H6wNgPXteq+KPXFgg==
Received: from MW4PR04CA0189.namprd04.prod.outlook.com (2603:10b6:303:86::14)
 by IA1PR12MB7709.namprd12.prod.outlook.com (2603:10b6:208:423::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Wed, 1 Feb
 2023 16:31:37 +0000
Received: from CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::d4) by MW4PR04CA0189.outlook.office365.com
 (2603:10b6:303:86::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24 via Frontend
 Transport; Wed, 1 Feb 2023 16:31:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT058.mail.protection.outlook.com (10.13.174.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Wed, 1 Feb 2023 16:31:36 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 08:31:29 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 1 Feb 2023 08:31:28 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Wed, 1 Feb 2023 08:31:25 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v6 3/7] netfilter: flowtable: allow unidirectional rules
Date:   Wed, 1 Feb 2023 17:30:56 +0100
Message-ID: <20230201163100.1001180-4-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230201163100.1001180-1-vladbu@nvidia.com>
References: <20230201163100.1001180-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT058:EE_|IA1PR12MB7709:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bc6c5b7-6335-4590-f26a-08db0471ca08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n7+hOQOYUFm4WNEuj9+cgFs0R3wykV2eMjrR88SWTSESXBwJZNqtHy1StXRMG/Ukl+/6ru7wDFiaHfCNBQlDAx9svrX946Fj83eF3fW+ayexFtFqJcvLaczSMj+cfA74AHNNllbZKj6NqH+qzjrZCIK2yD2VXmJNd4/qUHu7wm5+5A8WyVI2pLEBi7sXGEaweKswdCUIHEfC17XarcYox8nZPY0fcpM4POm9Nocz5lK56s91FNaRjtk/KAvcQuk3fdxTI2XHtVqndT0jsEpe79EPsXMJiiOjbSnZQKrZPYo+zzVQjWMZ1VJi6Bz+I5UkfjtDCMXjgbCGBWZ7Fh/E+fax4SSJGqtJuL2F2uwoaNjv7zfmrSD5TXTsqgT9csrR5nMo0ZvPnrmwuEK3lm9ej3IcOeRnHNVwmxSjj0OqR9S694IQDf6twe0wb6KXkVNVgKQqYTifuwp2vhJKsPKOklMNHjO0PSDFcidQ7Z2Q2f1hFgVLJA+Sr8un1jkUs8jqoAky6uRxpz4ddwRHzJ+G3KrMbV9Zj98YHA2NylRDWlhJQ//0KU++FR/4Xp+44h1PbtoPDpZxmPUGeQpZsEviGhEJj2uZUUSZ16n1vS9A/vkoU4BXzVM4fS/hObB877+NPTUXyKbI2qCJV5b9u57YEDgH9n86pZXatsqAdEu9ZuIo9jBXC8ZbDtVYble2zzqwcNO/mZ6g9tihCASZ0Nwfdxa2Mq+Zal227vJBKNJu/oI=
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(136003)(39860400002)(376002)(451199018)(46966006)(36840700001)(40470700004)(8676002)(54906003)(110136005)(7696005)(40480700001)(478600001)(2906002)(316002)(40460700003)(41300700001)(8936002)(4326008)(70206006)(70586007)(7416002)(5660300002)(86362001)(356005)(36756003)(82310400005)(47076005)(26005)(186003)(2616005)(426003)(1076003)(6666004)(83380400001)(107886003)(7636003)(82740400003)(336012)(36860700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 16:31:36.9519
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bc6c5b7-6335-4590-f26a-08db0471ca08
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7709
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

