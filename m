Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E98546B27
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343946AbiFJQ7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 12:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350009AbiFJQ6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 12:58:22 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D4433E2C
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 09:58:20 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id s17-20020a170902ea1100b00168b7cad0efso1609758plg.14
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 09:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RI+DinQTUMJgh2SwSVOiYCIj0hdxO3MhPrfBi6v93cY=;
        b=ea4vysMGGsdxPdEwPmjTbCfDHX3IWHRkJZXa3lfLxwSVxcYOeQk7KwU8BQA+aYdV5R
         6c4ERS9Ju8Yy3dg2+axAGMyO4ycqG50sc6oTexADaa0FtrgAIocnV2TJ15wkXh9ltVw4
         WRMIBIM66IdH3ta2o0/y9LFQx3NRE8ncuT7XtReICxNvii6h3q912TPPK8scjGEGN16o
         Y8XcUsDNIceaqaKVWjoP0M6mPR1ZFS84pnhvoi6QpbWJNyee+J1jfA4upTzG5V0rBsBv
         Em9jseNbnAnDSYMFgWpVmdN4SQ4VKYAPnBM2tsx9ReIv5T8772Wf/2we533IuGLwMRx1
         aiEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RI+DinQTUMJgh2SwSVOiYCIj0hdxO3MhPrfBi6v93cY=;
        b=XrXXPwPiGRDz9irlaZDs71AYMSBthAGE06rQKOTGt+Y3VTooXn6PGCFd249xm0OJZ+
         vtAaXlC6gFqscpYqtWkZY0+8um+VVHYmlnSxwym0nscAYJSC+GRQBn+O/OQoi27B59ua
         Hun8iJlOiBNQ0WpoGj0g0Gb1eoioWmJK2RC18uiWG/CUKB+4zLDp1X2AreaPeGzhkhNM
         UNWGWHgPdleJmutHJDj2j7+aNnDA+VaNZGj1v1C42/6H4kEgTkEzeMQ5h12/alOZF2mY
         2/8HP0FoRLOogon/1A2G8j32t7tRpmETEUqEPh2jeltq7+GNz9f1bHExbKIPW2HnPlpv
         AXlA==
X-Gm-Message-State: AOAM530dXvX0bMI9yN7pgbNDRgmArUhpoey3wKJQvVZyEpkvQcLjnDKv
        WIURXN5/4e0zHjUjqqeGQgJPXY7vxWAarOCtT9VN59BxSvVkqDd0Ajaewmxl7rHY8jNkKSXekwG
        xynmgEjNudIhmw+06Lor/pAd7AHuCW2FkWDHznjHU+vvoVkPTvuBvBA==
X-Google-Smtp-Source: ABdhPJxwkgjMgeuZfAcDw/49XHcVa2MujWbFA1+cCxvubeXzLRPUjhhlwAEouYmDUmWQkD5Io5wJt1s=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:1956:b0:51c:3a0:49d2 with SMTP id
 s22-20020a056a00195600b0051c03a049d2mr31890495pfk.29.1654880299777; Fri, 10
 Jun 2022 09:58:19 -0700 (PDT)
Date:   Fri, 10 Jun 2022 09:58:01 -0700
In-Reply-To: <20220610165803.2860154-1-sdf@google.com>
Message-Id: <20220610165803.2860154-9-sdf@google.com>
Mime-Version: 1.0
References: <20220610165803.2860154-1-sdf@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH bpf-next v9 08/10] libbpf: implement bpf_prog_query_opts
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement bpf_prog_query_opts as a more expendable version of
bpf_prog_query. Expose new prog_attach_flags and attach_btf_func_id as
well:

* prog_attach_flags is a per-program attach_type; relevant only for
  lsm cgroup program which might have different attach_flags
  per attach_btf_id
* attach_btf_func_id is a new field expose for prog_query which
  specifies real btf function id for lsm cgroup attachments

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/include/uapi/linux/bpf.h |  3 +++
 tools/lib/bpf/bpf.c            | 38 +++++++++++++++++++++++++++-------
 tools/lib/bpf/bpf.h            | 15 ++++++++++++++
 tools/lib/bpf/libbpf.map       |  1 +
 4 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index fa64b0b612fd..4271ef3c2afb 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1432,6 +1432,7 @@ union bpf_attr {
 		__u32		attach_flags;
 		__aligned_u64	prog_ids;
 		__u32		prog_cnt;
+		__aligned_u64	prog_attach_flags; /* output: per-program attach_flags */
 	} query;
 
 	struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
