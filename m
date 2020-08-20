Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E56924ABD8
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 02:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbgHTANz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 20:13:55 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12740 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727034AbgHTANb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 20:13:31 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07K0DTUq031578
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 17:13:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=R7+iagKH/ujEk3wpyWZt8qRXFk7hx29qjMJYKXlBbvw=;
 b=e7dHGikO7/WWD/OC6WrDnC5jjgQo8LFJ69h3rIVYQiwHkavZ70imI2+IZUV9Y/QZmG1P
 nKISCp3fkSa+d/c8dd2KdbB11yf+uWArk9sqWXD69HB2MBZIa17vAZ/1EgsuFdnPnv+r
 7uHcO9/lJijRY6wZW7v9/5oetTAqu3lnZ7c= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 331crb8d9p-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 17:13:30 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 17:13:25 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 845DD3705675; Wed, 19 Aug 2020 17:13:23 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/3] bpf: implement link_query for bpf iterators
Date:   Wed, 19 Aug 2020 17:13:23 -0700
Message-ID: <20200820001323.3740936-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200820001323.3740798-1-yhs@fb.com>
References: <20200820001323.3740798-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_13:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 mlxlogscore=939 spamscore=0
 clxscore=1015 bulkscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implemented bpf_link callback functions
show_fdinfo and fill_link_info to support link_query
interface.

The general interface for show_fdinfo and fill_link_info
will print/fill the target_name. Each targets can
register show_fdinfo and fill_link_info callbacks
to print/fill more target specific information.

For example, the below is a fdinfo result for a bpf
task iterator.
  $ cat /proc/1749/fdinfo/7
  pos:    0
  flags:  02000000
  mnt_id: 14
  link_type:      iter
  link_id:        11
  prog_tag:       990e1f8152f7e54f
  prog_id:        59
  target_name:    task

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h            |  6 ++++
 include/uapi/linux/bpf.h       |  7 ++++
 kernel/bpf/bpf_iter.c          | 58 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  7 ++++
 4 files changed, 78 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 55f694b63164..66cd0fb8d70f 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1218,12 +1218,18 @@ typedef int (*bpf_iter_attach_target_t)(struct bp=
f_prog *prog,
 					union bpf_iter_link_info *linfo,
 					struct bpf_iter_aux_info *aux);
 typedef void (*bpf_iter_detach_target_t)(struct bpf_iter_aux_info *aux);
+typedef void (*bpf_iter_show_fdinfo_t) (const struct bpf_iter_aux_info *=
aux,
+					struct seq_file *seq);
+typedef int (*bpf_iter_fill_link_info_t)(const struct bpf_iter_aux_info =
*aux,
+					 struct bpf_link_info *info);
=20
 #define BPF_ITER_CTX_ARG_MAX 2
 struct bpf_iter_reg {
 	const char *target;
 	bpf_iter_attach_target_t attach_target;
 	bpf_iter_detach_target_t detach_target;
+	bpf_iter_show_fdinfo_t show_fdinfo;
+	bpf_iter_fill_link_info_t fill_link_info;
 	u32 ctx_arg_info_size;
 	struct bpf_ctx_arg_aux ctx_arg_info[BPF_ITER_CTX_ARG_MAX];
 	const struct bpf_iter_seq_info *seq_info;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 0480f893facd..a1bbaff7a0af 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4071,6 +4071,13 @@ struct bpf_link_info {
 			__u64 cgroup_id;
 			__u32 attach_type;
 		} cgroup;
+		struct {
+			__aligned_u64 target_name; /* in/out: target_name buffer ptr */
+			__u32 target_name_len;	   /* in/out: target_name buffer len */
+			union {
+				__u32 map_id;
+			} map;
+		} iter;
 		struct  {
 			__u32 netns_ino;
 			__u32 attach_type;
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index b6715964b685..adbffade91cd 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -377,10 +377,68 @@ static int bpf_iter_link_replace(struct bpf_link *l=
ink,
 	return ret;
 }
=20
+static void bpf_iter_link_show_fdinfo(const struct bpf_link *link,
+				      struct seq_file *seq)
+{
+	struct bpf_iter_link *iter_link =3D
+		container_of(link, struct bpf_iter_link, link);
+	bpf_iter_show_fdinfo_t show_fdinfo;
+
+	seq_printf(seq,
+		   "target_name:\t%s\n",
+		   iter_link->tinfo->reg_info->target);
+
+	show_fdinfo =3D iter_link->tinfo->reg_info->show_fdinfo;
+	if (show_fdinfo)
+		show_fdinfo(&iter_link->aux, seq);
+}
+
+static int bpf_iter_link_fill_link_info(const struct bpf_link *link,
+					struct bpf_link_info *info)
+{
+	struct bpf_iter_link *iter_link =3D
+		container_of(link, struct bpf_iter_link, link);
+	char __user *ubuf =3D u64_to_user_ptr(info->iter.target_name);
+	bpf_iter_fill_link_info_t fill_link_info;
+	u32 ulen =3D info->iter.target_name_len;
+	const char *target_name;
+	u32 target_len;
+
+	if (ulen && !ubuf)
+		return -EINVAL;
+
+	target_name =3D iter_link->tinfo->reg_info->target;
+	target_len =3D  strlen(target_name);
+	info->iter.target_name_len =3D target_len + 1;
+	if (!ubuf)
+		return 0;
+
+	if (ulen >=3D target_len + 1) {
+		if (copy_to_user(ubuf, target_name, target_len + 1))
+			return -EFAULT;
+	} else {
+		char zero =3D '\0';
+
+		if (copy_to_user(ubuf, target_name, ulen - 1))
+			return -EFAULT;
+		if (put_user(zero, ubuf + ulen - 1))
+			return -EFAULT;
+		return -ENOSPC;
+	}
+
+	fill_link_info =3D iter_link->tinfo->reg_info->fill_link_info;
+	if (fill_link_info)
+		return fill_link_info(&iter_link->aux, info);
+
+        return 0;
+}
+
 static const struct bpf_link_ops bpf_iter_link_lops =3D {
 	.release =3D bpf_iter_link_release,
 	.dealloc =3D bpf_iter_link_dealloc,
 	.update_prog =3D bpf_iter_link_replace,
+	.show_fdinfo =3D bpf_iter_link_show_fdinfo,
+	.fill_link_info =3D bpf_iter_link_fill_link_info,
 };
=20
 bool bpf_link_is_iter(struct bpf_link *link)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 0480f893facd..a1bbaff7a0af 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4071,6 +4071,13 @@ struct bpf_link_info {
 			__u64 cgroup_id;
 			__u32 attach_type;
 		} cgroup;
+		struct {
+			__aligned_u64 target_name; /* in/out: target_name buffer ptr */
+			__u32 target_name_len;	   /* in/out: target_name buffer len */
+			union {
+				__u32 map_id;
+			} map;
+		} iter;
 		struct  {
 			__u32 netns_ino;
 			__u32 attach_type;
--=20
2.24.1

