Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C4D3FA3D6
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 07:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbhH1FV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 01:21:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12590 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232994AbhH1FVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 01:21:20 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17S5BXuk010217
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 22:20:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ggS2YXj1zpYNXrAy5OVy51eWkVxG9q9EVk6h1JnHn8U=;
 b=PpMPUV/mMTsB5RFPtNlN1vUGMZY4FRiff2a0QY1BP+s3dDPGI60lLivwIcji8bKxKfvx
 R5eZWLsRPSneh6VtXjsbJP9JbT+KAetxZjEGzQ4vvG/c5SDYxvUGTtQtcaufoasVcMvR
 GHUllh5CBOml3kFItRhpkn5e+3uotR2tmQg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3aq1xd4afv-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 22:20:31 -0700
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 27 Aug 2021 22:20:29 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id 56E2E5BF0E32; Fri, 27 Aug 2021 22:20:23 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, <netdev@vger.kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH v3 bpf-next 4/7] libbpf: use static const fmt string in __bpf_printk
Date:   Fri, 27 Aug 2021 22:20:03 -0700
Message-ID: <20210828052006.1313788-5-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210828052006.1313788-1-davemarchevsky@fb.com>
References: <20210828052006.1313788-1-davemarchevsky@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: StMSX9_2IPTb1UvdgwDSxBKR-EYgU0Uy
X-Proofpoint-GUID: StMSX9_2IPTb1UvdgwDSxBKR-EYgU0Uy
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-28_01:2021-08-27,2021-08-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 malwarescore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1015
 bulkscore=0 mlxlogscore=972 suspectscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108280031
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The __bpf_printk convenience macro was using a 'char' fmt string holder
as it predates support for globals in libbpf. Move to more efficient
'static const char', but provide a fallback to the old way via
BPF_NO_GLOBAL_DATA so users on old kernels can still use the macro.

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
---
 tools/lib/bpf/bpf_helpers.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index 5f087306cdfe..a1d5ec6f285c 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -216,10 +216,16 @@ enum libbpf_tristate {
 		     ___param, sizeof(___param));		\
 })
=20
+#ifdef BPF_NO_GLOBAL_DATA
+#define BPF_PRINTK_FMT_TYPE char
+#else
+#define BPF_PRINTK_FMT_TYPE static const char
+#endif
+
 /* Helper macro to print out debug messages */
 #define __bpf_printk(fmt, ...)				\
 ({							\
-	char ____fmt[] =3D fmt;				\
+	BPF_PRINTK_FMT_TYPE ____fmt[] =3D fmt;		\
 	bpf_trace_printk(____fmt, sizeof(____fmt),	\
 			 ##__VA_ARGS__);		\
 })
--=20
2.30.2

