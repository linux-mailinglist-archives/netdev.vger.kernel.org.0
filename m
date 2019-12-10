Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA8911856D
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 11:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfLJKna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 05:43:30 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47737 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727510AbfLJKn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 05:43:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575974607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oF/SV6ufhESqfSAItJef3FX7tcICe8pVDWWfHQ4TG/0=;
        b=P4vzex2wDDjRdRyqdmmlVxfbqKnvkIbmZ2mIYXwwgWpdhOgyCuPU19RFZrgNPgO2kNOQlY
        /59pYw53eeAZfe/amU/kNv1iB3Let36i0JwEgcxlZl0MdiNdOJPf28sO9bIjZgdXsiNAUQ
        DZZ40I+/9HKKKXuUOe5AJCC4NmC5BXI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-mSeqh8vlMLavF7KqGH6q6w-1; Tue, 10 Dec 2019 05:43:24 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2421DBFB;
        Tue, 10 Dec 2019 10:43:22 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-168.ams2.redhat.com [10.36.117.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE09660568;
        Tue, 10 Dec 2019 10:43:20 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Dexuan Cui <decui@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH net-next v2 4/6] vsock: add vsock_loopback transport
Date:   Tue, 10 Dec 2019 11:43:05 +0100
Message-Id: <20191210104307.89346-5-sgarzare@redhat.com>
In-Reply-To: <20191210104307.89346-1-sgarzare@redhat.com>
References: <20191210104307.89346-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: mSeqh8vlMLavF7KqGH6q6w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
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
v1 -> v2:
- fixed reverse christmas tree ordering of local variables [Dave]
- changed 'the_vsock_loopback' in a global static variable [Stefan]
- removed RCU synchronization [Stefan]
  It is not needed because the af_vsock keeps a reference to the module
  as long as there are open sockets assigned to the transport
- removed 'loopback' prefix in 'struct vsock_loopback' fields
---
 MAINTAINERS                    |   1 +
 net/vmw_vsock/Kconfig          |  12 +++
 net/vmw_vsock/Makefile         |   1 +
 net/vmw_vsock/vsock_loopback.c | 180 +++++++++++++++++++++++++++++++++
 4 files changed, 194 insertions(+)
 create mode 100644 net/vmw_vsock/vsock_loopback.c

diff --git a/MAINTAINERS b/MAINTAINERS
index ce7fd2e7aa1a..a28c77ee6b0d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17480,6 +17480,7 @@ F:=09net/vmw_vsock/diag.c
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
index 000000000000..a45f7ffca8c5
--- /dev/null
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -0,0 +1,180 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* loopback transport for vsock using virtio_transport_common APIs
+ *
+ * Copyright (C) 2013-2019 Red Hat, Inc.
+ * Authors: Asias He <asias@redhat.com>
+ *          Stefan Hajnoczi <stefanha@redhat.com>
+ *          Stefano Garzarella <sgarzare@redhat.com>
+ *
+ */
+#include <linux/spinlock.h>
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/virtio_vsock.h>
+
+struct vsock_loopback {
+=09struct workqueue_struct *workqueue;
+
+=09spinlock_t pkt_list_lock; /* protects pkt_list */
+=09struct list_head pkt_list;
+=09struct work_struct pkt_work;
+};
+
+static struct vsock_loopback the_vsock_loopback;
+
+static u32 vsock_loopback_get_local_cid(void)
+{
+=09return VMADDR_CID_LOCAL;
+}
+
+static int vsock_loopback_send_pkt(struct virtio_vsock_pkt *pkt)
+{
+=09struct vsock_loopback *vsock =3D &the_vsock_loopback;
+=09int len =3D pkt->len;
+
+=09spin_lock_bh(&vsock->pkt_list_lock);
+=09list_add_tail(&pkt->list, &vsock->pkt_list);
+=09spin_unlock_bh(&vsock->pkt_list_lock);
+
+=09queue_work(vsock->workqueue, &vsock->pkt_work);
+
+=09return len;
+}
+
+static int vsock_loopback_cancel_pkt(struct vsock_sock *vsk)
+{
+=09struct vsock_loopback *vsock =3D &the_vsock_loopback;
+=09struct virtio_vsock_pkt *pkt, *n;
+=09LIST_HEAD(freeme);
+
+=09spin_lock_bh(&vsock->pkt_list_lock);
+=09list_for_each_entry_safe(pkt, n, &vsock->pkt_list, list) {
+=09=09if (pkt->vsk !=3D vsk)
+=09=09=09continue;
+=09=09list_move(&pkt->list, &freeme);
+=09}
+=09spin_unlock_bh(&vsock->pkt_list_lock);
+
+=09list_for_each_entry_safe(pkt, n, &freeme, list) {
+=09=09list_del(&pkt->list);
+=09=09virtio_transport_free_pkt(pkt);
+=09}
+
+=09return 0;
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
+=09=09container_of(work, struct vsock_loopback, pkt_work);
+=09LIST_HEAD(pkts);
+
+=09spin_lock_bh(&vsock->pkt_list_lock);
+=09list_splice_init(&vsock->pkt_list, &pkts);
+=09spin_unlock_bh(&vsock->pkt_list_lock);
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
+=09struct vsock_loopback *vsock =3D &the_vsock_loopback;
+=09int ret;
+
+=09vsock->workqueue =3D alloc_workqueue("vsock-loopback", 0, 0);
+=09if (!vsock->workqueue)
+=09=09return -ENOMEM;
+
+=09spin_lock_init(&vsock->pkt_list_lock);
+=09INIT_LIST_HEAD(&vsock->pkt_list);
+=09INIT_WORK(&vsock->pkt_work, vsock_loopback_work);
+
+=09ret =3D vsock_core_register(&loopback_transport.transport,
+=09=09=09=09  VSOCK_TRANSPORT_F_LOCAL);
+=09if (ret)
+=09=09goto out_wq;
+
+=09return 0;
+
+out_wq:
+=09destroy_workqueue(vsock->workqueue);
+=09return ret;
+}
+
+static void __exit vsock_loopback_exit(void)
+{
+=09struct vsock_loopback *vsock =3D &the_vsock_loopback;
+=09struct virtio_vsock_pkt *pkt;
+
+=09vsock_core_unregister(&loopback_transport.transport);
+
+=09flush_work(&vsock->pkt_work);
+
+=09spin_lock_bh(&vsock->pkt_list_lock);
+=09while (!list_empty(&vsock->pkt_list)) {
+=09=09pkt =3D list_first_entry(&vsock->pkt_list,
+=09=09=09=09       struct virtio_vsock_pkt, list);
+=09=09list_del(&pkt->list);
+=09=09virtio_transport_free_pkt(pkt);
+=09}
+=09spin_unlock_bh(&vsock->pkt_list_lock);
+
+=09destroy_workqueue(vsock->workqueue);
+}
+
+module_init(vsock_loopback_init);
+module_exit(vsock_loopback_exit);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Stefano Garzarella <sgarzare@redhat.com>");
+MODULE_DESCRIPTION("loopback transport for vsock");
+MODULE_ALIAS_NETPROTO(PF_VSOCK);
--=20
2.23.0

