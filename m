Return-Path: <netdev+bounces-7722-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ABBB721303
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 23:00:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E48232810FE
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 20:59:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E126156F2;
	Sat,  3 Jun 2023 20:55:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9C1FC10
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 20:55:03 +0000 (UTC)
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27711B8;
	Sat,  3 Jun 2023 13:54:59 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
	by mx.sberdevices.ru (Postfix) with ESMTP id 04A085FD3F;
	Sat,  3 Jun 2023 23:54:50 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
	s=mail; t=1685825690;
	bh=viwHYEvceGtDMUIG+aX6fN6oIIWnfCEIyG3Bl7nwYVc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=WpCnBw7xTxwmFDHHr1ihsxJZknnFcUKm3pLdKM+YSxGTUlmubcnI1smELp2XcMddv
	 P8mqHc4Kv3JMK+9w2GTEUosfI+rB4ji1cyc948Guf1m8dHbfgA84/AzAE63GXJvhD9
	 jv8i/HsO8a3wRbwqgF9QtbOnHAplmosZoi/zA9FuRZb/pK+nlsgrrEqo563xwQ2Hlo
	 iusUj7g9iHOT27mQiRayIjsOZcXpi7uvzEiYO3DMknBdSW3NvTJZWRM0fRiQ3nzeGG
	 0wiRZNuMaUTK20crgrNdauOYhGS64NqsGc8lZVt2Ux3hsvRASwwbwzhYifBtMiefyN
	 cqr6CosXZWD5g==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
	by mx.sberdevices.ru (Postfix) with ESMTP;
	Sat,  3 Jun 2023 23:54:49 +0300 (MSK)
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
Subject: [RFC PATCH v4 15/17] test/vsock: MSG_ZEROCOPY flag tests
Date: Sat, 3 Jun 2023 23:49:37 +0300
Message-ID: <20230603204939.1598818-16-AVKrasnov@sberdevices.ru>
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

This adds three tests for MSG_ZEROCOPY feature:
1) SOCK_STREAM tx with different buffers.
1) SOCK_SEQPACKET tx with different buffers.
1) SOCK_STREAM test to read empty error queue of the socket.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 tools/testing/vsock/Makefile              |   2 +-
 tools/testing/vsock/util.c                | 218 +++++++++++++++
 tools/testing/vsock/util.h                |  18 ++
 tools/testing/vsock/vsock_test.c          |  16 ++
 tools/testing/vsock/vsock_test_zerocopy.c | 312 ++++++++++++++++++++++
 tools/testing/vsock/vsock_test_zerocopy.h |  15 ++
 6 files changed, 580 insertions(+), 1 deletion(-)
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
 
diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index 01b636d3039a..81bc7fdafe03 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -11,15 +11,23 @@
 #include <stdio.h>
 #include <stdint.h>
 #include <stdlib.h>
+#include <string.h>
 #include <signal.h>
 #include <unistd.h>
 #include <assert.h>
 #include <sys/epoll.h>
+#include <sys/mman.h>
+#include <linux/errqueue.h>
+#include <poll.h>
 
 #include "timeout.h"
 #include "control.h"
 #include "util.h"
 
+#ifndef SOL_VSOCK
+#define SOL_VSOCK 287
+#endif
+
 /* Install signal handlers */
 void init_signals(void)
 {
@@ -408,3 +416,213 @@ unsigned long hash_djb2(const void *data, size_t len)
 
 	return hash;
 }
