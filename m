Return-Path: <netdev+bounces-9025-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7321F7269BC
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 21:27:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE6221C20EB5
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:27:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBC5A39247;
	Wed,  7 Jun 2023 19:26:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C055639234;
	Wed,  7 Jun 2023 19:26:41 +0000 (UTC)
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8E61FD5;
	Wed,  7 Jun 2023 12:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=9bLt1bZoja3A6VdG8QxGXZX21kSsesIkv3TXCJcc660=; b=CnUb9WZpmBb2Z2v9m9FT2TFQZC
	A/ho/MPvlPVwupOw/zj1mkpWcQ1s1ngjAyS0biPCjWw1FQwFxJ329TQ/EGyC+Qq1NWeQwmYBeXvOg
	6IpRmoE3eQeKCRlh7l7UtqmdnM2hwTpDiry+GZHkw4gheBT0crshzzeWqHhDyz+a1MkdNis5nnk4X
	wEYNxm+wtoZnH2O4btl1gwkpBGgN51FbxaNhBWIN/eZokFhBjfO+F5tSIlM8ctzCLSbDn35ZYig/y
	zhGD+1V0o8E3KqncS8sJRa8uXTJUsq7+tLX35Q+IciSyIGRQsd3J5H0K78ytPCAGqmW8PRE7Ck4o3
	Ph+M8iIg==;
Received: from 49.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.49] helo=localhost)
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1q6ynk-000CYB-8D; Wed, 07 Jun 2023 21:26:36 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
To: ast@kernel.org
Cc: andrii@kernel.org,
	martin.lau@linux.dev,
	razor@blackwall.org,
	sdf@google.com,
	john.fastabend@gmail.com,
	kuba@kernel.org,
	dxu@dxuuu.xyz,
	joe@cilium.io,
	toke@kernel.org,
	davem@davemloft.net,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next v2 3/7] libbpf: Add opts-based attach/detach/query API for tcx
Date: Wed,  7 Jun 2023 21:26:21 +0200
Message-Id: <20230607192625.22641-4-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230607192625.22641-1-daniel@iogearbox.net>
References: <20230607192625.22641-1-daniel@iogearbox.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26931/Wed Jun  7 09:23:57 2023)
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Extend libbpf attach opts and add a new detach opts API so this can be used
to add/remove fd-based tcx BPF programs. The old-style bpf_prog_detach and
bpf_prog_detach2 APIs are refactored to reuse the detach opts internally.

The bpf_prog_query_opts API got extended to be able to handle the new link_ids,
link_attach_flags and revision fields.

For concrete usage examples, see the extensive selftests that have been
developed as part of this series.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 tools/lib/bpf/bpf.c      | 78 ++++++++++++++++++++++------------------
 tools/lib/bpf/bpf.h      | 54 +++++++++++++++++++++-------
 tools/lib/bpf/libbpf.c   |  6 ++++
 tools/lib/bpf/libbpf.map |  1 +
 4 files changed, 91 insertions(+), 48 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index ed86b37d8024..a3d1b7ebe224 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -629,11 +629,21 @@ int bpf_prog_attach(int prog_fd, int target_fd, enum bpf_attach_type type,
 	return bpf_prog_attach_opts(prog_fd, target_fd, type, &opts);
 }
 
