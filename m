Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716802795E8
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 03:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729967AbgIZBPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 21:15:20 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27704 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729960AbgIZBPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 21:15:19 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08Q1BMJn001795
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 18:15:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=xLwbvc2fK8XJzHwy/2cOsAcmQLstsjcmHgQrWNAe4Jo=;
 b=X5QhxDoV8pUFnoE4Y3iI+kjCZBjwx2otDY4jijZvYuicDAJ9AsechDz+4CIwYE5xjpOh
 W17vDdHGEnLQAXHnYpztA8tQoYxoFazLkrHZ9ZeL51FihlhhPdHOpIsq88RvtmnAR29G
 jzqvf+S10LkfLBrsYwMHdkjZ91KGqb0dz6s= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp7jrf2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 18:15:18 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 25 Sep 2020 18:14:43 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 2517E2EC75B0; Fri, 25 Sep 2020 18:14:41 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH v2 bpf-next 8/9] libbpf: add btf__str_by_offset() as a more generic variant of name_by_offset
Date:   Fri, 25 Sep 2020 18:13:56 -0700
Message-ID: <20200926011357.2366158-9-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200926011357.2366158-1-andriin@fb.com>
References: <20200926011357.2366158-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_19:2020-09-24,2020-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 mlxlogscore=836 impostorscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 spamscore=0 suspectscore=8
 clxscore=1015 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009260006
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BTF strings are used not just for names, they can be arbitrary strings us=
ed
for CO-RE relocations, line/func infos, etc. Thus "name_by_offset" termin=
ology
is too specific and might be misleading. Instead, introduce
btf__str_by_offset() API which uses generic string terminology.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.c      | 7 ++++++-
 tools/lib/bpf/btf.h      | 1 +
 tools/lib/bpf/libbpf.map | 1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 7533088b2524..2d0b1e12f50e 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1025,7 +1025,7 @@ const void *btf__get_raw_data(const struct btf *btf=
_ro, __u32 *size)
 	return btf->raw_data;
 }
=20
-const char *btf__name_by_offset(const struct btf *btf, __u32 offset)
+const char *btf__str_by_offset(const struct btf *btf, __u32 offset)
 {
 	if (offset < btf->hdr->str_len)
 		return btf->strs_data + offset;
@@ -1033,6 +1033,11 @@ const char *btf__name_by_offset(const struct btf *=
btf, __u32 offset)
 		return NULL;
 }
=20
+const char *btf__name_by_offset(const struct btf *btf, __u32 offset)
+{
+	return btf__str_by_offset(btf, offset);
+}
+
 int btf__get_from_id(__u32 id, struct btf **btf)
 {
 	struct bpf_btf_info btf_info =3D { 0 };
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index d6629a2e8ebf..f7dec0144c3c 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -49,6 +49,7 @@ LIBBPF_API int btf__fd(const struct btf *btf);
 LIBBPF_API void btf__set_fd(struct btf *btf, int fd);
 LIBBPF_API const void *btf__get_raw_data(const struct btf *btf, __u32 *s=
ize);
 LIBBPF_API const char *btf__name_by_offset(const struct btf *btf, __u32 =
offset);
+LIBBPF_API const char *btf__str_by_offset(const struct btf *btf, __u32 o=
ffset);
 LIBBPF_API int btf__get_from_id(__u32 id, struct btf **btf);
 LIBBPF_API int btf__get_map_kv_tids(const struct btf *btf, const char *m=
ap_name,
 				    __u32 expected_key_size,
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 1cb98d01e4f2..560907ba5aac 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -326,6 +326,7 @@ LIBBPF_0.2.0 {
 		btf__add_volatile;
 		btf__find_str;
 		btf__new_empty;
+		btf__str_by_offset;
 		perf_buffer__buffer_cnt;
 		perf_buffer__buffer_fd;
 		perf_buffer__epoll_fd;
--=20
2.24.1

