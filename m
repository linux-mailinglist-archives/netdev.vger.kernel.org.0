Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 193F1FC366
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 10:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfKNJ6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 04:58:50 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38961 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727234AbfKNJ6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 04:58:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573725527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=65r3DuwQkGH8EpQmPjQ17L+IGIFGZoxYFV27wOZKOTQ=;
        b=E9KjmFasnK6oU4fokAgeJujTE0XazVDhu+Trlo8bi6cl3U5Jg7GaIGvQbjiwLKhpATPUkk
        CbMucGQmLnjUNTKi/IjrMOV8SmmxfXZp6glUTKeIiAj08MVEXyY7MvaOs6caqXm1jRSU8M
        AZfYIkOo7/M9VC5MXkfkt7TxDWidfIc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-lzmR9pLcOE6BPlHynGmxEw-1; Thu, 14 Nov 2019 04:58:44 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0A6C107ACC5;
        Thu, 14 Nov 2019 09:58:42 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-81.ams2.redhat.com [10.36.117.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F6D2165D3;
        Thu, 14 Nov 2019 09:58:39 +0000 (UTC)
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
Subject: [PATCH net-next v2 08/15] vsock: add vsock_create_connected() called by transports
Date:   Thu, 14 Nov 2019 10:57:43 +0100
Message-Id: <20191114095750.59106-9-sgarzare@redhat.com>
In-Reply-To: <20191114095750.59106-1-sgarzare@redhat.com>
References: <20191114095750.59106-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: lzmR9pLcOE6BPlHynGmxEw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All transports call __vsock_create() with the same parameters,
most of them depending on the parent socket. In order to simplify
the VSOCK core APIs exposed to the transports, this patch adds
the vsock_create_connected() callable from transports to create
a new socket when a connection request is received.
We also unexported the __vsock_create().

Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/net/af_vsock.h                  |  5 +----
 net/vmw_vsock/af_vsock.c                | 20 +++++++++++++-------
 net/vmw_vsock/hyperv_transport.c        |  3 +--
 net/vmw_vsock/virtio_transport_common.c |  3 +--
 net/vmw_vsock/vmci_transport.c          |  3 +--
 5 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 4b5d16840fd4..fa1570dc9f5c 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -76,10 +76,7 @@ struct vsock_sock {
=20
 s64 vsock_stream_has_data(struct vsock_sock *vsk);
 s64 vsock_stream_has_space(struct vsock_sock *vsk);
-struct sock *__vsock_create(struct net *net,
-=09=09=09    struct socket *sock,
-=09=09=09    struct sock *parent,
-=09=09=09    gfp_t priority, unsigned short type, int kern);
+struct sock *vsock_create_connected(struct sock *parent);
=20
 /**** TRANSPORT ****/
=20
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 11b88094e3b2..7c11ac1bc542 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -567,12 +567,12 @@ static int __vsock_bind(struct sock *sk, struct socka=
ddr_vm *addr)
=20
 static void vsock_connect_timeout(struct work_struct *work);
=20
-struct sock *__vsock_create(struct net *net,
-=09=09=09    struct socket *sock,
-=09=09=09    struct sock *parent,
-=09=09=09    gfp_t priority,
-=09=09=09    unsigned short type,
-=09=09=09    int kern)
+static struct sock *__vsock_create(struct net *net,
+=09=09=09=09   struct socket *sock,
+=09=09=09=09   struct sock *parent,
+=09=09=09=09   gfp_t priority,
+=09=09=09=09   unsigned short type,
+=09=09=09=09   int kern)
 {
 =09struct sock *sk;
 =09struct vsock_sock *psk;
@@ -639,7 +639,6 @@ struct sock *__vsock_create(struct net *net,
=20
 =09return sk;
 }
-EXPORT_SYMBOL_GPL(__vsock_create);
=20
 static void __vsock_release(struct sock *sk, int level)
 {
@@ -703,6 +702,13 @@ static int vsock_queue_rcv_skb(struct sock *sk, struct=
 sk_buff *skb)
 =09return err;
 }
=20
+struct sock *vsock_create_connected(struct sock *parent)
+{
+=09return __vsock_create(sock_net(parent), NULL, parent, GFP_KERNEL,
+=09=09=09      parent->sk_type, 0);
+}
+EXPORT_SYMBOL_GPL(vsock_create_connected);
+
 s64 vsock_stream_has_data(struct vsock_sock *vsk)
 {
 =09return vsk->transport->stream_has_data(vsk);
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transp=
ort.c
index ab947561543e..7d0a972a1428 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -360,8 +360,7 @@ static void hvs_open_connection(struct vmbus_channel *c=
han)
 =09=09if (sk->sk_ack_backlog >=3D sk->sk_max_ack_backlog)
 =09=09=09goto out;
=20
-=09=09new =3D __vsock_create(sock_net(sk), NULL, sk, GFP_KERNEL,
-=09=09=09=09     sk->sk_type, 0);
+=09=09new =3D vsock_create_connected(sk);
 =09=09if (!new)
 =09=09=09goto out;
=20
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio=
_transport_common.c
index d4a0bf19aa98..b7b1a98e478e 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1004,8 +1004,7 @@ virtio_transport_recv_listen(struct sock *sk, struct =
virtio_vsock_pkt *pkt)
 =09=09return -ENOMEM;
 =09}
=20
-=09child =3D __vsock_create(sock_net(sk), NULL, sk, GFP_KERNEL,
-=09=09=09       sk->sk_type, 0);
+=09child =3D vsock_create_connected(sk);
 =09if (!child) {
 =09=09virtio_transport_reset(vsk, pkt);
 =09=09return -ENOMEM;
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.=
c
index 608bb6bd79aa..b6c8c9cc8d72 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -1004,8 +1004,7 @@ static int vmci_transport_recv_listen(struct sock *sk=
,
 =09=09return -ECONNREFUSED;
 =09}
=20
-=09pending =3D __vsock_create(sock_net(sk), NULL, sk, GFP_KERNEL,
-=09=09=09=09 sk->sk_type, 0);
+=09pending =3D vsock_create_connected(sk);
 =09if (!pending) {
 =09=09vmci_transport_send_reset(sk, pkt);
 =09=09return -ENOMEM;
--=20
2.21.0

