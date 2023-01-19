Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB12674321
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 20:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjASTwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 14:52:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbjASTv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 14:51:56 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296757C875;
        Thu, 19 Jan 2023 11:51:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IVEGTfwM5lvCpgbh4iqpXLj5zQEUyXp7cnVVPMOATpLZspz8amMvJOjeDAHSm6R3MgB8V3kZNQmebusWjspjhTSMF5wEzCWcH7HAP1wChensF/r7kO+V0w9zHIAqI//+bzIE33q8PW4JCc0yMjRqqdCDvw3AenEwiZWrgXlG0dEZCFcd10MlveA7EUCqVEVxq1bzGoMA6UcAPOIi6ntqmhdnXNdNbAWjREcBlGczIzlkMRtjnT+CJoOKC/qSGBgU5sstiFhkcHrwUtAINNc35vxD4L/KN3+cMa14Ok1eWG0mW1+49vC43GN0/e8jUUQm/vCpt+Ef0V9f4U6Zi98wdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RJeW/5XL6gYeYwPc2MxzVrvJZqcGbC83ng9KlEa7AGs=;
 b=Th6wrl8vZ80mTlQz3k1GrVLimnGgsAXeVOjdv/8sm9Ufc7BEuLGsaOJmbuHejSg4urIX1lvDZWiwWKVxh2yLieP33WEeATCagzA6sknSSYV7yW3dCkkLTcWuhCQS8WctI2Kgb4mOvMAHnNDHHojp9ab857gNGBmVVTvwwKWEIKhkh+32bEvvgIC/cMUsrLa4ysCDSPhiVeqBNAGLME2PWjubBOqkYVqOgxUGquz1F3l+yK45s0BkDk+GAAGypypadDKTlVA0pVBUY/ez2NzdT2MM7W/AraMHPe+03DTshYorUeb89kXw4I0ogwXta8cS0UfP2SqiPywqztFM0BfUNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJeW/5XL6gYeYwPc2MxzVrvJZqcGbC83ng9KlEa7AGs=;
 b=bp5uMxBlCmPYkV5NTzXViKXJcavMbg0W06Tzxq1tQTRCuJJipDFjdgvy1hSKUpMywuiRqpEdebm4DjiQHDowYWtzENkgF4gjoTMJ46PiwZORzcy7V9wrzO0n8yH2ZfY20KZyuXBUUenZ1KFyE0y77G6FbJLmdR9x3V/ppf+D2sdNk5O1MXN5maTqS0n2/judFuWGOTZtJZIrq1N2BuQbTPVI1iKX6hRORboijjPMEN59N6/a9lufKNqQvOFx+xZ4sH8+R9L+U86/aeHH33FjGFgE1mBPAtOvoSjxdJV7fXczgswncoe+lmrnvm2msDDNn2iiFhGoczwYSUO2fWDMLA==
Received: from BN0PR03CA0013.namprd03.prod.outlook.com (2603:10b6:408:e6::18)
 by CH2PR12MB4277.namprd12.prod.outlook.com (2603:10b6:610:ae::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 19:51:50 +0000
Received: from BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::88) by BN0PR03CA0013.outlook.office365.com
 (2603:10b6:408:e6::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25 via Frontend
 Transport; Thu, 19 Jan 2023 19:51:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT031.mail.protection.outlook.com (10.13.177.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Thu, 19 Jan 2023 19:51:49 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 11:51:34 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 11:51:34 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 19 Jan
 2023 11:51:31 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v3 3/7] netfilter: flowtable: allow unidirectional rules
Date:   Thu, 19 Jan 2023 20:51:00 +0100
Message-ID: <20230119195104.3371966-4-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230119195104.3371966-1-vladbu@nvidia.com>
References: <20230119195104.3371966-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT031:EE_|CH2PR12MB4277:EE_
X-MS-Office365-Filtering-Correlation-Id: 41c4b67e-9264-41bd-f98b-08dafa569ae5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8IFPxh5pWc2Fesssr2Hw1652PqyZPJ9Et2PMgmoTt5I4Qi1/ODPxCMu7CGjmtCut3wFahZsDO9TpQf0Vj9Yf5uK6MaZTAZKBs6e1AEqyUp6pI9jhe1zMa6GSZTYWbzyJAcVFjH/IvVpEzjqEEbn5zyqWsT6fUwxeS7hRz1j6Tp8fVIc5V0LniH+zWwzjEKjBKIbRLudWWyxnx1tRRPsGTgOjrn7isnVMc2vS66Zwt68E1KjcBOhxiW/KHoGrg/QGIvdJuWLkvDXoVqSzQtBRTTwx1hUeSXEkR8lNMpuw/y69Q+lkD2T1rYkmIW58Nqiw8IBBamy9wK3lOMKaUGBhBdnyvtBjftmZ6JIBlbOI0bpEJ2BjtpaKzhEdvChhlbbs5+m26+9EFbYa2E+lFoxRNMM/eEPiQyT26HHCTp3/hL7yv08SVChJ/wMRu2KyP6KqxOURy6BqnyKK1fKxnrzMfi2rPo3X3j7Xg2waETZGYLlLUU0W93jU/nrVt+fv4OhrKvlZeTLeAvbP1Tqbt5TzkoKZR6aMoUDrFfi/pXBqDvDBPtyBwjthpSyA68hB8dFPeWaf8lM3YG/fLiSqwNa47jMyiwxI9DNdB+qo1E8DwCPERek6bBfJxKyeHEYawzYMyKzjmBqkFj+vJvQZHltBqCV27LG4Vq0zateR2xm1I1J7JU4f+dOCf9gYIFbtfM+n72KdtNEWpmZVZOeqUdrqdq94A8B+DsqC/xvdCiRHQtU=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(376002)(346002)(451199015)(46966006)(36840700001)(40470700004)(2616005)(36860700001)(82740400003)(107886003)(110136005)(54906003)(6666004)(1076003)(26005)(186003)(7636003)(40480700001)(478600001)(7696005)(86362001)(82310400005)(356005)(36756003)(40460700003)(83380400001)(41300700001)(7416002)(426003)(8936002)(47076005)(8676002)(4326008)(70206006)(2906002)(5660300002)(316002)(336012)(70586007)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 19:51:49.7209
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 41c4b67e-9264-41bd-f98b-08dafa569ae5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4277
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

