Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37507275C84
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 17:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgIWPzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 11:55:03 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17462 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726603AbgIWPzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 11:55:00 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08NFhlTc022101
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 08:55:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=uEc9KTTnUvXk9tjS4mlIoiIdh7NlFMATmQlV9Jej1XY=;
 b=rqqEUSrbCMf5+85Fud3ShqgOVBJXPGmkdhCKdK1bQyT0J1pxvxNzxj+GCY8kgjg6YdCT
 B6KWUXSefF/UBimsvL/3d28wxK10ssTre6GW5+JvJLVymarqEhZZgl/k5GpaFhPkW8B4
 /u2IPexyYVXfFuvth4+4v7vTIxJChIhorJU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp5vc2p-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 08:55:00 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Sep 2020 08:54:57 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 18BAB2EC7442; Wed, 23 Sep 2020 08:54:55 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH bpf-next 8/9] libbpf: add btf__str_by_offset() as a more generic variant of name_by_offset
Date:   Wed, 23 Sep 2020 08:54:35 -0700
Message-ID: <20200923155436.2117661-9-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200923155436.2117661-1-andriin@fb.com>
References: <20200923155436.2117661-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_12:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 mlxlogscore=807 clxscore=1015 suspectscore=8 impostorscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 spamscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230125
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

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.c      | 7 ++++++-
 tools/lib/bpf/btf.h      | 1 +
 tools/lib/bpf/libbpf.map | 1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 7d50f626b823..15c84d41a5cb 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1023,7 +1023,7 @@ const void *btf__get_raw_data(const struct btf *btf=
_ro, __u32 *size)
 	return btf->raw_data;
 }
=20
-const char *btf__name_by_offset(const struct btf *btf, __u32 offset)
+const char *btf__str_by_offset(const struct btf *btf, __u32 offset)
 {
 	if (offset < btf->hdr->str_len)
 		return btf->strs_data + offset;
@@ -1031,6 +1031,11 @@ const char *btf__name_by_offset(const struct btf *=
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
index 32dd71eeed38..6a91d47283d7 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -48,6 +48,7 @@ LIBBPF_API int btf__fd(const struct btf *btf);
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
index 6ef598472a50..724ad3d94bb3 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -325,6 +325,7 @@ LIBBPF_0.2.0 {
 		btf__append_var;
 		btf__append_volatile;
 		btf__new_empty;
+		btf__str_by_offset;
 		perf_buffer__buffer_cnt;
 		perf_buffer__buffer_fd;
 		perf_buffer__epoll_fd;
--=20
2.24.1

