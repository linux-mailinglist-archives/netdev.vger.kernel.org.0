Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECB3A7DEF7
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 17:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732746AbfHAP0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 11:26:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38008 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732735AbfHAP0R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 11:26:17 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EB6FE3179B5F;
        Thu,  1 Aug 2019 15:26:16 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-63.ams2.redhat.com [10.36.117.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB2F5600D1;
        Thu,  1 Aug 2019 15:26:14 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     kvm@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 10/11] vsock_test: skip read() in test_stream*close tests on a VMCI host
Date:   Thu,  1 Aug 2019 17:25:40 +0200
Message-Id: <20190801152541.245833-11-sgarzare@redhat.com>
In-Reply-To: <20190801152541.245833-1-sgarzare@redhat.com>
References: <20190801152541.245833-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 01 Aug 2019 15:26:17 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When VMCI transport is used, if the guest closes a connection,
all data is gone and EOF is returned, so we should skip the read
of data written by the peer before closing the connection.

Reported-by: Jorgen Hansen <jhansen@vmware.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 tools/testing/vsock/vsock_test.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index cb606091489f..64adf45501ca 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -71,6 +71,7 @@ static void test_stream_client_close_client(const struct test_opts *opts)
 
 static void test_stream_client_close_server(const struct test_opts *opts)
 {
+	unsigned int local_cid;
 	int fd;
 
 	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
@@ -79,16 +80,27 @@ static void test_stream_client_close_server(const struct test_opts *opts)
 		exit(EXIT_FAILURE);
 	}
 
+	local_cid = vsock_get_local_cid(fd);
+
 	control_expectln("CLOSED");
 
 	send_byte(fd, -EPIPE);
-	recv_byte(fd, 1);
+
+	/* Skip the read of data wrote by the peer if we are on VMCI and
+	 * we are on the host side, because when the guest closes a
+	 * connection, all data is gone and EOF is returned.
+	 */
+	if (!(opts->transport == TEST_TRANSPORT_VMCI &&
+	    local_cid == VMADDR_CID_HOST))
+		recv_byte(fd, 1);
+
 	recv_byte(fd, 0);
 	close(fd);
 }
 
 static void test_stream_server_close_client(const struct test_opts *opts)
 {
+	unsigned int local_cid;
 	int fd;
 
 	fd = vsock_stream_connect(opts->peer_cid, 1234);
@@ -97,10 +109,20 @@ static void test_stream_server_close_client(const struct test_opts *opts)
 		exit(EXIT_FAILURE);
 	}
 
+	local_cid = vsock_get_local_cid(fd);
+
 	control_expectln("CLOSED");
 
 	send_byte(fd, -EPIPE);
-	recv_byte(fd, 1);
+
+	/* Skip the read of data wrote by the peer if we are on VMCI and
+	 * we are on the host side, because when the guest closes a
+	 * connection, all data is gone and EOF is returned.
+	 */
+	if (!(opts->transport == TEST_TRANSPORT_VMCI &&
+	    local_cid == VMADDR_CID_HOST))
+		recv_byte(fd, 1);
+
 	recv_byte(fd, 0);
 	close(fd);
 }
-- 
2.20.1

