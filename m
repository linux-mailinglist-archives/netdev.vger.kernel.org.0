Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB2AB6EC208
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 21:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbjDWTb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 15:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbjDWTbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 15:31:34 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE6810EB;
        Sun, 23 Apr 2023 12:31:31 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id EDC965FD18;
        Sun, 23 Apr 2023 22:31:29 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1682278290;
        bh=PTO+88z7ZzGCowyLUeWnfeKiSAjG0RLn8oFYE0Qu8bY=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=sH69E1M6FNJ7rC2dzF58ROHqeXt5VLytPBTkz4GNy/gUcUsUQHI6VDPSw6D+FAy4i
         lkqnX8+ihuGZJSbcWCfTbWkH5iMWRtbpunO0NoKHsoIF78PHVGEJ/YNKAnMfV4Jt2+
         ITLL4NP6ux9+VBqK/WW2SfG6Okpr3s8QUhTkqvOzBnK2SmMjkjrERAWCm4/pC/yk4J
         GlAvTLvuIxU1ecQcdRnsv/ZR09+e3TjZJwbfzmNfiqbU0zf8lwL3yU4QamD455jTJS
         2jFibJD/YzMeh9Ci8SsEaXjAokyPT9Unt1b7ZgfZGv+2Z4V2nwQT42eEkdGFmnCifr
         1/9vteiuVySyQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 23 Apr 2023 22:31:29 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>,
        <avkrasnov@sberdevices.ru>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v2 13/15] test/vsock: MSG_ZEROCOPY flag tests
Date:   Sun, 23 Apr 2023 22:26:41 +0300
Message-ID: <20230423192643.1537470-14-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230423192643.1537470-1-AVKrasnov@sberdevices.ru>
References: <20230423192643.1537470-1-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/04/23 16:01:00 #21150277
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds set of tests for MSG_ZEROCOPY flag.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 tools/testing/vsock/Makefile              |   2 +-
 tools/testing/vsock/util.h                |   1 +
 tools/testing/vsock/vsock_test.c          |  11 +
 tools/testing/vsock/vsock_test_zerocopy.c | 501 ++++++++++++++++++++++
 tools/testing/vsock/vsock_test_zerocopy.h |  12 +
 5 files changed, 526 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/vsock/vsock_test_zerocopy.c
 create mode 100644 tools/testing/vsock/vsock_test_zerocopy.h

diff --git a/tools/testing/vsock/Makefile b/tools/testing/vsock/Makefile
index 43a254f0e14d..0a78787d1d92 100644
--- a/tools/testing/vsock/Makefile
+++ b/tools/testing/vsock/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 all: test vsock_perf
 test: vsock_test vsock_diag_test
-vsock_test: vsock_test.o timeout.o control.o util.o
+vsock_test: vsock_test.o vsock_test_zerocopy.o timeout.o control.o util.o
 vsock_diag_test: vsock_diag_test.o timeout.o control.o util.o
 vsock_perf: vsock_perf.o
 
diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
index fb99208a95ea..46ba1d3202b8 100644
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -2,6 +2,7 @@
 #ifndef UTIL_H
 #define UTIL_H
 
+#include <stdbool.h>
 #include <sys/socket.h>
 #include <linux/vm_sockets.h>
 
diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index ac1bd3ac1533..d9bddb643794 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -20,6 +20,7 @@
 #include <sys/mman.h>
 #include <poll.h>
 
+#include "vsock_test_zerocopy.h"
 #include "timeout.h"
 #include "control.h"
 #include "util.h"
@@ -1128,6 +1129,16 @@ static struct test_case test_cases[] = {
 		.run_client = test_stream_virtio_skb_merge_client,
 		.run_server = test_stream_virtio_skb_merge_server,
 	},
+	{
+		.name = "SOCK_STREAM MSG_ZEROCOPY",
+		.run_client = test_stream_msg_zcopy_client,
+		.run_server = test_stream_msg_zcopy_server,
+	},
+	{
+		.name = "SOCK_STREAM MSG_ZEROCOPY empty MSG_ERRQUEUE",
+		.run_client = test_stream_msg_zcopy_empty_errq_client,
+		.run_server = test_stream_msg_zcopy_empty_errq_server,
+	},
 	{},
 };
 
