Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305281B6D43
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 07:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgDXFf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 01:35:29 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38566 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726458AbgDXFf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 01:35:28 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O5YKcF011760
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 22:35:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=3p26RKWuBfKBBGCNIOWRu8lE6O/AFW/2J28Yvk0DqbQ=;
 b=FCfqqspNhJ9EQ6DF1+PU9iFsPc1rZ5DRrVCnVndUc2yjlV2l1knt5vz7sATOClcydIs9
 tu0/iA3fpvIkF6mshJ79QulGYnYjA/3/j2/KuEiYbHHrMZCYaJTh8tUv6d1+aALg/+Ms
 F5mYHAsp6XVRBZNi2aUnkYFcMrqSICfweMc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30jtc5tq4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 22:35:26 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 23 Apr 2020 22:35:26 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A9C9F2EC31CF; Thu, 23 Apr 2020 22:35:20 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 05/10] libbpf: add low-level APIs for new bpf_link commands
Date:   Thu, 23 Apr 2020 22:35:00 -0700
Message-ID: <20200424053505.4111226-6-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200424053505.4111226-1-andriin@fb.com>
References: <20200424053505.4111226-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_01:2020-04-23,2020-04-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 clxscore=1015 spamscore=0 adultscore=0 malwarescore=0 suspectscore=43
 bulkscore=0 mlxscore=0 mlxlogscore=622 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240040
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add low-level API calls for bpf_link_get_next_id() and
bpf_link_get_fd_by_id().

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/bpf.c      | 19 +++++++++++++++++--
 tools/lib/bpf/bpf.h      |  4 +++-
 tools/lib/bpf/libbpf.map |  6 ++++++
 3 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 5cc1b0785d18..8f2f0958d446 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -721,6 +721,11 @@ int bpf_btf_get_next_id(__u32 start_id, __u32 *next_=
id)
 	return bpf_obj_get_next_id(start_id, next_id, BPF_BTF_GET_NEXT_ID);
 }
=20
+int bpf_link_get_next_id(__u32 start_id, __u32 *next_id)
+{
+	return bpf_obj_get_next_id(start_id, next_id, BPF_LINK_GET_NEXT_ID);
+}
+
 int bpf_prog_get_fd_by_id(__u32 id)
 {
 	union bpf_attr attr;
@@ -751,13 +756,23 @@ int bpf_btf_get_fd_by_id(__u32 id)
 	return sys_bpf(BPF_BTF_GET_FD_BY_ID, &attr, sizeof(attr));
 }
=20
-int bpf_obj_get_info_by_fd(int prog_fd, void *info, __u32 *info_len)
+int bpf_link_get_fd_by_id(__u32 id)
+{
+	union bpf_attr attr;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.link_id =3D id;
+
+	return sys_bpf(BPF_LINK_GET_FD_BY_ID, &attr, sizeof(attr));
+}
+
+int bpf_obj_get_info_by_fd(int bpf_fd, void *info, __u32 *info_len)
 {
 	union bpf_attr attr;
 	int err;
=20
 	memset(&attr, 0, sizeof(attr));
-	attr.info.bpf_fd =3D prog_fd;
+	attr.info.bpf_fd =3D bpf_fd;
 	attr.info.info_len =3D *info_len;
 	attr.info.info =3D ptr_to_u64(info);
=20
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 46d47afdd887..335b457b3a25 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -216,10 +216,12 @@ LIBBPF_API int bpf_prog_test_run(int prog_fd, int r=
epeat, void *data,
 LIBBPF_API int bpf_prog_get_next_id(__u32 start_id, __u32 *next_id);
 LIBBPF_API int bpf_map_get_next_id(__u32 start_id, __u32 *next_id);
 LIBBPF_API int bpf_btf_get_next_id(__u32 start_id, __u32 *next_id);
+LIBBPF_API int bpf_link_get_next_id(__u32 start_id, __u32 *next_id);
 LIBBPF_API int bpf_prog_get_fd_by_id(__u32 id);
 LIBBPF_API int bpf_map_get_fd_by_id(__u32 id);
 LIBBPF_API int bpf_btf_get_fd_by_id(__u32 id);
-LIBBPF_API int bpf_obj_get_info_by_fd(int prog_fd, void *info, __u32 *in=
fo_len);
+LIBBPF_API int bpf_link_get_fd_by_id(__u32 id);
+LIBBPF_API int bpf_obj_get_info_by_fd(int bpf_fd, void *info, __u32 *inf=
o_len);
 LIBBPF_API int bpf_prog_query(int target_fd, enum bpf_attach_type type,
 			      __u32 query_flags, __u32 *attach_flags,
 			      __u32 *prog_ids, __u32 *prog_cnt);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index bb8831605b25..7cd49aa38005 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -254,3 +254,9 @@ LIBBPF_0.0.8 {
 		bpf_program__set_lsm;
 		bpf_set_link_xdp_fd_opts;
 } LIBBPF_0.0.7;
+
+LIBBPF_0.0.9 {
+	global:
+		bpf_link_get_fd_by_id;
+		bpf_link_get_next_id;
+} LIBBPF_0.0.8;
--=20
2.24.1

