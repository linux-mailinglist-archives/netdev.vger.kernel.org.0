Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53DB4FF802
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 15:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235864AbiDMNo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 09:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233901AbiDMNoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 09:44:23 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2079.outbound.protection.outlook.com [40.107.100.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70EA75FF3E;
        Wed, 13 Apr 2022 06:42:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bO62xje74sfA/VN5IoK06/Lxij00HnPjSab9mXZsED1r11vuvjVsLbiw0E6mYsCqSS3RBlnzlsKjIQFz3Hbvg7OOLBbYjLRKVqLyZtqs//10fxqHrX5oiWbH14FyjnlAunuD53Aj7Y5PfVKyVLmTaNAhM33nbiD6o74Mjt/+lkuQvdYUlXD78SGAOwZacWS3tCweh97PI2vd4MgdswNTGDMOT2L4z0hoDsY1pfLn/JwlyMrg7yvLpXqAkGEie2vvdzA4J5/6hVYeSGIKJFbqkSqXB+Fsn3U0K7qi/cAdR6m7QvCrUx/WLj88+pkz6wy3JRoqgF3k3YcopS1iZcc9fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1TL4O8zeRPXtXtORiu1FZzks29WEzmPQvxSSgkA8TUw=;
 b=ITXgnVu7qoSLqsNkgu6nUC068yG/KhP2xW8tmgIrFbtVI/qNZ6XNXswwa0PqtcFCrhq5ShTqh2zkXQeA6yo7TLhwxnY8u+ck7zbugFdFwjvUjOkKp/0oqbRLVLumKhhueOqU9a0ipfntO1vxqJn27mi5uG+5pjkBvn5T6t1vPDbrHFPPuUHrxXdHnkM7h7EAMeTd38bbRBRcpqxd1hBrcKyzVnyy4TVCzpCrAnEHys2gkX6RswIrB9MODSW4yvV12NaAt7ERikxBFkPA312WQmFGCV+4RhadeDoiplpCbxCPbhN/tVxJcMGHuJ/77YCs2dG45qKp9rQfdROh+l0tuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1TL4O8zeRPXtXtORiu1FZzks29WEzmPQvxSSgkA8TUw=;
 b=O6doZlWgvST/xaMVjjZKqNoThViPScQ8MVbwVevs8bXka+VkghW1nalUuLpV0K5IdChrq1IvwEGXQ2b9JhHO4R4y1dbHdbZL+gYV8eTDQJjWUMV8teoRmFk8H72/dHZ68HwXcx55U/cptccy5tLghrWWiV5KFU9hML4307walX9s3GUdf85Uib/0svoABgULEcng/e49VqtkoHpl33/2ZHyE57thKqe4lProery8v07C1Vstu/v3HsYaQPJAJybtvVyTl6nlHYvtqum4gV3kPHBMlt9B3nlWexh3WHizkOcf5uEodn6LVIylDHPsJTqAEMKSXeAEbbVEyXvFAA2mxw==
Received: from BN9P222CA0025.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::30)
 by BY5PR12MB4210.namprd12.prod.outlook.com (2603:10b6:a03:203::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 13:41:59 +0000
Received: from BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::17) by BN9P222CA0025.outlook.office365.com
 (2603:10b6:408:10c::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20 via Frontend
 Transport; Wed, 13 Apr 2022 13:41:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT039.mail.protection.outlook.com (10.13.177.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5164.19 via Frontend Transport; Wed, 13 Apr 2022 13:41:58 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 13 Apr
 2022 13:41:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 13 Apr
 2022 06:41:57 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Wed, 13 Apr
 2022 06:41:50 -0700
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>
CC:     Tariq Toukan <tariqt@nvidia.com>, Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David Ahern" <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        "Florent Revest" <revest@chromium.org>,
        <linux-kselftest@vger.kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "Kumar Kartikeya Dwivedi" <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>
Subject: [PATCH bpf-next v5 3/6] bpf: Allow helpers to accept pointers with a fixed size
Date:   Wed, 13 Apr 2022 16:41:17 +0300
Message-ID: <20220413134120.3253433-4-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220413134120.3253433-1-maximmi@nvidia.com>
References: <20220413134120.3253433-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bde473d-17d6-4887-39b4-08da1d5361cd
X-MS-TrafficTypeDiagnostic: BY5PR12MB4210:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB42106CDB48AEE77F715B241ADCEC9@BY5PR12MB4210.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7OC71EskqQzGVoD/DZR0VfMr/ZsaVOFnIvW6L/6fPOwh2IcGwPGLErhJoZgrkau7uUL0qkzk/pqsDio+y3sZnj3zpsz6G+w6ZUDY3B/5RZsGJ1/i1J0X5EKHSTUd9cIT8eI5xtmTt2isYzQWuxow9Yw3kGoKXzygnDHbnggTgKBl9bkttZL/Z6XOn3UOfXiQz864rzBTjPWG0nUycxRYCJAlGKTjG15G0ln5pBOA7Cx4t+TWhCVjUQX75F6NCeaKKoevry86QccRlvHTdvKOZMXvbc9rmcFk3Th67aFMtkEDIDc+LzxfgH3TAU3KsDne01n0C3dNOS+9IxcpsSYr3pR3WXkPBcC1GdhWR6eEwhvevhFIIRdSZVYg1g1vnNJUIi4Y4OyvLOOqIYVnZ5ov+cw4kxHvbqRbbjG3y6Y50kHIpvpNNFWHkvk4iiNhJrze6Zearn4GBYj0BfwUroeJvHCbqO5MAX9nFNDLjXDyHKboLQLaY+Qsr1B9eyNO11Aznvo1gRUf1wZDH8LKoCC7SLYZ/8ISClERMoSpRolsh5IW5Y4Ysbuqc5kuEF7m8KsCedSQqwuDFH01fgwDhQFofEiXLIW0oxgzKcFvERXbEpsfZM/dcOwxOeXWpI83D8YO+VV9eQ3iR8fNnqRrBMlBo6yUmuorQvDfjjZtSNdSOPdMY8dFH9cvdemaIqUomUukJID+kj3c6LAL0GLi1Dzq6qgODkrp0ewbTLt8vs7l4KYBK6zvDR+AaW2nm895Y32UuZQG/LoR3r9wAVnnOux12g==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(5660300002)(508600001)(2616005)(107886003)(7696005)(36860700001)(356005)(8676002)(70586007)(2906002)(70206006)(4326008)(40460700003)(7416002)(36756003)(86362001)(82310400005)(110136005)(316002)(54906003)(83380400001)(8936002)(6666004)(81166007)(336012)(426003)(186003)(26005)(1076003)(47076005)(461764006)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 13:41:58.4802
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bde473d-17d6-4887-39b4-08da1d5361cd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4210
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before this commit, the BPF verifier required ARG_PTR_TO_MEM arguments
to be followed by ARG_CONST_SIZE holding the size of the memory region.
The helpers had to check that size in runtime.

There are cases where the size expected by a helper is a compile-time
constant. Checking it in runtime is an unnecessary overhead and waste of
BPF registers.

This commit allows helpers to accept ARG_PTR_TO_MEM arguments without
the corresponding ARG_CONST_SIZE, given that they define the memory
region size in struct bpf_func_proto.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/linux/bpf.h   | 10 ++++++++++
 kernel/bpf/verifier.c | 26 +++++++++++++++-----------
 2 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 88449fbbe063..988749057610 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -465,6 +465,16 @@ struct bpf_func_proto {
 		};
 		u32 *arg_btf_id[5];
 	};
+	union {
+		struct {
+			size_t arg1_size;
+			size_t arg2_size;
+			size_t arg3_size;
+			size_t arg4_size;
+			size_t arg5_size;
+		};
+		size_t arg_size[5];
+	};
 	int *ret_btf_id; /* return value btf_id */
 	bool (*allowed)(const struct bpf_prog *prog);
 };
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 571ccd7f04eb..1b4c1e9ce8b2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5573,6 +5573,11 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		 * next is_mem_size argument below.
 		 */
 		meta->raw_mode = (arg_type == ARG_PTR_TO_UNINIT_MEM);
