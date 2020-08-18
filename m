Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8740324902E
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 23:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgHRVee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 17:34:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57480 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726874AbgHRVe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 17:34:29 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07ILYM5B000886
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 14:34:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=aEKN32479ug/zbl8v+pT/cWUU1hgpbXoIDmUhsC74dk=;
 b=drX7lYr53kZ1S76bt9JQG7TWHr/gcFr5BSD8WUEZFig7yCZnY1RsTyvjVHrEP+x26gMJ
 ztuPJxssQN1OcWgx+jvmR7i9yI6EGZWyAwvC7nGf2VUbnR4VWXPCFx5ZlkzRIr0U2oHV
 G4nkj9QA3f0UCTnRAdxf4m+n4Y5a6AFHsa0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3304jq55se-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 14:34:27 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 14:34:19 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id C68E42EC5EAC; Tue, 18 Aug 2020 14:34:14 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 6/7] libbpf: switch tracing and CO-RE helper macros to bpf_probe_read_kernel()
Date:   Tue, 18 Aug 2020 14:33:55 -0700
Message-ID: <20200818213356.2629020-7-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200818213356.2629020-1-andriin@fb.com>
References: <20200818213356.2629020-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_15:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 suspectscore=8 phishscore=0 spamscore=0
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180154
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

