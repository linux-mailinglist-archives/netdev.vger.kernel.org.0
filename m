Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4242D18534A
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 01:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbgCNA1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 20:27:55 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22980 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726853AbgCNA1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 20:27:55 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02E0CA1n021618
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 17:27:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=YTjaTHu2n5GJzTk4Ic/xTsGWvouGB609SEkVKC8tbNk=;
 b=Jh+CpYi5RNb7Cban2yuC3wm+6mJBDKr2aVdP+YgZRCYHq9En0yPPpV5o7+M55d+TE9so
 1XScPjCdO16f1XaOPl8+pTInshJNKrZxyf077XPUJuF0hQQWYyq+Q7+xb2zvycCwtXFl
 7cFHn5RyVgLE17hLu3NHQxA/1wh716gQ3n8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yqt80y3aq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 17:27:54 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 13 Mar 2020 17:27:52 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 6984B2EC2D5E; Fri, 13 Mar 2020 17:27:47 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next] selftests/bpf: fix nanosleep for real this time
Date:   Fri, 13 Mar 2020 17:27:43 -0700
Message-ID: <20200314002743.3782677-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_12:2020-03-12,2020-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 malwarescore=0 clxscore=1015 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 phishscore=0 mlxlogscore=861 mlxscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003130107
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amazingly, some libc implementations don't call __NR_nanosleep syscall from
their nanosleep() APIs. Hammer it down with explicit syscall() call and never
get back to it again. Also simplify code for timespec initialization.

I verified that nanosleep is called w/ printk and in exactly same Linux image
that is used in Travis CI. So it should both sleep and call correct syscall.

v1->v2:
  - math is too hard, fix usec -> nsec convertion (Martin);
  - test_vmlinux has explicit nanosleep() call, convert that one as well.

Fixes: 4e1fd25d19e8 ("selftests/bpf: Fix usleep() implementation")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/prog_tests/vmlinux.c |  2 +-
 tools/testing/selftests/bpf/test_progs.c         | 16 ++++++----------
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/vmlinux.c b/tools/testing/selftests/bpf/prog_tests/vmlinux.c
index 04939eda1325..72310cfc6474 100644
--- a/tools/testing/selftests/bpf/prog_tests/vmlinux.c
+++ b/tools/testing/selftests/bpf/prog_tests/vmlinux.c
@@ -11,7 +11,7 @@ static void nsleep()
 {
 	struct timespec ts = { .tv_nsec = MY_TV_NSEC };
 
-	(void)nanosleep(&ts, NULL);
+	(void)syscall(__NR_nanosleep, &ts, NULL);
 }
 
 void test_vmlinux(void)
diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index f85a06512541..dc12fd0de1c2 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -35,16 +35,12 @@ struct prog_test_def {
  */
 int usleep(useconds_t usec)
 {
-	struct timespec ts;
-
-	if (usec > 999999) {
-		ts.tv_sec = usec / 1000000;
-		ts.tv_nsec = usec % 1000000;
-	} else {
-		ts.tv_sec = 0;
-		ts.tv_nsec = usec;
-	}
-	return nanosleep(&ts, NULL);
+	struct timespec ts = {
+		.tv_sec = usec / 1000000,
+		.tv_nsec = (usec % 1000000) * 1000,
+	};
+
+	return syscall(__NR_nanosleep, &ts, NULL);
 }
 
 static bool should_run(struct test_selector *sel, int num, const char *name)
-- 
2.17.1

