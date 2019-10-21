Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3E8DE29F
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 05:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbfJUDjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 23:39:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35940 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727020AbfJUDjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 23:39:19 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9L3SH41008459
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 20:39:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=oF2Mny3FBAuW1n/mdu6LspK0/eaqpl9kmCSOrnW9N6I=;
 b=LSRyBUCcMMSQNIIiDUhYr/oe/uBBiRv5VXoYVqHlpljWiaDE0hG+HOMBJ18PWPUiZclf
 EDl3gmH33potDXLHfcpxVdnKTz4OnzMv0p1NXTcfw8IgzUhNuY3+S4MaC0hiO8yrikcE
 ueE4a+5f5VmqOdGFic1XqOFBGVUwP7evMbE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vrj6sjgpk-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 20:39:18 -0700
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sun, 20 Oct 2019 20:39:16 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 1BAF1861976; Sun, 20 Oct 2019 20:39:16 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 5/7] selftests/bpf: make a copy of subtest name
Date:   Sun, 20 Oct 2019 20:39:00 -0700
Message-ID: <20191021033902.3856966-6-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191021033902.3856966-1-andriin@fb.com>
References: <20191021033902.3856966-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-21_01:2019-10-18,2019-10-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=25
 adultscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910210029
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

test_progs never created a copy of subtest name, rather just stored
pointer to whatever string test provided. This is bad as that string
might be freed or modified by the end of subtest. Fix this by creating
a copy of given subtest name when subtest starts.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/test_progs.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index c7e52f4194e2..a05a807840c0 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -20,7 +20,7 @@ struct prog_test_def {
 	bool tested;
 	bool need_cgroup_cleanup;
 
-	const char *subtest_name;
+	char *subtest_name;
 	int subtest_num;
 
 	/* store counts before subtest started */
@@ -81,16 +81,17 @@ void test__end_subtest()
 	fprintf(env.stdout, "#%d/%d %s:%s\n",
 	       test->test_num, test->subtest_num,
 	       test->subtest_name, sub_error_cnt ? "FAIL" : "OK");
+
+	free(test->subtest_name);
+	test->subtest_name = NULL;
 }
 
 bool test__start_subtest(const char *name)
 {
 	struct prog_test_def *test = env.test;
 
-	if (test->subtest_name) {
+	if (test->subtest_name)
 		test__end_subtest();
-		test->subtest_name = NULL;
-	}
 
 	test->subtest_num++;
 
@@ -104,7 +105,13 @@ bool test__start_subtest(const char *name)
 	if (!should_run(&env.subtest_selector, test->subtest_num, name))
 		return false;
 
-	test->subtest_name = name;
+	test->subtest_name = strdup(name);
+	if (!test->subtest_name) {
+		fprintf(env.stderr,
+			"Subtest #%d: failed to copy subtest name!\n",
+			test->subtest_num);
+		return false;
+	}
 	env.test->old_error_cnt = env.test->error_cnt;
 
 	return true;
-- 
2.17.1

