Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7553C27CDBC
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbgI2Mq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:46:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25167 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729185AbgI2MqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 08:46:03 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601383560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AYjnufP8is+PZDpSpcYj3MIA3sxrhG7nb/FUgzRuevk=;
        b=If0pQJIN0Va1FMkM0TyOC87hHJtn1kEUPgNCXPBq0W6cV5M4iDdTpQbl7mpkADKHaiBXbK
        XhFBmGm8AHQS2MWEofIImoP6wIujV3BIaGqjzcFceLsokCo9wG+7GcZpuBJG8+ij+u4eYH
        o0Bdr1RlEzfwMgvpjOFMT/LHnppVNJg=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-ggmpKQRDOku5B2OYdTPBeA-1; Tue, 29 Sep 2020 08:45:59 -0400
X-MC-Unique: ggmpKQRDOku5B2OYdTPBeA-1
Received: by mail-oo1-f70.google.com with SMTP id h23so2012934oof.6
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 05:45:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=AYjnufP8is+PZDpSpcYj3MIA3sxrhG7nb/FUgzRuevk=;
        b=Zc2nSvfidL1V8VLMsFUf9GANBRunoakGuEQShUBj3mMlNBfIJMdMNtcuWIzf6K3I5c
         VTTOIXXFLVxtgcZM4OQcyzCxuLJoMdU0c3SMYirnWIKnmgTuYhps42Irt9P3VfTW3s6K
         VyrIUwcZ0yM13CqL2tnNfQaQOVnwljFoYBszz9Vk/OzkaGsQYX0rdADFAeGnTXmh+oZt
         rqMBG7+UPNRBxe5ZpATSDpo8OJY5DTcZHTpHCcTe16fDIgCg3QgJFaE6VQwGRfwoEHUX
         kabkhxyWLSZ8SJhOte8ybq2n5xE4WV3843XBxkPof4hyh/5wNf62w0fhv44whn486gcb
         ahpQ==
X-Gm-Message-State: AOAM530a/ZDEcnpJVuR7et/pULn39zgsL9LUAdVTpoASseBvV0ASFFhm
        JCZTBhKXcH4u46N8Knai1d11iwPxShG7Yi4BK3TorlKyNTVHl/5jdjVffhO8PueHotqn8nwNNkl
        me+qM0NOPNrdV692k
X-Received: by 2002:aca:3087:: with SMTP id w129mr2363854oiw.102.1601383558004;
        Tue, 29 Sep 2020 05:45:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfMI6UWdicXpTfbXfsBehiQkxtLkRdsV4/gHnvUrQzRfL7SCWhLkUaVjWb578vYPggBxT9Uw==
X-Received: by 2002:aca:3087:: with SMTP id w129mr2363835oiw.102.1601383557767;
        Tue, 29 Sep 2020 05:45:57 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id a13sm958321oib.35.2020.09.29.05.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 05:45:55 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id ECC9C183C60; Tue, 29 Sep 2020 14:45:53 +0200 (CEST)
Subject: [PATCH bpf-next v10 4/7] libbpf: add support for freplace attachment
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
Date:   Tue, 29 Sep 2020 14:45:53 +0200
Message-ID: <160138355387.48470.18026176785351166890.stgit@toke.dk>
In-Reply-To: <160138354947.48470.11523413403103182788.stgit@toke.dk>
References: <160138354947.48470.11523413403103182788.stgit@toke.dk>
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

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/bpf.c      |   18 +++++++++++++++---
 tools/lib/bpf/bpf.h      |    3 ++-
 tools/lib/bpf/libbpf.c   |   44 +++++++++++++++++++++++++++++++++++++++-----
 tools/lib/bpf/libbpf.h   |    3 +++
 tools/lib/bpf/libbpf.map |    1 +
 5 files changed, 60 insertions(+), 9 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 70575a37aa14..d27e34133973 100644
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
index 16806810a53c..875dde20d56e 100644
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
index 32dc444224d8..a4f55f8a460d 100644
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
index 6b10ebad69c6..2d4acc87596c 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -304,6 +304,7 @@ LIBBPF_0.2.0 {
 	global:
 		bpf_prog_bind_map;
 		bpf_prog_test_run_opts;
+		bpf_program__attach_freplace;
 		bpf_program__section_name;
 		btf__add_array;
 		btf__add_const;

