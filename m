Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5974F429E2D
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 08:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbhJLG4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 02:56:30 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14332 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234038AbhJLG4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 02:56:02 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HT5qW00zhz905V;
        Tue, 12 Oct 2021 14:49:10 +0800 (CST)
Received: from dggema772-chm.china.huawei.com (10.1.198.214) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.8; Tue, 12 Oct 2021 14:53:49 +0800
Received: from huawei.com (10.175.101.6) by dggema772-chm.china.huawei.com
 (10.1.198.214) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.8; Tue, 12
 Oct 2021 14:53:48 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <john.fastabend@gmail.com>, <daniel@iogearbox.net>,
        <jakub@cloudflare.com>, <lmb@cloudflare.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <ast@kernel.org>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <xiyou.wangcong@gmail.com>
CC:     <liujian56@huawei.com>
Subject: [PATHC bpf v5 3/3] selftests, bpf: Add one test for sockmap with strparser
Date:   Tue, 12 Oct 2021 14:57:05 +0800
Message-ID: <20211012065705.224643-3-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211012065705.224643-1-liujian56@huawei.com>
References: <20211012065705.224643-1-liujian56@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggema772-chm.china.huawei.com (10.1.198.214)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the test to check sockmap with strparser is working well.

Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 tools/testing/selftests/bpf/test_sockmap.c | 33 ++++++++++++++++++++--
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 06924917ad77..1ba7e7346afb 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -139,6 +139,7 @@ struct sockmap_options {
 	bool sendpage;
 	bool data_test;
 	bool drop_expected;
+	bool check_recved_len;
 	int iov_count;
 	int iov_length;
 	int rate;
@@ -556,8 +557,12 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 	int err, i, flags = MSG_NOSIGNAL;
 	bool drop = opt->drop_expected;
 	bool data = opt->data_test;
+	int iov_alloc_length = iov_length;
 
-	err = msg_alloc_iov(&msg, iov_count, iov_length, data, tx);
+	if (!tx && opt->check_recved_len)
+		iov_alloc_length *= 2;
+
+	err = msg_alloc_iov(&msg, iov_count, iov_alloc_length, data, tx);
 	if (err)
 		goto out_errno;
 	if (peek_flag) {
@@ -665,6 +670,13 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 
 			s->bytes_recvd += recv;
 
+			if (opt->check_recved_len && s->bytes_recvd > total_bytes) {
+				errno = EMSGSIZE;
+				fprintf(stderr, "recv failed(), bytes_recvd:%zd, total_bytes:%f\n",
+						s->bytes_recvd, total_bytes);
+				goto out_errno;
+			}
+
 			if (data) {
 				int chunk_sz = opt->sendpage ?
 						iov_length * cnt :
@@ -744,7 +756,8 @@ static int sendmsg_test(struct sockmap_options *opt)
 
 	rxpid = fork();
 	if (rxpid == 0) {
-		iov_buf -= (txmsg_pop - txmsg_start_pop + 1);
+		if (txmsg_pop || txmsg_start_pop)
+			iov_buf -= (txmsg_pop - txmsg_start_pop + 1);
 		if (opt->drop_expected || txmsg_ktls_skb_drop)
 			_exit(0);
 
@@ -1688,6 +1701,19 @@ static void test_txmsg_ingress_parser(int cgrp, struct sockmap_options *opt)
 	test_exec(cgrp, opt);
 }
 
+static void test_txmsg_ingress_parser2(int cgrp, struct sockmap_options *opt)
+{
+	if (ktls == 1)
+		return;
+	skb_use_parser = 10;
+	opt->iov_length = 20;
+	opt->iov_count = 1;
+	opt->rate = 1;
+	opt->check_recved_len = true;
+	test_exec(cgrp, opt);
+	opt->check_recved_len = false;
+}
+
 char *map_names[] = {
 	"sock_map",
 	"sock_map_txmsg",
@@ -1786,7 +1812,8 @@ struct _test test[] = {
 	{"txmsg test pull-data", test_txmsg_pull},
 	{"txmsg test pop-data", test_txmsg_pop},
 	{"txmsg test push/pop data", test_txmsg_push_pop},
-	{"txmsg text ingress parser", test_txmsg_ingress_parser},
+	{"txmsg test ingress parser", test_txmsg_ingress_parser},
+	{"txmsg test ingress parser2", test_txmsg_ingress_parser2},
 };
 
 static int check_whitelist(struct _test *t, struct sockmap_options *opt)
-- 
2.17.1

