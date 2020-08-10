Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4EF1240F7B
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 21:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730053AbgHJTWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 15:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729685AbgHJTNF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 15:13:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 519C521775;
        Mon, 10 Aug 2020 19:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086784;
        bh=WpV52KAFDM0xr311bUeYlAhrwM/hcvWw2VepPjQWodA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=08KotkF9QfASJRn0L7D1i6PEcAoiMAclukKHA3C6bHNmAVRa24SsL35qb2VuOEKk6
         kJaxsdogIW1AXhDmxiYp+ZvQBMr/Z7EsGHfJj0HIo+b3Fg5qRVCpHyG9mowrqrTc0n
         GkT2DtzqoPAFRbXwelr1QerSU5JGwjQs9fKqyMFk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lihong Kou <koulihong@huawei.com>,
        syzbot+96414aa0033c363d8458@syzkaller.appspotmail.com,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/31] Bluetooth: add a mutex lock to avoid UAF in do_enale_set
Date:   Mon, 10 Aug 2020 15:12:31 -0400
Message-Id: <20200810191259.3794858-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191259.3794858-1-sashal@kernel.org>
References: <20200810191259.3794858-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lihong Kou <koulihong@huawei.com>

[ Upstream commit f9c70bdc279b191da8d60777c627702c06e4a37d ]

In the case we set or free the global value listen_chan in
different threads, we can encounter the UAF problems because
the method is not protected by any lock, add one to avoid
this bug.

BUG: KASAN: use-after-free in l2cap_chan_close+0x48/0x990
net/bluetooth/l2cap_core.c:730
Read of size 8 at addr ffff888096950000 by task kworker/1:102/2868

CPU: 1 PID: 2868 Comm: kworker/1:102 Not tainted 5.5.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 01/01/2011
Workqueue: events do_enable_set
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1fb/0x318 lib/dump_stack.c:118
 print_address_description+0x74/0x5c0 mm/kasan/report.c:374
 __kasan_report+0x149/0x1c0 mm/kasan/report.c:506
 kasan_report+0x26/0x50 mm/kasan/common.c:641
 __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:135
 l2cap_chan_close+0x48/0x990 net/bluetooth/l2cap_core.c:730
 do_enable_set+0x660/0x900 net/bluetooth/6lowpan.c:1074
 process_one_work+0x7f5/0x10f0 kernel/workqueue.c:2264
 worker_thread+0xbbc/0x1630 kernel/workqueue.c:2410
 kthread+0x332/0x350 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 2870:
 save_stack mm/kasan/common.c:72 [inline]
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc+0x118/0x1c0 mm/kasan/common.c:515
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:529
 kmem_cache_alloc_trace+0x221/0x2f0 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 l2cap_chan_create+0x50/0x320 net/bluetooth/l2cap_core.c:446
 chan_create net/bluetooth/6lowpan.c:640 [inline]
 bt_6lowpan_listen net/bluetooth/6lowpan.c:959 [inline]
 do_enable_set+0x6a4/0x900 net/bluetooth/6lowpan.c:1078
 process_one_work+0x7f5/0x10f0 kernel/workqueue.c:2264
 worker_thread+0xbbc/0x1630 kernel/workqueue.c:2410
 kthread+0x332/0x350 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Freed by task 2870:
 save_stack mm/kasan/common.c:72 [inline]
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:337 [inline]
 __kasan_slab_free+0x12e/0x1e0 mm/kasan/common.c:476
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:485
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10d/0x220 mm/slab.c:3757
 l2cap_chan_destroy net/bluetooth/l2cap_core.c:484 [inline]
 kref_put include/linux/kref.h:65 [inline]
 l2cap_chan_put+0x170/0x190 net/bluetooth/l2cap_core.c:498
 do_enable_set+0x66c/0x900 net/bluetooth/6lowpan.c:1075
 process_one_work+0x7f5/0x10f0 kernel/workqueue.c:2264
 worker_thread+0xbbc/0x1630 kernel/workqueue.c:2410
 kthread+0x332/0x350 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff888096950000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 0 bytes inside of
 2048-byte region [ffff888096950000, ffff888096950800)
The buggy address belongs to the page:
page:ffffea00025a5400 refcount:1 mapcount:0 mapping:ffff8880aa400e00 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00027d1548 ffffea0002397808 ffff8880aa400e00
raw: 0000000000000000 ffff888096950000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88809694ff00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88809694ff80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff888096950000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888096950080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888096950100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

Reported-by: syzbot+96414aa0033c363d8458@syzkaller.appspotmail.com
Signed-off-by: Lihong Kou <koulihong@huawei.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/6lowpan.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 357475cceec61..9a75f9b00b512 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -57,6 +57,7 @@ static bool enable_6lowpan;
 /* We are listening incoming connections via this channel
  */
 static struct l2cap_chan *listen_chan;
+static DEFINE_MUTEX(set_lock);
 
 struct lowpan_peer {
 	struct list_head list;
@@ -1082,12 +1083,14 @@ static void do_enable_set(struct work_struct *work)
 
 	enable_6lowpan = set_enable->flag;
 
+	mutex_lock(&set_lock);
 	if (listen_chan) {
 		l2cap_chan_close(listen_chan, 0);
 		l2cap_chan_put(listen_chan);
 	}
 
 	listen_chan = bt_6lowpan_listen();
+	mutex_unlock(&set_lock);
 
 	kfree(set_enable);
 }
@@ -1139,11 +1142,13 @@ static ssize_t lowpan_control_write(struct file *fp,
 		if (ret == -EINVAL)
 			return ret;
 
+		mutex_lock(&set_lock);
 		if (listen_chan) {
 			l2cap_chan_close(listen_chan, 0);
 			l2cap_chan_put(listen_chan);
 			listen_chan = NULL;
 		}
+		mutex_unlock(&set_lock);
 
 		if (conn) {
 			struct lowpan_peer *peer;
-- 
2.25.1

