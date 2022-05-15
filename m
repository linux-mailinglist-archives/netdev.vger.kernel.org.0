Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C10E5274FE
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 04:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234292AbiEOCfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 22:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233849AbiEOCfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 22:35:20 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F24BF53
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 19:35:17 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id i6-20020a17090a718600b001dc87aca289so6205339pjk.5
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 19:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+WjPdyMxAdY9z5Dvu+MUV583iy9AH2h8aY84f8u+NlQ=;
        b=drK5May8XtsY9ItuFqGUPfYPZSwPFC2vfWpY3F0n+trY0R+YgtulCP7PaD0tTJYX87
         /AQzQdehzBXCX/m9XBVR+UEuQM1EiQOLyBQFDJn4AEtc6yk4IHGVD6xEuPAit6b3utLc
         pexcE8FmNCBHJ3vKjD3Wuv4qRyCvS8bOd9hQ3GKXf6M92KdyaHgvs6OqDSt/PCZsV7zJ
         6k2Y0w02FfG3VXu16UcaUq+7hUYRzXqUDru05kCE3TYBetyhT54RS2zi6TSof9r0Hzxu
         PS3sd/eymY2do0BX/aNeXkVD9XqdOm59MkVD8or9jMJzISh5c1W9Xkbe0G/miCcx/pVQ
         EnQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+WjPdyMxAdY9z5Dvu+MUV583iy9AH2h8aY84f8u+NlQ=;
        b=WV2MWdCB4TgyTYdUrdWa3LAHTowoLarzpX8SbLmp4tZpnS5rsnlCFPl/PtQxsySdiD
         AKTuOCwTV6Do+yVCo1+NebE+lBi7IndK42R0lQaXg5/8DkUWN3ORu1RwbbeIwFvm0Bru
         RPBTOdVbzcRiQVYnUeTc7kYsZYOddFCwk16/7Z7wnJkQoqoXFToZRKJd82uO3w3DiHc5
         JqDg4DisEjZQpTLlabqNb2lGLOQarudn70Fb67+hnsXsKxsdNe0kiIu6FT/4TXXmZGSh
         /S8pKj9GtHaRwsEqitBxx8CinjfhJlXSOgZYhEDI40Dl/CyXl/qInwbm2EUtQBh5muuU
         B1YA==
X-Gm-Message-State: AOAM530lE4CNOuAz/WIJdtmQY3CkDDjZhhBUL7+VvXmi3VqF4RATgGL6
        AmoKJOAYXCACH3U4IJqg1T9bU2POi6+FxC9Y
X-Google-Smtp-Source: ABdhPJzI7Dv8yggdDz/nPqxwdCwDu1Q9s6V8RXcBRcuirs2FNzx0DWjzi40c7FJoyyLmQlUTM+qr+DPFvYNQOqRN
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:90b:610:b0:1d9:4008:cfee with SMTP
 id gb16-20020a17090b061000b001d94008cfeemr12637276pjb.71.1652582116715; Sat,
 14 May 2022 19:35:16 -0700 (PDT)
