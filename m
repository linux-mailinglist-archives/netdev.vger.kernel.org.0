Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAA72795DC
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 03:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729915AbgIZBOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 21:14:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32546 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729908AbgIZBOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 21:14:44 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08Q1Dptf029535
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 18:14:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=4XxEFqSWZ2fU0OtZqRN5wmUcc2YG7N8MWGdSie2XoBs=;
 b=fp38aUXbGHeNR+MuIiFqgFOpbniJ2FaEzfAw66IdIp5wZk8OH1oYZrQak9OtPCm+k4sF
 jLdtRFP6wepKininJwYXPQvpdMST6SXUf1tZxD/RPhHOjlBwVgxviKFdU+NdL7zggJWu
 /ra/T/y9UQCTUEMgx8SCq3xVZJ5+4+eMBlA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp4ar9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 18:14:43 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 25 Sep 2020 18:14:42 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id B9BF82EC75B0; Fri, 25 Sep 2020 18:14:36 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH v2 bpf-next 6/9] libbpf: add btf__new_empty() to create an empty BTF object
Date:   Fri, 25 Sep 2020 18:13:54 -0700
Message-ID: <20200926011357.2366158-7-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200926011357.2366158-1-andriin@fb.com>
References: <20200926011357.2366158-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_19:2020-09-24,2020-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=910
 clxscore=1015 phishscore=0 suspectscore=25 spamscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009260006
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an ability to create an empty BTF object from scratch. This is going =
to be
used by pahole for BTF encoding. And also by selftest for convenient crea=
tion
of BTF objects.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.c      | 30 ++++++++++++++++++++++++++++++
 tools/lib/bpf/btf.h      |  1 +
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 32 insertions(+)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 040f3b8ee39f..54861a5ba9d9 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -565,6 +565,36 @@ void btf__free(struct btf *btf)
 	free(btf);
 }
=20
+struct btf *btf__new_empty(void)
+{
+	struct btf *btf;
+
+	btf =3D calloc(1, sizeof(*btf));
+	if (!btf)
+		return ERR_PTR(-ENOMEM);
+	btf->fd =3D -1;
+	btf->ptr_sz =3D sizeof(void *);
+
+	/* +1 for empty string at offset 0 */
+	btf->raw_size =3D sizeof(struct btf_header) + 1;
+	btf->raw_data =3D calloc(1, btf->raw_size);
+	if (!btf->raw_data) {
+		free(btf);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	btf->hdr =3D btf->raw_data;
+	btf->hdr->hdr_len =3D sizeof(struct btf_header);
+	btf->hdr->magic =3D BTF_MAGIC;
+	btf->hdr->version =3D BTF_VERSION;
+
+	btf->types_data =3D btf->raw_data + btf->hdr->hdr_len;
+	btf->strs_data =3D btf->raw_data + btf->hdr->hdr_len;
+	btf->hdr->str_len =3D 1; /* empty string at offset 0 */
+
+	return btf;
+}
+
 struct btf *btf__new(const void *data, __u32 size)
 {
 	struct btf *btf;
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index d88b6447c222..b387d0b61f1c 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -27,6 +27,7 @@ struct bpf_object;
=20
 LIBBPF_API void btf__free(struct btf *btf);
 LIBBPF_API struct btf *btf__new(const void *data, __u32 size);
+LIBBPF_API struct btf *btf__new_empty(void);
 LIBBPF_API struct btf *btf__parse(const char *path, struct btf_ext **btf=
_ext);
 LIBBPF_API struct btf *btf__parse_elf(const char *path, struct btf_ext *=
*btf_ext);
 LIBBPF_API struct btf *btf__parse_raw(const char *path);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index c38aca688a39..6e75cb0e1b17 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -306,6 +306,7 @@ LIBBPF_0.2.0 {
 		bpf_program__section_name;
 		btf__add_str;
 		btf__find_str;
+		btf__new_empty;
 		perf_buffer__buffer_cnt;
 		perf_buffer__buffer_fd;
 		perf_buffer__epoll_fd;
--=20
2.24.1

