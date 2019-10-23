Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4358BE1726
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 11:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404166AbfJWJ6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 05:58:06 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32211 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404141AbfJWJ6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 05:58:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571824681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qx+Ku3BlIpX0I15FPAq9IIdpSSgHtN5oiRx9nIugrWU=;
        b=WbGlToV26OtqHv5PrMDWAsqGb7Nbendg74Ez8ZbWj2zGZ7e3evpubD0F8UEF1Rf4U0X+AT
        XNmkMfGBAYglyouYud7prFt2KHW8JdSx9ly/gsbAVFPPLZGLgM66ak2k+DQLoQ/AZzBaC7
        9Af9bqMzhG76JE1r5UC4DQ5ioCm0Et4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-PG_tMOeSOJiKcBZB6AL-jA-1; Wed, 23 Oct 2019 05:57:58 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6ED6E800D49;
        Wed, 23 Oct 2019 09:57:56 +0000 (UTC)
Received: from steredhat.redhat.com (unknown [10.36.118.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 109675C1B2;
        Wed, 23 Oct 2019 09:57:52 +0000 (UTC)
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
Subject: [PATCH net-next 08/14] vsock: add vsock_create_connected() called by transports
Date:   Wed, 23 Oct 2019 11:55:48 +0200
Message-Id: <20191023095554.11340-9-sgarzare@redhat.com>
In-Reply-To: <20191023095554.11340-1-sgarzare@redhat.com>
References: <20191023095554.11340-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: PG_tMOeSOJiKcBZB6AL-jA-1
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
index 90ac46ea12ef..95878bed2c67 100644
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
@@ -705,6 +704,13 @@ static int vsock_queue_rcv_skb(struct sock *sk, struct=
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
index d62297a62ca6..0ce792a1bf6c 100644
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
index b2a310dfa158..f7d0ecbd8f97 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1002,8 +1002,7 @@ virtio_transport_recv_listen(struct sock *sk, struct =
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
index 8290d37b6587..5955238ffc13 100644
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