Date:   Sun, 15 May 2022 02:35:00 +0000
In-Reply-To: <20220515023504.1823463-1-yosryahmed@google.com>
Message-Id: <20220515023504.1823463-4-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220515023504.1823463-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [RFC PATCH bpf-next v2 3/7] libbpf: Add support for rstat flush progs
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>
Cc:     Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org,
        Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to attach RSTAT_FLUSH programs.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 tools/lib/bpf/bpf.c      |  1 -
 tools/lib/bpf/libbpf.c   | 40 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h   |  3 +++
 tools/lib/bpf/libbpf.map |  1 +
 4 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 5660268e103f..9e3cb0d1eb99 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -870,7 +870,6 @@ int bpf_link_create(int prog_fd, int target_fd,
 		attr.link_create.tracing.cookie = OPTS_GET(opts, tracing.cookie, 0);
 		if (!OPTS_ZEROED(opts, tracing))
 			return libbpf_err(-EINVAL);
-		break;
 	default:
 		if (!OPTS_ZEROED(opts, flags))
 			return libbpf_err(-EINVAL);
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 4867a930628b..b7fc64ebf8dd 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8998,6 +8998,7 @@ static int attach_trace(const struct bpf_program *prog, long cookie, struct bpf_
 static int attach_kprobe_multi(const struct bpf_program *prog, long cookie, struct bpf_link **link);
 static int attach_lsm(const struct bpf_program *prog, long cookie, struct bpf_link **link);
 static int attach_iter(const struct bpf_program *prog, long cookie, struct bpf_link **link);
+static int attach_rstat(const struct bpf_program *prog, long cookie, struct bpf_link **link);
 
 static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("socket",		SOCKET_FILTER, 0, SEC_NONE | SEC_SLOPPY_PFX),
@@ -9078,6 +9079,7 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("cgroup/setsockopt",	CGROUP_SOCKOPT, BPF_CGROUP_SETSOCKOPT, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
 	SEC_DEF("struct_ops+",		STRUCT_OPS, 0, SEC_NONE),
 	SEC_DEF("sk_lookup",		SK_LOOKUP, BPF_SK_LOOKUP, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
+	SEC_DEF("rstat/flush",		RSTAT_FLUSH, 0, SEC_NONE, attach_rstat),
 };
 
 static size_t custom_sec_def_cnt;
@@ -11784,6 +11786,44 @@ static int attach_iter(const struct bpf_program *prog, long cookie, struct bpf_l
 	return libbpf_get_error(*link);
 }
 
+struct bpf_link *bpf_program__attach_rstat(const struct bpf_program *prog)
+{
+	struct bpf_link *link = NULL;
+	char errmsg[STRERR_BUFSIZE];
+	int err, prog_fd, link_fd;
+
+	prog_fd = bpf_program__fd(prog);
+	if (prog_fd < 0) {
+		pr_warn("prog '%s': can't attach before loaded\n", prog->name);
+		return libbpf_err_ptr(-EINVAL);
+	}
+
+	link = calloc(1, sizeof(*link));
+	if (!link)
+		return libbpf_err_ptr(-ENOMEM);
+	link->detach = &bpf_link__detach_fd;
+
+	/* rstat flushers are currently the only supported rstat programs */
+	link_fd = bpf_link_create(prog_fd, 0, BPF_RSTAT_FLUSH, NULL);
+	if (link_fd < 0) {
+		err = -errno;
+		pr_warn("prog '%s': failed to attach: %s\n",
+			prog->name, libbpf_strerror_r(err, errmsg,
+						      sizeof(errmsg)));
+		free(link);
+		return libbpf_err_ptr(err);
+	}
+
+	link->fd = link_fd;
+	return link;
+}
+
+static int attach_rstat(const struct bpf_program *prog, long cookie, struct bpf_link **link)
+{
+	*link = bpf_program__attach_rstat(prog);
+	return libbpf_get_error(*link);
+}
+
 struct bpf_link *bpf_program__attach(const struct bpf_program *prog)
 {
 	struct bpf_link *link = NULL;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 21984dcd6dbe..f8b6827d5550 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -662,6 +662,9 @@ LIBBPF_API struct bpf_link *
 bpf_program__attach_iter(const struct bpf_program *prog,
 			 const struct bpf_iter_attach_opts *opts);
 
+LIBBPF_API struct bpf_link *
+bpf_program__attach_rstat(const struct bpf_program *prog);
+
 /*
  * Libbpf allows callers to adjust BPF programs before being loaded
  * into kernel. One program in an object file can be transformed into
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 008da8db1d94..f945c6265cb5 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -449,6 +449,7 @@ LIBBPF_0.8.0 {
 		bpf_program__attach_kprobe_multi_opts;
 		bpf_program__attach_trace_opts;
 		bpf_program__attach_usdt;
+		bpf_program__attach_rstat;
 		bpf_program__set_insns;
 		libbpf_register_prog_handler;
 		libbpf_unregister_prog_handler;
-- 
2.36.0.550.gb090851708-goog

