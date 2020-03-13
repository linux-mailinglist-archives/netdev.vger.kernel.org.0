Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 459381840D1
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 07:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgCMGSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 02:18:42 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2546 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726299AbgCMGSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 02:18:42 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 02D6Fg7Q004238
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 23:18:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=wpUtVqAQJbpIzB+P5uZAyP2Oh+c7swHcHj/HJQEwnm4=;
 b=dcMQcEKU0Yy6yaeNTUaLnrkUng5V726BoVo4tB4JwSqlHdHUP63GQn4RWNJU5kbMAGKg
 ra4xvXMbUtWOUBJR+BzpAv3FfzhJbbL4/8RRYbOmQjZ2WjnTr3yV3yp/KIU6La/pj1ta
 alFZHkLYUh+Nxf/ooIhrhXsaO+ixhSTUv4I= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2yqt7eamkv-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 23:18:41 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 12 Mar 2020 23:18:40 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A86002EC2EB3; Thu, 12 Mar 2020 23:18:38 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] selftests/bpf: fix usleep() implementation
Date:   Thu, 12 Mar 2020 23:18:37 -0700
Message-ID: <20200313061837.3685572-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_02:2020-03-11,2020-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 phishscore=0 bulkscore=0 clxscore=1015
 adultscore=0 impostorscore=0 mlxlogscore=729 spamscore=0 malwarescore=0
 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003130035
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nanosleep syscall expects pointer to struct timespec, not nanoseconds
directly. Current implementation fulfills its purpose of invoking nanosleep
syscall, but doesn't really provide sleeping capabilities, which can cause
flakiness for tests relying on usleep() to wait for something.

Fixes: ec12a57b822c ("selftests/bpf: Guarantee that useep() calls nanosleep() syscall")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/test_progs.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 2b0bc1171c9c..b6201dd82edf 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -35,7 +35,16 @@ struct prog_test_def {
  */
 int usleep(useconds_t usec)
 {
-	return syscall(__NR_nanosleep, usec * 1000UL);
+	struct timespec ts;
+
+	if (usec > 999999) {
+		ts.tv_sec = usec / 1000000;
+		ts.tv_nsec = usec % 1000000;
+	} else {
+		ts.tv_sec = 0;
+		ts.tv_nsec = usec;
+	}
+	return nanosleep(&ts, NULL);
 }
 
 static bool should_run(struct test_selector *sel, int num, const char *name)
-- 
2.17.1

