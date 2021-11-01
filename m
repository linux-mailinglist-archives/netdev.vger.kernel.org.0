Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2EE441C39
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 15:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbhKAOJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 10:09:59 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:42497 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbhKAOJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 10:09:58 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635775645; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=MsGzeoOMcFoJ10K38erf8p1hz7SNoVYic0txO5jGnzM=; b=NHDlvQzygcuerqfhE+6Q/JeCUYPMOwslFQYbBZSz2cqVh2fhFapNEsU8tdKRBuS4rffmduWf
 plaPFFZoUnM3EJISyuuei0sn2TyN0JFPSS9gwaR1/GB5uoIMdrywI2nqH3S3wEbFX1DFuFT+
 9yrxo3utvPVJ1H0udRk2tSb2d3U=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 617ff483648aeeca5c3e60e1 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 01 Nov 2021 14:06:59
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8DBD9C43618; Mon,  1 Nov 2021 14:06:59 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 84D4BC4338F;
        Mon,  1 Nov 2021 14:06:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 84D4BC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Zekun Shen <bruceshenzk@gmail.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, brendandg@nyu.edu
Subject: Re: [PATCH] rsi_usb: Fix use-after-free in rsi_rx_done_handler
References: <YXxQL/vIiYcZUu/j@10-18-43-117.dynapool.wireless.nyu.edu>
Date:   Mon, 01 Nov 2021 16:06:52 +0200
In-Reply-To: <YXxQL/vIiYcZUu/j@10-18-43-117.dynapool.wireless.nyu.edu> (Zekun
        Shen's message of "Fri, 29 Oct 2021 15:49:03 -0400")
Message-ID: <87y2680y2r.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zekun Shen <bruceshenzk@gmail.com> writes:

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
> Reported-by: Zekun Shen <bruceshenzk@gmail.com>
> Reported-by: Brendan Dolan-Gavitt <brendandg@nyu.edu>
> Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>

There's no need to have the author in Reported-by tag, so I'll remove
that.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
