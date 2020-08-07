Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E7A23F146
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 18:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgHGQbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 12:31:35 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20926 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726096AbgHGQbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 12:31:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596817891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Sd0aCyo6pSCgTzLOHI/vvi0TOhAd/PWdDXakJPbGoK4=;
        b=F9Xd6Dblk94wnonDRa6e3lTffKVCkUSHBfyXDvaP2DCVnlG24Ahu28dd7wvNF37daNiWwr
        XOgHbwnEfOVvTdEEmzUs6sJaK3P/vuvfV5K9+jFU3UVrLA9ln3AvBch+VKkOy+L2+8Djn3
        +LAcF8nyy84B2jVf7udmuNDEMpD/AYA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-EeZVKLSVPlO7kR1XWNvgLQ-1; Fri, 07 Aug 2020 12:31:27 -0400
X-MC-Unique: EeZVKLSVPlO7kR1XWNvgLQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56F70100CCC5;
        Fri,  7 Aug 2020 16:31:26 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-113-201.ams2.redhat.com [10.36.113.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 104EC5C1C3;
        Fri,  7 Aug 2020 16:31:24 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net] mptcp: more stable diag self-tests
Date:   Fri,  7 Aug 2020 18:31:00 +0200
Message-Id: <80f1f6d16da4542e825d9aca1949d6169d77104c.1596817814.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During diag self-tests we introduce long wait in the mptcp test
program to give the script enough time to access the sockets
dump.

Such wait is introduced after shutting down one sockets end. Since
commit 43b54c6ee382 ("mptcp: Use full MPTCP-level disconnect state
machine") if both sides shutdown the socket is correctly transitioned
into CLOSED status.

As a side effect some sockets are not dumped via the diag interface,
because the socket state (CLOSED) does not match the default filter, and
this cause self-tests instability.

Address the issue moving the above mentioned wait before shutting
down the socket.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/68
Fixes: df62f2ec3df6 ("selftests/mptcp: add diag interface tests")
Tested-and-acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
index cad6f73a5fd0..090620c3e10c 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -406,10 +406,11 @@ static int copyfd_io_poll(int infd, int peerfd, int outfd)
 
 				/* ... but we still receive.
 				 * Close our write side, ev. give some time
-				 * for address notification
+				 * for address notification and/or checking
+				 * the current status
 				 */
-				if (cfg_join)
-					usleep(400000);
+				if (cfg_wait)
+					usleep(cfg_wait);
 				shutdown(peerfd, SHUT_WR);
 			} else {
 				if (errno == EINTR)
@@ -427,7 +428,7 @@ static int copyfd_io_poll(int infd, int peerfd, int outfd)
 	}
 
 	/* leave some time for late join/announce */
-	if (cfg_wait)
+	if (cfg_join)
 		usleep(cfg_wait);
 
 	close(peerfd);
-- 
2.26.2

