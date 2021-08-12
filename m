Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A7D3E9BD4
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 03:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233248AbhHLBKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 21:10:21 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13414 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233111AbhHLBKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 21:10:21 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GlT5y6ML0zdZSm;
        Thu, 12 Aug 2021 09:06:14 +0800 (CST)
Received: from dggpeml500016.china.huawei.com (7.185.36.70) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 12 Aug 2021 09:09:53 +0800
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 dggpeml500016.china.huawei.com (7.185.36.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 12 Aug 2021 09:09:52 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <sgarzare@redhat.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <arei.gonglei@huawei.com>,
        "Longpeng(Mike)" <longpeng2@huawei.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] vsock/virtio: avoid potential deadlock when vsock device remove
Date:   Thu, 12 Aug 2021 09:09:39 +0800
Message-ID: <20210812010939.1644-1-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.148.223]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500016.china.huawei.com (7.185.36.70)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a potential deadlock case when remove the vsock device or
process the RESET event:

  vsock_for_each_connected_socket:
      spin_lock_bh(&vsock_table_lock) ----------- (1)
      ...
          virtio_vsock_reset_sock:
              lock_sock(sk) --------------------- (2)
      ...
      spin_unlock_bh(&vsock_table_lock)

lock_sock() may do initiative schedule when the 'sk' is owned by
other thread at the same time, we would receivce a warning message
that "scheduling while atomic".

Even worse, if the next task (selected by the scheduler) try to
release a 'sk', it need to request vsock_table_lock and the deadlock
occur, cause the system into softlockup state.
  Call trace:
   queued_spin_lock_slowpath
   vsock_remove_bound
   vsock_remove_sock
   virtio_transport_release
   __vsock_release
   vsock_release
   __sock_release
   sock_close
   __fput
   ____fput

So we should not require sk_lock in this case, just like the behavior
in vhost_vsock or vmci.

Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
---
 net/vmw_vsock/virtio_transport.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index e0c2c99..4f7c99d 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -357,11 +357,14 @@ static void virtio_vsock_event_fill(struct virtio_vsock *vsock)
 
 static void virtio_vsock_reset_sock(struct sock *sk)
 {
-	lock_sock(sk);
+	/* vmci_transport.c doesn't take sk_lock here either.  At least we're
+	 * under vsock_table_lock so the sock cannot disappear while we're
+	 * executing.
+	 */
+
 	sk->sk_state = TCP_CLOSE;
 	sk->sk_err = ECONNRESET;
 	sk_error_report(sk);
-	release_sock(sk);
 }
 
 static void virtio_vsock_update_guest_cid(struct virtio_vsock *vsock)
-- 
1.8.3.1

