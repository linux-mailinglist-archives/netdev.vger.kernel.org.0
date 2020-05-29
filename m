Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD7A1E7ECC
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 15:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgE2NcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 09:32:25 -0400
Received: from foss.arm.com ([217.140.110.172]:36640 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbgE2NcY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 09:32:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C089A55D;
        Fri, 29 May 2020 06:32:23 -0700 (PDT)
Received: from localhost.localdomain (entos-thunderx2-02.shanghai.arm.com [10.169.138.74])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 66E103F305;
        Fri, 29 May 2020 06:32:20 -0700 (PDT)
From:   Jia He <justin.he@arm.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaly Xin <Kaly.Xin@arm.com>,
        Jia He <justin.he@arm.com>, stable@vger.kernel.org
Subject: [PATCH] virtio_vsock: Fix race condition in virtio_transport_recv_pkt
Date:   Fri, 29 May 2020 21:31:23 +0800
Message-Id: <20200529133123.195610-1-justin.he@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When client tries to connect(SOCK_STREAM) the server in the guest with NONBLOCK
mode, there will be a panic on a ThunderX2 (armv8a server):
[  463.718844][ T5040] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
[  463.718848][ T5040] Mem abort info:
[  463.718849][ T5040]   ESR = 0x96000044
[  463.718852][ T5040]   EC = 0x25: DABT (current EL), IL = 32 bits
[  463.718853][ T5040]   SET = 0, FnV = 0
[  463.718854][ T5040]   EA = 0, S1PTW = 0
[  463.718855][ T5040] Data abort info:
[  463.718856][ T5040]   ISV = 0, ISS = 0x00000044
[  463.718857][ T5040]   CM = 0, WnR = 1
[  463.718859][ T5040] user pgtable: 4k pages, 48-bit VAs, pgdp=0000008f6f6e9000
[  463.718861][ T5040] [0000000000000000] pgd=0000000000000000
[  463.718866][ T5040] Internal error: Oops: 96000044 [#1] SMP
[...]
[  463.718977][ T5040] CPU: 213 PID: 5040 Comm: vhost-5032 Tainted: G           O      5.7.0-rc7+ #139
[  463.718980][ T5040] Hardware name: GIGABYTE R281-T91-00/MT91-FS1-00, BIOS F06 09/25/2018
[  463.718982][ T5040] pstate: 60400009 (nZCv daif +PAN -UAO)
[  463.718995][ T5040] pc : virtio_transport_recv_pkt+0x4c8/0xd40 [vmw_vsock_virtio_transport_common]
[  463.718999][ T5040] lr : virtio_transport_recv_pkt+0x1fc/0xd40 [vmw_vsock_virtio_transport_common]
[  463.719000][ T5040] sp : ffff80002dbe3c40
[...]
[  463.719025][ T5040] Call trace:
[  463.719030][ T5040]  virtio_transport_recv_pkt+0x4c8/0xd40 [vmw_vsock_virtio_transport_common]
[  463.719034][ T5040]  vhost_vsock_handle_tx_kick+0x360/0x408 [vhost_vsock]
[  463.719041][ T5040]  vhost_worker+0x100/0x1a0 [vhost]
[  463.719048][ T5040]  kthread+0x128/0x130
[  463.719052][ T5040]  ret_from_fork+0x10/0x18

The race condition as follows:
Task1                            Task2
=====                            =====
__sock_release                   virtio_transport_recv_pkt
  __vsock_release                  vsock_find_bound_socket (found)
    lock_sock_nested
    vsock_remove_sock
    sock_orphan
      sk_set_socket(sk, NULL)
    ...
    release_sock
                                lock_sock
                                   virtio_transport_recv_connecting
                                     sk->sk_socket->state (panic)

This fixes it by checking vsk again whether it is in bound/connected table.

Signed-off-by: Jia He <justin.he@arm.com>
Cc: stable@vger.kernel.org
---
 net/vmw_vsock/virtio_transport_common.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 69efc891885f..0dbd6a45f0ed 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1132,6 +1132,17 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 
 	lock_sock(sk);
 
+	/* Check it again if vsk is removed by vsock_remove_sock */
+	spin_lock_bh(&vsock_table_lock);
+	if (!__vsock_in_bound_table(vsk) && !__vsock_in_connected_table(vsk)) {
+		spin_unlock_bh(&vsock_table_lock);
+		(void)virtio_transport_reset_no_sock(t, pkt);
+		release_sock(sk);
+		sock_put(sk);
+		goto free_pkt;
+	}
+	spin_unlock_bh(&vsock_table_lock);
+
 	/* Update CID in case it has changed after a transport reset event */
 	vsk->local_addr.svm_cid = dst.svm_cid;
 
-- 
2.17.1

