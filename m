Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84A5323CF3
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 14:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbhBXNAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 08:00:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:51042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235493AbhBXM5c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 07:57:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 023E464ED3;
        Wed, 24 Feb 2021 12:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171141;
        bh=ZhtQCacTIBWG7l21wC+/AHVmsUBxBX357SWtdBSeyq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nCG0soLorQ9AfLg3LAkZTlNNXznAk/gyduMECFVp82hcwyx/4tf/GZQnTef3zLCMQ
         iUvAHBgzoXkee0d8NST+NTRqi6GWxTHvrxnAu+jfqrZIH9o+eggh/0mRQhArQBI45F
         3m4iqNWT4eqjHpKRaxxcVhr4pVgm/frraP3PYdRL4vPpZzBb1cHCMAjmIuALT1e8bO
         0T04iUDtPV/Jki3XRfOSR5ydFeCTvJ3SbA2xHObs4AQDMaKTU5O2Adxv+rRmFY+D7a
         En98s/V+aTYGHeBd35X+O2Hs4RTxUH4qUlvOfyKLprij9rRtdKREUpFtCfuVYkfbrT
         NFSvL/rMBETZw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 07/56] Bluetooth: btusb: fix memory leak on suspend and resume
Date:   Wed, 24 Feb 2021 07:51:23 -0500
Message-Id: <20210224125212.482485-7-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125212.482485-1-sashal@kernel.org>
References: <20210224125212.482485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>

[ Upstream commit 5ff20cbe6752a5bc06ff58fee8aa11a0d5075819 ]

