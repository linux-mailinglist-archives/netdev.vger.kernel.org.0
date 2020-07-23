Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26B322A8BB
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 08:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgGWGPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 02:15:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46248 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726177AbgGWGPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 02:15:50 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06N6FnGG008712
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 23:15:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ghRWIAEEw73tVwkF1awAhejj2FU2wOb03HNXuz0VqSA=;
 b=HJAEMTXtnqt8hA2mBLuck/4DhJ/gxLLVr6LZ54eD506LGoBu2aECUVCybWW4loW2QXGs
 dH/MDJS02G534rMtzOgMS5CnP65YP3wW4BNojgpaQskJxDhSUk2fBIm23tiS1O16Z9/h
 JTMvuBAyjQuIdFhZhG8lJ66rNNo6FXzihQw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32eg0bdn76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 23:15:49 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 22 Jul 2020 23:15:45 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 7C9643705266; Wed, 22 Jul 2020 23:15:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v3 07/13] bpf: implement bpf iterator for sock local storage map
Date:   Wed, 22 Jul 2020 23:15:41 -0700
Message-ID: <20200723061541.2100360-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200723061533.2099842-1-yhs@fb.com>
References: <20200723061533.2099842-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-23_02:2020-07-22,2020-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=691
 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=9 clxscore=1015
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007230050
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf iterator for bpf sock local storage map
is implemented. User space interacts with sock
local storage map with fd as a key and storage value.
In kernel, passing fd to the bpf program does not
really make sense. In this case, the sock itself is
passed to bpf program.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 net/core/bpf_sk_storage.c | 206 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 206 insertions(+)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 6f921c4ddc2c..eafcd15e7dfd 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 #include <linux/spinlock.h>
 #include <linux/bpf.h>
+#include <linux/btf_ids.h>
 #include <net/bpf_sk_storage.h>
 #include <net/sock.h>
 #include <uapi/linux/sock_diag.h>
@@ -1217,3 +1218,208 @@ int bpf_sk_storage_diag_put(struct bpf_sk_storage=
_diag *diag,
 	return err;
 }
 EXPORT_SYMBOL_GPL(bpf_sk_storage_diag_put);
