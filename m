Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A7B4D276A
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 05:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbiCIDhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 22:37:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbiCIDhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 22:37:04 -0500
Received: from APC01-HK2-obe.outbound.protection.outlook.com (mail-eopbgr1300110.outbound.protection.outlook.com [40.107.130.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3809BA0BFA;
        Tue,  8 Mar 2022 19:36:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJjvjzkpu7w/cvN+J9QqpRRZbW0LyU/IsKXdBfmWaxCxnqxYnQ/BFnBRIW1NFcqK/IPF7fcJplCOgC7FGtuLrfFmSibSjyjwtMHAT8wZalWUYdPOqjTO5tsqZhzepRYFjRfcxgeX2EuM1SfUYdvLRxdwxY27Xc8NpH7viL6jbrDXL/sNxGl7jgR275E/9s00ihV0YwZOOfmiz//5eN/pLC+0R3sRYfQK717XRNxSaehfopDTT7/X67O9ov9WuI/u0+Y9RvJkUPmJMOQ9ER4QGF/p8kn+VJGs0PJFac5C+NVhGefgvYaElwdTPFopquzy74S44OgPvyIJzDOTGrnEKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4HjnWvRWyaI2fkMBJn7vzTiLupYSN9oMxBEiWwLb5JA=;
 b=Qu7grFPOqkp+a8UcM46TFl6kXEnPmkd1XiVbYCn2SzKNO7bORBJRP7rXrBe65N7Gz19rHi+Z0nOBQTHdcTLsCiwEz76ODHhDdWxeOheaaZ4wBMUyzt4hPi4JlK23T2WaPtajZuJXdyYqCKrqnje+bMpFQqdEHJTWpUgC6Zi112o6jXWCqsrEr3332AeT36fHZZYAOgayPrj01JYENkY8TWmp2GF9RLYev6klKFyVfOUdA4DFfSHV0KC5Y2rUR9AbHBHGpXavGul+bzPRZgTh3xhrqNIJjZcXLtawyKDr9vfgbHy5NPj52bOS8mZcPp1o7WZmV3ZW9d0ZszqBufIbsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4HjnWvRWyaI2fkMBJn7vzTiLupYSN9oMxBEiWwLb5JA=;
 b=XZjn49SET4V8+jp/ALEmxpS9SsEJmZpuhkc7otg1m3jm1e48uJNRqnTExh5uBnL3aRZVbHKYK0Vgh+trH2NeTmbwkptxPcMTVOGtASftlHnaRkvtlqZUx3YSZhsTJHo70511M0CnvAs8jmyoK4VWuXG26a4e+U8Sath9vNvqoN0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by KL1PR0601MB4113.apcprd06.prod.outlook.com (2603:1096:820:31::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 03:36:02 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59%5]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 03:36:02 +0000
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
        Christy Lee <christylee@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Delyan Kratunov <delyank@fb.com>,
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK),
        netdev@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        bpf@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        linux-kernel@vger.kernel.org (open list)
Cc:     zhengkui_guo@outlook.com
Subject: [PATCH v2] selftests/bpf: fix array_size.cocci warning
Date:   Wed,  9 Mar 2022 11:35:04 +0800
Message-Id: <20220309033518.1743-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <b01130f4-0f9c-9fe4-639b-0dcece4ca09a@iogearbox.net>
References: <b01130f4-0f9c-9fe4-639b-0dcece4ca09a@iogearbox.net>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0037.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::6)
 To HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e733231-c39f-40cc-2ad2-08da017def45
