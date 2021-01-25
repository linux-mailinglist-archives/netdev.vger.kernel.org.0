Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7BB6304A28
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbhAZFM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:12:26 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:46981 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728975AbhAYNoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 08:44:18 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 5988F520E59;
        Mon, 25 Jan 2021 14:17:08 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1611573428;
        bh=ggSXTSKARCvqKJVbAn9D45Qa00fyv1PuHALitv3Zxfo=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=fiIr+sf79ayfuopLrCQvipkbhh1kICt9oxyC++Sov6ZG6kVgAYaMNFk6V+mE+6aHC
         HuIereUT1Rg9dUk9E6poYs2XiVfZTWvxWtKpHoF+qaKaJH8zvNWqUCySltbX2DQKm+
         1FRu2qmyGMDP/Le/t2V/LuOVz58WvPPAcx4xnrzg=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id C2F8F520E3A;
        Mon, 25 Jan 2021 14:17:07 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Mon, 25
 Jan 2021 14:17:07 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jeff Vander Stoep <jeffv@google.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v3 13/13] vsock_test: add SOCK_SEQPACKET tests
Date:   Mon, 25 Jan 2021 14:16:49 +0300
Message-ID: <20210125111652.599950-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
References: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.16, Database issued on: 01/25/2021 10:59:54
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 161363 [Jan 25 2021]
X-KSE-AntiSpam-Info: LuaCore: 421 421 33a18ad4049b4a5e5420c907b38d332fafd06b09
X-KSE-AntiSpam-Info: Version: 5.9.16.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_date, moscow}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;arseniy-pc.avp.ru:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 01/25/2021 11:02:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 1/25/2021 10:11:00 AM
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/01/25 10:04:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/01/25 10:14:00 #16023936
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds two tests of SOCK_SEQPACKET socket: both transfer data and then
test MSG_EOR and MSG_TRUNC flags. Cases for connect(), bind(),  etc. are
not tested, because it is same as for stream socket.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 tools/testing/vsock/util.c       |  32 ++++++--
 tools/testing/vsock/util.h       |   3 +
 tools/testing/vsock/vsock_test.c | 126 +++++++++++++++++++++++++++++++
 3 files changed, 156 insertions(+), 5 deletions(-)

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
index 5a4fb80fa832..db6cc49fa5e4 100644
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
@@ -279,6 +281,120 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
 	close(fd);
 }
 
+#define MESSAGES_CNT 7
+#define MESSAGE_EOR_IDX (MESSAGES_CNT / 2)
+static void test_seqpacket_msg_send_client(const struct test_opts *opts)
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
+		send_byte(fd, 1, (i != MESSAGE_EOR_IDX) ? 0 : MSG_EOR);
+
+	control_writeln("SENDDONE");
+	close(fd);
+}
+
+static void test_seqpacket_msg_send_server(const struct test_opts *opts)
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
+
+		if (i == MESSAGE_EOR_IDX) {
+			if (!(msg.msg_flags & MSG_EOR)) {
+				fprintf(stderr, "MSG_EOR flag expected\n");
+				exit(EXIT_FAILURE);
+			}
+		} else {
+			if (msg.msg_flags & MSG_EOR) {
+				fprintf(stderr, "unexpected MSG_EOR flag\n");
+				exit(EXIT_FAILURE);
+			}
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
+	if (recvmsg(fd, &msg, MSG_TRUNC) != MESSAGE_TRUNC_SZ) {
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
@@ -309,6 +425,16 @@ static struct test_case test_cases[] = {
 		.run_client = test_stream_msg_peek_client,
 		.run_server = test_stream_msg_peek_server,
 	},
+	{
+		.name = "SOCK_SEQPACKET send data MSG_EOR",
+		.run_client = test_seqpacket_msg_send_client,
+		.run_server = test_seqpacket_msg_send_server,
+	},
+	{
+		.name = "SOCK_SEQPACKET send data MSG_TRUNC",
+		.run_client = test_seqpacket_msg_trunc_client,
+		.run_server = test_seqpacket_msg_trunc_server,
+	},
 	{},
 };
 
-- 
2.25.1

