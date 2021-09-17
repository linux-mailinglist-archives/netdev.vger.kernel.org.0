Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6F240FF65
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 20:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242063AbhIQSbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 14:31:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20956 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S242007AbhIQSbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 14:31:16 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 18H9qOPN022750
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 11:29:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=B/JmWmcNKy6ICUZ29pbwSrxh626rS/icdmMLYPXuUcY=;
 b=m6DD6lxqva18qwa1fHnxg04p7r62hTiRiprKuyb7eNTbIoCwFQdGAvE58TUT96TieP/s
 NgmVKL3ixyrWpo0rVhk1gfkR0AiqdMAklWvsOjND8n72dcbaOsgDDkYPnR5TNCisNB9f
 wW4VsR5hYXV25peU1qNEsWXUfq/gTrEDpnU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3b4rrnka7y-18
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 11:29:53 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 17 Sep 2021 11:29:47 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id 18B056BF31C7; Fri, 17 Sep 2021 11:29:17 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, <netdev@vger.kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH v6 bpf-next 4/9] libbpf: Modify bpf_printk to choose helper based on arg count
Date:   Fri, 17 Sep 2021 11:29:06 -0700
Message-ID: <20210917182911.2426606-5-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917182911.2426606-1-davemarchevsky@fb.com>
References: <20210917182911.2426606-1-davemarchevsky@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: whxqaXttIlQ5--aaVbFTmyDXNvztAwRD
X-Proofpoint-GUID: whxqaXttIlQ5--aaVbFTmyDXNvztAwRD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-17_07,2021-09-17_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 adultscore=0 malwarescore=0 impostorscore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 clxscore=1015 suspectscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109030001 definitions=main-2109170110
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

