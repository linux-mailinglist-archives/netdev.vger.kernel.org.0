Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 350B24D2663
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 05:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbiCIDZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 22:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbiCIDZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 22:25:14 -0500
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2122.outbound.protection.outlook.com [40.107.215.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB289443E5;
        Tue,  8 Mar 2022 19:24:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e3Zt7WLyDaTfhT685Uv2lL5HE6YTcccIs/fkt9lBxAMwNyVvJLjw8FR3dw+pa9/EIaRvZcZvoVnNbBYoU7+ocw47+UhmMxyGjz1ve7kYwV3curSxbR5JVqSIdSGl4mlKpsUkCtaLUF3KaCYgMINfhdR3vxeW2280craqNrr5+GBKgZ/PClr2+o7pqelD2w7dB07on/aI17EHJ6bnRi8E4fd9jY23pOLI/iurLHBeZUZeA9xXxyIRlKOQ1xljnk+xCz2uUJ8xO3rRWmgjC72OGEByYmTebh/svYM9wN73HouOaYj8v94lx8EElE12VusDyOy+XmyK4T5zUr3dRXAEnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jmyrMYlJ5mAhk6qfnf2d/Vgoztb6KQY+V1i2MuCEuxs=;
 b=g7xaz/0jCr6fp0VqA6GAFMeeq05T2DIvx0+RHlmPWSrmp4NxOt2KIo3yTZ9l+C7wEHudU+76OtWd4+tqpL8qYVjlQp0uHsQvQm6QXXHCVJfwmhQP9xfdQODu6+Kj8906gj8GUeB6sYp+R5+qyV4FQBYOl3bQ2exoe48MMlU8ffJju9Hp41v0aIFA6RoZXJ6d8nt6iERcWZAcg7nN5aUutoJPSz6G2dGbWxkStThUyDiCtyLPBLsfAI6JYwWzgd3iqusyg+e5Ywo7Dm//kZ+Z+Gwu9Beb1VTDFalC0tAe1eAFSUR/6peQ4lzx3TP2870ekZZ4RIxLH6Vc0NaKGS/3RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jmyrMYlJ5mAhk6qfnf2d/Vgoztb6KQY+V1i2MuCEuxs=;
 b=pfvGOXY+wW30Yk4HTwYX7XP948SjOexlMZk2NzkZ39S/PAD6tmaWUK3FBJHExnLMFOpnQph3fnDQHyt8UE+sk90aLaVE4DnqKBiaw/Vb68tqbvweLLZnAgWDquDI1xpRtNuuRlhsHMSO8zWS35LNhiXA3Ps9WKYmzM8ZxECabg8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by HK2PR06MB3619.apcprd06.prod.outlook.com (2603:1096:202:3b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 03:24:08 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59%5]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 03:24:08 +0000
From:   Guo Zhengkui <guozhengkui@vivo.com>
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        Guo Zhengkui <guozhengkui@vivo.com>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Christy Lee <christylee@fb.com>,
        Delyan Kratunov <delyank@fb.com>,
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK),
        netdev@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        bpf@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        linux-kernel@vger.kernel.org (open list)
