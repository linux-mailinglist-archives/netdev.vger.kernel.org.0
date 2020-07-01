Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D46211406
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 22:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgGAUEI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 1 Jul 2020 16:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbgGAUEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 16:04:07 -0400
X-Greylist: delayed 479 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 01 Jul 2020 13:04:07 PDT
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B265C08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 13:04:07 -0700 (PDT)
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by rin.romanrm.net (Postfix) with SMTP id EAD3C4B9;
        Wed,  1 Jul 2020 19:56:03 +0000 (UTC)
Date:   Thu, 2 Jul 2020 00:56:03 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Viktor =?UTF-8?B?SsOkZ2Vyc2vDvHBwZXI=?= 
        <viktor_jaegerskuepper@freenet.de>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Qiujun Huang <hqjagain@gmail.com>,
        ath9k-devel@qca.qualcomm.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, anenbupt@gmail.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] Revert "ath9k: Fix general protection fault in
 ath9k_hif_usb_rx_cb"
Message-ID: <20200702005603.495c5d98@natsu>
In-Reply-To: <53940af0-d156-3117-ac86-2f3ccaee9513@freenet.de>
References: <20200404041838.10426-1-hqjagain@gmail.com>
        <20200404041838.10426-6-hqjagain@gmail.com>
        <20200621020428.6417d6fb@natsu>
        <87lfkff9qe.fsf@codeaurora.org>
        <53940af0-d156-3117-ac86-2f3ccaee9513@freenet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Jul 2020 17:53:27 +0200
Viktor Jägersküpper <viktor_jaegerskuepper@freenet.de> wrote:

