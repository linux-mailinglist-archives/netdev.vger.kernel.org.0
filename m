Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B2124C806
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 00:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbgHTWt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 18:49:57 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21326 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728533AbgHTWtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 18:49:52 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KMnkFY007017
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 15:49:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=JQHjQ781PNu2wmdJr1YFCMxvQzOxx+uwBKjxfuIlxzI=;
 b=V8fynO1YLyyshiGQFog5xMm8iRdYdUWiZUmhr910EU89/ZhBLExL9hUZ+2HhAdJUAYMz
 799+c97ATbxZL1ohdUyZ2ssg6c6jijlFbbH4+dHnfvtBUwBHEhvQM2kFv4ULOaj1KXhJ
 rHO/Hp6wDeO8NnPFqtcb0zkl6CxviMD+Bd4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304kq12ex-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 15:49:51 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 15:49:23 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 8DB213704EF5; Thu, 20 Aug 2020 15:49:18 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 2/3] bpf: implement link_query callbacks in map element iterators
Date:   Thu, 20 Aug 2020 15:49:18 -0700
Message-ID: <20200820224918.483254-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200820224917.483062-1-yhs@fb.com>
References: <20200820224917.483062-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_07:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 malwarescore=0 mlxlogscore=899
 lowpriorityscore=0 suspectscore=8 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200186
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For bpf_map_elem and bpf_sk_local_storage bpf iterators,
additional map_id should be shown for fdinfo and
userspace query. For example, the following is for
a bpf_map_elem iterator.
  $ cat /proc/1753/fdinfo/9
  pos:    0
  flags:  02000000
  mnt_id: 14
  link_type:      iter
  link_id:        34
  prog_tag:       104be6d3fe45e6aa
  prog_id:        173
  target_name:    bpf_map_elem
  map_id:         127

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h       |  4 ++++
 kernel/bpf/map_iter.c     | 15 +++++++++++++++
 net/core/bpf_sk_storage.c |  2 ++
 3 files changed, 21 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 529e9b183eeb..30c144af894a 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1256,6 +1256,10 @@ int bpf_iter_new_fd(struct bpf_link *link);
 bool bpf_link_is_iter(struct bpf_link *link);
 struct bpf_prog *bpf_iter_get_info(struct bpf_iter_meta *meta, bool in_s=
top);
 int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx);
+void bpf_iter_map_show_fdinfo(const struct bpf_iter_aux_info *aux,
+			      struct seq_file *seq);
+int bpf_iter_map_fill_link_info(const struct bpf_iter_aux_info *aux,
+				struct bpf_link_info *info);
=20
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
diff --git a/kernel/bpf/map_iter.c b/kernel/bpf/map_iter.c
index af86048e5afd..714e74556aa2 100644
--- a/kernel/bpf/map_iter.c
+++ b/kernel/bpf/map_iter.c
@@ -149,6 +149,19 @@ static void bpf_iter_detach_map(struct bpf_iter_aux_=
info *aux)
 	bpf_map_put_with_uref(aux->map);
 }
=20
+void bpf_iter_map_show_fdinfo(const struct bpf_iter_aux_info *aux,
+			      struct seq_file *seq)
+{
+	seq_printf(seq, "map_id:\t\t%u\n", aux->map->id);
+}
+
+int bpf_iter_map_fill_link_info(const struct bpf_iter_aux_info *aux,
+				struct bpf_link_info *info)
+{
+	info->iter.map.map_id =3D aux->map->id;
+	return 0;
+}
+
 DEFINE_BPF_ITER_FUNC(bpf_map_elem, struct bpf_iter_meta *meta,
 		     struct bpf_map *map, void *key, void *value)
=20
@@ -156,6 +169,8 @@ static const struct bpf_iter_reg bpf_map_elem_reg_inf=
o =3D {
 	.target			=3D "bpf_map_elem",
 	.attach_target		=3D bpf_iter_attach_map,
 	.detach_target		=3D bpf_iter_detach_map,
+	.show_fdinfo		=3D bpf_iter_map_show_fdinfo,
+	.fill_link_info		=3D bpf_iter_map_fill_link_info,
 	.ctx_arg_info_size	=3D 2,
 	.ctx_arg_info		=3D {
 		{ offsetof(struct bpf_iter__bpf_map_elem, key),
diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index b988f48153a4..281200dc0a01 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -1437,6 +1437,8 @@ static struct bpf_iter_reg bpf_sk_storage_map_reg_i=
nfo =3D {
 	.target			=3D "bpf_sk_storage_map",
 	.attach_target		=3D bpf_iter_attach_map,
 	.detach_target		=3D bpf_iter_detach_map,
+	.show_fdinfo		=3D bpf_iter_map_show_fdinfo,
+	.fill_link_info		=3D bpf_iter_map_fill_link_info,
 	.ctx_arg_info_size	=3D 2,
 	.ctx_arg_info		=3D {
 		{ offsetof(struct bpf_iter__bpf_sk_storage_map, sk),
--=20
2.24.1

