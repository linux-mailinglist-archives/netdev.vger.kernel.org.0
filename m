Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E16269190
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgINQbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:31:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22577 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726526AbgINQNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 12:13:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600100014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w9fKJXKN7VEhK7rTxzSRwDVyT2JXTZwoaKL+6VZUoBs=;
        b=VJXimnRJjJwZfmiZtTJkYURZ/52TYOnG+WRvCEpgyTNnhA7yDylY3tfGyhbkP3NMY6vqJS
        L1yUV4Fdx2MxvtAWCO/E2pt9Z1jpJiy5tc9sexHqmgyO5C6zsdaREZDN0bpMRNleA/3Z5x
        Kmimp1BR04N50fkFs7cXhdwSc3YiC5U=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-rhybtj9vOY-Sb8JkLt5mRw-1; Mon, 14 Sep 2020 12:13:33 -0400
X-MC-Unique: rhybtj9vOY-Sb8JkLt5mRw-1
Received: by mail-wm1-f70.google.com with SMTP id m125so160165wmm.7
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 09:13:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=w9fKJXKN7VEhK7rTxzSRwDVyT2JXTZwoaKL+6VZUoBs=;
        b=Oqm6ijgB8X81GbndisDDB6eu1tADDVDo7IjLTu2BHl0XFI8uKM7N3BX8mCitPi/YIa
         h9qLHdcZH/N+xszNTmISkEyeXoPEfTYKiZCNhgILPm7A+XXfmpEFU0c5X+bNIddYMV5I
         vTx+/qKvmynGC7N+7Dxg3H9x9E60WSTHpHgGeL1UU+9oStNg5itrUR5/zA3KFl8J12qb
         Esbb4LfM9WUezhkgHJIHPi9RaTlCoOtKimQmtvRcKHEYJtW7AS1lXEk7badD/TiVwuNw
         ZUI6giw6G04CvKOQFKahqcbsFXl0hsF0vk/T/Opq6io5Gm0cbEVkv6dAkcTY2Ph2C2wj
         pJBQ==
X-Gm-Message-State: AOAM530s5rh11ypet3HMobqtyOaCnLhqD4eUzjvUHnU7k9AtL4HQz7xF
        1fQwtijoG0UCCmzDdnNY9PrZjAlkjpKSskJyKf7Zyli7LEtv+zy6tAGWfs4wpJXlAlFgniYnWmN
        jkwEhPBJHkGMkN7cJ
X-Received: by 2002:a1c:7d0c:: with SMTP id y12mr115198wmc.103.1600100010879;
        Mon, 14 Sep 2020 09:13:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycy67McyEKAjD6mxAKv2rQFFdOmXdWxlgOvPv9+JS+C20bpLj6ILkpKO5HV0IFL9mCFlu/SA==
X-Received: by 2002:a1c:7d0c:: with SMTP id y12mr115177wmc.103.1600100010706;
        Mon, 14 Sep 2020 09:13:30 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id t4sm21996062wrr.26.2020.09.14.09.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 09:13:29 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6EDC41829CC; Mon, 14 Sep 2020 18:13:29 +0200 (CEST)
Subject: [PATCH bpf-next v4 6/8] libbpf: add support for freplace attachment
 in bpf_link_create
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:13:29 +0200
Message-ID: <160010000935.80898.4271262373666475188.stgit@toke.dk>
In-Reply-To: <160010000272.80898.13117015273092905112.stgit@toke.dk>
References: <160010000272.80898.13117015273092905112.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds support for supplying a target btf ID for the bpf_link_create()
operation, and adds a new bpf_program__attach_freplace() high-level API for
attaching freplace functions with a target.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/bpf.c      |    1 +
 tools/lib/bpf/bpf.h      |    3 ++-
 tools/lib/bpf/libbpf.c   |   24 ++++++++++++++++++------
 tools/lib/bpf/libbpf.h   |    3 +++
 tools/lib/bpf/libbpf.map |    1 +
 5 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 82b983ff6569..e928456c0dd6 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -599,6 +599,7 @@ int bpf_link_create(int prog_fd, int target_fd,
 	attr.link_create.iter_info =
 		ptr_to_u64(OPTS_GET(opts, iter_info, (void *)0));
 	attr.link_create.iter_info_len = OPTS_GET(opts, iter_info_len, 0);
+	attr.link_create.target_btf_id = OPTS_GET(opts, target_btf_id, 0);
 
 	return sys_bpf(BPF_LINK_CREATE, &attr, sizeof(attr));
 }
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 015d13f25fcc..f8dbf666b62b 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -174,8 +174,9 @@ struct bpf_link_create_opts {
 	__u32 flags;
 	union bpf_iter_link_info *iter_info;
 	__u32 iter_info_len;
+	__u32 target_btf_id;
 };
