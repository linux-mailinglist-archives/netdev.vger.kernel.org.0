Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83F1D7B0FB
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 19:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387579AbfG3R5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 13:57:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13724 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387530AbfG3R5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 13:57:14 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6UHlNHt020746
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 10:57:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=AUAufsu9mVmhXWJi53/lbye/2/dyCjbxIWFWIy+YTv0=;
 b=Bi4j03K+lkiQY4FqzwB8/O3vet2hYHB15gzFmHqu+MAOveQq1MzwdsNAxNVyqWuDruy+
 +KK0GvXDuuYzpCBtqnx+R1r7h9Pwv7YsaW67/e4/SmPYvdKPCJYk9LScA3lBR3k5zDE8
 nGnhCT1LerHOktI7nF8kQmNAXvMbPSNxoTc= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2u2gk2t4r8-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 10:57:13 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 30 Jul 2019 10:57:08 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id ECA2F861675; Tue, 30 Jul 2019 10:56:59 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next] selftests/bpf: fix clearing buffered output between tests/subtests
Date:   Tue, 30 Jul 2019 10:56:52 -0700
Message-ID: <20190730175652.181547-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-30_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=954 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907300187
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clear buffered output once test or subtests finishes even if test was
successful. Not doing this leads to accumulation of output from previous
tests and on first failed tests lots of irrelevant output will be
dumped, greatly confusing things.

Fixed: 3a516a0a3a7b ("selftests/bpf: add sub-tests support for test_progs")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/test_progs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 546d99b3ec34..db00196c8315 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -46,8 +46,8 @@ static void dump_test_log(const struct prog_test_def *test, bool failed)
 			if (env.log_buf[env.log_cnt - 1] != '\n')
 				fprintf(stdout, "\n");
 		}
-		env.log_cnt = 0;
 	}
+	env.log_cnt = 0;
 }
 
 void test__end_subtest()
-- 
2.17.1