Cc:     zhengkui_guo@outlook.com
Subject: [PATCH v2] selftests/bpf: fix array_size.cocci warning
Date:   Wed,  9 Mar 2022 11:22:58 +0800
Message-Id: <20220309032325.1526-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <b01130f4-0f9c-9fe4-639b-0dcece4ca09a@iogearbox.net>
References: <b01130f4-0f9c-9fe4-639b-0dcece4ca09a@iogearbox.net>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:3:17::20) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 199da4d0-fd7d-4467-caa6-08da017c4587
X-MS-TrafficTypeDiagnostic: HK2PR06MB3619:EE_
X-Microsoft-Antispam-PRVS: <HK2PR06MB3619970B96D52630BA29BA1DC70A9@HK2PR06MB3619.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ijyv8U/e9SErdfrbT/TE2D0vvjP3rt8DFGF/of37jdHCDqowvuMNXwGD/UKvsh1EP0Z8+V9Vgghrv9Bh3KVKQN0WImNt22cToUy/7eM3DlkPTmPXP6cWTymh1lx6856LFb3tD+nxiCS+2whsuWrzmEcc5iniJ8RAoamTsttHLD+64MDZ/5mKt278JbLHO79DZPLw8DT0YeyQoJTN4tS55S78XtheagRB+qToeNLOFnlGjTjTd4NHXW0gYBGGfp9rsN8hPW5Ff2FMi0ba+AlO5fnysir3QFMcnwrtdy6VMmPXhdUljRtKnatUl3Mqj52SNCW/2Qlphe6LjRt8aBJBiH/+MtdWE5DFBsjMUu9ib7apeyOBFVOJIQRgsD8Uj4a92tTwgN+Q0hcISYYIfmjUaafPZ2gTVW4xM4QfcWYaws1U5565ZIumP1iyUEhTf0Wnh13CfMgIqkWDw6LS/slbRSj01NtMCKVPheX/X4LwKMxIZmZbFdr0lN4Nc9kjsmLiOCNWLRi/iQc1XfrTbsGpikxNdtcae10y1NInytwbv4XkNYYNSTVfO+rY8Lc7meQb7I+Nlkk3+h+xySsNt46KsoNXmrsGyYUZzK/d2utwlwuKE/78uWg2kKNWZEIi2utwszmES1eiVnjxUvl0/ASggRGe84oXL/54bUhPpC9E9zvUxRoyAXCKRT090qww8OxJ3pnD8F/f06r0LCoeLn3AuTS3gp5OyWFxCQXY+OOGWF8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(38350700002)(110136005)(26005)(83380400001)(38100700002)(316002)(6486002)(921005)(4326008)(6512007)(5660300002)(7416002)(8676002)(186003)(36756003)(66946007)(66556008)(86362001)(66476007)(6666004)(52116002)(8936002)(2906002)(2616005)(6506007)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?775p7xPzZMTBuLCzVIFyqJiut8UDp5O/TNnxJVsFMruD5OeomS996FxWV7tm?=
 =?us-ascii?Q?eYF8HEqJ6fzq9B+lTY7UtLqDNPp3ByEi5hvPfaJhuhnHG4zJ7ANwtqizMv5a?=
 =?us-ascii?Q?cqMC0qX7LivIyrK9J2XSe14GMsJzFYJZc64E/WxzFgjFWh2TdEs8Gfo7V9eW?=
 =?us-ascii?Q?OPGPx/hmtSWumz2Q17zoFdTO83iZ22/1YVnInBi/peU+H0Ir1X2BFfVsmcnB?=
 =?us-ascii?Q?RbeiEStsT+BHcEion13F9l6sEB93FatJS1kJIwSwi8MDJ6Yy8RyN8lXfdfQb?=
 =?us-ascii?Q?ej83N8K8AGerzQFwyZGfBnB2URDK+ihIBzz6f+fjEiKtfsHJDbyMz7VutrvY?=
 =?us-ascii?Q?VNaxlY2kjTHa7Gr3A6tIBB1yRa96QleVmxEmSqvNsa79F7QAPICwGYJabLto?=
 =?us-ascii?Q?jCXffKmpwhU9MNAKWFzDodhYMFqpDAujS7TcNex/S+xcx3i0yBFfNABPDKt9?=
 =?us-ascii?Q?cckO2S4Wlj10lxPn71CaIEGQbNsYvWdqR4lXi/EsNQyHtp6VjiO4zXJC8icK?=
 =?us-ascii?Q?a3M2TrCHdYdkb9i3ZtYNHRsWnRZThtfWct0IGyvFNBMloIAQmm+Jit5UyK6y?=
 =?us-ascii?Q?r0Rx8wTGEg/ywqE6So53phmzALeJ6PlXDacsnfSD2n/wPfWB1iSUk5YccMrV?=
 =?us-ascii?Q?at9309g9yl1Xh4nEOCIpu+rZMiL46Lnw6sBNJgvBOIO/398zOogR96WO/7/1?=
 =?us-ascii?Q?m4r8gjkpkyPXXwPOqFDQdo1iHv4ahUybn2bTyRux44QceQsJSorB7hy2rjPa?=
 =?us-ascii?Q?hcYNPNZV5mO15eQQjMJLFGG+NdNzqphkwLTDUuQh5di7/Ql8MCXOveYIKXNf?=
 =?us-ascii?Q?kIVAOyhSXP8D2la0Bl98fcBIX7oDSq9spBmU8PR0PJR/q4RjGGQfdKJVmFuI?=
 =?us-ascii?Q?rhYS35J7SrGSnfXoCk1Am8OrXoz9JENkpmOnrXQWph8PtkcxiZCRPZzvzPhB?=
 =?us-ascii?Q?yEVBy4fMockod1bF9NK9cIW2wePk0MKE9wS/8fQZVa/hSXdxacmDnmEk40il?=
 =?us-ascii?Q?+j1lJcHi3YAEWDnrAQyhLRY51eR39VMeHPnbnqvdayNck1i+hOArzSV0Xay0?=
 =?us-ascii?Q?X4hISPhERRJha613KryxBBLjeRNYTVEaQkFzGRRClGDVfXrRhDlxDCPJjAsH?=
 =?us-ascii?Q?iEIIhqUW66ZJd+Mz02nxBFG+YCRw7Zjyalb0ZUiubcoLv83w63e63nQLB/Zo?=
 =?us-ascii?Q?XvWE+KjQZPVvn7oKbbaECq7INo+8lsl8QVXEpXDRmV/nKZDE7ynejWHEl0LX?=
 =?us-ascii?Q?Vi96IFBEVCYuRYYMNhdNO8HbdVFAZkvJ9hImJfKK9JDpn535Y9C1M7xO6r/D?=
 =?us-ascii?Q?MuaFgvLiI3sjIYjW22jvYQnci0OXuKNkoS6K5tgxPYQ2Y7bu1pKFLpriBY0v?=
 =?us-ascii?Q?iLEqaXSIRNSF7Ft9Tj961+FrdByY7XTRDn0S2Jz6i2AemaCGYYvTXgBNx5LL?=
 =?us-ascii?Q?4cyo+d8D3Kau8LtQwdHX2k5HoE9KxpQYv4eUJ4dMLXC70UxTB4uM6/OcyM6E?=
 =?us-ascii?Q?cE1eeWqOR2MsuCcCERle90U1jmB9HpuALkgxKYwAB5Qp8yRb4jJ13+wcA8sf?=
 =?us-ascii?Q?U7WRB9PxLDWY7E/sSmHNID97MAreXX12P9cBFFFGAad/yIKm4FhCMWTdSHeh?=
 =?us-ascii?Q?aPi7j+6xNq3NJfF75RSE5SY=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 199da4d0-fd7d-4467-caa6-08da017c4587
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 03:24:08.3102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: txzlPJr/mOnpO7TIzpkQNf2psXgzB5Ux+HFN29OOaCQM/aJPtSj5OIIUGz87UgKDNNv/DUr1iETomf+9mTvrpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK2PR06MB3619
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the array_size.cocci warning in tools/testing/selftests/bpf/

