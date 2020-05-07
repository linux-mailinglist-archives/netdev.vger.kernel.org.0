Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0A01C81BE
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 07:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgEGFkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 01:40:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58790 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726860AbgEGFjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 01:39:51 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0475dkg9007953
        for <netdev@vger.kernel.org>; Wed, 6 May 2020 22:39:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=N9vwbuBy18Cgc2aH5He7mmxPGSZIesdfelx4Lla6la0=;
 b=AZUMzGhUdFd5DDhHuvvAjzq59MGxEc6kh9FA5SMe7lCR9vKX1JO1yFH6R2WfnLEqUW/m
 TgXrUjwOPsBX2BZD8lSqwA36PAlS0e7/gmQFRdTQFrdfRYIQQ0ZSZ4hbhUEGPHfSiEN1
 8TtEZtnahqfvWUaUlQUeNu+IU/Qx0NDp/K0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30v0hp3gw4-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 22:39:50 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 6 May 2020 22:39:23 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 1496F3701B99; Wed,  6 May 2020 22:39:23 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v3 07/21] bpf: create file bpf iterator
Date:   Wed, 6 May 2020 22:39:23 -0700
Message-ID: <20200507053923.1543044-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200507053915.1542140-1-yhs@fb.com>
References: <20200507053915.1542140-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-07_02:2020-05-05,2020-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 mlxscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 phishscore=0 spamscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=959 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070044
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To produce a file bpf iterator, the fd must be
corresponding to a link_fd assocciated with a
trace/iter program. When the pinned file is
opened, a seq_file will be generated.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h   |  2 ++
 kernel/bpf/bpf_iter.c | 17 ++++++++++++++++-
 kernel/bpf/inode.c    |  5 ++++-
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 80b1b9d8a638..b06653ab3476 100644
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
@@ -1145,6 +1146,7 @@ void bpf_iter_unreg_target(const char *target);
 bool bpf_iter_prog_supported(struct bpf_prog *prog);
 int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *pr=
og);
 int bpf_iter_new_fd(struct bpf_link *link);
+bool bpf_link_is_iter(struct bpf_link *link);
=20
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 917df4c69966..b0b8726c08f8 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -39,6 +39,8 @@ static DEFINE_MUTEX(link_mutex);
 /* incremented on every opened seq_file */
 static atomic64_t session_id;
=20
+static int prepare_seq_file(struct file *file, struct bpf_iter_link *lin=
k);
+
 /* bpf_seq_read, a customized and simpler version for bpf iterator.
  * no_llseek is assumed for this file.
  * The following are differences from seq_read():
@@ -157,6 +159,13 @@ static ssize_t bpf_seq_read(struct file *file, char =
__user *buf, size_t size,
 	return copied;
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
@@ -178,7 +187,8 @@ static int iter_release(struct inode *inode, struct f=
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
@@ -305,6 +315,11 @@ static const struct bpf_link_ops bpf_iter_link_lops =
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

