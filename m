Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12EE253AD4D
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 21:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiFATrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 15:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiFATrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 15:47:20 -0400
Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A4C262AED
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 12:40:46 -0700 (PDT)
Received: by mail-oo1-f73.google.com with SMTP id v67-20020a4a5a46000000b0033331e32ee0so1439446ooa.20
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 12:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rl4Q5YNXrUZR0MvLiYU75QfslgkmFK8E4ywaOtSsktU=;
        b=M7CfAIsINVDBlypj9OF2zw84prNk4QeiLe23JdEYcNFXQ1AkLaxYs+o0AKIfr/DSwO
         xdSQ2K3sTArbh7FBKcnT6Ar1yIy7a66Zze+VR7e5GxO46Nlj32HulQwebgf7hzf/yfyU
         ng/1q5y/CHZ0utD4HoICcZ8WMG2c1PizXG9zfKgTLGlznCXgCdCmPrVuABu4fOrbzBkq
         m9nBuDJ9+8uj0IYl09tRprWHJ3gPid7yFuhoK39zLizNizQvk1/xykGbDDuptIzLAWV2
         ddS9eGDkjbMc7wfoqTMHGYoKE+5rlCXOvVuxN4FF50DpxOtJ7PxG3r4tiPF2Py0cPprM
         vKBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rl4Q5YNXrUZR0MvLiYU75QfslgkmFK8E4ywaOtSsktU=;
        b=CiJ2pRgIV2fW5yZY+Mfq9kmL1ZT8YH0YKl3tKgkl1BphBzLQ0zOCWcAJ9KvFK+hWcx
         XoHcrrRVhg6dcCLM1yl8v60QgnR9N95gLTM3YOIHYCjcngaJPdnsPkMy8ApCnFHfMb0n
         PHXgAocq4ZGQ4TQcIFX9FsMGXGdKZxEPqv7R+fjZU0JxzAepszxTEySRm6ZEVB8JEm8/
         7+9kULq4zjvlYUVDaLPDOdUDgHVWi1mibADr1xmsvP2Vq8FbWzs85YMN0JMqyo9KJLzP
         LfR8VnlbVeyn7MWmtt20DCE/6RPNHQRx7vJ63Nwarx62LjUEFg86Tu4OGB+yHnbWPdjO
         8ZMw==
X-Gm-Message-State: AOAM533tSYSZhDEcyKkct8frvfM/botVXYlanJaUiI8qcVTHfFrvC83C
        jY24h1u6eF2fMKB4COFsY2PLa/p+8i5fypPnGQurJbEysDPrYcYC9eQgcs3NymdisZCx3n3SgoC
        k/JeI9AWWmm8XCCxrWFfzJdW/EpRPmdiervqcAMOfIyFEl9BsQR3pFw==
X-Google-Smtp-Source: ABdhPJyn3EmbAh10IlNFicL/VZGeQzi5BoVWeVJ0juwujauVMTN0FlSXu4dvMk/Y2oxzxsE5nkZCi+k=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:6308:b0:1de:fb6c:5944 with SMTP id
 e8-20020a17090a630800b001defb6c5944mr890334pjj.60.1654110153798; Wed, 01 Jun
 2022 12:02:33 -0700 (PDT)
Date:   Wed,  1 Jun 2022 12:02:15 -0700
In-Reply-To: <20220601190218.2494963-1-sdf@google.com>
Message-Id: <20220601190218.2494963-9-sdf@google.com>
Mime-Version: 1.0
References: <20220601190218.2494963-1-sdf@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH bpf-next v8 08/11] libbpf: implement bpf_prog_query_opts
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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
 tools/include/uapi/linux/bpf.h |  3 +++
 tools/lib/bpf/bpf.c            | 40 +++++++++++++++++++++++++++-------
 tools/lib/bpf/bpf.h            | 15 +++++++++++++
 tools/lib/bpf/libbpf.map       |  2 +-
 4 files changed, 51 insertions(+), 9 deletions(-)

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
index 240186aac8e6..c7af7db53725 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -888,28 +888,52 @@ int bpf_iter_create(int link_fd)
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
+	OPTS_SET(opts, attach_flags, attr.query.attach_flags);
+	OPTS_SET(opts, prog_cnt, attr.query.prog_cnt);
 
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
index 38e284ff057d..f2f713161775 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -462,10 +462,10 @@ LIBBPF_0.8.0 {
 
 LIBBPF_1.0.0 {
 	global:
+		bpf_prog_query_opts;
 		libbpf_bpf_attach_type_str;
 		libbpf_bpf_link_type_str;
 		libbpf_bpf_map_type_str;
 		libbpf_bpf_prog_type_str;
-
 	local: *;
 };
-- 
2.36.1.255.ge46751e96f-goog

