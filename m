Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7361FC356
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 10:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbfKNJ7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 04:59:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55044 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727431AbfKNJ7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 04:59:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573725552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QljSnaf1FSPYM6HmLOdL6Z62VLNrQqpYUEnkNfrauXs=;
        b=AMelJHsxpRJh+Gla2RZoydCBMBd+qxBJLk88m6S0oFJbachwFrFHvfPWIMAsN6SCQmkVEI
        i6nA8oV4CYANh/xCRUqlj+xnUNBoZyyefk7i3iCxzNSdOyReAm/7nC4Tcma6X7BlH8fDRr
        vlUHLeLjDlBj/41lBGNR0zOCPOXq3Lg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-8rDX-7Z1MdmAqbsAgWb--A-1; Thu, 14 Nov 2019 04:59:09 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1080593A2;
        Thu, 14 Nov 2019 09:59:07 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-81.ams2.redhat.com [10.36.117.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C7BC19757;
        Thu, 14 Nov 2019 09:59:04 +0000 (UTC)
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
Subject: [PATCH net-next v2 13/15] vsock: prevent transport modules unloading
Date:   Thu, 14 Nov 2019 10:57:48 +0100
Message-Id: <20191114095750.59106-14-sgarzare@redhat.com>
In-Reply-To: <20191114095750.59106-1-sgarzare@redhat.com>
References: <20191114095750.59106-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 8rDX-7Z1MdmAqbsAgWb--A-1
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
Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
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
index cf5c3691251b..4206dc6d813f 100644
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
index 5357714b6104..5cb0ae42d916 100644
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
@@ -418,10 +428,13 @@ int vsock_assign_transport(struct vsock_sock *vsk, st=
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
@@ -741,8 +754,7 @@ static void vsock_sk_destruct(struct sock *sk)
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
index 1c9e65d7d94d..3c7d07a99fc5 100644
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
index d9c9c834ad6f..644d32e43d23 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -2020,6 +2020,7 @@ static u32 vmci_transport_get_local_cid(void)
 }
=20
 static struct vsock_transport vmci_transport =3D {
+=09.module =3D THIS_MODULE,
 =09.init =3D vmci_transport_socket_init,
 =09.destruct =3D vmci_transport_destruct,
 =09.release =3D vmci_transport_release,
--=20
2.21.0

