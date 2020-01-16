Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 450BF13F222
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406991AbgAPSdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:33:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46359 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2403823AbgAPRYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 12:24:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579195491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cbf0JDACQ1z0Tg+uGTmFGjFNBjOD4cliWg8yJbi8qUQ=;
        b=LHtIFCAHg3/7qcTa8Sz08Q3rUJX4E4DGcN6dMo/xmJbK8VF1BudDd6fvU7D2yxrPipquNI
        GIa2Oqp8X/ZbBcOLrMrgbEMIPzM+7iU30tTHtmVlcKO/85W5c6Kq/ge3kJwNWPpYL+WDDn
        yTrwZXK5Liq5pFtOQBqzWXUCLXfVXck=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-bBiplUCvO5uGdLfoXn4TUQ-1; Thu, 16 Jan 2020 12:24:49 -0500
X-MC-Unique: bBiplUCvO5uGdLfoXn4TUQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFB70800D4C;
        Thu, 16 Jan 2020 17:24:47 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-242.ams2.redhat.com [10.36.117.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 593AB5C1D8;
        Thu, 16 Jan 2020 17:24:45 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jorgen Hansen <jhansen@vmware.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-hyperv@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH net-next 2/3] vsock/virtio_transport_common: handle netns of received packets
Date:   Thu, 16 Jan 2020 18:24:27 +0100
Message-Id: <20200116172428.311437-3-sgarzare@redhat.com>
In-Reply-To: <20200116172428.311437-1-sgarzare@redhat.com>
References: <20200116172428.311437-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows transports that use virtio_transport_common
to specify the network namespace where a received packet is to
be delivered.

virtio_transport and vhost_transport, for now, use the default
network namespace.

vsock_loopback uses the same network namespace of the transmitter.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vsock.c                   |  1 +
 include/linux/virtio_vsock.h            |  2 ++
 net/vmw_vsock/virtio_transport.c        |  2 ++
 net/vmw_vsock/virtio_transport_common.c | 13 ++++++++++---
 4 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index c2d7d57e98cf..f1d39939d5e4 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -474,6 +474,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_w=
ork *work)
 			continue;
 		}
=20
+		pkt->net =3D vsock_default_net();
 		len =3D pkt->len;
=20
 		/* Deliver to monitoring devices all received packets */
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 71c81e0dc8f2..d4fc93e6e03e 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -43,6 +43,7 @@ struct virtio_vsock_pkt {
 	struct list_head list;
 	/* socket refcnt not held, only use for cancellation */
 	struct vsock_sock *vsk;
+	struct net *net;
 	void *buf;
 	u32 buf_len;
 	u32 len;
@@ -54,6 +55,7 @@ struct virtio_vsock_pkt_info {
 	u32 remote_cid, remote_port;
 	struct vsock_sock *vsk;
 	struct msghdr *msg;
+	struct net *net;
 	u32 pkt_len;
 	u16 type;
 	u16 op;
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_tran=
sport.c
index dfbaf6bd8b1c..fb03a1535c21 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -527,6 +527,8 @@ static void virtio_transport_rx_work(struct work_stru=
ct *work)
 			}
=20
 			pkt->len =3D len - sizeof(pkt->hdr);
+			pkt->net =3D vsock_default_net();
+
 			virtio_transport_deliver_tap_pkt(pkt);
 			virtio_transport_recv_pkt(&virtio_transport, pkt);
 		}
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virt=
io_transport_common.c
index cecdfd91ed00..6402dea62e45 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -63,6 +63,7 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info=
 *info,
 	pkt->hdr.len		=3D cpu_to_le32(len);
 	pkt->reply		=3D info->reply;
 	pkt->vsk		=3D info->vsk;
