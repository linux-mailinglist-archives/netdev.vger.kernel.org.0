Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671142CE32C
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 00:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbgLCXze convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Dec 2020 18:55:34 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14012 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727175AbgLCXzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 18:55:33 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B3NkgBf003350
        for <netdev@vger.kernel.org>; Thu, 3 Dec 2020 15:54:52 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 357159v8fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 15:54:52 -0800
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Dec 2020 15:54:51 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id D4F062ECA8F6; Thu,  3 Dec 2020 15:54:50 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 2/2] selftests/bpf: fix invalid use of strncat in test_sockmap
Date:   Thu, 3 Dec 2020 15:54:40 -0800
Message-ID: <20201203235440.2302137-2-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201203235440.2302137-1-andrii@kernel.org>
References: <20201203235440.2302137-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_15:2020-12-03,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 mlxlogscore=999 clxscore=1034 lowpriorityscore=0 suspectscore=8
 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0 priorityscore=1501
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012030131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

strncat()'s third argument is how many bytes will be added *in addition* to
already existing bytes in destination. Plus extra zero byte will be added
after that. So existing use in test_sockmap has many opportunities to overflow
the string and cause memory corruptions. And in this case, GCC complains for
a good reason.

Fixes: 16962b2404ac ("bpf: sockmap, add selftests")
Fixes: 73563aa3d977 ("selftests/bpf: test_sockmap, print additional test options")
Fixes: 1ade9abadfca ("bpf: test_sockmap, add options for msg_pop_data() helper")
Fixes: 463bac5f1ca7 ("bpf, selftests: Add test for ktls with skb bpf ingress policy")
Fixes: e9dd904708c4 ("bpf: add tls support for testing in test_sockmap")
Fixes: 753fb2ee0934 ("bpf: sockmap, add msg_peek tests to test_sockmap")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/test_sockmap.c | 36 ++++++++++++++--------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 0fa1e421c3d7..427ca00a3217 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -1273,6 +1273,16 @@ static char *test_to_str(int test)
 	return "unknown";
 }
 
+static void append_str(char *dst, const char *src, size_t dst_cap)
+{
+	size_t avail = dst_cap - strlen(dst);
+
+	if (avail <= 1) /* just zero byte could be written */
+		return;
+
+	strncat(dst, src, avail - 1); /* strncat() adds + 1 for zero byte */
+}
+
 #define OPTSTRING 60
 static void test_options(char *options)
 {
@@ -1281,42 +1291,42 @@ static void test_options(char *options)
 	memset(options, 0, OPTSTRING);
 
 	if (txmsg_pass)
-		strncat(options, "pass,", OPTSTRING);
+		append_str(options, "pass,", OPTSTRING);
 	if (txmsg_redir)
-		strncat(options, "redir,", OPTSTRING);
+		append_str(options, "redir,", OPTSTRING);
 	if (txmsg_drop)
-		strncat(options, "drop,", OPTSTRING);
+		append_str(options, "drop,", OPTSTRING);
 	if (txmsg_apply) {
 		snprintf(tstr, OPTSTRING, "apply %d,", txmsg_apply);
-		strncat(options, tstr, OPTSTRING);
+		append_str(options, tstr, OPTSTRING);
 	}
 	if (txmsg_cork) {
 		snprintf(tstr, OPTSTRING, "cork %d,", txmsg_cork);
-		strncat(options, tstr, OPTSTRING);
+		append_str(options, tstr, OPTSTRING);
 	}
 	if (txmsg_start) {
 		snprintf(tstr, OPTSTRING, "start %d,", txmsg_start);
-		strncat(options, tstr, OPTSTRING);
+		append_str(options, tstr, OPTSTRING);
 	}
 	if (txmsg_end) {
 		snprintf(tstr, OPTSTRING, "end %d,", txmsg_end);
-		strncat(options, tstr, OPTSTRING);
+		append_str(options, tstr, OPTSTRING);
 	}
 	if (txmsg_start_pop) {
 		snprintf(tstr, OPTSTRING, "pop (%d,%d),",
 			 txmsg_start_pop, txmsg_start_pop + txmsg_pop);
-		strncat(options, tstr, OPTSTRING);
+		append_str(options, tstr, OPTSTRING);
 	}
 	if (txmsg_ingress)
-		strncat(options, "ingress,", OPTSTRING);
+		append_str(options, "ingress,", OPTSTRING);
 	if (txmsg_redir_skb)
-		strncat(options, "redir_skb,", OPTSTRING);
+		append_str(options, "redir_skb,", OPTSTRING);
 	if (txmsg_ktls_skb)
-		strncat(options, "ktls_skb,", OPTSTRING);
+		append_str(options, "ktls_skb,", OPTSTRING);
 	if (ktls)
-		strncat(options, "ktls,", OPTSTRING);
+		append_str(options, "ktls,", OPTSTRING);
 	if (peek_flag)
-		strncat(options, "peek,", OPTSTRING);
+		append_str(options, "peek,", OPTSTRING);
 }
 
 static int __test_exec(int cgrp, int test, struct sockmap_options *opt)
-- 
2.24.1

