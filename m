Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCA6E16D3
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 11:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390998AbfJWJ4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 05:56:31 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58258 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390974AbfJWJ4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 05:56:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571824589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PbBHwvRLvLZ0eluEmXVUU71SfEOX89Tc9IF8g918SpU=;
        b=YVLiWCzDxkc7VDiYivyyv9/f9jf+JQ+wKubGNFJCpQMIaX28waVQsnN6txE3itBe6qxqJC
        ZECE5a+GlXfDPfI+Vzqr2ELm/Q7xWT/eJSS3R2dLu7g5QacGSGbozAiU2QHvzIJ1vDG5YO
        ZCfhd9J+eEg6eaMoUCpI6Fh5rpX2Mas=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-33Ff576cMC2trEkMna2QHQ-1; Wed, 23 Oct 2019 05:56:26 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C3A7476;
        Wed, 23 Oct 2019 09:56:24 +0000 (UTC)
Received: from steredhat.redhat.com (unknown [10.36.118.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA17A5C1B2;
        Wed, 23 Oct 2019 09:56:14 +0000 (UTC)
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
Subject: [PATCH net-next 02/14] vsock: remove vm_sockets_get_local_cid()
Date:   Wed, 23 Oct 2019 11:55:42 +0200
Message-Id: <20191023095554.11340-3-sgarzare@redhat.com>
In-Reply-To: <20191023095554.11340-1-sgarzare@redhat.com>
References: <20191023095554.11340-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 33Ff576cMC2trEkMna2QHQ-1
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
index 2ab43b2bba31..2f2582fb7fdd 100644
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
index d02c9b41a768..b1cd16ed66ea 100644
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