Use `ARRAY_SIZE(arr)` instead of forms like `sizeof(arr)/sizeof(arr[0])`.

syscall.c and test_rdonly_maps.c don't contain header files which
implement ARRAY_SIZE() macro. So I add `#include <linux/kernel.h>`,
in which ARRAY_SIZE(arr) not only calculates the size of `arr`, but also
checks that `arr` is really an array (using __must_be_array(arr)).

Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
---
 .../selftests/bpf/prog_tests/cgroup_attach_autodetach.c     | 2 +-
 .../testing/selftests/bpf/prog_tests/cgroup_attach_multi.c  | 2 +-
 .../selftests/bpf/prog_tests/cgroup_attach_override.c       | 2 +-
 tools/testing/selftests/bpf/prog_tests/global_data.c        | 6 +++---
 tools/testing/selftests/bpf/prog_tests/obj_name.c           | 2 +-
 tools/testing/selftests/bpf/progs/syscall.c                 | 3 ++-
 tools/testing/selftests/bpf/progs/test_rdonly_maps.c        | 3 ++-
 tools/testing/selftests/bpf/test_cgroup_storage.c           | 2 +-
 tools/testing/selftests/bpf/test_lru_map.c                  | 4 ++--
 tools/testing/selftests/bpf/test_sock_addr.c                | 6 +++---
 tools/testing/selftests/bpf/test_sockmap.c                  | 4 ++--
 11 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_autodetach.c b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_autodetach.c
