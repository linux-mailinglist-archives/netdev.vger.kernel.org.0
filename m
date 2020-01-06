Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46769131C26
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 00:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbgAFXPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 18:15:22 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:32902 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbgAFXPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 18:15:21 -0500
Received: by mail-lj1-f195.google.com with SMTP id y6so44667959lji.0;
        Mon, 06 Jan 2020 15:15:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GcHJg22cvo8ljopBl3kBLmCFRVo0QCzkiqo6O1LyDuE=;
        b=hoW9RI/ZapKnQCth4HdKJwZKngbGc9yt7QGH8LrsDBLY9WesJ34GJYbNfP5blSBIIl
         0+leGvAAGl6/uRFjmq+P5xtc6txH41TpAia7SwtCDueUo+dGNFJeAYlqG6rMYgjHoKJa
         REuPY3nIdi0m/zhitowkaA8Z8X1qAY/dp/8rlShg9M7nXzAKLSZjqb10xgMtYXiaislN
         lWYpURSArfUew39d11gLh/pKBe3EU49IgfrCONFZGKqDURxsP34ulXm3fzCKLsj4s/Po
         0wojxUlXh58BLDS49RzWzdkuzF+fmAsZSFywVd3t8sbb+rH+6l7Fn/QvMgVFiYjYRKzi
         V8OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GcHJg22cvo8ljopBl3kBLmCFRVo0QCzkiqo6O1LyDuE=;
        b=ouRMY1ouWudy7BjleKaDs2MBFjHWAtzXdQBGyhPpX0SDS7Wpm+njzfwrbAYtQ8Ouak
         O8ZBwBnZuDSbAVnxSOUsWLIwgp2W+S7FlCy5AjaxS7jeDo4vLJbS+EUZJa4CVuNXQ10a
         pt6L0zqE+ddRf270YusnYuLroBpmyBletsPy2YISdWN5tVlOiTF7h9rXWhNmh/3tQKU/
         kb/etUbWRCtfTxhvBxqBV+1pkF495fkNSVDx3SbuweZZiTnDTb4P7TGquQJ3DrGhJUis
         6UcX8WztrbwysDzJd1LQLEoRIL/juIDHdyPqy4sz7FolIP86AKd0FN7GO9c5uMYcCNJC
         aHcA==
X-Gm-Message-State: APjAAAUHcDhfroSa/saaujssKt4hyReEkC1Zl7vmbTfRBsDDmXW8DacN
        GQI3pgGWT8MCGUztwR1vGXY=
X-Google-Smtp-Source: APXvYqy/7HxcFhKd7hifJSt5qHNNgYUM7sQG6qyy6Dz+T5mjvtfn8r5FCSwZB+0VuLc51qM5jWtOYA==
X-Received: by 2002:a2e:b4ef:: with SMTP id s15mr55146151ljm.20.1578352519724;
        Mon, 06 Jan 2020 15:15:19 -0800 (PST)
Received: from [192.168.2.145] (79-139-233-37.dynamic.spd-mgts.ru. [79.139.233.37])
        by smtp.googlemail.com with ESMTPSA id o10sm11984144lfn.20.2020.01.06.15.15.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2020 15:15:19 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: sdio: Fix OOB interrupt initialization on
 brcm43362
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        hdegoede@redhat.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, kvalo@codeaurora.org, davem@davemloft.net
References: <20191226092033.12600-1-jean-philippe@linaro.org>
 <16f419a7070.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
 <141f055a-cd1d-66cb-7052-007cda629d3a@gmail.com>
 <20200106191919.GA826263@myrica>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <c2bb1067-9b9c-3be1-b87e-e733a668a056@gmail.com>
Date:   Tue, 7 Jan 2020 02:15:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200106191919.GA826263@myrica>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

06.01.2020 22:19, Jean-Philippe Brucker пишет:
> Hi Dmitry,
> 
> On Thu, Dec 26, 2019 at 05:37:58PM +0300, Dmitry Osipenko wrote:
>> I haven't seen any driver probe failures due to OOB on NVIDIA Tegra,
>> only suspend-resume was problematic due to the unbalanced OOB
>> interrupt-wake enabling.
>>
>> But maybe checking whether OOB interrupt-wake works by invoking
>> enable_irq_wake() during brcmf_sdiod_intr_register() causes trouble for
>> the cubietruck board.
>>
>> @Jean-Philippe, could you please try this change (on top of recent
>> linux-next):
> 
> Sorry for the delay, linux-next doesn't boot for me at the moment and I
> have little time to investigate why, so I might retry closer to the merge
> window.
> 
> However, isn't the interrupt-wake issue independent from the problem
> (introduced in v4.17) that my patch fixes? I applied "brcmfmac: Keep OOB
> wake-interrupt disabled when it shouldn't be enabled" on v5.5-rc5 and it
> doesn't seem to cause a regression, but the wifi only works if I apply my
> patch as well.
> 
> Thanks,
> Jean
> 
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
>> index b684a5b6d904..80d7106b10a9 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
>> @@ -115,13 +115,6 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev
>> *sdiodev)
>>                 }
>>                 sdiodev->oob_irq_requested = true;
>>
>> -               ret = enable_irq_wake(pdata->oob_irq_nr);
>> -               if (ret != 0) {
>> -                       brcmf_err("enable_irq_wake failed %d\n", ret);
>> -                       return ret;
>> -               }
>> -               disable_irq_wake(pdata->oob_irq_nr);
>> -
>>                 sdio_claim_host(sdiodev->func1);
>>
>>                 if (sdiodev->bus_if->chip == BRCM_CC_43362_CHIP_ID) {

Hello Jean,

Could you please clarify whether you applied [1] and then the above
snippet on top of it or you only applied [1] without the snippet?

[1] brcmfmac: Keep OOB wake-interrupt disabled when it shouldn't be enabled
