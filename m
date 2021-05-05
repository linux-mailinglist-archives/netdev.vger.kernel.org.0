Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B0B3745EA
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237957AbhEERJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 13:09:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238141AbhEEREt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 13:04:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62C2761C1D;
        Wed,  5 May 2021 16:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232934;
        bh=avyk2B4JCFFY9W3hguuFLcN3UPFlDfecHr6fFqMzGlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OKDFkk2llx0IZLqo8O7SDz1FQb8i5mHiAAJ+hGjQSR+ekQoAgTTuoAio7xiOuRm+d
         UmJA9DrMVAVkRZoGCk9U0btx7XURJkLtuIHG/bZgrRlDUI38fBmvUrGtyRxe7HFVAJ
         +5KM6zl8I+2JXOYYUPkqgMv7+u6Ojo48mhEz7aWH3TZh/HDhdqmp6C87yQhACoVRkB
         Un+cfibDwY49ekau/fRxxtjX3uC+4lA6C9Nl1DCK5zAwuN1e5dKjzjMlEp1rw/PEXJ
         6xKW72pV1TCJ/kwLwT297bPiq3Pzeg9XqEuPbcnTXh4N+ack4tRn65w6s1euvjZ79t
         eLZWDPrhoiiKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Archie Pusaka <apusaka@chromium.org>,
        syzbot+98228e7407314d2d4ba2@syzkaller.appspotmail.com,
        Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 08/19] Bluetooth: verify AMP hci_chan before amp_destroy
Date:   Wed,  5 May 2021 12:41:51 -0400
Message-Id: <20210505164203.3464510-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505164203.3464510-1-sashal@kernel.org>
References: <20210505164203.3464510-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

[ Upstream commit 5c4c8c9544099bb9043a10a5318130a943e32fc3 ]

hci_chan can be created in 2 places: hci_loglink_complete_evt() if
it is an AMP hci_chan, or l2cap_conn_add() otherwise. In theory,
Only AMP hci_chan should be removed by a call to
hci_disconn_loglink_complete_evt(). However, the controller might mess
up, call that function, and destroy an hci_chan which is not initiated
by hci_loglink_complete_evt().

This patch adds a verification that the destroyed hci_chan must have
been init'd by hci_loglink_complete_evt().

Example crash call trace:
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xe3/0x144 lib/dump_stack.c:118
 print_address_description+0x67/0x22a mm/kasan/report.c:256
 kasan_report_error mm/kasan/report.c:354 [inline]
 kasan_report mm/kasan/report.c:412 [inline]
 kasan_report+0x251/0x28f mm/kasan/report.c:396
 hci_send_acl+0x3b/0x56e net/bluetooth/hci_core.c:4072
 l2cap_send_cmd+0x5af/0x5c2 net/bluetooth/l2cap_core.c:877
 l2cap_send_move_chan_cfm_icid+0x8e/0xb1 net/bluetooth/l2cap_core.c:4661
 l2cap_move_fail net/bluetooth/l2cap_core.c:5146 [inline]
 l2cap_move_channel_rsp net/bluetooth/l2cap_core.c:5185 [inline]
 l2cap_bredr_sig_cmd net/bluetooth/l2cap_core.c:5464 [inline]
 l2cap_sig_channel net/bluetooth/l2cap_core.c:5799 [inline]
 l2cap_recv_frame+0x1d12/0x51aa net/bluetooth/l2cap_core.c:7023
 l2cap_recv_acldata+0x2ea/0x693 net/bluetooth/l2cap_core.c:7596
 hci_acldata_packet net/bluetooth/hci_core.c:4606 [inline]
 hci_rx_work+0x2bd/0x45e net/bluetooth/hci_core.c:4796
 process_one_work+0x6f8/0xb50 kernel/workqueue.c:2175
 worker_thread+0x4fc/0x670 kernel/workqueue.c:2321
 kthread+0x2f0/0x304 kernel/kthread.c:253
 ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:415

