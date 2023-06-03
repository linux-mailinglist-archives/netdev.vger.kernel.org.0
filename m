Return-Path: <netdev+bounces-7721-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AB1C721302
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 22:59:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 501F9280BE9
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 20:59:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A86DD19E46;
	Sat,  3 Jun 2023 20:55:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCB7156D2
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 20:55:01 +0000 (UTC)
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23E11B7;
	Sat,  3 Jun 2023 13:54:59 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
	by mx.sberdevices.ru (Postfix) with ESMTP id 4027C5FD40;
	Sat,  3 Jun 2023 23:54:50 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
	s=mail; t=1685825690;
	bh=FgPTGIGxeBtK5P9H+BLgs5wiavf5GzMitjxHRDrphMA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=BPLkTA1IdyQHFINXouNlMNTBnYljhy3Pao3JcffEzGYHyJUDRJrIlwPXANH4q4OTq
	 d0AtgctMHevEDTV9gEYtdOTCFuXZrrC/9+Nc+7J1M6LpVCpizanzjuGSrF0bs2qQu3
	 n22iOijNrxigaadZuT0Q9RCXDuLrAD6wsK7INncufOosIx03ILqkk95IbVix3kCNy1
	 r2rzg5JKE5oH+Ll+vp56ROV6ECpsqeuGyadfz3Ml0M+PbZ8dp6mBYrAQUyvgcj3cMd
	 Nk1O24f4J9WBJd2TpmE2ltcegLZ4awOztC6bGRvJ5IDBRwH6PufWFpGVPlpW8weRtY
	 YajyhMXndf5iA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
	by mx.sberdevices.ru (Postfix) with ESMTP;
	Sat,  3 Jun 2023 23:54:50 +0300 (MSK)
From: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
	<jasowang@redhat.com>, Bobby Eshleman <bobby.eshleman@bytedance.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel@sberdevices.ru>, <oxffffaa@gmail.com>, <avkrasnov@sberdevices.ru>,
	Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v4 16/17] test/vsock: MSG_ZEROCOPY support for vsock_perf
Date: Sat, 3 Jun 2023 23:49:38 +0300
Message-ID: <20230603204939.1598818-17-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
References: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH02.sberdevices.ru (172.16.1.5) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/06/03 16:55:00 #21417531
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

To use this option pass '--zc' parameter:

./vsock_perf --zc --sender <cid> --port <port> --bytes <bytes to send>

With this option MSG_ZEROCOPY flag will be passed to the 'send()' call.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 tools/testing/vsock/vsock_perf.c | 139 +++++++++++++++++++++++++++++--
 1 file changed, 130 insertions(+), 9 deletions(-)

diff --git a/tools/testing/vsock/vsock_perf.c b/tools/testing/vsock/vsock_perf.c
index a72520338f84..7fd76f7a3c16 100644
--- a/tools/testing/vsock/vsock_perf.c
+++ b/tools/testing/vsock/vsock_perf.c
@@ -18,6 +18,8 @@
 #include <poll.h>
 #include <sys/socket.h>
 #include <linux/vm_sockets.h>
+#include <sys/mman.h>
+#include <linux/errqueue.h>
 
 #define DEFAULT_BUF_SIZE_BYTES	(128 * 1024)
 #define DEFAULT_TO_SEND_BYTES	(64 * 1024)
@@ -28,9 +30,14 @@
 #define BYTES_PER_GB		(1024 * 1024 * 1024ULL)
 #define NSEC_PER_SEC		(1000000000ULL)
 
+#ifndef SOL_VSOCK
+#define SOL_VSOCK 287
+#endif
+
 static unsigned int port = DEFAULT_PORT;
 static unsigned long buf_size_bytes = DEFAULT_BUF_SIZE_BYTES;
 static unsigned long vsock_buf_bytes = DEFAULT_VSOCK_BUF_BYTES;
+static bool zerocopy;
 
 static void error(const char *s)
 {
@@ -247,15 +254,76 @@ static void run_receiver(unsigned long rcvlowat_bytes)
 	close(fd);
 }
 
