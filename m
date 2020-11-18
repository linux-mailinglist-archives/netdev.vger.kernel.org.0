Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8AC2B76C2
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 08:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgKRHRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 02:17:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgKRHRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 02:17:08 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7D5C0613D4;
        Tue, 17 Nov 2020 23:17:08 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id q5so839922pfk.6;
        Tue, 17 Nov 2020 23:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0w+Bq27/X0GIM1BI/NmY3YCnW8k8aSVxxtLiS5VSHa4=;
        b=BAXFUOgaXVa9W++H6CMOkJixDx0G47ljK4t+NNAQFx5YmxZjVgw0o88tLe/U8RW4NX
         8NcG0+CeDGitGfgdPVrDierjmX6fPqWgkH3NC2pO+7dcaDjcmyY+PDTJIF2dQxfr0c0C
         HRUTm2+/HQgZtX0X4cwHKzNTjki5+AWY8nUwNCmSvEntvZM6EQIB9oK1tLkJL64FJiu8
         at02S8TH+mKvsmILkehhskO/Nlf+qsFMgen3VSzqKtkldIZXDMX3F91BuMiuX5XCyHMN
         YKyHzeD8HsmpAHqhFunJJsxXx6sWGqE9TA/7u4PeiyFf5iIhDMIibUmw6xF2B7K5YRvf
         mJfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0w+Bq27/X0GIM1BI/NmY3YCnW8k8aSVxxtLiS5VSHa4=;
        b=RsAS5tjXa8gTOPdoWvrI7ze8JFmZpCfZj3aHFSNsPsGpDWvOgM8J/3rIOCirllY9MU
         454yHuIs+uiPdKBpX4d5yvYfad5ZnbTXB1c5UzN0zWhhYrgML12AB/TKaLFR1fJReS0a
         Wj9XOkABlpsPTJqYFdS7Kwi126SWZCuZSZuijlTpHTXahPGNk1+jIiKeZfibizwjTQHJ
         jakv6ec4eGQR2piLmwt3OEVrz+H/BGrppW0zPDYqeDkbeE4v1FWO+KwYhbIGUflYzVE9
         XLEcrc/kqS79BNl0p0Zt6Jhr7P57q4toFCAsovCOROtMX+N8kr7wrxYcFtxpODTatPp1
         ntNQ==
X-Gm-Message-State: AOAM532pvirV/RvtT5b5L9DV77R+MGoahdGzuuq1NwdpYCAeV40UJ95i
        hQpnVSuN5Si0wfHAaUTGR4Q=
X-Google-Smtp-Source: ABdhPJwpbP84Y6/nHU0afdC6CD4TN367l8gQUfUEiJcxtBej/sP2oyRducY8Glp7q5EE52FJffNoVQ==
X-Received: by 2002:a62:7895:0:b029:18b:de24:2a9d with SMTP id t143-20020a6278950000b029018bde242a9dmr3429699pfc.21.1605683827746;
        Tue, 17 Nov 2020 23:17:07 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.45])
        by smtp.gmail.com with ESMTPSA id e128sm23019382pfe.154.2020.11.17.23.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 23:17:06 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        xi.wang@gmail.com, luke.r.nels@gmail.com,
        linux-riscv@lists.infradead.org, andrii.nakryiko@gmail.com
Subject: [PATCH bpf-next v2 3/3] selftests/bpf: Mark tests that require unaligned memory access
Date:   Wed, 18 Nov 2020 08:16:40 +0100
Message-Id: <20201118071640.83773-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201118071640.83773-1-bjorn.topel@gmail.com>
References: <20201118071640.83773-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A lot of tests require unaligned memory access to work. Mark the tests
as such, so that they can be avoided on unsupported architectures such
as RISC-V.

Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
---
 .../selftests/bpf/verifier/ctx_sk_lookup.c    |  7 +++
 .../bpf/verifier/direct_value_access.c        |  3 ++
 .../testing/selftests/bpf/verifier/map_ptr.c  |  1 +
 .../selftests/bpf/verifier/raw_tp_writable.c  |  1 +
 .../selftests/bpf/verifier/ref_tracking.c     |  4 ++
 .../testing/selftests/bpf/verifier/regalloc.c |  8 ++++
 .../selftests/bpf/verifier/wide_access.c      | 46 +++++++++++--------
 7 files changed, 52 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c b/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c
