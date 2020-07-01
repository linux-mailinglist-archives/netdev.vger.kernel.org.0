Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D46211000
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 18:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732275AbgGAQB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 12:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728534AbgGAQB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 12:01:28 -0400
X-Greylist: delayed 316 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 01 Jul 2020 09:01:28 PDT
Received: from mout0.freenet.de (mout0.freenet.de [IPv6:2001:748:100:40::2:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BABC08C5C1;
        Wed,  1 Jul 2020 09:01:28 -0700 (PDT)
Received: from [195.4.92.164] (helo=mjail1.freenet.de)
        by mout0.freenet.de with esmtpa (ID viktor.jaegerskuepper@freenet.de) (port 25) (Exim 4.92 #3)
        id 1jqf5k-000148-HV; Wed, 01 Jul 2020 17:56:08 +0200
Received: from [::1] (port=45056 helo=mjail1.freenet.de)
        by mjail1.freenet.de with esmtpa (ID viktor.jaegerskuepper@freenet.de) (Exim 4.92 #3)
        id 1jqf5k-0001yC-Fa; Wed, 01 Jul 2020 17:56:08 +0200
Received: from sub5.freenet.de ([195.4.92.124]:37220)
        by mjail1.freenet.de with esmtpa (ID viktor.jaegerskuepper@freenet.de) (Exim 4.92 #3)
        id 1jqf3C-0008Rg-9L; Wed, 01 Jul 2020 17:53:30 +0200
Received: from p200300e70725c1007461df5dd0c38276.dip0.t-ipconnect.de ([2003:e7:725:c100:7461:df5d:d0c3:8276]:56922 helo=[127.0.0.1])
        by sub5.freenet.de with esmtpsa (ID viktor.jaegerskuepper@freenet.de) (TLSv1.2:ECDHE-RSA-CHACHA20-POLY1305:256) (port 465) (Exim 4.92 #3)
        id 1jqf3C-0003YH-0o; Wed, 01 Jul 2020 17:53:30 +0200
Subject: [PATCH] Revert "ath9k: Fix general protection fault in
 ath9k_hif_usb_rx_cb"
To:     Kalle Valo <kvalo@codeaurora.org>, Roman Mamedov <rm@romanrm.net>
Cc:     Qiujun Huang <hqjagain@gmail.com>, ath9k-devel@qca.qualcomm.com,
        davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        anenbupt@gmail.com, syzkaller-bugs@googlegroups.com
References: <20200404041838.10426-1-hqjagain@gmail.com>
 <20200404041838.10426-6-hqjagain@gmail.com> <20200621020428.6417d6fb@natsu>
 <87lfkff9qe.fsf@codeaurora.org>
From:   =?UTF-8?B?VmlrdG9yIErDpGdlcnNrw7xwcGVy?= 
        <viktor_jaegerskuepper@freenet.de>
Message-ID: <53940af0-d156-3117-ac86-2f3ccaee9513@freenet.de>
Date:   Wed, 1 Jul 2020 17:53:27 +0200
MIME-Version: 1.0
In-Reply-To: <87lfkff9qe.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
X-Originated-At: 2003:e7:725:c100:7461:df5d:d0c3:8276!56922
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo writes:
> Roman Mamedov <rm@romanrm.net> writes:
> 
>> On Sat,  4 Apr 2020 12:18:38 +0800
>> Qiujun Huang <hqjagain@gmail.com> wrote:
>>
>>> In ath9k_hif_usb_rx_cb interface number is assumed to be 0.
>>> usb_ifnum_to_if(urb->dev, 0)
>>> But it isn't always true.
>>>
>>> The case reported by syzbot:
>>> https://lore.kernel.org/linux-usb/000000000000666c9c05a1c05d12@google.com
>>> usb 2-1: new high-speed USB device number 2 using dummy_hcd
>>> usb 2-1: config 1 has an invalid interface number: 2 but max is 0
>>> usb 2-1: config 1 has no interface number 0
>>> usb 2-1: New USB device found, idVendor=0cf3, idProduct=9271, bcdDevice=
>>> 1.08
>>> usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>>> general protection fault, probably for non-canonical address
>>> 0xdffffc0000000015: 0000 [#1] SMP KASAN
>>> KASAN: null-ptr-deref in range [0x00000000000000a8-0x00000000000000af]
>>> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.6.0-rc5-syzkaller #0
>>>
>>> Call Trace
>>> __usb_hcd_giveback_urb+0x29a/0x550 drivers/usb/core/hcd.c:1650
>>> usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1716
>>> dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
>>> call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
>>> expire_timers kernel/time/timer.c:1449 [inline]
>>> __run_timers kernel/time/timer.c:1773 [inline]
>>> __run_timers kernel/time/timer.c:1740 [inline]
>>> run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786
>>> __do_softirq+0x21e/0x950 kernel/softirq.c:292
>>> invoke_softirq kernel/softirq.c:373 [inline]
>>> irq_exit+0x178/0x1a0 kernel/softirq.c:413
>>> exiting_irq arch/x86/include/asm/apic.h:546 [inline]
>>> smp_apic_timer_interrupt+0x141/0x540 arch/x86/kernel/apic/apic.c:1146
>>> apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
>>>
>>> Reported-and-tested-by: syzbot+40d5d2e8a4680952f042@syzkaller.appspotmail.com
>>> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
>>
>> This causes complete breakage of ath9k operation across all the stable kernel
>> series it got backported to, and I guess the mainline as well. Please see:
>> https://bugzilla.kernel.org/show_bug.cgi?id=208251
>> https://bugzilla.redhat.com/show_bug.cgi?id=1848631
> 
> So there's no fix for this? I was under impression that someone fixed
> this, but maybe I'm mixing with something else.
> 
> If this is not fixed can someone please submit a patch to revert the
> offending commit (or commits) so that we get ath9k working again?
> 

This reverts commit 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05 ("ath9k: Fix general protection fault
in ath9k_hif_usb_rx_cb") because the driver gets stuck like this:

  [    5.778803] usb 1-5: Manufacturer: ATHEROS
  [   21.697488] usb 1-5: ath9k_htc: Firmware ath9k_htc/htc_9271-1.4.0.fw requested
  [   21.701377] usbcore: registered new interface driver ath9k_htc
  [   22.053705] usb 1-5: ath9k_htc: Transferred FW: ath9k_htc/htc_9271-1.4.0.fw, size: 51008
  [   22.306182] ath9k_htc 1-5:1.0: ath9k_htc: HTC initialized with 33 credits
  [  115.708513] ath9k_htc: Failed to initialize the device
  [  115.708683] usb 1-5: ath9k_htc: USB layer deinitialized

Reported-by: Roman Mamedov <rm@romanrm.net>
Ref: https://bugzilla.kernel.org/show_bug.cgi?id=208251
Fixes: 2bbcaaee1fcb ("ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb")
Tested-by: Viktor Jägersküpper <viktor_jaegerskuepper@freenet.de>
Signed-off-by: Viktor Jägersküpper <viktor_jaegerskuepper@freenet.de>
---

I couldn't find any fix for this, so here is the patch which reverts the
offending commit. I have tested it with 5.8.0-rc3 and with 5.7.4.

Feel free to change the commit message if it is necessary or appropriate, I am
just a user affected by this bug.

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 4ed21dad6a8e..6049d3766c64 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -643,9 +643,9 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 
 static void ath9k_hif_usb_rx_cb(struct urb *urb)
 {
-       struct rx_buf *rx_buf = (struct rx_buf *)urb->context;
-       struct hif_device_usb *hif_dev = rx_buf->hif_dev;
-       struct sk_buff *skb = rx_buf->skb;
+       struct sk_buff *skb = (struct sk_buff *) urb->context;
+       struct hif_device_usb *hif_dev =
+               usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
        int ret;
 
        if (!skb)
@@ -685,15 +685,14 @@ static void ath9k_hif_usb_rx_cb(struct urb *urb)
        return;
 free:
        kfree_skb(skb);
-       kfree(rx_buf);
 }
 
 static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 {
-       struct rx_buf *rx_buf = (struct rx_buf *)urb->context;
-       struct hif_device_usb *hif_dev = rx_buf->hif_dev;
-       struct sk_buff *skb = rx_buf->skb;
+       struct sk_buff *skb = (struct sk_buff *) urb->context;
        struct sk_buff *nskb;
+       struct hif_device_usb *hif_dev =
+               usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
        int ret;
 
        if (!skb)
@@ -751,7 +750,6 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
        return;
 free:
        kfree_skb(skb);
-       kfree(rx_buf);
        urb->context = NULL;
 }
 
@@ -797,7 +795,7 @@ static int ath9k_hif_usb_alloc_tx_urbs(struct hif_device_usb *hif_dev)
        init_usb_anchor(&hif_dev->mgmt_submitted);
 
        for (i = 0; i < MAX_TX_URB_NUM; i++) {
-               tx_buf = kzalloc(sizeof(*tx_buf), GFP_KERNEL);
+               tx_buf = kzalloc(sizeof(struct tx_buf), GFP_KERNEL);
                if (!tx_buf)
                        goto err;
 
@@ -834,9 +832,8 @@ static void ath9k_hif_usb_dealloc_rx_urbs(struct hif_device_usb *hif_dev)
 
 static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
 {
-       struct rx_buf *rx_buf = NULL;
-       struct sk_buff *skb = NULL;
        struct urb *urb = NULL;
+       struct sk_buff *skb = NULL;
        int i, ret;
 
        init_usb_anchor(&hif_dev->rx_submitted);
@@ -844,12 +841,6 @@ static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
 
        for (i = 0; i < MAX_RX_URB_NUM; i++) {
 
-               rx_buf = kzalloc(sizeof(*rx_buf), GFP_KERNEL);
-               if (!rx_buf) {
-                       ret = -ENOMEM;
-                       goto err_rxb;
-               }
-
                /* Allocate URB */
                urb = usb_alloc_urb(0, GFP_KERNEL);
                if (urb == NULL) {
@@ -864,14 +855,11 @@ static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
                        goto err_skb;
                }
 
-               rx_buf->hif_dev = hif_dev;
-               rx_buf->skb = skb;
-
                usb_fill_bulk_urb(urb, hif_dev->udev,
                                  usb_rcvbulkpipe(hif_dev->udev,
                                                  USB_WLAN_RX_PIPE),
                                  skb->data, MAX_RX_BUF_SIZE,
-                                 ath9k_hif_usb_rx_cb, rx_buf);
+                                 ath9k_hif_usb_rx_cb, skb);
 
                /* Anchor URB */
                usb_anchor_urb(urb, &hif_dev->rx_submitted);
@@ -897,8 +885,6 @@ static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
 err_skb:
        usb_free_urb(urb);
 err_urb:
-       kfree(rx_buf);
-err_rxb:
        ath9k_hif_usb_dealloc_rx_urbs(hif_dev);
        return ret;
 }
@@ -910,21 +896,14 @@ static void ath9k_hif_usb_dealloc_reg_in_urbs(struct hif_device_usb *hif_dev)
 
 static int ath9k_hif_usb_alloc_reg_in_urbs(struct hif_device_usb *hif_dev)
 {
-       struct rx_buf *rx_buf = NULL;
-       struct sk_buff *skb = NULL;
        struct urb *urb = NULL;
+       struct sk_buff *skb = NULL;
        int i, ret;
 
        init_usb_anchor(&hif_dev->reg_in_submitted);
 
        for (i = 0; i < MAX_REG_IN_URB_NUM; i++) {
 
-               rx_buf = kzalloc(sizeof(*rx_buf), GFP_KERNEL);
-               if (!rx_buf) {
-                       ret = -ENOMEM;
-                       goto err_rxb;
-               }
-
                /* Allocate URB */
                urb = usb_alloc_urb(0, GFP_KERNEL);
                if (urb == NULL) {
@@ -939,14 +918,11 @@ static int ath9k_hif_usb_alloc_reg_in_urbs(struct hif_device_usb *hif_dev)
                        goto err_skb;
                }
 
-               rx_buf->hif_dev = hif_dev;
-               rx_buf->skb = skb;
-
                usb_fill_int_urb(urb, hif_dev->udev,
                                  usb_rcvintpipe(hif_dev->udev,
                                                  USB_REG_IN_PIPE),
                                  skb->data, MAX_REG_IN_BUF_SIZE,
-                                 ath9k_hif_usb_reg_in_cb, rx_buf, 1);
+                                 ath9k_hif_usb_reg_in_cb, skb, 1);
 
                /* Anchor URB */
                usb_anchor_urb(urb, &hif_dev->reg_in_submitted);
@@ -972,8 +948,6 @@ static int ath9k_hif_usb_alloc_reg_in_urbs(struct hif_device_usb *hif_dev)
 err_skb:
        usb_free_urb(urb);
 err_urb:
-       kfree(rx_buf);
-err_rxb:
        ath9k_hif_usb_dealloc_reg_in_urbs(hif_dev);
        return ret;
 }
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index 5985aa15ca93..a94e7e1c86e9 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -86,11 +86,6 @@ struct tx_buf {
        struct list_head list;
 };
 
-struct rx_buf {
-       struct sk_buff *skb;
-       struct hif_device_usb *hif_dev;
-};
-
 #define HIF_USB_TX_STOP  BIT(0)
 #define HIF_USB_TX_FLUSH BIT(1)
 
