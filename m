Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0426C7DEF5
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 17:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732704AbfHAP0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 11:26:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58422 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731484AbfHAP0M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 11:26:12 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EFE0B927BF;
        Thu,  1 Aug 2019 15:26:11 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-63.ams2.redhat.com [10.36.117.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED24A600D1;
        Thu,  1 Aug 2019 15:26:09 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     kvm@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 08/11] VSOCK: add vsock_get_local_cid() test utility
Date:   Thu,  1 Aug 2019 17:25:38 +0200
Message-Id: <20190801152541.245833-9-sgarzare@redhat.com>
In-Reply-To: <20190801152541.245833-1-sgarzare@redhat.com>
References: <20190801152541.245833-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Thu, 01 Aug 2019 15:26:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds utility to get local CID, useful to
understand if we are in the host or guest.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 tools/testing/vsock/util.c | 17 +++++++++++++++++
 tools/testing/vsock/util.h |  1 +
 2 files changed, 18 insertions(+)

diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index d46a6e079b96..41b94495ecb1 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -13,6 +13,7 @@
 #include <stdlib.h>
 #include <signal.h>
 #include <unistd.h>
+#include <assert.h>
 
 #include "timeout.h"
 #include "control.h"
@@ -44,6 +45,22 @@ unsigned int parse_cid(const char *str)
 	return n;
 }
 
+/* Get the local CID */
+unsigned int vsock_get_local_cid(int fd)
+{
+	struct sockaddr_vm svm;
+	socklen_t svm_len = sizeof(svm);
+
+	if (getsockname(fd, (struct sockaddr *) &svm, &svm_len)) {
+		perror("getsockname");
+		exit(EXIT_FAILURE);
+	}
+
+	assert(svm.svm_family == AF_VSOCK);
+
+	return svm.svm_cid;
+}
+
 /* Connect to <cid, port> and return the file descriptor. */
 int vsock_stream_connect(unsigned int cid, unsigned int port)
 {
diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
index fe524d393d67..379e02ab59bb 100644
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -36,6 +36,7 @@ unsigned int parse_cid(const char *str);
 int vsock_stream_connect(unsigned int cid, unsigned int port);
 int vsock_stream_accept(unsigned int cid, unsigned int port,
 			struct sockaddr_vm *clientaddrp);
+unsigned int vsock_get_local_cid(int fd);
 void send_byte(int fd, int expected_ret);
 void recv_byte(int fd, int expected_ret);
 void run_tests(const struct test_case *test_cases,
-- 
2.20.1

