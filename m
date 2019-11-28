Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1D6A10CD9B
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 18:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfK1RPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 12:15:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45782 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726608AbfK1RPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 12:15:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574961338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5auX1CvYbu3yZRsbt+Lmj7tuXc5Und38I/LjU8EXijg=;
        b=Gme6DFpsmRq90pucWX4aOMaMgl31v9cybP0/xu8Gh1mpREG/GQ0hM7j87fTYqwygqAtXmh
        gZnDQKTMvOzx9RyJIVxochWg3OuDpHcwoerPByyzi329lbx41MnNDg6069PWfFPBCH153P
        MBqVv3YRgI5e5jqfXhwg/zs59QnSo/8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-j_2Yy6OxNziUa1CniJMwSw-1; Thu, 28 Nov 2019 12:15:35 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDD8D107ACC4;
        Thu, 28 Nov 2019 17:15:33 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-168.ams2.redhat.com [10.36.117.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7723B600C8;
        Thu, 28 Nov 2019 17:15:31 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: [RFC PATCH 2/3] vsock/virtio_transport_common: handle netns of received packets
Date:   Thu, 28 Nov 2019 18:15:18 +0100
Message-Id: <20191128171519.203979-3-sgarzare@redhat.com>
In-Reply-To: <20191128171519.203979-1-sgarzare@redhat.com>
References: <20191128171519.203979-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: j_2Yy6OxNziUa1CniJMwSw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
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

vsock_loopback uses the same network namespace of the trasmitter.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vsock.c                   |  1 +
 include/linux/virtio_vsock.h            |  2 ++
 net/vmw_vsock/virtio_transport.c        |  2 ++
 net/vmw_vsock/virtio_transport_common.c | 13 ++++++++++---
 4 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index dde392b91bb3..31b0f3608752 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -474,6 +474,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_wor=
k *work)
 =09=09=09continue;
 =09=09}
=20
+=09=09pkt->net =3D vsock_default_net();
 =09=09len =3D pkt->len;
=20
 =09=09/* Deliver to monitoring devices all received packets */
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 71c81e0dc8f2..a025d105a456 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -43,6 +43,7 @@ struct virtio_vsock_pkt {
 =09struct list_head list;
 =09/* socket refcnt not held, only use for cancellation */
 =09struct vsock_sock *vsk;
+=09struct net *net;
 =09void *buf;
 =09u32 buf_len;
 =09u32 len;
@@ -53,6 +54,7 @@ struct virtio_vsock_pkt {
 struct virtio_vsock_pkt_info {
 =09u32 remote_cid, remote_port;
 =09struct vsock_sock *vsk;
+=09struct net *net;
 =09struct msghdr *msg;
 =09u32 pkt_len;
 =09u16 type;
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transp=
ort.c
index dfbaf6bd8b1c..fb03a1535c21 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -527,6 +527,8 @@ static void virtio_transport_rx_work(struct work_struct=
 *work)
 =09=09=09}
=20
 =09=09=09pkt->len =3D len - sizeof(pkt->hdr);
+=09=09=09pkt->net =3D vsock_default_net();
+
 =09=09=09virtio_transport_deliver_tap_pkt(pkt);
 =09=09=09virtio_transport_recv_pkt(&virtio_transport, pkt);
 =09=09}
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio=
_transport_common.c
index 10a8cbe39f61..f249dc099c38 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -60,6 +60,7 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *=
info,
 =09pkt->hdr.len=09=09=3D cpu_to_le32(len);
 =09pkt->reply=09=09=3D info->reply;
 =09pkt->vsk=09=09=3D info->vsk;
+=09pkt->net=09=09=3D info->net;
=20
 =09if (info->msg && len > 0) {
 =09=09pkt->buf =3D kmalloc(len, GFP_KERNEL);
@@ -260,6 +261,7 @@ static int virtio_transport_send_credit_update(struct v=
sock_sock *vsk,
 =09=09.op =3D VIRTIO_VSOCK_OP_CREDIT_UPDATE,
 =09=09.type =3D type,
 =09=09.vsk =3D vsk,
+=09=09.net =3D sock_net(sk_vsock(vsk)),
 =09};
=20
 =09return virtio_transport_send_pkt_info(vsk, &info);
@@ -609,6 +611,7 @@ int virtio_transport_connect(struct vsock_sock *vsk)
 =09=09.op =3D VIRTIO_VSOCK_OP_REQUEST,
 =09=09.type =3D VIRTIO_VSOCK_TYPE_STREAM,
 =09=09.vsk =3D vsk,
+=09=09.net =3D sock_net(sk_vsock(vsk)),
 =09};
=20
 =09return virtio_transport_send_pkt_info(vsk, &info);
@@ -625,6 +628,7 @@ int virtio_transport_shutdown(struct vsock_sock *vsk, i=
nt mode)
 =09=09=09 (mode & SEND_SHUTDOWN ?
 =09=09=09  VIRTIO_VSOCK_SHUTDOWN_SEND : 0),
 =09=09.vsk =3D vsk,
+=09=09.net =3D sock_net(sk_vsock(vsk)),
 =09};
