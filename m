Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A669520A0F
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 02:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbiEJAWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 20:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233546AbiEJAW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 20:22:29 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F4628C9C8
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 17:18:26 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id c202-20020a621cd3000000b0050dd228152aso5399750pfc.11
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 17:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jUygyQcHmQCX+4t0PO9Lj98oGxUhwQRCqcIwRtRRuu0=;
        b=b9L6wIY6W3JHgNc21GkxYFtPGgfmo5QUJKkjlOhi4hW3quxxLCFiGsyjlcSg3mOEte
         xmYcnYmek/bOQXhLz+sI4VQviMEA+cmcQ45gAHFT3NM89PNw3VF2taoJOECrNh688Ieh
         XVEE6g3VTkOhPesLqypGO5fy0bGZ8/jL+ZYAYtCCGQJukNlJAI77UUs0ewH/ySwBGf6S
         euh6YXkx+e0I2eJNJCkjlpGpu/IgzPTDz31AoWxHLCsaa08vNcDkWlzYVZ3WX+++HFY+
         JMd+L9/ZBEFMpxJLXdRZehKNGnT/yoi38iBjacCWDEVlkD8M9h/fuKz/vEF7G+xhBP93
         CS6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jUygyQcHmQCX+4t0PO9Lj98oGxUhwQRCqcIwRtRRuu0=;
        b=EAbSUhfgN+z5LsqnzEOQQetrogoZPcqIqLOw7wpHD31hHizIgc+gZR8RiXj7JuOjZ8
         zDLIZFQ1p0PzrDfqO7vVDsb7Koo6nWPDUtrIxnmnbTrNn9Vee0TJl1yfoDobFWt4Cl5T
         gXIhhWbCglUMGtthJk82+TYqeUpCFoAHCAgRBVKD9wkyuJvJzUC7apRyJ0LTwVTjLFHb
         9IqOWMd0TvzYoFcBS2GaVSpEa6IwIj5x6FVEW2YPYwcEpu7x5kGDjuVaf+Bd2wGdUP93
         U925DDJZLaLXy96sBSytVaMacjBEdvCCl70BwZsSZXsu1ycBgFQ8rM05MxL/FzRUGCs0
         syUA==
X-Gm-Message-State: AOAM532MbUzgs1MHCm3crlM5gECzhHzRwOIrzuDU2bFAiU9cde5nZ9CY
        a//suepea97JEhy4F8xxObIG8PmomgPDIRhl
X-Google-Smtp-Source: ABdhPJws2wA6fi+zGQOzH1vWd8zNdFXSGIXiWcInZijSRi9ZraL3D7PhFIBq8d5am7hWKt6LV39Xxn5hy8O21P2z
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a05:6a00:846:b0:50d:f02f:bb46 with SMTP
 id q6-20020a056a00084600b0050df02fbb46mr18110972pfk.74.1652141905673; Mon, 09
 May 2022 17:18:25 -0700 (PDT)
Date:   Tue, 10 May 2022 00:18:01 +0000
In-Reply-To: <20220510001807.4132027-1-yosryahmed@google.com>
Message-Id: <20220510001807.4132027-4-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220510001807.4132027-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [RFC PATCH bpf-next 3/9] libbpf: Add support for rstat progs and links
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to attach "cgroup_subsys/rstat" programs to a subsystem by
calling bpf_program__attach_subsys. Currently, only CGROUP_SUBSYS_RSTAT
programs are supported for attachment to subsystems.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 tools/lib/bpf/bpf.c      |  3 +++
 tools/lib/bpf/bpf.h      |  3 +++
 tools/lib/bpf/libbpf.c   | 35 +++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h   |  3 +++
 tools/lib/bpf/libbpf.map |  1 +
 5 files changed, 45 insertions(+)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index cf27251adb92..abfff17cfa07 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -863,6 +863,9 @@ int bpf_link_create(int prog_fd, int target_fd,
 		if (!OPTS_ZEROED(opts, kprobe_multi))
 			return libbpf_err(-EINVAL);
 		break;
+	case BPF_CGROUP_SUBSYS_RSTAT:
+		attr.link_create.cgroup_subsys.name = ptr_to_u64(OPTS_GET(opts, cgroup_subsys.name, 0));
+		break;
 	default:
 		if (!OPTS_ZEROED(opts, flags))
 			return libbpf_err(-EINVAL);
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index f4b4afb6d4ba..384767a9ffd3 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -413,6 +413,9 @@ struct bpf_link_create_opts {
 		struct {
 			__u64 bpf_cookie;
 		} perf_event;
+		struct {
+			const char *name;
+		} cgroup_subsys;
 		struct {
 			__u32 flags;
 			__u32 cnt;
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 809fe209cdcc..56380953df55 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8715,6 +8715,7 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("cgroup/setsockopt",	CGROUP_SOCKOPT, BPF_CGROUP_SETSOCKOPT, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
 	SEC_DEF("struct_ops+",		STRUCT_OPS, 0, SEC_NONE),
 	SEC_DEF("sk_lookup",		SK_LOOKUP, BPF_SK_LOOKUP, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
+	SEC_DEF("cgroup_subsys/rstat",	CGROUP_SUBSYS_RSTAT, 0, SEC_NONE),
 };
 
 static size_t custom_sec_def_cnt;
@@ -10957,6 +10958,40 @@ static int attach_iter(const struct bpf_program *prog, long cookie, struct bpf_l
 	return libbpf_get_error(*link);
 }
 
+struct bpf_link *bpf_program__attach_subsys(const struct bpf_program *prog,
+					     const char *subsys_name)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, lopts,
+			    .cgroup_subsys.name = subsys_name);
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
+	link_fd = bpf_link_create(prog_fd, 0, BPF_CGROUP_SUBSYS_RSTAT, &lopts);
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
 struct bpf_link *bpf_program__attach(const struct bpf_program *prog)
 {
 	struct bpf_link *link = NULL;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 05dde85e19a6..eddbffcd39f7 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -537,6 +537,9 @@ bpf_program__attach_xdp(const struct bpf_program *prog, int ifindex);
 LIBBPF_API struct bpf_link *
 bpf_program__attach_freplace(const struct bpf_program *prog,
 			     int target_fd, const char *attach_func_name);
+LIBBPF_API struct bpf_link *
+bpf_program__attach_subsys(const struct bpf_program *prog,
+			   const char *subsys_name);
 
 struct bpf_map;
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index dd35ee58bfaa..5583a2dbfb7c 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -447,4 +447,5 @@ LIBBPF_0.8.0 {
 		libbpf_register_prog_handler;
 		libbpf_unregister_prog_handler;
 		bpf_program__attach_kprobe_multi_opts;
+		bpf_program__attach_subsys;
 } LIBBPF_0.7.0;
-- 
2.36.0.512.ge40c2bad7a-goog

