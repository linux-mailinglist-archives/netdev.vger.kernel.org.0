Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0088821A244
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 16:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgGIOjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 10:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgGIOjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 10:39:10 -0400
Received: from mout1.freenet.de (mout1.freenet.de [IPv6:2001:748:100:40::2:3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614EEC08C5CE;
        Thu,  9 Jul 2020 07:39:10 -0700 (PDT)
Received: from [195.4.92.163] (helo=mjail0.freenet.de)
        by mout1.freenet.de with esmtpa (ID viktor.jaegerskuepper@freenet.de) (port 25) (Exim 4.92 #3)
        id 1jtXhY-0000fE-Jj; Thu, 09 Jul 2020 16:39:04 +0200
Received: from localhost ([::1]:43698 helo=mjail0.freenet.de)
        by mjail0.freenet.de with esmtpa (ID viktor.jaegerskuepper@freenet.de) (Exim 4.92 #3)
        id 1jtXhY-0001zB-HJ; Thu, 09 Jul 2020 16:39:04 +0200
Received: from sub4.freenet.de ([195.4.92.123]:55558)
        by mjail0.freenet.de with esmtpa (ID viktor.jaegerskuepper@freenet.de) (Exim 4.92 #3)
        id 1jtXf7-0000ot-KE; Thu, 09 Jul 2020 16:36:33 +0200
Received: from p200300e7072d05009530c91dafb9c844.dip0.t-ipconnect.de ([2003:e7:72d:500:9530:c91d:afb9:c844]:35596 helo=[127.0.0.1])
        by sub4.freenet.de with esmtpsa (ID viktor.jaegerskuepper@freenet.de) (TLSv1.2:ECDHE-RSA-CHACHA20-POLY1305:256) (port 465) (Exim 4.92 #3)
        id 1jtXf7-0006kg-GW; Thu, 09 Jul 2020 16:36:33 +0200
Subject: Re: [PATCH] Revert "ath9k: Fix general protection fault in
 ath9k_hif_usb_rx_cb"
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Roman Mamedov <rm@romanrm.net>, Qiujun Huang <hqjagain@gmail.com>,
        ath9k-devel@qca.qualcomm.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, anenbupt@gmail.com,
        syzkaller-bugs@googlegroups.com
References: <20200404041838.10426-1-hqjagain@gmail.com>
 <20200404041838.10426-6-hqjagain@gmail.com> <20200621020428.6417d6fb@natsu>
 <87lfkff9qe.fsf@codeaurora.org>
 <53940af0-d156-3117-ac86-2f3ccaee9513@freenet.de>
 <87imf6beo0.fsf@codeaurora.org>
From:   =?UTF-8?B?VmlrdG9yIErDpGdlcnNrw7xwcGVy?= 
        <viktor_jaegerskuepper@freenet.de>
Message-ID: <abb99acd-e001-6e80-4d46-fae5ad3887f6@freenet.de>
Date:   Thu, 9 Jul 2020 16:36:24 +0200
MIME-Version: 1.0
In-Reply-To: <87imf6beo0.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
X-Originated-At: 2003:e7:72d:500:9530:c91d:afb9:c844!35596
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo wrote:
> Viktor Jägersküpper <viktor_jaegerskuepper@freenet.de> writes:
> 
>> Kalle Valo writes:
>>> Roman Mamedov <rm@romanrm.net> writes:
>>>
>>>> On Sat,  4 Apr 2020 12:18:38 +0800
>>>> Qiujun Huang <hqjagain@gmail.com> wrote:
>>>>
>>>>> In ath9k_hif_usb_rx_cb interface number is assumed to be 0.
>>>>> usb_ifnum_to_if(urb->dev, 0)
>>>>> But it isn't always true.
>>>>>
>>>>> The case reported by syzbot:
>>>>> https://lore.kernel.org/linux-usb/000000000000666c9c05a1c05d12@google.com
>>>>> usb 2-1: new high-speed USB device number 2 using dummy_hcd
>>>>> usb 2-1: config 1 has an invalid interface number: 2 but max is 0
>>>>> usb 2-1: config 1 has no interface number 0
>>>>> usb 2-1: New USB device found, idVendor=0cf3, idProduct=9271, bcdDevice=
>>>>> 1.08
>>>>> usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>>>>> general protection fault, probably for non-canonical address
>>>>> 0xdffffc0000000015: 0000 [#1] SMP KASAN
>>>>> KASAN: null-ptr-deref in range [0x00000000000000a8-0x00000000000000af]
>>>>> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.6.0-rc5-syzkaller #0
>>>>>
>>>>> Call Trace
>>>>> __usb_hcd_giveback_urb+0x29a/0x550 drivers/usb/core/hcd.c:1650
>>>>> usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1716
>>>>> dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
>>>>> call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
>>>>> expire_timers kernel/time/timer.c:1449 [inline]
>>>>> __run_timers kernel/time/timer.c:1773 [inline]
>>>>> __run_timers kernel/time/timer.c:1740 [inline]
>>>>> run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786
>>>>> __do_softirq+0x21e/0x950 kernel/softirq.c:292
>>>>> invoke_softirq kernel/softirq.c:373 [inline]
>>>>> irq_exit+0x178/0x1a0 kernel/softirq.c:413
>>>>> exiting_irq arch/x86/include/asm/apic.h:546 [inline]
>>>>> smp_apic_timer_interrupt+0x141/0x540 arch/x86/kernel/apic/apic.c:1146
>>>>> apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
>>>>>
>>>>> Reported-and-tested-by: syzbot+40d5d2e8a4680952f042@syzkaller.appspotmail.com
>>>>> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
>>>>
>>>> This causes complete breakage of ath9k operation across all the stable kernel
>>>> series it got backported to, and I guess the mainline as well. Please see:
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=208251
>>>> https://bugzilla.redhat.com/show_bug.cgi?id=1848631
>>>
>>> So there's no fix for this? I was under impression that someone fixed
>>> this, but maybe I'm mixing with something else.
>>>
>>> If this is not fixed can someone please submit a patch to revert the
>>> offending commit (or commits) so that we get ath9k working again?
>>>
>>
>> This reverts commit 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05 ("ath9k: Fix general protection fault
>> in ath9k_hif_usb_rx_cb") because the driver gets stuck like this:
>>
>>   [    5.778803] usb 1-5: Manufacturer: ATHEROS
>>   [   21.697488] usb 1-5: ath9k_htc: Firmware ath9k_htc/htc_9271-1.4.0.fw requested
>>   [   21.701377] usbcore: registered new interface driver ath9k_htc
>>   [   22.053705] usb 1-5: ath9k_htc: Transferred FW: ath9k_htc/htc_9271-1.4.0.fw, size: 51008
>>   [   22.306182] ath9k_htc 1-5:1.0: ath9k_htc: HTC initialized with 33 credits
>>   [  115.708513] ath9k_htc: Failed to initialize the device
>>   [  115.708683] usb 1-5: ath9k_htc: USB layer deinitialized
>>
>> Reported-by: Roman Mamedov <rm@romanrm.net>
>> Ref: https://bugzilla.kernel.org/show_bug.cgi?id=208251
>> Fixes: 2bbcaaee1fcb ("ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb")
>> Tested-by: Viktor Jägersküpper <viktor_jaegerskuepper@freenet.de>
>> Signed-off-by: Viktor Jägersküpper <viktor_jaegerskuepper@freenet.de>
>> ---
>>
>> I couldn't find any fix for this, so here is the patch which reverts the
>> offending commit. I have tested it with 5.8.0-rc3 and with 5.7.4.
>>
>> Feel free to change the commit message if it is necessary or appropriate, I am
>> just a user affected by this bug.
> 
> This was badly formatted:
> 
> https://patchwork.kernel.org/patch/11636783/
> 
> But v2 looks correct:
> 
> https://patchwork.kernel.org/patch/11637341/
> 
> Thanks, I'll take a closer look at this as soon as I can.
> 

Hi Kalle,

it seems you didn't have time for this so far. If you don't have time at the
moment, is there someone else who can fix this? Reverting the commit is just the
first and easy option and fixing this properly can be done after that.

Thanks,
Viktor
