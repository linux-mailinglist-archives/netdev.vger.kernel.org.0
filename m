Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB2E250607
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 19:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgHXRZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 13:25:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:39970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728259AbgHXQfj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 12:35:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7BEA22B49;
        Mon, 24 Aug 2020 16:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598286938;
        bh=0qKFt4rBMJJe2mXKHEb4MCWoeQnV2O2OwSgCNEIKOr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCQEI4sQHacWLhdVQtpT/chdiWj7D8gjgr0JtXpf6KsX++05yQNrE7FUv2q+EBveK
         0/M+ci7J7XR1PFUC+JXufsIXeD6gb0jevIKP9INFV6aH1LnS0tI6iksX4jI0P6hlQD
         9XsAmvc/MBG0yXiTKS9X0wwBMdRSGTTFZfvy16mI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 25/63] tools/bpftool: Fix compilation warnings in 32-bit mode
Date:   Mon, 24 Aug 2020 12:34:25 -0400
Message-Id: <20200824163504.605538-25-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163504.605538-1-sashal@kernel.org>
References: <20200824163504.605538-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 09f44b753a7d120becc80213c3459183c8acd26b ]

Fix few compilation warnings in bpftool when compiling in 32-bit mode.
Abstract away u64 to pointer conversion into a helper function.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200813204945.1020225-2-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/btf_dumper.c |  2 +-
 tools/bpf/bpftool/link.c       |  4 ++--
 tools/bpf/bpftool/main.h       | 10 +++++++++-
 tools/bpf/bpftool/prog.c       | 16 ++++++++--------
 4 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
index ede162f83eea0..0e9310727281a 100644
--- a/tools/bpf/bpftool/btf_dumper.c
+++ b/tools/bpf/bpftool/btf_dumper.c
@@ -67,7 +67,7 @@ static int dump_prog_id_as_func_ptr(const struct btf_dumper *d,
 	if (!info->btf_id || !info->nr_func_info ||
 	    btf__get_from_id(info->btf_id, &prog_btf))
 		goto print;
-	finfo = (struct bpf_func_info *)info->func_info;
+	finfo = u64_to_ptr(info->func_info);
 	func_type = btf__type_by_id(prog_btf, finfo->type_id);
 	if (!func_type || !btf_is_func(func_type))
 		goto print;
diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index fca57ee8fafe4..dea691c83afca 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -101,7 +101,7 @@ static int show_link_close_json(int fd, struct bpf_link_info *info)
 	switch (info->type) {
 	case BPF_LINK_TYPE_RAW_TRACEPOINT:
 		jsonw_string_field(json_wtr, "tp_name",
-				   (const char *)info->raw_tracepoint.tp_name);
+				   u64_to_ptr(info->raw_tracepoint.tp_name));
 		break;
 	case BPF_LINK_TYPE_TRACING:
 		err = get_prog_info(info->prog_id, &prog_info);
@@ -177,7 +177,7 @@ static int show_link_close_plain(int fd, struct bpf_link_info *info)
 	switch (info->type) {
 	case BPF_LINK_TYPE_RAW_TRACEPOINT:
 		printf("\n\ttp '%s'  ",
-		       (const char *)info->raw_tracepoint.tp_name);
+		       (const char *)u64_to_ptr(info->raw_tracepoint.tp_name));
 		break;
 	case BPF_LINK_TYPE_TRACING:
 		err = get_prog_info(info->prog_id, &prog_info);
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 5cdf0bc049bd9..5917484c2e027 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -21,7 +21,15 @@
 /* Make sure we do not use kernel-only integer typedefs */
 #pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
 
-#define ptr_to_u64(ptr)	((__u64)(unsigned long)(ptr))
+static inline __u64 ptr_to_u64(const void *ptr)
+{
+	return (__u64)(unsigned long)ptr;
+}
+
+static inline void *u64_to_ptr(__u64 ptr)
+{
+	return (void *)(unsigned long)ptr;
+}
 
 #define NEXT_ARG()	({ argc--; argv++; if (argc < 0) usage(); })
 #define NEXT_ARGP()	({ (*argc)--; (*argv)++; if (*argc < 0) usage(); })
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index a5eff83496f2d..2c6f7e160b248 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -537,14 +537,14 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
 			p_info("no instructions returned");
 			return -1;
 		}
-		buf = (unsigned char *)(info->jited_prog_insns);
+		buf = u64_to_ptr(info->jited_prog_insns);
 		member_len = info->jited_prog_len;
 	} else {	/* DUMP_XLATED */
 		if (info->xlated_prog_len == 0 || !info->xlated_prog_insns) {
 			p_err("error retrieving insn dump: kernel.kptr_restrict set?");
 			return -1;
 		}
-		buf = (unsigned char *)info->xlated_prog_insns;
+		buf = u64_to_ptr(info->xlated_prog_insns);
 		member_len = info->xlated_prog_len;
 	}
 
@@ -553,7 +553,7 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
 		return -1;
 	}
 
-	func_info = (void *)info->func_info;
+	func_info = u64_to_ptr(info->func_info);
 
 	if (info->nr_line_info) {
 		prog_linfo = bpf_prog_linfo__new(info);
@@ -571,7 +571,7 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
 
 		n = write(fd, buf, member_len);
 		close(fd);
-		if (n != member_len) {
+		if (n != (ssize_t)member_len) {
 			p_err("error writing output file: %s",
 			      n < 0 ? strerror(errno) : "short write");
 			return -1;
@@ -601,13 +601,13 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
 			__u32 i;
 			if (info->nr_jited_ksyms) {
 				kernel_syms_load(&dd);
-				ksyms = (__u64 *) info->jited_ksyms;
+				ksyms = u64_to_ptr(info->jited_ksyms);
 			}
 
 			if (json_output)
 				jsonw_start_array(json_wtr);
 
-			lens = (__u32 *) info->jited_func_lens;
+			lens = u64_to_ptr(info->jited_func_lens);
 			for (i = 0; i < info->nr_jited_func_lens; i++) {
 				if (ksyms) {
 					sym = kernel_syms_search(&dd, ksyms[i]);
@@ -668,7 +668,7 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
 	} else {
 		kernel_syms_load(&dd);
 		dd.nr_jited_ksyms = info->nr_jited_ksyms;
-		dd.jited_ksyms = (__u64 *) info->jited_ksyms;
+		dd.jited_ksyms = u64_to_ptr(info->jited_ksyms);
 		dd.btf = btf;
 		dd.func_info = func_info;
 		dd.finfo_rec_size = info->func_info_rec_size;
@@ -1790,7 +1790,7 @@ static char *profile_target_name(int tgt_fd)
 		goto out;
 	}
 
-	func_info = (struct bpf_func_info *)(info_linear->info.func_info);
+	func_info = u64_to_ptr(info_linear->info.func_info);
 	t = btf__type_by_id(btf, func_info[0].type_id);
 	if (!t) {
 		p_err("btf %d doesn't have type %d",
-- 
2.25.1

