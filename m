Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61CE044A1FA
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242011AbhKIBPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:15:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:38612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241766AbhKIBKo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:10:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81A8661A83;
        Tue,  9 Nov 2021 01:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419875;
        bh=RKEmarnTG58voAI1wWvxQd9ErnZyKMcBBb43H0ND5QI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uf5imTuwjIvRMSWUVFU49vvEmaKqHXq+pyB0kgklOSrHbMWhz7F4H9T/GxfG24Xox
         NaMdiD03iG3Dy0YNM7M9OuU5a54ob26xF1yuIlDZd2LZNjOhxs1dKYkfWMYO/guOuX
         0Gr9zJgoGkYHEKywt1CHNgTE4xRrlHFmvYHTTD4OhrFia2C+gkXi/YOgE4Bc8f+eAP
         Z8Ym+6axcyLb9cbVVcww5Q3pM/kVvxXQdsmF0qMp2ubHd+58uhJGhNx7zR3mNHX0++
         9eu+uAoOGY4X4Ds74PZ+MMWGsANI1Kbo7dJAse0MIWwOHi5ctItw+bi68CJRKDqYAB
         z+ort9uqyvRyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/74] Bluetooth: fix use-after-free error in lock_sock_nested()
Date:   Mon,  8 Nov 2021 12:48:33 -0500
Message-Id: <20211108174942.1189927-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174942.1189927-1-sashal@kernel.org>
References: <20211108174942.1189927-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang ShaoBo <bobo.shaobowang@huawei.com>

[ Upstream commit 1bff51ea59a9afb67d2dd78518ab0582a54a472c ]

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
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 82e76ff01267a..08e9f332adad3 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1347,6 +1347,9 @@ static void l2cap_sock_close_cb(struct l2cap_chan *chan)
 {
 	struct sock *sk = chan->data;
 
+	if (!sk)
+		return;
+
 	l2cap_sock_kill(sk);
 }
 
@@ -1355,6 +1358,9 @@ static void l2cap_sock_teardown_cb(struct l2cap_chan *chan, int err)
 	struct sock *sk = chan->data;
 	struct sock *parent;
 
+	if (!sk)
+		return;
+
 	BT_DBG("chan %p state %s", chan, state_to_string(chan->state));
 
 	/* This callback can be called both for server (BT_LISTEN)
@@ -1538,8 +1544,10 @@ static void l2cap_sock_destruct(struct sock *sk)
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
2.33.0

