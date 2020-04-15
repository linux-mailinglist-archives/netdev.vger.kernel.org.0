Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B68761AB1C3
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 21:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411896AbgDOTah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 15:30:37 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37252 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2411817AbgDOT2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 15:28:23 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03FJSC9S007588
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=yd6omChVWlKDAQ+4CsV2D1kT8tOgiYp8DJQFULum+mo=;
 b=IepUGivxnqarnUXSBc7KbX2nThQ1NC5XkZgb0MchcVSWvpJ6xiXHZZ0pi9HVH5Ub9nAP
 X7R7LuQF+Z6tLZLORpnY/es6mONDmnr3m8IxMv3ANwkFRWfgDshrSzjU+o3drOov85+o
 gaBG62Dt+3B8mPj3G06N1Y496SX1qA+6QBA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 30dn7fymmh-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:20 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 15 Apr 2020 12:28:06 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 607433700AF5; Wed, 15 Apr 2020 12:27:54 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next v2 12/17] bpf: implement query for target_proto and file dumper prog_id
Date:   Wed, 15 Apr 2020 12:27:54 -0700
Message-ID: <20200415192754.4083756-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200415192740.4082659-1-yhs@fb.com>
References: <20200415192740.4082659-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-15_07:2020-04-14,2020-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=4 phishscore=0 mlxscore=0 spamscore=0 adultscore=0
 impostorscore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004150144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given a fd representing a bpfdump target, user
can retrieve the target_proto name which represents
the bpf program prototype.

Given a fd representing a file dumper, user can
retrieve the bpf_prog id associated with that dumper.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h            |  2 +
 include/uapi/linux/bpf.h       | 11 +++++-
 kernel/bpf/dump.c              | 72 ++++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c           |  2 +-
 tools/include/uapi/linux/bpf.h | 11 +++++-
 5 files changed, 95 insertions(+), 3 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 401e5bf921a2..a1ae8509e735 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1138,6 +1138,8 @@ int bpf_prog_dump_create(struct bpf_prog *prog);
 struct bpf_prog *bpf_dump_get_prog(struct seq_file *seq, u32 priv_data_s=
ize,
 				   u64 *session_id, u64 *seq_num, bool is_last);
 int bpf_dump_run_prog(struct bpf_prog *prog, void *ctx);
