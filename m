Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F962550E1
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 00:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgH0WBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 18:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727784AbgH0WB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 18:01:27 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86164C061264;
        Thu, 27 Aug 2020 15:01:26 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ds1so3357741pjb.1;
        Thu, 27 Aug 2020 15:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lF9GoJia/BdQro05C97aOHJN/7tOJrlcHilgbqvUTmk=;
        b=W4eyEDWtJ9SZSZjXqkHcwoKxvh0FVZtIpgVnmcAf8MSwiFKwfIy1YLSp+4Mga+fDSx
         fS+8wPRnPMPPnAc4KYFeXQoWZuZ9MToHnW0HwCrWiNNE8XZ2+eboXETyzTQvUYs1aH3O
         51fLicqYm2AeqN+SUmCKFmLYM8fqDINcN9Kae1yn4u7xuCIQX9UVvSAuwIFeSIPtV0sE
         YXjjI1pvgx1Re/TnEhClDxrs80Or8xACeUWpKk6vKe8t7o6seZ50k6fGpcInh1h9gPJq
         RjLLmE2kitPNyi1S5qRcD112rhqRG2NVUY7GM8wbPAIfllUA7elEk/aSPf9zxWUf9M8G
         UfmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lF9GoJia/BdQro05C97aOHJN/7tOJrlcHilgbqvUTmk=;
        b=K/+Yq9evNtmMNTu4/ycyy4qPHKt+KutIlitIzNkuvgwQRSrbVk0NIVJNLMlSXLsZfK
         z7nuAuh+MuyQvFkdIYQ3m8rk1hKCnKYjKfZusORRqVYX8GsBQNprSMtFOT1Zqpgvgqh9
         +PoenXo06iqbqAPMdQ0a32lGe1r5bjUgYtwDtuCCC6QfQiVJ9pHuV9yw4MPvWnii9Lm3
         Fk5uxj60S4ufDWodZEdBJbrPwrJMaCbv24jW7n6dW1SAu2A2uh9pxHgdLrGRZ2pBAqZN
         ipdKY0XTy3wm/V6mqRiv6u4GKVF7dJA5J0Be+nN00idDvDQoRV8wt5j+x+yfaokbiZ/6
         /HTQ==
X-Gm-Message-State: AOAM531EColyMUdhoedX/sClouEtXa7tNmxK9mSkowOucHnfPWwKf6ee
        92LN2dd+PA35yrayUD0kKAw=
X-Google-Smtp-Source: ABdhPJxfIWiDWre+E8v8i+FQq9nrcZaMKIdjG2jnADcfsGyGtjFVhSGzU9RkZNcmVOoLoYFfBCDhKg==
X-Received: by 2002:a17:90a:bb83:: with SMTP id v3mr764681pjr.177.1598565686047;
        Thu, 27 Aug 2020 15:01:26 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id x28sm3997564pfq.62.2020.08.27.15.01.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2020 15:01:25 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, josef@toxicpanda.com, bpoirier@suse.com,
        akpm@linux-foundation.org, hannes@cmpxchg.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v3 bpf-next 4/5] libbpf: support sleepable progs
Date:   Thu, 27 Aug 2020 15:01:13 -0700
Message-Id: <20200827220114.69225-5-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200827220114.69225-1-alexei.starovoitov@gmail.com>
References: <20200827220114.69225-1-alexei.starovoitov@gmail.com>
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
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 8cdb2528482e..b688aadf09c5 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -208,6 +208,7 @@ struct bpf_sec_def {
 	bool is_exp_attach_type_optional;
 	bool is_attachable;
 	bool is_attach_btf;
+	bool is_sleepable;
 	attach_fn_t attach_fn;
 };
 
@@ -6291,6 +6292,8 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 			/* couldn't guess, but user might manually specify */
 			continue;
 
+		if (prog->sec_def->is_sleepable)
+			prog->prog_flags |= BPF_F_SLEEPABLE;
 		bpf_program__set_type(prog, prog->sec_def->prog_type);
 		bpf_program__set_expected_attach_type(prog,
 				prog->sec_def->expected_attach_type);
@@ -7559,6 +7562,21 @@ static const struct bpf_sec_def section_defs[] = {
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
@@ -7566,6 +7584,11 @@ static const struct bpf_sec_def section_defs[] = {
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
@@ -8288,7 +8311,7 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 
 		prog->prog_ifindex = attr->ifindex;
 		prog->log_level = attr->log_level;
-		prog->prog_flags = attr->prog_flags;
+		prog->prog_flags |= attr->prog_flags;
 		if (!first_prog)
 			first_prog = prog;
 	}
-- 
2.23.0

