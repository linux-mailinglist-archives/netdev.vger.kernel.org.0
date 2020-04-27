Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D163E1BAF1D
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgD0UN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:13:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30478 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726849AbgD0UN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:13:28 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03RKBcKL003423
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:13:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Zt20xQdlfJLBte//mGUFbKnydXAnAYSLNsjyfy0EltE=;
 b=hbdzrCyq5Qao/aA+WwEGqQyNgzolLi7+K2WmvJyK+ZXl7+rg1XbyZSaTm3IQoIsySk70
 af9ME65aYII07goiqlFTU9qdBazjRbGTRmfQaLsxE8DQsND/fr673836w6V76bg90psr
 +HqvPJmzZGA7aLd2/rnmX580Q80FMJ2gcW8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30n5bx246a-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:13:27 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 13:12:41 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id E79243700871; Mon, 27 Apr 2020 13:12:37 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v1 03/19] bpf: add bpf_map iterator
Date:   Mon, 27 Apr 2020 13:12:37 -0700
Message-ID: <20200427201237.2994794-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200427201235.2994549-1-yhs@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_15:2020-04-27,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf_map iterator is implemented.
The bpf program is called at seq_ops show() and stop() functions.
bpf_iter_get_prog() will retrieve bpf program and other
parameters during seq_file object traversal. In show() function,
bpf program will traverse every valid object, and in stop()
function, bpf program will be called one more time after all
objects are traversed.

The first member of the bpf context contains the meta data, namely,
the seq_file, session_id and seq_num. Here, the session_id is
a unique id for one specific seq_file session. The seq_num is
the number of bpf prog invocations in the current session.
The bpf_iter_get_prog(), which will be implemented in subsequent
patches, will have more information on how meta data are computed.

The second member of the bpf context is a struct bpf_map pointer,
which bpf program can examine.

The target implementation also provided the structure definition
for bpf program and the function definition for verifier to
verify the bpf program. Specifically for bpf_map iterator,
the structure is "bpf_iter__bpf_map" andd the function is
"__bpf_iter__bpf_map".

More targets will be implemented later, all of which will include
the following, similar to bpf_map iterator:
  - seq_ops() implementation
  - function definition for verifier to verify the bpf program
  - seq_file private data size
  - additional target feature

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h   |  10 ++++
 kernel/bpf/Makefile   |   2 +-
 kernel/bpf/bpf_iter.c |  19 ++++++++
 kernel/bpf/map_iter.c | 107 ++++++++++++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c  |  13 +++++
 5 files changed, 150 insertions(+), 1 deletion(-)
 create mode 100644 kernel/bpf/map_iter.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5e56abc1e2f1..4ac8d61f7c3e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1078,6 +1078,7 @@ int  generic_map_update_batch(struct bpf_map *map,
 int  generic_map_delete_batch(struct bpf_map *map,
 			      const union bpf_attr *attr,
 			      union bpf_attr __user *uattr);
+struct bpf_map *bpf_map_get_curr_or_next(u32 *id);
=20
 extern int sysctl_unprivileged_bpf_disabled;
=20
@@ -1118,7 +1119,16 @@ struct bpf_iter_reg {
 	u32 target_feature;
 };
=20
+struct bpf_iter_meta {
+	__bpf_md_ptr(struct seq_file *, seq);
+	u64 session_id;
+	u64 seq_num;
+};
+
 int bpf_iter_reg_target(struct bpf_iter_reg *reg_info);
+struct bpf_prog *bpf_iter_get_prog(struct seq_file *seq, u32 priv_data_s=
ize,
+				   u64 *session_id, u64 *seq_num, bool is_last);
+int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx);
=20
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 6a8b0febd3f6..b2b5eefc5254 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -2,7 +2,7 @@
 obj-y :=3D core.o
 CFLAGS_core.o +=3D $(call cc-disable-warning, override-init)
=20
-obj-$(CONFIG_BPF_SYSCALL) +=3D syscall.o verifier.o inode.o helpers.o tn=
um.o bpf_iter.o
+obj-$(CONFIG_BPF_SYSCALL) +=3D syscall.o verifier.o inode.o helpers.o tn=
um.o bpf_iter.o map_iter.o
 obj-$(CONFIG_BPF_SYSCALL) +=3D hashtab.o arraymap.o percpu_freelist.o bp=
f_lru_list.o lpm_trie.o map_in_map.o
 obj-$(CONFIG_BPF_SYSCALL) +=3D local_storage.o queue_stack_maps.o
 obj-$(CONFIG_BPF_SYSCALL) +=3D disasm.o
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 1115b978607a..284c95587803 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -48,3 +48,22 @@ int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
=20
 	return 0;
 }
