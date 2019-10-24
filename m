Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43338E3CFD
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 22:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbfJXUPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 16:15:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2618 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725958AbfJXUPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 16:15:52 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9OKFoF3032162
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 13:15:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=AqguFbZ5f9u34b5gn1m0+C3/fKrXRL4Heu2+Fcpv7uw=;
 b=KVIwobNlyBj7ZX46no+QcLPM0XqMdJWv+bBM74dE+jDDJ+IuD19x5sFsm7YA/YHtUbu+
 c7Mky4/yR+TBKOCL3IhkkO/jZnTkYhKOUrGWm3XaOIOav9tGj1B/xSzVeWCxtITjzaJ8
 diyAlig6veyMMTOR2zREmPHw85NosIfNN8E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vu01p57vu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 13:15:51 -0700
Received: from 2401:db00:2050:5076:face:0:7:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 24 Oct 2019 13:15:25 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 7BFC52941F3D; Thu, 24 Oct 2019 13:15:24 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] bpf: Prepare btf_ctx_access for non raw_tp use case.
Date:   Thu, 24 Oct 2019 13:15:24 -0700
Message-ID: <20191024201524.685995-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-24_11:2019-10-23,2019-10-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 spamscore=0 mlxscore=0 clxscore=1015
 phishscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910240189
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch makes a few changes to btf_ctx_access() to prepare
it for non raw_tp use case.

btf_ctx_access() only needs the attach_btf_id from prog.  Hence, this patch
only passes the attach_btf_id instead of passing prog.  It allows other
use cases when the prog->aux->attach_btf_id may not be a typedef.
For example, in the future, a bpf_prog can attach to
"struct tcp_congestion_ops" and its attach_btf_id is
pointing to the btf_id of "struct tcp_congestion_ops".

While at it, allow btf_ctx_access to directly take a BTF_KIND_FUNC_PROTO
btf_id.  It is to prepare for a later patch that does not need a "typedef"
to figure out the func_proto.  For example, when attaching a bpf_prog
to an ops in "struct tcp_congestion_ops", the func_proto can be
found directly by following the members of "struct tcp_congestion_ops".

For the no typedef use case, there is no extra first arg.  Hence, this
patch only limits the skip arg logic to raw_tp only.

Since a BTF_KIND_FUNC_PROTO type does not have a name (i.e. "(anon)"),
an optional name arg is added also.  If specified, this name will be used
in the bpf_log() message instead of the type's name obtained from btf_id.
For example, the function pointer member name of
"struct tcp_congestion_ops" can be used.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/bpf.h      |  2 +-
 kernel/bpf/btf.c         | 53 ++++++++++++++++++++++++++--------------
 kernel/trace/bpf_trace.c |  3 ++-
 3 files changed, 38 insertions(+), 20 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 2c2c29b49845..1befe59331d9 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -766,7 +766,7 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 				     const union bpf_attr *kattr,
 				     union bpf_attr __user *uattr);
 bool btf_ctx_access(int off, int size, enum bpf_access_type type,
-		    const struct bpf_prog *prog,
+		    u32 btf_id, const char *name,
 		    struct bpf_insn_access_aux *info);
 int btf_struct_access(struct bpf_verifier_log *log,
 		      const struct btf_type *t, int off, int size,
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index f7557af39756..8c8174782675 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -346,6 +346,11 @@ static bool btf_type_is_func_proto(const struct btf_type *t)
 	return BTF_INFO_KIND(t->info) == BTF_KIND_FUNC_PROTO;
 }
 
