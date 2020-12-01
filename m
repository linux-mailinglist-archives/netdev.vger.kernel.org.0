Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAD02C9402
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 01:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389173AbgLAAcr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 30 Nov 2020 19:32:47 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9870 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389163AbgLAAcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 19:32:47 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B10TloF004997
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 16:32:05 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 354affyued-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 16:32:05 -0800
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 16:32:04 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id D90262ECA5FC; Mon, 30 Nov 2020 16:31:57 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 6/7] selftests/bpf: add support for marking sub-tests as skipped
Date:   Mon, 30 Nov 2020 16:31:36 -0800
Message-ID: <20201201003137.1692914-7-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201201003137.1692914-1-andrii@kernel.org>
References: <20201201003137.1692914-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_12:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 bulkscore=0
 mlxlogscore=840 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=25
 clxscore=1015 priorityscore=1501 phishscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously skipped sub-tests would be counted as passing with ":OK" appened
in the log. Change that to be accounted as ":SKIP".

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 17587754b7a7..5ef081bdae4e 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -149,15 +149,15 @@ void test__end_subtest()
 
 	if (sub_error_cnt)
 		env.fail_cnt++;
-	else
+	else if (test->skip_cnt == 0)
 		env.sub_succ_cnt++;
 	skip_account();
 
 	dump_test_log(test, sub_error_cnt);
 
 	fprintf(env.stdout, "#%d/%d %s:%s\n",
-	       test->test_num, test->subtest_num,
-	       test->subtest_name, sub_error_cnt ? "FAIL" : "OK");
+	       test->test_num, test->subtest_num, test->subtest_name,
+	       sub_error_cnt ? "FAIL" : (test->skip_cnt ? "SKIP" : "OK"));
 
 	free(test->subtest_name);
 	test->subtest_name = NULL;
-- 
2.24.1

