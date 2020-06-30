Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07DB20EA4F
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbgF3Aey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgF3Aev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 20:34:51 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC00EC061755;
        Mon, 29 Jun 2020 17:34:50 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id a14so4059240pfi.2;
        Mon, 29 Jun 2020 17:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=I5Dv5raHq6PKZyEpvvq0aeWAhucJ0jOmmbBdZJh0B1Y=;
        b=JN/fgGfSacZedbz7M6C4AVLeRNaVJ1u34NkbjTO25zboFUppPjiG6noVCx8Qp95+SF
         cV+IomRwr+KXtDN+hLZLgeR9X1wXUOBWkBIcmshCCzocZTkZ0HdT1k9AV4JQxaqVrOO+
         Y5I8vwHSOMnLdSUTGKz/CZsRVL7fBJO/OA8DApXw1mAWxEGn9QudInMbavNALgO+rS6T
         kuyz5xbFeFwmBK9rIzirzuB0YniHl5A03L7RrPqn0eg4QPXiVSc+pKAfRXzYoXjuMKqo
         fN7t4jlkLL4xUCAlj8snTFlxmpvuL+VbWUUu6r7Bcwq5iYqQ5tYhAkezOl1XqpEW6UOa
         0KcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=I5Dv5raHq6PKZyEpvvq0aeWAhucJ0jOmmbBdZJh0B1Y=;
        b=Otoc6we04sUsr1q7c58a/y3i0BrfKyjqT39AOLmImSRbcsWzlLDTkkpZTz0TRD2tSI
         iTYdtzO4EXEZOeNwNRlLzXif8+TZG1WpeHKOI+NsZ7vxWeFURH1O+bbpOhGerQs0zTGN
         /V6vYsPjr2EJtto0Ad6iIsZqqIpJ9+RYADqc9sHzj8LRX/MdtpIvdhOL4sCulEJLfHGR
         Q3ijv3e+GEvbX7ZWvfzmIc1CwjD1Qkjt5rjocgyMWwBo23lVVpcss+vwt2q/ZvizHvvx
         PwoozFkiKOnfRgKCFj70sgYponJITaEkHtpg2DvYmoIdYtQ4RNGXdHFXLmTAtH95sK+F
         h5GQ==
X-Gm-Message-State: AOAM532pdb4fx2HQJfXd2q8iGDiGYoInzpwm9EowFK3zNdHUri0Mw5Me
        8FEz780DqCtcV6uG6eiE6IA=
X-Google-Smtp-Source: ABdhPJxEBXo9jjcxOH6c8+M2Yxex416nTtfVGPrjI/baQv0WNsJZ9+hMSmfjYDTv+IqRea3XzQSuTQ==
X-Received: by 2002:a63:dd42:: with SMTP id g2mr13253436pgj.442.1593477290305;
        Mon, 29 Jun 2020 17:34:50 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id b4sm700658pfo.137.2020.06.29.17.34.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jun 2020 17:34:49 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, paulmck@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v4 bpf-next 4/5] libbpf: support sleepable progs
Date:   Mon, 29 Jun 2020 17:34:40 -0700
Message-Id: <20200630003441.42616-5-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200630003441.42616-1-alexei.starovoitov@gmail.com>
References: <20200630003441.42616-1-alexei.starovoitov@gmail.com>
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
index 4ea7f4f1a691..c2f054fde30f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -209,6 +209,7 @@ struct bpf_sec_def {
 	bool is_exp_attach_type_optional;
 	bool is_attachable;
 	bool is_attach_btf;
+	bool is_sleepable;
 	attach_fn_t attach_fn;
 };
 
@@ -5626,6 +5627,8 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 			/* couldn't guess, but user might manually specify */
 			continue;
 
+		if (prog->sec_def->is_sleepable)
+			prog->prog_flags |= BPF_F_SLEEPABLE;
 		bpf_program__set_type(prog, prog->sec_def->prog_type);
 		bpf_program__set_expected_attach_type(prog,
 				prog->sec_def->expected_attach_type);
@@ -6893,6 +6896,21 @@ static const struct bpf_sec_def section_defs[] = {
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
@@ -6900,6 +6918,11 @@ static const struct bpf_sec_def section_defs[] = {
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
@@ -7614,7 +7637,7 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 
 		prog->prog_ifindex = attr->ifindex;
 		prog->log_level = attr->log_level;
-		prog->prog_flags = attr->prog_flags;
+		prog->prog_flags |= attr->prog_flags;
 		if (!first_prog)
 			first_prog = prog;
 	}
-- 
2.23.0

