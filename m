Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28392FC34D
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 10:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfKNJ6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 04:58:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30757 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727298AbfKNJ6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 04:58:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573725531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tyzaEqsxubxPfYHQ9uGDf27MfxbTKex6Xr0WT8Sku1E=;
        b=TcPfMz4uOC4v1USvPw3xCkFiFDa42TFGm/3q5aTCtCQQgSyq2M4Szb/Xx0RtmMbxVGCLNy
        qWBThmGkj8JMumihTNAavx5sDGJxXRJK9IHxdQUjTKwoWResOnlGjVYXUMEhYKrwfsblc7
        2H99CadlFQtxurkOIHDfuRvaKZV075g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-dRY_8fKuMkmqbtFjdX13Wg-1; Thu, 14 Nov 2019 04:58:48 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B91F800C73;
        Thu, 14 Nov 2019 09:58:46 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-81.ams2.redhat.com [10.36.117.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C6EA165D3;
        Thu, 14 Nov 2019 09:58:42 +0000 (UTC)
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
Subject: [PATCH net-next v2 09/15] vsock: move vsock_insert_unbound() in the vsock_create()
Date:   Thu, 14 Nov 2019 10:57:44 +0100
Message-Id: <20191114095750.59106-10-sgarzare@redhat.com>
In-Reply-To: <20191114095750.59106-1-sgarzare@redhat.com>
References: <20191114095750.59106-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: dRY_8fKuMkmqbtFjdX13Wg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vsock_insert_unbound() was called only when 'sock' parameter of
__vsock_create() was not null. This only happened when
__vsock_create() was called by vsock_create().

In order to simplify the multi-transports support, this patch
moves vsock_insert_unbound() at the end of vsock_create().

Reviewed-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/af_vsock.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 7c11ac1bc542..8985d9d417f0 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -634,9 +634,6 @@ static struct sock *__vsock_create(struct net *net,
 =09=09return NULL;
 =09}
=20
-=09if (sock)
-=09=09vsock_insert_unbound(vsk);
-
 =09return sk;
 }
=20
@@ -1887,6 +1884,8 @@ static const struct proto_ops vsock_stream_ops =3D {
 static int vsock_create(struct net *net, struct socket *sock,
 =09=09=09int protocol, int kern)
 {
+=09struct sock *sk;
+
 =09if (!sock)
 =09=09return -EINVAL;
=20
@@ -1906,7 +1905,13 @@ static int vsock_create(struct net *net, struct sock=
et *sock,
=20
 =09sock->state =3D SS_UNCONNECTED;
=20
-=09return __vsock_create(net, sock, NULL, GFP_KERNEL, 0, kern) ? 0 : -ENOM=
EM;
+=09sk =3D __vsock_create(net, sock, NULL, GFP_KERNEL, 0, kern);
+=09if (!sk)
+=09=09return -ENOMEM;
+
+=09vsock_insert_unbound(vsock_sk(sk));
+
+=09return 0;
 }
=20
 static const struct net_proto_family vsock_family_ops =3D {
--=20
2.21.0

