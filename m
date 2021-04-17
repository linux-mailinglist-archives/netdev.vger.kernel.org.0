Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99419362D49
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 05:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235818AbhDQDeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 23:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235569AbhDQDdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 23:33:52 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCC7C06138B;
        Fri, 16 Apr 2021 20:32:37 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso17419807pji.3;
        Fri, 16 Apr 2021 20:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HMtZowpuKJ//bqS/0/So0II0C+lVTMjMU4WfA8IzfXQ=;
        b=d9xUxsCBW7edUpglJJKfWcL/aYE92UjSpChpteTvee/6RG79nrnKI6OY75EBgENk/L
         2RwjJHSTCee23NqFxJr7SF6HhFVQwjp5B7/qP/vzTMHzCQZsaw7gVb8PD23zSn2CnW1Z
         c55Y6lwuGGmNLY1W7oBDyKoApg+U9h0Fgynshn95pg1yYJmz7BU6efkI4dN5r5S+f50h
         +gJQuFlXjgp44ZxFtndKSHD3e+hKNhiOaRhFWOCPyINC5kKIEXslaMMFt56owU3oN6+l
         Rs+AmIKOnd5Ned4TiBjKtZ6frbkFWuUMcfU767zT1fK161+984Z19zZZJR+tKnQOeHoE
         lhbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HMtZowpuKJ//bqS/0/So0II0C+lVTMjMU4WfA8IzfXQ=;
        b=QBFvnJKRXO6LMl+KsbOxdEgRcJuBncm83rNxv2qSSxnTr/RxbeWXdF7xd2lVJXrT+u
         dGJCKSL/8MJkvKgfPvkuWdaMfPx/NOXBe5ZhToacQsdDF+orVVPsACVJyZvRo6KvxFlJ
         c0HTx5rkgBzLmi+uxpcV2rg9Eo0rQ93Tn0chzMtRhBCCe717De6mjg005Ml2MByAq6VT
         xyFeja9Q8YKPRVrJdU5zW+VZobn78ntGeIwkwO3rLPf2ZImfFVwbksJb+E+TndZj0OQ/
         v8MdBs9kRRWPAE85gnUv0L0Qs19+UzBCR7o2KLPPMCxNOqVa3LQ/k86V0dfr1Nl3ILW2
         YD6w==
X-Gm-Message-State: AOAM533cCX+XZqWBNPQXG8hTslpFzQTfxB+TKjl3WD5GJ5tiS8PBVFzv
        ftHJ+BlQ52ZeXWm+DNHaxIQ=
X-Google-Smtp-Source: ABdhPJwFWIYsr6WfcRCKss2XirzpbVv7W5EWlBGhIYPKxLChT2EKOaOPvmy8ZpTqjysKsbgbGHKK/g==
X-Received: by 2002:a17:90a:4381:: with SMTP id r1mr13526973pjg.214.1618630356734;
        Fri, 16 Apr 2021 20:32:36 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id h1sm6069870pgv.88.2021.04.16.20.32.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Apr 2021 20:32:36 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 07/15] selftests/bpf: Test for btf_load command.
Date:   Fri, 16 Apr 2021 20:32:16 -0700
Message-Id: <20210417033224.8063-8-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
References: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Improve selftest to check that btf_load is working from bpf program.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/testing/selftests/bpf/progs/syscall.c | 48 +++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/syscall.c b/tools/testing/selftests/bpf/progs/syscall.c
index 01476f88e45f..b6ac10f75c37 100644
--- a/tools/testing/selftests/bpf/progs/syscall.c
+++ b/tools/testing/selftests/bpf/progs/syscall.c
@@ -4,6 +4,7 @@
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
+#include <linux/btf.h>
 #include <../../tools/include/linux/filter.h>
 
 volatile const int workaround = 1;
@@ -18,6 +19,45 @@ struct args {
 	int prog_fd;
 };
 
+#define BTF_INFO_ENC(kind, kind_flag, vlen) \
+	((!!(kind_flag) << 31) | ((kind) << 24) | ((vlen) & BTF_MAX_VLEN))
+#define BTF_TYPE_ENC(name, info, size_or_type) (name), (info), (size_or_type)
+#define BTF_INT_ENC(encoding, bits_offset, nr_bits) \
+	((encoding) << 24 | (bits_offset) << 16 | (nr_bits))
+#define BTF_TYPE_INT_ENC(name, encoding, bits_offset, bits, sz) \
+	BTF_TYPE_ENC(name, BTF_INFO_ENC(BTF_KIND_INT, 0, 0), sz), \
+	BTF_INT_ENC(encoding, bits_offset, bits)
+
+static int btf_load(void)
+{
+	struct btf_blob {
+		struct btf_header btf_hdr;
+		__u32 types[8];
+		__u32 str;
+	} raw_btf = {
+		.btf_hdr = {
+			.magic = BTF_MAGIC,
+			.version = BTF_VERSION,
+			.hdr_len = sizeof(struct btf_header),
+			.type_len = sizeof(__u32) * 8,
+			.str_off = sizeof(__u32) * 8,
+			.str_len = sizeof(__u32),
+		},
+		.types = {
+			/* long */
+			BTF_TYPE_INT_ENC(0, BTF_INT_SIGNED, 0, 64, 8),  /* [1] */
+			/* unsigned long */
+			BTF_TYPE_INT_ENC(0, 0, 0, 64, 8),  /* [2] */
+		},
+	};
+	static union bpf_attr btf_load_attr = {
+		.btf_size = sizeof(raw_btf),
+	};
+
+	btf_load_attr.btf = (long)&raw_btf;
+	return bpf_sys_bpf(BPF_BTF_LOAD, &btf_load_attr, sizeof(btf_load_attr));
+}
+
 SEC("syscall")
 int bpf_prog(struct args *ctx)
 {
@@ -35,6 +75,8 @@ int bpf_prog(struct args *ctx)
 		.map_type = BPF_MAP_TYPE_HASH,
 		.key_size = 8,
 		.value_size = 8,
+		.btf_key_type_id = 1,
+		.btf_value_type_id = 2,
 	};
 	static union bpf_attr map_update_attr = { .map_fd = 1, };
 	static __u64 key = 12;
@@ -45,7 +87,13 @@ int bpf_prog(struct args *ctx)
 	};
 	int ret;
 
+	ret = btf_load();
+	if (ret < 0)
+		return ret;
+
 	map_create_attr.max_entries = ctx->max_entries;
+	map_create_attr.btf_fd = ret;
+
 	prog_load_attr.license = (long) license;
 	prog_load_attr.insns = (long) insns;
 	prog_load_attr.log_buf = ctx->log_buf;
-- 
2.30.2

