Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC67911856E
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 11:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbfLJKne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 05:43:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38276 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727540AbfLJKnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 05:43:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575974611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8fTadIIM/EGcJyroW82UCutvScqyTCaxJaPZkU5T0yE=;
        b=d7m+tdvp7ak/qIxsyc1tQlkY+AVi2J8XX3qAqDS5UcWo3sCYokuWkC2VtHAzVGkuFmxb/8
        hVe62YI54fzkWC8YRvLU5xW6yN4rWDA+ZPhYqIDLOWdUUvUBsKQTqar005KxCTmS9BUKFD
        QHkytaK4UiajC6kOsO0RI4w3sGVc7J4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-VouMmq0dMj-tIB48CAjylw-1; Tue, 10 Dec 2019 05:43:28 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EA92104ED28;
        Tue, 10 Dec 2019 10:43:27 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-168.ams2.redhat.com [10.36.117.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7246D605AF;
        Tue, 10 Dec 2019 10:43:25 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Dexuan Cui <decui@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH net-next v2 6/6] vsock/virtio: remove loopback handling
Date:   Tue, 10 Dec 2019 11:43:07 +0100
Message-Id: <20191210104307.89346-7-sgarzare@redhat.com>
In-Reply-To: <20191210104307.89346-1-sgarzare@redhat.com>
References: <20191210104307.89346-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: VouMmq0dMj-tIB48CAjylw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can remove the loopback handling from virtio_transport,
because now the vsock core is able to handle local communication
using the new vsock_loopback device.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 61 ++------------------------------
 1 file changed, 2 insertions(+), 59 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transp=
ort.c
index 1458c5c8b64d..dfbaf6bd8b1c 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -44,10 +44,6 @@ struct virtio_vsock {
 =09spinlock_t send_pkt_list_lock;
 =09struct list_head send_pkt_list;
=20
-=09struct work_struct loopback_work;
-=09spinlock_t loopback_list_lock; /* protects loopback_list */
-=09struct list_head loopback_list;
-
 =09atomic_t queued_replies;
=20
 =09/* The following fields are protected by rx_lock.  vqs[VSOCK_VQ_RX]
@@ -86,20 +82,6 @@ static u32 virtio_transport_get_local_cid(void)
 =09return ret;
 }
=20
-static int virtio_transport_send_pkt_loopback(struct virtio_vsock *vsock,
-=09=09=09=09=09      struct virtio_vsock_pkt *pkt)
-{
-=09int len =3D pkt->len;
-
-=09spin_lock_bh(&vsock->loopback_list_lock);
-=09list_add_tail(&pkt->list, &vsock->loopback_list);
-=09spin_unlock_bh(&vsock->loopback_list_lock);
-
-=09queue_work(virtio_vsock_workqueue, &vsock->loopback_work);
-
-=09return len;
-}
-
 static void
 virtio_transport_send_pkt_work(struct work_struct *work)
 {
@@ -194,7 +176,8 @@ virtio_transport_send_pkt(struct virtio_vsock_pkt *pkt)
 =09}
=20
 =09if (le64_to_cpu(pkt->hdr.dst_cid) =3D=3D vsock->guest_cid) {
-=09=09len =3D virtio_transport_send_pkt_loopback(vsock, pkt);
+=09=09virtio_transport_free_pkt(pkt);
+=09=09len =3D -ENODEV;
 =09=09goto out_rcu;
 =09}
=20
@@ -502,33 +485,6 @@ static struct virtio_transport virtio_transport =3D {
 =09.send_pkt =3D virtio_transport_send_pkt,
 };
=20
-static void virtio_transport_loopback_work(struct work_struct *work)
-{
-=09struct virtio_vsock *vsock =3D
-=09=09container_of(work, struct virtio_vsock, loopback_work);
-=09LIST_HEAD(pkts);
-
-=09spin_lock_bh(&vsock->loopback_list_lock);
-=09list_splice_init(&vsock->loopback_list, &pkts);
-=09spin_unlock_bh(&vsock->loopback_list_lock);
-
-=09mutex_lock(&vsock->rx_lock);
-
-=09if (!vsock->rx_run)
-=09=09goto out;
-
-=09while (!list_empty(&pkts)) {
-=09=09struct virtio_vsock_pkt *pkt;
-
-=09=09pkt =3D list_first_entry(&pkts, struct virtio_vsock_pkt, list);
-=09=09list_del_init(&pkt->list);
-
-=09=09virtio_transport_recv_pkt(&virtio_transport, pkt);
-=09}
-out:
-=09mutex_unlock(&vsock->rx_lock);
-}
-
 static void virtio_transport_rx_work(struct work_struct *work)
 {
 =09struct virtio_vsock *vsock =3D
@@ -633,13 +589,10 @@ static int virtio_vsock_probe(struct virtio_device *v=
dev)
 =09mutex_init(&vsock->event_lock);
 =09spin_lock_init(&vsock->send_pkt_list_lock);
 =09INIT_LIST_HEAD(&vsock->send_pkt_list);
-=09spin_lock_init(&vsock->loopback_list_lock);
-=09INIT_LIST_HEAD(&vsock->loopback_list);
 =09INIT_WORK(&vsock->rx_work, virtio_transport_rx_work);
 =09INIT_WORK(&vsock->tx_work, virtio_transport_tx_work);
 =09INIT_WORK(&vsock->event_work, virtio_transport_event_work);
 =09INIT_WORK(&vsock->send_pkt_work, virtio_transport_send_pkt_work);
-=09INIT_WORK(&vsock->loopback_work, virtio_transport_loopback_work);
=20
 =09mutex_lock(&vsock->tx_lock);
 =09vsock->tx_run =3D true;
@@ -720,22 +673,12 @@ static void virtio_vsock_remove(struct virtio_device =
*vdev)
 =09}
 =09spin_unlock_bh(&vsock->send_pkt_list_lock);
=20
-=09spin_lock_bh(&vsock->loopback_list_lock);
-=09while (!list_empty(&vsock->loopback_list)) {
-=09=09pkt =3D list_first_entry(&vsock->loopback_list,
-=09=09=09=09       struct virtio_vsock_pkt, list);
-=09=09list_del(&pkt->list);
-=09=09virtio_transport_free_pkt(pkt);
-=09}
-=09spin_unlock_bh(&vsock->loopback_list_lock);
-
 =09/* Delete virtqueues and flush outstanding callbacks if any */
 =09vdev->config->del_vqs(vdev);
=20
 =09/* Other works can be queued before 'config->del_vqs()', so we flush
 =09 * all works before to free the vsock object to avoid use after free.
 =09 */
-=09flush_work(&vsock->loopback_work);
 =09flush_work(&vsock->rx_work);
 =09flush_work(&vsock->tx_work);
 =09flush_work(&vsock->event_work);
--=20
2.23.0

