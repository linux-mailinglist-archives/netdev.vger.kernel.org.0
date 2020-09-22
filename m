Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6F6274848
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 20:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgIVSi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 14:38:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22340 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726652AbgIVSis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 14:38:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600799926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UdWeLaNNOYSzrThwXfahZZYi0128JO9Qu7WeeEKhKXw=;
        b=WW3fUS1R+PXUGUI9VxjszdEpsGwTjrFrCNZOU0rnRDecxDHACXJIZiv7HKtJFD+N/6WcRj
        QbHq7y6HZvud6GCmZCNEaM64jPojDRIKqdmKqE7L+xmaLYtmx/jrBxxxpstReqNmLzhoE8
        2SL/V/QswyUNYb77OfCKJXz72IZwIEY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-EttzqU84Ps2K_c_ZweKa6A-1; Tue, 22 Sep 2020 14:38:44 -0400
X-MC-Unique: EttzqU84Ps2K_c_ZweKa6A-1
Received: by mail-wr1-f72.google.com with SMTP id s8so7754031wrb.15
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 11:38:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=UdWeLaNNOYSzrThwXfahZZYi0128JO9Qu7WeeEKhKXw=;
        b=E04Quiy2YS6wvccJHt7fVbR6pROcgdM0DXGua7eMFGhI7bEMB8JPCs8UkYZXHc3Djn
         kzig4Xocu6ppE3tN1cVIEKFBmhPvZni0+HUYVgd4djJH5fPVy3mgFu3DcEUREA4fOHBd
         /Pi3W6Xenkc5YMuV6TOD3SqITFF+3afJ5OVDXwa+ElF4Ug6PlrITIT0GHUgayTdnxZnP
         ZJI5KSQpxJ1g+AMylAkbpKMfNgP5kjS9LExPfFJ09O4JWa/gws41VFUnvFqzheR1louc
         oqRycLNrA0SUYnlS3bImBhbRVV4bEyGtvW0d3i7c72bkKsjYqeP3PNlUZeJ7h34Mp1Q+
         +rMw==
X-Gm-Message-State: AOAM531nyxghcnnf8hfxYGBjWPZAQu7q1MndVyjUkjrmSF2E0X543e7I
        POBZ4FesB9ppXzTEKn9EGkt08dJrdxZ1tcCbdSji/UId1pd0FSBCqXaq9o4+ztb/6EYSeKSI6vX
        yEadrGBSEqmV2OUVX
X-Received: by 2002:a1c:e40b:: with SMTP id b11mr2530476wmh.100.1600799923085;
        Tue, 22 Sep 2020 11:38:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw8JabB4hXJBfAd/o5PhXOPdRiLHPUqgeODMWUcLi0f4H+3Oe7wsNxiM7w62Ojbe8W/l657Ng==
X-Received: by 2002:a1c:e40b:: with SMTP id b11mr2530455wmh.100.1600799922896;
        Tue, 22 Sep 2020 11:38:42 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id i26sm5907104wmb.17.2020.09.22.11.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 11:38:42 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5819D183A90; Tue, 22 Sep 2020 20:38:41 +0200 (CEST)
