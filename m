Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE97D2F5E34
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 11:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbhANJ7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 04:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727906AbhANJ7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 04:59:42 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6700CC061573;
        Thu, 14 Jan 2021 01:59:03 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id j13so2917067pjz.3;
        Thu, 14 Jan 2021 01:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=rLBzwlf8KBkW1DZlLF9GkNc0sIjNTFqLeUdb09RmAqE=;
        b=SI+5KCpdIIA+vpcGjqLojJqks95heRRt8JglLCenKIRLbWBRwNrd3f4IL4va8gITod
         Rqvm5pwP7AJXLoVmw7qv4s/47JX/F5GldSQ89HgxRlFHmRv2rD2XEuonUT22DMsQFsGX
         apvS6J+Vni+I2+drdEbzPoOxvJEUOp3RdsAAREpoKfnI2q5aG/G6zJKZwx/Iw7+XOrxO
         ImsQe8iVJSPVdrzwIOZmeZ6815hooqP0RvYJeYdj/r1Bx/ABb8WEfOM1tTgUEQjUMZHW
         94VoAtbU2NPU/O8f3zsTWtA3PWkXG/7JWAWpEsSqZgadYnA04LwG34LiekW6ttI93vSI
         L3dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=rLBzwlf8KBkW1DZlLF9GkNc0sIjNTFqLeUdb09RmAqE=;
        b=fnnYHYyjNjGdFZziz9uDeWwL2And0OyjkdJKDjFiiZ2D8CreCHLVO1jOoGvELk1zif
         Vfyq26/g1tkFVHPZxvXxxrLu2SLvzVyfDqwWT1pNhRpHCK5fNN8x3EdJi24RcQwDNZiY
         WJdt+EI24u885ZzDS83onuDDUBkucGDTWMnAUrLiZh3la6EHsxqQQLKSmox9/qu+6WAW
         AoyZfEGE9OppkPLQ3DN3qlWH5Lhwydu6jCAlF+P9UY+LyMHUBKWSWag7VzGHsu9h3bW1
         XYgYuxlnhPPDGw2QkriCVSys+bHey4o6x3ViRnhzv1ACcZNX/J3N7Z9tSJv/cvrrO1qd
         s/Lw==
X-Gm-Message-State: AOAM532m3S9axKUZ6qwRc9LYLPwgOAIexgeWK33uGSigA8n8Bqm7SwgL
        +Hf50mmLAfsT/XcUMZD3fHPETp9Dk1A=
X-Google-Smtp-Source: ABdhPJz0SGBjrjifzRJmyB+WZRJUpQk5USuqf81S9cZEdd18n+6UVo0RA/aluPP9Oj8WFiaYOZvKXQ==
X-Received: by 2002:a17:90b:490c:: with SMTP id kr12mr4191801pjb.227.1610618342943;
        Thu, 14 Jan 2021 01:59:02 -0800 (PST)
Received: from cosmos ([103.113.142.250])
        by smtp.gmail.com with ESMTPSA id w200sm4896023pfc.14.2021.01.14.01.58.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Jan 2021 01:59:02 -0800 (PST)
Date:   Thu, 14 Jan 2021 15:28:57 +0530
From:   Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Bluetooth: btusb: fix memory leak on suspend and resume
Message-ID: <20210114095853.GA1650@cosmos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 net/bluetooth/hci_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 9d2c9a1c552f..29c88dbbc3fe 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3566,7 +3566,8 @@ static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
 	}
 
 	/* Suspend notifier should only act on events when powered. */
-	if (!hdev_is_powered(hdev))
+	if (!hdev_is_powered(hdev) ||
+	    !hci_dev_test_flag(hdev, HCI_UNREGISTER))
 		goto done;
 
 	if (action == PM_SUSPEND_PREPARE) {
-- 
2.17.1

