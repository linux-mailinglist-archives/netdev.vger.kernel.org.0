Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F31A44E2A8
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 08:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbhKLH5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 02:57:05 -0500
Received: from m43-7.mailgun.net ([69.72.43.7]:34070 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233016AbhKLH5E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Nov 2021 02:57:04 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1636703654; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=JhTHi+cjBy/VdffAN6fi4V1mo4GMP+yP7S70xPY2nOI=;
 b=atrmWHY3CR3T2xtvgc+/971f1p+9LOuqxe++CxoQboSKs1Sz6v/wolf6Po29dvUmcUTvbQ+X
 B5Lm11lnSddpsFAVfqSlkdPLOxGtMwXmGaHDoYRhWq1sW4VOr94DVSC9sYb4/O/mwKixuOFM
 IUvBIne/ts1mCNCBYhNJCGhCB38=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 618e1d9ea4b510b38f278536 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 12 Nov 2021 07:54:06
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 40EF3C43616; Fri, 12 Nov 2021 07:54:06 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A14F5C4338F;
        Fri, 12 Nov 2021 07:54:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org A14F5C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ar5523: Fix null-ptr-deref with unexpected
 WDCMSG_TARGET_START reply
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <YXsmPQ3awHFLuAj2@10-18-43-117.dynapool.wireless.nyu.edu>
References: <YXsmPQ3awHFLuAj2@10-18-43-117.dynapool.wireless.nyu.edu>
To:     Zekun Shen <bruceshenzk@gmail.com>
Cc:     bruceshenzk@gmail.com, Pontus Fuchs <pontus.fuchs@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163670364142.27466.15677300491997142770.kvalo@codeaurora.org>
Date:   Fri, 12 Nov 2021 07:54:06 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zekun Shen <bruceshenzk@gmail.com> wrote:

> Unexpected WDCMSG_TARGET_START replay can lead to null-ptr-deref
> when ar->tx_cmd->odata is NULL. The patch adds a null check to
> prevent such case.
> 
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>  ar5523_cmd+0x46a/0x581 [ar5523]
>  ar5523_probe.cold+0x1b7/0x18da [ar5523]
>  ? ar5523_cmd_rx_cb+0x7a0/0x7a0 [ar5523]
>  ? __pm_runtime_set_status+0x54a/0x8f0
>  ? _raw_spin_trylock_bh+0x120/0x120
>  ? pm_runtime_barrier+0x220/0x220
>  ? __pm_runtime_resume+0xb1/0xf0
>  usb_probe_interface+0x25b/0x710
>  really_probe+0x209/0x5d0
>  driver_probe_device+0xc6/0x1b0
>  device_driver_attach+0xe2/0x120
> 
> I found the bug using a custome USBFuzz port. It's a research work
> to fuzz USB stack/drivers. I modified it to fuzz ath9k driver only,
> providing hand-crafted usb descriptors to QEMU.
> 
> After fixing the code (fourth byte in usb packet) to WDCMSG_TARGET_START,
> I got the null-ptr-deref bug. I believe the bug is triggerable whenever
> cmd->odata is NULL. After patching, I tested with the same input and no
> longer see the KASAN report.
> 
> This was NOT tested on a real device.
> 
> Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

ae80b6033834 ar5523: Fix null-ptr-deref with unexpected WDCMSG_TARGET_START reply

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/YXsmPQ3awHFLuAj2@10-18-43-117.dynapool.wireless.nyu.edu/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

