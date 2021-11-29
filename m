Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3894612C9
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 11:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352490AbhK2Ksy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 05:48:54 -0500
Received: from so254-9.mailgun.net ([198.61.254.9]:36032 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351301AbhK2Kqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 05:46:54 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1638182616; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=KDEueJuZ/qunvbMBJmEsrbgcZilnFPukYMrEY6XOGsA=;
 b=mYT67lhzuRBzXzMjPUz0gg+piHGkLjRqmkTY0lmiM99pUlPLxzmx2BElhZGtM4iqYkSP5EeM
 h4TMk4GuRX+E4yKvW6YMhWJ6E710tFG8vU2sFs13Pn/2YB74cpnZUJuENmIGAfa1yOXO1Byu
 DSXCTasRDBK5cSGJQr6cfdj4huU=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 61a4aed8e7d68470af9ef1f7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 29 Nov 2021 10:43:36
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A868EC43618; Mon, 29 Nov 2021 10:43:35 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A7339C4338F;
        Mon, 29 Nov 2021 10:43:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org A7339C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: rsi: Fix use-after-free in rsi_rx_done_handler()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <YXxQL/vIiYcZUu/j@10-18-43-117.dynapool.wireless.nyu.edu>
References: <YXxQL/vIiYcZUu/j@10-18-43-117.dynapool.wireless.nyu.edu>
To:     Zekun Shen <bruceshenzk@gmail.com>
Cc:     bruceshenzk@gmail.com, Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, brendandg@nyu.edu
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163818261048.17830.10234717976356726248.kvalo@codeaurora.org>
Date:   Mon, 29 Nov 2021 10:43:35 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zekun Shen <bruceshenzk@gmail.com> wrote:

> When freeing rx_cb->rx_skb, the pointer is not set to NULL,
> a later rsi_rx_done_handler call will try to read the freed
> address.
> This bug will very likley lead to double free, although
> detected early as use-after-free bug.
> 
> The bug is triggerable with a compromised/malfunctional usb
> device. After applying the patch, the same input no longer
> triggers the use-after-free.
> 
> Attached is the kasan report from fuzzing.
> 
> BUG: KASAN: use-after-free in rsi_rx_done_handler+0x354/0x430 [rsi_usb]
> Read of size 4 at addr ffff8880188e5930 by task modprobe/231
> Call Trace:
>  <IRQ>
>  dump_stack+0x76/0xa0
>  print_address_description.constprop.0+0x16/0x200
>  ? rsi_rx_done_handler+0x354/0x430 [rsi_usb]
>  ? rsi_rx_done_handler+0x354/0x430 [rsi_usb]
>  __kasan_report.cold+0x37/0x7c
>  ? dma_direct_unmap_page+0x90/0x110
>  ? rsi_rx_done_handler+0x354/0x430 [rsi_usb]
>  kasan_report+0xe/0x20
>  rsi_rx_done_handler+0x354/0x430 [rsi_usb]
>  __usb_hcd_giveback_urb+0x1e4/0x380
>  usb_giveback_urb_bh+0x241/0x4f0
>  ? __usb_hcd_giveback_urb+0x380/0x380
>  ? apic_timer_interrupt+0xa/0x20
>  tasklet_action_common.isra.0+0x135/0x330
>  __do_softirq+0x18c/0x634
>  ? handle_irq_event+0xcd/0x157
>  ? handle_edge_irq+0x1eb/0x7b0
>  irq_exit+0x114/0x140
>  do_IRQ+0x91/0x1e0
>  common_interrupt+0xf/0xf
>  </IRQ>
> 
> Reported-by: Brendan Dolan-Gavitt <brendandg@nyu.edu>
> Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

b07e3c6ebc0c rsi: Fix use-after-free in rsi_rx_done_handler()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/YXxQL/vIiYcZUu/j@10-18-43-117.dynapool.wireless.nyu.edu/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

