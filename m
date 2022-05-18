Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13CD152C6EA
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 00:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbiERW46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 18:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbiERW4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 18:56:14 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51F925C9
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 15:55:49 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2d7eaa730d9so31165007b3.13
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 15:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2mJnOSjuai7q1tkEZvBJr5bmr2lBnPatwvJBByC7RYE=;
        b=I/wJvpzYJraNkpUeMMIUlPg2zm9a9a/ke941W4BMFrZ2uvLjCbz8qDGT1eFjseucUR
         QLQFIqIzevl7NSVUIvf6wFTX5MPwaL9Aky6cVpHl+b9V3FIm1o0O+LaZQAcuvjHg8lx9
         YcKfuDOmH2EDXMsJslo7TJrXWWW41lxnT4gjZyF+aXPS7kxvPWpf3jYT3f7hEqnFzBvU
         OUdD8GFNwF4Tczj9kL7Y7tReEziXbDJEbO8LJX/DrrVS31i+ghdS2A/I6mMl9wtfuma3
         DDa43McAWaVTJ4w974UwJuJaxz2ooXpkr7vYhoKMzvKHywC61AwKdVT8vyvaJQYvpINP
         O1Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2mJnOSjuai7q1tkEZvBJr5bmr2lBnPatwvJBByC7RYE=;
        b=jCIgWmQt1ePJ497LGFO8uQnD4r3L4uYIgtarJ6Htj1YshWB2OjSyipUBcgx1HrZpdi
         TlOSsdVsECredfXuhFBaEiyxAwlRocheb5Lmz3vz0iVZ9cCjPdF9RqwNgfQWEpq7ZzIL
         VG7NRkoxkLtfnsGlLTpcFVgv7dFyg8SKdMhpUsNbJBSZxs1Ix4ZT7OD2Aqpo7+dOFxcm
         YohA559GrRRJxUPXAdR4pURcmYf0lryfqqfXILbF8Pr0t4yJb3/zhmPodJE8rnc6q+N5
         RvWjsAZ2vqoMWYsfAm1KjGAjfsP9+2cSoaaNgniptUzVywERj1vvPN1DxLoxW0A4SR1T
         ZQJw==
X-Gm-Message-State: AOAM5334ZhtBQW+NU8qfZXPnYavFTbB8lXyPai7gAgWOysHYRVNhjkxa
        vBcqxe520hFBXlkOX4A5XYg96k+zX/FYUhVObWhHaSXb3XvszPKEwRnrFVlwpeuNJdXlIuJWURM
        RCyxJxFcwhKC3okpe7JSokZmeEIiYRxT+78lXWOgY4+TEDJXFiQObwA==
X-Google-Smtp-Source: ABdhPJxDqGihjPQJl8FPNGuzRHa+r13bolkMhbxwBkrjmzPziR5RANtVT6B6YCvwpUvkgdBJUxbiSyM=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:f763:3448:2567:bf00])
 (user=sdf job=sendgmr) by 2002:a81:3a57:0:b0:2f1:57ee:c671 with SMTP id
 h84-20020a813a57000000b002f157eec671mr1822551ywa.104.1652914548210; Wed, 18
 May 2022 15:55:48 -0700 (PDT)
Date:   Wed, 18 May 2022 15:55:27 -0700
In-Reply-To: <20220518225531.558008-1-sdf@google.com>
Message-Id: <20220518225531.558008-8-sdf@google.com>
Mime-Version: 1.0
References: <20220518225531.558008-1-sdf@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH bpf-next v7 07/11] libbpf: implement bpf_prog_query_opts
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/include/uapi/linux/bpf.h |  5 ++++
 tools/lib/bpf/bpf.c            | 42 +++++++++++++++++++++++++++-------
 tools/lib/bpf/bpf.h            | 15 ++++++++++++
 tools/lib/bpf/libbpf.map       |  1 +
 4 files changed, 55 insertions(+), 8 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b9d2d6de63a7..432fc5f49567 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1432,6 +1432,7 @@ union bpf_attr {
 		__u32		attach_flags;
 		__aligned_u64	prog_ids;
 		__u32		prog_cnt;
+		__aligned_u64	prog_attach_flags; /* output: per-program attach_flags */
 	} query;
 
 	struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
@@ -5911,6 +5912,10 @@ struct bpf_prog_info {
 	__u64 run_cnt;
 	__u64 recursion_misses;
 	__u32 verified_insns;
+	/* BTF ID of the function to attach to within BTF object identified
+	 * by btf_id.
+	 */
+	__u32 attach_btf_func_id;
 } __attribute__((aligned(8)));
 
 struct bpf_map_info {
diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 4677644d80f4..f0c2c2ea5a93 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -968,28 +968,54 @@ int bpf_iter_create(int link_fd)
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
 
 	memset(&attr, 0, sizeof(attr));
+
+	if (!OPTS_VALID(opts, bpf_prog_query_opts))
+		return libbpf_err(-EINVAL);
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
 
-	if (attach_flags)
-		*attach_flags = attr.query.attach_flags;
-	*prog_cnt = attr.query.prog_cnt;
+	if (OPTS_HAS(opts, prog_cnt))
+		opts->prog_cnt = attr.query.prog_cnt;
+	if (OPTS_HAS(opts, attach_flags))
+		opts->attach_flags = attr.query.attach_flags;
 
 	return libbpf_err_errno(ret);
 }
 
+int bpf_prog_query(int target_fd, enum bpf_attach_type type, __u32 query_flags,
+		   __u32 *attach_flags, __u32 *prog_ids, __u32 *prog_cnt)
+{
+	LIBBPF_OPTS(bpf_prog_query_opts, p);
+	int ret;
+
+	p.query_flags = query_flags;
+	p.prog_ids = prog_ids;
+	p.prog_cnt = *prog_cnt;
+
+	ret = bpf_prog_query_opts(target_fd, type, &p);
+
+	if (attach_flags)
+		*attach_flags = p.attach_flags;
+	*prog_cnt = p.prog_cnt;
+
+	return ret;
+}
+
 int bpf_prog_test_run(int prog_fd, int repeat, void *data, __u32 size,
 		      void *data_out, __u32 *size_out, __u32 *retval,
 		      __u32 *duration)
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 2e0d3731e4c0..11ffbed99637 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -484,9 +484,24 @@ LIBBPF_API int bpf_map_get_fd_by_id(__u32 id);
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
index 6b36f46ab5d8..24f7a5147bf2 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -452,6 +452,7 @@ LIBBPF_0.8.0 {
 		bpf_map_delete_elem_flags;
 		bpf_object__destroy_subskeleton;
 		bpf_object__open_subskeleton;
+		bpf_prog_query_opts;
 		bpf_program__attach_kprobe_multi_opts;
 		bpf_program__attach_trace_opts;
 		bpf_program__attach_usdt;
-- 
2.36.1.124.g0e6072fb45-goog

