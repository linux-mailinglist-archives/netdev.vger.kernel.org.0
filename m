Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC74713F1E5
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391840AbgAPRY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:24:58 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21906 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391372AbgAPRY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 12:24:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579195495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rJXCaurapNQ3l0l2gppkZEC8B+0gvsSxNTKA5/PN+5k=;
        b=UCN+paU/wQyQ6BTwPFumvC9JIx0Ubm1/ikweKV4QQMKD1tHx8Vk2Mqc52IGh6rXmeRjEYt
        v663eqs+wmRTbXzDuq/3M0xbFsdFs/wOfL00SesM61/4zBhU9YbFfLdKen3jwgLujlovSp
        h14kqg7JFrAAjhEIsmWYfbRNhCmzGIQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-D6q33l1yOH-_YtBkUiFYyg-1; Thu, 16 Jan 2020 12:24:53 -0500
X-MC-Unique: D6q33l1yOH-_YtBkUiFYyg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BD63477;
        Thu, 16 Jan 2020 17:24:52 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-242.ams2.redhat.com [10.36.117.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A6405C1D8;
        Thu, 16 Jan 2020 17:24:48 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jorgen Hansen <jhansen@vmware.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-hyperv@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH net-next 3/3] vhost/vsock: use netns of process that opens the vhost-vsock device
Date:   Thu, 16 Jan 2020 18:24:28 +0100
Message-Id: <20200116172428.311437-4-sgarzare@redhat.com>
In-Reply-To: <20200116172428.311437-1-sgarzare@redhat.com>
References: <20200116172428.311437-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch assigns the network namespace of the process that opened
vhost-vsock device (e.g. VMM) to the packets coming from the guest,
allowing only host sockets in the same network namespace to
communicate with the guest.

This patch also allows having different VMs, running in different
network namespace, with the same CID.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
RFC -> v1
 * used 'vsock_net_eq()' insted of 'net_eq()'
---
 drivers/vhost/vsock.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index f1d39939d5e4..8b0169105559 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -40,6 +40,7 @@ static DEFINE_READ_MOSTLY_HASHTABLE(vhost_vsock_hash, 8=
);
 struct vhost_vsock {
 	struct vhost_dev dev;
 	struct vhost_virtqueue vqs[2];
+	struct net *net;
=20
 	/* Link to global vhost_vsock_hash, writes use vhost_vsock_mutex */
 	struct hlist_node hash;
@@ -61,7 +62,7 @@ static u32 vhost_transport_get_local_cid(void)
 /* Callers that dereference the return value must hold vhost_vsock_mutex=
 or the
  * RCU read lock.
  */
-static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
+static struct vhost_vsock *vhost_vsock_get(u32 guest_cid, struct net *ne=
t)
 {
 	struct vhost_vsock *vsock;
=20
@@ -72,7 +73,7 @@ static struct vhost_vsock *vhost_vsock_get(u32 guest_ci=
d)
 		if (other_cid =3D=3D 0)
 			continue;
=20
-		if (other_cid =3D=3D guest_cid)
+		if (other_cid =3D=3D guest_cid && vsock_net_eq(net, vsock->net))
 			return vsock;
=20
 	}
@@ -245,7 +246,7 @@ vhost_transport_send_pkt(struct virtio_vsock_pkt *pkt=
)
 	rcu_read_lock();
=20
 	/* Find the vhost_vsock according to guest context id  */
-	vsock =3D vhost_vsock_get(le64_to_cpu(pkt->hdr.dst_cid));
+	vsock =3D vhost_vsock_get(le64_to_cpu(pkt->hdr.dst_cid), pkt->net);
 	if (!vsock) {
 		rcu_read_unlock();
 		virtio_transport_free_pkt(pkt);
@@ -277,7 +278,8 @@ vhost_transport_cancel_pkt(struct vsock_sock *vsk)
 	rcu_read_lock();
=20
 	/* Find the vhost_vsock according to guest context id  */
-	vsock =3D vhost_vsock_get(vsk->remote_addr.svm_cid);
+	vsock =3D vhost_vsock_get(vsk->remote_addr.svm_cid,
+				sock_net(sk_vsock(vsk)));
 	if (!vsock)
 		goto out;
=20
@@ -474,7 +476,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_w=
ork *work)
 			continue;
 		}
=20
-		pkt->net =3D vsock_default_net();
+		pkt->net =3D vsock->net;
 		len =3D pkt->len;
=20
 		/* Deliver to monitoring devices all received packets */
@@ -608,7 +610,14 @@ static int vhost_vsock_dev_open(struct inode *inode,=
 struct file *file)
 	vqs =3D kmalloc_array(ARRAY_SIZE(vsock->vqs), sizeof(*vqs), GFP_KERNEL)=
;
 	if (!vqs) {
 		ret =3D -ENOMEM;
-		goto out;
+		goto out_vsock;
+	}
+
+	/* Derive the network namespace from the pid opening the device */
+	vsock->net =3D get_net_ns_by_pid(current->pid);
+	if (IS_ERR(vsock->net)) {
+		ret =3D PTR_ERR(vsock->net);
+		goto out_vqs;
 	}
=20
 	vsock->guest_cid =3D 0; /* no CID assigned yet */
@@ -630,7 +639,9 @@ static int vhost_vsock_dev_open(struct inode *inode, =
struct file *file)
 	vhost_work_init(&vsock->send_pkt_work, vhost_transport_send_pkt_work);
 	return 0;
=20
-out:
+out_vqs:
+	kfree(vqs);
+out_vsock:
 	vhost_vsock_free(vsock);
 	return ret;
 }
@@ -655,7 +666,7 @@ static void vhost_vsock_reset_orphans(struct sock *sk=
)
 	 */
=20
 	/* If the peer is still valid, no need to reset connection */
-	if (vhost_vsock_get(vsk->remote_addr.svm_cid))
+	if (vhost_vsock_get(vsk->remote_addr.svm_cid, sock_net(sk)))
 		return;
=20
 	/* If the close timeout is pending, let it expire.  This avoids races
@@ -703,6 +714,7 @@ static int vhost_vsock_dev_release(struct inode *inod=
e, struct file *file)
 	spin_unlock_bh(&vsock->send_pkt_list_lock);
=20
 	vhost_dev_cleanup(&vsock->dev);
+	put_net(vsock->net);
 	kfree(vsock->dev.vqs);
 	vhost_vsock_free(vsock);
 	return 0;
@@ -729,7 +741,7 @@ static int vhost_vsock_set_cid(struct vhost_vsock *vs=
ock, u64 guest_cid)
=20
 	/* Refuse if CID is already in use */
 	mutex_lock(&vhost_vsock_mutex);
-	other =3D vhost_vsock_get(guest_cid);
+	other =3D vhost_vsock_get(guest_cid, vsock->net);
 	if (other && other !=3D vsock) {
 		mutex_unlock(&vhost_vsock_mutex);
 		return -EADDRINUSE;
--=20
2.24.1

