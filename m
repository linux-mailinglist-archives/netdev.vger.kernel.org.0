Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C02911EAA9
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 19:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbfLMSsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 13:48:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23971 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728455AbfLMSsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 13:48:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576262892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5A2LeRnUqA/oVUAeoB9Y1zyaCpFbrJsfRAN46NsJ6og=;
        b=BWSrxPB3sx/Vle2dnpPMbnN5XXhVCMHDe60fLhX85MxyCMsdeM1xYd9Ef2VGiV+x1fRM4o
        OWfElaiytoGnnhQlDZ4nnpsfbnaU8QdJFbxfZ39B6qifmHD0q3y3M+ZOyFm+F+Q34EESAv
        u8q9ZJ2DBLA2Lx84qulFbylbcIK09Vs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-znf3gbb5PCy5O_eL0tSkOA-1; Fri, 13 Dec 2019 13:48:10 -0500
X-MC-Unique: znf3gbb5PCy5O_eL0tSkOA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F649477;
        Fri, 13 Dec 2019 18:48:09 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-123.ams2.redhat.com [10.36.117.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C21DD60474;
        Fri, 13 Dec 2019 18:48:07 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH net 1/2] vsock/virtio: fix null-pointer dereference in virtio_transport_recv_listen()
Date:   Fri, 13 Dec 2019 19:48:00 +0100
Message-Id: <20191213184801.486675-2-sgarzare@redhat.com>
In-Reply-To: <20191213184801.486675-1-sgarzare@redhat.com>
References: <20191213184801.486675-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With multi-transport support, listener sockets are not bound to any
transport. So, calling virtio_transport_reset(), when an error
occurs, on a listener socket produces the following null-pointer
dereference:

  BUG: kernel NULL pointer dereference, address: 00000000000000e8
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] SMP PTI
  CPU: 0 PID: 20 Comm: kworker/0:1 Not tainted 5.5.0-rc1-ste-00003-gb4be2=
1f316ac-dirty #56
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS ?-20190727_073=
836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
  Workqueue: virtio_vsock virtio_transport_rx_work [vmw_vsock_virtio_tran=
sport]
  RIP: 0010:virtio_transport_send_pkt_info+0x20/0x130 [vmw_vsock_virtio_t=
ransport_common]
  Code: 1f 84 00 00 00 00 00 0f 1f 00 55 48 89 e5 41 57 41 56 41 55 49 89=
 f5 41 54 49 89 fc 53 48 83 ec 10 44 8b 76 20 e8 c0 ba fe ff <48> 8b 80 e=
8 00 00 00 e8 64 e3 7d c1 45 8b 45 00 41 8b 8c 24 d4 02
  RSP: 0018:ffffc900000b7d08 EFLAGS: 00010282
  RAX: 0000000000000000 RBX: ffff88807bf12728 RCX: 0000000000000000
  RDX: ffff88807bf12700 RSI: ffffc900000b7d50 RDI: ffff888035c84000
  RBP: ffffc900000b7d40 R08: ffff888035c84000 R09: ffffc900000b7d08
  R10: ffff8880781de800 R11: 0000000000000018 R12: ffff888035c84000
  R13: ffffc900000b7d50 R14: 0000000000000000 R15: ffff88807bf12724
  FS:  0000000000000000(0000) GS:ffff88807dc00000(0000) knlGS:00000000000=
00000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00000000000000e8 CR3: 00000000790f4004 CR4: 0000000000160ef0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   virtio_transport_reset+0x59/0x70 [vmw_vsock_virtio_transport_common]
   virtio_transport_recv_pkt+0x5bb/0xe50 [vmw_vsock_virtio_transport_comm=
on]
   ? detach_buf_split+0xf1/0x130
   virtio_transport_rx_work+0xba/0x130 [vmw_vsock_virtio_transport]
   process_one_work+0x1c0/0x300
   worker_thread+0x45/0x3c0
   kthread+0xfc/0x130
   ? current_work+0x40/0x40
   ? kthread_park+0x90/0x90
   ret_from_fork+0x35/0x40
  Modules linked in: sunrpc kvm_intel kvm vmw_vsock_virtio_transport vmw_=
vsock_virtio_transport_common irqbypass vsock virtio_rng rng_core
  CR2: 00000000000000e8
  ---[ end trace e75400e2ea2fa824 ]---

This happens because virtio_transport_reset() calls
virtio_transport_send_pkt_info() that can be used only on
connecting/connected sockets.

This patch fixes the issue, using virtio_transport_reset_no_sock()
instead of virtio_transport_reset() when we are handling a listener
socket.

Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virt=
io_transport_common.c
index e5ea29c6bca7..f5991006190e 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1021,18 +1021,18 @@ virtio_transport_recv_listen(struct sock *sk, str=
uct virtio_vsock_pkt *pkt,
 	int ret;
=20
 	if (le16_to_cpu(pkt->hdr.op) !=3D VIRTIO_VSOCK_OP_REQUEST) {
-		virtio_transport_reset(vsk, pkt);
+		virtio_transport_reset_no_sock(t, pkt);
 		return -EINVAL;
 	}
=20
 	if (sk_acceptq_is_full(sk)) {
-		virtio_transport_reset(vsk, pkt);
+		virtio_transport_reset_no_sock(t, pkt);
 		return -ENOMEM;
 	}
=20
 	child =3D vsock_create_connected(sk);
 	if (!child) {
-		virtio_transport_reset(vsk, pkt);
+		virtio_transport_reset_no_sock(t, pkt);
 		return -ENOMEM;
 	}
=20
@@ -1054,7 +1054,7 @@ virtio_transport_recv_listen(struct sock *sk, struc=
t virtio_vsock_pkt *pkt,
 	 */
 	if (ret || vchild->transport !=3D &t->transport) {
 		release_sock(child);
-		virtio_transport_reset(vsk, pkt);
+		virtio_transport_reset_no_sock(t, pkt);
 		sock_put(child);
 		return ret;
 	}
--=20
2.23.0

