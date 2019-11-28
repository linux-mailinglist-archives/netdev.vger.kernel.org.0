Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5846610CD9F
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 18:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfK1RPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 12:15:43 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52084 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727028AbfK1RPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 12:15:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574961339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i43hEG8t6TDOi2Mge5CT+4KErjH/1IrCl/OdUkMsEKc=;
        b=AfHoQJ3oweaELN1IzMvpJ9xyE47T7/jYKuDlBX526G3Q2emnjUmjJSKntNk0OIJa2FQExw
        BVYY7QWkkj5z+51kYpeI2tDwmlk+0Q2NgnJuQ3/2tHM1QuDvwQjfZcrK7XUsiYQ6kRWVDm
        PpNbamGKGIXF5IDWLI4mrWl5h984kxo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-V9_Me1OjMuqt2wlDS8MvuQ-1; Thu, 28 Nov 2019 12:15:38 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A2E380183C;
        Thu, 28 Nov 2019 17:15:36 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-168.ams2.redhat.com [10.36.117.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35E0E600C8;
        Thu, 28 Nov 2019 17:15:34 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: [RFC PATCH 3/3] vhost/vsock: use netns of process that opens the vhost-vsock device
Date:   Thu, 28 Nov 2019 18:15:19 +0100
Message-Id: <20191128171519.203979-4-sgarzare@redhat.com>
In-Reply-To: <20191128171519.203979-1-sgarzare@redhat.com>
References: <20191128171519.203979-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: V9_Me1OjMuqt2wlDS8MvuQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch assigns the network namespace of the process that opened
vhost-vsock device (e.g. VMM) to the packets coming from the guest,
allowing only host sockets in the same network namespace to
communicate with the guest.

This patch also allows to have different VMs, running in different
network namespace, with the same CID.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vsock.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 31b0f3608752..e162b3604302 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -40,6 +40,7 @@ static DEFINE_READ_MOSTLY_HASHTABLE(vhost_vsock_hash, 8);
 struct vhost_vsock {
 =09struct vhost_dev dev;
 =09struct vhost_virtqueue vqs[2];
+=09struct net *net;
=20
 =09/* Link to global vhost_vsock_hash, writes use vhost_vsock_mutex */
 =09struct hlist_node hash;
@@ -61,7 +62,7 @@ static u32 vhost_transport_get_local_cid(void)
 /* Callers that dereference the return value must hold vhost_vsock_mutex o=
r the
  * RCU read lock.
  */
-static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
+static struct vhost_vsock *vhost_vsock_get(u32 guest_cid, struct net *net)
 {
 =09struct vhost_vsock *vsock;
=20
@@ -72,7 +73,7 @@ static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
 =09=09if (other_cid =3D=3D 0)
 =09=09=09continue;
=20
-=09=09if (other_cid =3D=3D guest_cid)
+=09=09if (other_cid =3D=3D guest_cid && net_eq(net, vsock->net))
 =09=09=09return vsock;
=20
 =09}
@@ -245,7 +246,7 @@ vhost_transport_send_pkt(struct virtio_vsock_pkt *pkt)
 =09rcu_read_lock();
=20
 =09/* Find the vhost_vsock according to guest context id  */
-=09vsock =3D vhost_vsock_get(le64_to_cpu(pkt->hdr.dst_cid));
+=09vsock =3D vhost_vsock_get(le64_to_cpu(pkt->hdr.dst_cid), pkt->net);
 =09if (!vsock) {
 =09=09rcu_read_unlock();
 =09=09virtio_transport_free_pkt(pkt);
@@ -277,7 +278,8 @@ vhost_transport_cancel_pkt(struct vsock_sock *vsk)
 =09rcu_read_lock();
=20
 =09/* Find the vhost_vsock according to guest context id  */
-=09vsock =3D vhost_vsock_get(vsk->remote_addr.svm_cid);
+=09vsock =3D vhost_vsock_get(vsk->remote_addr.svm_cid,
+=09=09=09=09sock_net(sk_vsock(vsk)));
 =09if (!vsock)
 =09=09goto out;
=20
@@ -474,7 +476,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_wor=
k *work)
 =09=09=09continue;
 =09=09}
=20
-=09=09pkt->net =3D vsock_default_net();
+=09=09pkt->net =3D vsock->net;
 =09=09len =3D pkt->len;
=20
 =09=09/* Deliver to monitoring devices all received packets */
@@ -606,7 +608,14 @@ static int vhost_vsock_dev_open(struct inode *inode, s=
truct file *file)
 =09vqs =3D kmalloc_array(ARRAY_SIZE(vsock->vqs), sizeof(*vqs), GFP_KERNEL)=
;
 =09if (!vqs) {
 =09=09ret =3D -ENOMEM;
-=09=09goto out;
+=09=09goto out_vsock;
+=09}
+
+=09/* Derive the network namespace from the pid opening the device */
+=09vsock->net =3D get_net_ns_by_pid(current->pid);
+=09if (IS_ERR(vsock->net)) {
+=09=09ret =3D PTR_ERR(vsock->net);
+=09=09goto out_vqs;
 =09}
=20
 =09vsock->guest_cid =3D 0; /* no CID assigned yet */
@@ -628,7 +637,9 @@ static int vhost_vsock_dev_open(struct inode *inode, st=
ruct file *file)
 =09vhost_work_init(&vsock->send_pkt_work, vhost_transport_send_pkt_work);
 =09return 0;
=20
-out:
+out_vqs:
+=09kfree(vqs);
+out_vsock:
 =09vhost_vsock_free(vsock);
 =09return ret;
 }
@@ -653,7 +664,7 @@ static void vhost_vsock_reset_orphans(struct sock *sk)
 =09 */
=20
 =09/* If the peer is still valid, no need to reset connection */
-=09if (vhost_vsock_get(vsk->remote_addr.svm_cid))
+=09if (vhost_vsock_get(vsk->remote_addr.svm_cid, sock_net(sk)))
 =09=09return;
=20
 =09/* If the close timeout is pending, let it expire.  This avoids races
@@ -701,6 +712,7 @@ static int vhost_vsock_dev_release(struct inode *inode,=
 struct file *file)
 =09spin_unlock_bh(&vsock->send_pkt_list_lock);
=20
 =09vhost_dev_cleanup(&vsock->dev);
+=09put_net(vsock->net);
 =09kfree(vsock->dev.vqs);
 =09vhost_vsock_free(vsock);
 =09return 0;
@@ -727,7 +739,7 @@ static int vhost_vsock_set_cid(struct vhost_vsock *vsoc=
k, u64 guest_cid)
=20
 =09/* Refuse if CID is already in use */
 =09mutex_lock(&vhost_vsock_mutex);
-=09other =3D vhost_vsock_get(guest_cid);
+=09other =3D vhost_vsock_get(guest_cid, vsock->net);
 =09if (other && other !=3D vsock) {
 =09=09mutex_unlock(&vhost_vsock_mutex);
 =09=09return -EADDRINUSE;
--=20
2.23.0