+int bpf_dump_query(const union bpf_attr *attr, union bpf_attr __user *ua=
ttr);
+
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_hash_update(struct bpf_map *map, void *key, void *value,
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 75f3657d526c..856e3f8a63b8 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -533,7 +533,10 @@ union bpf_attr {
 	};
=20
 	struct { /* anonymous struct used by BPF_OBJ_GET_INFO_BY_FD */
-		__u32		bpf_fd;
+		union {
+			__u32		bpf_fd;
+			__u32		dump_query_fd;
+		};
 		__u32		info_len;
 		__aligned_u64	info;
 	} info;
@@ -3618,6 +3621,12 @@ struct bpf_btf_info {
 	__u32 id;
 } __attribute__((aligned(8)));
=20
+struct bpf_dump_info {
+	__aligned_u64 prog_ctx_type_name;
+	__u32 type_name_buf_len;
+	__u32 prog_id;
+} __attribute__((aligned(8)));
+
 /* User bpf_sock_addr struct to access socket fields and sockaddr struct=
 passed
  * by user and intended to be used by socket (e.g. to bind to, depends o=
n
  * attach attach type).
diff --git a/kernel/bpf/dump.c b/kernel/bpf/dump.c
index 789b35772a81..643591bf5aea 100644
--- a/kernel/bpf/dump.c
+++ b/kernel/bpf/dump.c
@@ -93,6 +93,78 @@ static void *get_extra_priv_dptr(void *old_ptr, u32 ol=
d_size)
 	return old_ptr + roundup(old_size, 8);
 }
=20
+int bpf_dump_query(const union bpf_attr *attr, union bpf_attr __user *ua=
ttr)
+{
+	struct bpf_dump_info __user *ubpf_dinfo;
+	struct bpfdump_target_info *tinfo;
+	struct dumper_inode_info *i_info;
+	struct bpf_dump_info bpf_dinfo;
+	const char *prog_ctx_type_name;
+	void * __user tname_buf;
+	u32 tname_len, info_len;
+	struct file *filp;
+	struct fd qfd;
+	int err =3D 0;
+
+	qfd =3D fdget(attr->info.dump_query_fd);
+	filp =3D qfd.file;
+	if (!filp)
+		return -EBADF;
+
+	if (filp->f_op !=3D &bpf_dumper_ops &&
+	    filp->f_inode->i_op !=3D &bpfdump_dir_iops) {
+		err =3D -EINVAL;
+		goto done;
+	}
+
+	info_len =3D attr->info.info_len;
+	ubpf_dinfo =3D u64_to_user_ptr(attr->info.info);
+	err =3D bpf_check_uarg_tail_zero(ubpf_dinfo, sizeof(bpf_dinfo),
+				       info_len);
+	if (err)
+		goto done;
+	info_len =3D min_t(u32, sizeof(bpf_dinfo), info_len);
+
+	memset(&bpf_dinfo, 0, sizeof(bpf_dinfo));
+	if (copy_from_user(&bpf_dinfo, ubpf_dinfo, info_len)) {
+		err =3D -EFAULT;
+		goto done;
+	}
+
+	/* copy prog_id for dumpers */
+	if (filp->f_op =3D=3D &bpf_dumper_ops) {
+		i_info =3D filp->f_inode->i_private;
+		bpf_dinfo.prog_id =3D i_info->prog->aux->id;
+		tinfo =3D i_info->tinfo;
+	} else {
+		tinfo =3D filp->f_inode->i_private;
+	}
+
+	prog_ctx_type_name =3D tinfo->prog_ctx_type_name;
+
+	tname_len =3D strlen(prog_ctx_type_name) + 1;
+	if (bpf_dinfo.type_name_buf_len < tname_len) {
+		err =3D -ENOSPC;
+		goto done;
+	}
+
+	/* copy prog_ctx_type_name */
+	tname_buf =3D u64_to_user_ptr(bpf_dinfo.prog_ctx_type_name);
+	if (copy_to_user(tname_buf, prog_ctx_type_name, tname_len)) {
+		err =3D -EFAULT;
+		goto done;
+	}
+
+	/* copy potentially updated bpf_dinfo and info_len */
+	if (copy_to_user(ubpf_dinfo, &bpf_dinfo, info_len) ||
+	    put_user(info_len, &uattr->info.info_len))
+		return -EFAULT;
+
+done:
+	fdput(qfd);
+	return err;
+}
+
 #ifdef CONFIG_PROC_FS
 static void dumper_show_fdinfo(struct seq_file *m, struct file *filp)
 {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e6a4514435c4..1cde78e53a17 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3358,7 +3358,7 @@ static int bpf_obj_get_info_by_fd(const union bpf_a=
ttr *attr,
 	else if (f.file->f_op =3D=3D &btf_fops)
 		err =3D bpf_btf_get_info_by_fd(f.file->private_data, attr, uattr);
 	else
-		err =3D -EINVAL;
+		err =3D bpf_dump_query(attr, uattr);
=20
 	fdput(f);
 	return err;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 75f3657d526c..856e3f8a63b8 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -533,7 +533,10 @@ union bpf_attr {
 	};
=20
 	struct { /* anonymous struct used by BPF_OBJ_GET_INFO_BY_FD */
-		__u32		bpf_fd;
+		union {
+			__u32		bpf_fd;
+			__u32		dump_query_fd;
+		};
 		__u32		info_len;
 		__aligned_u64	info;
 	} info;
@@ -3618,6 +3621,12 @@ struct bpf_btf_info {
 	__u32 id;
 } __attribute__((aligned(8)));
=20
+struct bpf_dump_info {
+	__aligned_u64 prog_ctx_type_name;
+	__u32 type_name_buf_len;
+	__u32 prog_id;
+} __attribute__((aligned(8)));
+
 /* User bpf_sock_addr struct to access socket fields and sockaddr struct=
 passed
  * by user and intended to be used by socket (e.g. to bind to, depends o=
n
  * attach attach type).
--=20
2.24.1