kmemleak report:
unreferenced object 0xffff9b1127f00500 (size 208):
  comm "kworker/u17:2", pid 500, jiffies 4294937470 (age 580.136s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 60 ed 05 11 9b ff ff 00 00 00 00 00 00 00 00  .`..............
  backtrace:
    [<000000006ab3fd59>] kmem_cache_alloc_node+0x17a/0x480
    [<0000000051a5f6f9>] __alloc_skb+0x5b/0x1d0
    [<0000000037e2d252>] hci_prepare_cmd+0x32/0xc0 [bluetooth]
    [<0000000010b586d5>] hci_req_add_ev+0x84/0xe0 [bluetooth]
    [<00000000d2deb520>] hci_req_clear_event_filter+0x42/0x70 [bluetooth]
    [<00000000f864bd8c>] hci_req_prepare_suspend+0x84/0x470 [bluetooth]
    [<000000001deb2cc4>] hci_prepare_suspend+0x31/0x40 [bluetooth]
    [<000000002677dd79>] process_one_work+0x209/0x3b0
    [<00000000aaa62b07>] worker_thread+0x34/0x400
    [<00000000826d176c>] kthread+0x126/0x140
    [<000000002305e558>] ret_from_fork+0x22/0x30
unreferenced object 0xffff9b1125c6ee00 (size 512):
  comm "kworker/u17:2", pid 500, jiffies 4294937470 (age 580.136s)
  hex dump (first 32 bytes):
    04 00 00 00 0d 00 00 00 05 0c 01 00 11 9b ff ff  ................
    00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000009f07c0cc>] slab_post_alloc_hook+0x59/0x270
    [<0000000049431dc2>] __kmalloc_node_track_caller+0x15f/0x330
    [<00000000027a42f6>] __kmalloc_reserve.isra.70+0x31/0x90
    [<00000000e8e3e76a>] __alloc_skb+0x87/0x1d0
    [<0000000037e2d252>] hci_prepare_cmd+0x32/0xc0 [bluetooth]
    [<0000000010b586d5>] hci_req_add_ev+0x84/0xe0 [bluetooth]
    [<00000000d2deb520>] hci_req_clear_event_filter+0x42/0x70 [bluetooth]
    [<00000000f864bd8c>] hci_req_prepare_suspend+0x84/0x470 [bluetooth]
    [<000000001deb2cc4>] hci_prepare_suspend+0x31/0x40 [bluetooth]
    [<000000002677dd79>] process_one_work+0x209/0x3b0
    [<00000000aaa62b07>] worker_thread+0x34/0x400
    [<00000000826d176c>] kthread+0x126/0x140
    [<000000002305e558>] ret_from_fork+0x22/0x30
unreferenced object 0xffff9b112b395788 (size 8):
  comm "kworker/u17:2", pid 500, jiffies 4294937470 (age 580.136s)
  hex dump (first 8 bytes):
    20 00 00 00 00 00 04 00                           .......
  backtrace:
    [<0000000052dc28d2>] kmem_cache_alloc_trace+0x15e/0x460
    [<0000000046147591>] alloc_ctrl_urb+0x52/0xe0 [btusb]
    [<00000000a2ed3e9e>] btusb_send_frame+0x91/0x100 [btusb]
    [<000000001e66030e>] hci_send_frame+0x7e/0xf0 [bluetooth]
    [<00000000bf6b7269>] hci_cmd_work+0xc5/0x130 [bluetooth]
    [<000000002677dd79>] process_one_work+0x209/0x3b0
    [<00000000aaa62b07>] worker_thread+0x34/0x400
    [<00000000826d176c>] kthread+0x126/0x140
    [<000000002305e558>] ret_from_fork+0x22/0x30

In pm sleep-resume context, while the btusb device rebinds, it enters
hci_unregister_dev(), whilst there is a possibility of hdev receiving
PM_POST_SUSPEND suspend_notifier event, leading to generation of msg
frames. When hci_unregister_dev() completes, i.e. hdev context is
destroyed/freed, those intermittently sent msg frames cause memory
leak.

BUG details:
Below is stack trace of thread that enters hci_unregister_dev(), marks
the hdev flag HCI_UNREGISTER to 1, and then goes onto to wait on notifier
lock - refer unregister_pm_notifier().

  hci_unregister_dev+0xa5/0x320 [bluetoot]
  btusb_disconnect+0x68/0x150 [btusb]
  usb_unbind_interface+0x77/0x250
  ? kernfs_remove_by_name_ns+0x75/0xa0
  device_release_driver_internal+0xfe/0x1
  device_release_driver+0x12/0x20
  bus_remove_device+0xe1/0x150
  device_del+0x192/0x3e0
  ? usb_remove_ep_devs+0x1f/0x30
  usb_disable_device+0x92/0x1b0
  usb_disconnect+0xc2/0x270
  hub_event+0x9f6/0x15d0
  ? rpm_idle+0x23/0x360
  ? rpm_idle+0x26b/0x360
  process_one_work+0x209/0x3b0
  worker_thread+0x34/0x400
  ? process_one_work+0x3b0/0x3b0
  kthread+0x126/0x140
  ? kthread_park+0x90/0x90
  ret_from_fork+0x22/0x30

Below is stack trace of thread executing hci_suspend_notifier() which
processes the PM_POST_SUSPEND event, while the unbinding thread is
waiting on lock.

  hci_suspend_notifier.cold.39+0x5/0x2b [bluetooth]
  blocking_notifier_call_chain+0x69/0x90
  pm_notifier_call_chain+0x1a/0x20
  pm_suspend.cold.9+0x334/0x352
  state_store+0x84/0xf0
  kobj_attr_store+0x12/0x20
  sysfs_kf_write+0x3b/0x40
  kernfs_fop_write+0xda/0x1c0
  vfs_write+0xbb/0x250
  ksys_write+0x61/0xe0
  __x64_sys_write+0x1a/0x20
  do_syscall_64+0x37/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fix hci_suspend_notifer(), not to act on events when flag HCI_UNREGISTER
is set.

Signed-off-by: Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index c4aa2cbb92697..a8679cc468abc 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3527,7 +3527,8 @@ static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
 	}
 
 	/* Suspend notifier should only act on events when powered. */
-	if (!hdev_is_powered(hdev))
+	if (!hdev_is_powered(hdev) ||
+	    hci_dev_test_flag(hdev, HCI_UNREGISTER))
 		goto done;
 
 	if (action == PM_SUSPEND_PREPARE) {
-- 
2.27.0

