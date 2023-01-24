Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFBA679B09
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234189AbjAXOEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234591AbjAXODw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:03:52 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2083.outbound.protection.outlook.com [40.107.93.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF58342DD7;
        Tue, 24 Jan 2023 06:03:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mMVMTd/+8vxqrMXvh4o9+Ny0W7MUY/S2sQpeeuZCJQH+VXIQWllJtLrQ7XqZF2Tepff4M/WMPSxFvj1OHRWoCHEDxV4CtSzJuIjVbgQzGCkAAVa9Ux/J8qrVhf6gQMHOsHeIS5Hc4naX4tUOOEFPOQLnWTUFpEyZMh4O8YaHNBiiwdvT79VXMZD9hUYnCjsDO6uhkGulafJBB5ryQwqik/8GPUQVijNK3nvUuJxRjT+0S4Jl3Te5Ov/60NS+FAkYK83Cwx1PakiXsW10XXgPyvZhwkPGpyx6584l7aOGALbgNXyjG/5EVs6R0YnbOmVQa2SshZsBmaFhWTkMwo05JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jiEHwNRseUOKk2qsnr28Ib/6wkMAHi8nqCcurGrTgE8=;
 b=RaRQ6HgQOkrwC8IWEEjtvCVx7xqcepKpBNo4lj88SKTBGFZGyityWQ1jRyROcSBvRqsLrsmGf2CyDWa3gBkgFpXE37qOjTsh+pqg1JCX7X/8kCLK0k8mQ7jAHIg4Kveqh5IuYxn7uAIiy4NIWUAm+VckdibkvaJzgcjoQ6ZLcrYt3gqHLUR/DvcS0VecA5YrzV4iI41QTKZg3IZAnrgEbwMZVYACT3md9xyFOIWFTAckkGNxVSKIIbbHV1d4lHDYx+LKM0bXEidqjoltW+8y9lR23kSJghzQd/79/Y5+Iq65cK0AEI6CD8USottE6KkQomMPNxmgb8NxMP3Hg+RNyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jiEHwNRseUOKk2qsnr28Ib/6wkMAHi8nqCcurGrTgE8=;
 b=bUqLCHcr88+JG/aFzFqvJsbrh8pet8+ZmYqMyJC+O6CaZxmntIEKtqwinPBiOffuj2PCPN2YOeiZascI1eN1GBv0Ehy12QcIZfqz7Yrzet7AZjcYilpMxDZaCgXfvIqGvohoosQIOLM9RJXXGq9KidyRPCRdLgrT36vO0W5nqVR711867mvxQeTnHuF3u4SJAVIwDSYsiXoJMig59Z7y/m7WZDpzFTUSL/Yd73jj/Th30/2WIF7YNGUoNqocwB2ClLtm1oqbEGL0QfCQYr1FUtaX8MyycP0DPb2weVl2togGhzFQiV0MJD71gXg+UF35o14rm9ad1ukyLPoH174fSQ==
Received: from BN9PR03CA0243.namprd03.prod.outlook.com (2603:10b6:408:ff::8)
 by SA1PR12MB7039.namprd12.prod.outlook.com (2603:10b6:806:24e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 14:03:21 +0000
Received: from BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ff:cafe::15) by BN9PR03CA0243.outlook.office365.com
 (2603:10b6:408:ff::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Tue, 24 Jan 2023 14:03:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT065.mail.protection.outlook.com (10.13.177.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Tue, 24 Jan 2023 14:03:20 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 06:03:00 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 06:03:00 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 24 Jan
 2023 06:02:57 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v4 3/7] netfilter: flowtable: allow unidirectional rules
Date:   Tue, 24 Jan 2023 15:02:03 +0100
Message-ID: <20230124140207.3975283-4-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230124140207.3975283-1-vladbu@nvidia.com>
References: <20230124140207.3975283-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT065:EE_|SA1PR12MB7039:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ea236de-c524-4651-93b7-08dafe13c02c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sV04RJYNhwrctf6UJU6gbdNk6bK+hvOvrpcLmmL9HFDseoieSS1vnHr68vRKsD1mhZjpFZ7cOU6kUtifgu7ssPSv3cV2iZoKYEmPBKpGUEhbMgszR9JqGTdKX25bZIoUGE1n4vNhITyrhpSvsEMh+/FWoRMpZyJdRW3wUfjfKJZrXXdcahUFc54MsAsrOLk7lAvQ8RxEP2mxB+rfw6n1GnFfvVfjzDjWC903rNiKLllrLa7b/vtKIf/sxBDHkQZ/S9Rk8Rd57eXPhU306OAan/10cP61LoR9gRKvUoktJ0dkly1pH7199v8DjLHKu3skL8KpXo4T/wBmDXjjF8nLbwCJvLRFCzp5uHAt+emZYOZOa00MONzmXPrJ/hRhIkpVE5OdtypsCWM9vNBPJyd8B2dTWlQYsYXnEVsupeLr0tLDcVxYHL9BSI6PVrw0JgxzwQu12xK98maG8Lxn3TZIGHLcCHV6/atrgba5rCPAwYCUSPclDAFrFvmu98HhvKv7POyn9yvBomUAEZMPp/Dhk32qpuX9THDq06XwPFygMDONV+eCj/fswoBKypWgcU72MjB9XWiSRNj/HLddlEfruIr1WnEcEFu4MvToogN6PDUg7LsDQ4e/5lwxIyS9QdryMVFCPsbYJhXw5XfPH/nPsiSSca3Uen0M8TawHF7xMPAB8L6gGdDO7KXbQKDjk9FH774GH7iqeidz8VC/+4KfM5/de7DEdMvDnk6+DhJbvog=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(396003)(376002)(451199015)(46966006)(40470700004)(36840700001)(7636003)(82740400003)(40460700003)(36756003)(40480700001)(356005)(82310400005)(86362001)(478600001)(316002)(336012)(110136005)(8676002)(70206006)(70586007)(4326008)(2616005)(426003)(47076005)(7696005)(54906003)(2906002)(1076003)(36860700001)(83380400001)(6666004)(5660300002)(41300700001)(26005)(186003)(107886003)(7416002)(8936002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 14:03:20.6295
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ea236de-c524-4651-93b7-08dafe13c02c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7039
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

