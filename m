Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 591A610228C
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 12:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbfKSLCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 06:02:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60709 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727630AbfKSLBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 06:01:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574161298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+TpsTNb8F4YRI6TLaH+wSJs+oDBX86nBQbo9F03+T2Q=;
        b=TF9Fu8vR5KHPQ/UOksuZx/ZTE6rZ+sNnc/JsetdUkbBG6ZOtnoHLZNjLn4Mjpz2vva+ckH
        ILFlIMKfKddV5jE1eiUzS/sj+XisjtDy8lhfNMV1tWKzPr8RGVhUzQPjoM73yykzv0aJZE
        BtMLK6l8yTKeAkmC8+0z23fCCibo3FA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-uuIYqfakNAqOeRLo6xzJIw-1; Tue, 19 Nov 2019 06:01:35 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6DD90801FD2;
        Tue, 19 Nov 2019 11:01:34 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-41.ams2.redhat.com [10.36.117.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75E4760BE0;
        Tue, 19 Nov 2019 11:01:32 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: [PATCH net-next 3/6] vsock: add local transport support in the vsock core
Date:   Tue, 19 Nov 2019 12:01:18 +0100
Message-Id: <20191119110121.14480-4-sgarzare@redhat.com>
In-Reply-To: <20191119110121.14480-1-sgarzare@redhat.com>
References: <20191119110121.14480-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: uuIYqfakNAqOeRLo6xzJIw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows to register a transport able to handle
local communication (loopback).

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/net/af_vsock.h   |  2 ++
 net/vmw_vsock/af_vsock.c | 17 ++++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 4206dc6d813f..b1c717286993 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -98,6 +98,8 @@ struct vsock_transport_send_notify_data {
 #define VSOCK_TRANSPORT_F_G2H=09=090x00000002
 /* Transport provides DGRAM communication */
 #define VSOCK_TRANSPORT_F_DGRAM=09=090x00000004
+/* Transport provides local (loopback) communication */
+#define VSOCK_TRANSPORT_F_LOCAL=09=090x00000008
=20
 struct vsock_transport {
 =09struct module *module;
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index cc8659838bf2..c9e5bad59dc1 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -136,6 +136,8 @@ static const struct vsock_transport *transport_h2g;
 static const struct vsock_transport *transport_g2h;
 /* Transport used for DGRAM communication */
 static const struct vsock_transport *transport_dgram;
+/* Transport used for local communication */
+static const struct vsock_transport *transport_local;
 static DEFINE_MUTEX(vsock_register_mutex);
=20
 /**** UTILS ****/
@@ -2130,7 +2132,7 @@ EXPORT_SYMBOL_GPL(vsock_core_get_transport);
=20
 int vsock_core_register(const struct vsock_transport *t, int features)
 {
-=09const struct vsock_transport *t_h2g, *t_g2h, *t_dgram;
+=09const struct vsock_transport *t_h2g, *t_g2h, *t_dgram, *t_local;
 =09int err =3D mutex_lock_interruptible(&vsock_register_mutex);
=20
 =09if (err)
@@ -2139,6 +2141,7 @@ int vsock_core_register(const struct vsock_transport =
*t, int features)
 =09t_h2g =3D transport_h2g;
 =09t_g2h =3D transport_g2h;
 =09t_dgram =3D transport_dgram;
+=09t_local =3D transport_local;
=20
 =09if (features & VSOCK_TRANSPORT_F_H2G) {
 =09=09if (t_h2g) {
@@ -2164,9 +2167,18 @@ int vsock_core_register(const struct vsock_transport=
 *t, int features)
 =09=09t_dgram =3D t;
 =09}
=20
+=09if (features & VSOCK_TRANSPORT_F_LOCAL) {
+=09=09if (t_local) {
+=09=09=09err =3D -EBUSY;
+=09=09=09goto err_busy;
+=09=09}
+=09=09t_local =3D t;
+=09}
+
 =09transport_h2g =3D t_h2g;
 =09transport_g2h =3D t_g2h;
 =09transport_dgram =3D t_dgram;
+=09transport_local =3D t_local;
=20
 err_busy:
 =09mutex_unlock(&vsock_register_mutex);
@@ -2187,6 +2199,9 @@ void vsock_core_unregister(const struct vsock_transpo=
rt *t)
 =09if (transport_dgram =3D=3D t)
 =09=09transport_dgram =3D NULL;
=20
+=09if (transport_local =3D=3D t)
+=09=09transport_local =3D NULL;
+
 =09mutex_unlock(&vsock_register_mutex);
 }
 EXPORT_SYMBOL_GPL(vsock_core_unregister);
--=20
2.21.0

