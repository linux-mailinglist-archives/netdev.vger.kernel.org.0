Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E98912504F
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 19:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbfLRSHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 13:07:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58091 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727565AbfLRSHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 13:07:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576692462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FlkaeYSFXvcGkCKY6XBlUXahFqgenbvaIYvHtAYj1TY=;
        b=K0t4+sBTNHxQr/9+uh3aub/x05NXVthrBFLcByoJUQGfVJWlzcvCDI9J1py1Ip8UiH7+Rw
        TjTy8SgagjmSeOZmxhy/51h1ykTTO3o5N3CjgS9Flx0QpgF7e+3SlNlODcMOCtEe25Q0Zw
        AbsDeH5BS4XetgqEmaHcEWqfZ1OWk0E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-_Cr8_2JDMlK5tZ86RYOKog-1; Wed, 18 Dec 2019 13:07:38 -0500
X-MC-Unique: _Cr8_2JDMlK5tZ86RYOKog-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FD50802B60;
        Wed, 18 Dec 2019 18:07:35 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-218.ams2.redhat.com [10.36.117.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2765F5D9E5;
        Wed, 18 Dec 2019 18:07:32 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net
Cc:     Jorgen Hansen <jhansen@vmware.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dexuan Cui <decui@microsoft.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH net-next v3 05/11] VSOCK: add full barrier between test cases
Date:   Wed, 18 Dec 2019 19:07:02 +0100
Message-Id: <20191218180708.120337-6-sgarzare@redhat.com>
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
=20
-		if (opts->mode =3D=3D TEST_MODE_CLIENT)
+		if (opts->mode =3D=3D TEST_MODE_CLIENT) {
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
 			run =3D test_cases[i].run_client;
-		else
+		} else {
+			control_writeln("NEXT");
+			control_expectln("NEXT");
+
 			run =3D test_cases[i].run_server;
+		}
=20
 		if (run)
 			run(opts);
--=20
2.24.1

