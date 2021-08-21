Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5B23F3838
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 04:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241032AbhHUDAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 23:00:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31604 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241012AbhHUDAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 23:00:09 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17L2pAiu011366
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 19:59:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=kjxoTvvbtdKtm++ybFFEOg5xUoaDxGTFS2ZQmkmKJ70=;
 b=aPbHsuuDmjBPan4LhD/uJRbKYxnnRywY3faenm/vXjRmcxOu6F4+Q3OGxgyS0ely58Wc
 TGyEa0dc+nHhFx5ZCTMYLvcUzx40CMhDwgDMLJdcn9eg7iaLvPEKidCRRKXebmoMcekU
 qkPVsDczHAJkULN1KNfkIx4X20V6+KYmyzo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3ajfuh2x6a-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 19:59:30 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 20 Aug 2021 19:59:14 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id 1421057300B2; Fri, 20 Aug 2021 19:59:10 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Florent Revest <revest@chromium.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH bpf-next 3/5] libbpf: Add bpf_vprintk convenience macro
Date:   Fri, 20 Aug 2021 19:58:35 -0700
Message-ID: <20210821025837.1614098-4-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210821025837.1614098-1-davemarchevsky@fb.com>
References: <20210821025837.1614098-1-davemarchevsky@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: IP7HEx3Dc4fQkk_SPH-KCaUcwDeC07J8
X-Proofpoint-ORIG-GUID: IP7HEx3Dc4fQkk_SPH-KCaUcwDeC07J8
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-20_11:2021-08-20,2021-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 suspectscore=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 mlxlogscore=959 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108210016
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_vprintk functions similarly to BPF_SEQ_PRINTF and BPF_SNPRINTF
macros elsewhere in the file - it allows use of bpf_trace_vprintk
without manual conversion of varargs to u64 array.

Like the bpf_printk macro, bpf_vprintk is meant to be the main interface
to the bpf_trace_vprintk helper and thus is uncapitalized.

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
---
 tools/lib/bpf/bpf_helpers.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index b9987c3efa3c..43c8115956c3 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -224,4 +224,22 @@ enum libbpf_tristate {
 		     ___param, sizeof(___param));		\
 })
=20
+/*
+ * bpf_vprintk wraps the bpf_trace_printk helper with variadic arguments
+ * instead of an array of u64.
+ */
+#define bpf_vprintk(fmt, args...)				\
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
 #endif
--=20
2.30.2