-#define bpf_link_create_opts__last_field iter_info_len
+#define bpf_link_create_opts__last_field target_btf_id
 
 LIBBPF_API int bpf_link_create(int prog_fd, int target_fd,
 			       enum bpf_attach_type attach_type,
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 550950eb1860..165131c73f40 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -9322,12 +9322,14 @@ static struct bpf_link *attach_iter(const struct bpf_sec_def *sec,
 
 static struct bpf_link *
 bpf_program__attach_fd(struct bpf_program *prog, int target_fd,
-		       const char *target_name)
+		       int target_btf_id, const char *target_name)
 {
 	enum bpf_attach_type attach_type;
 	char errmsg[STRERR_BUFSIZE];
 	struct bpf_link *link;
 	int prog_fd, link_fd;
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
+			    .target_btf_id = target_btf_id);
 
 	prog_fd = bpf_program__fd(prog);
 	if (prog_fd < 0) {
@@ -9340,8 +9342,12 @@ bpf_program__attach_fd(struct bpf_program *prog, int target_fd,
 		return ERR_PTR(-ENOMEM);
 	link->detach = &bpf_link__detach_fd;
 
-	attach_type = bpf_program__get_expected_attach_type(prog);
-	link_fd = bpf_link_create(prog_fd, target_fd, attach_type, NULL);
+	if (bpf_program__get_type(prog) == BPF_PROG_TYPE_EXT)
+		attach_type = BPF_TRACE_FREPLACE;
+	else
+		attach_type = bpf_program__get_expected_attach_type(prog);
+
+	link_fd = bpf_link_create(prog_fd, target_fd, attach_type, &opts);
 	if (link_fd < 0) {
 		link_fd = -errno;
 		free(link);
@@ -9357,19 +9363,25 @@ bpf_program__attach_fd(struct bpf_program *prog, int target_fd,
 struct bpf_link *
 bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd)
 {
-	return bpf_program__attach_fd(prog, cgroup_fd, "cgroup");
+	return bpf_program__attach_fd(prog, cgroup_fd, 0, "cgroup");
 }
 
 struct bpf_link *
 bpf_program__attach_netns(struct bpf_program *prog, int netns_fd)
 {
-	return bpf_program__attach_fd(prog, netns_fd, "netns");
+	return bpf_program__attach_fd(prog, netns_fd, 0, "netns");
 }
 
 struct bpf_link *bpf_program__attach_xdp(struct bpf_program *prog, int ifindex)
 {
 	/* target_fd/target_ifindex use the same field in LINK_CREATE */
-	return bpf_program__attach_fd(prog, ifindex, "xdp");
+	return bpf_program__attach_fd(prog, ifindex, 0, "xdp");
+}
+
+struct bpf_link *bpf_program__attach_freplace(struct bpf_program *prog,
+					      int target_fd, int target_btf_id)
+{
+	return bpf_program__attach_fd(prog, target_fd, target_btf_id, "freplace");
 }
 
 struct bpf_link *
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index a750f67a23f6..ce5add9b9203 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -261,6 +261,9 @@ LIBBPF_API struct bpf_link *
 bpf_program__attach_netns(struct bpf_program *prog, int netns_fd);
 LIBBPF_API struct bpf_link *
 bpf_program__attach_xdp(struct bpf_program *prog, int ifindex);
+LIBBPF_API struct bpf_link *
+bpf_program__attach_freplace(struct bpf_program *prog,
+			     int target_fd, int target_btf_id);
 
 struct bpf_map;
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 92ceb48a5ca2..3cc2c42f435d 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -302,6 +302,7 @@ LIBBPF_0.1.0 {
 
 LIBBPF_0.2.0 {
 	global:
+		bpf_program__attach_freplace;
 		bpf_program__section_name;
 		perf_buffer__buffer_cnt;
 		perf_buffer__buffer_fd;

