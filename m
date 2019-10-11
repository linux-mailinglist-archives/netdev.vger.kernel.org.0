Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBD39D4098
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 15:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbfJKNIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 09:08:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51694 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728568AbfJKNIM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 09:08:12 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 046D588384F;
        Fri, 11 Oct 2019 13:08:12 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-54.ams2.redhat.com [10.36.117.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF76160623;
        Fri, 11 Oct 2019 13:08:09 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Jorgen Hansen <jhansen@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Adit Ranadive <aditr@vmware.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 2/2] vhost/vsock: don't allow half-closed socket in the host
Date:   Fri, 11 Oct 2019 15:07:58 +0200
Message-Id: <20191011130758.22134-3-sgarzare@redhat.com>
In-Reply-To: <20191011130758.22134-1-sgarzare@redhat.com>
References: <20191011130758.22134-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Fri, 11 Oct 2019 13:08:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vmci_transport never allowed half-closed socket on the host side.
In order to provide the same behaviour, we changed the
vhost_transport_stream_has_data() to return 0 (no data available)
if the peer (guest) closed the connection.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vsock.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 9f57736fe15e..754120aa4478 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -58,6 +58,21 @@ static u32 vhost_transport_get_local_cid(void)
 	return VHOST_VSOCK_DEFAULT_HOST_CID;
 }
 
+static s64 vhost_transport_stream_has_data(struct vsock_sock *vsk)
+{
+	/* vmci_transport doesn't allow half-closed socket on the host side.
+	 * recv() on the host side returns EOF when the guest closes a
+	 * connection, also if some data is still in the receive queue.
+	 *
+	 * In order to provide the same behaviour, we always return 0
+	 * (no data available) if the peer (guest) closed the connection.
+	 */
+	if (vsk->peer_shutdown == SHUTDOWN_MASK)
+		return 0;
+
+	return virtio_transport_stream_has_data(vsk);
+}
+
 /* Callers that dereference the return value must hold vhost_vsock_mutex or the
  * RCU read lock.
  */
@@ -804,7 +819,7 @@ static struct virtio_transport vhost_transport = {
 
 		.stream_enqueue           = virtio_transport_stream_enqueue,
 		.stream_dequeue           = virtio_transport_stream_dequeue,
-		.stream_has_data          = virtio_transport_stream_has_data,
+		.stream_has_data          = vhost_transport_stream_has_data,
 		.stream_has_space         = virtio_transport_stream_has_space,
 		.stream_rcvhiwat          = virtio_transport_stream_rcvhiwat,
 		.stream_is_active         = virtio_transport_stream_is_active,
-- 
2.21.0