Allocated by task 38:
 set_track mm/kasan/kasan.c:460 [inline]
 kasan_kmalloc+0x8d/0x9a mm/kasan/kasan.c:553
 kmem_cache_alloc_trace+0x102/0x129 mm/slub.c:2787
 kmalloc include/linux/slab.h:515 [inline]
 kzalloc include/linux/slab.h:709 [inline]
 hci_chan_create+0x86/0x26d net/bluetooth/hci_conn.c:1674
 l2cap_conn_add.part.0+0x1c/0x814 net/bluetooth/l2cap_core.c:7062
 l2cap_conn_add net/bluetooth/l2cap_core.c:7059 [inline]
 l2cap_connect_cfm+0x134/0x852 net/bluetooth/l2cap_core.c:7381
 hci_connect_cfm+0x9d/0x122 include/net/bluetooth/hci_core.h:1404
 hci_remote_ext_features_evt net/bluetooth/hci_event.c:4161 [inline]
 hci_event_packet+0x463f/0x72fa net/bluetooth/hci_event.c:5981
 hci_rx_work+0x197/0x45e net/bluetooth/hci_core.c:4791
 process_one_work+0x6f8/0xb50 kernel/workqueue.c:2175
 worker_thread+0x4fc/0x670 kernel/workqueue.c:2321
 kthread+0x2f0/0x304 kernel/kthread.c:253
 ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:415

Freed by task 1732:
 set_track mm/kasan/kasan.c:460 [inline]
 __kasan_slab_free mm/kasan/kasan.c:521 [inline]
 __kasan_slab_free+0x106/0x128 mm/kasan/kasan.c:493
 slab_free_hook mm/slub.c:1409 [inline]
 slab_free_freelist_hook+0xaa/0xf6 mm/slub.c:1436
 slab_free mm/slub.c:3009 [inline]
 kfree+0x182/0x21e mm/slub.c:3972
 hci_disconn_loglink_complete_evt net/bluetooth/hci_event.c:4891 [inline]
 hci_event_packet+0x6a1c/0x72fa net/bluetooth/hci_event.c:6050
 hci_rx_work+0x197/0x45e net/bluetooth/hci_core.c:4791
 process_one_work+0x6f8/0xb50 kernel/workqueue.c:2175
 worker_thread+0x4fc/0x670 kernel/workqueue.c:2321
 kthread+0x2f0/0x304 kernel/kthread.c:253
 ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:415

The buggy address belongs to the object at ffff8881d7af9180
 which belongs to the cache kmalloc-128 of size 128
The buggy address is located 24 bytes inside of
 128-byte region [ffff8881d7af9180, ffff8881d7af9200)
The buggy address belongs to the page:
page:ffffea00075ebe40 count:1 mapcount:0 mapping:ffff8881da403200 index:0x0
flags: 0x8000000000000200(slab)
raw: 8000000000000200 dead000000000100 dead000000000200 ffff8881da403200
raw: 0000000000000000 0000000080150015 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8881d7af9080: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
 ffff8881d7af9100: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>ffff8881d7af9180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                            ^
 ffff8881d7af9200: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8881d7af9280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reported-by: syzbot+98228e7407314d2d4ba2@syzkaller.appspotmail.com
Reviewed-by: Alain Michaud <alainm@chromium.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h | 1 +
 net/bluetooth/hci_event.c        | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 5aaf6cdb121a..f042188c8099 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -498,6 +498,7 @@ struct hci_chan {
 	struct sk_buff_head data_q;
 	unsigned int	sent;
 	__u8		state;
+	bool		amp;
 };
 
 struct hci_conn_params {
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 586c005bdc1e..7ed3c7df271a 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4385,6 +4385,7 @@ static void hci_loglink_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		return;
 
 	hchan->handle = le16_to_cpu(ev->handle);
+	hchan->amp = true;
 
 	BT_DBG("hcon %p mgr %p hchan %p", hcon, hcon->amp_mgr, hchan);
 
@@ -4417,7 +4418,7 @@ static void hci_disconn_loglink_complete_evt(struct hci_dev *hdev,
 	hci_dev_lock(hdev);
 
 	hchan = hci_chan_lookup_handle(hdev, le16_to_cpu(ev->handle));
-	if (!hchan)
+	if (!hchan || !hchan->amp)
 		goto unlock;
 
 	amp_destroy_logical_link(hchan, ev->reason);
-- 
2.30.2

