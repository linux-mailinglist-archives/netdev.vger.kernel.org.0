Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5436811856B
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 11:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfLJKn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 05:43:26 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33335 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727480AbfLJKnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 05:43:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575974605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bWw5CHeiqYpd2mPCO8jLMgnH+0xB69v4o/ZzGi9D20g=;
        b=fSIOCswdrpz7BR4+RkDpC4isVlBvp7if3vuM2f7WKT3HWkMQGGrzpQzyIpCMJFRXRI2SNY
        9O/1VcnE2+f+1OLIIRp/hs9Djx143YqIQoIn2WPqLNiLvlkm6thH5iRzZRI/67fUtH4sTk
        nax4nPmPnOVgsLfvTo/3pXpqOgvbxa4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-LdCDeDbyMre2pv2b90AovA-1; Tue, 10 Dec 2019 05:43:21 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6130F1183E2E;
        Tue, 10 Dec 2019 10:43:20 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-168.ams2.redhat.com [10.36.117.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1546060570;
        Tue, 10 Dec 2019 10:43:17 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Dexuan Cui <decui@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH net-next v2 3/6] vsock: add local transport support in the vsock core
Date:   Tue, 10 Dec 2019 11:43:04 +0100
Message-Id: <20191210104307.89346-4-sgarzare@redhat.com>
In-Reply-To: <20191210104307.89346-1-sgarzare@redhat.com>
References: <20191210104307.89346-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: LdCDeDbyMre2pv2b90AovA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows to register a transport able to handle
local communication (loopback).

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
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
index 74db4cd637a7..3da0749a0c97 100644
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
@@ -2137,7 +2139,7 @@ EXPORT_SYMBOL_GPL(vsock_core_get_transport);
=20
 int vsock_core_register(const struct vsock_transport *t, int features)
 {
-=09const struct vsock_transport *t_h2g, *t_g2h, *t_dgram;
+=09const struct vsock_transport *t_h2g, *t_g2h, *t_dgram, *t_local;
 =09int err =3D mutex_lock_interruptible(&vsock_register_mutex);
=20
 =09if (err)
@@ -2146,6 +2148,7 @@ int vsock_core_register(const struct vsock_transport =
*t, int features)
 =09t_h2g =3D transport_h2g;
 =09t_g2h =3D transport_g2h;
 =09t_dgram =3D transport_dgram;
+=09t_local =3D transport_local;
=20
 =09if (features & VSOCK_TRANSPORT_F_H2G) {
 =09=09if (t_h2g) {
@@ -2171,9 +2174,18 @@ int vsock_core_register(const struct vsock_transport=
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
@@ -2194,6 +2206,9 @@ void vsock_core_unregister(const struct vsock_transpo=
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
2.23.0

