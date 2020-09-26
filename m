Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58082795DF
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 03:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729931AbgIZBOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 21:14:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62288 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729921AbgIZBOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 21:14:45 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08Q1BEH5001755
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 18:14:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=5AcoWPWlRBkoW7FvkHqzFfr8i93hzsKUu5drSHDOpLI=;
 b=jPIUmPClgcB/ANxoue+f+K6TWCrRyjXJLPkZhXk28LfZCnDq3RtcQdPc0oWfZ0H3+bw0
 N4uLNmKxg3qqkqoHsGHwUYHNqKUXXDQxghVEg4z4vXJ1RVHmKm/KZGItxUH6CMk3L8Br
 G28RdMJOAoTtME9NAsfAvKSoh4IJ+A02+kU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp7jrde-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 18:14:45 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 25 Sep 2020 18:14:43 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 660682EC75B0; Fri, 25 Sep 2020 18:14:32 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH v2 bpf-next 4/9] libbpf: extract generic string hashing function for reuse
Date:   Fri, 25 Sep 2020 18:13:52 -0700
Message-ID: <20200926011357.2366158-5-andriin@fb.com>
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
 mlxlogscore=856 impostorscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 spamscore=0 suspectscore=8
 clxscore=1015 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009260006
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Calculating a hash of zero-terminated string is a common need when using
hashmap, so extract it for reuse.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf_dump.c |  9 +--------
 tools/lib/bpf/hashmap.h  | 12 ++++++++++++
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 6c079b3c8679..91310e528a3a 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -90,14 +90,7 @@ struct btf_dump {
=20
 static size_t str_hash_fn(const void *key, void *ctx)
 {
-	const char *s =3D key;
-	size_t h =3D 0;
-
-	while (*s) {
-		h =3D h * 31 + *s;
-		s++;
-	}
-	return h;
+	return str_hash(key);
 }
=20
 static bool str_equal_fn(const void *a, const void *b, void *ctx)
diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
index e0af36b0e5d8..d9b385fe808c 100644
--- a/tools/lib/bpf/hashmap.h
+++ b/tools/lib/bpf/hashmap.h
@@ -25,6 +25,18 @@ static inline size_t hash_bits(size_t h, int bits)
 #endif
 }
=20
+/* generic C-string hashing function */
+static inline size_t str_hash(const char *s)
+{
+	size_t h =3D 0;
+
+	while (*s) {
+		h =3D h * 31 + *s;
+		s++;
+	}
+	return h;
+}
+
 typedef size_t (*hashmap_hash_fn)(const void *key, void *ctx);
 typedef bool (*hashmap_equal_fn)(const void *key1, const void *key2, voi=
d *ctx);
=20
--=20
2.24.1