index 2ad5f974451c..fb13ca2d5606 100644
--- a/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c
+++ b/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c
@@ -266,6 +266,7 @@
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
 	.expected_attach_type = BPF_SK_LOOKUP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"invalid 8-byte read from bpf_sk_lookup remote_ip4 field",
@@ -292,6 +293,7 @@
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
 	.expected_attach_type = BPF_SK_LOOKUP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"invalid 8-byte read from bpf_sk_lookup remote_port field",
@@ -305,6 +307,7 @@
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
 	.expected_attach_type = BPF_SK_LOOKUP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"invalid 8-byte read from bpf_sk_lookup local_ip4 field",
@@ -331,6 +334,7 @@
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
 	.expected_attach_type = BPF_SK_LOOKUP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"invalid 8-byte read from bpf_sk_lookup local_port field",
@@ -344,6 +348,7 @@
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
 	.expected_attach_type = BPF_SK_LOOKUP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 /* invalid 1,2,4-byte reads from 8-byte fields in bpf_sk_lookup */
 {
@@ -410,6 +415,7 @@
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
 	.expected_attach_type = BPF_SK_LOOKUP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"invalid 4-byte unaligned read from bpf_sk_lookup at even offset",
@@ -422,6 +428,7 @@
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
 	.expected_attach_type = BPF_SK_LOOKUP,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 /* in-bound and out-of-bound writes to bpf_sk_lookup */
 {
diff --git a/tools/testing/selftests/bpf/verifier/direct_value_access.c b/tools/testing/selftests/bpf/verifier/direct_value_access.c
index 988f46a1a4c7..c0648dc009b5 100644
--- a/tools/testing/selftests/bpf/verifier/direct_value_access.c
+++ b/tools/testing/selftests/bpf/verifier/direct_value_access.c
@@ -69,6 +69,7 @@
 	.fixup_map_array_48b = { 1 },
 	.result = REJECT,
 	.errstr = "R1 min value is outside of the allowed memory range",
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"direct map access, write test 7",
@@ -195,6 +196,7 @@
 	.fixup_map_array_48b = { 1, 3 },
 	.result = REJECT,
 	.errstr = "invalid access to map value, value_size=48 off=47 size=2",
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"direct map access, write test 17",
@@ -209,6 +211,7 @@
 	.fixup_map_array_48b = { 1, 3 },
 	.result = REJECT,
 	.errstr = "invalid access to map value, value_size=48 off=47 size=2",
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"direct map access, write test 18",
diff --git a/tools/testing/selftests/bpf/verifier/map_ptr.c b/tools/testing/selftests/bpf/verifier/map_ptr.c
index 637f9293bda8..b117bdd3806d 100644
--- a/tools/testing/selftests/bpf/verifier/map_ptr.c
+++ b/tools/testing/selftests/bpf/verifier/map_ptr.c
@@ -44,6 +44,7 @@
 	.errstr_unpriv = "bpf_array access is allowed only to CAP_PERFMON and CAP_SYS_ADMIN",
 	.result = REJECT,
 	.errstr = "cannot access ptr member ops with moff 0 in struct bpf_map with off 1 size 4",
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"bpf_map_ptr: read ops field accepted",
diff --git a/tools/testing/selftests/bpf/verifier/raw_tp_writable.c b/tools/testing/selftests/bpf/verifier/raw_tp_writable.c
index 95b5d70a1dc1..2978fb5a769d 100644
--- a/tools/testing/selftests/bpf/verifier/raw_tp_writable.c
+++ b/tools/testing/selftests/bpf/verifier/raw_tp_writable.c
@@ -31,4 +31,5 @@
 	.fixup_map_hash_8b = { 1, },
 	.prog_type = BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
 	.errstr = "R6 invalid variable buffer offset: off=0, var_off=(0x0; 0xffffffff)",
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
diff --git a/tools/testing/selftests/bpf/verifier/ref_tracking.c b/tools/testing/selftests/bpf/verifier/ref_tracking.c
index 006b5bd99c08..3b6ee009c00b 100644
--- a/tools/testing/selftests/bpf/verifier/ref_tracking.c
+++ b/tools/testing/selftests/bpf/verifier/ref_tracking.c
@@ -675,6 +675,7 @@
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	.result = REJECT,
 	.errstr = "invalid mem access",
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"reference tracking: use ptr from bpf_sk_fullsock() after release",
@@ -698,6 +699,7 @@
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	.result = REJECT,
 	.errstr = "invalid mem access",
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"reference tracking: use ptr from bpf_sk_fullsock(tp) after release",
@@ -725,6 +727,7 @@
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	.result = REJECT,
 	.errstr = "invalid mem access",
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"reference tracking: use sk after bpf_sk_release(tp)",
@@ -747,6 +750,7 @@
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	.result = REJECT,
 	.errstr = "invalid mem access",
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"reference tracking: use ptr from bpf_get_listener_sock() after bpf_sk_release(sk)",
diff --git a/tools/testing/selftests/bpf/verifier/regalloc.c b/tools/testing/selftests/bpf/verifier/regalloc.c
index 4ad7e05de706..bb0dd89dd212 100644
--- a/tools/testing/selftests/bpf/verifier/regalloc.c
+++ b/tools/testing/selftests/bpf/verifier/regalloc.c
@@ -21,6 +21,7 @@
 	.fixup_map_hash_48b = { 4 },
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"regalloc negative",
@@ -71,6 +72,7 @@
 	.fixup_map_hash_48b = { 4 },
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"regalloc src_reg negative",
@@ -97,6 +99,7 @@
 	.result = REJECT,
 	.errstr = "invalid access to map value, value_size=48 off=44 size=8",
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"regalloc and spill",
@@ -126,6 +129,7 @@
 	.fixup_map_hash_48b = { 4 },
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"regalloc and spill negative",
@@ -156,6 +160,7 @@
 	.result = REJECT,
 	.errstr = "invalid access to map value, value_size=48 off=48 size=8",
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"regalloc three regs",
@@ -182,6 +187,7 @@
 	.fixup_map_hash_48b = { 4 },
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"regalloc after call",
@@ -210,6 +216,7 @@
 	.fixup_map_hash_48b = { 4 },
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"regalloc in callee",
@@ -240,6 +247,7 @@
 	.fixup_map_hash_48b = { 4 },
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
 	"regalloc, spill, JEQ",
diff --git a/tools/testing/selftests/bpf/verifier/wide_access.c b/tools/testing/selftests/bpf/verifier/wide_access.c
index ccade9312d21..55af248efa93 100644
--- a/tools/testing/selftests/bpf/verifier/wide_access.c
+++ b/tools/testing/selftests/bpf/verifier/wide_access.c
@@ -1,4 +1,4 @@
-#define BPF_SOCK_ADDR_STORE(field, off, res, err) \
+#define BPF_SOCK_ADDR_STORE(field, off, res, err, flgs)	\
 { \
 	"wide store to bpf_sock_addr." #field "[" #off "]", \
 	.insns = { \
@@ -11,31 +11,36 @@
 	.prog_type = BPF_PROG_TYPE_CGROUP_SOCK_ADDR, \
 	.expected_attach_type = BPF_CGROUP_UDP6_SENDMSG, \
 	.errstr = err, \
+	.flags = flgs, \
 }
 
 /* user_ip6[0] is u64 aligned */
 BPF_SOCK_ADDR_STORE(user_ip6, 0, ACCEPT,
-		    NULL),
+		    NULL, 0),
 BPF_SOCK_ADDR_STORE(user_ip6, 1, REJECT,
-		    "invalid bpf_context access off=12 size=8"),
+		    "invalid bpf_context access off=12 size=8",
+		    F_NEEDS_EFFICIENT_UNALIGNED_ACCESS),
 BPF_SOCK_ADDR_STORE(user_ip6, 2, ACCEPT,
-		    NULL),
+		    NULL, 0),
 BPF_SOCK_ADDR_STORE(user_ip6, 3, REJECT,
-		    "invalid bpf_context access off=20 size=8"),
+		    "invalid bpf_context access off=20 size=8",
+		    F_NEEDS_EFFICIENT_UNALIGNED_ACCESS),
 
 /* msg_src_ip6[0] is _not_ u64 aligned */
 BPF_SOCK_ADDR_STORE(msg_src_ip6, 0, REJECT,
-		    "invalid bpf_context access off=44 size=8"),
+		    "invalid bpf_context access off=44 size=8",
+		    F_NEEDS_EFFICIENT_UNALIGNED_ACCESS),
 BPF_SOCK_ADDR_STORE(msg_src_ip6, 1, ACCEPT,
-		    NULL),
+		    NULL, 0),
 BPF_SOCK_ADDR_STORE(msg_src_ip6, 2, REJECT,
-		    "invalid bpf_context access off=52 size=8"),
+		    "invalid bpf_context access off=52 size=8",
+		    F_NEEDS_EFFICIENT_UNALIGNED_ACCESS),
 BPF_SOCK_ADDR_STORE(msg_src_ip6, 3, REJECT,
-		    "invalid bpf_context access off=56 size=8"),
+		    "invalid bpf_context access off=56 size=8", 0),
 
 #undef BPF_SOCK_ADDR_STORE
 
