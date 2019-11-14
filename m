Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3101FC32F
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 10:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfKNJ6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 04:58:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46870 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726881AbfKNJ6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 04:58:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573725494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fnsq7tDFsMeM2bW2mfSnMuHGo8jDj07T4KGT6z4t4ZE=;
        b=gXqQEl3xlPT3tOeBmwsbkNsqqy0tZHr44OI0gl+vt5QrTyCgP9yixDLzNkD2rp04oiQ8mP
        rBk7pGHNzRyixPq4WIlJaAP0nsmxsS9c3/4AaB3wU21XuYfV411BxpebssrfOi5VxJ89Ez
        YaRNdXDUEc0UZ1gzWvvtzytmZztFT/w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-A843iaCbNWGJZRawbJf9lg-1; Thu, 14 Nov 2019 04:58:11 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9CCF1005509;
        Thu, 14 Nov 2019 09:58:08 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-81.ams2.redhat.com [10.36.117.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 51FD2165D3;
        Thu, 14 Nov 2019 09:58:05 +0000 (UTC)
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
Subject: [PATCH net-next v2 02/15] vsock: remove vm_sockets_get_local_cid()
Date:   Thu, 14 Nov 2019 10:57:37 +0100
Message-Id: <20191114095750.59106-3-sgarzare@redhat.com>
In-Reply-To: <20191114095750.59106-1-sgarzare@redhat.com>
References: <20191114095750.59106-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: A843iaCbNWGJZRawbJf9lg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vm_sockets_get_local_cid() is only used in virtio_transport_common.c.
We can replace it calling the virtio_transport_get_ops() and
using the get_local_cid() callback registered by the transport.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/linux/vm_sockets.h              |  2 --
 net/vmw_vsock/af_vsock.c                | 10 ----------
 net/vmw_vsock/virtio_transport_common.c |  2 +-
 3 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/include/linux/vm_sockets.h b/include/linux/vm_sockets.h
index 33f1a2ecd905..7dd899ccb920 100644
--- a/include/linux/vm_sockets.h
+++ b/include/linux/vm_sockets.h
@@ -10,6 +10,4 @@
=20
 #include <uapi/linux/vm_sockets.h>
=20
-int vm_sockets_get_local_cid(void);
-
 #endif /* _VM_SOCKETS_H */
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 1f4fde4711b6..eb13693e9d04 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -129,16 +129,6 @@ static struct proto vsock_proto =3D {
 static const struct vsock_transport *transport;
 static DEFINE_MUTEX(vsock_register_mutex);
=20
-/**** EXPORTS ****/
-
-/* Get the ID of the local context.  This is transport dependent. */
-
-int vm_sockets_get_local_cid(void)
-{
-=09return transport->get_local_cid();
-}
-EXPORT_SYMBOL_GPL(vm_sockets_get_local_cid);
-
 /**** UTILS ****/
=20
 /* Each bound VSocket is stored in the bind hash table and each connected
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio=
_transport_common.c
index 828edd88488c..3edc373d2acc 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -168,7 +168,7 @@ static int virtio_transport_send_pkt_info(struct vsock_=
sock *vsk,
 =09struct virtio_vsock_pkt *pkt;
 =09u32 pkt_len =3D info->pkt_len;
=20
-=09src_cid =3D vm_sockets_get_local_cid();
+=09src_cid =3D virtio_transport_get_ops()->transport.get_local_cid();
 =09src_port =3D vsk->local_addr.svm_port;
 =09if (!info->remote_cid) {
 =09=09dst_cid=09=3D vsk->remote_addr.svm_cid;
--=20
2.21.0

