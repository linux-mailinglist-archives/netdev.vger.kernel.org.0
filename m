Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB51F1C32B9
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 08:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgEDGZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 02:25:54 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58540 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726330AbgEDGZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 02:25:53 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0446OR85015663
        for <netdev@vger.kernel.org>; Sun, 3 May 2020 23:25:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=dtJsG/26YZbNyiFbUeS0UIWBslLRvenjO+ksJpYkTdQ=;
 b=Xhw0apxr4mpat+03DoyJHIaMb8RJRlcC8dNeUp1KfKv3YEcFar3DAYB1ZaeTSjj3RmvX
 QOUnaMqnPqJO3DVGxZuzvlbBFj4gHdyEP/0dB93fcI7P2cqdMyjBSzex1FnuKK0d+k1G
 6RokNk+FDrQpXeNMv0UA2RKLvVDj1DA870k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 30s4byf1nq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 23:25:51 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sun, 3 May 2020 23:25:51 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 9280C3702037; Sun,  3 May 2020 23:25:48 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 02/20] bpf: allow loading of a bpf_iter program
Date:   Sun, 3 May 2020 23:25:48 -0700
Message-ID: <20200504062548.2047454-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200504062547.2047304-1-yhs@fb.com>
References: <20200504062547.2047304-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-04_02:2020-05-01,2020-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 phishscore=0 priorityscore=1501 mlxscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040054
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A bpf_iter program is a tracing program with attach type
BPF_TRACE_ITER. The load attribute
  attach_btf_id
is used by the verifier against a particular kernel function,
which represents a target, e.g., __bpf_iter__bpf_map
for target bpf_map which is implemented later.

The program return value must be 0 or 1 for now.
  0 : successful, except potential seq_file buffer overflow
      which is handled by seq_file reader.
  1 : request to restart the same object

In the future, other return values may be used for filtering or
teminating the iterator.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h            |  3 +++
 include/uapi/linux/bpf.h       |  1 +
 kernel/bpf/bpf_iter.c          | 30 ++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c          | 21 +++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  1 +
 5 files changed, 56 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 597b37c4e1c6..cd385c36a172 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1127,6 +1127,8 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd);
 int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
 int bpf_obj_get_user(const char __user *pathname, int flags);
=20
+#define BPF_ITER_FUNC_PREFIX "__bpf_iter__"
+
 typedef int (*bpf_iter_init_seq_priv_t)(void *private_data);
 typedef void (*bpf_iter_fini_seq_priv_t)(void *private_data);
=20
@@ -1139,6 +1141,7 @@ struct bpf_iter_reg {
 };
=20
 int bpf_iter_reg_target(struct bpf_iter_reg *reg_info);
+bool bpf_iter_prog_supported(struct bpf_prog *prog);
=20
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b3643e27e264..047b19fe716e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -218,6 +218,7 @@ enum bpf_attach_type {
 	BPF_TRACE_FEXIT,
 	BPF_MODIFY_RETURN,
 	BPF_LSM_MAC,
+	BPF_TRACE_ITER,
 	__MAX_BPF_ATTACH_TYPE
 };
=20
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index ed930a0470e9..c1fae67a1452 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -12,6 +12,7 @@ struct bpf_iter_target_info {
 	bpf_iter_init_seq_priv_t init_seq_private;
 	bpf_iter_fini_seq_priv_t fini_seq_private;
 	u32 seq_priv_size;
+	u32 btf_id;
 };
=20
 static struct list_head targets =3D LIST_HEAD_INIT(targets);
@@ -38,3 +39,32 @@ int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
=20
 	return 0;
 }
+
+bool bpf_iter_prog_supported(struct bpf_prog *prog)
+{
+	const char *attach_fname =3D prog->aux->attach_func_name;
+	u32 prog_btf_id =3D prog->aux->attach_btf_id;
+	const char *prefix =3D BPF_ITER_FUNC_PREFIX;
+	struct bpf_iter_target_info *tinfo;
+	int prefix_len =3D strlen(prefix);
+	bool supported =3D false;
+
+	if (strncmp(attach_fname, prefix, prefix_len))
+		return false;
+
+	mutex_lock(&targets_mutex);
+	list_for_each_entry(tinfo, &targets, list) {
+		if (tinfo->btf_id && tinfo->btf_id =3D=3D prog_btf_id) {
+			supported =3D true;
+			break;
+		}
+		if (!strcmp(attach_fname + prefix_len, tinfo->target)) {
+			tinfo->btf_id =3D prog->aux->attach_btf_id;
+			supported =3D true;
+			break;
+		}
+	}
+	mutex_unlock(&targets_mutex);
+
+	return supported;
+}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 70ad009577f8..d725ff7d11db 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7101,6 +7101,10 @@ static int check_return_code(struct bpf_verifier_e=
nv *env)
 			return 0;
 		range =3D tnum_const(0);
 		break;
+	case BPF_PROG_TYPE_TRACING:
+		if (env->prog->expected_attach_type !=3D BPF_TRACE_ITER)
+			return 0;
+		break;
 	default:
 		return 0;
 	}
@@ -10481,6 +10485,7 @@ static int check_attach_btf_id(struct bpf_verifie=
r_env *env)
 	struct bpf_prog *tgt_prog =3D prog->aux->linked_prog;
 	u32 btf_id =3D prog->aux->attach_btf_id;
 	const char prefix[] =3D "btf_trace_";
+	struct btf_func_model fmodel;
 	int ret =3D 0, subprog =3D -1, i;
 	struct bpf_trampoline *tr;
 	const struct btf_type *t;
@@ -10622,6 +10627,22 @@ static int check_attach_btf_id(struct bpf_verifi=
er_env *env)
 		prog->aux->attach_func_proto =3D t;
 		prog->aux->attach_btf_trace =3D true;
 		return 0;
+	case BPF_TRACE_ITER:
+		if (!btf_type_is_func(t)) {
+			verbose(env, "attach_btf_id %u is not a function\n",
+				btf_id);
+			return -EINVAL;
+		}
+		t =3D btf_type_by_id(btf, t->type);
+		if (!btf_type_is_func_proto(t))
+			return -EINVAL;
+		prog->aux->attach_func_name =3D tname;
+		prog->aux->attach_func_proto =3D t;
+		if (!bpf_iter_prog_supported(prog))
+			return -EINVAL;
+		ret =3D btf_distill_func_proto(&env->log, btf, t,
+					     tname, &fmodel);
+		return ret;
 	default:
 		if (!prog_extension)
 			return -EINVAL;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index b3643e27e264..047b19fe716e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -218,6 +218,7 @@ enum bpf_attach_type {
 	BPF_TRACE_FEXIT,
 	BPF_MODIFY_RETURN,
 	BPF_LSM_MAC,
+	BPF_TRACE_ITER,
 	__MAX_BPF_ATTACH_TYPE
 };
=20
--=20
2.24.1

