Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACB967DEED
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 17:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732646AbfHAP0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 11:26:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35262 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732631AbfHAP0C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 11:26:02 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 55A29C08EC0A;
        Thu,  1 Aug 2019 15:26:02 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-63.ams2.redhat.com [10.36.117.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2A35600C4;
        Thu,  1 Aug 2019 15:25:59 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     kvm@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 05/11] VSOCK: add full barrier between test cases
Date:   Thu,  1 Aug 2019 17:25:35 +0200
Message-Id: <20190801152541.245833-6-sgarzare@redhat.com>
In-Reply-To: <20190801152541.245833-1-sgarzare@redhat.com>
References: <20190801152541.245833-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 01 Aug 2019 15:26:02 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Hajnoczi <stefanha@redhat.com>

See code comment for details.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 tools/testing/vsock/util.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index f838bcee3589..4280a56ba677 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -161,10 +161,24 @@ void run_tests(const struct test_case *test_cases,
 		printf("%s...", test_cases[i].name);
 		fflush(stdout);
 
-		if (opts->mode == TEST_MODE_CLIENT)
+		if (opts->mode == TEST_MODE_CLIENT) {
+			/* Full barrier before executing the next test.  This
+			 * ensures that client and server are executing the
+			 * same test case.  In particular, it means whoever is
+			 * faster will not see the peer still executing the
+			 * last test.  This is important because port numbers
+			 * can be used by multiple test cases.
+			 */
+			control_expectln("NEXT");
+			control_writeln("NEXT");
+
 			run = test_cases[i].run_client;
-		else
+		} else {
+			control_writeln("NEXT");
+			control_expectln("NEXT");
+
 			run = test_cases[i].run_server;
+		}
 
 		if (run)
 			run(opts);
-- 
2.20.1