-#define BPF_SOCK_ADDR_LOAD(field, off, res, err) \
+#define BPF_SOCK_ADDR_LOAD(field, off, res, err, flgs)	\
 { \
 	"wide load from bpf_sock_addr." #field "[" #off "]", \
 	.insns = { \
@@ -48,26 +53,31 @@ BPF_SOCK_ADDR_STORE(msg_src_ip6, 3, REJECT,
 	.prog_type = BPF_PROG_TYPE_CGROUP_SOCK_ADDR, \
 	.expected_attach_type = BPF_CGROUP_UDP6_SENDMSG, \
 	.errstr = err, \
+	.flags = flgs, \
 }
 
 /* user_ip6[0] is u64 aligned */
 BPF_SOCK_ADDR_LOAD(user_ip6, 0, ACCEPT,
-		   NULL),
+		   NULL, 0),
 BPF_SOCK_ADDR_LOAD(user_ip6, 1, REJECT,
-		   "invalid bpf_context access off=12 size=8"),
+		   "invalid bpf_context access off=12 size=8",
+		    F_NEEDS_EFFICIENT_UNALIGNED_ACCESS),
 BPF_SOCK_ADDR_LOAD(user_ip6, 2, ACCEPT,
-		   NULL),
+		   NULL, 0),
 BPF_SOCK_ADDR_LOAD(user_ip6, 3, REJECT,
-		   "invalid bpf_context access off=20 size=8"),
+		   "invalid bpf_context access off=20 size=8",
+		    F_NEEDS_EFFICIENT_UNALIGNED_ACCESS),
 
 /* msg_src_ip6[0] is _not_ u64 aligned */
 BPF_SOCK_ADDR_LOAD(msg_src_ip6, 0, REJECT,
-		   "invalid bpf_context access off=44 size=8"),
+		   "invalid bpf_context access off=44 size=8",
+		    F_NEEDS_EFFICIENT_UNALIGNED_ACCESS),
 BPF_SOCK_ADDR_LOAD(msg_src_ip6, 1, ACCEPT,
-		   NULL),
+		   NULL, 0),
 BPF_SOCK_ADDR_LOAD(msg_src_ip6, 2, REJECT,
-		   "invalid bpf_context access off=52 size=8"),
+		   "invalid bpf_context access off=52 size=8",
+		    F_NEEDS_EFFICIENT_UNALIGNED_ACCESS),
 BPF_SOCK_ADDR_LOAD(msg_src_ip6, 3, REJECT,
-		   "invalid bpf_context access off=56 size=8"),
+		   "invalid bpf_context access off=56 size=8", 0),
 
 #undef BPF_SOCK_ADDR_LOAD
-- 
2.27.0

