Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3791CC38A
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 20:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbgEIR7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 13:59:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62720 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728592AbgEIR7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 13:59:13 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 049HuSmK026231
        for <netdev@vger.kernel.org>; Sat, 9 May 2020 10:59:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=TJFXJiiakuJUVspAT6aTlAB5fFSLYAO/nM1aUaHyJLs=;
 b=gdr8HISnm7KT2+gkpAZbUzKsymRF/8vsn/VMZ7ICe1Q+jxquqcS9qzAeOZyBjd3FBYUB
 xUx/nmSg/qBuCBgCSzBdi+qiwGRIBo71f/NVYxkYgKfrth7J/I9bPiXx/bJ3yU9glbNA
 w29m3uQUjCS0oy/mj6sNoTOO87/gl/H5Au0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30wsbq1hb3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 09 May 2020 10:59:13 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sat, 9 May 2020 10:59:11 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id E8BDC37008E2; Sat,  9 May 2020 10:59:07 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v4 08/21] bpf: implement common macros/helpers for target iterators
Date:   Sat, 9 May 2020 10:59:07 -0700
Message-ID: <20200509175907.2475956-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200509175859.2474608-1-yhs@fb.com>
References: <20200509175859.2474608-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-09_06:2020-05-08,2020-05-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0 bulkscore=0
 phishscore=0 clxscore=1015 mlxscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090155
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Macro DEFINE_BPF_ITER_FUNC is implemented so target
can define an init function to capture the BTF type
which represents the target.

The bpf_iter_meta is a structure holding meta data, common
to all targets in the bpf program.

Additional marker functions are called before or after
bpf_seq_read() show()/next()/stop() callback functions
to help calculate precise seq_num and whether call bpf_prog
inside stop().

Two functions, bpf_iter_get_info() and bpf_iter_run_prog(),
are implemented so target can get needed information from
bpf_iter infrastructure and can run the program.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h   | 11 ++++++
 kernel/bpf/bpf_iter.c | 85 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 91 insertions(+), 5 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index b06653ab3476..ffe0b9b669bf 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1129,6 +1129,9 @@ int bpf_obj_pin_user(u32 ufd, const char __user *pa=
thname);
 int bpf_obj_get_user(const char __user *pathname, int flags);
=20
 #define BPF_ITER_FUNC_PREFIX "__bpf_iter__"
+#define DEFINE_BPF_ITER_FUNC(target, args...)			\
+	extern int __bpf_iter__ ## target(args);		\
+	int __init __bpf_iter__ ## target(args) { return 0; }
=20
 typedef int (*bpf_iter_init_seq_priv_t)(void *private_data);
 typedef void (*bpf_iter_fini_seq_priv_t)(void *private_data);
@@ -1141,12 +1144,20 @@ struct bpf_iter_reg {
 	u32 seq_priv_size;
 };
=20
+struct bpf_iter_meta {
+	__bpf_md_ptr(struct seq_file *, seq);
+	u64 session_id;
+	u64 seq_num;
+};
+
 int bpf_iter_reg_target(struct bpf_iter_reg *reg_info);
 void bpf_iter_unreg_target(const char *target);
 bool bpf_iter_prog_supported(struct bpf_prog *prog);
 int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *pr=
og);
 int bpf_iter_new_fd(struct bpf_link *link);
 bool bpf_link_is_iter(struct bpf_link *link);
