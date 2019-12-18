Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40F55125055
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 19:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfLRSIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 13:08:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36832 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727527AbfLRSHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 13:07:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576692463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mub2wd3Ra/02EpcL0dbiRF0hcLXprsOY9Pb/jiP+caQ=;
        b=XgPWDXGyuxiG6+ynoVFwTG5w9eO01IEA2BE7AKNGXCqbkyHr3EPRgs4L4dxCUMbs0rIZGX
        HCjsHKoVikJc+Jhtk8/41gt1PPSzpJVE44neTz6n8pyf/NfZS+DpJbev6stxniquwRuQfc
        3AE/SPbrUWyOykTpjehj7fxk60hC/eY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-85-OGXhYp4LOFqXDxkkZZZRtQ-1; Wed, 18 Dec 2019 13:07:39 -0500
X-MC-Unique: OGXhYp4LOFqXDxkkZZZRtQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C650F1088392;
        Wed, 18 Dec 2019 18:07:37 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-218.ams2.redhat.com [10.36.117.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5DFF5D9E2;
        Wed, 18 Dec 2019 18:07:35 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net
Cc:     Jorgen Hansen <jhansen@vmware.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dexuan Cui <decui@microsoft.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH net-next v3 06/11] VSOCK: add send_byte()/recv_byte() test utilities
Date:   Wed, 18 Dec 2019 19:07:03 +0100
Message-Id: <20191218180708.120337-7-sgarzare@redhat.com>
In-Reply-To: <20191218180708.120337-1-sgarzare@redhat.com>
References: <20191218180708.120337-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Hajnoczi <stefanha@redhat.com>

Test cases will want to transfer data.  This patch adds utility
functions to do this.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
v3:
 * check the byte received in the recv_byte()
 * use send(2)/recv(2) instead of write(2)/read(2) to test also flags
   (e.g. MSG_PEEK)
---
 tools/testing/vsock/util.c | 103 +++++++++++++++++++++++++++++++++++++
 tools/testing/vsock/util.h |   2 +
 2 files changed, 105 insertions(+)

diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index 4280a56ba677..6026ef3ce512 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -9,6 +9,7 @@
=20
 #include <errno.h>
 #include <stdio.h>
+#include <stdint.h>
 #include <stdlib.h>
 #include <signal.h>
 #include <unistd.h>
@@ -149,6 +150,108 @@ int vsock_stream_accept(unsigned int cid, unsigned =
int port,
 	return client_fd;
 }
=20
+/* Transmit one byte and check the return value.
+ *
+ * expected_ret:
+ *  <0 Negative errno (for testing errors)
+ *   0 End-of-file
+ *   1 Success
+ */
+void send_byte(int fd, int expected_ret, int flags)
+{
+	const uint8_t byte =3D 'A';
+	ssize_t nwritten;
+
+	timeout_begin(TIMEOUT);
+	do {
+		nwritten =3D send(fd, &byte, sizeof(byte), flags);
+		timeout_check("write");
+	} while (nwritten < 0 && errno =3D=3D EINTR);
+	timeout_end();
+
+	if (expected_ret < 0) {
+		if (nwritten !=3D -1) {
+			fprintf(stderr, "bogus send(2) return value %zd\n",
+				nwritten);
+			exit(EXIT_FAILURE);
+		}
+		if (errno !=3D -expected_ret) {
+			perror("write");
+			exit(EXIT_FAILURE);
+		}
+		return;
+	}
+
+	if (nwritten < 0) {
+		perror("write");
+		exit(EXIT_FAILURE);
+	}
+	if (nwritten =3D=3D 0) {
+		if (expected_ret =3D=3D 0)
+			return;
+
+		fprintf(stderr, "unexpected EOF while sending byte\n");
+		exit(EXIT_FAILURE);
+	}
+	if (nwritten !=3D sizeof(byte)) {
+		fprintf(stderr, "bogus send(2) return value %zd\n", nwritten);
+		exit(EXIT_FAILURE);
+	}
+}
+
+/* Receive one byte and check the return value.
+ *
+ * expected_ret:
+ *  <0 Negative errno (for testing errors)
+ *   0 End-of-file
+ *   1 Success
+ */
+void recv_byte(int fd, int expected_ret, int flags)
+{
+	uint8_t byte;
+	ssize_t nread;
+
+	timeout_begin(TIMEOUT);
+	do {
+		nread =3D recv(fd, &byte, sizeof(byte), flags);
+		timeout_check("read");
+	} while (nread < 0 && errno =3D=3D EINTR);
+	timeout_end();
+
+	if (expected_ret < 0) {
+		if (nread !=3D -1) {
+			fprintf(stderr, "bogus recv(2) return value %zd\n",
+				nread);
+			exit(EXIT_FAILURE);
+		}
+		if (errno !=3D -expected_ret) {
+			perror("read");
+			exit(EXIT_FAILURE);
+		}
+		return;
+	}
+
+	if (nread < 0) {
+		perror("read");
+		exit(EXIT_FAILURE);
+	}
+	if (nread =3D=3D 0) {
+		if (expected_ret =3D=3D 0)
+			return;
+
+		fprintf(stderr, "unexpected EOF while receiving byte\n");
+		exit(EXIT_FAILURE);
+	}
+	if (nread !=3D sizeof(byte)) {
+		fprintf(stderr, "bogus recv(2) return value %zd\n", nread);
+		exit(EXIT_FAILURE);
+	}
+	if (byte !=3D 'A') {
+		fprintf(stderr, "unexpected byte read %c\n", byte);
+		exit(EXIT_FAILURE);
+	}
+}
+
 /* Run test cases.  The program terminates if a failure occurs. */
 void run_tests(const struct test_case *test_cases,
 	       const struct test_opts *opts)
diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
index 1786305cfddd..4df12e4b5ebe 100644
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -36,6 +36,8 @@ unsigned int parse_cid(const char *str);
 int vsock_stream_connect(unsigned int cid, unsigned int port);
 int vsock_stream_accept(unsigned int cid, unsigned int port,
 			struct sockaddr_vm *clientaddrp);
+void send_byte(int fd, int expected_ret, int flags);
+void recv_byte(int fd, int expected_ret, int flags);
 void run_tests(const struct test_case *test_cases,
 	       const struct test_opts *opts);
=20
--=20
2.24.1

