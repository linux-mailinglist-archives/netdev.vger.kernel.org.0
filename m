Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6070F1CDB61
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 15:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729911AbgEKNiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 09:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729811AbgEKNiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 09:38:24 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8FEC061A0E
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 06:38:22 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id j5so11021513wrq.2
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 06:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oMvuLrgtg4fujA+qHaz0E9TK2E50uwJmrNzLZd/PmYA=;
        b=WIaaTzUxcBxlyzNHEbjDWMcGZJ06DL2JdVGWbLjOrnD5okoQdgPixEqHyvis2OmJL3
         MmRo/tgA4gNFwdZX3FNurhIMTQiIVQShhnvRGObLTtW1GFNboqRHH6jZDXCzsVFg9XW+
         2jQNou4Utt0kZYOl7uoCtZQ43G0uIl2rMpS6ENTZA1hyKej10djqI8e3V0/rHE+zMvmJ
         vVzHGhZonVP+G+74qGyCtV0fnWHWJDa7dFkrwtDcKs1fRNswgI8B+lOsK5eLpcO1QIgy
         F90e168ydiBqHisxLIz+pQDM4Rl+rSe9+a+F+azEhRM8nLIQGiF+UcDxoE8duIM8L19T
         Q/Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oMvuLrgtg4fujA+qHaz0E9TK2E50uwJmrNzLZd/PmYA=;
        b=tPUnicg3soIJMv/nkZNYa/lG0dVLH0kYIC0lQXtf1qb5x7u9LQGDs/OQcL8T27yXJd
         DJOg8xmlqGhcLUdMPS4cme0LpT7rDEDrU1dZG33qXGngDgLRHApmc4vbp27dQxl2CoQS
         oDBmC4gJxee1Kwm3jWcHVQ2JSyMDa6Xon/FeBZ6oDqVer1/F9NDNN99FWWv7N76ZNxqq
         U1kf7LBI09RLSApDSOn2Yc73ERwtfhVSvefcY5vRIKSd/UxK2EfD3jcme/vBNsyuPnF/
         +ukdFhf0lu6FyG5ErU5bHu1B2WghI12VgiQmcVfqbFWdKbFMYVD/FLEheI3tHLLoRdZU
         eiZA==
X-Gm-Message-State: AGi0Pubgf/5Nv54Y0kLkLkOqtoSTaY4lTzSfUkwckF+/Hk636mwbJKjE
        ss+TcXNNMlWt7/zLvyzAikJEzg==
X-Google-Smtp-Source: APiQypLSL0vJ+YBUGZa7VZclXrYM8MEBsxIa6Tld/8PEKwGr3QXcxAR2Do67+dgqgbQDLLr/Nnostw==
X-Received: by 2002:a5d:54c4:: with SMTP id x4mr20328287wrv.73.1589204301316;
        Mon, 11 May 2020 06:38:21 -0700 (PDT)
Received: from localhost.localdomain ([194.53.185.84])
        by smtp.gmail.com with ESMTPSA id p4sm6932371wrq.31.2020.05.11.06.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 06:38:20 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 1/4] tools: bpftool: poison and replace kernel integer typedefs
Date:   Mon, 11 May 2020 14:38:04 +0100
Message-Id: <20200511133807.26495-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200511133807.26495-1-quentin@isovalent.com>
References: <20200511133807.26495-1-quentin@isovalent.com>
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

