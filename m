Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0285319F6DB
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 15:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbgDFNYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 09:24:35 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:21488 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728262AbgDFNYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 09:24:33 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586179473; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=0huV9gCKoElhr+Kd6F/isL7651Gm8HQMAsVqnv5Vwq0=; b=A26cxBE1vnEgs7+uWZIuNKf6ttS3sbAAPYFM0Psf0Kmrb3tzXyg37v0jdOI8zfh2mnTQUu3q
 tXFS/a48fG93gkbPei/qKW2Q3tQ9iKEynjzKbxlH3BvATSAd8UtIPlRLYdge9L+rxpCfwaov
 iQJwiZGWno0Vvl0rAg57Dx0v8rQ=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e8b2d8d.7ff7bd409810-smtp-out-n05;
 Mon, 06 Apr 2020 13:24:29 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1CA2FC43636; Mon,  6 Apr 2020 13:24:29 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DE9BDC433F2;
        Mon,  6 Apr 2020 13:24:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DE9BDC433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Tony Chuang <yhchuang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list\:REALTEK WIRELESS DRIVER \(rtw88\)" 
        <linux-wireless@vger.kernel.org>,
        "open list\:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtw88: Add delay on polling h2c command status bit
References: <20200406093623.3980-1-kai.heng.feng@canonical.com>
        <87v9mczu4h.fsf@kamboji.qca.qualcomm.com>
        <94EAAF7E-66C5-40E2-B6A9-0787CB13A3A9@canonical.com>
Date:   Mon, 06 Apr 2020 16:24:24 +0300
In-Reply-To: <94EAAF7E-66C5-40E2-B6A9-0787CB13A3A9@canonical.com> (Kai-Heng
        Feng's message of "Mon, 6 Apr 2020 21:18:20 +0800")
Message-ID: <87zhboycfr.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kai-Heng Feng <kai.heng.feng@canonical.com> writes:

>> On Apr 6, 2020, at 20:17, Kalle Valo <kvalo@codeaurora.org> wrote:
>> 
>> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
>> 
>>> --- a/drivers/net/wireless/realtek/rtw88/hci.h
>>> +++ b/drivers/net/wireless/realtek/rtw88/hci.h
>>> @@ -253,6 +253,10 @@ rtw_write8_mask(struct rtw_dev *rtwdev, u32
>>> addr, u32 mask, u8 data)
>>> 	rtw_write8(rtwdev, addr, set);
>>> }
>>> 
>>> +#define rr8(addr)      rtw_read8(rtwdev, addr)
>>> +#define rr16(addr)     rtw_read16(rtwdev, addr)
>>> +#define rr32(addr)     rtw_read32(rtwdev, addr)
>> 
>> For me these macros reduce code readability, not improve anything. They
>> hide the use of rtwdev variable, which is evil, and a name like rr8() is
>> just way too vague. Please keep the original function names as is.
>
> The inspiration is from another driver.
> readx_poll_timeout macro only takes one argument for the op.
> Some other drivers have their own poll_timeout implementation,
> and I guess it makes sense to make one specific for rtw88.

I'm not even understanding the problem you are tying to fix with these
macros. The upstream philosopyhy is to have the source code readable and
maintainable, not to use minimal number of characters. There's a reason
why we don't name our functions a(), b(), c() and so on.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
