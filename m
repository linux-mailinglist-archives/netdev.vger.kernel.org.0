Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7366F217CD3
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 03:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbgGHByF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 21:54:05 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17428 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729215AbgGHByE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 21:54:04 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0681pjbq023399
        for <netdev@vger.kernel.org>; Tue, 7 Jul 2020 18:54:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Q5HwaKO6SgHndLhjMZOf+7Eh7QPm9CG57y5I/nBiDdA=;
 b=HKZwwZa9c6g4pjf9Y0p7ecuEur1eKkoBbmtwG2JnFROE6kspAfPdfyc321CZlJJDQzYC
 5jGGwGVXmBatjamD2r5hI7AxtrrySkrY7mQP9prWfbJi0t2xTJBepDhTpUJPu+mNXqvP
 x2B9bQuKmX2ZKJqsmdpJRtLo9cVMtgtZZHI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 324tug2v60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 18:54:03 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 7 Jul 2020 18:53:25 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id D6F9C2EC39F5; Tue,  7 Jul 2020 18:53:24 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Matthew Lim <matthewlim@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/6] libbpf: add btf__set_fd() for more control over loaded BTF FD
Date:   Tue, 7 Jul 2020 18:53:14 -0700
Message-ID: <20200708015318.3827358-3-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200708015318.3827358-1-andriin@fb.com>
References: <20200708015318.3827358-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-07_15:2020-07-07,2020-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 cotscore=-2147483648
 priorityscore=1501 lowpriorityscore=0 suspectscore=25 clxscore=1015
 spamscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=822
 impostorscore=0 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007080010
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add setter for BTF FD to allow application more fine-grained control in m=
ore
advanced scenarios. Storing BTF FD inside `struct btf` provides little be=
nefit
and probably would be better done differently (e.g., btf__load() could ju=
st
return FD on success), but we are stuck with this due to backwards
compatibility. The main problem is that it's impossible to load BTF and t=
han
free user-space memory, but keep FD intact, because `struct btf` assumes
ownership of that FD upon successful load and will attempt to close it du=
ring
btf__free(). To allow callers (e.g., libbpf itself for BTF sanitization) =
to
have more control over this, add btf__set_fd() to allow to reset FD
arbitrarily, if necessary.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.c      | 7 ++++++-
 tools/lib/bpf/btf.h      | 1 +
 tools/lib/bpf/libbpf.map | 1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index bfef3d606b54..c8861c9e3635 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -389,7 +389,7 @@ void btf__free(struct btf *btf)
 	if (!btf)
 		return;
=20
-	if (btf->fd !=3D -1)
+	if (btf->fd >=3D 0)
 		close(btf->fd);
=20
 	free(btf->data);
@@ -700,6 +700,11 @@ int btf__fd(const struct btf *btf)
 	return btf->fd;
 }
=20
+void btf__set_fd(struct btf *btf, int fd)
+{
+	btf->fd =3D fd;
+}
+
 const void *btf__get_raw_data(const struct btf *btf, __u32 *size)
 {
 	*size =3D btf->data_size;
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 06cd1731c154..173eff23c472 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -79,6 +79,7 @@ LIBBPF_API __s64 btf__resolve_size(const struct btf *bt=
f, __u32 type_id);
 LIBBPF_API int btf__resolve_type(const struct btf *btf, __u32 type_id);
 LIBBPF_API int btf__align_of(const struct btf *btf, __u32 id);
 LIBBPF_API int btf__fd(const struct btf *btf);
+LIBBPF_API void btf__set_fd(struct btf *btf, int fd);
 LIBBPF_API const void *btf__get_raw_data(const struct btf *btf, __u32 *s=
ize);
 LIBBPF_API const char *btf__name_by_offset(const struct btf *btf, __u32 =
offset);
 LIBBPF_API int btf__get_from_id(__u32 id, struct btf **btf);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 6544d2cd1ed6..c5d5c7664c3b 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -288,4 +288,5 @@ LIBBPF_0.1.0 {
 		bpf_map__value_size;
 		bpf_program__autoload;
 		bpf_program__set_autoload;
+		btf__set_fd;
 } LIBBPF_0.0.9;
--=20
2.24.1

