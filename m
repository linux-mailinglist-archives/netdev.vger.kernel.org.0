Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2001CF78C
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 16:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730200AbgELOn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 10:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgELOn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 10:43:56 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DEBDC061A0C;
        Tue, 12 May 2020 07:43:55 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id u5so3647488pgn.5;
        Tue, 12 May 2020 07:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4NPRld2zrAWuDTtveSvIS/3QdGfA5LqnVYEILeI44kY=;
        b=eOZcUlHRJG774BRllpqy/VU/TCQhs31jhO8ZgfKzw0Cv9OXi4ZkbQOy/3T8lTxn0zq
         l3Sg8peMrIc+qXUV1dWgZpoRSdKb/JWhWmKRzUGsKZZfU608MoR+wyWQuUyzZ/l8xVd4
         Z7i2FizCgHba0y5xYQD/c9D2445weTU24TR0k5wyAAGVUc3GK4Jh7vLga2Rl6pQgt31/
         ZcnbOCvq9O9r8vg1UtDBLuUF8DrbIlrSB6lZayaRFrIEEEbm36MOE5f3moBzAXE8h/LW
         ePZSeJQyEQGFEsQma7dT+ZoDtebK3ngX1fWAzn0ShmFvNc5kNxCKaQ9crI8BmYdVtNQ2
         JSsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4NPRld2zrAWuDTtveSvIS/3QdGfA5LqnVYEILeI44kY=;
        b=A34hDC5ELi6vZeQRihVMNSBnEQbCV02pRCK+wLfKEruJ8X0MiN5f8HNMmBFsa7Llbr
         UKgyrYrd2tN+E5VEaPNax4IlT8XK8B1M/eUR1MZDkapWUhu57j/Hmq17cyTFB68VI01d
         MgQ7ygHWVoQ7QcWnSek6pQLBmviyC8gv68sx+acpEg1dLjqXS9k++xajYXFqSWzHAygS
         7ksgyPulxtY8U7CTN0CEHYdZMRe6fuSpCxPL1h2RCN6CSLwSzEQnCmqilSmpuSPJmKm/
         vxBlACviro5hHmo9sIq9J0oy3f86PKivn5jzs2X/Z4BqkqMjfl8qKJLTHeaSkU+VVwX8
         GE3A==
X-Gm-Message-State: AGi0PuY5DUDEhpbMRX7JY0KehMPZ6HnnS5C2X8ZsYp6erIKtCjwCDxdP
        5gmBncOHPpxc3w2Q0kr7+w==
X-Google-Smtp-Source: APiQypLUrJdGiINsEobDyaO2anl+xYBv+k1ynmGzLTbgMPeW5Vu9/gCPNTaXTILIin+mMwrcLGBwng==
X-Received: by 2002:a63:5b1f:: with SMTP id p31mr20453090pgb.335.1589294635021;
        Tue, 12 May 2020 07:43:55 -0700 (PDT)
Received: from localhost.localdomain ([219.255.158.173])
        by smtp.gmail.com with ESMTPSA id w11sm10786581pgj.4.2020.05.12.07.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 07:43:54 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH bpf-next 3/3] samples: bpf: refactor kprobe, tail call kern progs map definition
Date:   Tue, 12 May 2020 23:43:39 +0900
Message-Id: <20200512144339.1617069-4-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200512144339.1617069-1-danieltimlee@gmail.com>
References: <20200512144339.1617069-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because the previous two commit replaced the bpf_load implementation of
the user program with libbpf, the corresponding kernel program's MAP
definition can be replaced with new BTF-defined map syntax.

This commit only updates the samples which uses libbpf API for loading
bpf program not with bpf_load.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/sampleip_kern.c    | 12 +++++------
 samples/bpf/sockex3_kern.c     | 36 ++++++++++++++++----------------
 samples/bpf/trace_event_kern.c | 24 ++++++++++-----------
 samples/bpf/tracex2_kern.c     | 24 ++++++++++-----------
 samples/bpf/tracex3_kern.c     | 24 ++++++++++-----------
 samples/bpf/tracex4_kern.c     | 12 +++++------
 samples/bpf/tracex5_kern.c     | 14 ++++++-------
 samples/bpf/tracex6_kern.c     | 38 ++++++++++++++++++----------------
 8 files changed, 93 insertions(+), 91 deletions(-)

diff --git a/samples/bpf/sampleip_kern.c b/samples/bpf/sampleip_kern.c
index e504dc308371..f24806ac24e7 100644
--- a/samples/bpf/sampleip_kern.c
+++ b/samples/bpf/sampleip_kern.c
@@ -13,12 +13,12 @@
 
 #define MAX_IPS		8192
 