+struct bpf_prog *bpf_iter_get_info(struct bpf_iter_meta *meta, bool in_s=
top);
+int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx);
=20
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 090f09b0eacb..30efd15cd4a0 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -41,6 +41,33 @@ static atomic64_t session_id;
=20
 static int prepare_seq_file(struct file *file, struct bpf_iter_link *lin=
k);
=20
+static void bpf_iter_inc_seq_num(struct seq_file *seq)
+{
+	struct bpf_iter_priv_data *iter_priv;
+
+	iter_priv =3D container_of(seq->private, struct bpf_iter_priv_data,
+				 target_private);
+	iter_priv->seq_num++;
+}
+
+static void bpf_iter_dec_seq_num(struct seq_file *seq)
+{
+	struct bpf_iter_priv_data *iter_priv;
+
+	iter_priv =3D container_of(seq->private, struct bpf_iter_priv_data,
+				 target_private);
+	iter_priv->seq_num--;
+}
+
+static void bpf_iter_done_stop(struct seq_file *seq)
+{
+	struct bpf_iter_priv_data *iter_priv;
+
+	iter_priv =3D container_of(seq->private, struct bpf_iter_priv_data,
+				 target_private);
+	iter_priv->done_stop =3D true;
+}
+
 /* bpf_seq_read, a customized and simpler version for bpf iterator.
  * no_llseek is assumed for this file.
  * The following are differences from seq_read():
@@ -93,6 +120,10 @@ static ssize_t bpf_seq_read(struct file *file, char _=
_user *buf, size_t size,
=20
 	err =3D seq->op->show(seq, p);
 	if (err > 0) {
+		/* object is skipped, decrease seq_num, so next
+		 * valid object can reuse the same seq_num.
+		 */
+		bpf_iter_dec_seq_num(seq);
 		seq->count =3D 0;
 	} else if (err < 0 || seq_has_overflowed(seq)) {
 		if (!err)
@@ -117,11 +148,15 @@ static ssize_t bpf_seq_read(struct file *file, char=
 __user *buf, size_t size,
 		if (IS_ERR_OR_NULL(p))
 			break;
=20
+		/* got a valid next object, increase seq_num */
+		bpf_iter_inc_seq_num(seq);
+
 		if (seq->count >=3D size)
 			break;
=20
 		err =3D seq->op->show(seq, p);
 		if (err > 0) {
+			bpf_iter_dec_seq_num(seq);
 			seq->count =3D offs;
 		} else if (err < 0 || seq_has_overflowed(seq)) {
 			seq->count =3D offs;
@@ -138,11 +173,15 @@ static ssize_t bpf_seq_read(struct file *file, char=
 __user *buf, size_t size,
 	offs =3D seq->count;
 	/* bpf program called if !p */
 	seq->op->stop(seq, p);
-	if (!p && seq_has_overflowed(seq)) {
-		seq->count =3D offs;
-		if (offs =3D=3D 0) {
-			err =3D -E2BIG;
-			goto done;
+	if (!p) {
+		if (!seq_has_overflowed(seq)) {
+			bpf_iter_done_stop(seq);
+		} else {
+			seq->count =3D offs;
+			if (offs =3D=3D 0) {
+				err =3D -E2BIG;
+				goto done;
+			}
 		}
 	}
=20
@@ -453,3 +492,39 @@ int bpf_iter_new_fd(struct bpf_link *link)
 	put_unused_fd(fd);
 	return err;
 }
+
+struct bpf_prog *bpf_iter_get_info(struct bpf_iter_meta *meta, bool in_s=
top)
+{
+	struct bpf_iter_priv_data *iter_priv;
+	struct seq_file *seq;
+	void *seq_priv;
+
+	seq =3D meta->seq;
+	if (seq->file->f_op !=3D &bpf_iter_fops)
+		return NULL;
+
+	seq_priv =3D seq->private;
+	iter_priv =3D container_of(seq_priv, struct bpf_iter_priv_data,
+				 target_private);
+
+	if (in_stop && iter_priv->done_stop)
+		return NULL;
+
+	meta->session_id =3D iter_priv->session_id;
+	meta->seq_num =3D iter_priv->seq_num;
+
+	return iter_priv->prog;
+}
+
+int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx)
+{
+	int ret;
+
+	rcu_read_lock();
+	migrate_disable();
+	ret =3D BPF_PROG_RUN(prog, ctx);
+	migrate_enable();
+	rcu_read_unlock();
+
+	return ret =3D=3D 0 ? 0 : -EAGAIN;
+}
--=20
2.24.1

