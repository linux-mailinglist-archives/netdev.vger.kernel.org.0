Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6035638B74F
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 21:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239558AbhETTV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 15:21:26 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:30205 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237684AbhETTVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 15:21:23 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 97A38520CD1;
        Thu, 20 May 2021 22:19:59 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1621538399;
        bh=FjpNYQ0y1YTkBHK0ZnyPMlgOXyCLzlWZ/ELZISPDFH0=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=S5dNJeA4jm1HQoezKMMQPVH3Ic4nuTRMxSYqFmPax48WXaM7LZzktBkcS39J13LX3
         8PCyqob75Fn5snZ7TGe6njKSaOC0xtz6zQ1LdO+MglRHSqMlcqNR+mNSHlQO3qsRjO
         gkSpK0xXVuJN817Pd3WZUOggDLEGOts3mKQc7k6lG5HIhv7wDRHJ4qyboanZXaG7qE
         J+svfRZMg0ian7WfFRKJY8xUXDpwN1/VnJ/Sbh24+NRrNzbAAeCdmhfufdQPzXsK1s
         mSm+X2o3UNfTneSKYHeMJnO1iGhw56pwyS3fYMVecu1LbL15daNlecZG+S5k4Gloq5
         avAba6yVXFLog==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 46D0E5215E2;
        Thu, 20 May 2021 22:19:59 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Thu, 20
 May 2021 22:19:58 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oxffffaa@gmail.com>
Subject: [PATCH v10 17/18] vsock_test: add SOCK_SEQPACKET tests
Date:   Thu, 20 May 2021 22:19:50 +0300
Message-ID: <20210520191953.1272798-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 05/20/2021 18:58:27
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 163818 [May 20 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 446 446 0309aa129ce7cd9d810f87a68320917ac2eba541
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;arseniy-pc.avp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 05/20/2021 19:01:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 20.05.2021 14:47:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/05/20 17:27:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/05/20 14:47:00 #16622423
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement two tests of SOCK_SEQPACKET socket: first sends data by
several 'write()'s and checks that number of 'read()' were same.
Second test checks MSG_TRUNC flag. Cases for connect(), bind(),
etc. are not tested, because it is same as for stream socket.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 v9 -> v10:
 1) Commit message updated.
 2) Add second test for message bounds.

 tools/testing/vsock/util.c       |  32 +++++++--
 tools/testing/vsock/util.h       |   3 +
 tools/testing/vsock/vsock_test.c | 116 +++++++++++++++++++++++++++++++
 3 files changed, 146 insertions(+), 5 deletions(-)

diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index 93cbd6f603f9..2acbb7703c6a 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -84,7 +84,7 @@ void vsock_wait_remote_close(int fd)
 }
 
 /* Connect to <cid, port> and return the file descriptor. */