-struct bpf_map_def SEC("maps") ip_map = {
-	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(u64),
-	.value_size = sizeof(u32),
-	.max_entries = MAX_IPS,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, u64);
+	__type(value, u32);
+	__uint(max_entries, MAX_IPS);
+} ip_map SEC(".maps");
 
 SEC("perf_event")
 int do_sample(struct bpf_perf_event_data *ctx)
diff --git a/samples/bpf/sockex3_kern.c b/samples/bpf/sockex3_kern.c
index 36d4dac23549..3304fabd636d 100644
--- a/samples/bpf/sockex3_kern.c
+++ b/samples/bpf/sockex3_kern.c
@@ -19,12 +19,12 @@
 
 #define PROG(F) SEC("socket/"__stringify(F)) int bpf_func_##F
 
-struct bpf_map_def SEC("maps") jmp_table = {
-	.type = BPF_MAP_TYPE_PROG_ARRAY,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(u32),
-	.max_entries = 8,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
+	__uint(key_size, sizeof(u32));
+	__uint(value_size, sizeof(u32));
+	__uint(max_entries, 8);
+} jmp_table SEC(".maps");
 
 #define PARSE_VLAN 1
 #define PARSE_MPLS 2
@@ -92,12 +92,12 @@ struct globals {
 	struct flow_key_record flow;
 };
 
-struct bpf_map_def SEC("maps") percpu_map = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(struct globals),
-	.max_entries = 32,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, __u32);
+	__type(value, struct globals);
+	__uint(max_entries, 32);
+} percpu_map SEC(".maps");
 
 /* user poor man's per_cpu until native support is ready */
 static struct globals *this_cpu_globals(void)
@@ -113,12 +113,12 @@ struct pair {
 	__u64 bytes;
 };
 
-struct bpf_map_def SEC("maps") hash_map = {
-	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(struct flow_key_record),
-	.value_size = sizeof(struct pair),
-	.max_entries = 1024,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, struct flow_key_record);
+	__type(value, struct pair);
+	__uint(max_entries, 1024);
+} hash_map SEC(".maps");
 
 static void update_stats(struct __sk_buff *skb, struct globals *g)
 {
diff --git a/samples/bpf/trace_event_kern.c b/samples/bpf/trace_event_kern.c
index da1d69e20645..7d3c66fb3f88 100644
--- a/samples/bpf/trace_event_kern.c
+++ b/samples/bpf/trace_event_kern.c
@@ -18,19 +18,19 @@ struct key_t {
 	u32 userstack;
 };
 
-struct bpf_map_def SEC("maps") counts = {
-	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(struct key_t),
-	.value_size = sizeof(u64),
-	.max_entries = 10000,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, struct key_t);
+	__type(value, u64);
+	__uint(max_entries, 10000);
+} counts SEC(".maps");
 
-struct bpf_map_def SEC("maps") stackmap = {
-	.type = BPF_MAP_TYPE_STACK_TRACE,
-	.key_size = sizeof(u32),
-	.value_size = PERF_MAX_STACK_DEPTH * sizeof(u64),
-	.max_entries = 10000,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_STACK_TRACE);
+	__uint(key_size, sizeof(u32));
+	__uint(value_size, PERF_MAX_STACK_DEPTH * sizeof(u64));
+	__uint(max_entries, 10000);
+} stackmap SEC(".maps");
 
 #define KERN_STACKID_FLAGS (0 | BPF_F_FAST_STACK_CMP)
 #define USER_STACKID_FLAGS (0 | BPF_F_FAST_STACK_CMP | BPF_F_USER_STACK)
diff --git a/samples/bpf/tracex2_kern.c b/samples/bpf/tracex2_kern.c
index ff5d00916733..a2409abd7b87 100644
--- a/samples/bpf/tracex2_kern.c
+++ b/samples/bpf/tracex2_kern.c
@@ -17,12 +17,12 @@
 #define SYSCALL
 #endif
 
