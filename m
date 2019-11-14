Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04076FC341
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 10:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfKNJ6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 04:58:45 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21484 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727137AbfKNJ6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 04:58:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573725512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YSMS/XmzCWXr0XNCpF90ZE7lU8I8qDTggindX3PCo9I=;
        b=OIBC6SRBxrwHF0zMBGo+TaUlztz7xIjdOM7w7NfkFHrmN2iuU6p66HJv3nGRxEyGXngk3s
        tNQdlkLsCBru1m68434qWOvJ02Aa1n5HrwsWUP4G9qsjdDsuOJudLwxjCbL8q5hDYWbElm
        98V1TzvJHwvZJxNOL9RnN9shwBX5dMg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-2VYZpDomNH6QSmht38oA-A-1; Thu, 14 Nov 2019 04:58:29 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A051E189CB01;
        Thu, 14 Nov 2019 09:58:26 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-81.ams2.redhat.com [10.36.117.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED5A019757;
        Thu, 14 Nov 2019 09:58:21 +0000 (UTC)
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
Subject: [PATCH net-next v2 05/15] vsock/virtio: add transport parameter to the virtio_transport_reset_no_sock()
Date:   Thu, 14 Nov 2019 10:57:40 +0100
Message-Id: <20191114095750.59106-6-sgarzare@redhat.com>
In-Reply-To: <20191114095750.59106-1-sgarzare@redhat.com>
References: <20191114095750.59106-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 2VYZpDomNH6QSmht38oA-A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are going to add 'struct vsock_sock *' parameter to
virtio_transport_get_ops().

In some cases, like in the virtio_transport_reset_no_sock(),
we don't have any socket assigned to the packet received,
so we can't use the virtio_transport_get_ops().

In order to allow virtio_transport_reset_no_sock() to use the
'.send_pkt' callback from the 'vhost_transport' or 'virtio_transport',
we add the 'struct virtio_transport *' to it and to its caller:
virtio_transport_recv_pkt().

We moved the 'vhost_transport' and 'virtio_transport' definition,
to pass their address to the virtio_transport_recv_pkt().

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vsock.c                   |  94 +++++++-------
 include/linux/virtio_vsock.h            |   3 +-
 net/vmw_vsock/virtio_transport.c        | 160 ++++++++++++------------
 net/vmw_vsock/virtio_transport_common.c |  12 +-
 4 files changed, 135 insertions(+), 134 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 9f57736fe15e..92ab3852c954 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -384,6 +384,52 @@ static bool vhost_vsock_more_replies(struct vhost_vsoc=
k *vsock)
 =09return val < vq->num;
 }
