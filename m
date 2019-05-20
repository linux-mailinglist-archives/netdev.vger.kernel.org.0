Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4C822F71
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 10:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731649AbfETIzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 04:55:18 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:46595 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731576AbfETIzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 04:55:18 -0400
Received: by mail-ed1-f65.google.com with SMTP id f37so22607701edb.13
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 01:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vFTt0M6+AyIysvwKwIils2X+lM/meF2sxJjj46Wd1sg=;
        b=B8xJgG9Mfe/9MxL0HtY4ca/tirLNmh0C9lj/ex3fDZnQ/Z3N+iZcFmu5S4eMsAkmPs
         9RAJQWBHGH5GhRDnKoHem++eVfSdl+KDJPtcw1herR9fhhgxrP2D3m+xKdRfMPEMMJ84
         JjtKJ6FHMv3vFq5XsnkSq3Esh6InwnFnUWBaI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vFTt0M6+AyIysvwKwIils2X+lM/meF2sxJjj46Wd1sg=;
        b=i2TRBZ5BXwaA4mIgZ2q4ad8urwUIvmdgo23vpouH/GWzls1pS3hvxmksq6ylTjWdVB
         GfX0sylsj/utg3EnNT221SMaUfma9NEsZ4rv8KChE/a5GoTZYIUIr61LkywhgRukFmvu
         c5T8U0mMyMRBbzDwkIVBirORh4i74TTFlk6RjeFxKpbi+9MKkjnzHNU5ffFSZSy3LHD9
         Cg9MrWt37K05fHwa+NtWJSjNfy98sIE6VCnGrnm/GniLVtVjAvGjbS/4ImnOnnXYrZhB
         DELwnhyrhFmbxTvUBnGda1miApzn4Oa3McOM8sV6tAlTTqP5XchG1QIKun8Q8N3E065A
         vZeA==
X-Gm-Message-State: APjAAAVrgKRY4S8W6UWE+xBj26vTBDusO9ujSwfQVVhvbkTeZtiv9Gss
        aSFnwiItp1iiM6R0zw1LcLtGoA==
X-Google-Smtp-Source: APXvYqx4flRS6cM748otmtPJ0wEKEab4DlGo6iNP+Fai8ttXEGXbq+CZSmv1FMlVMKWOwJno0wfUnA==
X-Received: by 2002:a50:aef6:: with SMTP id f51mr73838766edd.225.1558342516174;
        Mon, 20 May 2019 01:55:16 -0700 (PDT)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id g30sm5412048edg.57.2019.05.20.01.55.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 01:55:15 -0700 (PDT)
Subject: Re: [PATCH 0/3] brcmfmac: sdio: Deal better w/ transmission errors
 waking from sleep
To:     Douglas Anderson <dianders@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc:     linux-rockchip@lists.infradead.org,
        Double Lo <double.lo@cypress.com>, briannorris@chromium.org,
        Madhan Mohan R <madhanmohan.r@cypress.com>, mka@chromium.org,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        linux-mmc@vger.kernel.org, Shawn Lin <shawn.lin@rock-chips.com>,
        brcm80211-dev-list@cypress.com, YueHaibing <yuehaibing@huawei.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Martin Hicks <mort@bork.org>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Jiong Wu <lohengrin1024@gmail.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Naveen Gupta <naveen.gupta@cypress.com>,
        Avri Altman <avri.altman@wdc.com>
References: <20190517225420.176893-1-dianders@chromium.org>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <8c3fa57a-3843-947c-ec6b-a6144ccde1e9@broadcom.com>
Date:   Mon, 20 May 2019 10:55:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190517225420.176893-1-dianders@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/2019 12:54 AM, Douglas Anderson wrote:
> This series attempts to deal better with the expected transmission
> errors that we get when waking up the SDIO-based WiFi on
> rk3288-veyron-minnie, rk3288-veyron-speedy, and rk3288-veyron-mickey.
> 
> Some details about those errors can be found in
> <https://crbug.com/960222>, but to summarize it here: if we try to
> send the wakeup command to the WiFi card at the same time it has
> decided to wake up itself then it will behave badly on the SDIO bus.
> This can cause timeouts or CRC errors.
> 
> When I tested on 4.19 and 4.20 these CRC errors can be seen to cause
> re-tuning.  Since I am currently developing on 4.19 this was the
> original problem I attempted to solve.
> 
> On mainline it turns out that you don't see the retuning errors but
> you see tons of spam about timeouts trying to wakeup from sleep.  I
> tracked down the commit that was causing that and have partially
> reverted it here.  I have no real knowledge about Broadcom WiFi, but
> the commit that was causing problems sounds (from the descriptioin) to
> be a hack commit penalizing all Broadcom WiFi users because of a bug
> in a Cypress SD controller.  I will let others comment if this is
> truly the case and, if so, what the right solution should be.

Let me give a bit of background. The brcmfmac driver implements its own 
runtime-pm like functionality, ie. if the driver is idle for some time 
it will put the device in a low-power state. When it does that it powers 
down several cores in the chip among which the SDIO core. However, the 
SDIO bus used be very bad at handling devices that do that so instead it 
has the Always-On-Station (AOS) block take over the SDIO core in 
handling the bus. Default is will send a R1 response, but only for CMD52 
(and CMD14 but no host is using that cruft). In noCmdDecode it does not 
respond and simply wakes up the SDIO core, which takes over again. 
Because it does not respond timeouts (-110) are kinda expected in this mode.

Regards,
Arend
