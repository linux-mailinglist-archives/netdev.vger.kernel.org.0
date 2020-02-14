Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B380A15D6D3
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 12:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgBNLsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 06:48:50 -0500
Received: from mga04.intel.com ([192.55.52.120]:59363 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727835AbgBNLsu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 06:48:50 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 03:48:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,440,1574150400"; 
   d="scan'208";a="228468552"
Received: from dsitkin-mobl.ccr.corp.intel.com (HELO localhost.localdomain) ([10.252.24.179])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2020 03:48:48 -0800
From:   Sebastien Boeuf <sebastien.boeuf@intel.com>
To:     netdev@vger.kernel.org
Cc:     sgarzare@redhat.com, stefanha@redhat.com, davem@davemloft.net,
        Sebastien Boeuf <sebastien.boeuf@intel.com>
Subject: [PATCH v3 2/2] tools: testing: vsock: Test when server is bound but not listening
Date:   Fri, 14 Feb 2020 12:48:02 +0100
Message-Id: <20200214114802.23638-3-sebastien.boeuf@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214114802.23638-1-sebastien.boeuf@intel.com>
References: <20200214114802.23638-1-sebastien.boeuf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever the server side of vsock is binding to the socket, but not
listening yet, we expect the behavior from the client to be identical to
what happens when the server is not even started.

This new test runs the server side so that it binds to the socket
without ever listening to it. The client side will try to connect and
should receive an ECONNRESET error.

This new test provides a way to validate the previously introduced patch
for making sure the server side will always answer with a RST packet in
case the client requested a new connection.

Signed-off-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
---
 tools/testing/vsock/vsock_test.c | 77 ++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index 1d8b93f1af31..5a4fb80fa832 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -55,6 +55,78 @@ static void test_stream_connection_reset(const struct test_opts *opts)
 	close(fd);
 }
 
+static void test_stream_bind_only_client(const struct test_opts *opts)
+{
+	union {
+		struct sockaddr sa;
+		struct sockaddr_vm svm;
+	} addr = {
+		.svm = {
+			.svm_family = AF_VSOCK,
+			.svm_port = 1234,
+			.svm_cid = opts->peer_cid,
+		},
+	};
+	int ret;
+	int fd;
+
+	/* Wait for the server to be ready */
+	control_expectln("BIND");
+
+	fd = socket(AF_VSOCK, SOCK_STREAM, 0);
+
+	timeout_begin(TIMEOUT);
+	do {
+		ret = connect(fd, &addr.sa, sizeof(addr.svm));
+		timeout_check("connect");
+	} while (ret < 0 && errno == EINTR);
+	timeout_end();
+
+	if (ret != -1) {
+		fprintf(stderr, "expected connect(2) failure, got %d\n", ret);
+		exit(EXIT_FAILURE);
+	}
+	if (errno != ECONNRESET) {
+		fprintf(stderr, "unexpected connect(2) errno %d\n", errno);
+		exit(EXIT_FAILURE);
+	}
+
+	/* Notify the server that the client has finished */
+	control_writeln("DONE");
+
+	close(fd);
+}
+
+static void test_stream_bind_only_server(const struct test_opts *opts)
+{
+	union {
+		struct sockaddr sa;
+		struct sockaddr_vm svm;
+	} addr = {
+		.svm = {
+			.svm_family = AF_VSOCK,
+			.svm_port = 1234,
+			.svm_cid = VMADDR_CID_ANY,
+		},
+	};
+	int fd;
+
+	fd = socket(AF_VSOCK, SOCK_STREAM, 0);
+
+	if (bind(fd, &addr.sa, sizeof(addr.svm)) < 0) {
+		perror("bind");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Notify the client that the server is ready */
+	control_writeln("BIND");
+
+	/* Wait for the client to finish */
+	control_expectln("DONE");
+
+	close(fd);
+}
+
 static void test_stream_client_close_client(const struct test_opts *opts)
 {
 	int fd;
@@ -212,6 +284,11 @@ static struct test_case test_cases[] = {
 		.name = "SOCK_STREAM connection reset",
 		.run_client = test_stream_connection_reset,
 	},
+	{
+		.name = "SOCK_STREAM bind only",
+		.run_client = test_stream_bind_only_client,
+		.run_server = test_stream_bind_only_server,
+	},
 	{
 		.name = "SOCK_STREAM client close",
 		.run_client = test_stream_client_close_client,
-- 
2.20.1

---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

