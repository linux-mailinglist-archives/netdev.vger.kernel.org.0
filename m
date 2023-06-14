Return-Path: <netdev+bounces-8021-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6639172271F
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:15:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 86FFE1C20C5A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:15:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30B5919BDF;
	Mon,  5 Jun 2023 13:15:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC7919514;
	Mon,  5 Jun 2023 13:15:02 +0000 (UTC)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827CCA6;
	Mon,  5 Jun 2023 06:14:59 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1q6A2y-0004MZ-Tx; Mon, 05 Jun 2023 15:14:56 +0200
From: Florian Westphal <fw@strlen.de>
To: <bpf@vger.kernel.org>
Cc: netdev@vger.kernel.org,
	ast@kernel.org,
	Florian Westphal <fw@strlen.de>,
	Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: [PATCH bpf v2] bpf: netfilter: add BPF_NETFILTER bpf_attach_type
Date: Mon,  5 Jun 2023 15:14:45 +0200
Message-Id: <20230605131445.32016-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Andrii Nakryiko writes:

 And we currently don't have an attach type for NETLINK BPF link.
 Thankfully it's not too late to add it. I see that link_create() in
 kernel/bpf/syscall.c just bypasses attach_type check. We shouldn't
 have done that. Instead we need to add BPF_NETLINK attach type to enum
 bpf_attach_type. And wire all that properly throughout the kernel and
 libbpf itself.

This adds BPF_NETFILTER and uses it.  This breaks uabi but this
wasn't in any non-rc release yet, so it should be fine.

v2: check link_attack prog type in link_create too

Fixes: 84601d6ee68a ("bpf: add bpf_link support for BPF_NETFILTER programs")
Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Link: https://lore.kernel.org/bpf/CAEf4BzZ69YgrQW7DHCJUT_X+GqMq_ZQQPBwopaJJVGFD5=d5Vg@mail.gmail.com/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/uapi/linux/bpf.h       | 1 +
 kernel/bpf/syscall.c           | 9 +++++++++
 tools/include/uapi/linux/bpf.h | 1 +
 tools/lib/bpf/libbpf.c         | 2 +-
 4 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 1bb11a6ee667..c994ff5b157c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1035,6 +1035,7 @@ enum bpf_attach_type {
 	BPF_TRACE_KPROBE_MULTI,
 	BPF_LSM_CGROUP,
 	BPF_STRUCT_OPS,
+	BPF_NETFILTER,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 14f39c1e573e..0c21d0d8efe4 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2433,6 +2433,10 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 		default:
 			return -EINVAL;
 		}
+	case BPF_PROG_TYPE_NETFILTER:
+		if (expected_attach_type == BPF_NETFILTER)
+			return 0;
+		return -EINVAL;
 	case BPF_PROG_TYPE_SYSCALL:
 	case BPF_PROG_TYPE_EXT:
 		if (expected_attach_type)
@@ -4590,7 +4594,12 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 
 	switch (prog->type) {
 	case BPF_PROG_TYPE_EXT:
+		break;
 	case BPF_PROG_TYPE_NETFILTER:
+		if (attr->link_create.attach_type != BPF_NETFILTER) {
+			ret = -EINVAL;
+			goto out;
+		}
 		break;
 	case BPF_PROG_TYPE_PERF_EVENT:
 	case BPF_PROG_TYPE_TRACEPOINT:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 1bb11a6ee667..c994ff5b157c 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1035,6 +1035,7 @@ enum bpf_attach_type {
 	BPF_TRACE_KPROBE_MULTI,
 	BPF_LSM_CGROUP,
 	BPF_STRUCT_OPS,
+	BPF_NETFILTER,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ad1ec893b41b..532a97cf1cc1 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8712,7 +8712,7 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("struct_ops+",		STRUCT_OPS, 0, SEC_NONE),
 	SEC_DEF("struct_ops.s+",	STRUCT_OPS, 0, SEC_SLEEPABLE),
 	SEC_DEF("sk_lookup",		SK_LOOKUP, BPF_SK_LOOKUP, SEC_ATTACHABLE),
-	SEC_DEF("netfilter",		NETFILTER, 0, SEC_NONE),
+	SEC_DEF("netfilter",		NETFILTER, BPF_NETFILTER, SEC_NONE),
 };
 
 static size_t custom_sec_def_cnt;
-- 
2.39.3


