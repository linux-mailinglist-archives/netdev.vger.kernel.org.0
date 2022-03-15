Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679374D9BC3
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 14:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348525AbiCONGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 09:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242105AbiCONF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 09:05:59 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2101.outbound.protection.outlook.com [40.107.215.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8881836B7E;
        Tue, 15 Mar 2022 06:04:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kSYUcQBgI528+6UADNk/qqWFTLoZlrN8+mp4wj+PA0F2fvbJLM+WgtqlGl2YfMvZwdZnADJsH+yOl405kXole4CWtyDIBfy2i+JPJsXJ/hBkRzfSyPSAn8EQHJuzzPkoR9MDgt5tvNGWudkVlJTYX///BJe12sYv9oELioM6DCmr7tMrqQfpChYNOgze7Y1kA9T7XOAZTtap5e+9ZORIxMUu1TW6Ex1jhfwJK8JwqMUzAvYIa3P7Ejv7pOSnBj8Dgrvm3kXH4NaPuqPrp3Ysdmn/kc6sAlCAiDg+jmSv/4YvqVcuBFQe976BZc3TQVslXV69edm/Yehmcq2fvXmunA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z4YoUmE3WzDSQZhdMQI1WpiPhAX/oDntsolql+Z8IDE=;
 b=MUMFqUcoMT99UsJ88pFyYn1qIbrouqJUPqUr4PcqlFjRRRdFxYllmCG7nQNHQZE2ua3j888jmgNiSz1Af7in8zZfVFbC1te0v6hWwIMGlj7cZj9d0qXFsI76UiGWfQ4Hv9zVHDOEQo7+rR6LsbbS6au8UopGEGobPGb56S3JvRRX6DeoSMdzOr4EmccSi9StIJDdtIMMO3isV4tfwGc2RRil4pv/EC3iTrRjLiYEDpvLFxx/XwkBaBJk7B3r9yK0b26YrR9//4L5sXNUrPOQ3/J5ChWAF+CjFW4+2dxNXcR5FJ1ol4p5O3CgiB6oIIX1zpYpv7KSXpZ5CJRHzHc+ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4YoUmE3WzDSQZhdMQI1WpiPhAX/oDntsolql+Z8IDE=;
 b=hXv+cfsIIDr+fM8famu2aSiO3I/tOUYzRgqOlLriGAaPVGnTCaKQdHqhdT+muRHQMc5dd6AfekLIsgQCL3D5VlkHDGA50OzTjIC50CNAAxGJ0SdzRcawjte7IQvrLPXKujOkZknnrDDXR0eS8TPFmUXj6A7u2iuH4TD5NAIY8JQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by SL2PR06MB3130.apcprd06.prod.outlook.com (2603:1096:100:36::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Tue, 15 Mar
 2022 13:04:41 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59%5]) with mapi id 15.20.5061.029; Tue, 15 Mar 2022
 13:04:41 +0000
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
Subject: [PATCH v3] selftests/bpf: fix array_size.cocci warning
Date:   Tue, 15 Mar 2022 21:01:26 +0800
Message-Id: <20220315130143.2403-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <ba71e22a-cf59-b2bd-50c0-d0c9fb3f4e08@iogearbox.net>
References: <ba71e22a-cf59-b2bd-50c0-d0c9fb3f4e08@iogearbox.net>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR06CA0012.apcprd06.prod.outlook.com
 (2603:1096:202:2e::24) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 269b7e0a-2655-47a4-f5b2-08da06845e25
