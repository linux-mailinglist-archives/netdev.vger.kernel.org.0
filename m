Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E942F5FC5
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 12:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbhANLWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 06:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbhANLWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 06:22:39 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413DCC061757;
        Thu, 14 Jan 2021 03:21:53 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id s15so2744962plr.9;
        Thu, 14 Jan 2021 03:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=h8f1dMYtlAZ7DKjOr3TKBIWJ2EYKtUHiop2OPGodnrM=;
        b=N2pe0hWLkweig/TIpI/BIsd7BwLqXlQVpISWt/j8+V0nWKVEmdztH/dX6nr/uEQm4m
         JcbEery26j2IL7kTQ8zoCBBHut2RmWyC+DWEWihyqOkMFLxfUq7hlJ4CIJQMqddRuWWi
         qZb4tmkf6MN0SoAtpSRkVfntN0G0JeqgqgHvrAqldQgVjIN/FIncRZK/pNtVMaC2Au1Y
         onaua4uQCP46CM9gNyWFyET5EeuzUuxbF2JX2huJWfhRVHlfh3kogs5qf+HjgJzHxxgZ
         yOvFE/R3jgwraMxxIiKG+MSbxzV7VWpy6i3Nsa5sSFEvSFos4aqqGK+CeLkKWc98q1QI
         ZJ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=h8f1dMYtlAZ7DKjOr3TKBIWJ2EYKtUHiop2OPGodnrM=;
        b=HdkU3DS0gdgudSZlpPr17EP6tDCwggr/C/OFNwuDpbfLsdvbLHLhR9gIls0MeT2DDK
         ETGHKnXzAhqroNur2XO4qoyjM3hmjuKm991IY9+d27NidpAOHKV6wOBHG7/bP5p1XrzO
         +aeUSb61J+zeErJNxp8VBQj6s66vQJjVXGWmW0K3E/9EMjoshpAgoW5yZxVeeqrFM2fu
         E2P4CIwa+MAlkAFh+D7FIY4FdYBZhLiltHlgK3ZD0A9xtHydfKe/17maUFxX7mGblnGc
         ZHyYqz5aGngxZ77alrUcm6lWc/3DgCOTTsHqM3+83HujFq0QHWasqW7S8cOuGQX/syyU
         NP2g==
X-Gm-Message-State: AOAM533iNFMvykzlfCxJ6hL0AObDN7SRGsvhFAxi+y9wrasi4+oToj5h
        nC2Q+cw26oWenG8jGqRhGDU=
X-Google-Smtp-Source: ABdhPJyHTsn9QIm3/8CFcMQLLZccRnAy21ueeVqO9bY4W0TP7K8wvMxouIBFQ7ocPseWkS6He+ANDQ==
X-Received: by 2002:a17:902:be02:b029:da:c6c9:c9db with SMTP id r2-20020a170902be02b02900dac6c9c9dbmr7038693pls.69.1610623312699;
        Thu, 14 Jan 2021 03:21:52 -0800 (PST)
Received: from cosmos ([103.113.142.250])
        by smtp.gmail.com with ESMTPSA id w2sm5225593pfj.110.2021.01.14.03.21.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Jan 2021 03:21:52 -0800 (PST)
Date:   Thu, 14 Jan 2021 16:51:47 +0530
From:   Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] Bluetooth: btusb: fix memory leak on suspend and resume
Message-ID: <20210114112143.GA1318@cosmos>
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
index 9d2c9a1c552f..1c793e6eb92a 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3566,7 +3566,8 @@ static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
 	}
 
 	/* Suspend notifier should only act on events when powered. */
-	if (!hdev_is_powered(hdev))
+	if (!hdev_is_powered(hdev) ||
+	    hci_dev_test_flag(hdev, HCI_UNREGISTER))
 		goto done;
 
 	if (action == PM_SUSPEND_PREPARE) {
-- 
2.17.1

