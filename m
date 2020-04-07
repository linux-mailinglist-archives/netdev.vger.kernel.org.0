Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCA081A0605
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 07:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgDGFBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 01:01:44 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:64252 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726030AbgDGFBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 01:01:43 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586235702; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=jt0Tk8pFpcuNkX69+BRAOWUABI4M2KygUuVbL9SWXck=;
 b=HEdS5b2wSdnJb3g6JB2tV4Mwj5JJZKjI21TP1yVUH7Bw/dyKPioeAsrYqlCFAfU9NQ+QVUS3
 px+ZkkjoodYCBmzR2Uv9lGaSNtOEkRnJtTvdB3govTwLOqJF5LFyKYTzA0H4oLijqdnLgRSz
 txYe+a04+I3LGN6T/SyswIERzG0=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e8c0936.7f2ed250d538-smtp-out-n01;
 Tue, 07 Apr 2020 05:01:42 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 09CFAC433D2; Tue,  7 Apr 2020 05:01:42 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 947B3C433BA;
        Tue,  7 Apr 2020 05:01:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 947B3C433BA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/5] ath9k: Fix use-after-free Read in htc_connect_service
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200404041838.10426-2-hqjagain@gmail.com>
References: <20200404041838.10426-2-hqjagain@gmail.com>
To:     Qiujun Huang <hqjagain@gmail.com>
Cc:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, anenbupt@gmail.com,
        syzkaller-bugs@googlegroups.com, Qiujun Huang <hqjagain@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200407050142.09CFAC433D2@smtp.codeaurora.org>
Date:   Tue,  7 Apr 2020 05:01:42 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Qiujun Huang <hqjagain@gmail.com> wrote:

> The skb is consumed by htc_send_epid, so it needn't release again.
> 
> The case reported by syzbot:
> 
> https://lore.kernel.org/linux-usb/000000000000590f6b05a1c05d15@google.com
> usb 1-1: ath9k_htc: Firmware ath9k_htc/htc_9271-1.4.0.fw requested
> usb 1-1: ath9k_htc: Transferred FW: ath9k_htc/htc_9271-1.4.0.fw, size:
> 51008
> usb 1-1: Service connection timeout for: 256
> ==================================================================
> BUG: KASAN: use-after-free in atomic_read
> include/asm-generic/atomic-instrumented.h:26 [inline]
> BUG: KASAN: use-after-free in refcount_read include/linux/refcount.h:134
> [inline]
> BUG: KASAN: use-after-free in skb_unref include/linux/skbuff.h:1042
> [inline]
> BUG: KASAN: use-after-free in kfree_skb+0x32/0x3d0 net/core/skbuff.c:692
> Read of size 4 at addr ffff8881d0957994 by task kworker/1:2/83
> 
> Call Trace:
> kfree_skb+0x32/0x3d0 net/core/skbuff.c:692
> htc_connect_service.cold+0xa9/0x109
> drivers/net/wireless/ath/ath9k/htc_hst.c:282
> ath9k_wmi_connect+0xd2/0x1a0 drivers/net/wireless/ath/ath9k/wmi.c:265
> ath9k_init_htc_services.constprop.0+0xb4/0x650
> drivers/net/wireless/ath/ath9k/htc_drv_init.c:146
> ath9k_htc_probe_device+0x25a/0x1d80
> drivers/net/wireless/ath/ath9k/htc_drv_init.c:959
> ath9k_htc_hw_init+0x31/0x60
> drivers/net/wireless/ath/ath9k/htc_hst.c:501
> ath9k_hif_usb_firmware_cb+0x26b/0x500
> drivers/net/wireless/ath/ath9k/hif_usb.c:1187
> request_firmware_work_func+0x126/0x242
> drivers/base/firmware_loader/main.c:976
> process_one_work+0x94b/0x1620 kernel/workqueue.c:2264
> worker_thread+0x96/0xe20 kernel/workqueue.c:2410
> kthread+0x318/0x420 kernel/kthread.c:255
> ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> 
> Allocated by task 83:
> kmem_cache_alloc_node+0xdc/0x330 mm/slub.c:2814
> __alloc_skb+0xba/0x5a0 net/core/skbuff.c:198
> alloc_skb include/linux/skbuff.h:1081 [inline]
> htc_connect_service+0x2cc/0x840
> drivers/net/wireless/ath/ath9k/htc_hst.c:257
> ath9k_wmi_connect+0xd2/0x1a0 drivers/net/wireless/ath/ath9k/wmi.c:265
> ath9k_init_htc_services.constprop.0+0xb4/0x650
> drivers/net/wireless/ath/ath9k/htc_drv_init.c:146
> ath9k_htc_probe_device+0x25a/0x1d80
> drivers/net/wireless/ath/ath9k/htc_drv_init.c:959
> ath9k_htc_hw_init+0x31/0x60
> drivers/net/wireless/ath/ath9k/htc_hst.c:501
> ath9k_hif_usb_firmware_cb+0x26b/0x500
> drivers/net/wireless/ath/ath9k/hif_usb.c:1187
> request_firmware_work_func+0x126/0x242
> drivers/base/firmware_loader/main.c:976
> process_one_work+0x94b/0x1620 kernel/workqueue.c:2264
> worker_thread+0x96/0xe20 kernel/workqueue.c:2410
> kthread+0x318/0x420 kernel/kthread.c:255
> ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> 
> Freed by task 0:
> kfree_skb+0x102/0x3d0 net/core/skbuff.c:690
> ath9k_htc_txcompletion_cb+0x1f8/0x2b0
> drivers/net/wireless/ath/ath9k/htc_hst.c:356
> hif_usb_regout_cb+0x10b/0x1b0
> drivers/net/wireless/ath/ath9k/hif_usb.c:90
> __usb_hcd_giveback_urb+0x29a/0x550 drivers/usb/core/hcd.c:1650
> usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1716
> dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
> call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
> expire_timers kernel/time/timer.c:1449 [inline]
> __run_timers kernel/time/timer.c:1773 [inline]
> __run_timers kernel/time/timer.c:1740 [inline]
> run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786
> __do_softirq+0x21e/0x950 kernel/softirq.c:292
> 
> Reported-and-tested-by: syzbot+9505af1ae303dabdc646@syzkaller.appspotmail.com
> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

5 patches applied to ath-next branch of ath.git, thanks.

ced21a4c726b ath9k: Fix use-after-free Read in htc_connect_service
abeaa85054ff ath9k: Fix use-after-free Read in ath9k_wmi_ctrl_rx
e4ff08a4d727 ath9k: Fix use-after-free Write in ath9k_htc_rx_msg
19d6c375d671 ath9x: Fix stack-out-of-bounds Write in ath9k_hif_usb_rx_cb
2bbcaaee1fcb ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb

-- 
https://patchwork.kernel.org/patch/11474039/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
