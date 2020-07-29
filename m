Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87106232800
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 01:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgG2XV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 19:21:56 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39034 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726876AbgG2XVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 19:21:55 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06TNDJwv003047
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 16:21:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=VxYEzF1fsB2nYOj8u1pjEgmHrr0pYoQxICL8P8tR5xo=;
 b=GYxhcUc6lhbQZPywGWvoXZbO2H/82/8D7ZDJXxjvdeH8dE/2j8mLt72/twdyKqBRrPHx
 Ydn9UooCr66+kBc7nMHjI5y/bhtTGZYBt47AQqzpZZ7enaeact0rL3S3Y/xD/jvkHvRf
 sueCoi9ZDi8eNqST6D5dAFWEJdJgvpvPRG0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32h4q9ss5r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 16:21:54 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 29 Jul 2020 16:21:54 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id BF0762EC4E3D; Wed, 29 Jul 2020 16:21:52 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: make destructors more robust by handling ERR_PTR(err) cases
Date:   Wed, 29 Jul 2020 16:21:48 -0700
Message-ID: <20200729232148.896125-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-29_17:2020-07-29,2020-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 bulkscore=0 suspectscore=25 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007290158
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of libbpf "constructors" on failure return ERR_PTR(err) result encod=
ed as
a pointer. It's a common mistake to eventually pass such malformed pointe=
rs
into xxx__destroy()/xxx__free() "destructors". So instead of fixing up
clean up code in selftests and user programs, handle such error pointers =
in
destructors themselves. This works beautifully for NULL pointers passed t=
o
destructors, so might as well just work for error pointers.

Suggested-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.c      | 4 ++--
 tools/lib/bpf/btf_dump.c | 2 +-
 tools/lib/bpf/libbpf.c   | 9 ++++-----
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index c9e760e120dc..ded5b29965f9 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -386,7 +386,7 @@ __s32 btf__find_by_name_kind(const struct btf *btf, c=
onst char *type_name,
=20
 void btf__free(struct btf *btf)
 {
-	if (!btf)
+	if (IS_ERR_OR_NULL(btf))
 		return;
=20
 	if (btf->fd >=3D 0)
@@ -1025,7 +1025,7 @@ static int btf_ext_parse_hdr(__u8 *data, __u32 data=
_size)
=20
 void btf_ext__free(struct btf_ext *btf_ext)
 {
-	if (!btf_ext)
+	if (IS_ERR_OR_NULL(btf_ext))
 		return;
 	free(btf_ext->data);
 	free(btf_ext);
diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index e1c344504cae..cf711168d34a 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -183,7 +183,7 @@ void btf_dump__free(struct btf_dump *d)
 {
 	int i, cnt;
=20
-	if (!d)
+	if (IS_ERR_OR_NULL(d))
 		return;
=20
 	free(d->type_states);
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 54830d603fee..b9f11f854985 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6504,7 +6504,7 @@ void bpf_object__close(struct bpf_object *obj)
 {
 	size_t i;
=20
-	if (!obj)
+	if (IS_ERR_OR_NULL(obj))
 		return;
=20
 	if (obj->clear_priv)
@@ -7690,7 +7690,7 @@ int bpf_link__destroy(struct bpf_link *link)
 {
 	int err =3D 0;
=20
-	if (!link)
+	if (IS_ERR_OR_NULL(link))
 		return 0;
=20
 	if (!link->disconnected && link->detach)
@@ -8502,7 +8502,7 @@ void perf_buffer__free(struct perf_buffer *pb)
 {
 	int i;
=20
-	if (!pb)
+	if (IS_ERR_OR_NULL(pb))
 		return;
 	if (pb->cpu_bufs) {
 		for (i =3D 0; i < pb->cpu_cnt; i++) {
@@ -9379,8 +9379,7 @@ void bpf_object__detach_skeleton(struct bpf_object_=
skeleton *s)
 	for (i =3D 0; i < s->prog_cnt; i++) {
 		struct bpf_link **link =3D s->progs[i].link;
=20
-		if (!IS_ERR_OR_NULL(*link))
-			bpf_link__destroy(*link);
+		bpf_link__destroy(*link);
 		*link =3D NULL;
 	}
 }
--=20
2.24.1

