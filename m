Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 445D243F58A
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 05:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhJ2DzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 23:55:14 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:57540 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbhJ2DzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 23:55:13 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635479565; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=E6TbmtpcqjlLnVfky9lLPvKer7B+7CluEi37vqoEqT8=; b=kSY0s1W+EXc6sOXULfPzSU2U2v4xRrQQz4sVtyYmxJdgW25/2swajbvahK4FqilJGvyZ9bbt
 UVEeWT+7o6Dhgf3bcPVV4i+XOCB1hLxHGR+GZp/iiZ/uO5DUMsQmLDN48bFizpLq+bTSsSoV
 XUEQtsELCxBGroZZdLEWjVA0UYs=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 617b7005aeb23905566e5dc9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 29 Oct 2021 03:52:37
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9B83DC4360D; Fri, 29 Oct 2021 03:52:37 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 55B51C4338F;
        Fri, 29 Oct 2021 03:52:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 55B51C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Zekun Shen <bruceshenzk@gmail.com>
Cc:     ath9k-devel@qca.qualcomm.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: Fix out-of-bound memcpy in ath9k_hif_usb_rx_stream
References: <YXsidrRuK6zBJicZ@10-18-43-117.dynapool.wireless.nyu.edu>
Date:   Fri, 29 Oct 2021 06:52:31 +0300
In-Reply-To: <YXsidrRuK6zBJicZ@10-18-43-117.dynapool.wireless.nyu.edu> (Zekun
        Shen's message of "Thu, 28 Oct 2021 18:21:42 -0400")
Message-ID: <87y26cxzb4.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zekun Shen <bruceshenzk@gmail.com> writes:

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
> Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>

How did you test this?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
