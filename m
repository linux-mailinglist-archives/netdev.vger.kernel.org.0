Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B90131C81C0
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 07:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgEGFkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 01:40:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56812 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727051AbgEGFjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 01:39:49 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0475dk1G007958
        for <netdev@vger.kernel.org>; Wed, 6 May 2020 22:39:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=o511e/TxFuc20lRIwpO4Z+NkPnYwIvJ7kLN1VyZOyA8=;
 b=MgjVusAc6yTopNIOORglLwGZWs3v6+QZTcx25asvm478gh7khYpoyoUUg9Etlkga3N0W
 2Os98t96VVw+n/L8/XSVk3Ap6Honsjp0qiSxOJvHz4vGe+IyYlCiUz7S0l9QDojVjnwx
 /QsoAQD9yZQs9QlvqvLfTMesTBlKtViOmGM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30v0hp3gwd-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 22:39:48 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 6 May 2020 22:39:37 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 790313701B99; Wed,  6 May 2020 22:39:35 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v3 17/21] tools/libpf: add offsetof/container_of macro in bpf_helpers.h
Date:   Wed, 6 May 2020 22:39:35 -0700
Message-ID: <20200507053935.1545181-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200507053915.1542140-1-yhs@fb.com>
References: <20200507053915.1542140-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-07_02:2020-05-05,2020-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 mlxscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 phishscore=0 spamscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070044
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These two helpers will be used later in bpf_iter bpf program
bpf_iter_netlink.c. Put them in bpf_helpers.h since they could
be useful in other cases.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/lib/bpf/bpf_helpers.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index da00b87aa199..f67dce2af802 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -36,6 +36,20 @@
 #define __weak __attribute__((weak))
 #endif
=20
+/*
+ * Helper macro to manipulate data structures
+ */
+#ifndef offsetof
+#define offsetof(TYPE, MEMBER)  ((size_t)&((TYPE *)0)->MEMBER)
+#endif
+#ifndef container_of
+#define container_of(ptr, type, member)				\
+	({							\
+		void *__mptr =3D (void *)(ptr);			\
+		((type *)(__mptr - offsetof(type, member)));	\
+	})
+#endif
+
 /*
  * Helper structure used by eBPF C program
  * to describe BPF map attributes to libbpf loader
--=20
2.24.1

