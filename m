Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9A22CE001
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 21:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731065AbgLCUtB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Dec 2020 15:49:01 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5772 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387656AbgLCUtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 15:49:01 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B3KdaOH002372
        for <netdev@vger.kernel.org>; Thu, 3 Dec 2020 12:48:19 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 356ajcm398-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 12:48:19 -0800
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Dec 2020 12:48:14 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id AA8C32ECA8BF; Thu,  3 Dec 2020 12:48:10 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v6 bpf-next 07/14] selftests/bpf: add support for marking sub-tests as skipped
Date:   Thu, 3 Dec 2020 12:46:27 -0800
Message-ID: <20201203204634.1325171-8-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201203204634.1325171-1-andrii@kernel.org>
References: <20201203204634.1325171-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_12:2020-12-03,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxscore=0 suspectscore=25 spamscore=0 phishscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=833 malwarescore=0
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030121
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

