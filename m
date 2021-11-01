Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1AE2441C4B
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 15:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhKAON4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 10:13:56 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:59130 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232467AbhKAONz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 10:13:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635775882; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=r/vD9nDcJRJEJFPS9hrIRfMxd0yRef0RBWbVCTlCfco=; b=SANHdMcL0OpK0wYcN3X6JDiDamA3bsxOnsM7OnsoYGacbo9IqmH4en3ObKBitYMfL7rD8NqM
 XZ3WfgOXu6G1JQXHC8Z0OHX/jabchPnFQszT6IEttzsWp1kmaQLfVdUwluyV0hEtaq7Fowuc
 Wem0KiNJ0slaiIYNjVoRIe723wQ=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 617ff4c5c8c1b282a5dea743 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 01 Nov 2021 14:08:05
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4012FC43619; Mon,  1 Nov 2021 14:08:05 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 23272C4338F;
        Mon,  1 Nov 2021 14:08:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 23272C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Zekun Shen <bruceshenzk@gmail.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, brendandg@nyu.edu
Subject: Re: [PATCH] mwifiex_usb: Fix skb_over_panic in mwifiex_usb_recv
References: <YX4CqjfRcTa6bVL+@Zekuns-MBP-16.fios-router.home>
Date:   Mon, 01 Nov 2021 16:07:59 +0200
In-Reply-To: <YX4CqjfRcTa6bVL+@Zekuns-MBP-16.fios-router.home> (Zekun Shen's
        message of "Sat, 30 Oct 2021 22:42:50 -0400")
Message-ID: <87pmrk0y0w.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zekun Shen <bruceshenzk@gmail.com> writes:

> Currently, with an unknown recv_type, mwifiex_usb_recv
> just return -1 without restoring the skb. Next time
> mwifiex_usb_rx_complete is invoked with the same skb,
> calling skb_put causes skb_over_panic.
>
> The bug is triggerable with a compromised/malfunctioning
> usb device. After applying the patch, skb_over_panic
> no longer shows up with the same input.
>
> Attached is the panic report from fuzzing.
> skbuff: skb_over_panic: text:000000003bf1b5fa
>  len:2048 put:4 head:00000000dd6a115b data:000000000a9445d8
>  tail:0x844 end:0x840 dev:<NULL>
> kernel BUG at net/core/skbuff.c:109!
> invalid opcode: 0000 [#1] SMP KASAN NOPTI
> CPU: 0 PID: 198 Comm: in:imklog Not tainted 5.6.0 #60
> RIP: 0010:skb_panic+0x15f/0x161
> Call Trace:
>  <IRQ>
>  ? mwifiex_usb_rx_complete+0x26b/0xfcd [mwifiex_usb]
>  skb_put.cold+0x24/0x24
>  mwifiex_usb_rx_complete+0x26b/0xfcd [mwifiex_usb]
>  __usb_hcd_giveback_urb+0x1e4/0x380
>  usb_giveback_urb_bh+0x241/0x4f0
>  ? __hrtimer_run_queues+0x316/0x740
>  ? __usb_hcd_giveback_urb+0x380/0x380
>  tasklet_action_common.isra.0+0x135/0x330
>  __do_softirq+0x18c/0x634
>  irq_exit+0x114/0x140
>  smp_apic_timer_interrupt+0xde/0x380
>  apic_timer_interrupt+0xf/0x20
>  </IRQ>
>
> Reported-by: Zekun Shen <bruceshenzk@gmail.com>

You are the author, no need to have your name in Reported-by.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
