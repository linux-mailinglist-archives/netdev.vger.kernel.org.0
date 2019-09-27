Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C425C0421
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 13:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfI0L13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 07:27:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59750 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbfI0L12 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 07:27:28 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EB10564D87;
        Fri, 27 Sep 2019 11:27:27 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-249.ams2.redhat.com [10.36.117.249])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18D665D9C3;
        Fri, 27 Sep 2019 11:27:21 +0000 (UTC)
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
Subject: [RFC PATCH 02/13] vsock: remove vm_sockets_get_local_cid()
Date:   Fri, 27 Sep 2019 13:26:52 +0200
Message-Id: <20190927112703.17745-3-sgarzare@redhat.com>
In-Reply-To: <20190927112703.17745-1-sgarzare@redhat.com>
References: <20190927112703.17745-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Fri, 27 Sep 2019 11:27:28 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vm_sockets_get_local_cid() is only used in virtio_transport_common.c.
We can replace it calling the virtio_transport_get_ops() and
using the get_local_cid() callback registered by the transport.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/linux/vm_sockets.h              |  2 --
 net/vmw_vsock/af_vsock.c                | 10 ----------
 net/vmw_vsock/virtio_transport_common.c |  2 +-
 3 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/include/linux/vm_sockets.h b/include/linux/vm_sockets.h
index 33f1a2ecd905..7dd899ccb920 100644
--- a/include/linux/vm_sockets.h
+++ b/include/linux/vm_sockets.h
@@ -10,6 +10,4 @@
 
 #include <uapi/linux/vm_sockets.h>
 
-int vm_sockets_get_local_cid(void);
-
 #endif /* _VM_SOCKETS_H */
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index ab47bf3ab66e..f609434b2794 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -129,16 +129,6 @@ static struct proto vsock_proto = {
 static const struct vsock_transport *transport;
 static DEFINE_MUTEX(vsock_register_mutex);
 
-/**** EXPORTS ****/
-
-/* Get the ID of the local context.  This is transport dependent. */
-
-int vm_sockets_get_local_cid(void)
-{
-	return transport->get_local_cid();
-}
-EXPORT_SYMBOL_GPL(vm_sockets_get_local_cid);
-
 /**** UTILS ****/
 
 /* Each bound VSocket is stored in the bind hash table and each connected
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 5bb70c692b1e..ed1ad5289164 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -168,7 +168,7 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 	struct virtio_vsock_pkt *pkt;
 	u32 pkt_len = info->pkt_len;
 
-	src_cid = vm_sockets_get_local_cid();
+	src_cid = virtio_transport_get_ops()->transport.get_local_cid();
 	src_port = vsk->local_addr.svm_port;
 	if (!info->remote_cid) {
 		dst_cid	= vsk->remote_addr.svm_cid;
-- 
2.21.0