X-MS-TrafficTypeDiagnostic: SL2PR06MB3130:EE_
X-Microsoft-Antispam-PRVS: <SL2PR06MB313050E2B045CADEF519152DC7109@SL2PR06MB3130.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BG9s+YAqoU3E1Ar1+G/4s/QKSKFJ4tBPvV7OzzV5tJtW1o8rpMxhYqojnOa3dPR76jys7TVNFXlAFRBIhTBySwCt4NFrVSdegNQp2MorA5jmU/kDuVBLaLRQ60+7co/NDEmdb+RS+rqpjj+c4hTAJUpajnvTAI99VSgfIBtqjuUjMQSvaZ1so8GVAe9YWA93qhENv8bJATxuAKEmzFUHmlV49vWt8Z1syJXFqkziyBFTtwk4SCqRclXlOOppCMlA+lSvtCac0uPAOlC4yVSRNWTZFaGhAMm6gA6++RrYiZ3XFVWrZjN2lPD10fP4yZRGG9eYiNAk59eovwb9V5mIcc9gijzPb1MHjxcsQ4pAQD5nIuG3EYL9uofa96ly+anyzR3jyM34n7/TgDmqns5sEcHam8+RzJN0Lu9UdWfwZUKwPqE9kqlvcsp7Hpq5sv2W42XY9mUSRgSN0rYuuFBK+Li1DewSw63aX7oz2lx7AdK1BAvzu5ln1K3X+gUPtjgX2QMqps5JuyI62JscRNgIPo95/0fUVrgS9K20ymcrulwYK+VCVZvC6xKdrR4Ez/r3F4mX2D6TOXQBePSq8mnYCqDq7MudH8L4csiYeCgaZamNQwUClqkuFxjIiuWxBGW89N3u0k+GO0u8XFthHoPqG1pEyaMBqA42rGsgvpqaCUR1WcKEqkQCPVAEkvunEJOy2L8WyNHOEgoigDzhaS3Ez0dPjrbjlLZqcn1Zf3YjDOU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(8936002)(5660300002)(2906002)(52116002)(316002)(36756003)(6486002)(921005)(110136005)(38350700002)(38100700002)(1076003)(86362001)(508600001)(2616005)(186003)(26005)(8676002)(6666004)(6512007)(6506007)(66476007)(66556008)(66946007)(83380400001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ScDlcFmfuefDTGoaXkAKR5P3dpp3v/LwMOwp0KGz3am+AK699UOlSCvRTD7e?=
 =?us-ascii?Q?Jxp0gd8Jdks5BvFLN5jVYAQ7wTkQbbQnKkdbSjvSwpwsXE1n9SwFdxJJBrAW?=
 =?us-ascii?Q?roj/Bo5eWIuikfUvRFAQagpGqlyInvUO2yPxzlE2PEZELLUU+g4xsPwZSe3K?=
 =?us-ascii?Q?LC4OMHRJn5Ut1r6+P0JKvtWvjebI5koxYaNGY99pu+5Z/BBuJiS1akMl1Lju?=
 =?us-ascii?Q?f9TK/BBrPNVwXK1+lltwUAkU3NcHvGF+0FoXoVHGsVKBOGhNQdNtxd/N3aGG?=
 =?us-ascii?Q?9DaaA8lzDt/KEnUWVBEUc/qCNTpgR4NzlzaziNinncSRTRuyOg7iJDWlYPlo?=
 =?us-ascii?Q?HrOaMMU5fUe9k+7AnP6BjzQUiTnQyYNgav2mvRegH4ZagTudrDwumW6JMNJ9?=
 =?us-ascii?Q?PCkuL/X3wMIwazcxmwrp4pw1fp5Dt5Cl1oh3occTLe9Ka+QrfNYaOLg2UCUw?=
 =?us-ascii?Q?q6wtAfQsjN+aTM4MFId9nOx7ujyp3ig8ilWPnSd6qyXwOedZ0HLfZzIDkULQ?=
 =?us-ascii?Q?0czhUdQgqIfHqW65vslM53YzuJIuSTiF/jksLZBjmTIvuBYHNvTmdNTmp3ML?=
 =?us-ascii?Q?yV4HFUVXds322dn6Wn8uFgjtxwbgvynDD56aL1GKdnZtohJ8MP7zINwiyXdP?=
 =?us-ascii?Q?nZ/xhvL0KsSRrhM4LjjI3LuPwTnCfG3Wtfl8gNZCVCwTHOifQzLDtIeld7ar?=
 =?us-ascii?Q?TT0Noc8+Da7elQyGRpMBxQbfo5hzgvGowk33fkOGpOrR7BE4QqTTduCvYReL?=
 =?us-ascii?Q?6I24+NOghug8xIZqJCrAWZ2Sg0xjSBUrKuzZFF22Xp6FFSm7EvPU9DHjiBOk?=
 =?us-ascii?Q?wQgREZZUa6uDSbMJKsQcNNrOfwljW4bdTSDHMcrU5Qa6CDIpwHScPujsv1lr?=
 =?us-ascii?Q?RoSrcEwxTr5u8DTkk+pOM9yTA+osPWvdB/A3xb2Dvf/yhRdzFLCxp1yO3rZ8?=
 =?us-ascii?Q?bZCP8S6L+YRW/QJzfsYpddXrUrUgLLPv48TOC9b9WGa4bDZ2XSvNqdhEZDVw?=
 =?us-ascii?Q?L88iPz2U69o5MrUPC3CM+dyv3Lz8G4yqQUVnJsksSb2QIOqPIZGpN0GlZMFC?=
 =?us-ascii?Q?SWbUM4q5Nc8o3RowholzhHbybldaOzb0snin5uVyUY5OuxJ9osoZvqbkJ0A0?=
 =?us-ascii?Q?zhMqvxBVO9P4IUPDziTXvfVeTi02dQ2CD8NhbFUSJO4zILOaU3vthZ9fowkW?=
 =?us-ascii?Q?mcfSfZnfarWQ085P1rJZsjGPWOUaHhYG87RWYehBEawVKt4gShz7Y9GJLjKI?=
 =?us-ascii?Q?Xb5hfJWW0HPxtKYPLfnH37RvSs7BW7CCwYb2Qc/zYR7OhYN+0aVSZGI+mS3V?=
 =?us-ascii?Q?iZbPtN+FG3LpbzDHBwTXa+TwPHzeQ8nkKg2kL+ziEoQPw7rG4zbRHmS83ekl?=
 =?us-ascii?Q?IWReCPQM7T+UAat44KnkveervMNlEBvOAwFryVmBpmtfPUIBIPnVwAnoJyZr?=
 =?us-ascii?Q?PMHYBA9kxZ0mRaChaFVKX5gToS2XZBqf?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 269b7e0a-2655-47a4-f5b2-08da06845e25
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 13:04:41.3529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rt2YBaY2bcZt7Lajf8MWMHp81lT8onkwHfeh/0A790GHTrNCVxdZYUT9ErBGxDxEAK2L1F1AK+Pkx9CrwYlb8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SL2PR06MB3130
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

tools/testing/selftests/bpf/test_cgroup_storage.c uses ARRAY_SIZE() defined
in tools/include/linux/kernel.h (sys/sysinfo.h -> linux/kernel.h), while
others use ARRAY_SIZE() in bpf_util.h.

Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
---
 .../selftests/bpf/prog_tests/cgroup_attach_autodetach.c     | 2 +-
 .../testing/selftests/bpf/prog_tests/cgroup_attach_multi.c  | 2 +-
 .../selftests/bpf/prog_tests/cgroup_attach_override.c       | 2 +-
 tools/testing/selftests/bpf/prog_tests/global_data.c        | 6 +++---
 tools/testing/selftests/bpf/prog_tests/obj_name.c           | 2 +-
 tools/testing/selftests/bpf/test_cgroup_storage.c           | 2 +-
 tools/testing/selftests/bpf/test_lru_map.c                  | 4 ++--
 tools/testing/selftests/bpf/test_sock_addr.c                | 6 +++---
 tools/testing/selftests/bpf/test_sockmap.c                  | 4 ++--
 9 files changed, 15 insertions(+), 15 deletions(-)

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

