Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D273F7CEF
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 21:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242517AbhHYT7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 15:59:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50028 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242507AbhHYT7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 15:59:30 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17PJpONr008913
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 12:58:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=zMLxDb4KnCnHDg/fz+i9Y5/zBLd+vVuW8ncpktLpjm8=;
 b=F1YW6UXBQFKE8dNc1T0tuAcMnAjDrmC9c0XhP0QtoqmPK0RgLATeciddB7lpvVA2PmP3
 ndWONwXUWZCJxtcBSqgqiI6xS/R0d062t3vK5sDKmVNhU48LDXUH9ZMxZfpdP5QSHFrA
 sR2dr7IATXqahF1nUTOyDSgIT+rScOC0fb0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3an5sm894f-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 12:58:44 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 25 Aug 2021 12:58:43 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id 245115A34ED9; Wed, 25 Aug 2021 12:58:37 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, <netdev@vger.kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH v2 bpf-next 3/6] libbpf: Modify bpf_printk to choose helper based on arg count
Date:   Wed, 25 Aug 2021 12:58:20 -0700
Message-ID: <20210825195823.381016-4-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210825195823.381016-1-davemarchevsky@fb.com>
References: <20210825195823.381016-1-davemarchevsky@fb.com>
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: Lkr36jhIch-SBTEzApAE2bkrzqzZ_iBI
X-Proofpoint-ORIG-GUID: Lkr36jhIch-SBTEzApAE2bkrzqzZ_iBI
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-25_07:2021-08-25,2021-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 clxscore=1015 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108250117
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of being a thin wrapper which calls into bpf_trace_printk,
libbpf's bpf_printk convenience macro now chooses between
bpf_trace_printk and bpf_trace_vprintk. If the arg count (excluding
format string) is >3, use bpf_trace_vprintk, otherwise use the older
helper.

The motivation behind this added complexity - instead of migrating
entirely to bpf_trace_vprintk - is to maintain good developer experience
for users compiling against new libbpf but running on older kernels.
Users who are passing <=3D3 args to bpf_printk will see no change in their
bytecode.

__bpf_vprintk functions similarly to BPF_SEQ_PRINTF and BPF_SNPRINTF
macros elsewhere in the file - it allows use of bpf_trace_vprintk
without manual conversion of varargs to u64 array. Previous
implementation of bpf_printk macro is moved to __bpf_printk for use by
the new implementation.

This does change behavior of bpf_printk calls with >3 args in the "new
libbpf, old kernels" scenario. On my system, using a clang built from
recent upstream sources (14.0.0 https://github.com/llvm/llvm-project.git
50b62731452cb83979bbf3c06e828d26a4698dca), attempting to use 4 args to
__bpf_printk (old impl) results in a compile-time error:

  progs/trace_printk.c:21:21: error: too many args to 0x6cdf4b8: i64 =3D Co=
nstant<6>
        trace_printk_ret =3D __bpf_printk("testing,testing %d %d %d %d\n",

I was able to replicate this behavior with an older clang as well. When
the format string has >3 format specifiers, there is no output to the
trace_pipe in either case.

After this patch, using bpf_printk with 4 args would result in a
trace_vprintk helper call being emitted and a load-time failure on older
kernels.

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
---
 tools/lib/bpf/bpf_helpers.h | 45 ++++++++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index b9987c3efa3c..5f087306cdfe 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -14,14 +14,6 @@
 #define __type(name, val) typeof(val) *name
 #define __array(name, val) typeof(val) *name[]
=20
-/* Helper macro to print out debug messages */
-#define bpf_printk(fmt, ...)				\
-({							\
-	char ____fmt[] =3D fmt;				\
-	bpf_trace_printk(____fmt, sizeof(____fmt),	\
-			 ##__VA_ARGS__);		\
-})
-
 /*
  * Helper macro to place programs, maps, license in
  * different sections in elf_bpf file. Section names
@@ -224,4 +216,41 @@ enum libbpf_tristate {
 		     ___param, sizeof(___param));		\
 })
=20
+/* Helper macro to print out debug messages */
+#define __bpf_printk(fmt, ...)				\
+({							\
+	char ____fmt[] =3D fmt;				\
+	bpf_trace_printk(____fmt, sizeof(____fmt),	\
+			 ##__VA_ARGS__);		\
+})
+
+/*
+ * __bpf_vprintk wraps the bpf_trace_vprintk helper with variadic arguments
+ * instead of an array of u64.
+ */
+#define __bpf_vprintk(fmt, args...)				\
+({								\
+	static const char ___fmt[] =3D fmt;			\
+	unsigned long long ___param[___bpf_narg(args)];		\
+								\
+	_Pragma("GCC diagnostic push")				\
+	_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")	\
+	___bpf_fill(___param, args);				\
+	_Pragma("GCC diagnostic pop")				\
+								\
+	bpf_trace_vprintk(___fmt, sizeof(___fmt),		\
+		     ___param, sizeof(___param));		\
+})
+
+#define ___bpf_pick_printk(...) \
+	___bpf_nth(_, ##__VA_ARGS__, __bpf_vprintk, __bpf_vprintk, __bpf_vprintk,=
	\
+		__bpf_vprintk, __bpf_vprintk, __bpf_vprintk, __bpf_vprintk,		\
+		__bpf_vprintk, __bpf_vprintk, __bpf_printk, __bpf_printk,		\
+		__bpf_printk, __bpf_printk)
+
+#define bpf_printk(fmt, args...)		\
+({						\
+	___bpf_pick_printk(args)(fmt, args);	\
+})
+
 #endif
--=20
2.30.2

