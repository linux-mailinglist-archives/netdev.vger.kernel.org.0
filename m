Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C63F77B63
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 21:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388237AbfG0TCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 15:02:20 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44380 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388222AbfG0TCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 15:02:16 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6RIxnPo008430
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 12:02:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=nFRgnH9mQPN+sVp1HVKIA2YU5tTgpJRhti1w1Ct/vNg=;
 b=AT2oKFf5W1VsQiFcTWY7QMujwFTTG4n6DQmfldkcgum3OrF8JmVrjUfo1+UUdV4WhQa/
 asyzm6wBa33ZbR/r6f+227ZTVLm5fm4SAQ3+Vin3fib7G5SDVCG538t4KIudnHFdXJE9
 Y6VPRaOFRx5gZo3JedRKkhe/4esVVY+vDA8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u0jn3hbu3-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 12:02:15 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sat, 27 Jul 2019 12:02:14 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 23EBD861672; Sat, 27 Jul 2019 12:02:12 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <sdf@fomichev.me>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 9/9] selftests/bpf: convert send_signal.c to use subtests
Date:   Sat, 27 Jul 2019 12:01:50 -0700
Message-ID: <20190727190150.649137-10-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190727190150.649137-1-andriin@fb.com>
References: <20190727190150.649137-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-27_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=670 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907270238
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

