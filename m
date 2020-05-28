Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B7B1E5683
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 07:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgE1Fdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 01:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgE1Fdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 01:33:41 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D472C05BD1E;
        Wed, 27 May 2020 22:33:41 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p21so12872405pgm.13;
        Wed, 27 May 2020 22:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=U2Q9gUnZRFVmHKvj84PmwBmM/7agqbUryktJrVPtTsI=;
        b=L9AkCBWB0zyNWtidhVO6qKQPNEB0R7cHgVYqlOg/XnNbmuW4yMnP+W/08c8VVCMzTb
         kx9nlMxUR262RiJygGx0pId8Yn2cfXKrkmYHE4cZ4k8zWfsx9kjYPpDi0jfA5U9nuJ9J
         +InCl4FyKnJVawvXuJSHxF6NEqoou0MkkjhhXrLG9AGfxOh834UhicPz3Lov/Yzb8yxx
         uU9Ys/SBjvcJnvD2BbjDD9VM/v/NwIN3HH3kv+E8EZipsmUWdXCoKhGol4OrjribjZy5
         YtCmNn7ss6cO9xG2zwwAGeP78xHiZpQToTs1ZZlpTZTeTgjVLuOlJ5iUfj23rMBTMxtF
         sWNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=U2Q9gUnZRFVmHKvj84PmwBmM/7agqbUryktJrVPtTsI=;
        b=TtqcrBAgWT8+VkIoOECktDSgr5aVYv0NXbFzbRn2PfrRZt9WydrMh1Sv4f1GpNqtVg
         Jxq5fitsPOW1LW+3b5R8LyG8rX6WfjZpIICwE8rVMhJJ4uHDPdkga2yTLLorEU7h4gV4
         BF5y/4f5+pgHG+ZNRNCmsG1XXmXpnGm7fN0WOmZ1JtqxnOhEFbgzCvP+tjeaLZp4x+gn
         PRoI+ysxardHLpJidS/6dg59PqqJJ9g5/s6zMnotmbKtffC5A6gQNpVBANY0/5SCMf8m
         VCZPHCro2XNw5ErhgM7cbEC42jVsihafPdozDqs23LNr6Ih+G95LfkFp3PtMNXJx1TOv
         gddw==
X-Gm-Message-State: AOAM533gY5ah6ufRPgSGk9VSG+O8yPkxt4I9IDhknAlXs6mzf+Q+1zXj
        azObDTPq6ZnvQ3Oz/eSOhePG1QrY
X-Google-Smtp-Source: ABdhPJzbxyvTVfXuBvE7MTeha5mQCPybjxbolz8LYygyzbiKwZKUf3qdVFn/uUJ0vJe4B4XMV2OlnQ==
X-Received: by 2002:a62:79c2:: with SMTP id u185mr1370971pfc.159.1590644021092;
        Wed, 27 May 2020 22:33:41 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id o27sm3502461pgd.18.2020.05.27.22.33.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 May 2020 22:33:40 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 2/3] libbpf: support sleepable progs
Date:   Wed, 27 May 2020 22:33:33 -0700
Message-Id: <20200528053334.89293-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200528053334.89293-1-alexei.starovoitov@gmail.com>
References: <20200528053334.89293-1-alexei.starovoitov@gmail.com>
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
---
 tools/lib/bpf/libbpf.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 5d60de6fd818..d5dc9a1abea3 100644
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