diff --git a/tools/testing/vsock/vsock_test_zerocopy.c b/tools/testing/vsock/vsock_test_zerocopy.c
new file mode 100644
index 000000000000..de44587bff26
--- /dev/null
+++ b/tools/testing/vsock/vsock_test_zerocopy.c
@@ -0,0 +1,501 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* MSG_ZEROCOPY feature tests for vsock
+ *
+ * Copyright (C) 2023 SberDevices.
+ *
+ * Author: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <unistd.h>
+#include <poll.h>
+#include <linux/errqueue.h>
+#include <linux/kernel.h>
+#include <error.h>
+#include <errno.h>
+
+#include "control.h"
+#include "vsock_test_zerocopy.h"
+
+#ifndef SOL_VSOCK
+#define SOL_VSOCK 287
+#endif
+
+#define PAGE_SIZE		4096
+#define POLL_TIMEOUT_MS		100
+#define SENDMSG_RES_IOV_LEN	(-2)
+
+struct zerocopy_test_data {
+	bool zerocopied;
+	bool completion;
+	int sendmsg_errno;
+	ssize_t sendmsg_res;
+	int vecs_cnt;
+	struct iovec vecs[3];
+};
+
+static void do_recv_completion(int fd, bool zerocopied, bool completion)
+{
+	struct sock_extended_err *serr;
+	struct msghdr msg = { 0 };
+	struct pollfd fds = { 0 };
+	char cmsg_data[128];
+	struct cmsghdr *cm;
+	uint32_t hi, lo;
+	ssize_t res;
+
+	fds.fd = fd;
+	fds.events = 0;
+
+	if (poll(&fds, 1, POLL_TIMEOUT_MS) < 0) {
+		perror("poll");
+		exit(EXIT_FAILURE);
+	}
+
+	if (!(fds.revents & POLLERR)) {
+		if (completion) {
+			fprintf(stderr, "POLLERR expected\n");
+			exit(EXIT_FAILURE);
+		} else {
+			return;
+		}
+	}
+
+	msg.msg_control = cmsg_data;
+	msg.msg_controllen = sizeof(cmsg_data);
+
+	res = recvmsg(fd, &msg, MSG_ERRQUEUE);
+	if (res) {
+		fprintf(stderr, "failed to read error queue: %zi\n", res);
+		exit(EXIT_FAILURE);
+	}
+
+	cm = CMSG_FIRSTHDR(&msg);
+	if (!cm) {
+		fprintf(stderr, "cmsg: no cmsg\n");
+		exit(EXIT_FAILURE);
+	}
+
+	if (cm->cmsg_level != SOL_VSOCK) {
+		fprintf(stderr, "cmsg: unexpected 'cmsg_level'\n");
+		exit(EXIT_FAILURE);
+	}
+
+	if (cm->cmsg_type != 0) {
+		fprintf(stderr, "cmsg: unexpected 'cmsg_type'\n");
+		exit(EXIT_FAILURE);
+	}
+
+	serr = (void *)CMSG_DATA(cm);
+	if (serr->ee_origin != SO_EE_ORIGIN_ZEROCOPY) {
+		printf("serr: wrong origin: %u\n", serr->ee_origin);
+		exit(EXIT_FAILURE);
+	}
+
+	if (serr->ee_errno) {
+		printf("serr: wrong error code: %u\n", serr->ee_errno);
+		exit(EXIT_FAILURE);
+	}
+
+	hi = serr->ee_data;
+	lo = serr->ee_info;
+	if (hi != lo) {
+		fprintf(stderr, "serr: expected hi == lo\n");
+		exit(EXIT_FAILURE);
+	}
+
+	if (hi) {
+		fprintf(stderr, "serr: expected hi == lo == 0\n");
+		exit(EXIT_FAILURE);
+	}
+
+	if (zerocopied && (serr->ee_code & SO_EE_CODE_ZEROCOPY_COPIED)) {
+		fprintf(stderr, "serr: was copy instead of zerocopy\n");
+		exit(EXIT_FAILURE);
+	}
+
+	if (!zerocopied && !(serr->ee_code & SO_EE_CODE_ZEROCOPY_COPIED)) {
+		fprintf(stderr, "serr: was zerocopy instead of copy\n");
+		exit(EXIT_FAILURE);
+	}
+}
+
+static void enable_so_zerocopy(int fd)
+{
+	int val = 1;
+
+	if (setsockopt(fd, SOL_SOCKET, SO_ZEROCOPY, &val, sizeof(val)))
+		error(1, errno, "setsockopt");
+}
+
+static void *mmap_no_fail(size_t bytes)
+{
+	void *res;
+
+	res = mmap(NULL, bytes, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE, -1, 0);
+	if (res == MAP_FAILED) {
+		perror("mmap");
+		exit(EXIT_FAILURE);
+	}
+
+	return res;
+}
+
+static size_t iovec_bytes(const struct iovec *iov, size_t iovnum)
+{
+	size_t bytes;
+	int i;
+
+	for (bytes = 0, i = 0; i < iovnum; i++)
+		bytes += iov[i].iov_len;
+
+	return bytes;
+}
+
+static void iovec_random_init(struct iovec *iov,
+			      const struct zerocopy_test_data *test_data)
+{
+	int i;
+
+	for (i = 0; i < test_data->vecs_cnt; i++) {
+		int j;
+
+		if (test_data->vecs[i].iov_base == MAP_FAILED)
+			continue;
+
+		for (j = 0; j < iov[i].iov_len; j++)
+			((uint8_t *)iov[i].iov_base)[j] = rand() & 0xff;
+	}
+}
+
+static unsigned long iovec_hash_djb2(struct iovec *iov, size_t iovnum)
+{
+	unsigned long hash;
+	size_t iov_bytes;
+	size_t offs;
+	void *tmp;
+	int i;
+
+	iov_bytes = iovec_bytes(iov, iovnum);
+
+	tmp = malloc(iov_bytes);
+	if (!tmp) {
+		perror("malloc");
+		exit(EXIT_FAILURE);
+	}
+
+	for (offs = 0, i = 0; i < iovnum; i++) {
+		memcpy(tmp + offs, iov[i].iov_base, iov[i].iov_len);
+		offs += iov[i].iov_len;
+	}
+
+	hash = hash_djb2(tmp, iov_bytes);
+	free(tmp);
+
+	return hash;
+}
+
+static struct zerocopy_test_data test_data_array[] = {
+	/* Last element has non-page aligned size. */
+	{
+		.zerocopied = true,
+		.completion = true,
+		.sendmsg_errno = 0,
+		.sendmsg_res = SENDMSG_RES_IOV_LEN,
+		.vecs_cnt = 3,
+		{
+			{ NULL, PAGE_SIZE },
+			{ NULL, PAGE_SIZE },
+			{ NULL, 200 }
+		}
+	},
+	/* All elements have page aligned base and size. */
+	{
+		.zerocopied = true,
+		.completion = true,
+		.sendmsg_errno = 0,
+		.sendmsg_res = SENDMSG_RES_IOV_LEN,
+		.vecs_cnt = 3,
+		{
+			{ NULL, PAGE_SIZE },
+			{ NULL, PAGE_SIZE * 2 },
+			{ NULL, PAGE_SIZE * 3 }
+		}
+	},
+	/* All elements have page aligned base and size. But
+	 * data length is bigger than 64Kb.
+	 */
+	{
+		.zerocopied = true,
+		.completion = true,
+		.sendmsg_errno = 0,
+		.sendmsg_res = SENDMSG_RES_IOV_LEN,
+		.vecs_cnt = 3,
+		{
+			{ NULL, PAGE_SIZE * 16 },
+			{ NULL, PAGE_SIZE * 16 },
+			{ NULL, PAGE_SIZE * 16 }
+		}
+	},
+	/* All elements have page aligned base and size. */
+	{
+		.zerocopied = true,
+		.completion = true,
+		.sendmsg_errno = 0,
+		.sendmsg_res = SENDMSG_RES_IOV_LEN,
+		.vecs_cnt = 3,
+		{
+			{ NULL, PAGE_SIZE },
+			{ NULL, PAGE_SIZE },
+			{ NULL, PAGE_SIZE }
+		}
+	},
+	/* Middle element has non-page aligned size. */
+	{
+		.zerocopied = false,
+		.completion = true,
+		.sendmsg_errno = 0,
+		.sendmsg_res = SENDMSG_RES_IOV_LEN,
+		.vecs_cnt = 3,
+		{
+			{ NULL, PAGE_SIZE },
+			{ NULL, 100 },
+			{ NULL, PAGE_SIZE }
+		}
+	},
+	/* Middle element has both non-page aligned base and size. */
+	{
+		.zerocopied = false,
+		.completion = true,
+		.sendmsg_errno = 0,
+		.sendmsg_res = SENDMSG_RES_IOV_LEN,
+		.vecs_cnt = 3,
+		{
+			{ NULL, PAGE_SIZE },
+			{ (void *)1, 100 },
+			{ NULL, PAGE_SIZE }
+		}
+	},
+	/* One element has invalid base. */
+	{
+		.zerocopied = false,
+		.completion = false,
+		.sendmsg_errno = ENOMEM,
+		.sendmsg_res = -1,
+		.vecs_cnt = 3,
+		{
+			{ NULL, PAGE_SIZE },
+			{ MAP_FAILED, PAGE_SIZE },
+			{ NULL, PAGE_SIZE }
+		}
+	},
+	/* Valid data, but SO_ZEROCOPY is off. */
+	{
+		.zerocopied = true,
+		.completion = false,
+		.sendmsg_errno = 0,
+		.sendmsg_res = SENDMSG_RES_IOV_LEN,
+		.vecs_cnt = 1,
+		{
+			{ NULL, PAGE_SIZE }
+		}
+	},
+};
+
+static void __test_stream_msg_zerocopy_client(const struct test_opts *opts,
+					      const struct zerocopy_test_data *test_data)
+{
+	struct msghdr msg = { 0 };
+	ssize_t sendmsg_res;
+	struct iovec *iovec;
+	int fd;
+	int i;
+
+	fd = vsock_stream_connect(opts->peer_cid, 1234);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	if (test_data->completion)
+		enable_so_zerocopy(fd);
+
+	iovec = malloc(sizeof(*iovec) * test_data->vecs_cnt);
+	if (!iovec) {
+		perror("malloc");
+		exit(EXIT_FAILURE);
+	}
+
+	for (i = 0; i < test_data->vecs_cnt; i++) {
+		iovec[i].iov_len = test_data->vecs[i].iov_len;
+		iovec[i].iov_base = mmap_no_fail(test_data->vecs[i].iov_len);
+	}
+
+	for (i = 0; i < test_data->vecs_cnt; i++) {
+		if (test_data->vecs[i].iov_base == MAP_FAILED) {
+			if (munmap(iovec[i].iov_base, iovec[i].iov_len)) {
+				perror("munmap");
+				exit(EXIT_FAILURE);
+			}
+		}
+	}
+
+	iovec_random_init(iovec, test_data);
+
+	msg.msg_iov = iovec;
+	msg.msg_iovlen = test_data->vecs_cnt;
+
+	errno = 0;
+
+	if (test_data->sendmsg_res == SENDMSG_RES_IOV_LEN)
+		sendmsg_res = iovec_bytes(iovec, test_data->vecs_cnt);
+	else
+		sendmsg_res = test_data->sendmsg_res;
+
+	if (sendmsg(fd, &msg, MSG_ZEROCOPY) != sendmsg_res) {
+		perror("send");
+		exit(EXIT_FAILURE);
+	}
+
+	if (errno != test_data->sendmsg_errno) {
+		fprintf(stderr, "expected 'errno' == %i, got %i\n",
+			test_data->sendmsg_errno, errno);
+		exit(EXIT_FAILURE);
+	}
+
+	do_recv_completion(fd, test_data->zerocopied, test_data->completion);
+
+	if (test_data->sendmsg_res == SENDMSG_RES_IOV_LEN)
+		control_writeulong(iovec_hash_djb2(iovec, test_data->vecs_cnt));
+	else
+		control_writeulong(0);
+
+	for (i = 0; i < test_data->vecs_cnt; i++) {
+		if (test_data->vecs[i].iov_base != MAP_FAILED) {
+			if (munmap(iovec[i].iov_base, iovec[i].iov_len)) {
+				perror("munmap");
+				exit(EXIT_FAILURE);
+			}
+		}
+	}
+
+	free(iovec);
+	close(fd);
+	control_writeln("DONE");
+}
+
+static void __test_stream_msg_zerocopy_server(const struct test_opts *opts,
+					      const struct zerocopy_test_data *test_data)
+{
+	unsigned long remote_hash;
+	unsigned long local_hash;
+	ssize_t total_bytes_rec;
+	unsigned char *data;
+	size_t data_len;
+	int fd;
+
+	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+	if (fd < 0) {
+		perror("accept");
+		exit(EXIT_FAILURE);
+	}
+
+	data_len = iovec_bytes(test_data->vecs, test_data->vecs_cnt);
+
+	data = malloc(data_len);
+	if (!data) {
+		perror("malloc");
+		exit(EXIT_FAILURE);
+	}
+
+	total_bytes_rec = 0;
+
+	while (total_bytes_rec != data_len) {
+		ssize_t bytes_rec;
+
+		bytes_rec = read(fd, data + total_bytes_rec,
+				 data_len - total_bytes_rec);
+		if (bytes_rec <= 0)
+			break;
+
+		total_bytes_rec += bytes_rec;
+	}
+
+	if (test_data->sendmsg_res == SENDMSG_RES_IOV_LEN)
+		local_hash = hash_djb2(data, data_len);
+	else
+		local_hash = 0;
+
+	free(data);
+
+	/* Waiting for some result. */
+	remote_hash = control_readulong();
+	if (remote_hash != local_hash) {
+		fprintf(stderr, "hash mismatch\n");
+		exit(EXIT_FAILURE);
+	}
+
+	close(fd);
+	control_expectln("DONE");
+}
+
+void test_stream_msg_zcopy_client(const struct test_opts *opts)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
+		__test_stream_msg_zerocopy_client(opts, &test_data_array[i]);
+}
+
+void test_stream_msg_zcopy_server(const struct test_opts *opts)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
+		__test_stream_msg_zerocopy_server(opts, &test_data_array[i]);
+}
+
+void test_stream_msg_zcopy_empty_errq_client(const struct test_opts *opts)
+{
+	struct msghdr msg = { 0 };
+	char cmsg_data[128];
+	ssize_t res;
+	int fd;
+
+	fd = vsock_stream_connect(opts->peer_cid, 1234);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	msg.msg_control = cmsg_data;
+	msg.msg_controllen = sizeof(cmsg_data);
+
+	res = recvmsg(fd, &msg, MSG_ERRQUEUE);
+	if (res != -1) {
+		fprintf(stderr, "expected 'recvmsg(2)' failure, got %zi\n",
+			res);
+		exit(EXIT_FAILURE);
+	}
+
+	control_writeln("DONE");
+	close(fd);
+}
+
+void test_stream_msg_zcopy_empty_errq_server(const struct test_opts *opts)
+{
+	int fd;
+
+	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+	if (fd < 0) {
+		perror("accept");
+		exit(EXIT_FAILURE);
+	}
+
+	control_expectln("DONE");
+	close(fd);
+}
diff --git a/tools/testing/vsock/vsock_test_zerocopy.h b/tools/testing/vsock/vsock_test_zerocopy.h
new file mode 100644
index 000000000000..705a1e90f41a
--- /dev/null
+++ b/tools/testing/vsock/vsock_test_zerocopy.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef VSOCK_TEST_ZEROCOPY_H
+#define VSOCK_TEST_ZEROCOPY_H
+#include "util.h"
+
+void test_stream_msg_zcopy_client(const struct test_opts *opts);
+void test_stream_msg_zcopy_server(const struct test_opts *opts);
+
+void test_stream_msg_zcopy_empty_errq_client(const struct test_opts *opts);
+void test_stream_msg_zcopy_empty_errq_server(const struct test_opts *opts);
+
+#endif /* VSOCK_TEST_ZEROCOPY_H */
-- 
2.25.1

