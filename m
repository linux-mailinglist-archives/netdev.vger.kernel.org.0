Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C80365725
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 13:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbhDTLIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 07:08:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47190 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231773AbhDTLIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 07:08:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618916859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1FXQjKbNaNL0tsKFqOzmlYeQlOg2nURcqX1NM0c2SiM=;
        b=jUTSPo4pUabSt4+pdBHlE83t0z41jz1IQs4c1PMsldmUBMvr3uluOUz9WrS8R59kXPplGt
        2rKgXiA34E3qswxnJS6tLlNc8IhkdIJQs4hofkqapxNonmjP10xMWG3iuVT/8tZPgdFzLI
        fL9XO/EekWOATPJwUm8AB0IVVLqpKqM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-x_2yPielOtq0wODMkkYNBA-1; Tue, 20 Apr 2021 07:07:35 -0400
X-MC-Unique: x_2yPielOtq0wODMkkYNBA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B7028189D2;
        Tue, 20 Apr 2021 11:07:34 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-240.ams2.redhat.com [10.36.113.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3BA11002EF0;
        Tue, 20 Apr 2021 11:07:28 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH net] vsock/virtio: free queued packets when closing socket
Date:   Tue, 20 Apr 2021 13:07:27 +0200
Message-Id: <20210420110727.139945-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As reported by syzbot [1], there is a memory leak while closing the
socket. We partially solved this issue with commit ac03046ece2b
("vsock/virtio: free packets during the socket release"), but we
forgot to drain the RX queue when the socket is definitely closed by
the scheduled work.

To avoid future issues, let's use the new virtio_transport_remove_sock()
to drain the RX queue before removing the socket from the af_vsock lists
calling vsock_remove_sock().

[1] https://syzkaller.appspot.com/bug?extid=24452624fc4c571eedd9

Fixes: ac03046ece2b ("vsock/virtio: free packets during the socket release")
Reported-and-tested-by: syzbot+24452624fc4c571eedd9@syzkaller.appspotmail.com
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 28 +++++++++++++++++--------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index e4370b1b7494..902cb6dd710b 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -733,6 +733,23 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
 	return t->send_pkt(reply);
 }
 
+/* This function should be called with sk_lock held and SOCK_DONE set */
+static void virtio_transport_remove_sock(struct vsock_sock *vsk)
+{
+	struct virtio_vsock_sock *vvs = vsk->trans;
+	struct virtio_vsock_pkt *pkt, *tmp;
+
+	/* We don't need to take rx_lock, as the socket is closing and we are
+	 * removing it.
+	 */
+	list_for_each_entry_safe(pkt, tmp, &vvs->rx_queue, list) {
+		list_del(&pkt->list);
+		virtio_transport_free_pkt(pkt);
+	}
+
+	vsock_remove_sock(vsk);
+}
+
 static void virtio_transport_wait_close(struct sock *sk, long timeout)
 {
 	if (timeout) {
@@ -765,7 +782,7 @@ static void virtio_transport_do_close(struct vsock_sock *vsk,
 	    (!cancel_timeout || cancel_delayed_work(&vsk->close_work))) {
 		vsk->close_work_scheduled = false;
 
-		vsock_remove_sock(vsk);
+		virtio_transport_remove_sock(vsk);
 
 		/* Release refcnt obtained when we scheduled the timeout */
 		sock_put(sk);
@@ -828,22 +845,15 @@ static bool virtio_transport_close(struct vsock_sock *vsk)
 
 void virtio_transport_release(struct vsock_sock *vsk)
 {
-	struct virtio_vsock_sock *vvs = vsk->trans;
-	struct virtio_vsock_pkt *pkt, *tmp;
 	struct sock *sk = &vsk->sk;
 	bool remove_sock = true;
 
 	if (sk->sk_type == SOCK_STREAM)
 		remove_sock = virtio_transport_close(vsk);
 
-	list_for_each_entry_safe(pkt, tmp, &vvs->rx_queue, list) {
-		list_del(&pkt->list);
-		virtio_transport_free_pkt(pkt);
-	}
-
 	if (remove_sock) {
 		sock_set_flag(sk, SOCK_DONE);
-		vsock_remove_sock(vsk);
+		virtio_transport_remove_sock(vsk);
 	}
 }
 EXPORT_SYMBOL_GPL(virtio_transport_release);
-- 
2.30.2

