Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9653C4CE84D
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 03:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbiCFCgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 21:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbiCFCgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 21:36:19 -0500
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2120.outbound.protection.outlook.com [40.107.255.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145B933E90;
        Sat,  5 Mar 2022 18:35:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KWecqnE60UjbBa80E2H2wGRyUEbovtW2zkemTxhlcw9dh2k4CpAOpOWOiwHBTrj8kXs6zJj3gziXFFh5GTUeWYAxpH+U/B+nuIioivhzlx1/nChKwmVWWY7zX45aq+IF28C4A+iuGgW0fED7KK9I750SjoXVqB5fxecP7UxLN1DIdBUlxADkbAfxOzYpqigLeqbiD6BEC5nDSY88fc8J+9xw02KIR6LmgHe84RsOwc5H7vmTvkvOnopINltfTzaj3BNLeGpAcwKwweUJAE/0C/xJotUDeBx8BoY4R27ShqyCY9cydg7ptjdO7GM+DwSLuRosmnpg7B6afGgeYUR0HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EK3GcVSh5gIrT6BVwzyWwIjMolRWX5ZJ0L7X+8UcYEE=;
 b=YoYCvFz1XMY7o46mpX3M3q2gDBRWoFyAqK6MlF9PfHY4FLHnQpRdsKtljVWvLoPT9aiXKNf+F0PFzIvgx+eyxue4Ug9E5SMxlM3Ja+MiNPlNXdcD9HuxfLt8SnI4tmNNHz1vuKCQDDRHnmYUmeuEknIFzkYjEbwZxPXx3wj6uQKnQmAx0W3/2r8FEkGttculJtcoGGz01kwM3fPW/vR63pewFxgP2tvRzMMtR1VsqvbinzIlY212ilRrmp2yE1ZnzvlMCWfhNRnjyRkAQafGW/y5R9nQMqRlqYBWX9Eoi/MXHc4tk/wtldEl5L6+jwkjLPw2foWy7aHb9lqXw/ERfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EK3GcVSh5gIrT6BVwzyWwIjMolRWX5ZJ0L7X+8UcYEE=;
 b=PfSNwb2Wemfbemj9smIHORsHQsD4Zdm/J2KACaP18rRn0IlF4i5gvUoeifZfDIxKj5eruaUPj5PxI9shCJ4NzZMgZIA7l6iZbP0xY/d/8ZyUXV6nyUexerNCPjglA9rPbE5S0IvpxdbIwWkjaxeO0q0qcVeMaOedRq/5Mm/z5Z0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by HK0PR06MB2754.apcprd06.prod.outlook.com (2603:1096:203:55::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Sun, 6 Mar
 2022 02:35:21 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59%5]) with mapi id 15.20.5038.026; Sun, 6 Mar 2022
 02:35:21 +0000
From:   Guo Zhengkui <guozhengkui@vivo.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Guo Zhengkui <guozhengkui@vivo.com>
Subject: [PATCH] libbpf: fix array_size.cocci warning
Date:   Sun,  6 Mar 2022 10:34:26 +0800
Message-Id: <20220306023426.19324-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR06CA0018.apcprd06.prod.outlook.com
 (2603:1096:202:2e::30) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1059118c-ac7f-4f28-c772-08d9ff19f58d