=20
+static struct virtio_transport vhost_transport =3D {
+=09.transport =3D {
+=09=09.get_local_cid            =3D vhost_transport_get_local_cid,
+
+=09=09.init                     =3D virtio_transport_do_socket_init,
+=09=09.destruct                 =3D virtio_transport_destruct,
+=09=09.release                  =3D virtio_transport_release,
+=09=09.connect                  =3D virtio_transport_connect,
+=09=09.shutdown                 =3D virtio_transport_shutdown,
+=09=09.cancel_pkt               =3D vhost_transport_cancel_pkt,
+
+=09=09.dgram_enqueue            =3D virtio_transport_dgram_enqueue,
+=09=09.dgram_dequeue            =3D virtio_transport_dgram_dequeue,
+=09=09.dgram_bind               =3D virtio_transport_dgram_bind,
+=09=09.dgram_allow              =3D virtio_transport_dgram_allow,
+
+=09=09.stream_enqueue           =3D virtio_transport_stream_enqueue,
+=09=09.stream_dequeue           =3D virtio_transport_stream_dequeue,
+=09=09.stream_has_data          =3D virtio_transport_stream_has_data,
+=09=09.stream_has_space         =3D virtio_transport_stream_has_space,
+=09=09.stream_rcvhiwat          =3D virtio_transport_stream_rcvhiwat,
+=09=09.stream_is_active         =3D virtio_transport_stream_is_active,
+=09=09.stream_allow             =3D virtio_transport_stream_allow,
+
+=09=09.notify_poll_in           =3D virtio_transport_notify_poll_in,
+=09=09.notify_poll_out          =3D virtio_transport_notify_poll_out,
+=09=09.notify_recv_init         =3D virtio_transport_notify_recv_init,
+=09=09.notify_recv_pre_block    =3D virtio_transport_notify_recv_pre_block=
,
+=09=09.notify_recv_pre_dequeue  =3D virtio_transport_notify_recv_pre_deque=
ue,
+=09=09.notify_recv_post_dequeue =3D virtio_transport_notify_recv_post_dequ=
eue,
+=09=09.notify_send_init         =3D virtio_transport_notify_send_init,
+=09=09.notify_send_pre_block    =3D virtio_transport_notify_send_pre_block=
,
+=09=09.notify_send_pre_enqueue  =3D virtio_transport_notify_send_pre_enque=
ue,
+=09=09.notify_send_post_enqueue =3D virtio_transport_notify_send_post_enqu=
eue,
+
+=09=09.set_buffer_size          =3D virtio_transport_set_buffer_size,
+=09=09.set_min_buffer_size      =3D virtio_transport_set_min_buffer_size,
+=09=09.set_max_buffer_size      =3D virtio_transport_set_max_buffer_size,
+=09=09.get_buffer_size          =3D virtio_transport_get_buffer_size,
+=09=09.get_min_buffer_size      =3D virtio_transport_get_min_buffer_size,
+=09=09.get_max_buffer_size      =3D virtio_transport_get_max_buffer_size,
+=09},
+
+=09.send_pkt =3D vhost_transport_send_pkt,
+};
+
 static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 {
 =09struct vhost_virtqueue *vq =3D container_of(work, struct vhost_virtqueu=
e,
@@ -438,7 +484,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_wor=
k *work)
=20
 =09=09/* Only accept correctly addressed packets */
 =09=09if (le64_to_cpu(pkt->hdr.src_cid) =3D=3D vsock->guest_cid)
-=09=09=09virtio_transport_recv_pkt(pkt);
+=09=09=09virtio_transport_recv_pkt(&vhost_transport, pkt);
 =09=09else
 =09=09=09virtio_transport_free_pkt(pkt);
=20
@@ -786,52 +832,6 @@ static struct miscdevice vhost_vsock_misc =3D {
 =09.fops =3D &vhost_vsock_fops,
 };
=20
-static struct virtio_transport vhost_transport =3D {
-=09.transport =3D {
-=09=09.get_local_cid            =3D vhost_transport_get_local_cid,
-
-=09=09.init                     =3D virtio_transport_do_socket_init,
-=09=09.destruct                 =3D virtio_transport_destruct,
-=09=09.release                  =3D virtio_transport_release,
-=09=09.connect                  =3D virtio_transport_connect,
-=09=09.shutdown                 =3D virtio_transport_shutdown,
-=09=09.cancel_pkt               =3D vhost_transport_cancel_pkt,
-
-=09=09.dgram_enqueue            =3D virtio_transport_dgram_enqueue,
-=09=09.dgram_dequeue            =3D virtio_transport_dgram_dequeue,
-=09=09.dgram_bind               =3D virtio_transport_dgram_bind,
-=09=09.dgram_allow              =3D virtio_transport_dgram_allow,
-
-=09=09.stream_enqueue           =3D virtio_transport_stream_enqueue,
-=09=09.stream_dequeue           =3D virtio_transport_stream_dequeue,
-=09=09.stream_has_data          =3D virtio_transport_stream_has_data,
-=09=09.stream_has_space         =3D virtio_transport_stream_has_space,
-=09=09.stream_rcvhiwat          =3D virtio_transport_stream_rcvhiwat,
-=09=09.stream_is_active         =3D virtio_transport_stream_is_active,
-=09=09.stream_allow             =3D virtio_transport_stream_allow,
-
-=09=09.notify_poll_in           =3D virtio_transport_notify_poll_in,
-=09=09.notify_poll_out          =3D virtio_transport_notify_poll_out,
-=09=09.notify_recv_init         =3D virtio_transport_notify_recv_init,
-=09=09.notify_recv_pre_block    =3D virtio_transport_notify_recv_pre_block=
,
-=09=09.notify_recv_pre_dequeue  =3D virtio_transport_notify_recv_pre_deque=
ue,
-=09=09.notify_recv_post_dequeue =3D virtio_transport_notify_recv_post_dequ=
eue,
-=09=09.notify_send_init         =3D virtio_transport_notify_send_init,
-=09=09.notify_send_pre_block    =3D virtio_transport_notify_send_pre_block=
,
-=09=09.notify_send_pre_enqueue  =3D virtio_transport_notify_send_pre_enque=
ue,
-=09=09.notify_send_post_enqueue =3D virtio_transport_notify_send_post_enqu=
eue,
-
-=09=09.set_buffer_size          =3D virtio_transport_set_buffer_size,
-=09=09.set_min_buffer_size      =3D virtio_transport_set_min_buffer_size,
-=09=09.set_max_buffer_size      =3D virtio_transport_set_max_buffer_size,
-=09=09.get_buffer_size          =3D virtio_transport_get_buffer_size,
-=09=09.get_min_buffer_size      =3D virtio_transport_get_min_buffer_size,
-=09=09.get_max_buffer_size      =3D virtio_transport_get_max_buffer_size,
-=09},
-
-=09.send_pkt =3D vhost_transport_send_pkt,
-};
-
 static int __init vhost_vsock_init(void)
 {
 =09int ret;
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 07875ccc7bb5..b139f76060a6 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -150,7 +150,8 @@ virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
=20
 void virtio_transport_destruct(struct vsock_sock *vsk);
=20
-void virtio_transport_recv_pkt(struct virtio_vsock_pkt *pkt);
+void virtio_transport_recv_pkt(struct virtio_transport *t,
+=09=09=09       struct virtio_vsock_pkt *pkt);
 void virtio_transport_free_pkt(struct virtio_vsock_pkt *pkt);
 void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct vir=
tio_vsock_pkt *pkt);
 u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 wanted)=