+		if (fn->arg_size[arg]) {
+			err = check_helper_mem_access(env, regno,
+						      fn->arg_size[arg], false,
+						      meta);
+		}
 	} else if (arg_type_is_mem_size(arg_type)) {
 		bool zero_size_allowed = (arg_type == ARG_CONST_SIZE_OR_ZERO);
 
@@ -5912,13 +5917,12 @@ static bool check_raw_mode_ok(const struct bpf_func_proto *fn)
 	return count <= 1;
 }
 
-static bool check_args_pair_invalid(enum bpf_arg_type arg_curr,
-				    enum bpf_arg_type arg_next)
+static bool check_args_pair_invalid(const struct bpf_func_proto *fn, int arg)
 {
-	return (arg_type_is_mem_ptr(arg_curr) &&
-	        !arg_type_is_mem_size(arg_next)) ||
-	       (!arg_type_is_mem_ptr(arg_curr) &&
-		arg_type_is_mem_size(arg_next));
+	if (arg_type_is_mem_ptr(fn->arg_type[arg]))
+		return arg_type_is_mem_size(fn->arg_type[arg + 1]) ==
+			!!fn->arg_size[arg];
+	return arg_type_is_mem_size(fn->arg_type[arg + 1]) || fn->arg_size[arg];
 }
 
 static bool check_arg_pair_ok(const struct bpf_func_proto *fn)
@@ -5929,11 +5933,11 @@ static bool check_arg_pair_ok(const struct bpf_func_proto *fn)
 	 * helper function specification.
 	 */
 	if (arg_type_is_mem_size(fn->arg1_type) ||
-	    arg_type_is_mem_ptr(fn->arg5_type)  ||
-	    check_args_pair_invalid(fn->arg1_type, fn->arg2_type) ||
-	    check_args_pair_invalid(fn->arg2_type, fn->arg3_type) ||
-	    check_args_pair_invalid(fn->arg3_type, fn->arg4_type) ||
-	    check_args_pair_invalid(fn->arg4_type, fn->arg5_type))
+	    (arg_type_is_mem_ptr(fn->arg5_type) && !fn->arg5_size) ||
+	    check_args_pair_invalid(fn, 1) ||
+	    check_args_pair_invalid(fn, 2) ||
+	    check_args_pair_invalid(fn, 3) ||
+	    check_args_pair_invalid(fn, 4))
 		return false;
 
 	return true;
-- 
2.30.2

