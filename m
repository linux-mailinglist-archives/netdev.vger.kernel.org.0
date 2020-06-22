Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8882039AA
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 16:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729338AbgFVOgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 10:36:55 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:55320 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729318AbgFVOgy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 10:36:54 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1592836613; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=JSt09Fbrzf0H+Eep97NqWj/jsb72fCfRDnOyEo7TatI=; b=Bhur4cKR9SuKUJhxxCrLmQrZrIPCzvXjugxfV40SXdPJ8VNd7I/d+dyTm7wRyiy32Qbt0e5/
 7q1Ed+yrOl88S8lVEaUr5+2a2TRaG/at6DSY7sUkyNJ/NcAJs/BPhuOHeN7v/str+gGmn7mU
 Qi6OVKcG0tt7plTFB8iNAoxMWa4=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5ef0c1ffa3d8a4474323a509 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 22 Jun 2020 14:36:47
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 85EF2C433CB; Mon, 22 Jun 2020 14:36:46 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7E361C433CA;
        Mon, 22 Jun 2020 14:36:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7E361C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Roman Mamedov <rm@romanrm.net>
Cc:     Qiujun Huang <hqjagain@gmail.com>, ath9k-devel@qca.qualcomm.com,
        davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        anenbupt@gmail.com, syzkaller-bugs@googlegroups.com
Subject: Re: [BISECTED REGRESSION] ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
References: <20200404041838.10426-1-hqjagain@gmail.com>
        <20200404041838.10426-6-hqjagain@gmail.com>
        <20200621020428.6417d6fb@natsu>
Date:   Mon, 22 Jun 2020 17:36:41 +0300
In-Reply-To: <20200621020428.6417d6fb@natsu> (Roman Mamedov's message of "Sun,
        21 Jun 2020 02:04:28 +0500")
Message-ID: <87lfkff9qe.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Roman Mamedov <rm@romanrm.net> writes:

> On Sat,  4 Apr 2020 12:18:38 +0800
> Qiujun Huang <hqjagain@gmail.com> wrote:
>
>> In ath9k_hif_usb_rx_cb interface number is assumed to be 0.
>> usb_ifnum_to_if(urb->dev, 0)
>> But it isn't always true.
>> 
>> The case reported by syzbot:
>> https://lore.kernel.org/linux-usb/000000000000666c9c05a1c05d12@google.com
>> usb 2-1: new high-speed USB device number 2 using dummy_hcd
>> usb 2-1: config 1 has an invalid interface number: 2 but max is 0
>> usb 2-1: config 1 has no interface number 0
>> usb 2-1: New USB device found, idVendor=0cf3, idProduct=9271, bcdDevice=
>> 1.08
>> usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>> general protection fault, probably for non-canonical address
>> 0xdffffc0000000015: 0000 [#1] SMP KASAN
>> KASAN: null-ptr-deref in range [0x00000000000000a8-0x00000000000000af]
>> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.6.0-rc5-syzkaller #0
>> 
>> Call Trace
>> __usb_hcd_giveback_urb+0x29a/0x550 drivers/usb/core/hcd.c:1650
>> usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1716
>> dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
>> call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
>> expire_timers kernel/time/timer.c:1449 [inline]
>> __run_timers kernel/time/timer.c:1773 [inline]
>> __run_timers kernel/time/timer.c:1740 [inline]
>> run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786
>> __do_softirq+0x21e/0x950 kernel/softirq.c:292
>> invoke_softirq kernel/softirq.c:373 [inline]
>> irq_exit+0x178/0x1a0 kernel/softirq.c:413
>> exiting_irq arch/x86/include/asm/apic.h:546 [inline]
>> smp_apic_timer_interrupt+0x141/0x540 arch/x86/kernel/apic/apic.c:1146
>> apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
>> 
>> Reported-and-tested-by: syzbot+40d5d2e8a4680952f042@syzkaller.appspotmail.com
>> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
>
> This causes complete breakage of ath9k operation across all the stable kernel
> series it got backported to, and I guess the mainline as well. Please see:
> https://bugzilla.kernel.org/show_bug.cgi?id=208251
> https://bugzilla.redhat.com/show_bug.cgi?id=1848631

So there's no fix for this? I was under impression that someone fixed
this, but maybe I'm mixing with something else.

If this is not fixed can someone please submit a patch to revert the
offending commit (or commits) so that we get ath9k working again?

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
