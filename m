Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5C121770A
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 20:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgGGStO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 14:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbgGGStN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 14:49:13 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71384C061755;
        Tue,  7 Jul 2020 11:49:13 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k5so1240802plk.13;
        Tue, 07 Jul 2020 11:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/EybAqoDyvUdozd/cT6MIlsKnFaXfxagKfhLzrKSTJ8=;
        b=D0nvDpNFCHAtTRgo0NrdbtrE8PBXaK0p2vncJjtZN7wnDLKZVUkLOxg7Dg/mf6ddd+
         EAY7zu9VxPxpAgfsCvP0ypeBLx/axXngYJM6RHeG0l2Nlv1k8J7g0UwZt2YJBQRTccR8
         SPd+JPtjHxHZLgBIQXA7LQsxMhWMX6MDz6+zpOiCYxUUBIVkCcisscLIM6R8+lJz1/rC
         CMQG14dRxCnBuAPbcAn4jxlUNusztai7egVQHqe0TmoN0UehBUby6N+yOgXEMGDk6f6m
         AgL5DGXyJMMNLbCO+hr/cwgRfqjU1BIzGW0C4ZF4K873+LJtaiQceuXaWW1qTfb3tawb
         I07w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/EybAqoDyvUdozd/cT6MIlsKnFaXfxagKfhLzrKSTJ8=;
        b=K7VBhaHouirTgwC9Noq2nUgwYQA+9pFNE2XYhZqh66lALwD5zzbCnsHaHnrupGv3LT
         uOoARW/llOysqTln1K9NHzh87A1mGwHRG3P/thEAyYDNvkPCmM6nj70pmPDeKidcus/H
         wYIvTkx522DlCAh/PV/0tLjvlGqyiD0o0fpBYifYbXciYu30aCJVlKbAefZk+Lbofztx
         EJ9VG/Mje1P9/Vc5KcB2V2PuQ/Q7sh+Et4ttz3KSZiCz+FCTPoP3sNXcMb6W/JRUgrgE
         N7wwFVpI8FlKROM/ojL7TuNjN8KQW/6DqoJGA998h6F7bjeF0Xf0Xq/HhQlSDq3hue3c
         /c3w==
X-Gm-Message-State: AOAM530kRSYQUDL3dRMCfE5e2iKEqXksaFw0mLygULW36I76FVHDJXkL
        dpNipfPE/0bZ2PD4c4mQHA==
X-Google-Smtp-Source: ABdhPJxlg8g0RLdU88bv8Tf7dJtRfjDew8DwOw1HdGOKn9kX8803bSULHh8CoaHNfYGK2N9+X6SpJA==
X-Received: by 2002:a17:90b:1296:: with SMTP id fw22mr5846723pjb.20.1594147752962;
        Tue, 07 Jul 2020 11:49:12 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id r7sm1625278pgu.51.2020.07.07.11.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 11:49:12 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 1/4] samples: bpf: fix bpf programs with kprobe/sys_connect event
Date:   Wed,  8 Jul 2020 03:48:52 +0900
Message-Id: <20200707184855.30968-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200707184855.30968-1-danieltimlee@gmail.com>
References: <20200707184855.30968-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, BPF programs with kprobe/sys_connect does not work properly.

Commit 34745aed515c ("samples/bpf: fix kprobe attachment issue on x64")
This commit modifies the bpf_load behavior of kprobe events in the x64
architecture. If the current kprobe event target starts with "sys_*",
add the prefix "__x64_" to the front of the event.

Appending "__x64_" prefix with kprobe/sys_* event was appropriate as a
solution to most of the problems caused by the commit below.

    commit d5a00528b58c ("syscalls/core, syscalls/x86: Rename struct
    pt_regs-based sys_*() to __x64_sys_*()")

However, there is a problem with the sys_connect kprobe event that does
not work properly. For __sys_connect event, parameters can be fetched
normally, but for __x64_sys_connect, parameters cannot be fetched.

    ffffffff818d3520 <__x64_sys_connect>:
    ffffffff818d3520: e8 fb df 32 00        callq   0xffffffff81c01520
    <__fentry__>
    ffffffff818d3525: 48 8b 57 60           movq    96(%rdi), %rdx
    ffffffff818d3529: 48 8b 77 68           movq    104(%rdi), %rsi
    ffffffff818d352d: 48 8b 7f 70           movq    112(%rdi), %rdi
    ffffffff818d3531: e8 1a ff ff ff        callq   0xffffffff818d3450
    <__sys_connect>
    ffffffff818d3536: 48 98                 cltq
    ffffffff818d3538: c3                    retq
    ffffffff818d3539: 0f 1f 80 00 00 00 00  nopl    (%rax)

As the assembly code for __x64_sys_connect shows, parameters should be
fetched and set into rdi, rsi, rdx registers prior to calling
__sys_connect.

Because of this problem, this commit fixes the sys_connect event by
first getting the value of the rdi register and then the value of the
rdi, rsi, and rdx register through an offset based on that value.

Fixes: 34745aed515c ("samples/bpf: fix kprobe attachment issue on x64")
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

---
Changes in V2:
 - instead of changing event from __x64_sys_connect to __sys_connect,
 fetch and set register values directly

 samples/bpf/map_perf_test_kern.c         | 9 ++++++---
 samples/bpf/test_map_in_map_kern.c       | 9 ++++++---
 samples/bpf/test_probe_write_user_kern.c | 9 ++++++---
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/samples/bpf/map_perf_test_kern.c b/samples/bpf/map_perf_test_kern.c
index 12e91ae64d4d..c9b31193ca12 100644
--- a/samples/bpf/map_perf_test_kern.c
+++ b/samples/bpf/map_perf_test_kern.c
@@ -11,6 +11,8 @@
 #include <bpf/bpf_helpers.h>
 #include "bpf_legacy.h"
 #include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
+#include "trace_common.h"
 
 #define MAX_ENTRIES 1000
 #define MAX_NR_CPUS 1024
@@ -154,9 +156,10 @@ int stress_percpu_hmap_alloc(struct pt_regs *ctx)
 	return 0;
 }
 
