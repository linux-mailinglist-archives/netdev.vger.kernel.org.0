Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63B320ECAB
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 06:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgF3EeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 00:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgF3Ed4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 00:33:56 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CAD4C061755;
        Mon, 29 Jun 2020 21:33:56 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x3so3330658pfo.9;
        Mon, 29 Jun 2020 21:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=I5Dv5raHq6PKZyEpvvq0aeWAhucJ0jOmmbBdZJh0B1Y=;
        b=aIvaGz23E8eE8IwaaJj7UYpCXvcxyWUQN4hv0BwmYUPiUqSN44+BtyCazpizO9Pk6R
         DVCxtp9LrBlNJUFesBTVBdBesOnTqfR7k7MUvC3xX7iYO8B3ULS8pOtZVPL3DSzdrGte
         iR2l5M4rDe0feTbPiHIqN6AdlOYdls9ktk30VZNqJG2TUU0iYsf9Ghox7AsXzmndB394
         TwH8VEWStwZTOD412bC96945OLAX/iJruSnUX0cOkszbU2cCjB4oaRr9awG5pyK1XU+y
         VfDsWXyWBgjqCey9eCHixeCeGwEIjJ0/zG1HlIKgBBbz1CNAKSJhF6ck3sxoajhT+Txt
         qsQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=I5Dv5raHq6PKZyEpvvq0aeWAhucJ0jOmmbBdZJh0B1Y=;
        b=gCN8SM1I4aUWxYtbAqGlHumfjEYCorc0HXnriTPKHEUF9psp/eHWs6BvjIjwVfJ4/J
         gXI0RjT+D9OAjapdL7/iWoBcYWyhV2qf6XdwgVrMDbNncreK4Gy8dO0xu2uWOiViOIcf
         1epRD+pxGHH0cgwk69OVuRwKVYwBfqzzIjMm1ezN5pOhtgFU5PLN5iGFinW6vkXmH+a9
         JoMLAPSaBRwEDnU8LEmCdTBm9BCrRM27QdinXsn1hzA02lEvKbzpZvPZfWOekiYJyH4I
         IhDmreejuIqcdHKLoozGqSmkCVspZe3mUP8J0l3axDEG42qYzNXcD/IjdCEwzDYF4RCq
         G4yw==
X-Gm-Message-State: AOAM532A8mK6+A7S8wt7gZ8qtwpu7ahQrGW/+ozzZMSx7k5zfwUm2yz4
        Zm8gYK3kDvc+iWqvIbu2slCwL89M
X-Google-Smtp-Source: ABdhPJyfiguaqTfVEZKMdo0nmXJFXA16VZk1kZVKG/ZkQsXrP13vSuu2xBkFNwMnfeqr11LD4CLCjA==
X-Received: by 2002:a63:d30a:: with SMTP id b10mr13084460pgg.430.1593491635597;
        Mon, 29 Jun 2020 21:33:55 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id 21sm1111234pfv.43.2020.06.29.21.33.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jun 2020 21:33:54 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, paulmck@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v5 bpf-next 4/5] libbpf: support sleepable progs
Date:   Mon, 29 Jun 2020 21:33:42 -0700
Message-Id: <20200630043343.53195-5-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200630043343.53195-1-alexei.starovoitov@gmail.com>
References: <20200630043343.53195-1-alexei.starovoitov@gmail.com>
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

