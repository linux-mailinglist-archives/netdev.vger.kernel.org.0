Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE5A61821E2
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 20:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731305AbgCKTPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 15:15:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47018 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731059AbgCKTPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 15:15:21 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 02BJAr2I016924
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 12:15:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=32dYBsbl45icJAcX80thj3Nctm0A1BOQtbVtD6yyyCw=;
 b=biYf21h7Ul5H4mY8JHeIXdu9hXlLKU/zGzbd0//bgZKT/mcOpNMgFk+LDwBsdMIcxBCY
 Ej6tmnkdJX0hsvrc2s3YfpSIsjeJnniLzItAJ/XjOA2V242LSvA9OV7QTQYlmNarCPiE
 h0QlS1Og5twoQbymEwxU+UBxz9WgfRmwx8M= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2yp6uw8tcr-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 12:15:20 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 11 Mar 2020 12:15:18 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 9E6D82EC2EE5; Wed, 11 Mar 2020 12:15:16 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <sdf@google.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] selftests/bpf: make tcp_rtt test more robust to failures
Date:   Wed, 11 Mar 2020 12:15:13 -0700
Message-ID: <20200311191513.3954203-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-11_09:2020-03-11,2020-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=8 clxscore=1015
 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2003110107
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch to non-blocking accept and wait for server thread to exit before
proceeding. I noticed that sometimes tcp_rtt server thread failure would
"spill over" into other tests (that would run after tcp_rtt), probably just
because server thread exits much later and tcp_rtt doesn't wait for it.

Fixes: 8a03222f508b ("selftests/bpf: test_progs: fix client/server race in tcp_rtt")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/tcp_rtt.c        | 30 +++++++++++--------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
index f4cd60d6fba2..d235eea0de27 100644
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
@@ -222,23 +223,22 @@ static void *server_thread(void *arg)
 
 	if (CHECK_FAIL(err < 0)) {
 		perror("Failed to listed on socket");
-		return NULL;
+		return ERR_PTR(err);
 	}
 
-	client_fd = accept(fd, (struct sockaddr *)&addr, &len);
+	while (!server_done) {
+		client_fd = accept(fd, (struct sockaddr *)&addr, &len);
+		if (client_fd == -1 && errno == EAGAIN)
+			continue;
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
 
@@ -249,6 +249,7 @@ void test_tcp_rtt(void)
 {
 	int server_fd, cgroup_fd;
 	pthread_t tid;
+	void *server_res;
 
 	cgroup_fd = test__join_cgroup("/tcp_rtt");
 	if (CHECK_FAIL(cgroup_fd < 0))
@@ -267,6 +268,11 @@ void test_tcp_rtt(void)
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

