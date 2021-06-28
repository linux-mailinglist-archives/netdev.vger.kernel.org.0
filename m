Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92FD03B5C1F
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 12:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbhF1KIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 06:08:21 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:62072 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232645AbhF1KIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 06:08:15 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id A844452279D;
        Mon, 28 Jun 2021 13:05:46 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1624874746;
        bh=tKmtQQ01ctaYFWRFYY1ssjg0jyWvxlv52Sbi846U5a4=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=GDBii2Mi1y39+64Hwu+ced6NiEIgoIoKKFiqJdDDY8ajlKpX3EMFVeouQYSniaV7O
         5Yu+DV7FReYZkPPRkw2QpWiH6j5e7uPZoxwCr6RNTdNeov7jlwc5Rbz8r6OwHXa7ca
         ZD6couPfmh/8RZ3SuOzlvfjGrueL9L21T107kEQ9TqTJ95J+zW09x8wf1HvLsGkw8N
         8IY/Xh8rvObYKVprSQMjqHvwfa1QENFti9ZCfeXtO6ghnBlkRLCOzQhv8N0ZAupU59
         HEADlKIF7oLl9jSEH7NCu1ZWZxiWoem7ybqjmIkNxYIaF27sv0sE6vkgadpnl9ov4T
         r2GZWiGH2AOEw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 658BC5227E1;
        Mon, 28 Jun 2021 13:05:46 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Mon, 28
 Jun 2021 13:05:45 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v1 16/16] vsock_test: SEQPACKET read to broken buffer
Date:   Mon, 28 Jun 2021 13:05:36 +0300
Message-ID: <20210628100539.572000-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628095959.569772-1-arseny.krasnov@kaspersky.com>
References: <20210628095959.569772-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/28/2021 09:47:58
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164664 [Jun 28 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/28/2021 09:51:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 28.06.2021 5:59:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/06/28 08:23:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/06/28 05:40:00 #16806866
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add test where sender sends two message, each with own
data pattern. Reader tries to read first to broken buffer:
it has three pages size, but middle page is unmapped. Then,
reader tries to read second message to valid buffer. Test
checks, that uncopied part of first message was dropped
and thus not copied as part of second message.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 tools/testing/vsock/vsock_test.c | 121 +++++++++++++++++++++++++++++++
 1 file changed, 121 insertions(+)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index 67766bfe176f..697ba168e97f 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -16,6 +16,7 @@
 #include <linux/kernel.h>
 #include <sys/types.h>
 #include <sys/socket.h>
+#include <sys/mman.h>
 
 #include "timeout.h"
 #include "control.h"
@@ -385,6 +386,121 @@ static void test_seqpacket_msg_trunc_server(const struct test_opts *opts)
 	close(fd);
 }
 
+#define BUF_PATTERN_1 'a'
+#define BUF_PATTERN_2 'b'
+
+static void test_seqpacket_invalid_rec_buffer_client(const struct test_opts *opts)
+{
+	int fd;
+	unsigned char *buf1;
+	unsigned char *buf2;
+	int buf_size = getpagesize() * 3;
+
+	fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	buf1 = malloc(buf_size);
+	if (buf1 == NULL) {
+		perror("'malloc()' for 'buf1'");
+		exit(EXIT_FAILURE);
+	}
+
+	buf2 = malloc(buf_size);
+	if (buf2 == NULL) {
+		perror("'malloc()' for 'buf2'");
+		exit(EXIT_FAILURE);
+	}
+
+	memset(buf1, BUF_PATTERN_1, buf_size);
+	memset(buf2, BUF_PATTERN_2, buf_size);
+
+	if (send(fd, buf1, buf_size, 0) != buf_size) {
+		perror("send failed");
+		exit(EXIT_FAILURE);
+	}
+
+	if (send(fd, buf2, buf_size, 0) != buf_size) {
+		perror("send failed");
+		exit(EXIT_FAILURE);
+	}
+
+	close(fd);
+}
+
+static void test_seqpacket_invalid_rec_buffer_server(const struct test_opts *opts)
+{
+	int fd;
+	unsigned char *broken_buf;
+	unsigned char *valid_buf;
+	int page_size = getpagesize();
+	int buf_size = page_size * 3;
+	ssize_t res;
+	int prot = PROT_READ | PROT_WRITE;
+	int flags = MAP_PRIVATE | MAP_ANONYMOUS;
+	int i;
+
+	fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
+	if (fd < 0) {
+		perror("accept");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Setup first buffer. */
+	broken_buf = mmap(NULL, buf_size, prot, flags, -1, 0);
+	if (broken_buf == MAP_FAILED) {
+		perror("mmap for 'broken_buf'");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Unmap "hole" in buffer. */
+	if (munmap(broken_buf + page_size, page_size)) {
+		perror("'broken_buf' setup");
+		exit(EXIT_FAILURE);
+	}
+
+	valid_buf = mmap(NULL, buf_size, prot, flags, -1, 0);
+	if (valid_buf == MAP_FAILED) {
+		perror("mmap for 'valid_buf'");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Try to fill buffer with unmapped middle. */
+	res = read(fd, broken_buf, buf_size);
+	if (res != -1) {
+		perror("invalid read result of 'broken_buf'");
+		exit(EXIT_FAILURE);
+	}
+
+	if (errno != ENOMEM) {
+		perror("invalid errno of 'broken_buf'");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Try to fill valid buffer. */
+	res = read(fd, valid_buf, buf_size);
+	if (res != buf_size) {
+		perror("invalid read result of 'valid_buf'");
+		exit(EXIT_FAILURE);
+	}
+
+	for (i = 0; i < buf_size; i++) {
+		if (valid_buf[i] != BUF_PATTERN_2) {
+			perror("invalid pattern for valid buf");
+			exit(EXIT_FAILURE);
+		}
+	}
+
+
+	/* Unmap buffers. */
+	munmap(broken_buf, page_size);
+	munmap(broken_buf + page_size * 2, page_size);
+	munmap(valid_buf, buf_size);
+	close(fd);
+}
+
 static struct test_case test_cases[] = {
 	{
 		.name = "SOCK_STREAM connection reset",
@@ -425,6 +541,11 @@ static struct test_case test_cases[] = {
 		.run_client = test_seqpacket_msg_trunc_client,
 		.run_server = test_seqpacket_msg_trunc_server,
 	},
+	{
+		.name = "SOCK_SEQPACKET invalid receive buffer",
+		.run_client = test_seqpacket_invalid_rec_buffer_client,
+		.run_server = test_seqpacket_invalid_rec_buffer_server,
+	},
 	{},
 };
 
-- 
2.25.1