X-MS-TrafficTypeDiagnostic: HK0PR06MB2754:EE_
X-Microsoft-Antispam-PRVS: <HK0PR06MB2754A91E06995B37813471BEC7079@HK0PR06MB2754.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TQef+kZQDDSn0+9Qok8xvPiN4ClMc6yMqe4qyvb7bJMGlyIjpNEAUOjw6hpcEUm33LFgvnagnLPRTwYZxuc3+2RpdxcH6/Bz+euZ63K+WRubBFjyVkawkgglJMEkdX9ziWvLI1RFJlvFxbKKk2E91SKsHyWBozz4rQD5+gRjHlCMvuxwveOK49czr+EKWcm0czqOUuOhdt6N544RtyQH99hAO1WM3SV+K4FOrjIJwMaLjLXy5kky7zbSpM9Uyro64RcjRRwYmOv4VNDUr1PtSLx/cAFLOwJ7eJDcMPWqjf7B2mf8J3NLzbTw4g0PLeCzoDiA+FdXBB9GUmZquovZHK2WHGN37D+IwojtRqAy/WlWc3klQcN7Cdan9UWxVtJWfG5r2rr3x7yA8CPKBQ/vpsvsib1sRMOKmxKelr/O/VtU6v8F17sdnBK3cfN5cBGz7ydUZqMOWRbnXOTrlIurQjcZThWGwzyOq+Btn9x2BWueXn8aKcpRdSOOO2nZsPVZwhau62nJWyxmSXAA3zeejGPCqqBUp6d9U4cLJkzJrppwNpU7IlksGJ0WmWo5jKEGHuenuGX/IOA7b5KcfIqgsIL6NvbUgTCUwXDR1K66eY5GiYPc63C/bN19QfauhbftUk5yI0PlbOIZUQsF2WIADU2TOY19PYjpSESJt/IrEK1hbGx8ueAZBLp4yU4VcnWZrQ0D2mDyXgMTZwjfW1UIltsISCSRrrXBPyIxQltiX/w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(107886003)(1076003)(2616005)(66946007)(86362001)(4326008)(66476007)(83380400001)(7416002)(8936002)(38100700002)(921005)(66556008)(38350700002)(2906002)(26005)(508600001)(5660300002)(110136005)(52116002)(316002)(6486002)(6512007)(186003)(36756003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vblMEnzcxXcH05BwO/B9ZkgFn1R2PE6A+6/9xI6gpe7S8qpKzGooVbCqaMP3?=
 =?us-ascii?Q?pCCdptnWehYUweN1v1B6v1bS6y9hGDOa6H13ulqNVKAB/NEsPj9ZQpIT4s3W?=
 =?us-ascii?Q?edUD2vByqmSrMY4E1kJ5QM68TRT+iFLUV/ltnKI3HFC6SN1ud12nzWFJt076?=
 =?us-ascii?Q?ZO0Csd6OAOUyRAvpHN826kYWlOcMMwBHqCql+G5kzNzu8nr370gxzhcaQVbQ?=
 =?us-ascii?Q?j9MQHEhDEOFsmAZXOarKNFiDEYKC8kCywGiI11smep++iFN1bDQ2K9bOpp4G?=
 =?us-ascii?Q?I1PWgJuRnWWQk8EuvaytHhXtKMbzObZCsW84f1aS3BM5E3niuaNU9CKbBN+I?=
 =?us-ascii?Q?yOi97I6jasbg1tCiz+s/H6r+j8LKIm9lvEC+NvwoXj+bghI2KoFFI9b4yZEK?=
 =?us-ascii?Q?a+0nYZTIj94vcOSZQ63JaodOEgbU0CNuOFb7RzBl0arlGvi/lNfea4s1W8qL?=
 =?us-ascii?Q?A9pNVr4UKgPZIIjw9wb3Gz5DdRLxotPlcGqtlJ+tgUDzf6yDeVH7hjCejZpa?=
 =?us-ascii?Q?Q3X9UZuFFGBV+RWKb7V97K2pK8zuWfzb1RgMvJIL8VECia5GTNo5I7ORgDZ/?=
 =?us-ascii?Q?eR8rJbomNKnxpIIcfoMBI8StddaLSwjdr+x6w0xKrqo4rGvV/xihQJIJ2oYh?=
 =?us-ascii?Q?j9A1qQYUrDiKMmxf9c9nG+BeLWxHdvKsHpNtgmBA7GoGEGh5KFoDCnx6o6Lj?=
 =?us-ascii?Q?GnSTOTm9Qs2VxeR2VZfJSR5oX1s/SLWma6pN4b/KtA9sEUJIjnjJ7gtQ2cum?=
 =?us-ascii?Q?Ev8lVbIkM3wMild0NDiOf86SLgFRDWAypIkHzD29yW1llnQ+tc+NGJETtMF4?=
 =?us-ascii?Q?O8o+DleAeaHAM3GGERBArnirqFh8jXEyAZGon6qlImSALl8hvfZOm8Dl58pj?=
 =?us-ascii?Q?Mv0nq0gbOdEZ7A6DHOUM6w/V262mj1cPrMBfdkc8neiZZkfP8XH/7nyJ5AAf?=
 =?us-ascii?Q?AxgS00XdJJqoW97+0e3YHzuIZvU3VsTxxs2jjs+hYsSq026BGi0GVN1M79Gt?=
 =?us-ascii?Q?21XLXotPSqsceKlXxGPyiQ/lJ5mL311+LWJK1Dl2Mhn40zl0B0VaTy/+Y4Tj?=
 =?us-ascii?Q?XzaUv/dC1GuOyyA2E309cs2W4fXUTZ31JxDzbg9l7xLmzkcsLpN8d7Kn1nRR?=
 =?us-ascii?Q?1X+iB5Ga9eib00H/63A0lcwsichXRxmm/cvmaeYRroC1FQiV3UUM3Wl/zP1d?=
 =?us-ascii?Q?f+z5SMbrvuNHjsGLGdadLxEvnXPKVMTCeUAjQiDyp+eUbtG3fWnsj7lohbB5?=
 =?us-ascii?Q?zsXrWuCL76sEDbV87JxDPpoaXXN8/N9BSktBN7NE7Br0J+llYfboq3BTeAdk?=
 =?us-ascii?Q?gStTFSHJ4ii9Ad22wRfrJh+RzUQi4jDA7AzX/uKnb1vLWqfkQf7N9fl6bnGA?=
 =?us-ascii?Q?xhfsBBN7LPRBsWuwDIjCik9q+hfEu0AMT2zi8sDnO46pSzmL095cYBFeIL9x?=
 =?us-ascii?Q?3T6UCCFbNu5UpkH9vqW7gNiJjLgRJBaw9Lwmo35PKJEsugPdwNkrPzVJhjwe?=
 =?us-ascii?Q?0ZzQuvuo7voQ2InCwEBYKsUvz+YgEWrQXEwh0rEyt5mT+ZkpNV/kaXtYoCVc?=
 =?us-ascii?Q?JYqLxgYTciiQLL4N+kXMo2tg6HTvnlr2ZSy8pampAyVImYkDRpiL80DrFI4p?=
 =?us-ascii?Q?vV1vIGMIlgjxS71KMHEc7pQ=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1059118c-ac7f-4f28-c772-08d9ff19f58d
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2022 02:35:21.1423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VLvFb93rq18Q/41t0RRlh91tufImmahkjESVEgvfsOXz5HKKeW0PP2u9r5jUC2eqxCUdupDPF089e1Z3KVAi1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB2754
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:
tools/lib/bpf/bpf.c:114:31-32: WARNING: Use ARRAY_SIZE
tools/lib/bpf/xsk.c:484:34-35: WARNING: Use ARRAY_SIZE
tools/lib/bpf/xsk.c:485:35-36: WARNING: Use ARRAY_SIZE

It has been tested with gcc (Debian 8.3.0-6) 8.3.0 on x86_64.

Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
---
 tools/lib/bpf/bpf.c | 3 ++-
 tools/lib/bpf/xsk.c | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 418b259166f8..3c7c180294fa 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -29,6 +29,7 @@
 #include <errno.h>
 #include <linux/bpf.h>
 #include <linux/filter.h>
+#include <linux/kernel.h>
 #include <limits.h>
 #include <sys/resource.h>
 #include "bpf.h"
@@ -111,7 +112,7 @@ int probe_memcg_account(void)
 		BPF_EMIT_CALL(BPF_FUNC_ktime_get_coarse_ns),
 		BPF_EXIT_INSN(),
 	};
-	size_t insn_cnt = sizeof(insns) / sizeof(insns[0]);
+	size_t insn_cnt = ARRAY_SIZE(insns);
 	union bpf_attr attr;
 	int prog_fd;
 
diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index edafe56664f3..19dbefb1caf1 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -481,8 +481,8 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 		BPF_EMIT_CALL(BPF_FUNC_redirect_map),
 		BPF_EXIT_INSN(),
 	};
-	size_t insns_cnt[] = {sizeof(prog) / sizeof(struct bpf_insn),
-			      sizeof(prog_redirect_flags) / sizeof(struct bpf_insn),
+	size_t insns_cnt[] = {ARRAY_SIZE(prog),
+			      ARRAY_SIZE(prog_redirect_flags),
 	};
 	struct bpf_insn *progs[] = {prog, prog_redirect_flags};
 	enum xsk_prog option = get_xsk_prog();
-- 
2.20.1

