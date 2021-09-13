Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8AE40833D
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 05:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238556AbhIMD5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 23:57:51 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25062 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238565AbhIMD5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 23:57:45 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18D3SiKR001000
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 20:56:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=B/JmWmcNKy6ICUZ29pbwSrxh626rS/icdmMLYPXuUcY=;
 b=Ny6DePbscuU9GRs3f/tYo7GIV+riHpfj4qyiSYtnGebWA0JPeKAiCBNi5NYMfwTIPPli
 sG1TukBomjWhWQehNxSB3fL7dmFkoibj9NSdPJej7rQQHF8Zu1VcKPNHLKSyQRgUDVYx
 N0nZK5y9Y8TovRwBV7jJfkxBeUsn9gByC2U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3b1xs1r2rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 20:56:30 -0700
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Sun, 12 Sep 2021 20:56:29 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id 1D3EE68234CE; Sun, 12 Sep 2021 20:56:22 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, <netdev@vger.kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH v5 bpf-next 4/9] libbpf: Modify bpf_printk to choose helper based on arg count
Date:   Sun, 12 Sep 2021 20:56:04 -0700
Message-ID: <20210913035609.160722-5-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913035609.160722-1-davemarchevsky@fb.com>
References: <20210913035609.160722-1-davemarchevsky@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: Sl1B2kZ1dguSLJ8e-Wq2r9NAOOSJythV
X-Proofpoint-ORIG-GUID: Sl1B2kZ1dguSLJ8e-Wq2r9NAOOSJythV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-13_02,2021-09-09_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0 spamscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109130025
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
Acked-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/bpf_helpers.h | 45 ++++++++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index b9987c3efa3c..55a308796625 100644
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
+/* Helper macro to print out debug messages */
+#define bpf_printk(fmt, args...) ___bpf_pick_printk(args)(fmt, ##args)
+
 #endif
--=20
2.30.2

