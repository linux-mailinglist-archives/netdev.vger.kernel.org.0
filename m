Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97BAB21AB06
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 00:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgGIW5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 18:57:42 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46530 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726433AbgGIW5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 18:57:41 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 069MtHS2022854
        for <netdev@vger.kernel.org>; Thu, 9 Jul 2020 15:57:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=UN39p7LT33Yse9/2SnztHGUhfsyx3mPntaq1jstnlZo=;
 b=Ff4u9Bz87TXtbH1DmuQdTbETrNS86BwqBjV0jaq5M7dj2gidjLAPC83NYoB9ndQD4Dxz
 YLDQvfX/vaQEcFBpuD7uIPFy6qZ71cgTYN11IzsBMFjMo4fYv19IQWFcxZUPxMipU6yA
 OvhJmAfiRyH80y5DDoMOiU2jH+ATqbjfBCU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 325k2hq4vq-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 15:57:40 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 9 Jul 2020 15:57:37 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A677C2EC3C49; Thu,  9 Jul 2020 15:57:28 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <qboosh@pld-linux.org>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] libbpf: Fix libbpf hashmap on (I)LP32 architectures
Date:   Thu, 9 Jul 2020 15:57:23 -0700
Message-ID: <20200709225723.1069937-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-09_11:2020-07-09,2020-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 adultscore=0 mlxlogscore=740 clxscore=1015 suspectscore=0 spamscore=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007090152
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Bogusz <qboosh@pld-linux.org>

On ILP32, 64-bit result was shifted by value calculated for 32-bit long t=
ype
and returned value was much outside hashmap capacity.
As advised by Andrii Nakryiko, this patch uses different hashing variant =
for
architectures with size_t shorter than long long.

Fixes: e3b924224028 ("libbpf: add resizable non-thread safe internal hash=
map")
Signed-off-by: Jakub Bogusz <qboosh@pld-linux.org>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/hashmap.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
index df59fd4fc95b..e0af36b0e5d8 100644
--- a/tools/lib/bpf/hashmap.h
+++ b/tools/lib/bpf/hashmap.h
@@ -11,14 +11,18 @@
 #include <stdbool.h>
 #include <stddef.h>
 #include <limits.h>
-#ifndef __WORDSIZE
-#define __WORDSIZE (__SIZEOF_LONG__ * 8)
-#endif
=20
 static inline size_t hash_bits(size_t h, int bits)
 {
 	/* shuffle bits and return requested number of upper bits */
-	return (h * 11400714819323198485llu) >> (__WORDSIZE - bits);
+#if (__SIZEOF_SIZE_T__ =3D=3D __SIZEOF_LONG_LONG__)
+	/* LP64 case */
+	return (h * 11400714819323198485llu) >> (__SIZEOF_LONG_LONG__ * 8 - bit=
s);
+#elif (__SIZEOF_SIZE_T__ <=3D __SIZEOF_LONG__)
+	return (h * 2654435769lu) >> (__SIZEOF_LONG__ * 8 - bits);
+#else
+#	error "Unsupported size_t size"
+#endif
 }
=20
 typedef size_t (*hashmap_hash_fn)(const void *key, void *ctx);
--=20
2.24.1

