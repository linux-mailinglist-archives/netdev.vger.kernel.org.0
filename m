Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D28314AEA
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 09:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhBIIzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 03:55:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57172 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229988AbhBIIyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 03:54:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612860749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=27d+RXZO3vYMFsJOFty+AmSOzQHiAUphvpxkFATgeSY=;
        b=AlG8+yQrMkUiLAkFfdVDO3UyS6Lz1F59ovUKOiAm2inNf2ceYuXYHKVGyQqPPW2rPDRdub
        T0vjn7w9a6ycBsBqRb2tA3tK2Nft7f3qCjVHjRxSdRrl7humQvEvIwUwBnVe/DZHwFcsru
        21I89svBKCvMlVYXx2lV11RpUu/MAM4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-vUqHOcUSPzmtwGzq8FfsNg-1; Tue, 09 Feb 2021 03:52:25 -0500
X-MC-Unique: vUqHOcUSPzmtwGzq8FfsNg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87A091005501;
        Tue,  9 Feb 2021 08:52:23 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-6.ams2.redhat.com [10.36.114.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCFD25D9CD;
        Tue,  9 Feb 2021 08:52:20 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     kuba@kernel.org
Cc:     Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        George Zhang <georgezhang@vmware.com>
Subject: [PATCH net v2] vsock: fix locking in vsock_shutdown()
Date:   Tue,  9 Feb 2021 09:52:19 +0100
Message-Id: <20210209085219.14280-1-sgarzare@redhat.com>
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
v2:
- removed 'sk' variable is hvs_shutdown_lock_held, since it is unused
  after these changes
---
 net/vmw_vsock/af_vsock.c         | 8 +++++---
 net/vmw_vsock/hyperv_transport.c | 4 ----
 2 files changed, 5 insertions(+), 7 deletions(-)

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
index 630b851f8150..cc3bae2659e7 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -474,14 +474,10 @@ static void hvs_shutdown_lock_held(struct hvsock *hvs, int mode)
 
 static int hvs_shutdown(struct vsock_sock *vsk, int mode)
 {
-	struct sock *sk = sk_vsock(vsk);
-
 	if (!(mode & SEND_SHUTDOWN))
 		return 0;
 
-	lock_sock(sk);
 	hvs_shutdown_lock_held(vsk->trans, mode);
-	release_sock(sk);
 	return 0;
 }
 
-- 
2.29.2

