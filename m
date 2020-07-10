Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D1421AC64
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 03:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgGJBKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 21:10:34 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9442 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726265AbgGJBKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 21:10:34 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06A0pYZw031703
        for <netdev@vger.kernel.org>; Thu, 9 Jul 2020 18:10:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=xfAknqrzBkEU4BjOQfd350WpBtIFa49QBe655gjJm08=;
 b=E2x6hFbw43k1Hj4Kihmkc/8Kki5w7oUCB1BSEtoNfWuSudR7MrVKRiVVHc+R4yVrV+Ca
 o4gkOxinIgc2OsBAlH6kkXCVHtOJ9cyfviUgcDU8EApHuFibsjM6fbIi7dBHSi0btFg/
 wQ7EdKgyhDYcx2o5dJlidWXIMdaZjDrlIzg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 325jysqnbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 18:10:33 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 9 Jul 2020 18:10:33 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 4363F2EC3C81; Thu,  9 Jul 2020 18:10:28 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: fix memory leak and optimize BTF sanitization
Date:   Thu, 9 Jul 2020 18:10:23 -0700
Message-ID: <20200710011023.1655008-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-09_11:2020-07-09,2020-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=25 adultscore=0 phishscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007100001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Coverity's static analysis helpfully reported a memory leak introduced by
0f0e55d8247c ("libbpf: Improve BTF sanitization handling"). While fixing =
it,
I realized that btf__new() already creates a memory copy, so there is no =
need
to do this. So this patch also fixes misleading btf__new() signature to m=
ake
data into a `const void *` input parameter. And it avoids unnecessary mem=
ory
allocation and copy in BTF sanitization code altogether.

Fixes: 0f0e55d8247c ("libbpf: Improve BTF sanitization handling")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.c    |  2 +-
 tools/lib/bpf/btf.h    |  2 +-
 tools/lib/bpf/libbpf.c | 11 +++--------
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index c8861c9e3635..c9e760e120dc 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -397,7 +397,7 @@ void btf__free(struct btf *btf)
 	free(btf);
 }
=20
-struct btf *btf__new(__u8 *data, __u32 size)
+struct btf *btf__new(const void *data, __u32 size)
 {
 	struct btf *btf;
 	int err;
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 173eff23c472..a3b7ef9b737f 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -63,7 +63,7 @@ struct btf_ext_header {
 };
=20
 LIBBPF_API void btf__free(struct btf *btf);
-LIBBPF_API struct btf *btf__new(__u8 *data, __u32 size);
+LIBBPF_API struct btf *btf__new(const void *data, __u32 size);
 LIBBPF_API struct btf *btf__parse_elf(const char *path,
 				      struct btf_ext **btf_ext);
 LIBBPF_API int btf__finalize_data(struct bpf_object *obj, struct btf *bt=
f);
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 6602eb479596..25e4f77be8d7 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2533,17 +2533,12 @@ static int bpf_object__sanitize_and_load_btf(stru=
ct bpf_object *obj)
=20
 	sanitize =3D btf_needs_sanitization(obj);
 	if (sanitize) {
-		const void *orig_data;
-		void *san_data;
+		const void *raw_data;
 		__u32 sz;
=20
 		/* clone BTF to sanitize a copy and leave the original intact */
-		orig_data =3D btf__get_raw_data(obj->btf, &sz);
-		san_data =3D malloc(sz);
-		if (!san_data)
-			return -ENOMEM;
-		memcpy(san_data, orig_data, sz);
-		kern_btf =3D btf__new(san_data, sz);
+		raw_data =3D btf__get_raw_data(obj->btf, &sz);
+		kern_btf =3D btf__new(raw_data, sz);
 		if (IS_ERR(kern_btf))
 			return PTR_ERR(kern_btf);
=20
--=20
2.24.1