index 858916d11e2e..9367bd2f0ae1 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_autodetach.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_autodetach.c
@@ -14,7 +14,7 @@ static int prog_load(void)
 		BPF_MOV64_IMM(BPF_REG_0, 1), /* r0 = 1 */
 		BPF_EXIT_INSN(),
 	};
-	size_t insns_cnt = sizeof(prog) / sizeof(struct bpf_insn);
+	size_t insns_cnt = ARRAY_SIZE(prog);
 
 	return bpf_test_load_program(BPF_PROG_TYPE_CGROUP_SKB,
 			       prog, insns_cnt, "GPL", 0,
diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_multi.c b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_multi.c
index 38b3c47293da..db0b7bac78d1 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_multi.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_multi.c
@@ -63,7 +63,7 @@ static int prog_load_cnt(int verdict, int val)
 		BPF_MOV64_IMM(BPF_REG_0, verdict), /* r0 = verdict */
 		BPF_EXIT_INSN(),
 	};
-	size_t insns_cnt = sizeof(prog) / sizeof(struct bpf_insn);
+	size_t insns_cnt = ARRAY_SIZE(prog);
 	int ret;
 
 	ret = bpf_test_load_program(BPF_PROG_TYPE_CGROUP_SKB,
diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c
index 356547e849e2..9421a5b7f4e1 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c
@@ -16,7 +16,7 @@ static int prog_load(int verdict)
 		BPF_MOV64_IMM(BPF_REG_0, verdict), /* r0 = verdict */
 		BPF_EXIT_INSN(),
 	};
-	size_t insns_cnt = sizeof(prog) / sizeof(struct bpf_insn);
+	size_t insns_cnt = ARRAY_SIZE(prog);
 
 	return bpf_test_load_program(BPF_PROG_TYPE_CGROUP_SKB,
 			       prog, insns_cnt, "GPL", 0,
diff --git a/tools/testing/selftests/bpf/prog_tests/global_data.c b/tools/testing/selftests/bpf/prog_tests/global_data.c
index 6fb3d3155c35..027685858925 100644
--- a/tools/testing/selftests/bpf/prog_tests/global_data.c
+++ b/tools/testing/selftests/bpf/prog_tests/global_data.c
@@ -29,7 +29,7 @@ static void test_global_data_number(struct bpf_object *obj, __u32 duration)
 		{ "relocate .rodata reference", 10, ~0 },
 	};
 
