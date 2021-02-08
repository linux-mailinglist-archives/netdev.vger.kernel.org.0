Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A4931357C
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbhBHOqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:46:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25439 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232923AbhBHOol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:44:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612795395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hJ25Ui01C1ncQ+IMfWQfND73YP38mMdrHPvtKAqidhw=;
        b=iFkB5Qx+rhb5IROSdhq79S9NHtvRZslfVESH3VJKVD+FiOQAfI/Q4jp2Y5Vu+8+MJNrhOU
        xGuokUUTwbJu72D7OXftduxmtXV+Qsi8cVO7UI69nsgGQUEfxOY5PC5tETI/rvupBtalgS
        ZYXVf5l2kEr8jQ2+jbaJdJdlFcP/v3g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-Ja8sH24zPYSqpZXLVrafYw-1; Mon, 08 Feb 2021 09:43:13 -0500
X-MC-Unique: Ja8sH24zPYSqpZXLVrafYw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 564B31966322;
        Mon,  8 Feb 2021 14:43:11 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-115-25.ams2.redhat.com [10.36.115.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 899315D9DE;
        Mon,  8 Feb 2021 14:43:08 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, Jorgen Hansen <jhansen@vmware.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andy King <acking@vmware.com>, Wei Liu <wei.liu@kernel.org>,
        Dmitry Torokhov <dtor@vmware.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        George Zhang <georgezhang@vmware.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH net] vsock: fix locking in vsock_shutdown()
Date:   Mon,  8 Feb 2021 15:43:07 +0100
Message-Id: <20210208144307.83628-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In vsock_shutdown() we touched some socket fields without holding the
socket lock, such as 'state' and 'sk_flags'.

Also, after the introduction of multi-transport, we are accessing
'vsk->transport' in vsock_send_shutdown() without holding the lock
and this call can be made while the connection is in progress, so
the transport can change in the meantime.

To avoid issues, we hold the socket lock when we enter in
vsock_shutdown() and release it when we leave.

Among the transports that implement the 'shutdown' callback, only
hyperv_transport acquired the lock. Since the caller now holds it,
we no longer take it.

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/af_vsock.c         | 8 +++++---
 net/vmw_vsock/hyperv_transport.c | 2 --
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 4ea301fc2bf0..5546710d8ac1 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -943,10 +943,12 @@ static int vsock_shutdown(struct socket *sock, int mode)
 	 */
 
 	sk = sock->sk;
+
+	lock_sock(sk);
 	if (sock->state == SS_UNCONNECTED) {
 		err = -ENOTCONN;
 		if (sk->sk_type == SOCK_STREAM)
-			return err;
+			goto out;
 	} else {
 		sock->state = SS_DISCONNECTING;
 		err = 0;
@@ -955,10 +957,8 @@ static int vsock_shutdown(struct socket *sock, int mode)
 	/* Receive and send shutdowns are treated alike. */
 	mode = mode & (RCV_SHUTDOWN | SEND_SHUTDOWN);
 	if (mode) {
-		lock_sock(sk);
 		sk->sk_shutdown |= mode;
 		sk->sk_state_change(sk);
-		release_sock(sk);
 
 		if (sk->sk_type == SOCK_STREAM) {
 			sock_reset_flag(sk, SOCK_DONE);
@@ -966,6 +966,8 @@ static int vsock_shutdown(struct socket *sock, int mode)
 		}
 	}
 
+out:
+	release_sock(sk);
 	return err;
 }
 
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 630b851f8150..5a3beef73461 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -479,9 +479,7 @@ static int hvs_shutdown(struct vsock_sock *vsk, int mode)
 	if (!(mode & SEND_SHUTDOWN))
 		return 0;
 
-	lock_sock(sk);
 	hvs_shutdown_lock_held(vsk->trans, mode);
-	release_sock(sk);
 	return 0;
 }
 
-- 
2.29.2