Subject: [PATCH bpf-next v8 07/11] libbpf: add support for freplace attachment
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
Date:   Tue, 22 Sep 2020 20:38:41 +0200
Message-ID: <160079992129.8301.9319405264647976548.stgit@toke.dk>
In-Reply-To: <160079991372.8301.10648588027560707258.stgit@toke.dk>
References: <160079991372.8301.10648588027560707258.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds support for supplying a target btf ID for the bpf_link_create()
operation, and adds a new bpf_program__attach_freplace() high-level API for
attaching freplace functions with a target.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/bpf.c      |   18 +++++++++++++++---
 tools/lib/bpf/bpf.h      |    3 ++-
 tools/lib/bpf/libbpf.c   |   44 +++++++++++++++++++++++++++++++++++++++-----
 tools/lib/bpf/libbpf.h   |    3 +++
 tools/lib/bpf/libbpf.map |    1 +
 5 files changed, 60 insertions(+), 9 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 2baa1308737c..75f627094790 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -586,19 +586,31 @@ int bpf_link_create(int prog_fd, int target_fd,
 		    enum bpf_attach_type attach_type,
 		    const struct bpf_link_create_opts *opts)
 {
+	__u32 target_btf_id, iter_info_len;
 	union bpf_attr attr;
 
 	if (!OPTS_VALID(opts, bpf_link_create_opts))
 		return -EINVAL;
 
+	iter_info_len = OPTS_GET(opts, iter_info_len, 0);
+	target_btf_id = OPTS_GET(opts, target_btf_id, 0);
+
+	if (iter_info_len && target_btf_id)
+		return -EINVAL;
+
 	memset(&attr, 0, sizeof(attr));
 	attr.link_create.prog_fd = prog_fd;
 	attr.link_create.target_fd = target_fd;
 	attr.link_create.attach_type = attach_type;
 	attr.link_create.flags = OPTS_GET(opts, flags, 0);
-	attr.link_create.iter_info =
-		ptr_to_u64(OPTS_GET(opts, iter_info, (void *)0));
-	attr.link_create.iter_info_len = OPTS_GET(opts, iter_info_len, 0);
+
+	if (iter_info_len) {
+		attr.link_create.iter_info =
+			ptr_to_u64(OPTS_GET(opts, iter_info, (void *)0));
+		attr.link_create.iter_info_len = iter_info_len;
+	} else if (target_btf_id) {
+		attr.link_create.target_btf_id = target_btf_id;
+	}
 
 	return sys_bpf(BPF_LINK_CREATE, &attr, sizeof(attr));
 }
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 8c1ac4b42f90..6b8dbe24adc9 100644
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
index 570235dbc922..e9a2ad039e9a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -9390,9 +9390,11 @@ static struct bpf_link *attach_iter(const struct bpf_sec_def *sec,
 }
 
 static struct bpf_link *
-bpf_program__attach_fd(struct bpf_program *prog, int target_fd,
+bpf_program__attach_fd(struct bpf_program *prog, int target_fd, int btf_id,
 		       const char *target_name)
 {
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
+			    .target_btf_id = btf_id);
 	enum bpf_attach_type attach_type;
 	char errmsg[STRERR_BUFSIZE];
 	struct bpf_link *link;
@@ -9410,7 +9412,7 @@ bpf_program__attach_fd(struct bpf_program *prog, int target_fd,
 	link->detach = &bpf_link__detach_fd;
 
 	attach_type = bpf_program__get_expected_attach_type(prog);
-	link_fd = bpf_link_create(prog_fd, target_fd, attach_type, NULL);
+	link_fd = bpf_link_create(prog_fd, target_fd, attach_type, &opts);
 	if (link_fd < 0) {
 		link_fd = -errno;
 		free(link);
@@ -9426,19 +9428,51 @@ bpf_program__attach_fd(struct bpf_program *prog, int target_fd,
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
+					      int target_fd,
+					      const char *attach_func_name)
+{
+	int btf_id;
+
+	if (!!target_fd != !!attach_func_name) {
+		pr_warn("prog '%s': supply none or both of target_fd and attach_func_name\n",
+			prog->name);
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (prog->type != BPF_PROG_TYPE_EXT) {
+		pr_warn("prog '%s': only BPF_PROG_TYPE_EXT can attach as freplace",
+			prog->name);
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (target_fd) {
+		btf_id = libbpf_find_prog_btf_id(attach_func_name, target_fd);
+		if (btf_id < 0)
+			return ERR_PTR(btf_id);
+
+		return bpf_program__attach_fd(prog, target_fd, btf_id, "freplace");
+	} else {
+		/* no target, so use raw_tracepoint_open for compatibility
+		 * with old kernels
+		 */
+		return bpf_program__attach_trace(prog);
+	}
 }
 
 struct bpf_link *
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index a750f67a23f6..6909ee81113a 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -261,6 +261,9 @@ LIBBPF_API struct bpf_link *
 bpf_program__attach_netns(struct bpf_program *prog, int netns_fd);
 LIBBPF_API struct bpf_link *
 bpf_program__attach_xdp(struct bpf_program *prog, int ifindex);
+LIBBPF_API struct bpf_link *
+bpf_program__attach_freplace(struct bpf_program *prog,
+			     int target_fd, const char *attach_func_name);
 
 struct bpf_map;
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 5f054dadf082..b1c537873b23 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -303,6 +303,7 @@ LIBBPF_0.1.0 {
 LIBBPF_0.2.0 {
 	global:
 		bpf_prog_bind_map;
+		bpf_program__attach_freplace;
 		bpf_program__section_name;
 		perf_buffer__buffer_cnt;
 		perf_buffer__buffer_fd;