=20
 =09return virtio_transport_send_pkt_info(vsk, &info);
@@ -652,6 +656,7 @@ virtio_transport_stream_enqueue(struct vsock_sock *vsk,
 =09=09.msg =3D msg,
 =09=09.pkt_len =3D len,
 =09=09.vsk =3D vsk,
+=09=09.net =3D sock_net(sk_vsock(vsk)),
 =09};
=20
 =09return virtio_transport_send_pkt_info(vsk, &info);
@@ -674,6 +679,7 @@ static int virtio_transport_reset(struct vsock_sock *vs=
k,
 =09=09.type =3D VIRTIO_VSOCK_TYPE_STREAM,
 =09=09.reply =3D !!pkt,
 =09=09.vsk =3D vsk,
+=09=09.net =3D sock_net(sk_vsock(vsk)),
 =09};
=20
 =09/* Send RST only if the original pkt is not a RST pkt */
@@ -694,6 +700,7 @@ static int virtio_transport_reset_no_sock(const struct =
virtio_transport *t,
 =09=09.op =3D VIRTIO_VSOCK_OP_RST,
 =09=09.type =3D le16_to_cpu(pkt->hdr.type),
 =09=09.reply =3D true,
+=09=09.net =3D pkt->net,
 =09};
=20
 =09/* Send RST only if the original pkt is not a RST pkt */
@@ -978,6 +985,7 @@ virtio_transport_send_response(struct vsock_sock *vsk,
 =09=09.remote_port =3D le32_to_cpu(pkt->hdr.src_port),
 =09=09.reply =3D true,
 =09=09.vsk =3D vsk,
+=09=09.net =3D sock_net(sk_vsock(vsk)),
 =09};
=20
 =09return virtio_transport_send_pkt_info(vsk, &info);
@@ -1075,7 +1083,6 @@ virtio_transport_recv_listen(struct sock *sk, struct =
virtio_vsock_pkt *pkt,
 void virtio_transport_recv_pkt(struct virtio_transport *t,
 =09=09=09       struct virtio_vsock_pkt *pkt)
 {
-=09struct net *net =3D vsock_default_net();
 =09struct sockaddr_vm src, dst;
 =09struct vsock_sock *vsk;
 =09struct sock *sk;
@@ -1103,9 +1110,9 @@ void virtio_transport_recv_pkt(struct virtio_transpor=
t *t,
 =09/* The socket must be in connected or bound table
 =09 * otherwise send reset back
 =09 */
-=09sk =3D vsock_find_connected_socket(&src, &dst, net);
+=09sk =3D vsock_find_connected_socket(&src, &dst, pkt->net);
 =09if (!sk) {
-=09=09sk =3D vsock_find_bound_socket(&dst, net);
+=09=09sk =3D vsock_find_bound_socket(&dst, pkt->net);
 =09=09if (!sk) {
 =09=09=09(void)virtio_transport_reset_no_sock(t, pkt);
 =09=09=09goto free_pkt;
--=20
2.23.0

