Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7125A23F420
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 23:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbgHGVGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 17:06:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58792 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726825AbgHGVGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 17:06:51 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 077Ku7Q8000462
        for <netdev@vger.kernel.org>; Fri, 7 Aug 2020 14:06:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=aEKN32479ug/zbl8v+pT/cWUU1hgpbXoIDmUhsC74dk=;
 b=M7TWz8WsrT8ErvZgstWejj37Aiej8i17I1Fyd8C/p7wuNvS9ohiHXoS22XxqlNvBjjbQ
 97dL0x8QdZtoZJEFPHc93K2KM7KokGzPxmT5mYJFcfqhqjgxMOdTa2Z5W072VlVULjwa
 fKsmA0ow/cLyAztKDCsTKxBQdL5qAf3PTc4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32rvwf4g9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 14:06:49 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 7 Aug 2020 14:06:48 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 9A2E32EC5494; Fri,  7 Aug 2020 14:06:45 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 6/7] libbpf: switch tracing and CO-RE helper macros to bpf_probe_read_kernel()
Date:   Fri, 7 Aug 2020 14:06:28 -0700
Message-ID: <20200807210629.394335-7-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200807210629.394335-1-andriin@fb.com>
References: <20200807210629.394335-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-07_20:2020-08-06,2020-08-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 mlxscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 suspectscore=8 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008070147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that libbpf can automatically fallback to bpf_probe_read() on old ker=
nels
not yet supporting bpf_probe_read_kernel(), switch libbpf BPF-side helper
macros to use appropriate BPF helper for reading kernel data.

Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/bpf_core_read.h | 40 +++++++++++++++++++----------------
 tools/lib/bpf/bpf_tracing.h   |  4 ++--
 2 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/tools/lib/bpf/bpf_core_read.h b/tools/lib/bpf/bpf_core_read.=