+	pkt->net		=3D info->net;
=20
 	if (info->msg && len > 0) {
 		pkt->buf =3D kmalloc(len, GFP_KERNEL);
@@ -273,6 +274,7 @@ static int virtio_transport_send_credit_update(struct=
 vsock_sock *vsk,
 		.op =3D VIRTIO_VSOCK_OP_CREDIT_UPDATE,
 		.type =3D type,
 		.vsk =3D vsk,
+		.net =3D sock_net(sk_vsock(vsk)),
 	};
=20
 	return virtio_transport_send_pkt_info(vsk, &info);
@@ -622,6 +624,7 @@ int virtio_transport_connect(struct vsock_sock *vsk)
 		.op =3D VIRTIO_VSOCK_OP_REQUEST,
 		.type =3D VIRTIO_VSOCK_TYPE_STREAM,
 		.vsk =3D vsk,
+		.net =3D sock_net(sk_vsock(vsk)),
 	};
=20
 	return virtio_transport_send_pkt_info(vsk, &info);
@@ -638,6 +641,7 @@ int virtio_transport_shutdown(struct vsock_sock *vsk,=
 int mode)
 			 (mode & SEND_SHUTDOWN ?
 			  VIRTIO_VSOCK_SHUTDOWN_SEND : 0),
 		.vsk =3D vsk,
+		.net =3D sock_net(sk_vsock(vsk)),
 	};
=20
 	return virtio_transport_send_pkt_info(vsk, &info);
@@ -665,6 +669,7 @@ virtio_transport_stream_enqueue(struct vsock_sock *vs=
k,
 		.msg =3D msg,
 		.pkt_len =3D len,
 		.vsk =3D vsk,
+		.net =3D sock_net(sk_vsock(vsk)),
 	};
=20
 	return virtio_transport_send_pkt_info(vsk, &info);
@@ -687,6 +692,7 @@ static int virtio_transport_reset(struct vsock_sock *=
vsk,
 		.type =3D VIRTIO_VSOCK_TYPE_STREAM,
 		.reply =3D !!pkt,
 		.vsk =3D vsk,
+		.net =3D sock_net(sk_vsock(vsk)),
 	};
=20
 	/* Send RST only if the original pkt is not a RST pkt */
@@ -707,6 +713,7 @@ static int virtio_transport_reset_no_sock(const struc=
t virtio_transport *t,
 		.op =3D VIRTIO_VSOCK_OP_RST,
 		.type =3D le16_to_cpu(pkt->hdr.type),
 		.reply =3D true,
+		.net =3D pkt->net,
 	};
=20
 	/* Send RST only if the original pkt is not a RST pkt */
@@ -991,6 +998,7 @@ virtio_transport_send_response(struct vsock_sock *vsk=
,
 		.remote_port =3D le32_to_cpu(pkt->hdr.src_port),
 		.reply =3D true,
 		.vsk =3D vsk,
+		.net =3D sock_net(sk_vsock(vsk)),
 	};
=20
 	return virtio_transport_send_pkt_info(vsk, &info);
@@ -1088,7 +1096,6 @@ virtio_transport_recv_listen(struct sock *sk, struc=
t virtio_vsock_pkt *pkt,
 void virtio_transport_recv_pkt(struct virtio_transport *t,
 			       struct virtio_vsock_pkt *pkt)
 {
-	struct net *net =3D vsock_default_net();
 	struct sockaddr_vm src, dst;
 	struct vsock_sock *vsk;
 	struct sock *sk;
@@ -1116,9 +1123,9 @@ void virtio_transport_recv_pkt(struct virtio_transp=
ort *t,
 	/* The socket must be in connected or bound table
 	 * otherwise send reset back
 	 */
-	sk =3D vsock_find_connected_socket(&src, &dst, net);
+	sk =3D vsock_find_connected_socket(&src, &dst, pkt->net);
 	if (!sk) {
-		sk =3D vsock_find_bound_socket(&dst, net);
+		sk =3D vsock_find_bound_socket(&dst, pkt->net);
 		if (!sk) {
 			(void)virtio_transport_reset_no_sock(t, pkt);
 			goto free_pkt;
--=20
2.24.1

