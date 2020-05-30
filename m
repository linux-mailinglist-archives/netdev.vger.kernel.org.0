Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B6E1E9134
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 14:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbgE3McV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 08:32:21 -0400
Received: from foss.arm.com ([217.140.110.172]:45622 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbgE3McV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 08:32:21 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E6AA81042;
        Sat, 30 May 2020 05:32:19 -0700 (PDT)
Received: from localhost.localdomain (entos-thunderx2-02.shanghai.arm.com [10.169.138.74])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0F68B3F6C4;
        Sat, 30 May 2020 05:32:15 -0700 (PDT)
From:   Jia He <justin.he@arm.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaly Xin <Kaly.Xin@arm.com>,
        Markus Elfring <Markus.Elfring@web.de>,
        Jia He <justin.he@arm.com>, stable@vger.kernel.org,
        Asias He <asias@redhat.com>
Subject: [PATCH] virtio_vsock: Fix race condition in virtio_transport_recv_pkt
Date:   Sat, 30 May 2020 20:32:06 +0800
Message-Id: <20200530123206.63335-1-justin.he@arm.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When client on the host tries to connect(SOCK_STREAM, O_NONBLOCK) to the
server on the guest, there will be a panic on a ThunderX2 (armv8a server):

[  463.718844] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
[  463.718848] Mem abort info:
[  463.718849]   ESR = 0x96000044
[  463.718852]   EC = 0x25: DABT (current EL), IL = 32 bits
[  463.718853]   SET = 0, FnV = 0
[  463.718854]   EA = 0, S1PTW = 0
[  463.718855] Data abort info:
[  463.718856]   ISV = 0, ISS = 0x00000044
[  463.718857]   CM = 0, WnR = 1
[  463.718859] user pgtable: 4k pages, 48-bit VAs, pgdp=0000008f6f6e9000
[  463.718861] [0000000000000000] pgd=0000000000000000
[  463.718866] Internal error: Oops: 96000044 [#1] SMP
[...]
[  463.718977] CPU: 213 PID: 5040 Comm: vhost-5032 Tainted: G           O      5.7.0-rc7+ #139
[  463.718980] Hardware name: GIGABYTE R281-T91-00/MT91-FS1-00, BIOS F06 09/25/2018
[  463.718982] pstate: 60400009 (nZCv daif +PAN -UAO)
[  463.718995] pc : virtio_transport_recv_pkt+0x4c8/0xd40 [vmw_vsock_virtio_transport_common]
[  463.718999] lr : virtio_transport_recv_pkt+0x1fc/0xd40 [vmw_vsock_virtio_transport_common]
[  463.719000] sp : ffff80002dbe3c40
[...]
[  463.719025] Call trace:
[  463.719030]  virtio_transport_recv_pkt+0x4c8/0xd40 [vmw_vsock_virtio_transport_common]
[  463.719034]  vhost_vsock_handle_tx_kick+0x360/0x408 [vhost_vsock]
[  463.719041]  vhost_worker+0x100/0x1a0 [vhost]
[  463.719048]  kthread+0x128/0x130
[  463.719052]  ret_from_fork+0x10/0x18

The race condition is as follows:
Task1                                Task2
=====                                =====
__sock_release                       virtio_transport_recv_pkt
  __vsock_release                      vsock_find_bound_socket (found sk)
    lock_sock_nested
    vsock_remove_sock
    sock_orphan
      sk_set_socket(sk, NULL)
    sk->sk_shutdown = SHUTDOWN_MASK
    ...
    release_sock
                                    lock_sock
                                       virtio_transport_recv_connecting
                                         sk->sk_socket->state (panic!)

The root cause is that vsock_find_bound_socket can't hold the lock_sock,
so there is a small race window between vsock_find_bound_socket() and
lock_sock(). If __vsock_release() is running in another task,
sk->sk_socket will be set to NULL inadvertently.

Thus check the data structure member “sk_shutdown” (suggested by Stefano)
after a call of the function “lock_sock” since this field is set to
“SHUTDOWN_MASK” under the protection of “lock_sock_nested”.

Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
Signed-off-by: Jia He <justin.he@arm.com>
Cc: stable@vger.kernel.org
Cc: Asias He <asias@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
v4: refine the commit msg (from Markus)

 net/vmw_vsock/virtio_transport_common.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 69efc891885f..0edda1edf988 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1132,6 +1132,14 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 
 	lock_sock(sk);
 
+	/* Check if sk has been released before lock_sock */
+	if (sk->sk_shutdown == SHUTDOWN_MASK) {
+		(void)virtio_transport_reset_no_sock(t, pkt);
+		release_sock(sk);
+		sock_put(sk);
+		goto free_pkt;
+	}
+
 	/* Update CID in case it has changed after a transport reset event */
 	vsk->local_addr.svm_cid = dst.svm_cid;
 
-- 
2.17.1

