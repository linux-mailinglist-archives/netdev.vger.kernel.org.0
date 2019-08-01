Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 936A97DEE6
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 17:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732766AbfHAP0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 11:26:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55936 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732756AbfHAP0T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 11:26:19 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 720BD30B6FAA;
        Thu,  1 Aug 2019 15:26:19 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-63.ams2.redhat.com [10.36.117.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63010600D1;
        Thu,  1 Aug 2019 15:26:17 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     kvm@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 11/11] vsock_test: wait for the remote to close the connection
Date:   Thu,  1 Aug 2019 17:25:41 +0200
Message-Id: <20190801152541.245833-12-sgarzare@redhat.com>
In-Reply-To: <20190801152541.245833-1-sgarzare@redhat.com>
References: <20190801152541.245833-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Thu, 01 Aug 2019 15:26:19 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before check if a send returns -EPIPE, we need to make sure the
connection is closed.
To do that, we use epoll API to wait EPOLLRDHUP or EPOLLHUP events
on the socket.

Reported-by: Jorgen Hansen <jhansen@vmware.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 tools/testing/vsock/util.c       | 38 ++++++++++++++++++++++++++++++++
 tools/testing/vsock/util.h       |  1 +
 tools/testing/vsock/vsock_test.c | 10 +++++++++
 3 files changed, 49 insertions(+)

diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index 41b94495ecb1..425181fe196c 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -14,6 +14,7 @@
 #include <signal.h>
 #include <unistd.h>
 #include <assert.h>
+#include <sys/epoll.h>
 
 #include "timeout.h"
 #include "control.h"
@@ -61,6 +62,43 @@ unsigned int vsock_get_local_cid(int fd)
 	return svm.svm_cid;
 }
 
+/* Wait for the remote to close the connection */
+void vsock_wait_remote_close(int fd)
+{
+	struct epoll_event ev;
+	int epollfd, nfds;
+
+	epollfd = epoll_create1(0);
+	if (epollfd == -1) {
+		perror("epoll_create1");
+		exit(EXIT_FAILURE);
+	}
+
+	ev.events = EPOLLRDHUP | EPOLLHUP;
+	ev.data.fd = fd;
+	if (epoll_ctl(epollfd, EPOLL_CTL_ADD, fd, &ev) == -1) {
+		perror("epoll_ctl");
+		exit(EXIT_FAILURE);
+	}
+
+	nfds = epoll_wait(epollfd, &ev, 1, TIMEOUT * 1000);
+	if (nfds == -1) {
+		perror("epoll_wait");
+		exit(EXIT_FAILURE);
+	}
+
+	if (nfds == 0) {
+		fprintf(stderr, "epoll_wait timed out\n");
+		exit(EXIT_FAILURE);
+	}
+
+	assert(nfds == 1);
+	assert(ev.events & (EPOLLRDHUP | EPOLLHUP));
+	assert(ev.data.fd == fd);
+
+	close(epollfd);
+}
+
 /* Connect to <cid, port> and return the file descriptor. */
 int vsock_stream_connect(unsigned int cid, unsigned int port)
 {
diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
index 7fdb8100f035..89816966c05b 100644
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -45,6 +45,7 @@ int vsock_stream_connect(unsigned int cid, unsigned int port);
 int vsock_stream_accept(unsigned int cid, unsigned int port,
 			struct sockaddr_vm *clientaddrp);
 unsigned int vsock_get_local_cid(int fd);
+void vsock_wait_remote_close(int fd);
 void send_byte(int fd, int expected_ret);
 void recv_byte(int fd, int expected_ret);
 void run_tests(const struct test_case *test_cases,
diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index 64adf45501ca..a664675bec5a 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -84,6 +84,11 @@ static void test_stream_client_close_server(const struct test_opts *opts)
 
 	control_expectln("CLOSED");
 
+	/* Wait for the remote to close the connection, before check
+	 * -EPIPE error on send.
+	 */
+	vsock_wait_remote_close(fd);
+
 	send_byte(fd, -EPIPE);
 
 	/* Skip the read of data wrote by the peer if we are on VMCI and
@@ -113,6 +118,11 @@ static void test_stream_server_close_client(const struct test_opts *opts)
 
 	control_expectln("CLOSED");
 
+	/* Wait for the remote to close the connection, before check
+	 * -EPIPE error on send.
+	 */
+	vsock_wait_remote_close(fd);
+
 	send_byte(fd, -EPIPE);
 
 	/* Skip the read of data wrote by the peer if we are on VMCI and
-- 
2.20.1

