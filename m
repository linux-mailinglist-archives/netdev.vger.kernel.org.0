Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D78CF19F5B4
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 14:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgDFMRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 08:17:09 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:43925 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727798AbgDFMRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 08:17:08 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586175428; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=hPaukekXx0S9g5DYk6RxxkIC0V+FVGiqXWwaVk4VaVM=; b=JKNc4HfcCRCBuYa9IVmPy43GWBtexiWexf45vP7EoI1UdRcvxp3yoYb237qvuHzd6omPhoiw
 +hy+mtBouXyEqK0bLXFXs9yC+PV92OksT9JcLZ1/L6HQqUyzFd/ITrfCbaXRtgfh/dsYVkiZ
 jK0nCCvEj/NBVO0nBMVACRSNkHA=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e8b1dc3.7fba18c74730-smtp-out-n02;
 Mon, 06 Apr 2020 12:17:07 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6C015C433BA; Mon,  6 Apr 2020 12:17:07 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 10998C433D2;
        Mon,  6 Apr 2020 12:17:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 10998C433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     yhchuang@realtek.com, "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org (open list:REALTEK WIRELESS DRIVER
        (rtw88)), netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] rtw88: Add delay on polling h2c command status bit
References: <20200406093623.3980-1-kai.heng.feng@canonical.com>
Date:   Mon, 06 Apr 2020 15:17:02 +0300
In-Reply-To: <20200406093623.3980-1-kai.heng.feng@canonical.com> (Kai-Heng
        Feng's message of "Mon, 6 Apr 2020 17:36:22 +0800")
Message-ID: <87v9mczu4h.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kai-Heng Feng <kai.heng.feng@canonical.com> writes:

> On some systems we can constanly see rtw88 complains:
> [39584.721375] rtw_pci 0000:03:00.0: failed to send h2c command
>
> Increase interval of each check to wait the status bit really changes.
>
> While at it, add some helpers so we can use standarized
> readx_poll_timeout() macro.

One logical change per patch, please.

> --- a/drivers/net/wireless/realtek/rtw88/hci.h
> +++ b/drivers/net/wireless/realtek/rtw88/hci.h
> @@ -253,6 +253,10 @@ rtw_write8_mask(struct rtw_dev *rtwdev, u32 addr, u32 mask, u8 data)
>  	rtw_write8(rtwdev, addr, set);
>  }
>  
> +#define rr8(addr)      rtw_read8(rtwdev, addr)
> +#define rr16(addr)     rtw_read16(rtwdev, addr)
> +#define rr32(addr)     rtw_read32(rtwdev, addr)

For me these macros reduce code readability, not improve anything. They
hide the use of rtwdev variable, which is evil, and a name like rr8() is
just way too vague. Please keep the original function names as is.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
