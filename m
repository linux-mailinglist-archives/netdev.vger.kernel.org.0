Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 471C91824D7
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730079AbgCKW16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:27:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40138 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729848AbgCKW15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 18:27:57 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02BMQjSF019954
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 15:27:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=3Xo6yw4I3artDOKR/vU4FromBUK+37Stk/VpgvedPqE=;
 b=leCuJS8tDCSZQyvc7QD7WY4d+5qdUEdnP7rAddlyOuyajks6bZZ/7EO6HCevG/J/5M/c
 GGf4nzgieIyeqbDvgWIhqzpZlrPU/QBnTQLXht3HNUjWNVLvHkA1h7fHbLeK0C6JphLy
 qTwh1kAlSZWJtc9aXTvQQxhXZaryUU7VwFQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2ypn9g57cr-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 15:27:56 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 11 Mar 2020 15:27:54 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 32B1D2EC2C9E; Wed, 11 Mar 2020 15:27:52 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <sdf@google.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next] selftests/bpf: make tcp_rtt test more robust to failures
Date:   Wed, 11 Mar 2020 15:27:49 -0700
Message-ID: <20200311222749.458015-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-11_11:2020-03-11,2020-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=8 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2003110126
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch to non-blocking accept and wait for server thread to exit before
proceeding. I noticed that sometimes tcp_rtt server thread failure would
"spill over" into other tests (that would run after tcp_rtt), probably just
because server thread exits much later and tcp_rtt doesn't wait for it.

v1->v2:
  - add usleep() while waiting on initial non-blocking accept() (Stanislav);

Fixes: 8a03222f508b ("selftests/bpf: test_progs: fix client/server race in tcp_rtt")
Reviewed-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/tcp_rtt.c        | 32 ++++++++++++-------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
index f4cd60d6fba2..e08f6bb17700 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
@@ -188,7 +188,7 @@ static int start_server(void)
 	};
 	int fd;
 
-	fd = socket(AF_INET, SOCK_STREAM, 0);
+	fd = socket(AF_INET, SOCK_STREAM | SOCK_NONBLOCK, 0);
 	if (fd < 0) {
 		log_err("Failed to create server socket");
 		return -1;
@@ -205,6 +205,7 @@ static int start_server(void)
 
 static pthread_mutex_t server_started_mtx = PTHREAD_MUTEX_INITIALIZER;
 static pthread_cond_t server_started = PTHREAD_COND_INITIALIZER;
+static volatile bool server_done = false;
 
 static void *server_thread(void *arg)
 {
@@ -222,23 +223,24 @@ static void *server_thread(void *arg)
 
 	if (CHECK_FAIL(err < 0)) {
 		perror("Failed to listed on socket");
-		return NULL;
+		return ERR_PTR(err);
 	}
 
-	client_fd = accept(fd, (struct sockaddr *)&addr, &len);
+	while (!server_done) {
+		client_fd = accept(fd, (struct sockaddr *)&addr, &len);
+		if (client_fd == -1 && errno == EAGAIN) {
+			usleep(50);
+			continue;
+		}
+		break;
+	}
 	if (CHECK_FAIL(client_fd < 0)) {
 		perror("Failed to accept client");
-		return NULL;
+		return ERR_PTR(err);
 	}
 
-	/* Wait for the next connection (that never arrives)
-	 * to keep this thread alive to prevent calling
-	 * close() on client_fd.
-	 */
-	if (CHECK_FAIL(accept(fd, (struct sockaddr *)&addr, &len) >= 0)) {
-		perror("Unexpected success in second accept");
-		return NULL;
-	}
+	while (!server_done)
+		usleep(50);
 
 	close(client_fd);
 
@@ -249,6 +251,7 @@ void test_tcp_rtt(void)
 {
 	int server_fd, cgroup_fd;
 	pthread_t tid;
+	void *server_res;
 
 	cgroup_fd = test__join_cgroup("/tcp_rtt");
 	if (CHECK_FAIL(cgroup_fd < 0))
@@ -267,6 +270,11 @@ void test_tcp_rtt(void)
 	pthread_mutex_unlock(&server_started_mtx);
 
 	CHECK_FAIL(run_test(cgroup_fd, server_fd));
+
+	server_done = true;
+	pthread_join(tid, &server_res);
+	CHECK_FAIL(IS_ERR(server_res));
+
 close_server_fd:
 	close(server_fd);
 close_cgroup_fd:
-- 
2.17.1

