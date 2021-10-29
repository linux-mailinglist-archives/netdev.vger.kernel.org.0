Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D89F443F58D
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 05:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbhJ2D4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 23:56:10 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:30016 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231708AbhJ2D4J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 23:56:09 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635479621; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=svVJj/ptgEELOk5d+/buD8kNREVbrRN5Zobef5vXTGA=; b=bT7DCx85X+kg4UNSGdt4h+EwfOpTuKv+3qnqOfn5lJHI9vYH1OTYm4uQy8IW7UssskD4xAod
 zFIV+Hv3MxfIVukSjQxxLb5Shu+uRG5MrNHqSX6cr38qxmi00NmJ7eZWGvewjFsiWi1Zagd6
 fVaL8qofLUI9MeRxceyPzuvB0PE=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 617b703e648aeeca5c847a00 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 29 Oct 2021 03:53:34
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 040ADC43460; Fri, 29 Oct 2021 03:53:34 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 00CA4C4338F;
        Fri, 29 Oct 2021 03:53:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 00CA4C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Zekun Shen <bruceshenzk@gmail.com>
Cc:     Pontus Fuchs <pontus.fuchs@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ar5523: Fix null-ptr-deref with unexpected WDCMSG_TARGET_START reply
References: <YXsmPQ3awHFLuAj2@10-18-43-117.dynapool.wireless.nyu.edu>
Date:   Fri, 29 Oct 2021 06:53:30 +0300
In-Reply-To: <YXsmPQ3awHFLuAj2@10-18-43-117.dynapool.wireless.nyu.edu> (Zekun
        Shen's message of "Thu, 28 Oct 2021 18:37:49 -0400")
Message-ID: <87tuh0xz9h.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zekun Shen <bruceshenzk@gmail.com> writes:

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
> Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>

How did you test this?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