+
+struct bpf_prog *bpf_iter_get_prog(struct seq_file *seq, u32 priv_data_s=
ize,
+				   u64 *session_id, u64 *seq_num, bool is_last)
+{
+	return NULL;
+}
+
+int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx)
+{
+	int ret;
+
+	migrate_disable();
+	rcu_read_lock();
+	ret =3D BPF_PROG_RUN(prog, ctx);
+	rcu_read_unlock();
+	migrate_enable();
+
+	return ret;
+}
diff --git a/kernel/bpf/map_iter.c b/kernel/bpf/map_iter.c
new file mode 100644
index 000000000000..bb3ad4c3bde5
--- /dev/null
+++ b/kernel/bpf/map_iter.c
@@ -0,0 +1,107 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2020 Facebook */
+#include <linux/bpf.h>
+#include <linux/fs.h>
+#include <linux/filter.h>
+#include <linux/kernel.h>
+
+struct bpf_iter_seq_map_info {
+	struct bpf_map *map;
+	u32 id;
+};
+
+static void *bpf_map_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct bpf_iter_seq_map_info *info =3D seq->private;
+	struct bpf_map *map;
+	u32 id =3D info->id;
+
+	map =3D bpf_map_get_curr_or_next(&id);
+	if (IS_ERR_OR_NULL(map))
+		return NULL;
+
+	++*pos;
+	info->map =3D map;
+	info->id =3D id;
+	return map;
+}
+
+static void *bpf_map_seq_next(struct seq_file *seq, void *v, loff_t *pos=
)
+{
+	struct bpf_iter_seq_map_info *info =3D seq->private;
+	struct bpf_map *map;
+
+	++*pos;
+	++info->id;
+	map =3D bpf_map_get_curr_or_next(&info->id);
+	if (IS_ERR_OR_NULL(map))
+		return NULL;
+
+	bpf_map_put(info->map);
+	info->map =3D map;
+	return map;
+}
+
+struct bpf_iter__bpf_map {
+	__bpf_md_ptr(struct bpf_iter_meta *, meta);
+	__bpf_md_ptr(struct bpf_map *, map);
+};
+
+int __init __bpf_iter__bpf_map(struct bpf_iter_meta *meta, struct bpf_ma=
p *map)
+{
+	return 0;
+}
+
+static int bpf_map_seq_show(struct seq_file *seq, void *v)
+{
+	struct bpf_iter_meta meta;
+	struct bpf_iter__bpf_map ctx;
+	struct bpf_prog *prog;
+	int ret =3D 0;
+
+	ctx.meta =3D &meta;
+	ctx.map =3D v;
+	meta.seq =3D seq;
+	prog =3D bpf_iter_get_prog(seq, sizeof(struct bpf_iter_seq_map_info),
+				 &meta.session_id, &meta.seq_num,
+				 v =3D=3D (void *)0);
+	if (prog)
+		ret =3D bpf_iter_run_prog(prog, &ctx);
+
+	return ret =3D=3D 0 ? 0 : -EINVAL;
+}
+
+static void bpf_map_seq_stop(struct seq_file *seq, void *v)
+{
+	struct bpf_iter_seq_map_info *info =3D seq->private;
+
+	if (!v)
+		bpf_map_seq_show(seq, v);
+
+	if (info->map) {
+		bpf_map_put(info->map);
+		info->map =3D NULL;
+	}
+}
+
+static const struct seq_operations bpf_map_seq_ops =3D {
+	.start	=3D bpf_map_seq_start,
+	.next	=3D bpf_map_seq_next,
+	.stop	=3D bpf_map_seq_stop,
+	.show	=3D bpf_map_seq_show,
+};
+
+static int __init bpf_map_iter_init(void)
+{
+	struct bpf_iter_reg reg_info =3D {
+		.target			=3D "bpf_map",
+		.target_func_name	=3D "__bpf_iter__bpf_map",
+		.seq_ops		=3D &bpf_map_seq_ops,
+		.seq_priv_size		=3D sizeof(struct bpf_iter_seq_map_info),
+		.target_feature		=3D 0,
+	};
+
+	return bpf_iter_reg_target(&reg_info);
+}
+
+late_initcall(bpf_map_iter_init);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 7626b8024471..022187640943 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2800,6 +2800,19 @@ static int bpf_obj_get_next_id(const union bpf_att=
r *attr,
 	return err;
 }
=20
+struct bpf_map *bpf_map_get_curr_or_next(u32 *id)
+{
+	struct bpf_map *map;
+
+	spin_lock_bh(&map_idr_lock);
+	map =3D idr_get_next(&map_idr, id);
+	if (map)
+		map =3D __bpf_map_inc_not_zero(map, false);
+	spin_unlock_bh(&map_idr_lock);
+
+	return map;
+}
+
 #define BPF_PROG_GET_FD_BY_ID_LAST_FIELD prog_id
=20
 struct bpf_prog *bpf_prog_by_id(u32 id)
--=20
2.24.1