X-MS-TrafficTypeDiagnostic: KL1PR0601MB4113:EE_
X-Microsoft-Antispam-PRVS: <KL1PR0601MB4113C6A08343490DDF00A9FEC70A9@KL1PR0601MB4113.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: trvYNtHnD4ERun9YMUWTKR6uz7wO1cMl+YhTILAUf6YCtkNfaqVBjH4gS6ix5cLaMHDUkMebLeo6v2IPC45PJYFaMIq/eersjr/jTbzR1RjZye7E5uPp6z0ePmGww8P7/yq5sWCEcLmbmAuU3FMgX/LwrZWa8FEXg6EBiBDSRhwkWR/A+GBGUvUjENbBJbkVjbiqV1whXy7l1N4y8wiT559/mSfyzUlofdhHoP3mXzkGuumQ8v7W04qVpnjlh2/oP4YTgBvke99mMdvycXpR+0NanmFYV3dltyGXKt+BqWKgUrgH7FofhvJYur2AlGpz0CnxmMFoXQwaiyRUL4l4o71GXBMcu6jci7eyG4/Bm3lztDEfz5a5G9/+lqGLVax0LR/fdnE4FX8CyMwAL1cK5/TZkBas90q4Wsldd5AHlc94nMb5owxswiUTwW3ztMue0UvxUzahxd31ldj0C01OHLp2odwri2AAvy/e1TkRA97YYX/BqaFCOlHRSIV0tusIxi4TqOT9aZU6o4K7zw5H9Nv8yMWm2gqCQp0Y/TsvZddW4PnPj0t3u7ij6CPXMg7U8ZtKoUwaWwVC5ixVZJ8OaVxU9+OPK861wzy8smmRQ0YWPGQR8xgwi+tCqVDli0oHYy/PX3dvjM23wZxHN5AO/k2iN797zvhHSEkJpGaDnZwO27iU2Odn0f/Z7Ygw3u60lu+xPPnWdDTXvi4bEn/S5FiGxkiQ/DmmHAeF3O9rCKA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(6512007)(508600001)(5660300002)(38100700002)(38350700002)(2616005)(7416002)(1076003)(921005)(186003)(26005)(52116002)(66476007)(6506007)(8936002)(86362001)(83380400001)(36756003)(316002)(110136005)(4326008)(8676002)(6486002)(66556008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ggpg/xyf/LW98quWLOTyOrIflSe2g4vh1415L4uYPqm0Y/AUW49LwqXH+QY6?=
 =?us-ascii?Q?EwqR6AUQEpK7EmWOi6pHbSyTT42D8TqwcqYePyKXGongo50ktER7geJSm7Y3?=
 =?us-ascii?Q?3GLhCPEBISH42ByA6rQpAJT4gK9OPG1y4gNTMJLLN6eoolMNUjwEWm/amBvq?=
 =?us-ascii?Q?bb2ZCHeZmKctxUIvxUSBEhBkn9Tk4Y9r0XkFfTSfW6KGin8Ze13ODkEhitH6?=
 =?us-ascii?Q?srBYin5mL6Ex2gdVwkGlXu1esAd4SCg5DXkmbxOFEKry2N1k+v+WEL6hHU76?=
 =?us-ascii?Q?L6mQqgGonsx1dzNTpWzcq0YFlkkWYcl5M3DL/aa9IucxkGUJPAZU/PLj75Hm?=
 =?us-ascii?Q?ToloprORJ7rvVDgid40bfj+0/zu9DE5t1CcEbYEgJwJd0neRpUXGFDkZhvEC?=
 =?us-ascii?Q?uER38DHINcjPcedlTd6uV/WX1FIsVJTxH6ex9c37tFUA1RtouqBFbSlcWEsk?=
 =?us-ascii?Q?qzWAivQjBaceVf2igXbYVQVs0w2i3V+67Cl1TWLsKzDH/NsyCNWIWPEvWXvQ?=
 =?us-ascii?Q?7iQxq8vZV613r6Vuq4aGdHyAFM/71TJN9uCCcWEmf0h1mxinclXxzYcti2yN?=
 =?us-ascii?Q?VaoStRmJptrsYEt0IhwA7bjwOv9kEL335zrE1gkNRk+Wu6gRBaldzRfPg/T1?=
 =?us-ascii?Q?82RA/LlV/7KXbyh7cwZ6jCDjYGTB2kS7wYg9f2143b1q8eLiiIvP+xsf0nN7?=
 =?us-ascii?Q?V9d3MNGmpQ6adEthovvaSmwAJKR124L88b1sW9LQNuwCxB3lni4GYuX5mQ3y?=
 =?us-ascii?Q?KJvT6b3M8UYoZAMJC1IQJNM1uYrMLy3wt10eU3Wz+rfLzFbLB7SopPeCXIXL?=
 =?us-ascii?Q?4B1/lHcYUngOf5romqzFKEKgBRfY20EJS1SRHs/xaFccOItM0BzFQBTw4Tkl?=
 =?us-ascii?Q?fkvJUebw1cQT7fNihuKrPBjqqqaCgkf6na71mfn9NNgSMimoPDyS3qtT7z6Q?=
 =?us-ascii?Q?8R9v9mv4EgkagIhMjTwdtbMk9e6r2A14C8OrfqTzU7BdNkh7/6nVAZX1cNf+?=
 =?us-ascii?Q?2wtn2bI/A+WjtXRrATLVzrpktTr3KQl6FsaoI4Cv0OTLdl0u5fQf9cIVGtsR?=
 =?us-ascii?Q?uU80MsgrndsxDaU8qXJT1YbT5GVa47N6UjRArSWl8kRQk5cLUkktBkqijRXV?=
 =?us-ascii?Q?Dqhnypb4m1CfqjzK29qPuHPaPYCkq+cIvqRDHU3A5u1zl/lHJTmybUIkHVee?=
 =?us-ascii?Q?jj1LbeuzllwjMfxn9dpV45VKbwx+wQx3Q9RDGVu2m14GS+o1T2B00bmUx8aQ?=
 =?us-ascii?Q?3Qjt6h4N8HXC1bOT/Huivx2leOmRQhOnwihw7HnmnTz7flTrQv+EDh8gPEXM?=
 =?us-ascii?Q?oxABY9VhS+pWYy1khPT8VxReoZWAvaiGeVj9ydNISqq2m9X8e6r7ft0vwD4l?=
 =?us-ascii?Q?as8/qZJhkXUgzWhFYlWuLxmn0tEqkDxbhB4u5SNPX7N48fOBx96ibR75R0N6?=
 =?us-ascii?Q?E3H2/HIMoy6Hrczq7tSqsCI8dLO6uFcS0j24nNk3GjhzzN22cv/M4lqBz6J4?=
 =?us-ascii?Q?Aj30wocs0o6N9AXwfov3O0GpkaE6p1NgvRRQP17C0S3EMzSIT9rj/hpUM401?=
 =?us-ascii?Q?qMRZrc7IJqVtsfi094gES7u96m7qXpcKWe0wUvbUs7PH1yGajy4kpWjEeQMq?=
 =?us-ascii?Q?1SfJlg7lIH94tQd6O1qJIbc=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e733231-c39f-40cc-2ad2-08da017def45
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 03:36:02.5673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x0z9KXLIzwgJMQ3KWzEk2nbAfewlpmMvjGx9t669ZxdVo5HeOechxZbGZ2gP/gyXLP1d9JQsZU5tcnmbf8wr3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB4113
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the array_size.cocci warning in tools/testing/selftests/bpf/

Use `ARRAY_SIZE(arr)` in bpf_util.h instead of forms like
`sizeof(arr)/sizeof(arr[0])`.

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

