Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF84E4D1332
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 10:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345284AbiCHJU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 04:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiCHJU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 04:20:26 -0500
Received: from APC01-HK2-obe.outbound.protection.outlook.com (mail-eopbgr1300139.outbound.protection.outlook.com [40.107.130.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF433C4AA;
        Tue,  8 Mar 2022 01:19:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQ43dLyoIacOEjQtwWfPdog1pg/vq7Wiq0jzNT0oZgYFeUXrqPZOgeEufEo0TjDEwhc3NdzRt4W4d+hNyySYLzVkqw5kJC2QqInp8dQ04EkHjEFXWPns/IC8zvT0mk2Jzy7zJ1lOeAPsh/NSDqfzl1GaloMcZiGDfTNftd0JQOjaLjS8RWVNB1njCdLZ2/Gub+3y6qnXLCrj0tqy4ntMSpdPaO/MX64Qk0wYvJNz9CmE2JsSIcmHaOrL449zDV9HonS0mVyRx1lSyqpbpre8vQvc7r+HCCW5H8+jQxQSAAByQwaB39/dgc0K9hEJkPM8eGmIAggHzdeLK94h2kJ+ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B2fm1DUHsShRO6Hi66j2UJkZJ/7+rf5jNp4kNTlK+zs=;
 b=A+YuYhj81EYETmdU+lgs2LzirWuuWHRl5S9s3ZZgDdiZeklfFkDIAEr7HGoUe6PbrwUAs80dYBIs170i8ywMyBK3i+ImsfZ0O9Sow8Vn0RmnNNt07QXeBQNNpG5EjWLTgdjl80IKIBfiMsMeF7wh/Dmy63w+VQXVMFrB4qMF8zE0mo/lWhnikMxrjQvWPZ1Jm6EInzSXJv1fIDlIVrS+C7ND3HxV/2ZqqpYkuQPz1ieiSg7yc45XZ7nKzIz9L4lOAGGMeGk0KTGvxehanYLsfr4F/5qNENdL6erFpi8BnLWdDf7ArU5LMOr4ynwjh3OZQCqt6t/NpwXssHn8yS4vSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B2fm1DUHsShRO6Hi66j2UJkZJ/7+rf5jNp4kNTlK+zs=;
 b=GWuvbLb8wc1GJ4Hgo92QEBUbgFHOk9VMTRFFaHDH2kJNPT4u9YK8ywK8vPU4hT2LPB5TBWBLf/lrExazi/Vfqj9RvuJgBSdm7Cr5MbP8wDRowDMLEwUUsrcEuyQuMn0O9Neazgw8XR3KoFl2hkGLqgWJYBBaSv/fJ+lAaL/G35g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by TY2PR06MB3423.apcprd06.prod.outlook.com (2603:1096:404:108::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Tue, 8 Mar
 2022 09:19:26 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59%5]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 09:19:26 +0000
From:   Guo Zhengkui <guozhengkui@vivo.com>
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Guo Zhengkui <guozhengkui@vivo.com>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Yucong Sun <sunyucong@gmail.com>,
        Christy Lee <christylee@fb.com>,
        Delyan Kratunov <delyank@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK),
        netdev@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        bpf@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        linux-kernel@vger.kernel.org (open list)
Cc:     zhengkui_guo@outlook.com
Subject: [PATCH] selftests/bpf: fix array_size.cocci warning
Date:   Tue,  8 Mar 2022 17:17:08 +0800
Message-Id: <20220308091813.28574-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR03CA0055.apcprd03.prod.outlook.com
 (2603:1096:202:17::25) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 943fd36e-f9ee-4cd3-d8c7-08da00e4bdfa
X-MS-TrafficTypeDiagnostic: TY2PR06MB3423:EE_
X-Microsoft-Antispam-PRVS: <TY2PR06MB3423D08C128BE4F851C496C9C7099@TY2PR06MB3423.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hcy+Qpyseuin8FF9ZSmDDPRlvpIRostnBI4gC77WTGRrpcCXZEKwsuIAycmUI4UPbmOwVbk3/nZD9QSx0+P/6vzinhkq2sVLymqg7OY7OZE1cya0FyyMXHFU9QaJMPNenIueH4FKladtlhoh9Qpo5E1ueYC1kLI8XpnfINXSuNW05Uj716TtPtqvXDUglvkSq42qTLSb9FkSutJOMKOgGvHDCN27Z/lZvSGi5wl3/kTBZa1Ssw/Z/rq7AenLQrmUEeP2zA1H4pZcYYFLRan5IcBN++uC+JW6Vy97+AIuwaFlaC3J6PKlCc4IGnIGYEQXpC7aNBc99H7RqLlmBfTzgKLoI0Xr/Akkt6seDswQSGWVoXLI1yYvmGatkrWDoV4PzdkXCq5yBS6hfISuPwfgC3EmCpJPz0MYIuYLs32geF3OaS4TuO7H2R5iLXkQEjSkGfkCVoOmRHtVWNnl3WLTCqIWwBhhyHhVX+Wyrl/ZY4K7tl3An8QkVLrSHvp7rpidtTKbRpsMUKhHm6Iq7g86WgEChRfaxMiaFmfk/lj+6P7wjoV9pGTRuWv6rfWxBUqpsXHwZuToBCV6wUsF8tNQTbJ0/aD/F3AdTxL3VyxPHEU/hdQS6fCl63OtdlVWgTJsRfpE2hASzy2KY2jEgvKkFVk/8tk+HZd0HuqRs8f996Ypn/AMVkV/U636OhrgqGSsSoOkWD+MCdGsQN8P0mfqiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(508600001)(5660300002)(6666004)(86362001)(6506007)(52116002)(7416002)(83380400001)(6486002)(8676002)(66556008)(66476007)(36756003)(66946007)(26005)(1076003)(38100700002)(38350700002)(2616005)(186003)(316002)(6512007)(110136005)(8936002)(921005)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MQ6eV92Vg4G1VUSiP9D+cbL0d/eGsJ+d3tNmizBIWxPdQjIOer+KkYVpAs3n?=
 =?us-ascii?Q?qSiU2SF+rksWFdVSBoTy4L0SiTkBAdBMKMiKS+MNYeEhHthj8RI1oxA0UHt0?=
 =?us-ascii?Q?7GSFEsyDpxuNaLLNBPnOqF8LmyejVNMqJxixTiTZEe4q2Ql8GuSjXRpD0J9o?=
 =?us-ascii?Q?i9XQ4IJ2NV9r9k9M5bqop13rSbub9g5F5M+Fyxs6RtnMQ+kNSnGhSs0iAxS0?=
 =?us-ascii?Q?ZJlo5eld/yvknSAWPBUEQloUosL0hXfhnwzy+5dKsJ2o2trWNczOcHBuY16v?=
 =?us-ascii?Q?B6u0QSH/7k1xDxndDEH/cefJiM4pCgwm7ujk/pfGb6IlJ4KENEb8AGVTIpm0?=
 =?us-ascii?Q?hmgSgoDtGJPhqwIuyWAMkKq/gG2J6TbV01MEqcZHqFsqbZsOIiuLUFyUN5VW?=
 =?us-ascii?Q?QcmVT4NQfg9s+JVwhipkexP36slxrovIruXozDqgJ9dlVkSMcwm2Y/Md59RI?=
 =?us-ascii?Q?+a6ASW6sqY1XwDKDwNHal/j/+FceTUTxAWpj9shmU4f6d0ZEUOJAMq1ododS?=
 =?us-ascii?Q?l9P4+W/gWdOG3jGPPJe/tcABbJhW2ERUOd6++unrMCjXW/oJ11oiDKpdoOic?=
 =?us-ascii?Q?WENGz8mNs+eOXYgaonKWFrY8Zo7vyUdXduHWUPnnTDSH8OLehkFoLi3xKA73?=
 =?us-ascii?Q?Z3ydzbkiHOtGBiK+tEY39+htee+Uhj8vEgXFW1DbvKyzZOANTnyogicj3BmW?=
 =?us-ascii?Q?B9THcuHadWt6A4JdA5dKvvs/7S24y+EmAYLt6Dj/0c/duND9SEAIWWg5+mQn?=
 =?us-ascii?Q?oBDf2PGB1PEQfhZBD6Qq1qiETVGvP6HjZwDft/P+JHzcH0NGVK98k8Cva/K/?=
 =?us-ascii?Q?lZu28+8nxslSiZbnTwKpz1XYWh/pWhChc+a+FlygqFj0irViEefxmXuxxDeX?=
 =?us-ascii?Q?hjogqGJwhM1D5M6doFovDXy8HKV3p/KWiDq/WlxsJt2sMkbFxysZyF0tn15X?=
 =?us-ascii?Q?kY0wE5SgBgMmMkO52oPJtk1f0DHyhC61PFN+8uF9twytm1FMTNBcPi8Xyfjz?=
 =?us-ascii?Q?FwCaRWg7MDDQzTrdnCfWYB5mr5kAgvBZuKzMgt8dAYNjFRujknVHvz2nHcVT?=
 =?us-ascii?Q?JsP498KPyZZ/AwIAZkhxd9EOeLw9i85Pao0DFFZu366pJjRZIIzT879r18AI?=
 =?us-ascii?Q?oI5G+WqBY5ArxVDxye+ryOv6VvV6EbjauIVximD5CUS0+YM5H1uPl2HR7Nyc?=
 =?us-ascii?Q?NxU23FLwWrnmycLzNiWc2l1aJweh/47daBQFQwspmzrJokUWiA1HomFFfSG8?=
 =?us-ascii?Q?e1l3xmRcyeuVYeEOJTG4Bz7I5Mfpr3Gla+mVtLAwIahOS3S4OnxzjK89htsc?=
 =?us-ascii?Q?CSfGepmy/9IYC28cdt51sxtY6qpoHB6i9WTWNqB5RwHDla/48Wc2MhJk4N0m?=
 =?us-ascii?Q?guP9BqdVxwTc1HkXhpPlpm0aipWpWvYzphQ+tYyJBwHNq0KEQXOhq+C6q8LJ?=
 =?us-ascii?Q?u5Sr9h6f9kZJmo+b12jozgxMcKCT5r/69rEW735Oe0T/DH4QimKjF6Wo9VHg?=
 =?us-ascii?Q?nbiFVdq0sWtsFZD75Ok3btZaYA5uCxVO65YEiKeV5lXDFXasob92nqhjB7fQ?=
 =?us-ascii?Q?8VBBFtTWORsHRbqr1Od0UQRrmlwAquZsvs2X866/xyF9LHPqOfIf8JEx6UMd?=
 =?us-ascii?Q?9rKwX5CeKN/whd2MLNGqsRU=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 943fd36e-f9ee-4cd3-d8c7-08da00e4bdfa
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 09:19:26.7942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K8X87C3V5eFg1sE7XLbuhqx8zP40+ecGFP9Zx5Cs7YNPK08lsCMZsa2P47QQ9lIB/xuYVB8n79FvS7xBod1yLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR06MB3423
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
index e550f728962d..85c6e7849463 100644
--- a/tools/testing/selftests/bpf/progs/syscall.c
+++ b/tools/testing/selftests/bpf/progs/syscall.c
@@ -6,6 +6,7 @@
 #include <bpf/bpf_tracing.h>
 #include <../../../tools/include/linux/filter.h>
 #include <linux/btf.h>
+#include <linux/kernel.h>
 
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
index fc8e8a34a3db..ca75aac745a4 100644
--- a/tools/testing/selftests/bpf/progs/test_rdonly_maps.c
+++ b/tools/testing/selftests/bpf/progs/test_rdonly_maps.c
@@ -3,6 +3,7 @@
 
 #include <linux/ptrace.h>
 #include <linux/bpf.h>
+#include <linux/kernel.h>
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