-SEC("kprobe/sys_connect")
+SEC("kprobe/" SYSCALL(sys_connect))
 int stress_lru_hmap_alloc(struct pt_regs *ctx)
 {
+	struct pt_regs *real_regs = (struct pt_regs *)PT_REGS_PARM1_CORE(ctx);
 	char fmt[] = "Failed at stress_lru_hmap_alloc. ret:%dn";
 	union {
 		u16 dst6[8];
@@ -175,8 +178,8 @@ int stress_lru_hmap_alloc(struct pt_regs *ctx)
 	long val = 1;
 	u32 key = 0;
 
-	in6 = (struct sockaddr_in6 *)PT_REGS_PARM2(ctx);
-	addrlen = (int)PT_REGS_PARM3(ctx);
+	in6 = (struct sockaddr_in6 *)PT_REGS_PARM2_CORE(real_regs);
+	addrlen = (int)PT_REGS_PARM3_CORE(real_regs);
 
 	if (addrlen != sizeof(*in6))
 		return 0;
diff --git a/samples/bpf/test_map_in_map_kern.c b/samples/bpf/test_map_in_map_kern.c
index 6cee61e8ce9b..36a203e69064 100644
--- a/samples/bpf/test_map_in_map_kern.c
+++ b/samples/bpf/test_map_in_map_kern.c
@@ -13,6 +13,8 @@
 #include <bpf/bpf_helpers.h>
 #include "bpf_legacy.h"
 #include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
+#include "trace_common.h"
 
 #define MAX_NR_PORTS 65536
 
@@ -102,9 +104,10 @@ static __always_inline int do_inline_hash_lookup(void *inner_map, u32 port)
 	return result ? *result : -ENOENT;
 }
 
-SEC("kprobe/sys_connect")
+SEC("kprobe/" SYSCALL(sys_connect))
 int trace_sys_connect(struct pt_regs *ctx)
 {
+	struct pt_regs *real_regs = (struct pt_regs *)PT_REGS_PARM1_CORE(ctx);
 	struct sockaddr_in6 *in6;
 	u16 test_case, port, dst6[8];
 	int addrlen, ret, inline_ret, ret_key = 0;
@@ -112,8 +115,8 @@ int trace_sys_connect(struct pt_regs *ctx)
 	void *outer_map, *inner_map;
 	bool inline_hash = false;
 
-	in6 = (struct sockaddr_in6 *)PT_REGS_PARM2(ctx);
-	addrlen = (int)PT_REGS_PARM3(ctx);
+	in6 = (struct sockaddr_in6 *)PT_REGS_PARM2_CORE(real_regs);
+	addrlen = (int)PT_REGS_PARM3_CORE(real_regs);
 
 	if (addrlen != sizeof(*in6))
 		return 0;
diff --git a/samples/bpf/test_probe_write_user_kern.c b/samples/bpf/test_probe_write_user_kern.c
index f033f36a13a3..fd651a65281e 100644
--- a/samples/bpf/test_probe_write_user_kern.c
+++ b/samples/bpf/test_probe_write_user_kern.c
@@ -10,6 +10,8 @@
 #include <linux/version.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
+#include "trace_common.h"
 
 struct bpf_map_def SEC("maps") dnat_map = {
 	.type = BPF_MAP_TYPE_HASH,
@@ -26,13 +28,14 @@ struct bpf_map_def SEC("maps") dnat_map = {
  * This example sits on a syscall, and the syscall ABI is relatively stable
  * of course, across platforms, and over time, the ABI may change.
  */
-SEC("kprobe/sys_connect")
+SEC("kprobe/" SYSCALL(sys_connect))
 int bpf_prog1(struct pt_regs *ctx)
 {
+	struct pt_regs *real_regs = (struct pt_regs *)PT_REGS_PARM1_CORE(ctx);
+	void *sockaddr_arg = (void *)PT_REGS_PARM2_CORE(real_regs);
+	int sockaddr_len = (int)PT_REGS_PARM3_CORE(real_regs);
 	struct sockaddr_in new_addr, orig_addr = {};
 	struct sockaddr_in *mapped_addr;
-	void *sockaddr_arg = (void *)PT_REGS_PARM2(ctx);
-	int sockaddr_len = (int)PT_REGS_PARM3(ctx);
 
 	if (sockaddr_len > sizeof(orig_addr))
 		return 0;
-- 
2.25.1