;
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transp=
ort.c
index 082a30936690..3756f0857946 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -86,33 +86,6 @@ static u32 virtio_transport_get_local_cid(void)
 =09return ret;
 }
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
-=09=09virtio_transport_recv_pkt(pkt);
-=09}
-out:
-=09mutex_unlock(&vsock->rx_lock);
-}
-
 static int virtio_transport_send_pkt_loopback(struct virtio_vsock *vsock,
 =09=09=09=09=09      struct virtio_vsock_pkt *pkt)
 {
@@ -370,59 +343,6 @@ static bool virtio_transport_more_replies(struct virti=
o_vsock *vsock)
 =09return val < virtqueue_get_vring_size(vq);
 }
=20
-static void virtio_transport_rx_work(struct work_struct *work)
-{
-=09struct virtio_vsock *vsock =3D
-=09=09container_of(work, struct virtio_vsock, rx_work);
-=09struct virtqueue *vq;
-
-=09vq =3D vsock->vqs[VSOCK_VQ_RX];
-
-=09mutex_lock(&vsock->rx_lock);
-
-=09if (!vsock->rx_run)
-=09=09goto out;
-
-=09do {
-=09=09virtqueue_disable_cb(vq);
-=09=09for (;;) {
-=09=09=09struct virtio_vsock_pkt *pkt;
-=09=09=09unsigned int len;
-
-=09=09=09if (!virtio_transport_more_replies(vsock)) {
-=09=09=09=09/* Stop rx until the device processes already
-=09=09=09=09 * pending replies.  Leave rx virtqueue
-=09=09=09=09 * callbacks disabled.
-=09=09=09=09 */
-=09=09=09=09goto out;
-=09=09=09}
-
-=09=09=09pkt =3D virtqueue_get_buf(vq, &len);
-=09=09=09if (!pkt) {
-=09=09=09=09break;
-=09=09=09}
-
-=09=09=09vsock->rx_buf_nr--;
-
-=09=09=09/* Drop short/long packets */
-=09=09=09if (unlikely(len < sizeof(pkt->hdr) ||
-=09=09=09=09     len > sizeof(pkt->hdr) + pkt->len)) {
-=09=09=09=09virtio_transport_free_pkt(pkt);
-=09=09=09=09continue;
-=09=09=09}
-
-=09=09=09pkt->len =3D len - sizeof(pkt->hdr);
-=09=09=09virtio_transport_deliver_tap_pkt(pkt);
-=09=09=09virtio_transport_recv_pkt(pkt);
-=09=09}
-=09} while (!virtqueue_enable_cb(vq));
-
-out:
-=09if (vsock->rx_buf_nr < vsock->rx_buf_max_nr / 2)
-=09=09virtio_vsock_rx_fill(vsock);
-=09mutex_unlock(&vsock->rx_lock);
-}
-
 /* event_lock must be held */
 static int virtio_vsock_event_fill_one(struct virtio_vsock *vsock,
 =09=09=09=09       struct virtio_vsock_event *event)