+
+struct bpf_iter_seq_sk_storage_map_info {
+	struct bpf_map *map;
+	unsigned int bucket_id;
+	unsigned skip_elems;
+};
+
+static struct bpf_sk_storage_elem *
+bpf_sk_storage_map_seq_find_next(struct bpf_iter_seq_sk_storage_map_info=
 *info,
+				 struct bpf_sk_storage_elem *prev_selem)
+{
+	struct bpf_sk_storage *sk_storage;
+	struct bpf_sk_storage_elem *selem;
+	u32 skip_elems =3D info->skip_elems;
+	struct bpf_sk_storage_map *smap;
+	u32 bucket_id =3D info->bucket_id;
+	u32 i, count, n_buckets;
+	struct bucket *b;
+
+	smap =3D (struct bpf_sk_storage_map *)info->map;
+	n_buckets =3D 1U << smap->bucket_log;
+	if (bucket_id >=3D n_buckets)
+		return NULL;
+
+	/* try to find next selem in the same bucket */
+	selem =3D prev_selem;
+	count =3D 0;
+	while (selem) {
+		selem =3D hlist_entry_safe(selem->map_node.next,
+					 struct bpf_sk_storage_elem, map_node);
+		if (!selem) {
+			/* not found, unlock and go to the next bucket */
+			b =3D &smap->buckets[bucket_id++];
+			raw_spin_unlock_bh(&b->lock);
+			skip_elems =3D 0;
+			break;
+		}
+		sk_storage =3D rcu_dereference_raw(selem->sk_storage);
+		if (sk_storage) {
+			info->skip_elems =3D skip_elems + count;
+			return selem;
+		}
+		count++;
+	}
+
+	for (i =3D bucket_id; i < (1U << smap->bucket_log); i++) {
+		b =3D &smap->buckets[i];
+		raw_spin_lock_bh(&b->lock);
+		count =3D 0;
+		hlist_for_each_entry(selem, &b->list, map_node) {
+			sk_storage =3D rcu_dereference_raw(selem->sk_storage);
+			if (sk_storage && count >=3D skip_elems) {
+				info->bucket_id =3D i;
+				info->skip_elems =3D count;
+				return selem;
+			}
+			count++;
+		}
+		raw_spin_unlock_bh(&b->lock);
+		skip_elems =3D 0;
+	}
+
+	info->bucket_id =3D i;
+	info->skip_elems =3D 0;
+	return NULL;
+}
+
+static void *bpf_sk_storage_map_seq_start(struct seq_file *seq, loff_t *=
pos)
+{
+	struct bpf_sk_storage_elem *selem;
+
+	selem =3D bpf_sk_storage_map_seq_find_next(seq->private, NULL);
+	if (!selem)
+		return NULL;
+
+	if (*pos =3D=3D 0)
+		++*pos;
+	return selem;
+}
+
+static void *bpf_sk_storage_map_seq_next(struct seq_file *seq, void *v,
+					 loff_t *pos)
+{
+	struct bpf_iter_seq_sk_storage_map_info *info =3D seq->private;
+
+	++*pos;
+	++info->skip_elems;
+	return bpf_sk_storage_map_seq_find_next(seq->private, v);
+}
+
+struct bpf_iter__bpf_sk_storage_map {
+	__bpf_md_ptr(struct bpf_iter_meta *, meta);
+	__bpf_md_ptr(struct bpf_map *, map);
+	__bpf_md_ptr(struct sock *, sk);
+	__bpf_md_ptr(void *, value);
+};
+
+DEFINE_BPF_ITER_FUNC(bpf_sk_storage_map, struct bpf_iter_meta *meta,
+		     struct bpf_map *map, struct sock *sk,
+		     void *value)
+
+static int __bpf_sk_storage_map_seq_show(struct seq_file *seq,
+					 struct bpf_sk_storage_elem *selem)
+{
+	struct bpf_iter_seq_sk_storage_map_info *info =3D seq->private;
+	struct bpf_iter__bpf_sk_storage_map ctx =3D {};
+	struct bpf_sk_storage *sk_storage;
+	struct bpf_iter_meta meta;
+	struct bpf_prog *prog;
+	int ret =3D 0;
+
+	meta.seq =3D seq;
+	prog =3D bpf_iter_get_info(&meta, selem =3D=3D NULL);
+	if (prog) {
+		ctx.meta =3D &meta;
+		ctx.map =3D info->map;
+		if (selem) {
+			sk_storage =3D rcu_dereference_raw(selem->sk_storage);
+			ctx.sk =3D sk_storage->sk;
+			ctx.value =3D SDATA(selem)->data;
+		}
+		ret =3D bpf_iter_run_prog(prog, &ctx);
+	}
+
+	return ret;
+}
+
+static int bpf_sk_storage_map_seq_show(struct seq_file *seq, void *v)
+{
+	return __bpf_sk_storage_map_seq_show(seq, v);
+}
+
+static void bpf_sk_storage_map_seq_stop(struct seq_file *seq, void *v)
+{
+	struct bpf_iter_seq_sk_storage_map_info *info =3D seq->private;
+	struct bpf_sk_storage_map *smap;
+	struct bucket *b;
+
+	if (!v) {
+		(void)__bpf_sk_storage_map_seq_show(seq, v);
+	} else {
+		smap =3D (struct bpf_sk_storage_map *)info->map;
+		b =3D &smap->buckets[info->bucket_id];
+		raw_spin_unlock_bh(&b->lock);
+	}
+}
+
+static int bpf_iter_init_sk_storage_map(void *priv_data,
+					struct bpf_iter_aux_info *aux)
+{
+	struct bpf_iter_seq_sk_storage_map_info *seq_info =3D priv_data;
+
+	seq_info->map =3D aux->map;
+	return 0;
+}
+
+static int bpf_iter_check_map(struct bpf_prog *prog,
+			      struct bpf_iter_aux_info *aux)
+{
+	struct bpf_map *map =3D aux->map;
+
+	if (map->map_type !=3D BPF_MAP_TYPE_SK_STORAGE)
+		return -EINVAL;
+
+	if (prog->aux->max_rdonly_access > map->value_size)
+		return -EACCES;
+
+	return 0;
+}
+
+static const struct seq_operations bpf_sk_storage_map_seq_ops =3D {
+	.start  =3D bpf_sk_storage_map_seq_start,
+	.next   =3D bpf_sk_storage_map_seq_next,
+	.stop   =3D bpf_sk_storage_map_seq_stop,
+	.show   =3D bpf_sk_storage_map_seq_show,
+};
+
+static const struct bpf_iter_seq_info iter_seq_info =3D {
+	.seq_ops		=3D &bpf_sk_storage_map_seq_ops,
+	.init_seq_private	=3D bpf_iter_init_sk_storage_map,
+	.fini_seq_private	=3D NULL,
+	.seq_priv_size		=3D sizeof(struct bpf_iter_seq_sk_storage_map_info),
+};
+
+static struct bpf_iter_reg bpf_sk_storage_map_reg_info =3D {
+	.target			=3D "bpf_sk_storage_map",
+	.check_target		=3D bpf_iter_check_map,
+	.req_linfo		=3D BPF_ITER_LINK_MAP_FD,
+	.ctx_arg_info_size	=3D 2,
+	.ctx_arg_info		=3D {
+		{ offsetof(struct bpf_iter__bpf_sk_storage_map, sk),
+		  PTR_TO_BTF_ID_OR_NULL },
+		{ offsetof(struct bpf_iter__bpf_sk_storage_map, value),
+		  PTR_TO_RDWR_BUF_OR_NULL },
+	},
+	.seq_info		=3D &iter_seq_info,
+};
+
+static int __init bpf_sk_storage_map_iter_init(void)
+{
+	bpf_sk_storage_map_reg_info.ctx_arg_info[0].btf_id =3D
+		btf_sock_ids[BTF_SOCK_TYPE_SOCK];
+	return bpf_iter_reg_target(&bpf_sk_storage_map_reg_info);
+}
+late_initcall(bpf_sk_storage_map_iter_init);
--=20
2.24.1

