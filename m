Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEECEE1710
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 11:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404275AbfJWJ6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 05:58:30 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28990 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404265AbfJWJ60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 05:58:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571824705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E6cdvtI+lVBkl+0vlDQhx2DxQdbC47YC/eILjebBwE4=;
        b=G8uWtAVs49ZQU4YUtaiffkTTBvmHddGZDveP8zSTsa4pHxG+9zKKaEE5kVRX6rw974uYcM
        QSAIqUyXyuT1tYfeWKqRhhUIRg2hgfDLK7dgEpI1t6WSkbSq3e52yc2HMoVSWDjymsQC42
        jl9VnkjffsIRf0DyDXWcDe0w+qTSAFE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-4Nuw3kesNVi0_lsKblgbMQ-1; Wed, 23 Oct 2019 05:58:21 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB84C1005500;
        Wed, 23 Oct 2019 09:58:19 +0000 (UTC)
Received: from steredhat.redhat.com (unknown [10.36.118.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 58BCB5C1B2;
        Wed, 23 Oct 2019 09:58:16 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-hyperv@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH net-next 13/14] vsock: prevent transport modules unloading
Date:   Wed, 23 Oct 2019 11:55:53 +0200
Message-Id: <20191023095554.11340-14-sgarzare@redhat.com>
In-Reply-To: <20191023095554.11340-1-sgarzare@redhat.com>
References: <20191023095554.11340-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 4Nuw3kesNVi0_lsKblgbMQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds 'module' member in the 'struct vsock_transport'
in order to get/put the transport module. This prevents the
module unloading while sockets are assigned to it.

We increase the module refcnt when a socket is assigned to a
transport, and we decrease the module refcnt when the socket
is destructed.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
RFC -> v1:
- fixed typo 's/tranport/transport/' in a comment (Stefan)
---
 drivers/vhost/vsock.c            |  2 ++
 include/net/af_vsock.h           |  2 ++
 net/vmw_vsock/af_vsock.c         | 20 ++++++++++++++++----
 net/vmw_vsock/hyperv_transport.c |  2 ++
 net/vmw_vsock/virtio_transport.c |  2 ++
 net/vmw_vsock/vmci_transport.c   |  1 +
 6 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index b235f4bbe8ea..fdda9ec625ad 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -386,6 +386,8 @@ static bool vhost_vsock_more_replies(struct vhost_vsock=
 *vsock)
=20
 static struct virtio_transport vhost_transport =3D {
 =09.transport =3D {
+=09=09.module                   =3D THIS_MODULE,
+
 =09=09.get_local_cid            =3D vhost_transport_get_local_cid,
=20
 =09=09.init                     =3D virtio_transport_do_socket_init,
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 27a3463e4892..269e2f034789 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -100,6 +100,8 @@ struct vsock_transport_send_notify_data {
 #define VSOCK_TRANSPORT_F_DGRAM=09=090x00000004
=20
 struct vsock_transport {
+=09struct module *module;
+
 =09/* Initialize/tear-down socket. */
 =09int (*init)(struct vsock_sock *, struct vsock_sock *);
 =09void (*destruct)(struct vsock_sock *);
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index dddd85d9a147..1f2e707cae66 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -380,6 +380,16 @@ void vsock_enqueue_accept(struct sock *listener, struc=
t sock *connected)
 }
 EXPORT_SYMBOL_GPL(vsock_enqueue_accept);
=20
+static void vsock_deassign_transport(struct vsock_sock *vsk)
+{
+=09if (!vsk->transport)
+=09=09return;
+
+=09vsk->transport->destruct(vsk);
+=09module_put(vsk->transport->module);
+=09vsk->transport =3D NULL;
+}
+
 /* Assign a transport to a socket and call the .init transport callback.
  *
  * Note: for stream socket this must be called when vsk->remote_addr is se=
t
@@ -413,10 +423,13 @@ int vsock_assign_transport(struct vsock_sock *vsk, st=
ruct vsock_sock *psk)
 =09=09=09return 0;
=20
 =09=09vsk->transport->release(vsk);
-=09=09vsk->transport->destruct(vsk);
+=09=09vsock_deassign_transport(vsk);
 =09}
=20
-=09if (!new_transport)
+=09/* We increase the module refcnt to prevent the transport unloading
+=09 * while there are open sockets assigned to it.
+=09 */
+=09if (!new_transport || !try_module_get(new_transport->module))
 =09=09return -ENODEV;
=20
 =09vsk->transport =3D new_transport;
@@ -737,8 +750,7 @@ static void vsock_sk_destruct(struct sock *sk)
 {
 =09struct vsock_sock *vsk =3D vsock_sk(sk);
=20
-=09if (vsk->transport)
-=09=09vsk->transport->destruct(vsk);
+=09vsock_deassign_transport(vsk);
=20
 =09/* When clearing these addresses, there's no need to set the family and
 =09 * possibly register the address family with the kernel.
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transp=
ort.c
index 0ea66d87af39..d0a349d85414 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -857,6 +857,8 @@ int hvs_notify_send_post_enqueue(struct vsock_sock *vsk=
, ssize_t written,
 }
=20
 static struct vsock_transport hvs_transport =3D {
+=09.module                   =3D THIS_MODULE,
+
 =09.get_local_cid            =3D hvs_get_local_cid,
=20
 =09.init                     =3D hvs_sock_init,
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transp=
ort.c
index 83ad85050384..1458c5c8b64d 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -462,6 +462,8 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
=20
 static struct virtio_transport virtio_transport =3D {
 =09.transport =3D {
+=09=09.module                   =3D THIS_MODULE,
+
 =09=09.get_local_cid            =3D virtio_transport_get_local_cid,
=20
 =09=09.init                     =3D virtio_transport_do_socket_init,
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.=
c
index 04437f822d82..0cbf023fae11 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -2019,6 +2019,7 @@ static u32 vmci_transport_get_local_cid(void)
 }
=20
 static struct vsock_transport vmci_transport =3D {
+=09.module =3D THIS_MODULE,
 =09.init =3D vmci_transport_socket_init,
 =09.destruct =3D vmci_transport_destruct,
 =09.release =3D vmci_transport_release,
--=20
2.21.0

