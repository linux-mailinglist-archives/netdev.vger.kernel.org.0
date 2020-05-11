Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533231CE037
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 18:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729853AbgEKQPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 12:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730613AbgEKQPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 12:15:42 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB90C05BD09
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 09:15:42 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id 50so11176548wrc.11
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 09:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oMvuLrgtg4fujA+qHaz0E9TK2E50uwJmrNzLZd/PmYA=;
        b=F+Jey5xy2p11Fq+vcb2fui13u9Vb9JbPAW4c4lNO8uO19A7PsXjxMix7q324RqZqFk
         ROvwlVGyRd5srh9IISrJmPoX67Dv3GfoQdeYhMRhl0lWUlEHD1RTxZo3FC+dZD3CNXax
         47Lt6mp0IngzGPIx2HMdDX8e2EHJ9aZMsvKw5NJsh3Na58Cp6FfIi8l3+Zm76M0nHnAt
         Oaq3FKSGEBrwpUwhoPmo7gM6IXZ9gUQ3rd6A/pRpPy5IppHfNo0CuGH3a2zJtNkKhvKe
         QzB5waeB/d2lYZYm6uLb9wPSaUuY9/7cOM+KYX9hWoYQubnt6y/a+5HiRF7LyVIwrkK9
         xa1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oMvuLrgtg4fujA+qHaz0E9TK2E50uwJmrNzLZd/PmYA=;
        b=cBTP80J2Q8KAXQXuiYIUJeqEHkPlxuHxDGjL+QRMq2g3qagzqAJYw87uTpFEsxpT+n
         hndJzpsqbQvB/1tanJUJEyiIno0TRcrwx98BHqSiCUjEm46+uVn/BM5iErRC//rDn+Rs
         FZQSc3soWmX2AtOURUqAmtQgSo94xLGSht1GqcB2/s052Up1x97Jijfo+V/WZ3a50PlI
         COZ2GZPSXygaTyCUa6gGrATHSAizyn2GqstrFwawEQWTQPSznX2UceZo+iaRsr0mQt9n
         IpoFIwh2B+a00cpGtyYRDtUZ9nzLqDQ5bikB89VLZHfMHoB+ahUOxAGCaUddShHiQHxf
         QoyA==
X-Gm-Message-State: AGi0PubRYX7+SJdS6HUA10aRVzJx8s5faGdFNpmtJwFLdesyyg+FxKRd
        dwZC9N/pzNu3iPJFS4AlrDhwrg==
X-Google-Smtp-Source: APiQypLVws68exXc0o5xJvWUiAFtoTKCAfmcmiWjPqUWysMUL/uvdL8BHU5/ZmG/tDh36GL/qy/v5w==
X-Received: by 2002:a5d:68cb:: with SMTP id p11mr19384003wrw.349.1589213740680;
        Mon, 11 May 2020 09:15:40 -0700 (PDT)
Received: from localhost.localdomain ([194.53.185.84])
        by smtp.gmail.com with ESMTPSA id v131sm54734wmb.27.2020.05.11.09.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 09:15:40 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 1/4] tools: bpftool: poison and replace kernel integer typedefs
Date:   Mon, 11 May 2020 17:15:33 +0100
Message-Id: <20200511161536.29853-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200511161536.29853-1-quentin@isovalent.com>
References: <20200511161536.29853-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the use of kernel-only integer typedefs (u8, u32, etc.) by their
user space counterpart (__u8, __u32, etc.).

Similarly to what libbpf does, poison the typedefs to avoid introducing
them again in the future.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/btf_dumper.c    | 4 ++--
 tools/bpf/bpftool/cfg.c           | 4 ++--
 tools/bpf/bpftool/main.h          | 3 +++
 tools/bpf/bpftool/map_perf_ring.c | 2 +-
 tools/bpf/bpftool/prog.c          | 2 +-
 5 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
index 497807bec675..ede162f83eea 100644
--- a/tools/bpf/bpftool/btf_dumper.c
+++ b/tools/bpf/bpftool/btf_dumper.c
@@ -271,8 +271,8 @@ static void btf_int128_print(json_writer_t *jw, const void *data,
 	}
 }
 
-static void btf_int128_shift(__u64 *print_num, u16 left_shift_bits,
-			     u16 right_shift_bits)
+static void btf_int128_shift(__u64 *print_num, __u16 left_shift_bits,
+			     __u16 right_shift_bits)
 {
 	__u64 upper_num, lower_num;
 
diff --git a/tools/bpf/bpftool/cfg.c b/tools/bpf/bpftool/cfg.c
index 3e21f994f262..1951219a9af7 100644
--- a/tools/bpf/bpftool/cfg.c
+++ b/tools/bpf/bpftool/cfg.c
@@ -157,7 +157,7 @@ static bool cfg_partition_funcs(struct cfg *cfg, struct bpf_insn *cur,
 	return false;
 }
 
-static bool is_jmp_insn(u8 code)
+static bool is_jmp_insn(__u8 code)
 {
 	return BPF_CLASS(code) == BPF_JMP || BPF_CLASS(code) == BPF_JMP32;
 }
@@ -176,7 +176,7 @@ static bool func_partition_bb_head(struct func_node *func)
 
 	for (; cur <= end; cur++) {
 		if (is_jmp_insn(cur->code)) {
-			u8 opcode = BPF_OP(cur->code);
+			__u8 opcode = BPF_OP(cur->code);
 
 			if (opcode == BPF_EXIT || opcode == BPF_CALL)
 				continue;
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index a41cefabccaf..f89ac70ef973 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -18,6 +18,9 @@
 
 #include "json_writer.h"
 
+/* Make sure we do not use kernel-only integer typedefs */
+#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
+
 #define ptr_to_u64(ptr)	((__u64)(unsigned long)(ptr))
 
 #define NEXT_ARG()	({ argc--; argv++; if (argc < 0) usage(); })
diff --git a/tools/bpf/bpftool/map_perf_ring.c b/tools/bpf/bpftool/map_perf_ring.c
index d9b29c17fbb8..825f29f93a57 100644
--- a/tools/bpf/bpftool/map_perf_ring.c
+++ b/tools/bpf/bpftool/map_perf_ring.c
@@ -39,7 +39,7 @@ struct event_ring_info {
 
 struct perf_event_sample {
 	struct perf_event_header header;
-	u64 time;
+	__u64 time;
 	__u32 size;
 	unsigned char data[];
 };
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index f6a5974a7b0a..b6e5ba568f98 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -238,7 +238,7 @@ int prog_parse_fd(int *argc, char ***argv)
 	return fd;
 }
 
-static void show_prog_maps(int fd, u32 num_maps)
+static void show_prog_maps(int fd, __u32 num_maps)
 {
 	struct bpf_prog_info info = {};
 	__u32 len = sizeof(info);
-- 
2.20.1

