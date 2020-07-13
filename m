Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C666121DB88
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730287AbgGMQSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:18:13 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34014 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730240AbgGMQR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:17:58 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06DFx6BB004753
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:17:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=eFH4Iu6fEkWS/1CG+Xz79eBAsXBCuFN2ohUskFRkw6k=;
 b=U1jUwIysvXvVaYOlth/97S4qblamON9YzT2MM2N31Qs+nf2/nMJ2MEugLWL6QKtuaQ5G
 TtZDWDJzUd0YwwCRhYQ+KCoQTpVcnSSniWo0NgmG8p/PxcH7Y3gUX6Pxkk2WTttLNH8A
 Z+n3DI/rCA58/b4bTnfmiOjWC1gJuWA+S1g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 327b8hrbkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:17:57 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 13 Jul 2020 09:17:56 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 7C54A3702065; Mon, 13 Jul 2020 09:17:47 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 07/13] bpf: implement bpf iterator for sock local storage map
Date:   Mon, 13 Jul 2020 09:17:47 -0700
Message-ID: <20200713161747.3077347-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200713161739.3076283-1-yhs@fb.com>
References: <20200713161739.3076283-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-13_15:2020-07-13,2020-07-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=9
 mlxlogscore=712 phishscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 spamscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007130119
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
 net/core/bpf_sk_storage.c | 203 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 203 insertions(+)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 6f921c4ddc2c..95638eca5d67 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -1217,3 +1217,206 @@ int bpf_sk_storage_diag_put(struct bpf_sk_storage=
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
+	if (prog->aux->max_rdonly_access[0] > map->value_size)
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
+static const struct bpf_iter_reg bpf_sk_storage_map_reg_info =3D {
+	.target			=3D "bpf_sk_storage_map",
+	.check_target		=3D bpf_iter_check_map,
+	.link_info		=3D BPF_ITER_LINK_MAP_FD,
+	.ctx_arg_info_size	=3D 2,
+	.ctx_arg_info		=3D {
+		{ offsetof(struct bpf_iter__bpf_sk_storage_map, sk),
+		  PTR_TO_BTF_ID_OR_NULL },
+		{ offsetof(struct bpf_iter__bpf_sk_storage_map, value),
+		  PTR_TO_RDONLY_BUF_OR_NULL },
+	},
+	.seq_info		=3D &iter_seq_info,
+};
+
+static int __init bpf_sk_storage_map_iter_init(void)
+{
+	return bpf_iter_reg_target(&bpf_sk_storage_map_reg_info);
+}
+late_initcall(bpf_sk_storage_map_iter_init);
--=20
2.24.1

