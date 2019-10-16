Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F041D8661
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 05:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390952AbfJPDZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:25:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11090 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388957AbfJPDZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 23:25:19 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9G3L1kU004312
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 20:25:18 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vnkjd20gg-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 20:25:18 -0700
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 15 Oct 2019 20:25:15 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id EC6BA760F32; Tue, 15 Oct 2019 20:25:13 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 04/11] bpf: add attach_btf_id attribute to program load
Date:   Tue, 15 Oct 2019 20:24:58 -0700
Message-ID: <20191016032505.2089704-5-ast@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191016032505.2089704-1-ast@kernel.org>
References: <20191016032505.2089704-1-ast@kernel.org>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_01:2019-10-15,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 spamscore=0 suspectscore=1 mlxlogscore=999 mlxscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 clxscore=1034
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910160027
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add attach_btf_id attribute to prog_load command.
It's similar to existing expected_attach_type attribute which is
used in several cgroup based program types.
Unfortunately expected_attach_type is ignored for
tracing programs and cannot be reused for new purpose.
Hence introduce attach_btf_id to verify bpf programs against
given in-kernel BTF type id at load time.
It is strictly checked to be valid for raw_tp programs only.
In a later patches it will become:
btf_id == 0 semantics of existing raw_tp progs.
btd_id > 0 raw_tp with BTF and additional type safety.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       |  1 +
 kernel/bpf/syscall.c           | 18 ++++++++++++++----
 tools/include/uapi/linux/bpf.h |  1 +
 4 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 282e28bf41ec..f916380675dd 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -375,6 +375,7 @@ struct bpf_prog_aux {
 	u32 id;
 	u32 func_cnt; /* used by non-func prog as the number of func progs */
 	u32 func_idx; /* 0 for non-func prog, the index in func array for func prog */
+	u32 attach_btf_id; /* in-kernel BTF type id to attach to */
 	bool verifier_zext; /* Zero extensions has been inserted by verifier. */
 	bool offload_requested;
 	struct bpf_prog **func;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a65c3b0c6935..3bb2cd1de341 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -420,6 +420,7 @@ union bpf_attr {
 		__u32		line_info_rec_size;	/* userspace bpf_line_info size */
 		__aligned_u64	line_info;	/* line info */
 		__u32		line_info_cnt;	/* number of bpf_line_info records */
+		__u32		attach_btf_id;	/* in-kernel BTF type id to attach to */
 	};
 
 	struct { /* anonymous struct used by BPF_OBJ_* commands */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 82eabd4e38ad..b56c482c9760 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -23,6 +23,7 @@
 #include <linux/timekeeping.h>
 #include <linux/ctype.h>
 #include <linux/nospec.h>
+#include <uapi/linux/btf.h>
 
 #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PROG_ARRAY || \
 			   (map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
@@ -1565,8 +1566,9 @@ static void bpf_prog_load_fixup_attach_type(union bpf_attr *attr)
 }
 
 static int
-bpf_prog_load_check_attach_type(enum bpf_prog_type prog_type,
-				enum bpf_attach_type expected_attach_type)
+bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
+			   enum bpf_attach_type expected_attach_type,
+			   u32 btf_id)
 {
 	switch (prog_type) {
 	case BPF_PROG_TYPE_CGROUP_SOCK:
@@ -1608,13 +1610,19 @@ bpf_prog_load_check_attach_type(enum bpf_prog_type prog_type,
 		default:
 			return -EINVAL;
 		}
+	case BPF_PROG_TYPE_RAW_TRACEPOINT:
+		if (btf_id > BTF_MAX_TYPE)
+			return -EINVAL;
+		return 0;
 	default:
+		if (btf_id)
+			return -EINVAL;
 		return 0;
 	}
 }
 
 /* last field in 'union bpf_attr' used by this command */
-#define	BPF_PROG_LOAD_LAST_FIELD line_info_cnt
+#define	BPF_PROG_LOAD_LAST_FIELD attach_btf_id
 
 static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 {
@@ -1656,7 +1664,8 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 		return -EPERM;
 
 	bpf_prog_load_fixup_attach_type(attr);
-	if (bpf_prog_load_check_attach_type(type, attr->expected_attach_type))
+	if (bpf_prog_load_check_attach(type, attr->expected_attach_type,
+				       attr->attach_btf_id))
 		return -EINVAL;
 
 	/* plain bpf_prog allocation */
@@ -1665,6 +1674,7 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 		return -ENOMEM;
 
 	prog->expected_attach_type = attr->expected_attach_type;
+	prog->aux->attach_btf_id = attr->attach_btf_id;
 
 	prog->aux->offload_requested = !!attr->prog_ifindex;
 
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a65c3b0c6935..3bb2cd1de341 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -420,6 +420,7 @@ union bpf_attr {
 		__u32		line_info_rec_size;	/* userspace bpf_line_info size */
 		__aligned_u64	line_info;	/* line info */
 		__u32		line_info_cnt;	/* number of bpf_line_info records */
+		__u32		attach_btf_id;	/* in-kernel BTF type id to attach to */
 	};
 
 	struct { /* anonymous struct used by BPF_OBJ_* commands */
-- 
2.17.1