h
index eae5cccff761..03152cb143b7 100644
--- a/tools/lib/bpf/bpf_core_read.h
+++ b/tools/lib/bpf/bpf_core_read.h
@@ -24,27 +24,29 @@ enum bpf_field_info_kind {
=20
 #if __BYTE_ORDER =3D=3D __LITTLE_ENDIAN
 #define __CORE_BITFIELD_PROBE_READ(dst, src, fld)			      \
-	bpf_probe_read((void *)dst,					      \
-		       __CORE_RELO(src, fld, BYTE_SIZE),		      \
-		       (const void *)src + __CORE_RELO(src, fld, BYTE_OFFSET))
+	bpf_probe_read_kernel(						      \
+			(void *)dst,				      \
+			__CORE_RELO(src, fld, BYTE_SIZE),		      \
+			(const void *)src + __CORE_RELO(src, fld, BYTE_OFFSET))
 #else
 /* semantics of LSHIFT_64 assumes loading values into low-ordered bytes,=
 so
  * for big-endian we need to adjust destination pointer accordingly, bas=
ed on
  * field byte size
  */
 #define __CORE_BITFIELD_PROBE_READ(dst, src, fld)			      \
-	bpf_probe_read((void *)dst + (8 - __CORE_RELO(src, fld, BYTE_SIZE)),  \
-		       __CORE_RELO(src, fld, BYTE_SIZE),		      \
-		       (const void *)src + __CORE_RELO(src, fld, BYTE_OFFSET))
+	bpf_probe_read_kernel(						      \
+			(void *)dst + (8 - __CORE_RELO(src, fld, BYTE_SIZE)), \
+			__CORE_RELO(src, fld, BYTE_SIZE),		      \
+			(const void *)src + __CORE_RELO(src, fld, BYTE_OFFSET))
 #endif
=20
 /*
  * Extract bitfield, identified by s->field, and return its value as u64=
.
  * All this is done in relocatable manner, so bitfield changes such as
  * signedness, bit size, offset changes, this will be handled automatica=
lly.
- * This version of macro is using bpf_probe_read() to read underlying in=
teger
- * storage. Macro functions as an expression and its return type is
- * bpf_probe_read()'s return value: 0, on success, <0 on error.
+ * This version of macro is using bpf_probe_read_kernel() to read underl=
ying
+ * integer storage. Macro functions as an expression and its return type=
 is
+ * bpf_probe_read_kernel()'s return value: 0, on success, <0 on error.
  */
 #define BPF_CORE_READ_BITFIELD_PROBED(s, field) ({			      \
 	unsigned long long val =3D 0;					      \
@@ -99,8 +101,8 @@ enum bpf_field_info_kind {
 	__builtin_preserve_field_info(field, BPF_FIELD_BYTE_SIZE)
=20
 /*
- * bpf_core_read() abstracts away bpf_probe_read() call and captures off=
set
- * relocation for source address using __builtin_preserve_access_index()
+ * bpf_core_read() abstracts away bpf_probe_read_kernel() call and captu=
res
+ * offset relocation for source address using __builtin_preserve_access_=
index()
  * built-in, provided by Clang.
  *
  * __builtin_preserve_access_index() takes as an argument an expression =
of
@@ -115,8 +117,8 @@ enum bpf_field_info_kind {
  * (local) BTF, used to record relocation.
  */
 #define bpf_core_read(dst, sz, src)					    \
-	bpf_probe_read(dst, sz,						    \
-		       (const void *)__builtin_preserve_access_index(src))
+	bpf_probe_read_kernel(dst, sz,					    \
+			      (const void *)__builtin_preserve_access_index(src))
=20
 /*
  * bpf_core_read_str() is a thin wrapper around bpf_probe_read_str()
@@ -124,8 +126,8 @@ enum bpf_field_info_kind {
  * argument.
  */
 #define bpf_core_read_str(dst, sz, src)					    \
-	bpf_probe_read_str(dst, sz,					    \
-			   (const void *)__builtin_preserve_access_index(src))
+	bpf_probe_read_kernel_str(dst, sz,				    \
+				  (const void *)__builtin_preserve_access_index(src))
=20
 #define ___concat(a, b) a ## b
 #define ___apply(fn, n) ___concat(fn, n)
@@ -239,15 +241,17 @@ enum bpf_field_info_kind {
  *	int x =3D BPF_CORE_READ(s, a.b.c, d.e, f, g);
  *
  * BPF_CORE_READ will decompose above statement into 4 bpf_core_read (BP=
F
- * CO-RE relocatable bpf_probe_read() wrapper) calls, logically equivale=
nt to:
+ * CO-RE relocatable bpf_probe_read_kernel() wrapper) calls, logically
+ * equivalent to:
  * 1. const void *__t =3D s->a.b.c;
  * 2. __t =3D __t->d.e;
  * 3. __t =3D __t->f;
  * 4. return __t->g;
  *
  * Equivalence is logical, because there is a heavy type casting/preserv=
ation
- * involved, as well as all the reads are happening through bpf_probe_re=
ad()
- * calls using __builtin_preserve_access_index() to emit CO-RE relocatio=
ns.
+ * involved, as well as all the reads are happening through
+ * bpf_probe_read_kernel() calls using __builtin_preserve_access_index()=
 to
+ * emit CO-RE relocations.
  *
  * N.B. Only up to 9 "field accessors" are supported, which should be mo=
re
  * than enough for any practical purpose.
diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index eebf020cbe3e..f9ef37707888 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -289,9 +289,9 @@ struct pt_regs;
 #define BPF_KRETPROBE_READ_RET_IP		BPF_KPROBE_READ_RET_IP
 #else
 #define BPF_KPROBE_READ_RET_IP(ip, ctx)					    \
-	({ bpf_probe_read(&(ip), sizeof(ip), (void *)PT_REGS_RET(ctx)); })
+	({ bpf_probe_read_kernel(&(ip), sizeof(ip), (void *)PT_REGS_RET(ctx)); =
})
 #define BPF_KRETPROBE_READ_RET_IP(ip, ctx)				    \
-	({ bpf_probe_read(&(ip), sizeof(ip),				    \
+	({ bpf_probe_read_kernel(&(ip), sizeof(ip),			    \
 			  (void *)(PT_REGS_FP(ctx) + sizeof(ip))); })
 #endif
=20
--=20
2.24.1

