Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B12410227F
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 12:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbfKSLBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 06:01:43 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41217 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727787AbfKSLBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 06:01:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574161301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pVaD4RUGvcZUV7iJfA8OfX7YKlHYW2XH6nn8UwYs97o=;
        b=MbN6eyWRnjJCYcDiL9eK6ZedunF2LfTuQtMDbilVe0jgVo/Rsn73UXS9PeitK8I+ohhI8x
        u/RMu91IbRF3cXLKeNiv20r79b4JuQNK369N+G4S8+1WBpelQck/1jj69syD1iAN+a3JqH
        4jXxzI/k/UpBtwFabrGgH9BaNCmrZy4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-F_54rTL-O5-awBDfaSUJhw-1; Tue, 19 Nov 2019 06:01:38 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AAB06DC21;
        Tue, 19 Nov 2019 11:01:36 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-41.ams2.redhat.com [10.36.117.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C29A860BE0;
        Tue, 19 Nov 2019 11:01:34 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: [PATCH net-next 4/6] vsock: add vsock_loopback transport
Date:   Tue, 19 Nov 2019 12:01:19 +0100
Message-Id: <20191119110121.14480-5-sgarzare@redhat.com>
In-Reply-To: <20191119110121.14480-1-sgarzare@redhat.com>
References: <20191119110121.14480-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: F_54rTL-O5-awBDfaSUJhw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new vsock_loopback transport to handle local
communication.
This transport is based on the loopback implementation of
virtio_transport, so it uses the virtio_transport_common APIs
to interface with the vsock core.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 MAINTAINERS                    |   1 +
 net/vmw_vsock/Kconfig          |  12 ++
 net/vmw_vsock/Makefile         |   1 +
 net/vmw_vsock/vsock_loopback.c | 217 +++++++++++++++++++++++++++++++++
 4 files changed, 231 insertions(+)
 create mode 100644 net/vmw_vsock/vsock_loopback.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 760049454a23..c2a3dc3113ba 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17239,6 +17239,7 @@ F:=09net/vmw_vsock/diag.c
 F:=09net/vmw_vsock/af_vsock_tap.c
 F:=09net/vmw_vsock/virtio_transport_common.c
 F:=09net/vmw_vsock/virtio_transport.c
+F:=09net/vmw_vsock/vsock_loopback.c
 F:=09drivers/net/vsockmon.c
 F:=09drivers/vhost/vsock.c
 F:=09tools/testing/vsock/
diff --git a/net/vmw_vsock/Kconfig b/net/vmw_vsock/Kconfig
index 8abcb815af2d..56356d2980c8 100644
--- a/net/vmw_vsock/Kconfig
+++ b/net/vmw_vsock/Kconfig
@@ -26,6 +26,18 @@ config VSOCKETS_DIAG
=20
 =09  Enable this module so userspace applications can query open sockets.
=20
+config VSOCKETS_LOOPBACK
+=09tristate "Virtual Sockets loopback transport"
+=09depends on VSOCKETS
+=09default y
+=09select VIRTIO_VSOCKETS_COMMON
+=09help
+=09  This module implements a loopback transport for Virtual Sockets,
+=09  using vmw_vsock_virtio_transport_common.
+
+=09  To compile this driver as a module, choose M here: the module
+=09  will be called vsock_loopback. If unsure, say N.
+
 config VMWARE_VMCI_VSOCKETS
 =09tristate "VMware VMCI transport for Virtual Sockets"
 =09depends on VSOCKETS && VMWARE_VMCI
diff --git a/net/vmw_vsock/Makefile b/net/vmw_vsock/Makefile
index 7c6f9a0b67b0..6a943ec95c4a 100644
--- a/net/vmw_vsock/Makefile
+++ b/net/vmw_vsock/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_VMWARE_VMCI_VSOCKETS) +=3D vmw_vsock_vmci_tran=
sport.o
 obj-$(CONFIG_VIRTIO_VSOCKETS) +=3D vmw_vsock_virtio_transport.o
 obj-$(CONFIG_VIRTIO_VSOCKETS_COMMON) +=3D vmw_vsock_virtio_transport_commo=
