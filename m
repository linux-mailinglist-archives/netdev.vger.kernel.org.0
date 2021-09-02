Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2AD3FF23C
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 19:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346565AbhIBRX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 13:23:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28942 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346471AbhIBRX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 13:23:57 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 182HMp6h021623
        for <netdev@vger.kernel.org>; Thu, 2 Sep 2021 10:22:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=A703s80OCzWJhuJ4WRoud7sGEQlkBMLUoJ9S7q8raJE=;
 b=kzcNS+kWyt6sQA4Gjduf3X9zOx2heR8lGvT4wEf/nC38fDE8dSl0QAbTjSILeFlnO2EJ
 iX9NcMhmSz2eRc5y4oLZQzdCTHSNIlVX1fkV8BNrnsXJzpgzhBjC1D9828h5ApDM/YeS
 KZzgk+wdsWdxjqfDP5WfpxGjiKZhnhhmHhU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3atdx7x41q-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 10:22:58 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 2 Sep 2021 10:22:56 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id 80CD45FE2487; Thu,  2 Sep 2021 10:19:59 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, <netdev@vger.kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH v4 bpf-next 4/9] libbpf: Modify bpf_printk to choose helper based on arg count
Date:   Thu, 2 Sep 2021 10:19:24 -0700
Message-ID: <20210902171929.3922667-5-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210902171929.3922667-1-davemarchevsky@fb.com>
References: <20210902171929.3922667-1-davemarchevsky@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: TZbPeoepyhal5lGfIe_JN77CIn9YMke1
X-Proofpoint-ORIG-GUID: TZbPeoepyhal5lGfIe_JN77CIn9YMke1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-02_04:2021-09-02,2021-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 spamscore=0 phishscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109020100
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
Users who are passing <=3D3 args to bpf_printk will see no change in thei=
r
bytecode.

__bpf_vprintk functions similarly to BPF_SEQ_PRINTF and BPF_SNPRINTF
macros elsewhere in the file - it allows use of bpf_trace_vprintk
without manual conversion of varargs to u64 array. Previous
implementation of bpf_printk macro is moved to __bpf_printk for use by
the new implementation.

This does change behavior of bpf_printk calls with >3 args in the "new
libbpf, old kernels" scenario. Before this patch, attempting to use 4
args to bpf_printk results in a compile-time error. After this patch,
using bpf_printk with 4 args results in a trace_vprintk helper call
being emitted and a load-time failure on older kernels.

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
---
 tools/lib/bpf/bpf_helpers.h | 45 ++++++++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index b9987c3efa3c..a7e73be6dac4 100644
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
+ * __bpf_vprintk wraps the bpf_trace_vprintk helper with variadic argume=
nts
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
+			  ___param, sizeof(___param));		\
+})
+
+/* Use __bpf_printk when bpf_printk call has 3 or fewer fmt args
+ * Otherwise use __bpf_vprintk
+ */
+#define ___bpf_pick_printk(...) \
+	___bpf_nth(_, ##__VA_ARGS__, __bpf_vprintk, __bpf_vprintk, __bpf_vprint=
k,	\
+		   __bpf_vprintk, __bpf_vprintk, __bpf_vprintk, __bpf_vprintk,		\
+		   __bpf_vprintk, __bpf_vprintk, __bpf_printk /*3*/, __bpf_printk /*2*=
/,\
+		   __bpf_printk /*1*/, __bpf_printk /*0*/)
+
+#define bpf_printk(fmt, args...) ___bpf_pick_printk(args)(fmt, ##args)
+
 #endif
--=20
2.30.2

