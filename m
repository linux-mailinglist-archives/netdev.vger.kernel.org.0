Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F185550C1
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 18:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376673AbiFVQEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 12:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376608AbiFVQEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 12:04:11 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F282E36B70
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 09:04:05 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id u6-20020a63d346000000b00407d7652203so9216583pgi.18
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 09:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=UXuka4BFyLFGuWoAnLaszoN+ipFkLzHli/q8mm4HvyE=;
        b=bN+jmcqOWRR4CaJM+AzYdknRIOu8l0DD6qvCKJrIU9h4fDE/O0ivisq0XpbDUIiSPm
         d6jU26/JY93GWgj18C2tRTU62Zhl4c2XTrnBgF0TUjEI3UAWtpWWydImlkLvIUH1i5S0
         PYBdtDGQKYEUt4zjmgN4233OZ4KymCTLBUCLVlVqorQwQcGOaLXZkB8lshLJgEjiBWho
         PkIiU7XBRGUKDuAaWOCyuFZvxnEbV45GGztg0PYDdBCjyLZlyt0loRBb2235BaYcisQw
         jFYveQnxEO7EklPZdvtXwzCsrJVkZZ6atz1JovjceJMXOAUUZsxplyTsTM49HLRjBxPc
         OkOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UXuka4BFyLFGuWoAnLaszoN+ipFkLzHli/q8mm4HvyE=;
        b=M87AqnKav8nscHqzbLJD5jfw3GHx+N8ltwHf/Ok4d+hRSP/s+fhh86Dly5XxL69RKV
         fLvfry0OGBgNAUphO2LU0fnEZxCzRSG8oN1vOa3BDMq/C2fSX3mPzJtott0z/cF5lxf2
         PwN6e0/eD1kjvLlRmwaRTb+j6kRiEF5OD3GsomCR5YzLRekDa0sCnV1fsce+4bO169QB
         I+6GtDZktn9gzAuybS17hLtq1hORHAv0hwEDuX91noeMgAIbtlakAMpkGcEkdDURJAGk
         vznc5DGpfEhfS+NuZl8NFnjN9AQ6XXlM94k0HFm8ymMVBYRs5840cZ3caoc0xwUjmLfy
         ZVAQ==
X-Gm-Message-State: AJIora/Oft3br3VYb9JweX13nsJ2a98tU2eEMccJy1cup89cXuv/5STP
        ClADz5L5b4mfP/oHkSo0A45F1ocbp0hxIMZEh31yvQ4ZUaQf2D+1af2dBDQsJw59WMwVE51y8i0
        DDwOqcxzP6bkuiDwfpYaseoDUylk1KXD28SiAhNAHJxawoLLXKN5Ezg==
X-Google-Smtp-Source: AGRyM1vrWqPfPNd3QJOa4eztlB1yd1yurZ4WNXQNgi8M8PbaunIqr2HWc/+PqryqmWNVQDvTu0FJjRM=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:4a97:b0:1ea:fa24:467c with SMTP id
 f23-20020a17090a4a9700b001eafa24467cmr10016pjh.1.1655913844836; Wed, 22 Jun
 2022 09:04:04 -0700 (PDT)
Date:   Wed, 22 Jun 2022 09:03:44 -0700
In-Reply-To: <20220622160346.967594-1-sdf@google.com>
Message-Id: <20220622160346.967594-10-sdf@google.com>
Mime-Version: 1.0
References: <20220622160346.967594-1-sdf@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH bpf-next v10 09/11] libbpf: implement bpf_prog_query_opts
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
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
index b7479898c879..ad9e7311c4cf 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1432,6 +1432,7 @@ union bpf_attr {
 		__u32		attach_flags;
 		__aligned_u64	prog_ids;
 		__u32		prog_cnt;
+		__aligned_u64	prog_attach_flags; /* output: per-program attach_flags */
 	} query;
 
 	struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
@@ -6076,6 +6077,8 @@ struct bpf_prog_info {
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
2.37.0.rc0.104.g0611611a94-goog

