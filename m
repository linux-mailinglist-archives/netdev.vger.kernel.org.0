Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB9D1C32C5
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 08:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgEDG0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 02:26:03 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33290 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727822AbgEDGZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 02:25:58 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0446ORVO015653
        for <netdev@vger.kernel.org>; Sun, 3 May 2020 23:25:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=yekViGAMl9ig5D/9YjXrMssEWo+VghpxRRZ4nA9+Xv8=;
 b=Y7JrDcCFYOyj7NB+ROOi++ZqtPS6jNpjMUay3N02ZH4tkUsMrI0q90GX7g9pA5xsgTwR
 2D/K0cbtVJY7FXygwNjQtqHuKpKrSlMXl+Bd8V7xi5LLcDX2Yei4QiH7QMIOfoUNlajt
 KRHisN5k3RAb3IBiWCVuFaNawq9Nq10M3e4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 30s4byf1p2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 23:25:56 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sun, 3 May 2020 23:25:56 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id C01C63702037; Sun,  3 May 2020 23:25:54 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 07/20] bpf: create file bpf iterator
Date:   Sun, 3 May 2020 23:25:54 -0700
Message-ID: <20200504062554.2047969-1-yhs@fb.com>
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
 suspectscore=0 mlxlogscore=945 clxscore=1015 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040054
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To produce a file bpf iterator, the fd must be
corresponding to a link_fd assocciated with a
trace/iter program. When the pinned file is
opened, a seq_file will be generated.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h   |  2 ++
 kernel/bpf/bpf_iter.c | 17 ++++++++++++++++-
 kernel/bpf/inode.c    |  5 ++++-
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 9108d1a9b934..26daf85cba10 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1022,6 +1022,7 @@ static inline void bpf_enable_instrumentation(void)
=20
 extern const struct file_operations bpf_map_fops;
 extern const struct file_operations bpf_prog_fops;
+extern const struct file_operations bpf_iter_fops;
=20
 #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
 	extern const struct bpf_prog_ops _name ## _prog_ops; \
@@ -1144,6 +1145,7 @@ int bpf_iter_reg_target(struct bpf_iter_reg *reg_in=
fo);
 bool bpf_iter_prog_supported(struct bpf_prog *prog);
 int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *pr=
og);
 int bpf_iter_new_fd(struct bpf_link *link);
+bool bpf_link_is_iter(struct bpf_link *link);
=20
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 2a9f939be6e6..8bd787f3db6f 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -41,6 +41,8 @@ static DEFINE_MUTEX(link_mutex);
 /* incremented on every opened seq_file */
 static atomic64_t session_id;
=20
+static int prepare_seq_file(struct file *file, struct bpf_iter_link *lin=
k);
+
 /* bpf_seq_read, a customized and simpler version for bpf iterator.
  * no_llseek is assumed for this file.
  * The following are differences from seq_read():
@@ -169,6 +171,13 @@ static ssize_t bpf_seq_read(struct file *file, char =
__user *buf, size_t size,
 	goto Done;
 }
=20
+static int iter_open(struct inode *inode, struct file *file)
+{
+	struct bpf_iter_link *link =3D inode->i_private;
+
+	return prepare_seq_file(file, link);
+}
+
 static int iter_release(struct inode *inode, struct file *file)
 {
 	struct bpf_iter_priv_data *iter_priv;
@@ -188,7 +197,8 @@ static int iter_release(struct inode *inode, struct f=
ile *file)
 	return seq_release_private(inode, file);
 }
=20
-static const struct file_operations bpf_iter_fops =3D {
+const struct file_operations bpf_iter_fops =3D {
+	.open		=3D iter_open,
 	.llseek		=3D no_llseek,
 	.read		=3D bpf_seq_read,
 	.release	=3D iter_release,
@@ -290,6 +300,11 @@ static const struct bpf_link_ops bpf_iter_link_lops =
=3D {
 	.update_prog =3D bpf_iter_link_replace,
 };
=20
+bool bpf_link_is_iter(struct bpf_link *link)
+{
+	return link->ops =3D=3D &bpf_iter_link_lops;
+}
+
 int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *pr=
og)
 {
 	struct bpf_link_primer link_primer;
diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 95087d9f4ed3..fb878ba3f22f 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -358,8 +358,11 @@ static int bpf_mkmap(struct dentry *dentry, umode_t =
mode, void *arg)
=20
 static int bpf_mklink(struct dentry *dentry, umode_t mode, void *arg)
 {
+	struct bpf_link *link =3D arg;
+
 	return bpf_mkobj_ops(dentry, mode, arg, &bpf_link_iops,
-			     &bpffs_obj_fops);
+			     bpf_link_is_iter(link) ?
+			     &bpf_iter_fops : &bpffs_obj_fops);
 }
=20
 static struct dentry *
--=20
2.24.1

