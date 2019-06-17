Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4148148002
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 12:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfFQKw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 06:52:57 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53465 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727253AbfFQKw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 06:52:56 -0400
Received: by mail-wm1-f67.google.com with SMTP id x15so8736505wmj.3
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 03:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZrGsAut7uTsx4N98mpJ5emxcDiHoXMt2HeuGIHuHDuY=;
        b=ZmPOJv+uNeM7+bNBeQqLGswxWW9SMhfKnc014mIavxJdV79s0wjtcZT2VyUWK+UWrD
         Movw97H2zsJ+JBlhl315a19BTQrUa1M7tC7Gn1UzYUsnywZm6KraZ77S5sjMvTlk+U8Z
         LBfBBRYF8bxGvs2tbraE55QLhVFojz1qPLIU8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZrGsAut7uTsx4N98mpJ5emxcDiHoXMt2HeuGIHuHDuY=;
        b=f+GnW81QKzvd+HoyD4MD/tHjnUjte8JtMgoT5OnHOmmUj0JvHTpC9cnQl7kX7gP0RB
         HqMReUidX+ZPexR3LQqCz7QgDHxlRFi8aCdTPU3+eDOg3donOKQE5W3h7j7l22Y/uJY9
         vvW5Jd7i1KVBucDQDDTLFKO4OC1A9f4dgSb0leYg1vPMapfNlqE31NYSDM6TDaWOdJ3m
         7/Oylm4MTaTrZY0Pllsaok2xXdD0aalRVD/N+ygLyAbh/nkLotep1JfvHIi9iNfLIq6R
         s6mBoDA6njJg0uOZ6HbAt1Es6eGGb/3+zGKvzF/dtJ07xADTGTGIu1u0jDA58edP7kIp
         HhUA==
X-Gm-Message-State: APjAAAXmsYCsN4YXqoI/TmJ2j00QOme2kSJobV9g6wbDN8FAzTCvwPx0
        fzmJmt00FtzilRwfIBXCI2x68Q==
X-Google-Smtp-Source: APXvYqxwU5akwxSHDxkkxP8iCz4MY4SSgr81eWPc6HIAiFo2nQ2pP4CVo+hHo0NsY+yWo6H1GCq6JQ==
X-Received: by 2002:a1c:96c7:: with SMTP id y190mr16834836wmd.87.1560768773522;
        Mon, 17 Jun 2019 03:52:53 -0700 (PDT)
Received: from [10.176.68.244] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id y184sm9396231wmg.14.2019.06.17.03.52.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 03:52:52 -0700 (PDT)
Subject: Re: [PATCH v4 5/5] brcmfmac: sdio: Don't tune while the card is off
To:     Douglas Anderson <dianders@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc:     brcm80211-dev-list.pdl@broadcom.com,
        linux-rockchip@lists.infradead.org,
        Double Lo <double.lo@cypress.com>, briannorris@chromium.org,
        linux-wireless@vger.kernel.org,
        Naveen Gupta <naveen.gupta@cypress.com>,
        Madhan Mohan R <madhanmohan.r@cypress.com>, mka@chromium.org,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        netdev@vger.kernel.org, brcm80211-dev-list@cypress.com,
        Franky Lin <franky.lin@broadcom.com>,
        linux-kernel@vger.kernel.org,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20190613234153.59309-1-dianders@chromium.org>
 <20190613234153.59309-6-dianders@chromium.org>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <f0dc6ef8-b339-8656-14d6-cf7c4e872b22@broadcom.com>
Date:   Mon, 17 Jun 2019 12:52:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190613234153.59309-6-dianders@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/14/2019 1:41 AM, Douglas Anderson wrote:
> When Broadcom SDIO cards are idled they go to sleep and a whole
> separate subsystem takes over their SDIO communication.  This is the
> Always-On-Subsystem (AOS) and it can't handle tuning requests.
> 
> Specifically, as tested on rk3288-veyron-minnie (which reports having
> BCM4354/1 in dmesg), if I force a retune in brcmf_sdio_kso_control()
> when "on = 1" (aka we're transition from sleep to wake) by whacking:
>    bus->sdiodev->func1->card->host->need_retune = 1
> ...then I can often see tuning fail.  In this case dw_mmc reports "All
> phases bad!").  Note that I don't get 100% failure, presumably because
> sometimes the card itself has already transitioned away from the AOS
> itself by the time we try to wake it up.  If I force retuning when "on
> = 0" (AKA force retuning right before sending the command to go to
> sleep) then retuning is always OK.
> 
> NOTE: we need _both_ this patch and the patch to avoid triggering
> tuning due to CRC errors in the sleep/wake transition, AKA ("brcmfmac:
> sdio: Disable auto-tuning around commands expected to fail").  Though
> both patches handle issues with Broadcom's AOS, the problems are
> distinct:
> 1. We want to defer (but not ignore) asynchronous (like
>     timer-requested) tuning requests till the card is awake.  However,
>     we want to ignore CRC errors during the transition, we don't want
>     to queue deferred tuning request.
> 2. You could imagine that the AOS could implement retuning but we
>     could still get errors while transitioning in and out of the AOS.
>     Similarly you could imagine a seamless transition into and out of
>     the AOS (with no CRC errors) even if the AOS couldn't handle
>     tuning.
> 
> ALSO NOTE: presumably there is never a desperate need to retune in
> order to wake up the card, since doing so is impossible.  Luckily the
> only way the card can get into sleep state is if we had a good enough
> tuning to send it a sleep command, so presumably that "good enough"
> tuning is enough to wake us up, at least with a few retries.

The term "sleep command" is a bit confusing. There actually is a CMD14 
defined in the eSD spec, but that is not what we are using (unless we 
program the chip to do so) here. It is simply a specific register access 
using CMD52.

Apart from that....

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> 
> Signed-off-by: Douglas Anderson <dianders@chromium.org>

I think the stable version is mostly determined by change in MMC/SDIO so 
4.18 as mentioned Adrian seems most sensible. bcm4354 support was 
introduced in 3.14 and there were some earlier devices (4335) using same 
sleep mechanism.

Regards,
Arend