+
+void enable_so_zerocopy(int fd)
+{
+	int val = 1;
+
+	if (setsockopt(fd, SOL_SOCKET, SO_ZEROCOPY, &val, sizeof(val))) {
+		perror("mmap");
+		exit(EXIT_FAILURE);
+	}
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
+size_t iovec_bytes(const struct iovec *iov, size_t iovnum)
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
+			      const struct vsock_test_data *test_data)
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
+unsigned long iovec_hash_djb2(struct iovec *iov, size_t iovnum)
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
+struct iovec *iovec_from_test_data(const struct vsock_test_data *test_data)
+{
+	const struct iovec *test_iovec;
+	struct iovec *iovec;
+	int i;
+
+	iovec = malloc(sizeof(*iovec) * test_data->vecs_cnt);
+	if (!iovec) {
+		perror("malloc");
+		exit(EXIT_FAILURE);
+	}
+
+	test_iovec = test_data->vecs;
+
+	for (i = 0; i < test_data->vecs_cnt; i++) {
+		iovec[i].iov_len = test_iovec[i].iov_len;
+		iovec[i].iov_base = mmap_no_fail(test_iovec[i].iov_len);
+
+		if (test_iovec[i].iov_base != MAP_FAILED &&
+		    test_iovec[i].iov_base)
+			iovec[i].iov_base += (uintptr_t)test_iovec[i].iov_base;
+	}
+
+	/* Unmap "invalid" elements. */
+	for (i = 0; i < test_data->vecs_cnt; i++) {
+		if (test_iovec[i].iov_base == MAP_FAILED) {
+			if (munmap(iovec[i].iov_base, iovec[i].iov_len)) {
+				perror("munmap");
+				exit(EXIT_FAILURE);
+			}
+		}
+	}
+
+	iovec_random_init(iovec, test_data);
+
+	return iovec;
+}
+
+void free_iovec_test_data(const struct vsock_test_data *test_data,
+			  struct iovec *iovec)
+{
+	int i;
+
+	for (i = 0; i < test_data->vecs_cnt; i++) {
+		if (test_data->vecs[i].iov_base != MAP_FAILED) {
+			if (test_data->vecs[i].iov_base)
+				iovec[i].iov_base -= (uintptr_t)test_data->vecs[i].iov_base;
+
+			if (munmap(iovec[i].iov_base, iovec[i].iov_len)) {
+				perror("munmap");
+				exit(EXIT_FAILURE);
+			}
+		}
+	}
+
+	free(iovec);
+}
+
+#define POLL_TIMEOUT_MS		100
+void vsock_recv_completion(int fd, bool zerocopied, bool completion)
+{
+	struct sock_extended_err *serr;
+	struct msghdr msg = { 0 };
+	struct pollfd fds = { 0 };
+	char cmsg_data[128];
+	struct cmsghdr *cm;
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
+		fprintf(stderr, "serr: wrong origin: %u\n", serr->ee_origin);
+		exit(EXIT_FAILURE);
+	}
+
+	if (serr->ee_errno) {
+		fprintf(stderr, "serr: wrong error code: %u\n", serr->ee_errno);
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
diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
index fb99208a95ea..d07c1a9c2e0a 100644
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -2,6 +2,7 @@
 #ifndef UTIL_H
 #define UTIL_H
 
+#include <stdbool.h>
 #include <sys/socket.h>
 #include <linux/vm_sockets.h>
 
@@ -18,6 +19,16 @@ struct test_opts {
 	unsigned int peer_cid;
 };
 
+#define VSOCK_TEST_DATA_MAX_IOV 4
+
+struct vsock_test_data {
+	bool zerocopied;	/* Data must be zerocopied. */
+	bool completion;	/* Must dequeue completion. */
+	int sendmsg_errno;	/* 'errno' after 'sendmsg()'. */
+	int vecs_cnt;		/* Number of elements in 'vecs'. */
+	struct iovec vecs[VSOCK_TEST_DATA_MAX_IOV];
+};
+
 /* A test case definition.  Test functions must print failures to stderr and
  * terminate with exit(EXIT_FAILURE).
  */
@@ -50,4 +61,11 @@ void list_tests(const struct test_case *test_cases);
 void skip_test(struct test_case *test_cases, size_t test_cases_len,
 	       const char *test_id_str);
 unsigned long hash_djb2(const void *data, size_t len);
+void enable_so_zerocopy(int fd);
+size_t iovec_bytes(const struct iovec *iov, size_t iovnum);
+unsigned long iovec_hash_djb2(struct iovec *iov, size_t iovnum);
+struct iovec *iovec_from_test_data(const struct vsock_test_data *test_data);
+void free_iovec_test_data(const struct vsock_test_data *test_data,
+			  struct iovec *iovec);
+void vsock_recv_completion(int fd, bool zerocopied, bool completion);
 #endif /* UTIL_H */
diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index ac1bd3ac1533..d576b18bd357 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -20,6 +20,7 @@
 #include <sys/mman.h>
 #include <poll.h>
 
+#include "vsock_test_zerocopy.h"
 #include "timeout.h"
 #include "control.h"
 #include "util.h"
@@ -1128,6 +1129,21 @@ static struct test_case test_cases[] = {
 		.run_client = test_stream_virtio_skb_merge_client,
 		.run_server = test_stream_virtio_skb_merge_server,
 	},
+	{
+		.name = "SOCK_STREAM MSG_ZEROCOPY",
+		.run_client = test_stream_msg_zcopy_client,
+		.run_server = test_stream_msg_zcopy_server,
+	},
+	{
+		.name = "SOCK_SEQPACKET MSG_ZEROCOPY",
+		.run_client = test_seqpacket_msg_zcopy_client,
+		.run_server = test_seqpacket_msg_zcopy_server,
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
index 000000000000..c5539c5dbded
--- /dev/null
+++ b/tools/testing/vsock/vsock_test_zerocopy.c
@@ -0,0 +1,312 @@
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
+#define PAGE_SIZE		4096
+
+static struct vsock_test_data test_data_array[] = {
+	/* Last element has non-page aligned size. */
+	{
+		.zerocopied = true,
+		.completion = true,
+		.sendmsg_errno = 0,
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
+		.vecs_cnt = 3,
+		{
+			{ NULL, PAGE_SIZE },
+			{ NULL, PAGE_SIZE },
+			{ NULL, PAGE_SIZE }
+		}
+	},
+	/* Middle element has non-page aligned size. */
+	{
+		.zerocopied = true,
+		.completion = true,
+		.sendmsg_errno = 0,
+		.vecs_cnt = 3,
+		{
+			{ NULL, PAGE_SIZE },
+			{ NULL, 100 },
+			{ NULL, PAGE_SIZE }
+		}
+	},
+	/* Middle element has both non-page aligned base and size. */
+	{
+		.zerocopied = true,
+		.completion = true,
+		.sendmsg_errno = 0,
+		.vecs_cnt = 3,
+		{
+			{ NULL, PAGE_SIZE },
+			{ (void *)1, 100 },
+			{ NULL, PAGE_SIZE }
+		}
+	},
+	/* Middle element is unmapped. */
+	{
+		.zerocopied = false,
+		.completion = false,
+		.sendmsg_errno = ENOMEM,
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
+		.vecs_cnt = 1,
+		{
+			{ NULL, PAGE_SIZE }
+		}
+	},
+};
+
+static void __test_msg_zerocopy_client(const struct test_opts *opts,
+				       const struct vsock_test_data *test_data,
+				       bool sock_seqpacket)
+{
+	struct msghdr msg = { 0 };
+	ssize_t sendmsg_res;
+	struct iovec *iovec;
+	int fd;
+
+	if (sock_seqpacket)
+		fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
+	else
+		fd = vsock_stream_connect(opts->peer_cid, 1234);
+
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	if (test_data->completion)
+		enable_so_zerocopy(fd);
+
+	iovec = iovec_from_test_data(test_data);
+
+	msg.msg_iov = iovec;
+	msg.msg_iovlen = test_data->vecs_cnt;
+
+	errno = 0;
+
+	sendmsg_res = sendmsg(fd, &msg, MSG_ZEROCOPY);
+	if (errno != test_data->sendmsg_errno) {
+		fprintf(stderr, "expected 'errno' == %i, got %i\n",
+			test_data->sendmsg_errno, errno);
+		exit(EXIT_FAILURE);
+	}
+
+	if (!errno) {
+		if (sendmsg_res != iovec_bytes(iovec, test_data->vecs_cnt)) {
+			fprintf(stderr, "expected 'sendmsg()' == %li, got %li\n",
+				iovec_bytes(iovec, test_data->vecs_cnt),
+				sendmsg_res);
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	vsock_recv_completion(fd, test_data->zerocopied, test_data->completion);
+
+	if (test_data->sendmsg_errno == 0)
+		control_writeulong(iovec_hash_djb2(iovec, test_data->vecs_cnt));
+	else
+		control_writeulong(0);
+
+	control_writeln("DONE");
+	free_iovec_test_data(test_data, iovec);
+	close(fd);
+}
+
+void test_stream_msg_zcopy_client(const struct test_opts *opts)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
+		__test_msg_zerocopy_client(opts, &test_data_array[i], false);
+}
+
+void test_seqpacket_msg_zcopy_client(const struct test_opts *opts)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
+		__test_msg_zerocopy_client(opts, &test_data_array[i], true);
+}
+
+static void __test_stream_server(const struct test_opts *opts,
+				 const struct vsock_test_data *test_data,
+				 bool sock_seqpacket)
+{
+	unsigned long remote_hash;
+	unsigned long local_hash;
+	ssize_t total_bytes_rec;
+	unsigned char *data;
+	size_t data_len;
+	int fd;
+
+	if (sock_seqpacket)
+		fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
+	else
+		fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+
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
+	if (test_data->sendmsg_errno == 0)
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
+	control_expectln("DONE");
+	close(fd);
+}
+
+void test_stream_msg_zcopy_server(const struct test_opts *opts)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
+		__test_stream_server(opts, &test_data_array[i], false);
+}
+
+void test_seqpacket_msg_zcopy_server(const struct test_opts *opts)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
+		__test_stream_server(opts, &test_data_array[i], true);
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
index 000000000000..220b4f94f042
--- /dev/null
+++ b/tools/testing/vsock/vsock_test_zerocopy.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef VSOCK_TEST_ZEROCOPY_H
+#define VSOCK_TEST_ZEROCOPY_H
+#include "util.h"
+
+void test_stream_msg_zcopy_client(const struct test_opts *opts);
+void test_stream_msg_zcopy_server(const struct test_opts *opts);
+
+void test_seqpacket_msg_zcopy_client(const struct test_opts *opts);
+void test_seqpacket_msg_zcopy_server(const struct test_opts *opts);
+
+void test_stream_msg_zcopy_empty_errq_client(const struct test_opts *opts);
+void test_stream_msg_zcopy_empty_errq_server(const struct test_opts *opts);
+
+#endif /* VSOCK_TEST_ZEROCOPY_H */
-- 
2.25.1