@@ -5996,6 +5997,8 @@ struct bpf_prog_info {
 	__u64 run_cnt;
 	__u64 recursion_misses;
 	__u32 verified_insns;
+	__u32 attach_btf_obj_id;
+	__u32 attach_btf_id;
 } __attribute__((aligned(8)));
 
 struct bpf_map_info {
diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 240186aac8e6..accc97cf9928 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -888,24 +888,48 @@ int bpf_iter_create(int link_fd)
 	return libbpf_err_errno(fd);
 }
 
-int bpf_prog_query(int target_fd, enum bpf_attach_type type, __u32 query_flags,
-		   __u32 *attach_flags, __u32 *prog_ids, __u32 *prog_cnt)
+int bpf_prog_query_opts(int target_fd,
+			enum bpf_attach_type type,
+			struct bpf_prog_query_opts *opts)
 {
 	union bpf_attr attr;
 	int ret;
 
+	if (!OPTS_VALID(opts, bpf_prog_query_opts))
+		return libbpf_err(-EINVAL);
+
 	memset(&attr, 0, sizeof(attr));
+
 	attr.query.target_fd	= target_fd;
 	attr.query.attach_type	= type;
-	attr.query.query_flags	= query_flags;
-	attr.query.prog_cnt	= *prog_cnt;
-	attr.query.prog_ids	= ptr_to_u64(prog_ids);
+	attr.query.query_flags	= OPTS_GET(opts, query_flags, 0);
+	attr.query.prog_cnt	= OPTS_GET(opts, prog_cnt, 0);
+	attr.query.prog_ids	= ptr_to_u64(OPTS_GET(opts, prog_ids, NULL));
+	attr.query.prog_attach_flags = ptr_to_u64(OPTS_GET(opts, prog_attach_flags, NULL));
 
 	ret = sys_bpf(BPF_PROG_QUERY, &attr, sizeof(attr));
 
+	OPTS_SET(opts, attach_flags, attr.query.attach_flags);
+	OPTS_SET(opts, prog_cnt, attr.query.prog_cnt);
+
+	return libbpf_err_errno(ret);
+}
+
+int bpf_prog_query(int target_fd, enum bpf_attach_type type, __u32 query_flags,
+		   __u32 *attach_flags, __u32 *prog_ids, __u32 *prog_cnt)
+{
+	LIBBPF_OPTS(bpf_prog_query_opts, opts);
+	int ret;
+
+	opts.query_flags = query_flags;
+	opts.prog_ids = prog_ids;
+	opts.prog_cnt = *prog_cnt;
+
+	ret = bpf_prog_query_opts(target_fd, type, &opts);
+
 	if (attach_flags)
-		*attach_flags = attr.query.attach_flags;
-	*prog_cnt = attr.query.prog_cnt;
+		*attach_flags = opts.attach_flags;
+	*prog_cnt = opts.prog_cnt;
 
 	return libbpf_err_errno(ret);
 }
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index cabc03703e29..e8f70ce6b537 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -442,9 +442,24 @@ LIBBPF_API int bpf_map_get_fd_by_id(__u32 id);
 LIBBPF_API int bpf_btf_get_fd_by_id(__u32 id);
 LIBBPF_API int bpf_link_get_fd_by_id(__u32 id);
 LIBBPF_API int bpf_obj_get_info_by_fd(int bpf_fd, void *info, __u32 *info_len);
+
+struct bpf_prog_query_opts {
+	size_t sz; /* size of this struct for forward/backward compatibility */
+	__u32 query_flags;
+	__u32 attach_flags; /* output argument */
+	__u32 *prog_ids;
+	__u32 prog_cnt; /* input+output argument */
+	__u32 *prog_attach_flags;
+};
+#define bpf_prog_query_opts__last_field prog_attach_flags
+
+LIBBPF_API int bpf_prog_query_opts(int target_fd,
+				   enum bpf_attach_type type,
+				   struct bpf_prog_query_opts *opts);
 LIBBPF_API int bpf_prog_query(int target_fd, enum bpf_attach_type type,
 			      __u32 query_flags, __u32 *attach_flags,
 			      __u32 *prog_ids, __u32 *prog_cnt);
+
 LIBBPF_API int bpf_raw_tracepoint_open(const char *name, int prog_fd);
 LIBBPF_API int bpf_task_fd_query(int pid, int fd, __u32 flags, char *buf,
 				 __u32 *buf_len, __u32 *prog_id, __u32 *fd_type,
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 116a2a8ee7c2..03c69cb821b3 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -462,6 +462,7 @@ LIBBPF_0.8.0 {
 
 LIBBPF_1.0.0 {
 	global:
+		bpf_prog_query_opts;
 		btf__add_enum64;
 		btf__add_enum64_value;
 		libbpf_bpf_attach_type_str;
-- 
2.36.1.476.g0c4daa206d-goog