+static void recv_completion(int fd)
+{
+	struct sock_extended_err *serr;
+	char cmsg_data[128];
+	struct cmsghdr *cm;
+	struct msghdr msg = { 0 };
+	ssize_t ret;
+
+	msg.msg_control = cmsg_data;
+	msg.msg_controllen = sizeof(cmsg_data);
+
+	ret = recvmsg(fd, &msg, MSG_ERRQUEUE);
+	if (ret) {
+		fprintf(stderr, "recvmsg: failed to read err: %zi\n", ret);
+		return;
+	}
+
+	cm = CMSG_FIRSTHDR(&msg);
+	if (!cm) {
+		fprintf(stderr, "cmsg: no cmsg\n");
+		return;
+	}
+
+	if (cm->cmsg_level != SOL_VSOCK) {
+		fprintf(stderr, "cmsg: unexpected 'cmsg_level'\n");
+		return;
+	}
+
+	if (cm->cmsg_type) {
+		fprintf(stderr, "cmsg: unexpected 'cmsg_type'\n");
+		return;
+	}
+
+	serr = (void *)CMSG_DATA(cm);
+	if (serr->ee_origin != SO_EE_ORIGIN_ZEROCOPY) {
+		fprintf(stderr, "serr: wrong origin\n");
+		return;
+	}
+
+	if (serr->ee_errno) {
+		fprintf(stderr, "serr: wrong error code\n");
+		return;
+	}
+
+	if (zerocopy && (serr->ee_code & SO_EE_CODE_ZEROCOPY_COPIED))
+		fprintf(stderr, "warning: copy instead of zerocopy\n");
+}
+
+static void enable_so_zerocopy(int fd)
+{
+	int val = 1;
+
+	if (setsockopt(fd, SOL_SOCKET, SO_ZEROCOPY, &val, sizeof(val)))
+		error("setsockopt(SO_ZEROCOPY)");
+}
+
 static void run_sender(int peer_cid, unsigned long to_send_bytes)
 {
 	time_t tx_begin_ns;
 	time_t tx_total_ns;
 	size_t total_send;
+	time_t time_in_send;
 	void *data;
 	int fd;
 
-	printf("Run as sender\n");
+	if (zerocopy)
+		printf("Run as sender MSG_ZEROCOPY\n");
+	else
+		printf("Run as sender\n");
+
 	printf("Connect to %i:%u\n", peer_cid, port);
 	printf("Send %lu bytes\n", to_send_bytes);
 	printf("TX buffer %lu bytes\n", buf_size_bytes);
@@ -265,38 +333,82 @@ static void run_sender(int peer_cid, unsigned long to_send_bytes)
 	if (fd < 0)
 		exit(EXIT_FAILURE);
 
-	data = malloc(buf_size_bytes);
+	if (zerocopy) {
+		enable_so_zerocopy(fd);
 
-	if (!data) {
-		fprintf(stderr, "'malloc()' failed\n");
-		exit(EXIT_FAILURE);
+		data = mmap(NULL, buf_size_bytes, PROT_READ | PROT_WRITE,
+			    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+		if (data == MAP_FAILED) {
+			perror("mmap");
+			exit(EXIT_FAILURE);
+		}
+	} else {
+		data = malloc(buf_size_bytes);
+
+		if (!data) {
+			fprintf(stderr, "'malloc()' failed\n");
+			exit(EXIT_FAILURE);
+		}
 	}
 
 	memset(data, 0, buf_size_bytes);
 	total_send = 0;
+	time_in_send = 0;
 	tx_begin_ns = current_nsec();
 
 	while (total_send < to_send_bytes) {
 		ssize_t sent;
+		size_t rest_bytes;
+		time_t before;
 
-		sent = write(fd, data, buf_size_bytes);
+		rest_bytes = to_send_bytes - total_send;
+
+		before = current_nsec();
+		sent = send(fd, data, (rest_bytes > buf_size_bytes) ?
+			    buf_size_bytes : rest_bytes,
+			    zerocopy ? MSG_ZEROCOPY : 0);
+		time_in_send += (current_nsec() - before);
 
 		if (sent <= 0)
 			error("write");
 
 		total_send += sent;
+
+		if (zerocopy) {
+			struct pollfd fds = { 0 };
+
+			fds.fd = fd;
+
+			if (poll(&fds, 1, -1) < 0) {
+				perror("poll");
+				exit(EXIT_FAILURE);
+			}
+
+			if (!(fds.revents & POLLERR)) {
+				fprintf(stderr, "POLLERR expected\n");
+				exit(EXIT_FAILURE);
+			}
+
+			recv_completion(fd);
+		}
 	}
 
 	tx_total_ns = current_nsec() - tx_begin_ns;
 
 	printf("total bytes sent: %zu\n", total_send);
 	printf("tx performance: %f Gbits/s\n",
-	       get_gbps(total_send * 8, tx_total_ns));
-	printf("total time in 'write()': %f sec\n",
+	       get_gbps(total_send * 8, time_in_send));
+	printf("total time in tx loop: %f sec\n",
 	       (float)tx_total_ns / NSEC_PER_SEC);
+	printf("time in 'send()': %f sec\n",
+	       (float)time_in_send / NSEC_PER_SEC);
 
 	close(fd);
-	free(data);
+
+	if (zerocopy)
+		munmap(data, buf_size_bytes);
+	else
+		free(data);
 }
 
 static const char optstring[] = "";
@@ -336,6 +448,11 @@ static const struct option longopts[] = {
 		.has_arg = required_argument,
 		.val = 'R',
 	},
+	{
+		.name = "zc",
+		.has_arg = no_argument,
+		.val = 'Z',
+	},
 	{},
 };
 
@@ -351,6 +468,7 @@ static void usage(void)
 	       "  --help			This message\n"
 	       "  --sender   <cid>		Sender mode (receiver default)\n"
 	       "                                <cid> of the receiver to connect to\n"
+	       "  --zc				Enable zerocopy\n"
 	       "  --port     <port>		Port (default %d)\n"
 	       "  --bytes    <bytes>KMG		Bytes to send (default %d)\n"
 	       "  --buf-size <bytes>KMG		Data buffer size (default %d). In sender mode\n"
@@ -413,6 +531,9 @@ int main(int argc, char **argv)
 		case 'H': /* Help. */
 			usage();
 			break;
+		case 'Z': /* Zerocopy. */
+			zerocopy = true;
+			break;
 		default:
 			usage();
 		}
-- 
2.25.1


