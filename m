Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA6C1F7006
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgFKWX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgFKWXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 18:23:52 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B12C03E96F;
        Thu, 11 Jun 2020 15:23:51 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t7so2886586plr.0;
        Thu, 11 Jun 2020 15:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LkUP5sexiz8AFdMo14B9pC63P4eMSqbXdns0vvW2pzo=;
        b=TOKYSjUINUA+5D95s3pX0YJ9nVDtlTG+eZKFyZMfvmYCluYGnU25sZC4MZfNtXePWD
         tEkTyb5CYmmDpQ7zIycs8I5gTFFUBdQA+Lxgr8vh48sfGvygHkV+SpZBovj0uDMd6FMQ
         8rr8s5dtmGoL0ZEHVtcgCQX9LnR3/2a6APTk2A5zbnwe2v5kiHrPDVkU1aWnSnGykYyc
         fB82sdM9ejlVHAQV2AIrlsP1BumIXIPH2vBovJxRJ4cRDtXrxFNQxlt+FW1hHFpfxQqy
         +ht6ARHerxQtcOeRRUmB6620dATgWEMK/91/wpSN/MoG30FCEwSEcbNRz07KHbr2VyFe
         K4nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LkUP5sexiz8AFdMo14B9pC63P4eMSqbXdns0vvW2pzo=;
        b=WKHw0BAKWoemW60Io67wmUbBd3MvT8v6BWe2UPAPxlyyR7RASqpO+6ig9mHa62MIG5
         rfSH3y3n2da2F39hWjVPn7MiYWYTMOffAvBSN6FHXrnoCzPD+tpSo4U7d3ZZk2xzx4aQ
         gcpy8gLROuI6DbqJvZaV7OMb0kd2VnV7SR1SSSpaG2dLvGVzmc0OWrq84dzE2rjdA3Uk
         t5bMGFkKXFvClDOhnG7KV9WRufeHCn/pKWGw8y+ms+z5tRKSugWG682PI+R40qPTXbkA
         nEgP5jG/7bRFGG3BUcVZIN3HALAXJQFxeF9JIkjrb5CZSF5XAy8G+N8poqhEyC6dVUIi
         pa2g==
X-Gm-Message-State: AOAM5308dZLDjWimJAv+OaAlaMoW77Vl3w5LYrx2TWt85BJixnZdXCoz
        4H0964ylfc65RFJ3TSVRgXk=
X-Google-Smtp-Source: ABdhPJxY/QnPQaxBEYxdIJwm88KyXiDwLKqSxcEXygsc/BkcwLhsQiIRQcScshZtxn9Jf1ljQj+sLg==
X-Received: by 2002:a17:902:d392:: with SMTP id e18mr8875203pld.295.1591914230690;
        Thu, 11 Jun 2020 15:23:50 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id nl11sm8660651pjb.0.2020.06.11.15.23.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jun 2020 15:23:49 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, paulmck@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH RFC v3 bpf-next 3/4] libbpf: support sleepable progs
Date:   Thu, 11 Jun 2020 15:23:39 -0700
Message-Id: <20200611222340.24081-4-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200611222340.24081-1-alexei.starovoitov@gmail.com>
References: <20200611222340.24081-1-alexei.starovoitov@gmail.com>
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
index 7f01be2b88b8..936ce9e1623a 100644
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
@@ -7294,7 +7317,7 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 
 		prog->prog_ifindex = attr->ifindex;
 		prog->log_level = attr->log_level;
-		prog->prog_flags = attr->prog_flags;
+		prog->prog_flags |= attr->prog_flags;
 		if (!first_prog)
 			first_prog = prog;
 	}
-- 
2.23.0

