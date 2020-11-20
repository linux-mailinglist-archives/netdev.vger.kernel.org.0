Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B862BA7BA
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 11:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbgKTKry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 05:47:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56897 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726460AbgKTKry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 05:47:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605869272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FWeqzBmZlLWAnJm9w9KD07ccv+2odS4qEQoYooXswuk=;
        b=N5/G5SBfMqVHoUZ/KdGMxbxtnsHcr1Hv0uLDGlxTZHm/duSdASZXHN03cXOpbYbG4lGOPq
        GhtQ3NyDW3YnEHlb1CcUn/XqmYg8oNeZJPxP80J2TSgJ2tb7Ah0TjZ881T0J5ZwL2/Fl91
        jvhkag2t1o2QAWdWyLexNVRaagyrSsQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-z5gMOlHWMvOuFb6u_w9ZmA-1; Fri, 20 Nov 2020 05:47:47 -0500
X-MC-Unique: z5gMOlHWMvOuFb6u_w9ZmA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA5A9801B1C;
        Fri, 20 Nov 2020 10:47:45 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-22.ams2.redhat.com [10.36.114.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0495F1F0;
        Fri, 20 Nov 2020 10:47:36 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Sergio Lopez <slp@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jia He <justin.he@arm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] vsock/virtio: discard packets only when socket is really closed
Date:   Fri, 20 Nov 2020 11:47:36 +0100
Message-Id: <20201120104736.73749-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Starting from commit 8692cefc433f ("virtio_vsock: Fix race condition
in virtio_transport_recv_pkt"), we discard packets in
virtio_transport_recv_pkt() if the socket has been released.

When the socket is connected, we schedule a delayed work to wait the
RST packet from the other peer, also if SHUTDOWN_MASK is set in
sk->sk_shutdown.
This is done to complete the virtio-vsock shutdown algorithm, releasing
the port assigned to the socket definitively only when the other peer
has consumed all the packets.

If we discard the RST packet received, the socket will be closed only
when the VSOCK_CLOSE_TIMEOUT is reached.

Sergio discovered the issue while running ab(1) HTTP benchmark using
libkrun [1] and observing a latency increase with that commit.

To avoid this issue, we discard packet only if the socket is really
closed (SOCK_DONE flag is set).
We also set SOCK_DONE in virtio_transport_release() when we don't need
to wait any packets from the other peer (we didn't schedule the delayed
work). In this case we remove the socket from the vsock lists, releasing
the port assigned.

[1] https://github.com/containers/libkrun

Fixes: 8692cefc433f ("virtio_vsock: Fix race condition in virtio_transport_recv_pkt")
Cc: justin.he@arm.com
Reported-by: Sergio Lopez <slp@redhat.com>
Tested-by: Sergio Lopez <slp@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 0edda1edf988..5956939eebb7 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -841,8 +841,10 @@ void virtio_transport_release(struct vsock_sock *vsk)
 		virtio_transport_free_pkt(pkt);
 	}
 
-	if (remove_sock)
+	if (remove_sock) {
+		sock_set_flag(sk, SOCK_DONE);
 		vsock_remove_sock(vsk);
+	}
 }
 EXPORT_SYMBOL_GPL(virtio_transport_release);
 
@@ -1132,8 +1134,8 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 
 	lock_sock(sk);
 
-	/* Check if sk has been released before lock_sock */
-	if (sk->sk_shutdown == SHUTDOWN_MASK) {
+	/* Check if sk has been closed before lock_sock */
+	if (sock_flag(sk, SOCK_DONE)) {
 		(void)virtio_transport_reset_no_sock(t, pkt);
 		release_sock(sk);
 		sock_put(sk);
-- 
2.26.2

