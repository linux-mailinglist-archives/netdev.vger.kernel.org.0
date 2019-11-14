Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B16FC369
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 10:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfKNJ7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 04:59:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23701 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727200AbfKNJ6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 04:58:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573725524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q0bK5J9Fwy9MZEDp3nMf2y28Mbqw0pWe1/zlaqujCZs=;
        b=GKzC6mGUeOf2FGXm4m3HdcX9DJpr3VCO7l5H1WXZSEVciH1pxVCMce479iNiM2NdpDHWu8
        WLfldxwe8mxS8T6oqIXrItTOLooNmRVLhTHkndwgRePxyt+B/3VVofWsfuJTTxS7HO7fF8
        dLMR1U7NSG3rBnQ9CHbdCr41BSW0fWo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-2xBZQxchPuO5k8lOg4ufhw-1; Thu, 14 Nov 2019 04:58:41 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1056C477;
        Thu, 14 Nov 2019 09:58:39 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-81.ams2.redhat.com [10.36.117.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 270DDA7F1;
        Thu, 14 Nov 2019 09:58:32 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Jason Wang <jasowang@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>, linux-hyperv@vger.kernel.org
Subject: [PATCH net-next v2 07/15] vsock: handle buffer_size sockopts in the core
Date:   Thu, 14 Nov 2019 10:57:42 +0100
Message-Id: <20191114095750.59106-8-sgarzare@redhat.com>
In-Reply-To: <20191114095750.59106-1-sgarzare@redhat.com>
References: <20191114095750.59106-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 2xBZQxchPuO5k8lOg4ufhw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virtio_transport and vmci_transport handle the buffer_size
sockopts in a very similar way.

In order to support multiple transports, this patch moves this
handling in the core to allow the user to change the options
also if the socket is not yet assigned to any transport.

This patch also adds the '.notify_buffer_size' callback in the
'struct virtio_transport' in order to inform the transport,
when the buffer_size is changed by the user. It is also useful
to limit the 'buffer_size' requested (e.g. virtio transports).

Acked-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vsock.c                   |  7 +-
 include/linux/virtio_vsock.h            | 15 +----
 include/net/af_vsock.h                  | 15 ++---
 net/vmw_vsock/af_vsock.c                | 43 ++++++++++---
 net/vmw_vsock/hyperv_transport.c        | 36 -----------
 net/vmw_vsock/virtio_transport.c        |  8 +--
 net/vmw_vsock/virtio_transport_common.c | 79 ++++-------------------
 net/vmw_vsock/vmci_transport.c          | 86 +++----------------------
 net/vmw_vsock/vmci_transport.h          |  3 -
 9 files changed, 65 insertions(+), 227 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 92ab3852c954..6d7e4f022748 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -418,13 +418,8 @@ static struct virtio_transport vhost_transport =3D {
 =09=09.notify_send_pre_block    =3D virtio_transport_notify_send_pre_block=
,
 =09=09.notify_send_pre_enqueue  =3D virtio_transport_notify_send_pre_enque=
ue,
 =09=09.notify_send_post_enqueue =3D virtio_transport_notify_send_post_enqu=
eue,
+=09=09.notify_buffer_size       =3D virtio_transport_notify_buffer_size,
=20
-=09=09.set_buffer_size          =3D virtio_transport_set_buffer_size,
-=09=09.set_min_buffer_size      =3D virtio_transport_set_min_buffer_size,
-=09=09.set_max_buffer_size      =3D virtio_transport_set_max_buffer_size,
-=09=09.get_buffer_size          =3D virtio_transport_get_buffer_size,
-=09=09.get_min_buffer_size      =3D virtio_transport_get_min_buffer_size,
-=09=09.get_max_buffer_size      =3D virtio_transport_get_max_buffer_size,
 =09},
=20
 =09.send_pkt =3D vhost_transport_send_pkt,
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index b139f76060a6..71c81e0dc8f2 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -7,9 +7,6 @@
 #include <net/sock.h>
 #include <net/af_vsock.h>
=20
-#define VIRTIO_VSOCK_DEFAULT_MIN_BUF_SIZE=09128
-#define VIRTIO_VSOCK_DEFAULT_BUF_SIZE=09=09(1024 * 256)
-#define VIRTIO_VSOCK_DEFAULT_MAX_BUF_SIZE=09(1024 * 256)
 #define VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE=09(1024 * 4)
 #define VIRTIO_VSOCK_MAX_BUF_SIZE=09=090xFFFFFFFFUL
 #define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE=09=09(1024 * 64)
@@ -25,11 +22,6 @@ enum {
 struct virtio_vsock_sock {
 =09struct vsock_sock *vsk;
=20
-=09/* Protected by lock_sock(sk_vsock(trans->vsk)) */
-=09u32 buf_size;
-=09u32 buf_size_min;
-=09u32 buf_size_max;
-
 =09spinlock_t tx_lock;
 =09spinlock_t rx_lock;
=20
@@ -92,12 +84,6 @@ s64 virtio_transport_stream_has_space(struct vsock_sock =
*vsk);
=20
 int virtio_transport_do_socket_init(struct vsock_sock *vsk,
 =09=09=09=09 struct vsock_sock *psk);
-u64 virtio_transport_get_buffer_size(struct vsock_sock *vsk);
-u64 virtio_transport_get_min_buffer_size(struct vsock_sock *vsk);
-u64 virtio_transport_get_max_buffer_size(struct vsock_sock *vsk);
-void virtio_transport_set_buffer_size(struct vsock_sock *vsk, u64 val);
-void virtio_transport_set_min_buffer_size(struct vsock_sock *vsk, u64 val)=
;
-void virtio_transport_set_max_buffer_size(struct vsock_sock *vs, u64 val);
 int
 virtio_transport_notify_poll_in(struct vsock_sock *vsk,
 =09=09=09=09size_t target,
@@ -124,6 +110,7 @@ int virtio_transport_notify_send_pre_enqueue(struct vso=
ck_sock *vsk,
 =09struct vsock_transport_send_notify_data *data);
 int virtio_transport_notify_send_post_enqueue(struct vsock_sock *vsk,
 =09ssize_t written, struct vsock_transport_send_notify_data *data);
+void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64 *val)=
;
=20
 u64 virtio_transport_stream_rcvhiwat(struct vsock_sock *vsk);
 bool virtio_transport_stream_is_active(struct vsock_sock *vsk);
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 2ca67d048de4..4b5d16840fd4 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -65,6 +65,11 @@ struct vsock_sock {
 =09bool sent_request;
 =09bool ignore_connecting_rst;
=20
+=09/* Protected by lock_sock(sk) */
+=09u64 buffer_size;
+=09u64 buffer_min_size;
+=09u64 buffer_max_size;
+
 =09/* Private to transport. */
 =09void *trans;
 };
@@ -140,18 +145,12 @@ struct vsock_transport {
 =09=09struct vsock_transport_send_notify_data *);
 =09int (*notify_send_post_enqueue)(struct vsock_sock *, ssize_t,
 =09=09struct vsock_transport_send_notify_data *);
+=09/* sk_lock held by the caller */
+=09void (*notify_buffer_size)(struct vsock_sock *, u64 *);
=20
 =09/* Shutdown. */
 =09int (*shutdown)(struct vsock_sock *, int);
=20
-=09/* Buffer sizes. */
-=09void (*set_buffer_size)(struct vsock_sock *, u64);
-=09void (*set_min_buffer_size)(struct vsock_sock *, u64);
-=09void (*set_max_buffer_size)(struct vsock_sock *, u64);
-=09u64 (*get_buffer_size)(struct vsock_sock *);
-=09u64 (*get_min_buffer_size)(struct vsock_sock *);
-=09u64 (*get_max_buffer_size)(struct vsock_sock *);
-
 =09/* Addressing. */
 =09u32 (*get_local_cid)(void);
 };
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index f057acb0ee29..11b88094e3b2 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -126,6 +126,10 @@ static struct proto vsock_proto =3D {
  */
 #define VSOCK_DEFAULT_CONNECT_TIMEOUT (2 * HZ)
=20
+#define VSOCK_DEFAULT_BUFFER_SIZE     (1024 * 256)
+#define VSOCK_DEFAULT_BUFFER_MAX_SIZE (1024 * 256)
+#define VSOCK_DEFAULT_BUFFER_MIN_SIZE 128
+
 static const struct vsock_transport *transport_single;
 static DEFINE_MUTEX(vsock_register_mutex);
=20
@@ -613,10 +617,16 @@ struct sock *__vsock_create(struct net *net,
 =09=09vsk->trusted =3D psk->trusted;
 =09=09vsk->owner =3D get_cred(psk->owner);
 =09=09vsk->connect_timeout =3D psk->connect_timeout;
+=09=09vsk->buffer_size =3D psk->buffer_size;
+=09=09vsk->buffer_min_size =3D psk->buffer_min_size;
+=09=09vsk->buffer_max_size =3D psk->buffer_max_size;
 =09} else {
 =09=09vsk->trusted =3D capable(CAP_NET_ADMIN);
 =09=09vsk->owner =3D get_current_cred();
 =09=09vsk->connect_timeout =3D VSOCK_DEFAULT_CONNECT_TIMEOUT;
+=09=09vsk->buffer_size =3D VSOCK_DEFAULT_BUFFER_SIZE;
+=09=09vsk->buffer_min_size =3D VSOCK_DEFAULT_BUFFER_MIN_SIZE;
+=09=09vsk->buffer_max_size =3D VSOCK_DEFAULT_BUFFER_MAX_SIZE;
 =09}
=20
 =09if (vsk->transport->init(vsk, psk) < 0) {
@@ -1366,6 +1376,23 @@ static int vsock_listen(struct socket *sock, int bac=
klog)
 =09return err;
 }
=20
+static void vsock_update_buffer_size(struct vsock_sock *vsk,
+=09=09=09=09     const struct vsock_transport *transport,
+=09=09=09=09     u64 val)
+{
+=09if (val > vsk->buffer_max_size)
+=09=09val =3D vsk->buffer_max_size;
+
+=09if (val < vsk->buffer_min_size)
+=09=09val =3D vsk->buffer_min_size;
+
+=09if (val !=3D vsk->buffer_size &&
+=09    transport && transport->notify_buffer_size)
+=09=09transport->notify_buffer_size(vsk, &val);
+
+=09vsk->buffer_size =3D val;
+}
+
 static int vsock_stream_setsockopt(struct socket *sock,
 =09=09=09=09   int level,
 =09=09=09=09   int optname,
@@ -1403,17 +1430,19 @@ static int vsock_stream_setsockopt(struct socket *s=
ock,
 =09switch (optname) {
 =09case SO_VM_SOCKETS_BUFFER_SIZE:
 =09=09COPY_IN(val);
-=09=09transport->set_buffer_size(vsk, val);
+=09=09vsock_update_buffer_size(vsk, transport, val);
 =09=09break;
=20
 =09case SO_VM_SOCKETS_BUFFER_MAX_SIZE:
 =09=09COPY_IN(val);
-=09=09transport->set_max_buffer_size(vsk, val);
+=09=09vsk->buffer_max_size =3D val;
+=09=09vsock_update_buffer_size(vsk, transport, vsk->buffer_size);
 =09=09break;
=20
 =09case SO_VM_SOCKETS_BUFFER_MIN_SIZE:
 =09=09COPY_IN(val);
-=09=09transport->set_min_buffer_size(vsk, val);
+=09=09vsk->buffer_min_size =3D val;
+=09=09vsock_update_buffer_size(vsk, transport, vsk->buffer_size);
 =09=09break;
=20
 =09case SO_VM_SOCKETS_CONNECT_TIMEOUT: {
@@ -1454,7 +1483,6 @@ static int vsock_stream_getsockopt(struct socket *soc=
k,
 =09int len;
 =09struct sock *sk;
 =09struct vsock_sock *vsk;
-=09const struct vsock_transport *transport;
 =09u64 val;
=20
 =09if (level !=3D AF_VSOCK)
@@ -1478,21 +1506,20 @@ static int vsock_stream_getsockopt(struct socket *s=
ock,
 =09err =3D 0;
 =09sk =3D sock->sk;
 =09vsk =3D vsock_sk(sk);
-=09transport =3D vsk->transport;
=20
 =09switch (optname) {
 =09case SO_VM_SOCKETS_BUFFER_SIZE:
-=09=09val =3D transport->get_buffer_size(vsk);
+=09=09val =3D vsk->buffer_size;
 =09=09COPY_OUT(val);
 =09=09break;
=20
 =09case SO_VM_SOCKETS_BUFFER_MAX_SIZE:
-=09=09val =3D transport->get_max_buffer_size(vsk);
+=09=09val =3D vsk->buffer_max_size;
 =09=09COPY_OUT(val);
 =09=09break;
=20
 =09case SO_VM_SOCKETS_BUFFER_MIN_SIZE:
-=09=09val =3D transport->get_min_buffer_size(vsk);
+=09=09val =3D vsk->buffer_min_size;
 =09=09COPY_OUT(val);
 =09=09break;
=20
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transp=
ort.c
index 7fa09c5e4625..ab947561543e 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -845,36 +845,6 @@ int hvs_notify_send_post_enqueue(struct vsock_sock *vs=
k, ssize_t written,
 =09return 0;
 }
=20
-static void hvs_set_buffer_size(struct vsock_sock *vsk, u64 val)
-{
-=09/* Ignored. */
-}
-
-static void hvs_set_min_buffer_size(struct vsock_sock *vsk, u64 val)
-{
-=09/* Ignored. */
-}
-
-static void hvs_set_max_buffer_size(struct vsock_sock *vsk, u64 val)
-{
-=09/* Ignored. */
-}
-
-static u64 hvs_get_buffer_size(struct vsock_sock *vsk)
-{
-=09return -ENOPROTOOPT;
-}
-
-static u64 hvs_get_min_buffer_size(struct vsock_sock *vsk)
-{
-=09return -ENOPROTOOPT;
-}
-
-static u64 hvs_get_max_buffer_size(struct vsock_sock *vsk)
-{
-=09return -ENOPROTOOPT;
-}
-
 static struct vsock_transport hvs_transport =3D {
 =09.get_local_cid            =3D hvs_get_local_cid,
=20
@@ -908,12 +878,6 @@ static struct vsock_transport hvs_transport =3D {
 =09.notify_send_pre_enqueue  =3D hvs_notify_send_pre_enqueue,
 =09.notify_send_post_enqueue =3D hvs_notify_send_post_enqueue,
=20
-=09.set_buffer_size          =3D hvs_set_buffer_size,
-=09.set_min_buffer_size      =3D hvs_set_min_buffer_size,
-=09.set_max_buffer_size      =3D hvs_set_max_buffer_size,
-=09.get_buffer_size          =3D hvs_get_buffer_size,
-=09.get_min_buffer_size      =3D hvs_get_min_buffer_size,
-=09.get_max_buffer_size      =3D hvs_get_max_buffer_size,
 };
=20
 static int hvs_probe(struct hv_device *hdev,
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transp=
ort.c
index 3756f0857946..fb1fc7760e8c 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -494,13 +494,7 @@ static struct virtio_transport virtio_transport =3D {
 =09=09.notify_send_pre_block    =3D virtio_transport_notify_send_pre_block=
,
 =09=09.notify_send_pre_enqueue  =3D virtio_transport_notify_send_pre_enque=
ue,
 =09=09.notify_send_post_enqueue =3D virtio_transport_notify_send_post_enqu=
eue,
-
-=09=09.set_buffer_size          =3D virtio_transport_set_buffer_size,
-=09=09.set_min_buffer_size      =3D virtio_transport_set_min_buffer_size,
-=09=09.set_max_buffer_size      =3D virtio_transport_set_max_buffer_size,
-=09=09.get_buffer_size          =3D virtio_transport_get_buffer_size,
-=09=09.get_min_buffer_size      =3D virtio_transport_get_min_buffer_size,
-=09=09.get_max_buffer_size      =3D virtio_transport_get_max_buffer_size,
+=09=09.notify_buffer_size       =3D virtio_transport_notify_buffer_size,
 =09},
=20
 =09.send_pkt =3D virtio_transport_send_pkt,
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio=
_transport_common.c
index b113619d9576..d4a0bf19aa98 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -456,17 +456,13 @@ int virtio_transport_do_socket_init(struct vsock_sock=
 *vsk,
 =09if (psk) {
 =09=09struct virtio_vsock_sock *ptrans =3D psk->trans;
=20
-=09=09vvs->buf_size=09=3D ptrans->buf_size;
-=09=09vvs->buf_size_min =3D ptrans->buf_size_min;
-=09=09vvs->buf_size_max =3D ptrans->buf_size_max;
 =09=09vvs->peer_buf_alloc =3D ptrans->peer_buf_alloc;
-=09} else {
-=09=09vvs->buf_size =3D VIRTIO_VSOCK_DEFAULT_BUF_SIZE;
-=09=09vvs->buf_size_min =3D VIRTIO_VSOCK_DEFAULT_MIN_BUF_SIZE;
-=09=09vvs->buf_size_max =3D VIRTIO_VSOCK_DEFAULT_MAX_BUF_SIZE;
 =09}
=20
-=09vvs->buf_alloc =3D vvs->buf_size;
+=09if (vsk->buffer_size > VIRTIO_VSOCK_MAX_BUF_SIZE)
+=09=09vsk->buffer_size =3D VIRTIO_VSOCK_MAX_BUF_SIZE;
+
+=09vvs->buf_alloc =3D vsk->buffer_size;
=20
 =09spin_lock_init(&vvs->rx_lock);
 =09spin_lock_init(&vvs->tx_lock);
@@ -476,71 +472,20 @@ int virtio_transport_do_socket_init(struct vsock_sock=
 *vsk,
 }
 EXPORT_SYMBOL_GPL(virtio_transport_do_socket_init);
=20
-u64 virtio_transport_get_buffer_size(struct vsock_sock *vsk)
-{
-=09struct virtio_vsock_sock *vvs =3D vsk->trans;
-
-=09return vvs->buf_size;
-}
-EXPORT_SYMBOL_GPL(virtio_transport_get_buffer_size);
-
-u64 virtio_transport_get_min_buffer_size(struct vsock_sock *vsk)
+/* sk_lock held by the caller */
+void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64 *val)
 {
 =09struct virtio_vsock_sock *vvs =3D vsk->trans;
=20
-=09return vvs->buf_size_min;
-}
-EXPORT_SYMBOL_GPL(virtio_transport_get_min_buffer_size);
-
-u64 virtio_transport_get_max_buffer_size(struct vsock_sock *vsk)
-{
-=09struct virtio_vsock_sock *vvs =3D vsk->trans;
-
-=09return vvs->buf_size_max;
-}
-EXPORT_SYMBOL_GPL(virtio_transport_get_max_buffer_size);
-
-void virtio_transport_set_buffer_size(struct vsock_sock *vsk, u64 val)
-{
-=09struct virtio_vsock_sock *vvs =3D vsk->trans;
+=09if (*val > VIRTIO_VSOCK_MAX_BUF_SIZE)
+=09=09*val =3D VIRTIO_VSOCK_MAX_BUF_SIZE;
=20
-=09if (val > VIRTIO_VSOCK_MAX_BUF_SIZE)
-=09=09val =3D VIRTIO_VSOCK_MAX_BUF_SIZE;
-=09if (val < vvs->buf_size_min)
-=09=09vvs->buf_size_min =3D val;
-=09if (val > vvs->buf_size_max)
-=09=09vvs->buf_size_max =3D val;
-=09vvs->buf_size =3D val;
-=09vvs->buf_alloc =3D val;
+=09vvs->buf_alloc =3D *val;
=20
 =09virtio_transport_send_credit_update(vsk, VIRTIO_VSOCK_TYPE_STREAM,
 =09=09=09=09=09    NULL);
 }
-EXPORT_SYMBOL_GPL(virtio_transport_set_buffer_size);
-
-void virtio_transport_set_min_buffer_size(struct vsock_sock *vsk, u64 val)
-{
-=09struct virtio_vsock_sock *vvs =3D vsk->trans;
-
-=09if (val > VIRTIO_VSOCK_MAX_BUF_SIZE)
-=09=09val =3D VIRTIO_VSOCK_MAX_BUF_SIZE;
-=09if (val > vvs->buf_size)
-=09=09vvs->buf_size =3D val;
-=09vvs->buf_size_min =3D val;
-}
-EXPORT_SYMBOL_GPL(virtio_transport_set_min_buffer_size);
-
-void virtio_transport_set_max_buffer_size(struct vsock_sock *vsk, u64 val)
-{
-=09struct virtio_vsock_sock *vvs =3D vsk->trans;
-
-=09if (val > VIRTIO_VSOCK_MAX_BUF_SIZE)
-=09=09val =3D VIRTIO_VSOCK_MAX_BUF_SIZE;
-=09if (val < vvs->buf_size)
-=09=09vvs->buf_size =3D val;
-=09vvs->buf_size_max =3D val;
-}
-EXPORT_SYMBOL_GPL(virtio_transport_set_max_buffer_size);
+EXPORT_SYMBOL_GPL(virtio_transport_notify_buffer_size);
=20
 int
 virtio_transport_notify_poll_in(struct vsock_sock *vsk,
@@ -632,9 +577,7 @@ EXPORT_SYMBOL_GPL(virtio_transport_notify_send_post_enq=
ueue);
=20
 u64 virtio_transport_stream_rcvhiwat(struct vsock_sock *vsk)
 {
-=09struct virtio_vsock_sock *vvs =3D vsk->trans;
-
-=09return vvs->buf_size;
+=09return vsk->buffer_size;
 }
 EXPORT_SYMBOL_GPL(virtio_transport_stream_rcvhiwat);
=20
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.=
c
index cf3b78f0038f..608bb6bd79aa 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -74,10 +74,6 @@ static u32 vmci_transport_qp_resumed_sub_id =3D VMCI_INV=
ALID_ID;
=20
 static int PROTOCOL_OVERRIDE =3D -1;
=20
-#define VMCI_TRANSPORT_DEFAULT_QP_SIZE_MIN   128
-#define VMCI_TRANSPORT_DEFAULT_QP_SIZE       262144
-#define VMCI_TRANSPORT_DEFAULT_QP_SIZE_MAX   262144
-
 /* Helper function to convert from a VMCI error code to a VSock error code=
. */
=20
 static s32 vmci_transport_error_to_vsock_error(s32 vmci_error)
@@ -1025,11 +1021,11 @@ static int vmci_transport_recv_listen(struct sock *=
sk,
 =09/* If the proposed size fits within our min/max, accept it. Otherwise
 =09 * propose our own size.
 =09 */
-=09if (pkt->u.size >=3D vmci_trans(vpending)->queue_pair_min_size &&
-=09    pkt->u.size <=3D vmci_trans(vpending)->queue_pair_max_size) {
+=09if (pkt->u.size >=3D vpending->buffer_min_size &&
+=09    pkt->u.size <=3D vpending->buffer_max_size) {
 =09=09qp_size =3D pkt->u.size;
 =09} else {
-=09=09qp_size =3D vmci_trans(vpending)->queue_pair_size;
+=09=09qp_size =3D vpending->buffer_size;
 =09}
=20
 =09/* Figure out if we are using old or new requests based on the
@@ -1098,7 +1094,7 @@ static int vmci_transport_recv_listen(struct sock *sk=
,
 =09pending->sk_state =3D TCP_SYN_SENT;
 =09vmci_trans(vpending)->produce_size =3D
 =09=09vmci_trans(vpending)->consume_size =3D qp_size;
-=09vmci_trans(vpending)->queue_pair_size =3D qp_size;
+=09vpending->buffer_size =3D qp_size;
=20
 =09vmci_trans(vpending)->notify_ops->process_request(pending);
=20
@@ -1392,8 +1388,8 @@ static int vmci_transport_recv_connecting_client_nego=
tiate(
 =09vsk->ignore_connecting_rst =3D false;
=20
 =09/* Verify that we're OK with the proposed queue pair size */
-=09if (pkt->u.size < vmci_trans(vsk)->queue_pair_min_size ||
-=09    pkt->u.size > vmci_trans(vsk)->queue_pair_max_size) {
+=09if (pkt->u.size < vsk->buffer_min_size ||
+=09    pkt->u.size > vsk->buffer_max_size) {
 =09=09err =3D -EINVAL;
 =09=09goto destroy;
 =09}
@@ -1498,8 +1494,7 @@ vmci_transport_recv_connecting_client_invalid(struct =
sock *sk,
 =09=09vsk->sent_request =3D false;
 =09=09vsk->ignore_connecting_rst =3D true;
=20
-=09=09err =3D vmci_transport_send_conn_request(
-=09=09=09sk, vmci_trans(vsk)->queue_pair_size);
+=09=09err =3D vmci_transport_send_conn_request(sk, vsk->buffer_size);
 =09=09if (err < 0)
 =09=09=09err =3D vmci_transport_error_to_vsock_error(err);
 =09=09else
@@ -1583,21 +1578,6 @@ static int vmci_transport_socket_init(struct vsock_s=
ock *vsk,
 =09INIT_LIST_HEAD(&vmci_trans(vsk)->elem);
 =09vmci_trans(vsk)->sk =3D &vsk->sk;
 =09spin_lock_init(&vmci_trans(vsk)->lock);
-=09if (psk) {
-=09=09vmci_trans(vsk)->queue_pair_size =3D
-=09=09=09vmci_trans(psk)->queue_pair_size;
-=09=09vmci_trans(vsk)->queue_pair_min_size =3D
-=09=09=09vmci_trans(psk)->queue_pair_min_size;
-=09=09vmci_trans(vsk)->queue_pair_max_size =3D
-=09=09=09vmci_trans(psk)->queue_pair_max_size;
-=09} else {
-=09=09vmci_trans(vsk)->queue_pair_size =3D
-=09=09=09VMCI_TRANSPORT_DEFAULT_QP_SIZE;
-=09=09vmci_trans(vsk)->queue_pair_min_size =3D
-=09=09=09 VMCI_TRANSPORT_DEFAULT_QP_SIZE_MIN;
-=09=09vmci_trans(vsk)->queue_pair_max_size =3D
-=09=09=09VMCI_TRANSPORT_DEFAULT_QP_SIZE_MAX;
-=09}
=20
 =09return 0;
 }
@@ -1813,8 +1793,7 @@ static int vmci_transport_connect(struct vsock_sock *=
vsk)
=20
 =09if (vmci_transport_old_proto_override(&old_pkt_proto) &&
 =09=09old_pkt_proto) {
-=09=09err =3D vmci_transport_send_conn_request(
-=09=09=09sk, vmci_trans(vsk)->queue_pair_size);
+=09=09err =3D vmci_transport_send_conn_request(sk, vsk->buffer_size);
 =09=09if (err < 0) {
 =09=09=09sk->sk_state =3D TCP_CLOSE;
 =09=09=09return err;
@@ -1822,8 +1801,7 @@ static int vmci_transport_connect(struct vsock_sock *=
vsk)
 =09} else {
 =09=09int supported_proto_versions =3D
 =09=09=09vmci_transport_new_proto_supported_versions();
-=09=09err =3D vmci_transport_send_conn_request2(
-=09=09=09=09sk, vmci_trans(vsk)->queue_pair_size,
+=09=09err =3D vmci_transport_send_conn_request2(sk, vsk->buffer_size,
 =09=09=09=09supported_proto_versions);
 =09=09if (err < 0) {
 =09=09=09sk->sk_state =3D TCP_CLOSE;
@@ -1876,46 +1854,6 @@ static bool vmci_transport_stream_is_active(struct v=
sock_sock *vsk)
 =09return !vmci_handle_is_invalid(vmci_trans(vsk)->qp_handle);
 }
=20
-static u64 vmci_transport_get_buffer_size(struct vsock_sock *vsk)
-{
-=09return vmci_trans(vsk)->queue_pair_size;
-}
-
-static u64 vmci_transport_get_min_buffer_size(struct vsock_sock *vsk)
-{
-=09return vmci_trans(vsk)->queue_pair_min_size;
-}
-
-static u64 vmci_transport_get_max_buffer_size(struct vsock_sock *vsk)
-{
-=09return vmci_trans(vsk)->queue_pair_max_size;
-}
-
-static void vmci_transport_set_buffer_size(struct vsock_sock *vsk, u64 val=
)
-{
-=09if (val < vmci_trans(vsk)->queue_pair_min_size)
-=09=09vmci_trans(vsk)->queue_pair_min_size =3D val;
-=09if (val > vmci_trans(vsk)->queue_pair_max_size)
-=09=09vmci_trans(vsk)->queue_pair_max_size =3D val;
-=09vmci_trans(vsk)->queue_pair_size =3D val;
-}
-
-static void vmci_transport_set_min_buffer_size(struct vsock_sock *vsk,
-=09=09=09=09=09       u64 val)
-{
-=09if (val > vmci_trans(vsk)->queue_pair_size)
-=09=09vmci_trans(vsk)->queue_pair_size =3D val;
-=09vmci_trans(vsk)->queue_pair_min_size =3D val;
-}
-
-static void vmci_transport_set_max_buffer_size(struct vsock_sock *vsk,
-=09=09=09=09=09       u64 val)
-{
-=09if (val < vmci_trans(vsk)->queue_pair_size)
-=09=09vmci_trans(vsk)->queue_pair_size =3D val;
-=09vmci_trans(vsk)->queue_pair_max_size =3D val;
-}
-
 static int vmci_transport_notify_poll_in(
 =09struct vsock_sock *vsk,
 =09size_t target,
@@ -2098,12 +2036,6 @@ static const struct vsock_transport vmci_transport =
=3D {
 =09.notify_send_pre_enqueue =3D vmci_transport_notify_send_pre_enqueue,
 =09.notify_send_post_enqueue =3D vmci_transport_notify_send_post_enqueue,
 =09.shutdown =3D vmci_transport_shutdown,
-=09.set_buffer_size =3D vmci_transport_set_buffer_size,
-=09.set_min_buffer_size =3D vmci_transport_set_min_buffer_size,
-=09.set_max_buffer_size =3D vmci_transport_set_max_buffer_size,
-=09.get_buffer_size =3D vmci_transport_get_buffer_size,
-=09.get_min_buffer_size =3D vmci_transport_get_min_buffer_size,
-=09.get_max_buffer_size =3D vmci_transport_get_max_buffer_size,
 =09.get_local_cid =3D vmci_transport_get_local_cid,
 };
=20
diff --git a/net/vmw_vsock/vmci_transport.h b/net/vmw_vsock/vmci_transport.=
h
index 1ca1e8640b31..b7b072194282 100644
--- a/net/vmw_vsock/vmci_transport.h
+++ b/net/vmw_vsock/vmci_transport.h
@@ -108,9 +108,6 @@ struct vmci_transport {
 =09struct vmci_qp *qpair;
 =09u64 produce_size;
 =09u64 consume_size;
-=09u64 queue_pair_size;
-=09u64 queue_pair_min_size;
-=09u64 queue_pair_max_size;
 =09u32 detach_sub_id;
 =09union vmci_transport_notify notify;
 =09const struct vmci_transport_notify_ops *notify_ops;
--=20
2.21.0

