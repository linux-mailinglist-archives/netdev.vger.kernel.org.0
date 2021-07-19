Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7061B3CCC6A
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 04:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234293AbhGSCzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 22:55:43 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7029 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbhGSCzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 22:55:41 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GSmTC4kKBzYd7Z;
        Mon, 19 Jul 2021 10:46:55 +0800 (CST)
Received: from dggpemm500015.china.huawei.com (7.185.36.181) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 19 Jul 2021 10:52:39 +0800
Received: from huawei.com (10.175.124.27) by dggpemm500015.china.huawei.com
 (7.185.36.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 19 Jul
 2021 10:52:39 +0800
From:   Wang ShaoBo <bobo.shaobowang@huawei.com>
CC:     <cj.chengjian@huawei.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <huawei.libin@huawei.com>,
        <marcel@holtmann.org>, <luiz.dentz@gmail.com>,
        <johan.hedberg@gmail.com>, <linux-bluetooth@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] Bluetooth: fix use-after-free error in lock_sock_nested()
Date:   Mon, 19 Jul 2021 10:49:37 +0800
Message-ID: <20210719024937.9542-1-bobo.shaobowang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500015.china.huawei.com (7.185.36.181)
X-CFilter-Loop: Reflected
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use-after-free error in lock_sock_nested is reported:

[  179.140137][ T3731] =====================================================
[  179.142675][ T3731] BUG: KMSAN: use-after-free in lock_sock_nested+0x280/0x2c0
[  179.145494][ T3731] CPU: 4 PID: 3731 Comm: kworker/4:2 Not tainted 5.12.0-rc6+ #54
[  179.148432][ T3731] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
[  179.151806][ T3731] Workqueue: events l2cap_chan_timeout
[  179.152730][ T3731] Call Trace:
[  179.153301][ T3731]  dump_stack+0x24c/0x2e0
[  179.154063][ T3731]  kmsan_report+0xfb/0x1e0
[  179.154855][ T3731]  __msan_warning+0x5c/0xa0
[  179.155579][ T3731]  lock_sock_nested+0x280/0x2c0
[  179.156436][ T3731]  ? kmsan_get_metadata+0x116/0x180
[  179.157257][ T3731]  l2cap_sock_teardown_cb+0xb8/0x890
[  179.158154][ T3731]  ? __msan_metadata_ptr_for_load_8+0x10/0x20
[  179.159141][ T3731]  ? kmsan_get_metadata+0x116/0x180
[  179.159994][ T3731]  ? kmsan_get_shadow_origin_ptr+0x84/0xb0
[  179.160959][ T3731]  ? l2cap_sock_recv_cb+0x420/0x420
[  179.161834][ T3731]  l2cap_chan_del+0x3e1/0x1d50
[  179.162608][ T3731]  ? kmsan_get_metadata+0x116/0x180
[  179.163435][ T3731]  ? kmsan_get_shadow_origin_ptr+0x84/0xb0
[  179.164406][ T3731]  l2cap_chan_close+0xeea/0x1050
[  179.165189][ T3731]  ? kmsan_internal_unpoison_shadow+0x42/0x70
[  179.166180][ T3731]  l2cap_chan_timeout+0x1da/0x590
[  179.167066][ T3731]  ? __msan_metadata_ptr_for_load_8+0x10/0x20
[  179.168023][ T3731]  ? l2cap_chan_create+0x560/0x560
[  179.168818][ T3731]  process_one_work+0x121d/0x1ff0
[  179.169598][ T3731]  worker_thread+0x121b/0x2370
[  179.170346][ T3731]  kthread+0x4ef/0x610
[  179.171010][ T3731]  ? process_one_work+0x1ff0/0x1ff0
[  179.171828][ T3731]  ? kthread_blkcg+0x110/0x110
[  179.172587][ T3731]  ret_from_fork+0x1f/0x30
[  179.173348][ T3731]
[  179.173752][ T3731] Uninit was created at:
[  179.174409][ T3731]  kmsan_internal_poison_shadow+0x5c/0xf0
[  179.175373][ T3731]  kmsan_slab_free+0x76/0xc0
[  179.176060][ T3731]  kfree+0x3a5/0x1180
[  179.176664][ T3731]  __sk_destruct+0x8af/0xb80
[  179.177375][ T3731]  __sk_free+0x812/0x8c0
[  179.178032][ T3731]  sk_free+0x97/0x130
[  179.178686][ T3731]  l2cap_sock_release+0x3d5/0x4d0
[  179.179457][ T3731]  sock_close+0x150/0x450
[  179.180117][ T3731]  __fput+0x6bd/0xf00
[  179.180787][ T3731]  ____fput+0x37/0x40
[  179.181481][ T3731]  task_work_run+0x140/0x280
[  179.182219][ T3731]  do_exit+0xe51/0x3e60
[  179.182930][ T3731]  do_group_exit+0x20e/0x450
[  179.183656][ T3731]  get_signal+0x2dfb/0x38f0
[  179.184344][ T3731]  arch_do_signal_or_restart+0xaa/0xe10
[  179.185266][ T3731]  exit_to_user_mode_prepare+0x2d2/0x560
[  179.186136][ T3731]  syscall_exit_to_user_mode+0x35/0x60
[  179.186984][ T3731]  do_syscall_64+0xc5/0x140
[  179.187681][ T3731]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  179.188604][ T3731] =====================================================

