Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9E9C1A2C38
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 01:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgDHXZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 19:25:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57022 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726598AbgDHXZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 19:25:37 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 038NJf2c022975
        for <netdev@vger.kernel.org>; Wed, 8 Apr 2020 16:25:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=llWU84pQOOcFmGzSZOkQo3IKl60pkdXc8PkCSGbDJRk=;
 b=IuEy3TQVFsVw8efU1zSbqImoDUUjdAMFL/jiRZ8kEplGm7RC0/HMkHZOKlt/v3sgVOWm
 CIl7thLxgv0OymWJgD8hBqQdfil1NwdXKrCZlsErttVyasf+NH6+eyHYpfQzU7+EKaRm
 37VflsYZxLZCVMUiISEnXYWuJFlu7ZZhbZI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3091tmy095-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 16:25:36 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 8 Apr 2020 16:25:35 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id A4CAF3700D98; Wed,  8 Apr 2020 16:25:33 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 11/16] bpf: implement query for target_proto and file dumper prog_id
Date:   Wed, 8 Apr 2020 16:25:33 -0700
Message-ID: <20200408232533.2676305-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200408232520.2675265-1-yhs@fb.com>
References: <20200408232520.2675265-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-08_09:2020-04-07,2020-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 spamscore=0 bulkscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080163
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
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       | 13 +++++++++
 kernel/bpf/dump.c              | 51 ++++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c           | 14 ++++++++++
 tools/include/uapi/linux/bpf.h | 13 +++++++++
 5 files changed, 92 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f7d4269d77b8..c9aec3b02dfa 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1120,6 +1120,7 @@ int bpf_dump_create(u32 prog_fd, const char __user =
*dumper_name);
 struct bpf_prog *bpf_dump_get_prog(struct seq_file *seq, u32 priv_data_s=
ize,
 				   u64 *seq_num);
 int bpf_dump_run_prog(struct bpf_prog *prog, void *ctx);
+int bpf_dump_query(const union bpf_attr *attr, union bpf_attr __user *ua=
ttr);
=20
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a245f0df53c4..fc2157e319f1 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -113,6 +113,7 @@ enum bpf_cmd {
 	BPF_MAP_DELETE_BATCH,
 	BPF_LINK_CREATE,
 	BPF_LINK_UPDATE,
+	BPF_DUMP_QUERY,
 };
=20
 enum bpf_map_type {
@@ -594,6 +595,18 @@ union bpf_attr {
 		__u32		old_prog_fd;
 	} link_update;
=20
+	struct {
+		__u32		query_fd;
+		__u32		flags;
+		union {
+			struct {
+				__aligned_u64	target_proto;
+				__u32		proto_buf_len;
+			};
+			__u32			prog_id;
+		};
+	} dump_query;
+
 } __attribute__((aligned(8)));
=20
 /* The description below is an attempt at providing documentation to eBP=
F
diff --git a/kernel/bpf/dump.c b/kernel/bpf/dump.c
index 4e009b2612c2..f3041b362057 100644
--- a/kernel/bpf/dump.c
+++ b/kernel/bpf/dump.c
@@ -86,6 +86,57 @@ static void *get_extra_priv_dptr(void *old_ptr, u32 ol=
d_size)
 	return old_ptr + roundup(old_size, 8);
 }
=20
+int bpf_dump_query(const union bpf_attr *attr, union bpf_attr __user *ua=
ttr)
+{
+	struct bpfdump_target_info *tinfo;
+	struct dumper_inode_info *i_info;
+	const char *target_proto;
+	void * __user proto_buf;
+	struct file *filp;
+	u32 proto_len;
+	struct fd qfd;
+	int err =3D 0;
+
+	if (attr->dump_query.flags !=3D 0)
+		return -EINVAL;
+
+	qfd =3D fdget(attr->dump_query.query_fd);
+	filp =3D qfd.file;
+	if (!filp)
+		return -EBADF;
+
+	if (filp->f_op !=3D &bpf_dumper_ops &&
+	    filp->f_inode->i_op !=3D &bpf_dir_iops) {
+		err =3D -EINVAL;
+		goto done;
+	}
+
+	if (filp->f_op =3D=3D &bpf_dumper_ops) {
+		i_info =3D filp->f_inode->i_private;
+		if (put_user(i_info->prog->aux->id, &uattr->dump_query.prog_id))
+			err =3D -EFAULT;
+
+		goto done;
+	}
+
+	tinfo =3D filp->f_inode->i_private;
+	target_proto =3D tinfo->target_proto;
+
+	proto_len =3D strlen(target_proto) + 1;
+	if (attr->dump_query.proto_buf_len < proto_len) {
+		err =3D -ENOSPC;
+		goto done;
+	}
+
+	proto_buf =3D u64_to_user_ptr(attr->dump_query.target_proto);
+	if (copy_to_user(proto_buf, target_proto, proto_len))
+		err =3D -EFAULT;
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
index 62a872a406ca..46b58f1f2d75 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3673,6 +3673,17 @@ static int link_update(union bpf_attr *attr)
 	return ret;
 }
=20
+#define BPF_DUMP_QUERY_LAST_FIELD dump_query.proto_buf_len
+
+static int bpf_dump_do_query(const union bpf_attr *attr,
+			     union bpf_attr __user *uattr)
+{
+	if (CHECK_ATTR(BPF_DUMP_QUERY))
+		return -EINVAL;
+
+	return bpf_dump_query(attr, uattr);
+}
+
 SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned =
int, size)
 {
 	union bpf_attr attr;
@@ -3790,6 +3801,9 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __use=
r *, uattr, unsigned int, siz
 	case BPF_LINK_UPDATE:
 		err =3D link_update(&attr);
 		break;
+	case BPF_DUMP_QUERY:
+		err =3D bpf_dump_do_query(&attr, uattr);
+		break;
 	default:
 		err =3D -EINVAL;
 		break;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index a245f0df53c4..fc2157e319f1 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -113,6 +113,7 @@ enum bpf_cmd {
 	BPF_MAP_DELETE_BATCH,
 	BPF_LINK_CREATE,
 	BPF_LINK_UPDATE,
+	BPF_DUMP_QUERY,
 };
=20
 enum bpf_map_type {
@@ -594,6 +595,18 @@ union bpf_attr {
 		__u32		old_prog_fd;
 	} link_update;
=20
+	struct {
+		__u32		query_fd;
+		__u32		flags;
+		union {
+			struct {
+				__aligned_u64	target_proto;
+				__u32		proto_buf_len;
+			};
+			__u32			prog_id;
+		};
+	} dump_query;
+
 } __attribute__((aligned(8)));
=20
 /* The description below is an attempt at providing documentation to eBP=
F
--=20
2.24.1

