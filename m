Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57922253AD8
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 02:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgH0AGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 20:06:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19248 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726845AbgH0AG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 20:06:29 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07R05Yuc032208
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 17:06:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Bj1FGEHaoqbiaRh/ZSXUetNzMCXqGCc22v1K92GuKZA=;
 b=Qa6ZuEW1V4JApraTk7w1bK9v4bySl69LE4d2lUQjJgXcXIlpQZsasaNKU/Kg35CmPkQ9
 7L+y9UAH9phQP5u/1c6sXcxjX25bMD/Gy+P9ACIIj7J/0omcLzIO+RGFlkac33jtbaHy
 65Rd8tdvBYsRxPxnIzCUe1LrU7tBZ4NHgUI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 335up8jbxp-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 17:06:28 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 26 Aug 2020 17:06:23 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id C3EE137052E0; Wed, 26 Aug 2020 17:06:21 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 3/5] bpf: add link_query support for newly added main_thread_only info
Date:   Wed, 26 Aug 2020 17:06:21 -0700
Message-ID: <20200827000621.2712111-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200827000618.2711826-1-yhs@fb.com>
References: <20200827000618.2711826-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-26_14:2020-08-26,2020-08-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0
 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260187
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added support for link_query for main_thread_only information
with task/task_file iterators.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/uapi/linux/bpf.h       |  5 +++++
 kernel/bpf/task_iter.c         | 17 +++++++++++++++++
 tools/include/uapi/linux/bpf.h |  5 +++++
 3 files changed, 27 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index af5c600bf673..595bdc4c9431 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4259,6 +4259,11 @@ struct bpf_link_info {
 				struct {
 					__u32 map_id;
 				} map;
+
+				struct {
+					__u32 main_thread_only:1;
+					__u32 :31;
+				} task;
 			};
 		} iter;
 		struct  {
diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index 362bf2dda63a..7636abe05f27 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -329,6 +329,19 @@ static int bpf_iter_attach_task(struct bpf_prog *pro=
g,
 	return 0;
 }
=20
+static void bpf_iter_task_show_fdinfo(const struct bpf_iter_aux_info *au=
x,
+				      struct seq_file *seq)
+{
+	seq_printf(seq, "main_thread_only:\t%u\n", aux->main_thread_only);
+}
+
+static int bpf_iter_task_fill_link_info(const struct bpf_iter_aux_info *=
aux,
+					struct bpf_link_info *info)
+{
+	info->iter.task.main_thread_only =3D aux->main_thread_only;
+	return 0;
+}
+
 BTF_ID_LIST(btf_task_file_ids)
 BTF_ID(struct, task_struct)
 BTF_ID(struct, file)
@@ -343,6 +356,8 @@ static const struct bpf_iter_seq_info task_seq_info =3D=
 {
 static struct bpf_iter_reg task_reg_info =3D {
 	.target			=3D "task",
 	.attach_target		=3D bpf_iter_attach_task,
+	.show_fdinfo		=3D bpf_iter_task_show_fdinfo,
+	.fill_link_info		=3D bpf_iter_task_fill_link_info,
 	.ctx_arg_info_size	=3D 1,
 	.ctx_arg_info		=3D {
 		{ offsetof(struct bpf_iter__task, task),
@@ -361,6 +376,8 @@ static const struct bpf_iter_seq_info task_file_seq_i=
nfo =3D {
 static struct bpf_iter_reg task_file_reg_info =3D {
 	.target			=3D "task_file",
 	.attach_target		=3D bpf_iter_attach_task,
+	.show_fdinfo		=3D bpf_iter_task_show_fdinfo,
+	.fill_link_info		=3D bpf_iter_task_fill_link_info,
 	.ctx_arg_info_size	=3D 2,
 	.ctx_arg_info		=3D {
 		{ offsetof(struct bpf_iter__task_file, task),
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index af5c600bf673..595bdc4c9431 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4259,6 +4259,11 @@ struct bpf_link_info {
 				struct {
 					__u32 map_id;
 				} map;
+
+				struct {
+					__u32 main_thread_only:1;
+					__u32 :31;
+				} task;
 			};
 		} iter;
 		struct  {
--=20
2.24.1

