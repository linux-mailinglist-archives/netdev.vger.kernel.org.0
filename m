Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7DC4FC33C
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 10:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfKNJ6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 04:58:37 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34386 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727126AbfKNJ6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 04:58:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573725515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OI/oyBpp6dNOFd8cg+OW7lPRnEMqtUl0DG85Xe+Ap/Q=;
        b=aLFokB+oFX9hAK8sGuau9MxvkpxOVCaAhzMbEycoX1M/wHdOj4fI/9Ol5eFNKcnRxaCNYj
        P6TF/mGL+O9KceuZX7EBb2u/Q6CmHN9RYckVqMn0yM7W/7udEDS4GkyhVKi/L8WTuNdA5L
        UfYH5o51oVqABAq8CqwF7FiPPlapkcU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-P4Y3JgYmO-GZfVG04_Anyg-1; Thu, 14 Nov 2019 04:58:34 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9DEE189CB0B;
        Thu, 14 Nov 2019 09:58:32 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-81.ams2.redhat.com [10.36.117.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F065E19757;
        Thu, 14 Nov 2019 09:58:26 +0000 (UTC)
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
Subject: [PATCH net-next v2 06/15] vsock: add 'struct vsock_sock *' param to vsock_core_get_transport()
Date:   Thu, 14 Nov 2019 10:57:41 +0100
Message-Id: <20191114095750.59106-7-sgarzare@redhat.com>
In-Reply-To: <20191114095750.59106-1-sgarzare@redhat.com>
References: <20191114095750.59106-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: P4Y3JgYmO-GZfVG04_Anyg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since now the 'struct vsock_sock' object contains a pointer to
the transport, this patch adds a parameter to the
vsock_core_get_transport() to return the right transport
assigned to the socket.

This patch modifies also the virtio_transport_get_ops(), that
uses the vsock_core_get_transport(), adding the
'struct vsock_sock *' parameter.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/net/af_vsock.h                  | 2 +-
 net/vmw_vsock/af_vsock.c                | 7 ++-----
 net/vmw_vsock/virtio_transport_common.c | 9 +++++----
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index a5e1e134261d..2ca67d048de4 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -166,7 +166,7 @@ static inline int vsock_core_init(const struct vsock_tr=
ansport *t)
 void vsock_core_exit(void);
=20
 /* The transport may downcast this to access transport-specific functions =
*/
-const struct vsock_transport *vsock_core_get_transport(void);
+const struct vsock_transport *vsock_core_get_transport(struct vsock_sock *=
vsk);
=20
 /**** UTILS ****/
=20
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index d813967d7dd5..f057acb0ee29 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1999,12 +1999,9 @@ void vsock_core_exit(void)
 }
 EXPORT_SYMBOL_GPL(vsock_core_exit);
=20
-const struct vsock_transport *vsock_core_get_transport(void)
+const struct vsock_transport *vsock_core_get_transport(struct vsock_sock *=
vsk)
 {
-=09/* vsock_register_mutex not taken since only the transport uses this
-=09 * function and only while registered.
-=09 */
-=09return transport_single;
+=09return vsk->transport;
 }
 EXPORT_SYMBOL_GPL(vsock_core_get_transport);
=20
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio=
_transport_common.c
index e7b5e99842c9..b113619d9576 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -29,9 +29,10 @@
 /* Threshold for detecting small packets to copy */
 #define GOOD_COPY_LEN  128
=20
-static const struct virtio_transport *virtio_transport_get_ops(void)
+static const struct virtio_transport *
+virtio_transport_get_ops(struct vsock_sock *vsk)
 {
-=09const struct vsock_transport *t =3D vsock_core_get_transport();
+=09const struct vsock_transport *t =3D vsock_core_get_transport(vsk);
=20
 =09return container_of(t, struct virtio_transport, transport);
 }
@@ -168,7 +169,7 @@ static int virtio_transport_send_pkt_info(struct vsock_=
sock *vsk,
 =09struct virtio_vsock_pkt *pkt;
 =09u32 pkt_len =3D info->pkt_len;
=20
-=09src_cid =3D virtio_transport_get_ops()->transport.get_local_cid();
+=09src_cid =3D virtio_transport_get_ops(vsk)->transport.get_local_cid();
 =09src_port =3D vsk->local_addr.svm_port;
 =09if (!info->remote_cid) {
 =09=09dst_cid=09=3D vsk->remote_addr.svm_cid;
@@ -201,7 +202,7 @@ static int virtio_transport_send_pkt_info(struct vsock_=
sock *vsk,
=20
 =09virtio_transport_inc_tx_pkt(vvs, pkt);
=20
-=09return virtio_transport_get_ops()->send_pkt(pkt);
+=09return virtio_transport_get_ops(vsk)->send_pkt(pkt);
 }
=20
 static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
--=20
2.21.0

