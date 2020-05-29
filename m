Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DB21E74F9
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 06:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgE2Ei7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 00:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgE2Eis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 00:38:48 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61368C08C5C6;
        Thu, 28 May 2020 21:38:48 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y198so645082pfb.4;
        Thu, 28 May 2020 21:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=h4ZHrkBgJpMmqdfVG33n92n7yUXUN91GchFFtsy+Ugw=;
        b=eNsLLAIPN50kCmKBGKqeIVdZe6yDQC48Frtm5lj2RKnLBsnV2BbQn9MJD+9egUbARt
         D+wnx+D8i6vByDyOQXz49irZkgyQzjkzPZmmHH+H438ti90YM/TUn03AQSJrGMHnZ3SQ
         NgDkPspmFFEBELL3u77oRpZnhpCZtq07iUL+MNIpamH5Rkgz+471de4ilV+zkBD926hi
         xCVPzDBQW2rU5ZY2axhGSIAPQ7yPfGA9oclZijNyW+9zzJUI9KsR01oKHjZkdVidGo1f
         75oW5Y92mZF9wVuiSr5Fa/Wrxx4opoCpx7BPLOggAX/wHoVjj7oTHK2mpnw2Kr3G8XMU
         mG7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=h4ZHrkBgJpMmqdfVG33n92n7yUXUN91GchFFtsy+Ugw=;
        b=rPWU4+4ktXpPqCiSTDuLiQKPpjoT1CcvIEt7tnESOIQjBB/huahbtokPwm/45r07wq
         ql2hP1fCACJOVX6BdjinGh567KCq//kM/z9JbK+BH7Q9H8x7VNNKM0M5s+6qR2QUartB
         T6acE8v7aGGtn79APxhBwMbojw2AZ7r/4kUluS5Mscbm+dvNKRwWKM0KEnzJVKaKVTOT
         tQ74jhaNN5PJubZ+m31Q5G+9uE0r/DUvcRToDz++Ix+IHCxaWy/EmUgtG+Z4s43D7g/e
         Z5WmwgGsALP8EHjUcxq28uyqWpBJOer7IHZZW7HOgvDT+yxhKm1hGablIA4sFWeFVa+k
         /Ycw==
X-Gm-Message-State: AOAM533VMeIDF+3FBsQv7360EL/2r/VfIwnvtazg3iRR/oZQHxY5TkXC
        1/qN8nlmBoYp8LG0AL58PoI=
X-Google-Smtp-Source: ABdhPJwYL73PfNa8m+wjBjB4qrVnf3jxUHb0RSddv3pOM/qI4Ly+UPLO2Z7OlVWcpwMrLod3Mb21fw==
X-Received: by 2002:a65:4241:: with SMTP id d1mr247197pgq.307.1590727127955;
        Thu, 28 May 2020 21:38:47 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id w73sm6288777pfd.113.2020.05.28.21.38.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 May 2020 21:38:47 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v2 bpf-next 3/4] libbpf: support sleepable progs
Date:   Thu, 28 May 2020 21:38:38 -0700
Message-Id: <20200529043839.15824-4-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200529043839.15824-1-alexei.starovoitov@gmail.com>
References: <20200529043839.15824-1-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Pass request to load program as sleepable via ".s" suffix in the section name.
If it happens in the future that all map types and helpers are allowed with
BPF_F_SLEEPABLE flag "fmod_ret/" and "lsm/" can be aliased to "fmod_ret.s/" and
"lsm.s/" to make all lsm and fmod_ret programs sleepable by default. The fentry
and fexit programs would always need to have sleepable vs non-sleepable
distinction, since not all fentry/fexit progs will be attached to sleepable
kernel functions.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: KP Singh <kpsingh@google.com>
---
 tools/lib/bpf/libbpf.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 74d967619dcf..d59a362ab8f9 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -209,6 +209,7 @@ struct bpf_sec_def {
 	bool is_exp_attach_type_optional;
 	bool is_attachable;
 	bool is_attach_btf;
+	bool is_sleepable;
 	attach_fn_t attach_fn;
 };
 
@@ -5451,6 +5452,8 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 			/* couldn't guess, but user might manually specify */
 			continue;
 
+		if (prog->sec_def->is_sleepable)
+			prog->prog_flags |= BPF_F_SLEEPABLE;
 		bpf_program__set_type(prog, prog->sec_def->prog_type);
 		bpf_program__set_expected_attach_type(prog,
 				prog->sec_def->expected_attach_type);
@@ -6646,6 +6649,21 @@ static const struct bpf_sec_def section_defs[] = {
 		.expected_attach_type = BPF_TRACE_FEXIT,
 		.is_attach_btf = true,
 		.attach_fn = attach_trace),
+	SEC_DEF("fentry.s/", TRACING,
+		.expected_attach_type = BPF_TRACE_FENTRY,
+		.is_attach_btf = true,
+		.is_sleepable = true,
+		.attach_fn = attach_trace),
+	SEC_DEF("fmod_ret.s/", TRACING,
+		.expected_attach_type = BPF_MODIFY_RETURN,
+		.is_attach_btf = true,
+		.is_sleepable = true,
+		.attach_fn = attach_trace),
+	SEC_DEF("fexit.s/", TRACING,
+		.expected_attach_type = BPF_TRACE_FEXIT,
+		.is_attach_btf = true,
+		.is_sleepable = true,
+		.attach_fn = attach_trace),
 	SEC_DEF("freplace/", EXT,
 		.is_attach_btf = true,
 		.attach_fn = attach_trace),
@@ -6653,6 +6671,11 @@ static const struct bpf_sec_def section_defs[] = {
 		.is_attach_btf = true,
 		.expected_attach_type = BPF_LSM_MAC,
 		.attach_fn = attach_lsm),
+	SEC_DEF("lsm.s/", LSM,
+		.is_attach_btf = true,
+		.is_sleepable = true,
+		.expected_attach_type = BPF_LSM_MAC,
+		.attach_fn = attach_lsm),
 	SEC_DEF("iter/", TRACING,
 		.expected_attach_type = BPF_TRACE_ITER,
 		.is_attach_btf = true,
@@ -7292,7 +7315,7 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 
 		prog->prog_ifindex = attr->ifindex;
 		prog->log_level = attr->log_level;
-		prog->prog_flags = attr->prog_flags;
+		prog->prog_flags |= attr->prog_flags;
 		if (!first_prog)
 			first_prog = prog;
 	}
-- 
2.23.0

