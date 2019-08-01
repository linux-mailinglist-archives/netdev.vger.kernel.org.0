Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1187DEE1
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 17:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732728AbfHAP0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 11:26:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43856 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731484AbfHAP0O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 11:26:14 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6CC9514AFB8;
        Thu,  1 Aug 2019 15:26:14 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-63.ams2.redhat.com [10.36.117.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 794ED600D1;
        Thu,  1 Aug 2019 15:26:12 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     kvm@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 09/11] vsock_test: add --transport parameter
Date:   Thu,  1 Aug 2019 17:25:39 +0200
Message-Id: <20190801152541.245833-10-sgarzare@redhat.com>
In-Reply-To: <20190801152541.245833-1-sgarzare@redhat.com>
References: <20190801152541.245833-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 01 Aug 2019 15:26:14 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new --transport parameter to skip some tests or checks
not supported by a specific transport.

Suggested-by: Jorgen Hansen <jhansen@vmware.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 tools/testing/vsock/util.h       |  8 ++++++++
 tools/testing/vsock/vsock_test.c | 20 +++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
index 379e02ab59bb..7fdb8100f035 100644
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -12,9 +12,17 @@ enum test_mode {
 	TEST_MODE_SERVER
 };
 
+enum test_transport {
+	TEST_TRANSPORT_UNSET,
+	TEST_TRANSPORT_VMCI,
+	TEST_TRANSPORT_VIRTIO,
+	TEST_TRANSPORT_HYPERV
+};
+
 /* Test runner options */
 struct test_opts {
 	enum test_mode mode;
+	enum test_transport transport;
 	unsigned int peer_cid;
 };
 
diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index 06099d037405..cb606091489f 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -218,6 +218,11 @@ static const struct option longopts[] = {
 		.has_arg = required_argument,
 		.val = 'p',
 	},
+	{
+		.name = "transport",
+		.has_arg = required_argument,
+		.val = 't',
+	},
 	{
 		.name = "help",
 		.has_arg = no_argument,
@@ -228,7 +233,7 @@ static const struct option longopts[] = {
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: vsock_test [--help] [--control-host=<host>] --control-port=<port> --mode=client|server --peer-cid=<cid>\n"
+	fprintf(stderr, "Usage: vsock_test [--help] [--control-host=<host>] --control-port=<port> --mode=client|server --peer-cid=<cid> [--transport=vmci|virtio|hyperv]\n"
 		"\n"
 		"  Server: vsock_test --control-port=1234 --mode=server --peer-cid=3\n"
 		"  Client: vsock_test --control-host=192.168.0.1 --control-port=1234 --mode=client --peer-cid=2\n"
@@ -252,6 +257,7 @@ int main(int argc, char **argv)
 	const char *control_port = NULL;
 	struct test_opts opts = {
 		.mode = TEST_MODE_UNSET,
+		.transport = TEST_TRANSPORT_UNSET,
 		.peer_cid = VMADDR_CID_ANY,
 	};
 
@@ -283,6 +289,18 @@ int main(int argc, char **argv)
 		case 'P':
 			control_port = optarg;
 			break;
+		case 't':
+			if (strcmp(optarg, "vmci") == 0)
+				opts.transport = TEST_TRANSPORT_VMCI;
+			else if (strcmp(optarg, "virtio") == 0)
+				opts.transport = TEST_TRANSPORT_VIRTIO;
+			else if (strcmp(optarg, "hyperv") == 0)
+				opts.transport = TEST_TRANSPORT_HYPERV;
+			else {
+				fprintf(stderr, "--transport must be \"vmci\" or \"virtio\" or \"hyperv\"\n");
+				return EXIT_FAILURE;
+			}
+			break;
 		case '?':
 		default:
 			usage();
-- 
2.20.1

