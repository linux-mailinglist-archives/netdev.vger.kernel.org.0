Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FEC24AF1C
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 08:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgHTGOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 02:14:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14996 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725780AbgHTGOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 02:14:18 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07K6ANbu018963
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 23:14:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=PHf9Q5egeqJubOlCN2laHxGaCQYP7dor1nw1VjJdIXg=;
 b=O1Jl+7bznAGNJGagd8jlQaSJbDbaxOb/4fSkbxZEicdHtgdB949bEJJRqYHO9JMQ9tnk
 tyANIEyU0HfUlPHpa2Gu5VWZlm7fUbg4VyYURFpksbaJIy4/h3HgKu/smMkACrNpAFyW
 Unf4/yZu/68bCxbgrIJf9ubUwivlXkK0JJg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 331cue1eyq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 23:14:18 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 23:14:17 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id E4D3A2EC5ED6; Wed, 19 Aug 2020 23:14:14 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/4] libbpf: fix libbpf build on compilers missing __builtin_mul_overflow
Date:   Wed, 19 Aug 2020 23:14:09 -0700
Message-ID: <20200820061411.1755905-2-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200820061411.1755905-1-andriin@fb.com>
References: <20200820061411.1755905-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_13:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 suspectscore=8 spamscore=0 impostorscore=0 mlxscore=0
 adultscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 mlxlogscore=771
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200054
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC compilers older than version 5 don't support __builtin_mul_overflow y=
et.
Given GCC 4.9 is the minimal supported compiler for building kernel and t=
he
fact that libbpf is a dependency of resolve_btfids, which is dependency o=
f
CONFIG_DEBUG_INFO_BTF=3Dy, this needs to be handled. This patch fixes the=
 issue
by falling back to slower detection of integer overflow in such cases.

Fixes: 029258d7b228 ("libbpf: Remove any use of reallocarray() in libbpf"=
)
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf_internal.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_inter=
nal.h
index 61dff515a2f0..4d1c366fca2c 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -10,6 +10,7 @@
 #define __LIBBPF_LIBBPF_INTERNAL_H
=20
 #include <stdlib.h>
+#include <limits.h>
=20
 /* make sure libbpf doesn't use kernel-only integer typedefs */
 #pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
@@ -77,6 +78,9 @@ do {				\
 #define pr_info(fmt, ...)	__pr(LIBBPF_INFO, fmt, ##__VA_ARGS__)
 #define pr_debug(fmt, ...)	__pr(LIBBPF_DEBUG, fmt, ##__VA_ARGS__)
=20
+#ifndef __has_builtin
+#define __has_builtin(x) 0
+#endif
 /*
  * Re-implement glibc's reallocarray() for libbpf internal-only use.
  * reallocarray(), unfortunately, is not available in all versions of gl=
ibc,
@@ -90,8 +94,14 @@ static inline void *libbpf_reallocarray(void *ptr, siz=
e_t nmemb, size_t size)
 {
 	size_t total;
=20
+#if __has_builtin(__builtin_mul_overflow)
 	if (unlikely(__builtin_mul_overflow(nmemb, size, &total)))
 		return NULL;
+#else
+	if (size =3D=3D 0 || nmemb > ULONG_MAX / size)
+		return NULL;
+	total =3D nmemb * size;
+#endif
 	return realloc(ptr, total);
 }
=20
--=20
2.24.1