@@ -586,6 +506,86 @@ static struct virtio_transport virtio_transport =3D {
 =09.send_pkt =3D virtio_transport_send_pkt,
 };
=20
+static void virtio_transport_loopback_work(struct work_struct *work)
+{
+=09struct virtio_vsock *vsock =3D
+=09=09container_of(work, struct virtio_vsock, loopback_work);
+=09LIST_HEAD(pkts);
+
+=09spin_lock_bh(&vsock->loopback_list_lock);
+=09list_splice_init(&vsock->loopback_list, &pkts);
+=09spin_unlock_bh(&vsock->loopback_list_lock);
+
+=09mutex_lock(&vsock->rx_lock);
+
+=09if (!vsock->rx_run)
+=09=09goto out;
+
+=09while (!list_empty(&pkts)) {
+=09=09struct virtio_vsock_pkt *pkt;
+
+=09=09pkt =3D list_first_entry(&pkts, struct virtio_vsock_pkt, list);
+=09=09list_del_init(&pkt->list);
+
+=09=09virtio_transport_recv_pkt(&virtio_transport, pkt);
+=09}
+out:
+=09mutex_unlock(&vsock->rx_lock);
+}
+
+static void virtio_transport_rx_work(struct work_struct *work)
+{
+=09struct virtio_vsock *vsock =3D
+=09=09container_of(work, struct virtio_vsock, rx_work);
+=09struct virtqueue *vq;
+
+=09vq =3D vsock->vqs[VSOCK_VQ_RX];
+
+=09mutex_lock(&vsock->rx_lock);
+
+=09if (!vsock->rx_run)
+=09=09goto out;
+
+=09do {
+=09=09virtqueue_disable_cb(vq);
+=09=09for (;;) {
+=09=09=09struct virtio_vsock_pkt *pkt;
+=09=09=09unsigned int len;
+
+=09=09=09if (!virtio_transport_more_replies(vsock)) {
+=09=09=09=09/* Stop rx until the device processes already
+=09=09=09=09 * pending replies.  Leave rx virtqueue
+=09=09=09=09 * callbacks disabled.
+=09=09=09=09 */
+=09=09=09=09goto out;
+=09=09=09}
+
+=09=09=09pkt =3D virtqueue_get_buf(vq, &len);
+=09=09=09if (!pkt) {
+=09=09=09=09break;
+=09=09=09}
+
+=09=09=09vsock->rx_buf_nr--;
+
+=09=09=09/* Drop short/long packets */
+=09=09=09if (unlikely(len < sizeof(pkt->hdr) ||
+=09=09=09=09     len > sizeof(pkt->hdr) + pkt->len)) {
+=09=09=09=09virtio_transport_free_pkt(pkt);
+=09=09=09=09continue;
+=09=09=09}
+
+=09=09=09pkt->len =3D len - sizeof(pkt->hdr);
+=09=09=09virtio_transport_deliver_tap_pkt(pkt);
+=09=09=09virtio_transport_recv_pkt(&virtio_transport, pkt);
+=09=09}
+=09} while (!virtqueue_enable_cb(vq));
+
+out:
+=09if (vsock->rx_buf_nr < vsock->rx_buf_max_nr / 2)
+=09=09virtio_vsock_rx_fill(vsock);
+=09mutex_unlock(&vsock->rx_lock);
+}
+
 static int virtio_vsock_probe(struct virtio_device *vdev)
 {
 =09vq_callback_t *callbacks[] =3D {
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio=
_transport_common.c
index 3edc373d2acc..e7b5e99842c9 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -745,9 +745,9 @@ static int virtio_transport_reset(struct vsock_sock *vs=
k,
 /* Normally packets are associated with a socket.  There may be no socket =
if an
  * attempt was made to connect to a socket that does not exist.
  */
-static int virtio_transport_reset_no_sock(struct virtio_vsock_pkt *pkt)
+static int virtio_transport_reset_no_sock(const struct virtio_transport *t=
,
+=09=09=09=09=09  struct virtio_vsock_pkt *pkt)
 {
-=09const struct virtio_transport *t;
 =09struct virtio_vsock_pkt *reply;
 =09struct virtio_vsock_pkt_info info =3D {
 =09=09.op =3D VIRTIO_VSOCK_OP_RST,
@@ -767,7 +767,6 @@ static int virtio_transport_reset_no_sock(struct virtio=
_vsock_pkt *pkt)
 =09if (!reply)
 =09=09return -ENOMEM;
=20
-=09t =3D virtio_transport_get_ops();
 =09if (!t) {
 =09=09virtio_transport_free_pkt(reply);
 =09=09return -ENOTCONN;
@@ -1109,7 +1108,8 @@ static bool virtio_transport_space_update(struct sock=
 *sk,
 /* We are under the virtio-vsock's vsock->rx_lock or vhost-vsock's vq->mut=
ex
  * lock.
  */
-void virtio_transport_recv_pkt(struct virtio_vsock_pkt *pkt)
+void virtio_transport_recv_pkt(struct virtio_transport *t,
+=09=09=09       struct virtio_vsock_pkt *pkt)
 {
 =09struct sockaddr_vm src, dst;
 =09struct vsock_sock *vsk;
@@ -1131,7 +1131,7 @@ void virtio_transport_recv_pkt(struct virtio_vsock_pk=
t *pkt)
 =09=09=09=09=09le32_to_cpu(pkt->hdr.fwd_cnt));
=20
 =09if (le16_to_cpu(pkt->hdr.type) !=3D VIRTIO_VSOCK_TYPE_STREAM) {
-=09=09(void)virtio_transport_reset_no_sock(pkt);
+=09=09(void)virtio_transport_reset_no_sock(t, pkt);
 =09=09goto free_pkt;
 =09}
=20
@@ -1142,7 +1142,7 @@ void virtio_transport_recv_pkt(struct virtio_vsock_pk=
t *pkt)
 =09if (!sk) {
 =09=09sk =3D vsock_find_bound_socket(&dst);
 =09=09if (!sk) {
-=09=09=09(void)virtio_transport_reset_no_sock(pkt);
+=09=09=09(void)virtio_transport_reset_no_sock(t, pkt);
 =09=09=09goto free_pkt;
 =09=09}
 =09}
--=20
2.21.0

