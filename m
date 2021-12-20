Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C54847B0EA
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 17:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbhLTQJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 11:09:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49732 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbhLTQJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 11:09:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9933761221;
        Mon, 20 Dec 2021 16:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C79CC36AE2;
        Mon, 20 Dec 2021 16:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640016574;
        bh=jZHacZczCLz10XaI5dqoB8mx0uloJKeuJmcq3dzCOd4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=NdoblXwBBryhWsTxVKUuxRsufUOQ3Fo/AiKNa3R1BNgSZhSQSzxGsHfEx9whlR3sL
         N2aPBIJFq3J8/q8PGEwF8utAI6jXm7F7bbipf/Z+pP3qF/gSP1+3ncy7DmS71x18e/
         eZn9/30M61ldvBiZEatAty9l3FX+ATxKEwu8dowAeluldP1rCnY6ZUgRFCvbhnWX6z
         9fzHrV80i6uMZDnZ7JjYS0lVmZA8x7vcZ6BXJMghMSA7wd6G/jDyeDodeQ7l0joC5D
         qxPUT4MEUkr0k4tdt/gbjzXrhEwdUpNhTtSTnl9AvoG+MQinGk+54IqKG3kh1kIk5l
         kKWIOCVebJtRQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k: Fix out-of-bound memcpy in ath9k_hif_usb_rx_stream
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <YXsidrRuK6zBJicZ@10-18-43-117.dynapool.wireless.nyu.edu>
References: <YXsidrRuK6zBJicZ@10-18-43-117.dynapool.wireless.nyu.edu>
To:     Zekun Shen <bruceshenzk@gmail.com>
Cc:     bruceshenzk@gmail.com, ath9k-devel@qca.qualcomm.com,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164001657045.2023.708125278760304394.kvalo@kernel.org>
Date:   Mon, 20 Dec 2021 16:09:31 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zekun Shen <bruceshenzk@gmail.com> wrote:

> Large pkt_len can lead to out-out-bound memcpy. Current
> ath9k_hif_usb_rx_stream allows combining the content of two urb
> inputs to one pkt. The first input can indicate the size of the
> pkt. Any remaining size is saved in hif_dev->rx_remain_len.
> While processing the next input, memcpy is used with rx_remain_len.
> 
> 4-byte pkt_len can go up to 0xffff, while a single input is 0x4000
> maximum in size (MAX_RX_BUF_SIZE). Thus, the patch adds a check for
> pkt_len which must not exceed 2 * MAX_RX_BUG_SIZE.
> 
> BUG: KASAN: slab-out-of-bounds in ath9k_hif_usb_rx_cb+0x490/0xed7 [ath9k_htc]
> Read of size 46393 at addr ffff888018798000 by task kworker/0:1/23
> 
> CPU: 0 PID: 23 Comm: kworker/0:1 Not tainted 5.6.0 #63
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS rel-1.10.2-0-g5f4c7b1-prebuilt.qemu-project.org 04/01/2014
> Workqueue: events request_firmware_work_func
> Call Trace:
>  <IRQ>
>  dump_stack+0x76/0xa0
>  print_address_description.constprop.0+0x16/0x200
>  ? ath9k_hif_usb_rx_cb+0x490/0xed7 [ath9k_htc]
>  ? ath9k_hif_usb_rx_cb+0x490/0xed7 [ath9k_htc]
>  __kasan_report.cold+0x37/0x7c
>  ? ath9k_hif_usb_rx_cb+0x490/0xed7 [ath9k_htc]
>  kasan_report+0xe/0x20
>  check_memory_region+0x15a/0x1d0
>  memcpy+0x20/0x50
>  ath9k_hif_usb_rx_cb+0x490/0xed7 [ath9k_htc]
>  ? hif_usb_mgmt_cb+0x2d9/0x2d9 [ath9k_htc]
>  ? _raw_spin_lock_irqsave+0x7b/0xd0
>  ? _raw_spin_trylock_bh+0x120/0x120
>  ? __usb_unanchor_urb+0x12f/0x210
>  __usb_hcd_giveback_urb+0x1e4/0x380
>  usb_giveback_urb_bh+0x241/0x4f0
>  ? __hrtimer_run_queues+0x316/0x740
>  ? __usb_hcd_giveback_urb+0x380/0x380
>  tasklet_action_common.isra.0+0x135/0x330
>  __do_softirq+0x18c/0x634
>  irq_exit+0x114/0x140
>  smp_apic_timer_interrupt+0xde/0x380
>  apic_timer_interrupt+0xf/0x20
> 
> I found the bug using a custome USBFuzz port. It's a research work
> to fuzz USB stack/drivers. I modified it to fuzz ath9k driver only,
> providing hand-crafted usb descriptors to QEMU.
> 
> After fixing the value of pkt_tag to ATH_USB_RX_STREAM_MODE_TAG in QEMU
> emulation, I found the KASAN report. The bug is triggerable whenever
> pkt_len is above two MAX_RX_BUG_SIZE. I used the same input that crashes
> to test the driver works when applying the patch.
> 
> Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

6ce708f54cc8 ath9k: Fix out-of-bound memcpy in ath9k_hif_usb_rx_stream

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/YXsidrRuK6zBJicZ@10-18-43-117.dynapool.wireless.nyu.edu/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

