Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E706D12504C
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 19:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727753AbfLRSIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 13:08:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57266 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727654AbfLRSH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 13:07:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576692475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7lW+cxoZMuu0TO4yVVOLW4Vw9qRm3Vps7ty8G8tFB/M=;
        b=Eib+zEJ584HaGpZVUfoip756On+DDGWncFxDTeekFqily6VFbmtcwo2i8PE74KkUug/WvH
        PpliimjlAgVnIuneZFv/jxggm7B4l2+bZYsnl3fOMDv//3jmHjsti2iP3FBrXmDDwmg7CA
        atTUIkNkTFzP1sUHw34EySJxNyvr2bY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-MStQOSH1NAmxIEs9wBUUZw-1; Wed, 18 Dec 2019 13:07:50 -0500
X-MC-Unique: MStQOSH1NAmxIEs9wBUUZw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BFFC8C3ECB;
        Wed, 18 Dec 2019 18:07:49 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-218.ams2.redhat.com [10.36.117.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A83B5D9E5;
        Wed, 18 Dec 2019 18:07:44 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net
Cc:     Jorgen Hansen <jhansen@vmware.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dexuan Cui <decui@microsoft.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH net-next v3 08/11] vsock_test: wait for the remote to close the connection
Date:   Wed, 18 Dec 2019 19:07:05 +0100
Message-Id: <20191218180708.120337-9-sgarzare@redhat.com>
In-Reply-To: <20191218180708.120337-1-sgarzare@redhat.com>
References: <20191218180708.120337-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
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
v3:
 - removed unnecessary control_expectln("CLOSED") [Stefan]
---
 tools/testing/vsock/util.c       | 39 ++++++++++++++++++++++++++++++++
 tools/testing/vsock/util.h       |  1 +
 tools/testing/vsock/vsock_test.c | 12 ++++++----
 3 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index 6026ef3ce512..b132c96c87fc 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -13,6 +13,8 @@
 #include <stdlib.h>
 #include <signal.h>
 #include <unistd.h>
+#include <assert.h>
+#include <sys/epoll.h>
=20
 #include "timeout.h"
 #include "control.h"
@@ -44,6 +46,43 @@ unsigned int parse_cid(const char *str)
 	return n;
 }
=20
+/* Wait for the remote to close the connection */
+void vsock_wait_remote_close(int fd)
+{
+	struct epoll_event ev;
+	int epollfd, nfds;
+
+	epollfd =3D epoll_create1(0);
+	if (epollfd =3D=3D -1) {
+		perror("epoll_create1");
+		exit(EXIT_FAILURE);
+	}
+
+	ev.events =3D EPOLLRDHUP | EPOLLHUP;
+	ev.data.fd =3D fd;
+	if (epoll_ctl(epollfd, EPOLL_CTL_ADD, fd, &ev) =3D=3D -1) {
+		perror("epoll_ctl");
+		exit(EXIT_FAILURE);
+	}
+
+	nfds =3D epoll_wait(epollfd, &ev, 1, TIMEOUT * 1000);
+	if (nfds =3D=3D -1) {
+		perror("epoll_wait");
+		exit(EXIT_FAILURE);
+	}
+
+	if (nfds =3D=3D 0) {
+		fprintf(stderr, "epoll_wait timed out\n");
+		exit(EXIT_FAILURE);
+	}
+
+	assert(nfds =3D=3D 1);
+	assert(ev.events & (EPOLLRDHUP | EPOLLHUP));
+	assert(ev.data.fd =3D=3D fd);
+
+	close(epollfd);
+}
+
 /* Connect to <cid, port> and return the file descriptor. */
 int vsock_stream_connect(unsigned int cid, unsigned int port)
 {
diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
index 4df12e4b5ebe..331e945f3ae6 100644
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -36,6 +36,7 @@ unsigned int parse_cid(const char *str);
 int vsock_stream_connect(unsigned int cid, unsigned int port);
 int vsock_stream_accept(unsigned int cid, unsigned int port,
 			struct sockaddr_vm *clientaddrp);
+void vsock_wait_remote_close(int fd);
 void send_byte(int fd, int expected_ret, int flags);
 void recv_byte(int fd, int expected_ret, int flags);
 void run_tests(const struct test_case *test_cases,
diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock=
_test.c
index fae8ddc3ef72..629d7ce58202 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -66,7 +66,6 @@ static void test_stream_client_close_client(const struc=
t test_opts *opts)
=20
 	send_byte(fd, 1, 0);
 	close(fd);
-	control_writeln("CLOSED");
 }
=20
 static void test_stream_client_close_server(const struct test_opts *opts=
)
@@ -79,7 +78,10 @@ static void test_stream_client_close_server(const stru=
ct test_opts *opts)
 		exit(EXIT_FAILURE);
 	}
=20
-	control_expectln("CLOSED");
+	/* Wait for the remote to close the connection, before check
+	 * -EPIPE error on send.
+	 */
+	vsock_wait_remote_close(fd);
=20
 	send_byte(fd, -EPIPE, 0);
 	recv_byte(fd, 1, 0);
@@ -97,7 +99,10 @@ static void test_stream_server_close_client(const stru=
ct test_opts *opts)
 		exit(EXIT_FAILURE);
 	}
=20
-	control_expectln("CLOSED");
+	/* Wait for the remote to close the connection, before check
+	 * -EPIPE error on send.
+	 */
+	vsock_wait_remote_close(fd);
=20
 	send_byte(fd, -EPIPE, 0);
 	recv_byte(fd, 1, 0);
@@ -117,7 +122,6 @@ static void test_stream_server_close_server(const str=
uct test_opts *opts)
=20
 	send_byte(fd, 1, 0);
 	close(fd);
-	control_writeln("CLOSED");
 }
=20
 /* With the standard socket sizes, VMCI is able to support about 100
--=20
2.24.1

