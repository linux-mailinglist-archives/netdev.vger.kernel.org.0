Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBDADAC90
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 14:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502512AbfJQMoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 08:44:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13486 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502483AbfJQMoM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 08:44:12 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D1F6E3082E10;
        Thu, 17 Oct 2019 12:44:12 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-195.ams2.redhat.com [10.36.117.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 675D85D9D5;
        Thu, 17 Oct 2019 12:44:11 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH net 2/2] vsock/virtio: discard packets if credit is not respected
Date:   Thu, 17 Oct 2019 14:44:03 +0200
Message-Id: <20191017124403.266242-3-sgarzare@redhat.com>
In-Reply-To: <20191017124403.266242-1-sgarzare@redhat.com>
References: <20191017124403.266242-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 17 Oct 2019 12:44:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the remote peer doesn't respect the credit information
(buf_alloc, fwd_cnt), sending more data than it can send,
we should drop the packets to prevent a malicious peer
from using all of our memory.

This is patch follows the VIRTIO spec: "VIRTIO_VSOCK_OP_RW data
packets MUST only be transmitted when the peer has sufficient
free buffer space for the payload"

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index db127a69f5c3..481f7f8a1655 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -204,10 +204,14 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 	return virtio_transport_get_ops()->send_pkt(pkt);
 }
 
-static void virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
+static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
 					struct virtio_vsock_pkt *pkt)
 {
+	if (vvs->rx_bytes + pkt->len > vvs->buf_alloc)
+		return false;
+
 	vvs->rx_bytes += pkt->len;
+	return true;
 }
 
 static void virtio_transport_dec_rx_pkt(struct virtio_vsock_sock *vvs,
@@ -879,14 +883,18 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
 			      struct virtio_vsock_pkt *pkt)
 {
 	struct virtio_vsock_sock *vvs = vsk->trans;
-	bool free_pkt = false;
+	bool can_enqueue, free_pkt = false;
 
 	pkt->len = le32_to_cpu(pkt->hdr.len);
 	pkt->off = 0;
 
 	spin_lock_bh(&vvs->rx_lock);
 
-	virtio_transport_inc_rx_pkt(vvs, pkt);
+	can_enqueue = virtio_transport_inc_rx_pkt(vvs, pkt);
+	if (!can_enqueue) {
+		free_pkt = true;
+		goto out;
+	}
 
 	/* Try to copy small packets into the buffer of last packet queued,
 	 * to avoid wasting memory queueing the entire buffer with a small
-- 
2.21.0

