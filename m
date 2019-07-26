Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48682772DF
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 22:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbfGZUiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 16:38:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18778 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727512AbfGZUiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 16:38:15 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6QKS8xu024251
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 13:38:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=nFRgnH9mQPN+sVp1HVKIA2YU5tTgpJRhti1w1Ct/vNg=;
 b=jMeh1VvIVqRL3HsuZTnG0V5vQlkQQgDHOSXDJpZFWNU89j2NdtAfBrPxZAl21VnLeUv5
 K6qhMFU8vkPkr9eGQPsEh7EqNCxqjI7CBYIXkY7RL3+UX3dNfJwlRoumMS6d6M5pYCn4
 87DJZByAE1sg6hBaAdhgyC+tc++eYSop4kk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u072d8ckn-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 13:38:14 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 26 Jul 2019 13:38:12 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 2EC20861663; Fri, 26 Jul 2019 13:38:11 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 9/9] selftests/bpf: convert send_signal.c to use subtests
Date:   Fri, 26 Jul 2019 13:37:47 -0700
Message-ID: <20190726203747.1124677-10-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190726203747.1124677-1-andriin@fb.com>
References: <20190726203747.1124677-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-26_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=675 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907260234
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert send_signal set of tests to be exposed as three sub-tests.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/prog_tests/send_signal.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/send_signal.c b/tools/testing/selftests/bpf/prog_tests/send_signal.c
index d950f4558897..461b423d0584 100644
--- a/tools/testing/selftests/bpf/prog_tests/send_signal.c
+++ b/tools/testing/selftests/bpf/prog_tests/send_signal.c
@@ -219,7 +219,10 @@ void test_send_signal(void)
 {
 	int ret = 0;
 
-	ret |= test_send_signal_tracepoint();
-	ret |= test_send_signal_perf();
-	ret |= test_send_signal_nmi();
+	if (test__start_subtest("send_signal_tracepoint"))
+		ret |= test_send_signal_tracepoint();
+	if (test__start_subtest("send_signal_perf"))
+		ret |= test_send_signal_perf();
+	if (test__start_subtest("send_signal_nmi"))
+		ret |= test_send_signal_nmi();
 }
-- 
2.17.1