In our case, there are two Thread A and B:

Context: Thread A:              Context: Thread B:

l2cap_chan_timeout()            __se_sys_shutdown()
  l2cap_chan_close()              l2cap_sock_shutdown()
    l2cap_chan_del()                l2cap_chan_close()
      l2cap_sock_teardown_cb()        l2cap_sock_teardown_cb()

Once l2cap_sock_teardown_cb() excuted, this sock will be marked as SOCK_ZAPPED,
and can be treated as killable in l2cap_sock_kill() if sock_orphan() has
excuted, at this time we close sock through sock_close() which end to call
l2cap_sock_kill() like Thread C:

Context: Thread C:

sock_close()
  l2cap_sock_release()
    sock_orphan()
    l2cap_sock_kill()  #free sock if refcnt is 1

If C completed, Once A or B reaches l2cap_sock_teardown_cb() again,
use-after-free happened.

We should set chan->data to NULL if sock is destructed, for telling teardown
operation is not allowed in l2cap_sock_teardown_cb(), and also we should
avoid killing an already killed socket in l2cap_sock_close_cb().

Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
---
v2:
  put chan->data = NULL in l2cap_socl_destruct(), this refers to
  Luiz Augusto von Dentz <luiz.dentz@gmail.com>'s proposal.
---
 net/bluetooth/l2cap_sock.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index c99d65ef13b1..160c016a5dfb 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1508,6 +1508,9 @@ static void l2cap_sock_close_cb(struct l2cap_chan *chan)
 {
 	struct sock *sk = chan->data;
 
+	if (!sk)
+		return;
+
 	l2cap_sock_kill(sk);
 }
 
@@ -1516,6 +1519,9 @@ static void l2cap_sock_teardown_cb(struct l2cap_chan *chan, int err)
 	struct sock *sk = chan->data;
 	struct sock *parent;
 
+	if (!sk)
+		return;
+
 	BT_DBG("chan %p state %s", chan, state_to_string(chan->state));
 
 	/* This callback can be called both for server (BT_LISTEN)
@@ -1707,8 +1713,10 @@ static void l2cap_sock_destruct(struct sock *sk)
 {
 	BT_DBG("sk %p", sk);
 
-	if (l2cap_pi(sk)->chan)
+	if (l2cap_pi(sk)->chan) {
+		l2cap_pi(sk)->chan->data = NULL;
 		l2cap_chan_put(l2cap_pi(sk)->chan);
+	}
 
 	if (l2cap_pi(sk)->rx_busy_skb) {
 		kfree_skb(l2cap_pi(sk)->rx_busy_skb);
-- 
2.27.0

