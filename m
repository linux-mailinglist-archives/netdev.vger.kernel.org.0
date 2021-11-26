Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E83B45F1E6
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 17:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378377AbhKZQel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 11:34:41 -0500
Received: from so254-9.mailgun.net ([198.61.254.9]:56826 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234797AbhKZQcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 11:32:41 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1637944168; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=i7y3RRobBe8VK1BX5sog636WKlL725Ft5yrwsnRQyeE=;
 b=IUYzkG/Qbw+rq4sSbu9IuNvvBmKpeNOwbE2pN7Q4P/FeF3vRvLHKSrDya/NiVtIygxLnowzt
 sdXNfbIDrGLWhm29hO8c3KV97vPl6IqoGgx7GGmX5jJHAMK5YnJII2Rw4SQpliJDtV/aUCvT
 WriVQcGV28ly4fvqdCsVUhFTCZo=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 61a10b611abc6f02d0d37284 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 26 Nov 2021 16:29:21
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9C2C2C43618; Fri, 26 Nov 2021 16:29:20 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 16F58C4338F;
        Fri, 26 Nov 2021 16:29:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 16F58C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: mwifiex: Fix skb_over_panic in mwifiex_usb_recv()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <YX4CqjfRcTa6bVL+@Zekuns-MBP-16.fios-router.home>
References: <YX4CqjfRcTa6bVL+@Zekuns-MBP-16.fios-router.home>
To:     Zekun Shen <bruceshenzk@gmail.com>
Cc:     bruceshenzk@gmail.com, Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, brendandg@nyu.edu
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163794415190.10370.9116173861853655389.kvalo@codeaurora.org>
Date:   Fri, 26 Nov 2021 16:29:20 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zekun Shen <bruceshenzk@gmail.com> wrote:

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
> Reported-by: Brendan Dolan-Gavitt <brendandg@nyu.edu>
> Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

04d80663f67c mwifiex: Fix skb_over_panic in mwifiex_usb_recv()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/YX4CqjfRcTa6bVL+@Zekuns-MBP-16.fios-router.home/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