-int bpf_prog_attach_opts(int prog_fd, int target_fd,
-			  enum bpf_attach_type type,
-			  const struct bpf_prog_attach_opts *opts)
+int bpf_prog_detach(int target_fd, enum bpf_attach_type type)
+{
+	return bpf_prog_detach_opts(0, target_fd, type, NULL);
+}
+
+int bpf_prog_detach2(int prog_fd, int target_fd, enum bpf_attach_type type)
 {
-	const size_t attr_sz = offsetofend(union bpf_attr, replace_bpf_fd);
+	return bpf_prog_detach_opts(prog_fd, target_fd, type, NULL);
+}
+
+int bpf_prog_attach_opts(int prog_fd, int target,
+			 enum bpf_attach_type type,
+			 const struct bpf_prog_attach_opts *opts)
+{
+	const size_t attr_sz = offsetofend(union bpf_attr, expected_revision);
 	union bpf_attr attr;
 	int ret;
 
@@ -641,40 +651,35 @@ int bpf_prog_attach_opts(int prog_fd, int target_fd,
 		return libbpf_err(-EINVAL);
 
 	memset(&attr, 0, attr_sz);
-	attr.target_fd	   = target_fd;
-	attr.attach_bpf_fd = prog_fd;
-	attr.attach_type   = type;
-	attr.attach_flags  = OPTS_GET(opts, flags, 0);
-	attr.replace_bpf_fd = OPTS_GET(opts, replace_prog_fd, 0);
+	attr.target_fd		= target;
+	attr.attach_bpf_fd	= prog_fd;
+	attr.attach_type	= type;
+	attr.attach_flags	= OPTS_GET(opts, flags, 0);
+	attr.replace_bpf_fd	= OPTS_GET(opts, relative_fd, 0);
+	attr.expected_revision	= OPTS_GET(opts, expected_revision, 0);
 
 	ret = sys_bpf(BPF_PROG_ATTACH, &attr, attr_sz);
 	return libbpf_err_errno(ret);
 }
 
-int bpf_prog_detach(int target_fd, enum bpf_attach_type type)
+int bpf_prog_detach_opts(int prog_fd, int target,
+			 enum bpf_attach_type type,
+			 const struct bpf_prog_detach_opts *opts)
 {
-	const size_t attr_sz = offsetofend(union bpf_attr, replace_bpf_fd);
+	const size_t attr_sz = offsetofend(union bpf_attr, expected_revision);
 	union bpf_attr attr;
 	int ret;
 
-	memset(&attr, 0, attr_sz);
-	attr.target_fd	 = target_fd;
-	attr.attach_type = type;
-
-	ret = sys_bpf(BPF_PROG_DETACH, &attr, attr_sz);
-	return libbpf_err_errno(ret);
-}
-
-int bpf_prog_detach2(int prog_fd, int target_fd, enum bpf_attach_type type)
-{
-	const size_t attr_sz = offsetofend(union bpf_attr, replace_bpf_fd);
-	union bpf_attr attr;
-	int ret;
+	if (!OPTS_VALID(opts, bpf_prog_detach_opts))
+		return libbpf_err(-EINVAL);
 
 	memset(&attr, 0, attr_sz);
-	attr.target_fd	 = target_fd;
-	attr.attach_bpf_fd = prog_fd;
-	attr.attach_type = type;
+	attr.target_fd		= target;
+	attr.attach_bpf_fd	= prog_fd;
+	attr.attach_type	= type;
+	attr.attach_flags	= OPTS_GET(opts, flags, 0);
+	attr.replace_bpf_fd	= OPTS_GET(opts, relative_fd, 0);
+	attr.expected_revision	= OPTS_GET(opts, expected_revision, 0);
 
 	ret = sys_bpf(BPF_PROG_DETACH, &attr, attr_sz);
 	return libbpf_err_errno(ret);
@@ -833,7 +838,7 @@ int bpf_iter_create(int link_fd)
 	return libbpf_err_errno(fd);
 }
 
-int bpf_prog_query_opts(int target_fd,
+int bpf_prog_query_opts(int target,
 			enum bpf_attach_type type,
 			struct bpf_prog_query_opts *opts)
 {
@@ -846,17 +851,20 @@ int bpf_prog_query_opts(int target_fd,
 
 	memset(&attr, 0, attr_sz);
 
-	attr.query.target_fd	= target_fd;
-	attr.query.attach_type	= type;
-	attr.query.query_flags	= OPTS_GET(opts, query_flags, 0);
-	attr.query.prog_cnt	= OPTS_GET(opts, prog_cnt, 0);
-	attr.query.prog_ids	= ptr_to_u64(OPTS_GET(opts, prog_ids, NULL));
-	attr.query.prog_attach_flags = ptr_to_u64(OPTS_GET(opts, prog_attach_flags, NULL));
+	attr.query.target_fd		= target;
+	attr.query.attach_type		= type;
+	attr.query.query_flags		= OPTS_GET(opts, query_flags, 0);
+	attr.query.count		= OPTS_GET(opts, count, 0);
+	attr.query.prog_ids		= ptr_to_u64(OPTS_GET(opts, prog_ids, NULL));
+	attr.query.prog_attach_flags	= ptr_to_u64(OPTS_GET(opts, prog_attach_flags, NULL));
+	attr.query.link_ids		= ptr_to_u64(OPTS_GET(opts, link_ids, NULL));
+	attr.query.link_attach_flags	= ptr_to_u64(OPTS_GET(opts, link_attach_flags, NULL));
 
 	ret = sys_bpf(BPF_PROG_QUERY, &attr, attr_sz);
 
 	OPTS_SET(opts, attach_flags, attr.query.attach_flags);
-	OPTS_SET(opts, prog_cnt, attr.query.prog_cnt);
+	OPTS_SET(opts, revision, attr.query.revision);
+	OPTS_SET(opts, count, attr.query.count);
 
 	return libbpf_err_errno(ret);
 }
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 9aa0ee473754..480c584a6f7f 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -312,22 +312,43 @@ LIBBPF_API int bpf_obj_get(const char *pathname);
 LIBBPF_API int bpf_obj_get_opts(const char *pathname,
 				const struct bpf_obj_get_opts *opts);
 
-struct bpf_prog_attach_opts {
-	size_t sz; /* size of this struct for forward/backward compatibility */
-	unsigned int flags;
-	int replace_prog_fd;
-};
-#define bpf_prog_attach_opts__last_field replace_prog_fd
-
 LIBBPF_API int bpf_prog_attach(int prog_fd, int attachable_fd,
 			       enum bpf_attach_type type, unsigned int flags);
-LIBBPF_API int bpf_prog_attach_opts(int prog_fd, int attachable_fd,
-				     enum bpf_attach_type type,
-				     const struct bpf_prog_attach_opts *opts);
 LIBBPF_API int bpf_prog_detach(int attachable_fd, enum bpf_attach_type type);
 LIBBPF_API int bpf_prog_detach2(int prog_fd, int attachable_fd,
 				enum bpf_attach_type type);
 
+struct bpf_prog_attach_opts {
+	size_t sz; /* size of this struct for forward/backward compatibility */
+	__u32 flags;
+	union {
+		int	replace_prog_fd;
+		int	replace_fd;
+		int	relative_fd;
+		__u32	relative_id;
+	};
+	__u32 expected_revision;
+};
+#define bpf_prog_attach_opts__last_field expected_revision
+
+struct bpf_prog_detach_opts {
+	size_t sz; /* size of this struct for forward/backward compatibility */
+	__u32 flags;
+	union {
+		int	relative_fd;
+		__u32	relative_id;
+	};
+	__u32 expected_revision;
+};
+#define bpf_prog_detach_opts__last_field expected_revision
+
+LIBBPF_API int bpf_prog_attach_opts(int prog_fd, int target,
+				    enum bpf_attach_type type,
+				    const struct bpf_prog_attach_opts *opts);
+LIBBPF_API int bpf_prog_detach_opts(int prog_fd, int target,
+				    enum bpf_attach_type type,
+				    const struct bpf_prog_detach_opts *opts);
+
 union bpf_iter_link_info; /* defined in up-to-date linux/bpf.h */
 struct bpf_link_create_opts {
 	size_t sz; /* size of this struct for forward/backward compatibility */
@@ -489,14 +510,21 @@ struct bpf_prog_query_opts {
 	__u32 query_flags;
 	__u32 attach_flags; /* output argument */
 	__u32 *prog_ids;
-	__u32 prog_cnt; /* input+output argument */
+	union {
+		__u32 prog_cnt; /* input+output argument */
+		__u32 count;
+	};
 	__u32 *prog_attach_flags;
+	__u32 *link_ids;
+	__u32 *link_attach_flags;
+	__u32 revision;
 };
-#define bpf_prog_query_opts__last_field prog_attach_flags
+#define bpf_prog_query_opts__last_field revision
 
-LIBBPF_API int bpf_prog_query_opts(int target_fd,
+LIBBPF_API int bpf_prog_query_opts(int target,
 				   enum bpf_attach_type type,
 				   struct bpf_prog_query_opts *opts);
+
 LIBBPF_API int bpf_prog_query(int target_fd, enum bpf_attach_type type,
 			      __u32 query_flags, __u32 *attach_flags,
 			      __u32 *prog_ids, __u32 *prog_cnt);
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 47632606b06d..b89127471c6a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -117,6 +117,8 @@ static const char * const attach_type_name[] = {
 	[BPF_PERF_EVENT]		= "perf_event",
 	[BPF_TRACE_KPROBE_MULTI]	= "trace_kprobe_multi",
 	[BPF_STRUCT_OPS]		= "struct_ops",
+	[BPF_TCX_INGRESS]		= "tcx_ingress",
+	[BPF_TCX_EGRESS]		= "tcx_egress",
 };
 
 static const char * const link_type_name[] = {
@@ -8669,6 +8671,10 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("kretsyscall+",		KPROBE, 0, SEC_NONE, attach_ksyscall),
 	SEC_DEF("usdt+",		KPROBE,	0, SEC_NONE, attach_usdt),
 	SEC_DEF("tc",			SCHED_CLS, 0, SEC_NONE),
+	SEC_DEF("tc/ingress",		SCHED_CLS, BPF_TCX_INGRESS, SEC_ATTACHABLE_OPT),
+	SEC_DEF("tc/egress",		SCHED_CLS, BPF_TCX_EGRESS, SEC_ATTACHABLE_OPT),
+	SEC_DEF("tcx/ingress",		SCHED_CLS, BPF_TCX_INGRESS, SEC_ATTACHABLE_OPT),
+	SEC_DEF("tcx/egress",		SCHED_CLS, BPF_TCX_EGRESS, SEC_ATTACHABLE_OPT),
 	SEC_DEF("classifier",		SCHED_CLS, 0, SEC_NONE),
 	SEC_DEF("action",		SCHED_ACT, 0, SEC_NONE),
 	SEC_DEF("tracepoint+",		TRACEPOINT, 0, SEC_NONE, attach_tp),
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 7521a2fb7626..a29b90e9713c 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -395,4 +395,5 @@ LIBBPF_1.2.0 {
 LIBBPF_1.3.0 {
 	global:
 		bpf_obj_pin_opts;
+		bpf_prog_detach_opts;
 } LIBBPF_1.2.0;
-- 
2.34.1