n.o
 obj-$(CONFIG_HYPERV_VSOCKETS) +=3D hv_sock.o
+obj-$(CONFIG_VSOCKETS_LOOPBACK) +=3D vsock_loopback.o
=20
 vsock-y +=3D af_vsock.o af_vsock_tap.o vsock_addr.o
=20
diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.=
c
new file mode 100644
index 000000000000..3d1c1a88305f
--- /dev/null
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -0,0 +1,217 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * loopback transport for vsock using virtio_transport_common APIs
+ *
+ * Copyright (C) 2013-2019 Red Hat, Inc.
+ * Author: Asias He <asias@redhat.com>
+ *         Stefan Hajnoczi <stefanha@redhat.com>
+ *         Stefano Garzarella <sgarzare@redhat.com>
+ *
+ */
+#include <linux/spinlock.h>
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/virtio_vsock.h>
+
+static struct workqueue_struct *vsock_loopback_workqueue;
+static struct vsock_loopback *the_vsock_loopback;
+
+struct vsock_loopback {
+=09spinlock_t loopback_list_lock; /* protects loopback_list */
+=09struct list_head loopback_list;
+=09struct work_struct loopback_work;
+};
+
+static u32 vsock_loopback_get_local_cid(void)
+{
+=09return VMADDR_CID_LOCAL;
+}
+
+static int vsock_loopback_send_pkt(struct virtio_vsock_pkt *pkt)
+{
+=09struct vsock_loopback *vsock;
+=09int len =3D pkt->len;
+
+=09rcu_read_lock();
+=09vsock =3D rcu_dereference(the_vsock_loopback);
+=09if (!vsock) {
+=09=09virtio_transport_free_pkt(pkt);
+=09=09len =3D -ENODEV;
+=09=09goto out_rcu;
+=09}
+
+=09spin_lock_bh(&vsock->loopback_list_lock);
+=09list_add_tail(&pkt->list, &vsock->loopback_list);
+=09spin_unlock_bh(&vsock->loopback_list_lock);
+
+=09queue_work(vsock_loopback_workqueue, &vsock->loopback_work);
+
+out_rcu:
+=09rcu_read_unlock();
+=09return len;
+}
+
+static int vsock_loopback_cancel_pkt(struct vsock_sock *vsk)
+{
+=09struct vsock_loopback *vsock;
+=09struct virtio_vsock_pkt *pkt, *n;
+=09int ret;
+=09LIST_HEAD(freeme);
+
+=09rcu_read_lock();
+=09vsock =3D rcu_dereference(the_vsock_loopback);
+=09if (!vsock) {
+=09=09ret =3D -ENODEV;
+=09=09goto out_rcu;
+=09}
+
+=09spin_lock_bh(&vsock->loopback_list_lock);
+=09list_for_each_entry_safe(pkt, n, &vsock->loopback_list, list) {
+=09=09if (pkt->vsk !=3D vsk)
+=09=09=09continue;
+=09=09list_move(&pkt->list, &freeme);
+=09}
+=09spin_unlock_bh(&vsock->loopback_list_lock);
+
+=09list_for_each_entry_safe(pkt, n, &freeme, list) {
+=09=09list_del(&pkt->list);
+=09=09virtio_transport_free_pkt(pkt);
+=09}
+
+=09ret =3D 0;
+
+out_rcu:
+=09rcu_read_unlock();
+=09return ret;
+}
+
+static struct virtio_transport loopback_transport =3D {
+=09.transport =3D {
+=09=09.module                   =3D THIS_MODULE,
+
+=09=09.get_local_cid            =3D vsock_loopback_get_local_cid,
+
+=09=09.init                     =3D virtio_transport_do_socket_init,
+=09=09.destruct                 =3D virtio_transport_destruct,
+=09=09.release                  =3D virtio_transport_release,
+=09=09.connect                  =3D virtio_transport_connect,
+=09=09.shutdown                 =3D virtio_transport_shutdown,
+=09=09.cancel_pkt               =3D vsock_loopback_cancel_pkt,
+
+=09=09.dgram_bind               =3D virtio_transport_dgram_bind,
+=09=09.dgram_dequeue            =3D virtio_transport_dgram_dequeue,
+=09=09.dgram_enqueue            =3D virtio_transport_dgram_enqueue,
+=09=09.dgram_allow              =3D virtio_transport_dgram_allow,
+
+=09=09.stream_dequeue           =3D virtio_transport_stream_dequeue,
+=09=09.stream_enqueue           =3D virtio_transport_stream_enqueue,
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
+=09=09.notify_buffer_size       =3D virtio_transport_notify_buffer_size,
+=09},
+
+=09.send_pkt =3D vsock_loopback_send_pkt,
+};
+
+static void vsock_loopback_work(struct work_struct *work)
+{
+=09struct vsock_loopback *vsock =3D
+=09=09container_of(work, struct vsock_loopback, loopback_work);
+=09LIST_HEAD(pkts);
+
+=09spin_lock_bh(&vsock->loopback_list_lock);
+=09list_splice_init(&vsock->loopback_list, &pkts);
+=09spin_unlock_bh(&vsock->loopback_list_lock);
+
+=09while (!list_empty(&pkts)) {
+=09=09struct virtio_vsock_pkt *pkt;
+
+=09=09pkt =3D list_first_entry(&pkts, struct virtio_vsock_pkt, list);
+=09=09list_del_init(&pkt->list);
+
+=09=09virtio_transport_deliver_tap_pkt(pkt);
+=09=09virtio_transport_recv_pkt(&loopback_transport, pkt);
+=09}
+}
+
+static int __init vsock_loopback_init(void)
+{
+=09struct vsock_loopback *vsock =3D NULL;
+=09int ret;
+
+=09vsock_loopback_workqueue =3D alloc_workqueue("vsock-loopback", 0, 0);
+=09if (!vsock_loopback_workqueue)
+=09=09return -ENOMEM;
+
+=09vsock =3D kzalloc(sizeof(*vsock), GFP_KERNEL);
+=09if (!vsock) {
+=09=09ret =3D -ENOMEM;
+=09=09goto out_wq;
+=09}
+
+=09spin_lock_init(&vsock->loopback_list_lock);
+=09INIT_LIST_HEAD(&vsock->loopback_list);
+=09INIT_WORK(&vsock->loopback_work, vsock_loopback_work);
+
+=09rcu_assign_pointer(the_vsock_loopback, vsock);
+
+=09ret =3D vsock_core_register(&loopback_transport.transport,
+=09=09=09=09  VSOCK_TRANSPORT_F_LOCAL);
+=09if (ret)
+=09=09goto out_free;
+
+=09return 0;
+
+out_free:
+=09rcu_assign_pointer(the_vsock_loopback, NULL);
+=09kfree(vsock);
+out_wq:
+=09destroy_workqueue(vsock_loopback_workqueue);
+=09return ret;
+}
+
+static void __exit vsock_loopback_exit(void)
+{
+=09struct vsock_loopback *vsock =3D the_vsock_loopback;
+=09struct virtio_vsock_pkt *pkt;
+
+=09vsock_core_unregister(&loopback_transport.transport);
+
+=09rcu_assign_pointer(the_vsock_loopback, NULL);
+=09synchronize_rcu();
+
+=09spin_lock_bh(&vsock->loopback_list_lock);
+=09while (!list_empty(&vsock->loopback_list)) {
+=09=09pkt =3D list_first_entry(&vsock->loopback_list,
+=09=09=09=09       struct virtio_vsock_pkt, list);
+=09=09list_del(&pkt->list);
+=09=09virtio_transport_free_pkt(pkt);
+=09}
+=09spin_unlock_bh(&vsock->loopback_list_lock);
+
+=09flush_work(&vsock->loopback_work);
+
+=09kfree(vsock);
+=09destroy_workqueue(vsock_loopback_workqueue);
+}
+
+module_init(vsock_loopback_init);
+module_exit(vsock_loopback_exit);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Stefano Garzarella <sgarzare@redhat.com>");
+MODULE_DESCRIPTION("loopback transport for vsock");
+MODULE_ALIAS_NETPROTO(PF_VSOCK);
--=20
2.21.0

