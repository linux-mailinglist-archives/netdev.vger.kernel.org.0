Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 242C311EAAD
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 19:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbfLMSsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 13:48:17 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:46395 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728833AbfLMSsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 13:48:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576262894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VSDDjKTdNjIjYY9lNEGudZN4ZxbNPvX2QUzIT/T3/bU=;
        b=H+RNfMxdNvTysBCOEmbPOGorcnkdQWR0n9YwUpYf65m+E0ejY7abgtQ04kHLSiM0UHU2Az
        BWCe4hrJHp904ycXffWHXpDCVGBoLFmMWifQXPHMZYB9ZUI3ZUjE5r6bEQvZko5mrr7fTa
        QDe+Owf7cMPRb/BLYrOL/nrCTXYhrwI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-arex5kL_PveUSWwTT-l1-A-1; Fri, 13 Dec 2019 13:48:12 -0500
X-MC-Unique: arex5kL_PveUSWwTT-l1-A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 657F1107ACC4;
        Fri, 13 Dec 2019 18:48:11 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-123.ams2.redhat.com [10.36.117.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CDC1460474;
        Fri, 13 Dec 2019 18:48:09 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH net 2/2] vsock/virtio: add WARN_ON check on virtio_transport_get_ops()
Date:   Fri, 13 Dec 2019 19:48:01 +0100
Message-Id: <20191213184801.486675-3-sgarzare@redhat.com>
In-Reply-To: <20191213184801.486675-1-sgarzare@redhat.com>
References: <20191213184801.486675-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virtio_transport_get_ops() and virtio_transport_send_pkt_info()
can only be used on connecting/connected sockets, since a socket
assigned to a transport is required.

This patch adds a WARN_ON() on virtio_transport_get_ops() to check
this requirement, a comment and a returned error on
virtio_transport_send_pkt_info(),

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virt=
io_transport_common.c
index f5991006190e..6abec3fc81d1 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -34,6 +34,9 @@ virtio_transport_get_ops(struct vsock_sock *vsk)
 {
 	const struct vsock_transport *t =3D vsock_core_get_transport(vsk);
=20
+	if (WARN_ON(!t))
+		return NULL;
+
 	return container_of(t, struct virtio_transport, transport);
 }
=20
@@ -161,15 +164,25 @@ void virtio_transport_deliver_tap_pkt(struct virtio=
_vsock_pkt *pkt)
 }
 EXPORT_SYMBOL_GPL(virtio_transport_deliver_tap_pkt);
=20
+/* This function can only be used on connecting/connected sockets,
+ * since a socket assigned to a transport is required.
+ *
+ * Do not use on listener sockets!
+ */
 static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 					  struct virtio_vsock_pkt_info *info)
 {
 	u32 src_cid, src_port, dst_cid, dst_port;
+	const struct virtio_transport *t_ops;
 	struct virtio_vsock_sock *vvs;
 	struct virtio_vsock_pkt *pkt;
 	u32 pkt_len =3D info->pkt_len;
=20
-	src_cid =3D virtio_transport_get_ops(vsk)->transport.get_local_cid();
+	t_ops =3D virtio_transport_get_ops(vsk);
+	if (unlikely(!t_ops))
+		return -EFAULT;
+
+	src_cid =3D t_ops->transport.get_local_cid();
 	src_port =3D vsk->local_addr.svm_port;
 	if (!info->remote_cid) {
 		dst_cid	=3D vsk->remote_addr.svm_cid;
@@ -202,7 +215,7 @@ static int virtio_transport_send_pkt_info(struct vsoc=
k_sock *vsk,
=20
 	virtio_transport_inc_tx_pkt(vvs, pkt);
=20
-	return virtio_transport_get_ops(vsk)->send_pkt(pkt);
+	return t_ops->send_pkt(pkt);
 }
=20
 static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
--=20
2.23.0

