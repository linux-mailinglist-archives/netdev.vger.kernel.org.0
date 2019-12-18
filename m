Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4472A125051
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 19:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfLRSH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 13:07:26 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46289 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727367AbfLRSHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 13:07:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576692443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ak7zDmp1/cfdOQnn19i2bAKVAQPiklhpPuuaiXWuaLc=;
        b=VmpakIWa/jcrYN620jT3HHVjYB/8IVFpU9v95zWIy4/XsMolDr4DSEHSyFN8t5DcUPHXjy
        0bIvgcTl4ysMykcCtIR0y59SrhPVj4fMbRxarX2hf0cWRxpqn7IUMzCpc8mZlaV4ZsEdVk
        lEnf6NZQAFHLzFbsa9Du5EZSy+kqBUU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-WFFPBcoKMuGlKOSiuW5jFg-1; Wed, 18 Dec 2019 13:07:20 -0500
X-MC-Unique: WFFPBcoKMuGlKOSiuW5jFg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 896C6100726C;
        Wed, 18 Dec 2019 18:07:18 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-218.ams2.redhat.com [10.36.117.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E5F45D9E2;
        Wed, 18 Dec 2019 18:07:16 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net
Cc:     Jorgen Hansen <jhansen@vmware.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dexuan Cui <decui@microsoft.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH net-next v3 01/11] VSOCK: fix header include in vsock_diag_test
Date:   Wed, 18 Dec 2019 19:06:58 +0100
Message-Id: <20191218180708.120337-2-sgarzare@redhat.com>
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

The vsock_diag_test program directly included ../../../include/uapi/
headers from the source tree.  Tests are supposed to use the
usr/include/linux/ headers that have been prepared with make
headers_install instead.

Suggested-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 tools/testing/vsock/Makefile          | 2 +-
 tools/testing/vsock/README            | 2 +-
 tools/testing/vsock/vsock_diag_test.c | 5 ++---
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/testing/vsock/Makefile b/tools/testing/vsock/Makefile
index 5be687b1e16c..d41a4e13960a 100644
--- a/tools/testing/vsock/Makefile
+++ b/tools/testing/vsock/Makefile
@@ -3,7 +3,7 @@ all: test
 test: vsock_diag_test
 vsock_diag_test: vsock_diag_test.o timeout.o control.o
=20
-CFLAGS +=3D -g -O2 -Werror -Wall -I. -I../../include/uapi -I../../includ=
e -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common=
 -MMD -U_FORTIFY_SOURCE -D_GNU_SOURCE
+CFLAGS +=3D -g -O2 -Werror -Wall -I. -I../../include -I../../../usr/incl=
ude -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-comm=
on -MMD -U_FORTIFY_SOURCE -D_GNU_SOURCE
 .PHONY: all test clean
 clean:
 	${RM} *.o *.d vsock_diag_test
diff --git a/tools/testing/vsock/README b/tools/testing/vsock/README
index 2cc6d7302db6..cf7dc64273bf 100644
--- a/tools/testing/vsock/README
+++ b/tools/testing/vsock/README
@@ -10,7 +10,7 @@ The following tests are available:
 The following prerequisite steps are not automated and must be performed=
 prior
 to running tests:
=20
-1. Build the kernel and these tests.
+1. Build the kernel, make headers_install, and build these tests.
 2. Install the kernel and tests on the host.
 3. Install the kernel and tests inside the guest.
 4. Boot the guest and ensure that the AF_VSOCK transport is enabled.
diff --git a/tools/testing/vsock/vsock_diag_test.c b/tools/testing/vsock/=
vsock_diag_test.c
index c481101364a4..fc391e041954 100644
--- a/tools/testing/vsock/vsock_diag_test.c
+++ b/tools/testing/vsock/vsock_diag_test.c
@@ -21,12 +21,11 @@
 #include <linux/list.h>
 #include <linux/net.h>
 #include <linux/netlink.h>
+#include <linux/vm_sockets.h>
 #include <linux/sock_diag.h>
+#include <linux/vm_sockets_diag.h>
 #include <netinet/tcp.h>
=20
-#include "../../../include/uapi/linux/vm_sockets.h"
-#include "../../../include/uapi/linux/vm_sockets_diag.h"
-
 #include "timeout.h"
 #include "control.h"
=20
--=20
2.24.1