+static bool btf_type_is_typedef(const struct btf_type *t)
+{
+	return BTF_INFO_KIND(t->info) == BTF_KIND_TYPEDEF;
+}
+
 static bool btf_type_nosize(const struct btf_type *t)
 {
 	return btf_type_is_void(t) || btf_type_is_fwd(t) ||
@@ -3439,16 +3444,16 @@ struct btf *btf_parse_vmlinux(void)
 extern struct btf *btf_vmlinux;
 
 bool btf_ctx_access(int off, int size, enum bpf_access_type type,
-		    const struct bpf_prog *prog,
+		    u32 btf_id, const char *func_name,
 		    struct bpf_insn_access_aux *info)
 {
 	struct bpf_verifier_log *log = info->log;
-	u32 btf_id = prog->aux->attach_btf_id;
 	const struct btf_param *args;
 	const struct btf_type *t;
 	const char prefix[] = "btf_trace_";
 	const char *tname;
 	u32 nr_args, arg;
+	bool is_raw_tp = false;
 
 	if (!btf_id)
 		return true;
@@ -3459,37 +3464,49 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 	}
 
 	t = btf_type_by_id(btf_vmlinux, btf_id);
-	if (!t || BTF_INFO_KIND(t->info) != BTF_KIND_TYPEDEF) {
+	if (!t || (!btf_type_is_typedef(t) && !btf_type_is_func_proto(t))) {
 		bpf_log(log, "btf_id is invalid\n");
 		return false;
 	}
 
 	tname = __btf_name_by_offset(btf_vmlinux, t->name_off);
-	if (strncmp(prefix, tname, sizeof(prefix) - 1)) {
-		bpf_log(log, "btf_id points to wrong type name %s\n", tname);
-		return false;
+	if (btf_type_is_typedef(t)) {
+		if (strncmp(prefix, tname, sizeof(prefix) - 1)) {
+			bpf_log(log, "btf_id points to wrong type name %s\n",
+				tname);
+			return false;
+		}
+		tname += sizeof(prefix) - 1;
+
+		t = btf_type_by_id(btf_vmlinux, t->type);
+		if (!btf_type_is_ptr(t))
+			return false;
+		t = btf_type_by_id(btf_vmlinux, t->type);
+		btf_id = t->type;
+		is_raw_tp = true;
 	}
-	tname += sizeof(prefix) - 1;
 
-	t = btf_type_by_id(btf_vmlinux, t->type);
-	if (!btf_type_is_ptr(t))
-		return false;
-	t = btf_type_by_id(btf_vmlinux, t->type);
 	if (!btf_type_is_func_proto(t))
 		return false;
 
+	if (func_name)
+		tname = func_name;
+
 	if (off % 8) {
-		bpf_log(log, "raw_tp '%s' offset %d is not multiple of 8\n",
+		bpf_log(log, "func '%s' offset %d is not multiple of 8\n",
 			tname, off);
 		return false;
 	}
 	arg = off / 8;
 	args = (const struct btf_param *)(t + 1);
+	nr_args = btf_type_vlen(t);
 	/* skip first 'void *__data' argument in btf_trace_##name typedef */
-	args++;
-	nr_args = btf_type_vlen(t) - 1;
+	if (is_raw_tp) {
+		args++;
+		nr_args--;
+	}
 	if (arg >= nr_args) {
-		bpf_log(log, "raw_tp '%s' doesn't have %d-th argument\n",
+		bpf_log(log, "func '%s' doesn't have %d-th argument\n",
 			tname, arg);
 		return false;
 	}
@@ -3503,7 +3520,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		return true;
 	if (!btf_type_is_ptr(t)) {
 		bpf_log(log,
-			"raw_tp '%s' arg%d '%s' has type %s. Only pointer access is allowed\n",
+			"func '%s' arg%d '%s' has type %s. Only pointer access is allowed\n",
 			tname, arg,
 			__btf_name_by_offset(btf_vmlinux, t->name_off),
 			btf_kind_str[BTF_INFO_KIND(t->info)]);
@@ -3526,11 +3543,11 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		t = btf_type_by_id(btf_vmlinux, t->type);
 	if (!btf_type_is_struct(t)) {
 		bpf_log(log,
-			"raw_tp '%s' arg%d type %s is not a struct\n",
+			"func '%s' arg%d type %s is not a struct\n",
 			tname, arg, btf_kind_str[BTF_INFO_KIND(t->info)]);
 		return false;
 	}
-	bpf_log(log, "raw_tp '%s' arg%d has btf_id %d type %s '%s'\n",
+	bpf_log(log, "func '%s' arg%d has btf_id %d type %s '%s'\n",
 		tname, arg, info->btf_id, btf_kind_str[BTF_INFO_KIND(t->info)],
 		__btf_name_by_offset(btf_vmlinux, t->name_off));
 	return true;
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index c3240898cc44..435869b1834a 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1080,7 +1080,8 @@ static bool raw_tp_prog_is_valid_access(int off, int size,
 		return false;
 	if (off % size != 0)
 		return false;
-	return btf_ctx_access(off, size, type, prog, info);
+	return btf_ctx_access(off, size, type, prog->aux->attach_btf_id, NULL,
+			      info);
 }
 
 const struct bpf_verifier_ops raw_tracepoint_verifier_ops = {
-- 
2.17.1

