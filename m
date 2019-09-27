Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5CACC0443
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 13:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfI0L2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 07:28:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34803 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbfI0L2J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 07:28:09 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 425E2300D1C7;
        Fri, 27 Sep 2019 11:28:08 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-249.ams2.redhat.com [10.36.117.249])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DEF485D9C3;
        Fri, 27 Sep 2019 11:27:58 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-hyperv@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: [RFC PATCH 06/13] vsock: add 'struct vsock_sock *' param to vsock_core_get_transport()
Date:   Fri, 27 Sep 2019 13:26:56 +0200
Message-Id: <20190927112703.17745-7-sgarzare@redhat.com>
In-Reply-To: <20190927112703.17745-1-sgarzare@redhat.com>
References: <20190927112703.17745-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 27 Sep 2019 11:28:08 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since now the 'struct vsock_sock' object contains a pointer to
the transport, this patch adds a parameter to the
vsock_core_get_transport() to return the right transport
assigned to the socket.

This patch modifies also the virtio_transport_get_ops(), that
uses the vsock_core_get_transport(), adding the
'struct vsock_sock *' parameter.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/net/af_vsock.h                  | 2 +-
 net/vmw_vsock/af_vsock.c                | 4 ++--
 net/vmw_vsock/virtio_transport_common.c | 9 +++++----
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index a5e1e134261d..2ca67d048de4 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -166,7 +166,7 @@ static inline int vsock_core_init(const struct vsock_transport *t)
 void vsock_core_exit(void);
 
 /* The transport may downcast this to access transport-specific functions */
-const struct vsock_transport *vsock_core_get_transport(void);
+const struct vsock_transport *vsock_core_get_transport(struct vsock_sock *vsk);
 
 /**** UTILS ****/
 
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 81ee2561c76f..f7540a3ac64e 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1993,12 +1993,12 @@ void vsock_core_exit(void)
 }
 EXPORT_SYMBOL_GPL(vsock_core_exit);
 
-const struct vsock_transport *vsock_core_get_transport(void)
+const struct vsock_transport *vsock_core_get_transport(struct vsock_sock *vsk)
 {
 	/* vsock_register_mutex not taken since only the transport uses this
 	 * function and only while registered.
 	 */
-	return transport_single;
+	return vsk->transport;
 }
 EXPORT_SYMBOL_GPL(vsock_core_get_transport);
 
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 382536b69029..fc046c071178 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -29,9 +29,10 @@
 /* Threshold for detecting small packets to copy */
 #define GOOD_COPY_LEN  128
 
-static const struct virtio_transport *virtio_transport_get_ops(void)
+static const struct virtio_transport *
+virtio_transport_get_ops(struct vsock_sock *vsk)
 {
-	const struct vsock_transport *t = vsock_core_get_transport();
+	const struct vsock_transport *t = vsock_core_get_transport(vsk);
 
 	return container_of(t, struct virtio_transport, transport);
 }
@@ -168,7 +169,7 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 	struct virtio_vsock_pkt *pkt;
 	u32 pkt_len = info->pkt_len;
 
-	src_cid = virtio_transport_get_ops()->transport.get_local_cid();
+	src_cid = virtio_transport_get_ops(vsk)->transport.get_local_cid();
 	src_port = vsk->local_addr.svm_port;
 	if (!info->remote_cid) {
 		dst_cid	= vsk->remote_addr.svm_cid;
@@ -201,7 +202,7 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 
 	virtio_transport_inc_tx_pkt(vvs, pkt);
 
-	return virtio_transport_get_ops()->send_pkt(pkt);
+	return virtio_transport_get_ops(vsk)->send_pkt(pkt);
 }
 
 static void virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
-- 
2.21.0

