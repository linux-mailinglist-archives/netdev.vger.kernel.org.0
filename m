Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69FBB44644F
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 14:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbhKENpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 09:45:23 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:37693 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbhKENpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 09:45:22 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1636119763; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=97JDROl6nekEmikx5XRgFoJpVnsjC7pw9N4FbxjAHmg=;
 b=GBJZGgTWU609dNZky0B7Xb0v8uV7z9JCxSTJ4+vXLdIh2ZvyX7C5M7zMeLcfg6qgz0tnUxEz
 ogdNSDy52h4dKrGq/+JiljLtO2DbGpsdEwSGyxb+8lenh0waW7DVf34s88uELaurwrmCNtq7
 8aZnTYW+u1s6RchX28Xb2ltUkME=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 618534d1045d18c075fd4086 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 05 Nov 2021 13:42:41
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7BB9EC43618; Fri,  5 Nov 2021 13:42:40 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CD44EC4338F;
        Fri,  5 Nov 2021 13:42:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org CD44EC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k: Fix out-of-bound memcpy in ath9k_hif_usb_rx_stream
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <YXsidrRuK6zBJicZ@10-18-43-117.dynapool.wireless.nyu.edu>
References: <YXsidrRuK6zBJicZ@10-18-43-117.dynapool.wireless.nyu.edu>
To:     Zekun Shen <bruceshenzk@gmail.com>
Cc:     bruceshenzk@gmail.com, ath9k-devel@qca.qualcomm.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163611975427.24604.10345795952487961567.kvalo@codeaurora.org>
Date:   Fri,  5 Nov 2021 13:42:40 +0000 (UTC)
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
> Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>

I need to test this myself.

Patch set to Deferred.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/YXsidrRuK6zBJicZ@10-18-43-117.dynapool.wireless.nyu.edu/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