> Kalle Valo writes:
> > Roman Mamedov <rm@romanrm.net> writes:
> > 
> >> On Sat,  4 Apr 2020 12:18:38 +0800
> >> Qiujun Huang <hqjagain@gmail.com> wrote:
> >>
> >>> In ath9k_hif_usb_rx_cb interface number is assumed to be 0.
> >>> usb_ifnum_to_if(urb->dev, 0)
> >>> But it isn't always true.
> >>>
> >>> The case reported by syzbot:
> >>> https://lore.kernel.org/linux-usb/000000000000666c9c05a1c05d12@google.com
> >>> usb 2-1: new high-speed USB device number 2 using dummy_hcd
> >>> usb 2-1: config 1 has an invalid interface number: 2 but max is 0
> >>> usb 2-1: config 1 has no interface number 0
> >>> usb 2-1: New USB device found, idVendor=0cf3, idProduct=9271, bcdDevice=
> >>> 1.08
> >>> usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> >>> general protection fault, probably for non-canonical address
> >>> 0xdffffc0000000015: 0000 [#1] SMP KASAN
> >>> KASAN: null-ptr-deref in range [0x00000000000000a8-0x00000000000000af]
> >>> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.6.0-rc5-syzkaller #0
> >>>
> >>> Call Trace
> >>> __usb_hcd_giveback_urb+0x29a/0x550 drivers/usb/core/hcd.c:1650
> >>> usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1716
> >>> dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
> >>> call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
> >>> expire_timers kernel/time/timer.c:1449 [inline]
> >>> __run_timers kernel/time/timer.c:1773 [inline]
> >>> __run_timers kernel/time/timer.c:1740 [inline]
> >>> run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786
> >>> __do_softirq+0x21e/0x950 kernel/softirq.c:292
> >>> invoke_softirq kernel/softirq.c:373 [inline]
> >>> irq_exit+0x178/0x1a0 kernel/softirq.c:413
> >>> exiting_irq arch/x86/include/asm/apic.h:546 [inline]
> >>> smp_apic_timer_interrupt+0x141/0x540 arch/x86/kernel/apic/apic.c:1146
> >>> apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
> >>>
> >>> Reported-and-tested-by: syzbot+40d5d2e8a4680952f042@syzkaller.appspotmail.com
> >>> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
> >>
> >> This causes complete breakage of ath9k operation across all the stable kernel
> >> series it got backported to, and I guess the mainline as well. Please see:
> >> https://bugzilla.kernel.org/show_bug.cgi?id=208251
> >> https://bugzilla.redhat.com/show_bug.cgi?id=1848631
> > 
> > So there's no fix for this? I was under impression that someone fixed
> > this, but maybe I'm mixing with something else.
> > 
> > If this is not fixed can someone please submit a patch to revert the
> > offending commit (or commits) so that we get ath9k working again?
> > 
> 
> This reverts commit 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05 ("ath9k: Fix general protection fault
> in ath9k_hif_usb_rx_cb") because the driver gets stuck like this:
> 
>   [    5.778803] usb 1-5: Manufacturer: ATHEROS
>   [   21.697488] usb 1-5: ath9k_htc: Firmware ath9k_htc/htc_9271-1.4.0.fw requested
>   [   21.701377] usbcore: registered new interface driver ath9k_htc
>   [   22.053705] usb 1-5: ath9k_htc: Transferred FW: ath9k_htc/htc_9271-1.4.0.fw, size: 51008
>   [   22.306182] ath9k_htc 1-5:1.0: ath9k_htc: HTC initialized with 33 credits
>   [  115.708513] ath9k_htc: Failed to initialize the device
>   [  115.708683] usb 1-5: ath9k_htc: USB layer deinitialized
> 
> Reported-by: Roman Mamedov <rm@romanrm.net>
> Ref: https://bugzilla.kernel.org/show_bug.cgi?id=208251
> Fixes: 2bbcaaee1fcb ("ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb")
> Tested-by: Viktor Jägersküpper <viktor_jaegerskuepper@freenet.de>
> Signed-off-by: Viktor Jägersküpper <viktor_jaegerskuepper@freenet.de>
> ---
> 
> I couldn't find any fix for this, so here is the patch which reverts the
> offending commit. I have tested it with 5.8.0-rc3 and with 5.7.4.
> 
> Feel free to change the commit message if it is necessary or appropriate, I am
> just a user affected by this bug.
> 
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index 4ed21dad6a8e..6049d3766c64 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -643,9 +643,9 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
>  
>  static void ath9k_hif_usb_rx_cb(struct urb *urb)
>  {
> -       struct rx_buf *rx_buf = (struct rx_buf *)urb->context;
> -       struct hif_device_usb *hif_dev = rx_buf->hif_dev;
> -       struct sk_buff *skb = rx_buf->skb;
> +       struct sk_buff *skb = (struct sk_buff *) urb->context;
> +       struct hif_device_usb *hif_dev =
> +               usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));

It seems like line indentations are wrong in this one, you always use spaces
to indent, and not what the file or the patch being reverted originally used.

It does not apply for me, compared to reverting the offending commit outright:

$ patch --dry-run -p1 -R < bad-commit.patch 
checking file drivers/net/wireless/ath/ath9k/hif_usb.c
checking file drivers/net/wireless/ath/ath9k/hif_usb.h

$ patch --dry-run -p1 < viktor.patch 
checking file drivers/net/wireless/ath/ath9k/hif_usb.c
Hunk #1 FAILED at 643.
Hunk #2 FAILED at 685.
Hunk #3 FAILED at 751.
Hunk #4 FAILED at 797.
Hunk #5 FAILED at 834.
Hunk #6 FAILED at 844.
Hunk #7 FAILED at 864.
Hunk #8 FAILED at 897.
Hunk #9 FAILED at 910.
Hunk #10 FAILED at 939.
Hunk #11 FAILED at 972.
11 out of 11 hunks FAILED
checking file drivers/net/wireless/ath/ath9k/hif_usb.h
Reversed (or previously applied) patch detected!  Assume -R? [n] ^C

If you will submit a fixed one, perhaps it should be a "v2" now, and doesn't
need to quote all the prior conversation (patches don't generally do that) or
add extra comments after "Signed-off-by" (already done). But I'm also mostly
just a user and not an expert on these matters. :)

-- 
With respect,
Roman