-int vsock_stream_connect(unsigned int cid, unsigned int port)
+static int vsock_connect(unsigned int cid, unsigned int port, int type)
 {
 	union {
 		struct sockaddr sa;
@@ -101,7 +101,7 @@ int vsock_stream_connect(unsigned int cid, unsigned int port)
 
 	control_expectln("LISTENING");
 
-	fd = socket(AF_VSOCK, SOCK_STREAM, 0);
+	fd = socket(AF_VSOCK, type, 0);
 
 	timeout_begin(TIMEOUT);
 	do {
@@ -120,11 +120,21 @@ int vsock_stream_connect(unsigned int cid, unsigned int port)
 	return fd;
 }
 
+int vsock_stream_connect(unsigned int cid, unsigned int port)
+{
+	return vsock_connect(cid, port, SOCK_STREAM);
+}
+
+int vsock_seqpacket_connect(unsigned int cid, unsigned int port)
+{
+	return vsock_connect(cid, port, SOCK_SEQPACKET);
+}
+
 /* Listen on <cid, port> and return the first incoming connection.  The remote
  * address is stored to clientaddrp.  clientaddrp may be NULL.
  */
-int vsock_stream_accept(unsigned int cid, unsigned int port,
-			struct sockaddr_vm *clientaddrp)
+static int vsock_accept(unsigned int cid, unsigned int port,
+			struct sockaddr_vm *clientaddrp, int type)
 {
 	union {
 		struct sockaddr sa;
@@ -145,7 +155,7 @@ int vsock_stream_accept(unsigned int cid, unsigned int port,
 	int client_fd;
 	int old_errno;
 
-	fd = socket(AF_VSOCK, SOCK_STREAM, 0);
+	fd = socket(AF_VSOCK, type, 0);
 
 	if (bind(fd, &addr.sa, sizeof(addr.svm)) < 0) {
 		perror("bind");
@@ -189,6 +199,18 @@ int vsock_stream_accept(unsigned int cid, unsigned int port,
 	return client_fd;
 }
 
+int vsock_stream_accept(unsigned int cid, unsigned int port,
+			struct sockaddr_vm *clientaddrp)
+{
+	return vsock_accept(cid, port, clientaddrp, SOCK_STREAM);
+}
+
+int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
+			   struct sockaddr_vm *clientaddrp)
+{
+	return vsock_accept(cid, port, clientaddrp, SOCK_SEQPACKET);
+}
+
 /* Transmit one byte and check the return value.
  *
  * expected_ret:
diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
index e53dd09d26d9..a3375ad2fb7f 100644
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -36,8 +36,11 @@ struct test_case {
 void init_signals(void);
 unsigned int parse_cid(const char *str);
 int vsock_stream_connect(unsigned int cid, unsigned int port);
+int vsock_seqpacket_connect(unsigned int cid, unsigned int port);
 int vsock_stream_accept(unsigned int cid, unsigned int port,
 			struct sockaddr_vm *clientaddrp);
+int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
+			   struct sockaddr_vm *clientaddrp);
 void vsock_wait_remote_close(int fd);
 void send_byte(int fd, int expected_ret, int flags);
 void recv_byte(int fd, int expected_ret, int flags);
diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index 5a4fb80fa832..67766bfe176f 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -14,6 +14,8 @@
 #include <errno.h>
 #include <unistd.h>
 #include <linux/kernel.h>
+#include <sys/types.h>
+#include <sys/socket.h>
 
 #include "timeout.h"
 #include "control.h"
@@ -279,6 +281,110 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
 	close(fd);
 }
 
+#define MESSAGES_CNT 7
+static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
+{
+	int fd;
+
+	fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Send several messages, one with MSG_EOR flag */
+	for (int i = 0; i < MESSAGES_CNT; i++)
+		send_byte(fd, 1, 0);
+
+	control_writeln("SENDDONE");
+	close(fd);
+}
+
+static void test_seqpacket_msg_bounds_server(const struct test_opts *opts)
+{
+	int fd;
+	char buf[16];
+	struct msghdr msg = {0};
+	struct iovec iov = {0};
+
+	fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
+	if (fd < 0) {
+		perror("accept");
+		exit(EXIT_FAILURE);
+	}
+
+	control_expectln("SENDDONE");
+	iov.iov_base = buf;
+	iov.iov_len = sizeof(buf);
+	msg.msg_iov = &iov;
+	msg.msg_iovlen = 1;
+
+	for (int i = 0; i < MESSAGES_CNT; i++) {
+		if (recvmsg(fd, &msg, 0) != 1) {
+			perror("message bound violated");
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	close(fd);
+}
+
+#define MESSAGE_TRUNC_SZ 32
+static void test_seqpacket_msg_trunc_client(const struct test_opts *opts)
+{
+	int fd;
+	char buf[MESSAGE_TRUNC_SZ];
+
+	fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	if (send(fd, buf, sizeof(buf), 0) != sizeof(buf)) {
+		perror("send failed");
+		exit(EXIT_FAILURE);
+	}
+
+	control_writeln("SENDDONE");
+	close(fd);
+}
+
+static void test_seqpacket_msg_trunc_server(const struct test_opts *opts)
+{
+	int fd;
+	char buf[MESSAGE_TRUNC_SZ / 2];
+	struct msghdr msg = {0};
+	struct iovec iov = {0};
+
+	fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
+	if (fd < 0) {
+		perror("accept");
+		exit(EXIT_FAILURE);
+	}
+
+	control_expectln("SENDDONE");
+	iov.iov_base = buf;
+	iov.iov_len = sizeof(buf);
+	msg.msg_iov = &iov;
+	msg.msg_iovlen = 1;
+
+	ssize_t ret = recvmsg(fd, &msg, MSG_TRUNC);
+
+	if (ret != MESSAGE_TRUNC_SZ) {
+		printf("%zi\n", ret);
+		perror("MSG_TRUNC doesn't work");
+		exit(EXIT_FAILURE);
+	}
+
+	if (!(msg.msg_flags & MSG_TRUNC)) {
+		fprintf(stderr, "MSG_TRUNC expected\n");
+		exit(EXIT_FAILURE);
+	}
+
+	close(fd);
+}
+
 static struct test_case test_cases[] = {
 	{
 		.name = "SOCK_STREAM connection reset",
@@ -309,6 +415,16 @@ static struct test_case test_cases[] = {
 		.run_client = test_stream_msg_peek_client,
 		.run_server = test_stream_msg_peek_server,
 	},
+	{
+		.name = "SOCK_SEQPACKET msg bounds",
+		.run_client = test_seqpacket_msg_bounds_client,
+		.run_server = test_seqpacket_msg_bounds_server,
+	},
+	{
+		.name = "SOCK_SEQPACKET MSG_TRUNC flag",
+		.run_client = test_seqpacket_msg_trunc_client,
+		.run_server = test_seqpacket_msg_trunc_server,
+	},
 	{},
 };
 
-- 
2.25.1

