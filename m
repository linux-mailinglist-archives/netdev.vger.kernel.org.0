Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24C7270DCB
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 13:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgISLug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 07:50:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26963 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726492AbgISLu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 07:50:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600516225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SwwA41YQAopEqGEchaJlD8W3ssr+7sAf8vkfPDSrupE=;
        b=eO4K85MWWeF+gZm4wot/hBzhL+1/L+c4UyX3qdOhD1DMuqwZapsevQL1KhSZay7wcV/tzY
        e3CH8Asve4G4DjzNDvB3xlCrTXYLJ4HBAptR/GWTfeBXZHaLJY8QTaLS4Jmwa/ph1qWhhX
        TO+6W1eNdZ3rvaIQsJ5//ObZQRjgEFA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-Ec0slTmCNUiwkqXoidv_7g-1; Sat, 19 Sep 2020 07:50:23 -0400
X-MC-Unique: Ec0slTmCNUiwkqXoidv_7g-1
Received: by mail-ed1-f71.google.com with SMTP id r9so3260332edi.9
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 04:50:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=SwwA41YQAopEqGEchaJlD8W3ssr+7sAf8vkfPDSrupE=;
        b=tvL0XQDzvbPD2skAwrRNMef/0BFDq8aN1alLHURgk/n1CoG2fYeHCSOCBlTrcrG8FH
         3oER1cmH2qePntmAY8gAyDr2tQvyBaU0hEgYouiEMGpncko98V2ezYcY/Fn+jLcqhWcA
         B0o8lNHjv9kml1MwUF8vlf3vXK16jDHZUdABNBT1zrOpnKM7AnOX5m+eyZ+xjo4wH3j0
         t8uaarTpobtomZRNQAKHUjrk4WUjuupzGEx6+564ztsfUMxj/jSderB9hkv73acJ15it
         /R587xXrgIYLuCcyBi3QVbnu9jn2AubNr6nFCbm9AEqSlJezkvrvNYKydTADU++BQkEn
         fcHA==
X-Gm-Message-State: AOAM531giyKOgvKnECJ6XS1rd+gGSES4+lqJhb4tcnGbsky9b/RBDp4K
        sDc2CejtCcXE9KpDRZsUkfJaa5XLVxkIc4YcrTGCLvk+MR2kVBgVTKFS0r+xvolpYGk5mjQZHbA
        RO7gik6bU2bYzRwaN
X-Received: by 2002:a17:906:2c14:: with SMTP id e20mr42442669ejh.205.1600516222353;
        Sat, 19 Sep 2020 04:50:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPIoB1mAWh/0nHnQngH9U2ewx3FXG5J/VSfqJUHvEM+8a3csSofIpHz8g1RKu1ZbmugM6qQA==
X-Received: by 2002:a17:906:2c14:: with SMTP id e20mr42442619ejh.205.1600516221617;
        Sat, 19 Sep 2020 04:50:21 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id q1sm4238717ejy.37.2020.09.19.04.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 04:50:21 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BCA0D183A96; Sat, 19 Sep 2020 13:49:50 +0200 (CEST)
Subject: [PATCH bpf-next v7 07/10] libbpf: add support for freplace attachment
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
Date:   Sat, 19 Sep 2020 13:49:50 +0200
Message-ID: <160051619067.58048.3593613677214772554.stgit@toke.dk>
In-Reply-To: <160051618267.58048.2336966160671014012.stgit@toke.dk>
References: <160051618267.58048.2336966160671014012.stgit@toke.dk>
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
 tools/lib/bpf/libbpf.c   |   36 +++++++++++++++++++++++++++++++-----
 tools/lib/bpf/libbpf.h   |    3 +++
 tools/lib/bpf/libbpf.map |    1 +
 5 files changed, 52 insertions(+), 9 deletions(-)

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
index 570235dbc922..3b008917e67d 100644
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
@@ -9426,19 +9428,43 @@ bpf_program__attach_fd(struct bpf_program *prog, int target_fd,
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
+	if (!!target_fd != !!attach_func_name || prog->type != BPF_PROG_TYPE_EXT)
+		return ERR_PTR(-EINVAL);
+
+	if (target_fd) {
+
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

