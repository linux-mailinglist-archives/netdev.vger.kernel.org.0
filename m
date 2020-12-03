Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBCDE2CCD90
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 04:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388026AbgLCDxP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Dec 2020 22:53:15 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15588 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388018AbgLCDxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 22:53:14 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B33kpex005482
        for <netdev@vger.kernel.org>; Wed, 2 Dec 2020 19:52:33 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3560xg0km2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 19:52:33 -0800
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 2 Dec 2020 19:52:32 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 30EE12ECA822; Wed,  2 Dec 2020 19:52:28 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v5 bpf-next 10/14] bpf: allow to specify kernel module BTFs when attaching BPF programs
Date:   Wed, 2 Dec 2020 19:52:00 -0800
Message-ID: <20201203035204.1411380-11-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201203035204.1411380-1-andrii@kernel.org>
References: <20201203035204.1411380-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_01:2020-11-30,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1034 spamscore=0
 phishscore=0 malwarescore=0 suspectscore=25 adultscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030020
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ability for user-space programs to specify non-vmlinux BTF when attaching
BTF-powered BPF programs: raw_tp, fentry/fexit/fmod_ret, LSM, etc. For this,
attach_prog_fd (now with the alias name attach_btf_obj_fd) should specify FD
of a module or vmlinux BTF object. For backwards compatibility reasons,
0 denotes vmlinux BTF. Only kernel BTF (vmlinux or module) can be specified.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 include/linux/btf.h            |  1 +
 include/uapi/linux/bpf.h       |  7 ++-
 kernel/bpf/btf.c               |  5 +++
 kernel/bpf/syscall.c           | 82 +++++++++++++++++++++-------------
 tools/include/uapi/linux/bpf.h |  7 ++-
 5 files changed, 69 insertions(+), 33 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index fb608e4de076..4c200f5d242b 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -90,6 +90,7 @@ int btf_type_snprintf_show(const struct btf *btf, u32 type_id, void *obj,
 
 int btf_get_fd_by_id(u32 id);
 u32 btf_obj_id(const struct btf *btf);
+bool btf_is_kernel(const struct btf *btf);
 bool btf_member_is_reg_int(const struct btf *btf, const struct btf_type *s,
 			   const struct btf_member *m,
 			   u32 expected_offset, u32 expected_size);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c3458ec1f30a..1233f14f659f 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -557,7 +557,12 @@ union bpf_attr {
 		__aligned_u64	line_info;	/* line info */
 		__u32		line_info_cnt;	/* number of bpf_line_info records */
 		__u32		attach_btf_id;	/* in-kernel BTF type id to attach to */
-		__u32		attach_prog_fd; /* 0 to attach to vmlinux */
+		union {
+			/* valid prog_fd to attach to bpf prog */
+			__u32		attach_prog_fd;
+			/* or valid module BTF object fd or 0 to attach to vmlinux */
+			__u32		attach_btf_obj_fd;
+		};
 	};
 
 	struct { /* anonymous struct used by BPF_OBJ_* commands */
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 7a19bf5bfe97..8d6bdb4f4d61 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5738,6 +5738,11 @@ u32 btf_obj_id(const struct btf *btf)
 	return btf->id;
 }
 
+bool btf_is_kernel(const struct btf *btf)
+{
+	return btf->kernel_btf;
+}
+
 static int btf_id_cmp_func(const void *a, const void *b)
 {
 	const int *pa = a, *pb = b;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4fd7d9269008..1b5a053f4343 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1924,12 +1924,16 @@ static void bpf_prog_load_fixup_attach_type(union bpf_attr *attr)
 static int
 bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 			   enum bpf_attach_type expected_attach_type,
-			   u32 btf_id, u32 prog_fd)
+			   struct btf *attach_btf, u32 btf_id,
+			   struct bpf_prog *dst_prog)
 {
 	if (btf_id) {
 		if (btf_id > BTF_MAX_TYPE)
 			return -EINVAL;
 
+		if (!attach_btf && !dst_prog)
+			return -EINVAL;
+
 		switch (prog_type) {
 		case BPF_PROG_TYPE_TRACING:
 		case BPF_PROG_TYPE_LSM:
@@ -1941,7 +1945,10 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 		}
 	}
 
-	if (prog_fd && prog_type != BPF_PROG_TYPE_TRACING &&
+	if (attach_btf && (!btf_id || dst_prog))
+		return -EINVAL;
+
+	if (dst_prog && prog_type != BPF_PROG_TYPE_TRACING &&
 	    prog_type != BPF_PROG_TYPE_EXT)
 		return -EINVAL;
 
@@ -2058,7 +2065,8 @@ static bool is_perfmon_prog_type(enum bpf_prog_type prog_type)
 static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 {
 	enum bpf_prog_type type = attr->prog_type;
-	struct bpf_prog *prog;
+	struct bpf_prog *prog, *dst_prog = NULL;
+	struct btf *attach_btf = NULL;
 	int err;
 	char license[128];
 	bool is_gpl;
@@ -2100,44 +2108,56 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	if (is_perfmon_prog_type(type) && !perfmon_capable())
 		return -EPERM;
 
+	/* attach_prog_fd/attach_btf_obj_fd can specify fd of either bpf_prog
+	 * or btf, we need to check which one it is
+	 */
+	if (attr->attach_prog_fd) {
+		dst_prog = bpf_prog_get(attr->attach_prog_fd);
+		if (IS_ERR(dst_prog)) {
+			dst_prog = NULL;
+			attach_btf = btf_get_by_fd(attr->attach_btf_obj_fd);
+			if (IS_ERR(attach_btf))
+				return -EINVAL;
+			if (!btf_is_kernel(attach_btf)) {
+				btf_put(attach_btf);
+				return -EINVAL;
+			}
+		}
+	} else if (attr->attach_btf_id) {
+		/* fall back to vmlinux BTF, if BTF type ID is specified */
+		attach_btf = bpf_get_btf_vmlinux();
+		if (IS_ERR(attach_btf))
+			return PTR_ERR(attach_btf);
+		if (!attach_btf)
+			return -EINVAL;
+		btf_get(attach_btf);
+	}
+
 	bpf_prog_load_fixup_attach_type(attr);
 	if (bpf_prog_load_check_attach(type, attr->expected_attach_type,
-				       attr->attach_btf_id,
-				       attr->attach_prog_fd))
+				       attach_btf, attr->attach_btf_id,
+				       dst_prog)) {
+		if (dst_prog)
+			bpf_prog_put(dst_prog);
+		if (attach_btf)
+			btf_put(attach_btf);
 		return -EINVAL;
+	}
 
 	/* plain bpf_prog allocation */
 	prog = bpf_prog_alloc(bpf_prog_size(attr->insn_cnt), GFP_USER);
-	if (!prog)
+	if (!prog) {
+		if (dst_prog)
+			bpf_prog_put(dst_prog);
+		if (attach_btf)
+			btf_put(attach_btf);
 		return -ENOMEM;
+	}
 
 	prog->expected_attach_type = attr->expected_attach_type;
+	prog->aux->attach_btf = attach_btf;
 	prog->aux->attach_btf_id = attr->attach_btf_id;
-
-	if (attr->attach_btf_id && !attr->attach_prog_fd) {
-		struct btf *btf;
-
-		btf = bpf_get_btf_vmlinux();
-		if (IS_ERR(btf))
-			return PTR_ERR(btf);
-		if (!btf)
-			return -EINVAL;
-
-		btf_get(btf);
-		prog->aux->attach_btf = btf;
-	}
-
-	if (attr->attach_prog_fd) {
-		struct bpf_prog *dst_prog;
-
-		dst_prog = bpf_prog_get(attr->attach_prog_fd);
-		if (IS_ERR(dst_prog)) {
-			err = PTR_ERR(dst_prog);
-			goto free_prog;
-		}
-		prog->aux->dst_prog = dst_prog;
-	}
-
+	prog->aux->dst_prog = dst_prog;
 	prog->aux->offload_requested = !!attr->prog_ifindex;
 	prog->aux->sleepable = attr->prog_flags & BPF_F_SLEEPABLE;
 
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index c3458ec1f30a..1233f14f659f 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -557,7 +557,12 @@ union bpf_attr {
 		__aligned_u64	line_info;	/* line info */
 		__u32		line_info_cnt;	/* number of bpf_line_info records */
 		__u32		attach_btf_id;	/* in-kernel BTF type id to attach to */
-		__u32		attach_prog_fd; /* 0 to attach to vmlinux */
+		union {
+			/* valid prog_fd to attach to bpf prog */
+			__u32		attach_prog_fd;
+			/* or valid module BTF object fd or 0 to attach to vmlinux */
+			__u32		attach_btf_obj_fd;
+		};
 	};
 
 	struct { /* anonymous struct used by BPF_OBJ_* commands */
-- 
2.24.1

