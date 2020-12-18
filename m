Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC112DEC2D
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 00:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgLRX5J convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 18 Dec 2020 18:57:09 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28360 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726089AbgLRX5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 18:57:09 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BINsC2t013124
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 15:56:29 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35gxe5jqc9-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 15:56:28 -0800
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 18 Dec 2020 15:56:25 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id DCD272ECB8FE; Fri, 18 Dec 2020 15:56:20 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 2/3] libbpf: add non-CO-RE variants of BPF_CORE_READ() macro family
Date:   Fri, 18 Dec 2020 15:56:13 -0800
Message-ID: <20201218235614.2284956-3-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201218235614.2284956-1-andrii@kernel.org>
References: <20201218235614.2284956-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-18_14:2020-12-18,2020-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 spamscore=0 clxscore=1034 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=582 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180163
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF_CORE_READ(), in addition to handling CO-RE relocations, also allows much
nicer way to read data structures with nested pointers. Instead of writing
a sequence of bpf_probe_read() calls to follow links, one can just write
BPF_CORE_READ(a, b, c, d) to effectively do a->b->c->d read. This is a welcome
ability when porting BCC code, which (in most cases) allows exactly the
intuitive a->b->c->d variant.

This patch adds non-CO-RE variants of BPF_CORE_READ() family of macros for
cases where CO-RE is not supported (e.g., old kernels). In such cases, the
property of shortening a sequence of bpf_probe_read()s to a simple
BPF_PROBE_READ(a, b, c, d) invocation is still desirable, especially when
porting BCC code to libbpf. Yet, no CO-RE relocation is going to be emitted.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/bpf_core_read.h | 38 +++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/tools/lib/bpf/bpf_core_read.h b/tools/lib/bpf/bpf_core_read.h
index db0c735ceb53..9456aabcb03a 100644
--- a/tools/lib/bpf/bpf_core_read.h
+++ b/tools/lib/bpf/bpf_core_read.h
@@ -308,6 +308,18 @@ enum bpf_enum_value_kind {
 		     dst, (src), a, ##__VA_ARGS__)			    \
 })
 
+/* Non-CO-RE variant of BPF_CORE_READ_INTO() */
+#define BPF_PROBE_READ_INTO(dst, src, a, ...) ({			    \
+	___core_read(bpf_probe_read, bpf_probe_read,			    \
+		     dst, (src), a, ##__VA_ARGS__)			    \
+})
+
+/* Non-CO-RE variant of BPF_CORE_READ_USER_INTO() */
+#define BPF_PROBE_READ_USER_INTO(dst, src, a, ...) ({			    \
+	___core_read(bpf_probe_read_user, bpf_probe_read_user,		    \
+		     dst, (src), a, ##__VA_ARGS__)			    \
+})
+
 /*
  * BPF_CORE_READ_STR_INTO() does same "pointer chasing" as
  * BPF_CORE_READ() for intermediate pointers, but then executes (and returns
@@ -324,6 +336,18 @@ enum bpf_enum_value_kind {
 		     dst, (src), a, ##__VA_ARGS__)			    \
 })
 
+/* Non-CO-RE variant of BPF_CORE_READ_STR_INTO() */
+#define BPF_PROBE_READ_STR_INTO(dst, src, a, ...) ({			    \
+	___core_read(bpf_probe_read_str, bpf_probe_read,		    \
+		     dst, (src), a, ##__VA_ARGS__)			    \
+})
+
+/* Non-CO-RE variant of BPF_CORE_READ_USER_STR_INTO() */
+#define BPF_PROBE_READ_USER_STR_INTO(dst, src, a, ...) ({		    \
+	___core_read(bpf_probe_read_user_str, bpf_probe_read_user,	    \
+		     dst, (src), a, ##__VA_ARGS__)			    \
+})
+
 /*
  * BPF_CORE_READ() is used to simplify BPF CO-RE relocatable read, especially
  * when there are few pointer chasing steps.
@@ -361,5 +385,19 @@ enum bpf_enum_value_kind {
 	__r;								    \
 })
 
+/* Non-CO-RE variant of BPF_CORE_READ() */
+#define BPF_PROBE_READ(src, a, ...) ({					    \
+	___type((src), a, ##__VA_ARGS__) __r;				    \
+	BPF_PROBE_READ_INTO(&__r, (src), a, ##__VA_ARGS__);		    \
+	__r;								    \
+})
+
+/* Non-CO-RE variant of BPF_CORE_READ_USER() */
+#define BPF_PROBE_READ_USER(src, a, ...) ({				    \
+	___type((src), a, ##__VA_ARGS__) __r;				    \
+	BPF_PROBE_READ_USER_INTO(&__r, (src), a, ##__VA_ARGS__);	    \
+	__r;								    \
+})
+
 #endif
 
-- 
2.24.1