-struct bpf_map_def SEC("maps") my_map = {
-	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(long),
-	.value_size = sizeof(long),
-	.max_entries = 1024,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, long);
+	__type(value, long);
+	__uint(max_entries, 1024);
+} my_map SEC(".maps");
 
 /* kprobe is NOT a stable ABI. If kernel internals change this bpf+kprobe
  * example will no longer be meaningful
@@ -76,12 +76,12 @@ struct hist_key {
 	u64 index;
 };
 
-struct bpf_map_def SEC("maps") my_hist_map = {
-	.type = BPF_MAP_TYPE_PERCPU_HASH,
-	.key_size = sizeof(struct hist_key),
-	.value_size = sizeof(long),
-	.max_entries = 1024,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_HASH);
+	__uint(key_size, sizeof(struct hist_key));
+	__uint(value_size, sizeof(long));
+	__uint(max_entries, 1024);
+} my_hist_map SEC(".maps");
 
 SEC("kprobe/" SYSCALL "sys_write")
 int bpf_prog3(struct pt_regs *ctx)
diff --git a/samples/bpf/tracex3_kern.c b/samples/bpf/tracex3_kern.c
index fe21c14feb8d..659613c19a82 100644
--- a/samples/bpf/tracex3_kern.c
+++ b/samples/bpf/tracex3_kern.c
@@ -11,12 +11,12 @@
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 
-struct bpf_map_def SEC("maps") my_map = {
-	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(long),
-	.value_size = sizeof(u64),
-	.max_entries = 4096,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, long);
+	__type(value, u64);
+	__uint(max_entries, 4096);
+} my_map SEC(".maps");
 
 /* kprobe is NOT a stable ABI. If kernel internals change this bpf+kprobe
  * example will no longer be meaningful
@@ -42,12 +42,12 @@ static unsigned int log2l(unsigned long long n)
 
 #define SLOTS 100
 
-struct bpf_map_def SEC("maps") lat_map = {
-	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(u64),
-	.max_entries = SLOTS,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__uint(key_size, sizeof(u32));
+	__uint(value_size, sizeof(u64));
+	__uint(max_entries, SLOTS);
+} lat_map SEC(".maps");
 
 SEC("kprobe/blk_account_io_completion")
 int bpf_prog2(struct pt_regs *ctx)
diff --git a/samples/bpf/tracex4_kern.c b/samples/bpf/tracex4_kern.c
index b1bb9df88f8e..eb0f8fdd14bf 100644
--- a/samples/bpf/tracex4_kern.c
+++ b/samples/bpf/tracex4_kern.c
@@ -15,12 +15,12 @@ struct pair {
 	u64 ip;
 };
 
-struct bpf_map_def SEC("maps") my_map = {
-	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(long),
-	.value_size = sizeof(struct pair),
-	.max_entries = 1000000,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, long);
+	__type(value, struct pair);
+	__uint(max_entries, 1000000);
+} my_map SEC(".maps");
 
 /* kprobe is NOT a stable ABI. If kernel internals change this bpf+kprobe
  * example will no longer be meaningful
diff --git a/samples/bpf/tracex5_kern.c b/samples/bpf/tracex5_kern.c
index 481790fde864..32b49e8ab6bd 100644
--- a/samples/bpf/tracex5_kern.c
+++ b/samples/bpf/tracex5_kern.c
@@ -15,16 +15,16 @@
 
 #define PROG(F) SEC("kprobe/"__stringify(F)) int bpf_func_##F
 
-struct bpf_map_def SEC("maps") progs = {
-	.type = BPF_MAP_TYPE_PROG_ARRAY,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(u32),
+struct {
+	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
+	__uint(key_size, sizeof(u32));
+	__uint(value_size, sizeof(u32));
 #ifdef __mips__
-	.max_entries = 6000, /* MIPS n64 syscalls start at 5000 */
+	__uint(max_entries, 6000); /* MIPS n64 syscalls start at 5000 */
 #else
-	.max_entries = 1024,
+	__uint(max_entries, 1024);
 #endif
-};
+} progs SEC(".maps");
 
 SEC("kprobe/__seccomp_filter")
 int bpf_prog1(struct pt_regs *ctx)
diff --git a/samples/bpf/tracex6_kern.c b/samples/bpf/tracex6_kern.c
index 96c234efa852..acad5712d8b4 100644
--- a/samples/bpf/tracex6_kern.c
+++ b/samples/bpf/tracex6_kern.c
@@ -3,24 +3,26 @@
 #include <uapi/linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 
-struct bpf_map_def SEC("maps") counters = {
-	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
-	.key_size = sizeof(int),
-	.value_size = sizeof(u32),
-	.max_entries = 64,
-};
-struct bpf_map_def SEC("maps") values = {
-	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(int),
-	.value_size = sizeof(u64),
-	.max_entries = 64,
-};
-struct bpf_map_def SEC("maps") values2 = {
-	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(int),
-	.value_size = sizeof(struct bpf_perf_event_value),
-	.max_entries = 64,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(u32));
+	__uint(max_entries, 64);
+} counters SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, int);
+	__type(value, u64);
+	__uint(max_entries, 64);
+} values SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, int);
+	__type(value, struct bpf_perf_event_value);
+	__uint(max_entries, 64);
+} values2 SEC(".maps");
 
 SEC("kprobe/htab_map_get_next_key")
 int bpf_prog1(struct pt_regs *ctx)
-- 
2.25.1