-	for (i = 0; i < sizeof(tests) / sizeof(tests[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		err = bpf_map_lookup_elem(map_fd, &tests[i].key, &num);
 		CHECK(err || num != tests[i].num, tests[i].name,
 		      "err %d result %llx expected %llx\n",
@@ -58,7 +58,7 @@ static void test_global_data_string(struct bpf_object *obj, __u32 duration)
 		{ "relocate .bss reference",    4, "\0\0hello" },
 	};
 
-	for (i = 0; i < sizeof(tests) / sizeof(tests[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		err = bpf_map_lookup_elem(map_fd, &tests[i].key, str);
 		CHECK(err || memcmp(str, tests[i].str, sizeof(str)),
 		      tests[i].name, "err %d result \'%s\' expected \'%s\'\n",
@@ -92,7 +92,7 @@ static void test_global_data_struct(struct bpf_object *obj, __u32 duration)
 		{ "relocate .data reference",   3, { 41, 0xeeeeefef, 0x2111111111111111ULL, } },
 	};
 
-	for (i = 0; i < sizeof(tests) / sizeof(tests[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		err = bpf_map_lookup_elem(map_fd, &tests[i].key, &val);
 		CHECK(err || memcmp(&val, &tests[i].val, sizeof(val)),
 		      tests[i].name, "err %d result { %u, %u, %llu } expected { %u, %u, %llu }\n",
diff --git a/tools/testing/selftests/bpf/prog_tests/obj_name.c b/tools/testing/selftests/bpf/prog_tests/obj_name.c
index 6194b776a28b..7093edca6e08 100644
--- a/tools/testing/selftests/bpf/prog_tests/obj_name.c
+++ b/tools/testing/selftests/bpf/prog_tests/obj_name.c
@@ -20,7 +20,7 @@ void test_obj_name(void)
 	__u32 duration = 0;
 	int i;
 
-	for (i = 0; i < sizeof(tests) / sizeof(tests[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		size_t name_len = strlen(tests[i].name) + 1;
 		union bpf_attr attr;
 		size_t ncopy;
diff --git a/tools/testing/selftests/bpf/progs/syscall.c b/tools/testing/selftests/bpf/progs/syscall.c
index e550f728962d..62e6fa49a4ab 100644
--- a/tools/testing/selftests/bpf/progs/syscall.c
+++ b/tools/testing/selftests/bpf/progs/syscall.c
@@ -6,6 +6,7 @@
 #include <bpf/bpf_tracing.h>
 #include <../../../tools/include/linux/filter.h>
 #include <linux/btf.h>
+#include <bpf_util.h>
 
 char _license[] SEC("license") = "GPL";
 
@@ -82,7 +83,7 @@ int bpf_prog(struct args *ctx)
 	static __u64 value = 34;
 	static union bpf_attr prog_load_attr = {
 		.prog_type = BPF_PROG_TYPE_XDP,
-		.insn_cnt = sizeof(insns) / sizeof(insns[0]),
+		.insn_cnt = ARRAY_SIZE(insns),
 	};
 	int ret;
 
diff --git a/tools/testing/selftests/bpf/progs/test_rdonly_maps.c b/tools/testing/selftests/bpf/progs/test_rdonly_maps.c
index fc8e8a34a3db..a500f2c15970 100644
--- a/tools/testing/selftests/bpf/progs/test_rdonly_maps.c
+++ b/tools/testing/selftests/bpf/progs/test_rdonly_maps.c
@@ -3,6 +3,7 @@
 
 #include <linux/ptrace.h>
 #include <linux/bpf.h>
+#include <bpf_util.h>
 #include <bpf/bpf_helpers.h>
 
 const struct {
@@ -64,7 +65,7 @@ int full_loop(struct pt_regs *ctx)
 {
 	/* prevent compiler to optimize everything out */
 	unsigned * volatile p = (void *)&rdonly_values.a;
-	int i = sizeof(rdonly_values.a) / sizeof(rdonly_values.a[0]);
+	int i = ARRAY_SIZE(rdonly_values.a);
 	unsigned iters = 0, sum = 0;
 
 	/* validate verifier can allow full loop as well */
diff --git a/tools/testing/selftests/bpf/test_cgroup_storage.c b/tools/testing/selftests/bpf/test_cgroup_storage.c
index 5b8314cd77fd..d6a1be4d8020 100644
--- a/tools/testing/selftests/bpf/test_cgroup_storage.c
+++ b/tools/testing/selftests/bpf/test_cgroup_storage.c
@@ -36,7 +36,7 @@ int main(int argc, char **argv)
 		BPF_MOV64_REG(BPF_REG_0, BPF_REG_1),
 		BPF_EXIT_INSN(),
 	};
-	size_t insns_cnt = sizeof(prog) / sizeof(struct bpf_insn);
+	size_t insns_cnt = ARRAY_SIZE(prog);
 	int error = EXIT_FAILURE;
 	int map_fd, percpu_map_fd, prog_fd, cgroup_fd;
 	struct bpf_cgroup_storage_key key;
diff --git a/tools/testing/selftests/bpf/test_lru_map.c b/tools/testing/selftests/bpf/test_lru_map.c
index 6e6235185a86..563bbe18c172 100644
--- a/tools/testing/selftests/bpf/test_lru_map.c
+++ b/tools/testing/selftests/bpf/test_lru_map.c
@@ -878,11 +878,11 @@ int main(int argc, char **argv)
 	assert(nr_cpus != -1);
 	printf("nr_cpus:%d\n\n", nr_cpus);
 
-	for (f = 0; f < sizeof(map_flags) / sizeof(*map_flags); f++) {
+	for (f = 0; f < ARRAY_SIZE(map_flags); f++) {
 		unsigned int tgt_free = (map_flags[f] & BPF_F_NO_COMMON_LRU) ?
 			PERCPU_FREE_TARGET : LOCAL_FREE_TARGET;
 
-		for (t = 0; t < sizeof(map_types) / sizeof(*map_types); t++) {
+		for (t = 0; t < ARRAY_SIZE(map_types); t++) {
 			test_lru_sanity0(map_types[t], map_flags[f]);
 			test_lru_sanity1(map_types[t], map_flags[f], tgt_free);
 			test_lru_sanity2(map_types[t], map_flags[f], tgt_free);
diff --git a/tools/testing/selftests/bpf/test_sock_addr.c b/tools/testing/selftests/bpf/test_sock_addr.c
index f0c8d05ba6d1..f3d5d7ac6505 100644
--- a/tools/testing/selftests/bpf/test_sock_addr.c
+++ b/tools/testing/selftests/bpf/test_sock_addr.c
@@ -723,7 +723,7 @@ static int xmsg_ret_only_prog_load(const struct sock_addr_test *test,
 		BPF_MOV64_IMM(BPF_REG_0, rc),
 		BPF_EXIT_INSN(),
 	};
-	return load_insns(test, insns, sizeof(insns) / sizeof(struct bpf_insn));
+	return load_insns(test, insns, ARRAY_SIZE(insns));
 }
 
 static int sendmsg_allow_prog_load(const struct sock_addr_test *test)
@@ -795,7 +795,7 @@ static int sendmsg4_rw_asm_prog_load(const struct sock_addr_test *test)
 		BPF_EXIT_INSN(),
 	};
 
-	return load_insns(test, insns, sizeof(insns) / sizeof(struct bpf_insn));
+	return load_insns(test, insns, ARRAY_SIZE(insns));
 }
 
 static int recvmsg4_rw_c_prog_load(const struct sock_addr_test *test)
@@ -858,7 +858,7 @@ static int sendmsg6_rw_dst_asm_prog_load(const struct sock_addr_test *test,
 		BPF_EXIT_INSN(),
 	};
 
-	return load_insns(test, insns, sizeof(insns) / sizeof(struct bpf_insn));
+	return load_insns(test, insns, ARRAY_SIZE(insns));
 }
 
 static int sendmsg6_rw_asm_prog_load(const struct sock_addr_test *test)
diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 1ba7e7346afb..dfb4f5c0fcb9 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -1786,7 +1786,7 @@ static int populate_progs(char *bpf_file)
 		i++;
 	}
 
-	for (i = 0; i < sizeof(map_fd)/sizeof(int); i++) {
+	for (i = 0; i < ARRAY_SIZE(map_fd); i++) {
 		maps[i] = bpf_object__find_map_by_name(obj, map_names[i]);
 		map_fd[i] = bpf_map__fd(maps[i]);
 		if (map_fd[i] < 0) {
@@ -1867,7 +1867,7 @@ static int __test_selftests(int cg_fd, struct sockmap_options *opt)
 	}
 
 	/* Tests basic commands and APIs */
-	for (i = 0; i < sizeof(test)/sizeof(struct _test); i++) {
+	for (i = 0; i < ARRAY_SIZE(test); i++) {
 		struct _test t = test[i];
 
 		if (check_whitelist(&t, opt) != 0)
-- 
2.20.1

