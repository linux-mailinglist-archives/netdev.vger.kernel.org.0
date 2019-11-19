Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBE9102282
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 12:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbfKSLBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 06:01:47 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20953 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727814AbfKSLBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 06:01:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574161303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k/VeJds5qaMYhPiq90nAYjkDf0ayvTRObqcxf9AwYA8=;
        b=clPkmOffwDdWZI6uUo9cOdg+jipbQ5iZOD3rkYja97SNf+MXvFyQw18JKUhyifDKpk+dJr
        aVobFLt8NYogIiuEFUG1J4qljCvFdQCkPFXSxwnFNHlWfMQyQ1SZdj7jgqz7MlxaZ9a0TI
        9mE53WG1buF3TEEGmhVojxZ5AxuygVo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-iIIW8aj3MP-9gpfHsmbf1A-1; Tue, 19 Nov 2019 06:01:40 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DAA3B107ACE8;
        Tue, 19 Nov 2019 11:01:38 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-41.ams2.redhat.com [10.36.117.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0764260BE0;
        Tue, 19 Nov 2019 11:01:36 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: [PATCH net-next 5/6] vsock: use local transport when it is loaded
Date:   Tue, 19 Nov 2019 12:01:20 +0100
Message-Id: <20191119110121.14480-6-sgarzare@redhat.com>
In-Reply-To: <20191119110121.14480-1-sgarzare@redhat.com>
References: <20191119110121.14480-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: iIIW8aj3MP-9gpfHsmbf1A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
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
 net/vmw_vsock/af_vsock.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index c9e5bad59dc1..40bbb2a17e3d 100644
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
@@ -404,9 +419,10 @@ static void vsock_deassign_transport(struct vsock_sock=
 *vsk)
  * (e.g. during the connect() or when a connection request on a listener
  * socket is received).
  * The vsk->remote_addr is used to decide which transport to use:
- *  - remote CID <=3D VMADDR_CID_HOST will use guest->host transport;
- *  - remote CID =3D=3D local_cid (guest->host transport) will use guest->=
host
- *    transport for loopback (host->guest transports don't support loopbac=
k);
+ *  - remote CID =3D=3D VMADDR_CID_LOCAL or g2h->local_cid or VMADDR_CID_H=
OST if
+ *    g2h is not loaded, will use local transport;
+ *  - remote CID =3D=3D VMADDR_CID_HOST or VMADDR_CID_HYPERVISOR, will use
+ *    guest->host transport;
  *  - remote CID > VMADDR_CID_HOST will use host->guest transport;
  */
 int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
@@ -420,9 +436,10 @@ int vsock_assign_transport(struct vsock_sock *vsk, str=
uct vsock_sock *psk)
 =09=09new_transport =3D transport_dgram;
 =09=09break;
 =09case SOCK_STREAM:
-=09=09if (remote_cid <=3D VMADDR_CID_HOST ||
-=09=09    (transport_g2h &&
-=09=09     remote_cid =3D=3D transport_g2h->get_local_cid()))
+=09=09if (vsock_use_local_transport(remote_cid))
+=09=09=09new_transport =3D transport_local;
+=09=09else if (remote_cid =3D=3D VMADDR_CID_HOST ||
+=09=09=09 remote_cid =3D=3D VMADDR_CID_HYPERVISOR)
 =09=09=09new_transport =3D transport_g2h;
 =09=09else
 =09=09=09new_transport =3D transport_h2g;
@@ -459,6 +476,9 @@ bool vsock_find_cid(unsigned int cid)
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
2.21.0

