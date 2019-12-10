Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F79E118572
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 11:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfLJKnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 05:43:45 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49506 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727518AbfLJKna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 05:43:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575974609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jaNjlxDMPZqlhfTY1RQg/SgU5i5aNL66cyn4N8vlSXA=;
        b=Q8YEQi/QUMQQMrctDQ/h5UDm66gIcg/86FLDRHNrz8qkboLELdUqNWANDVGxD15TKzZyGU
        MAtRtkw3E4iUx8LYm4ZaupfeBJzBqVz7Km9kui/ocviJnPAmvrDxzNaAsTR9zAL3JWcyQj
        2C0peEyeJjRnj96g7w0Z/GYm6QDxRvc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-S4IbS98XMCuB5YZLZx2cFQ-1; Tue, 10 Dec 2019 05:43:26 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22F6D12A7E2A;
        Tue, 10 Dec 2019 10:43:25 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-168.ams2.redhat.com [10.36.117.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F3F4C6057B;
        Tue, 10 Dec 2019 10:43:22 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Dexuan Cui <decui@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH net-next v2 5/6] vsock: use local transport when it is loaded
Date:   Tue, 10 Dec 2019 11:43:06 +0100
Message-Id: <20191210104307.89346-6-sgarzare@redhat.com>
In-Reply-To: <20191210104307.89346-1-sgarzare@redhat.com>
References: <20191210104307.89346-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: S4IbS98XMCuB5YZLZx2cFQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a transport that can handle the local communication,
we can use it when it is loaded.

A socket will use the local transport (loopback) when the remote
CID is:
- equal to VMADDR_CID_LOCAL
- or equal to transport_g2h->get_local_cid(), if transport_g2h
  is loaded (this allows us to keep the same behavior implemented
  by virtio and vmci transports)
- or equal to VMADDR_CID_HOST, if transport_g2h is not loaded

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
v1 -> v2:
- use G2H transport when local transport is not loaded and remote cid
  is VMADDR_CID_LOCAL [Stefan]
---
 net/vmw_vsock/af_vsock.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 3da0749a0c97..9c5b2a91baad 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -388,6 +388,21 @@ void vsock_enqueue_accept(struct sock *listener, struc=
t sock *connected)
 }
 EXPORT_SYMBOL_GPL(vsock_enqueue_accept);
=20
+static bool vsock_use_local_transport(unsigned int remote_cid)
+{
+=09if (!transport_local)
+=09=09return false;
+
+=09if (remote_cid =3D=3D VMADDR_CID_LOCAL)
+=09=09return true;
+
+=09if (transport_g2h) {
+=09=09return remote_cid =3D=3D transport_g2h->get_local_cid();
+=09} else {
+=09=09return remote_cid =3D=3D VMADDR_CID_HOST;
+=09}
+}
+
 static void vsock_deassign_transport(struct vsock_sock *vsk)
 {
 =09if (!vsk->transport)
@@ -404,9 +419,9 @@ static void vsock_deassign_transport(struct vsock_sock =
*vsk)
  * (e.g. during the connect() or when a connection request on a listener
  * socket is received).
  * The vsk->remote_addr is used to decide which transport to use:
+ *  - remote CID =3D=3D VMADDR_CID_LOCAL or g2h->local_cid or VMADDR_CID_H=
OST if
+ *    g2h is not loaded, will use local transport;
  *  - remote CID <=3D VMADDR_CID_HOST will use guest->host transport;
- *  - remote CID =3D=3D local_cid (guest->host transport) will use guest->=
host
- *    transport for loopback (host->guest transports don't support loopbac=
k);
  *  - remote CID > VMADDR_CID_HOST will use host->guest transport;
  */
 int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
@@ -421,9 +436,9 @@ int vsock_assign_transport(struct vsock_sock *vsk, stru=
ct vsock_sock *psk)
 =09=09new_transport =3D transport_dgram;
 =09=09break;
 =09case SOCK_STREAM:
-=09=09if (remote_cid <=3D VMADDR_CID_HOST ||
-=09=09    (transport_g2h &&
-=09=09     remote_cid =3D=3D transport_g2h->get_local_cid()))
+=09=09if (vsock_use_local_transport(remote_cid))
+=09=09=09new_transport =3D transport_local;
+=09=09else if (remote_cid <=3D VMADDR_CID_HOST)
 =09=09=09new_transport =3D transport_g2h;
 =09=09else
 =09=09=09new_transport =3D transport_h2g;
@@ -466,6 +481,9 @@ bool vsock_find_cid(unsigned int cid)
 =09if (transport_h2g && cid =3D=3D VMADDR_CID_HOST)
 =09=09return true;
=20
+=09if (transport_local && cid =3D=3D VMADDR_CID_LOCAL)
+=09=09return true;
+
 =09return false;
 }
 EXPORT_SYMBOL_GPL(vsock_find_cid);
--=20
2.23.0

