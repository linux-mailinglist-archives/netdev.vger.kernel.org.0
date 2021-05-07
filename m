Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0A8375F23
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 05:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhEGD1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 23:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhEGD1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 23:27:08 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92B9C061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 20:26:08 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id h7so4462700plt.1
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 20:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=gJaFed0wY00nTCYMKyAT4BeNXU9a28r1uwn6VpBfIhw=;
        b=QqprI70irvJ63PrgI8B7wwMkgnbrfszvI+hsLrO0v5jomLcHCOifwZxPSO5LcRbrxB
         KFp76cVAHbHaRtPH78YiAXCfA0FXKlAaWqT9U6BbGZpAhzdMOm2VvmJ4qug2B7h270dn
         A8841PUjVf5TohTEfctAGtocMsNieJ2n6A9eut8GBxUPyiL2nXb0CR3NxeQh+EHT73nB
         MRcD68q05PiawJHQyS2dtEBtl6g8GOt9p/PA/f2SBR5u43saDLo5YXQulWz5BNeBOfix
         dvMt1Na+y5jGrdsGr2lW1MFOIuIWIiWPVHF3nPB/DKPfy3nBQmlgANCqejLSW2NK5XVW
         f3hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=gJaFed0wY00nTCYMKyAT4BeNXU9a28r1uwn6VpBfIhw=;
        b=TVZyQOOhaWaiwXKxBGn8jWRKM6sJIr2wuEQH/qE3u32B1cbz6xRFYGjVlb1pXyq7Hg
         mIKaY3cvH/FBSCMJNG+T3BxrwTwsQKFFvnY2lP0fCN1q5W+nnyjTxznRsvTtJSGhdexe
         XJ/qB4KwUrC705NWAhcgVD/3GXcGzvpSYVlBH1I9kIRQgG1YkYyAmo6kj0Az+ilZkl0t
         yblc+Q/R0OG1S1w13jv4lrywi2klB+aADLCdt8CDzzkzQNjsuEfNt0Ufzsc1poxPZ9/T
         z8aK19CmfugaH3T/z9RfTNfeKZYnZUxic6t/UtKj/p/GMkMUfNlV0NPy54xqtxKy6ppc
         Nu1g==
X-Gm-Message-State: AOAM532LVw16PQU5k3l1r5NtynLbToD4Wl+7MBXGFvam3W1xQ9aFnb/i
        KqYH/RuEcpf71tVwOlhCmAhTGZ/Xc2KwWA==
X-Google-Smtp-Source: ABdhPJxxV6HmISwgBRNubRD8+rjL79roAxvr5HehXE4tnbVOVsWet0hGEOgdnS51qpH431OTwcq4TA==
X-Received: by 2002:a17:90b:3504:: with SMTP id ls4mr20209297pjb.222.1620357968236;
        Thu, 06 May 2021 20:26:08 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id m9sm3047904pgt.65.2021.05.06.20.26.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 20:26:07 -0700 (PDT)
Subject: Re: [PATCH v3 net] ionic: fix ptp support config breakage
To:     Randy Dunlap <rdunlap@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, drivers@pensando.io,
        Allen Hubbe <allenbh@pensando.io>
References: <20210506041846.62502-1-snelson@pensando.io>
 <20210506171529.0d95c9da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b3099289-0ae4-7a4f-6739-55f788418eb8@infradead.org>
 <d412627d-467d-8e19-f4b6-2899afa1845d@pensando.io>
 <4e831e77-0688-f3a9-1202-76f88230c7a8@infradead.org>
 <4f3f61ad-08dd-0bba-bd8e-8cb16b466012@infradead.org>
 <583aeb80-4ac8-06ac-67f7-d717415523dd@infradead.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <ed18d03f-d467-5fe9-7b04-0fd474128d0b@pensando.io>
Date:   Thu, 6 May 2021 20:26:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <583aeb80-4ac8-06ac-67f7-d717415523dd@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/6/21 6:30 PM, Randy Dunlap wrote:
> On 5/6/21 6:16 PM, Randy Dunlap wrote:
>> On 5/6/21 6:12 PM, Randy Dunlap wrote:
>>> On 5/6/21 5:48 PM, Shannon Nelson wrote:
>>>> On 5/6/21 5:21 PM, Randy Dunlap wrote:
>>>>> On 5/6/21 5:15 PM, Jakub Kicinski wrote:
>>>>>> On Wed,  5 May 2021 21:18:46 -0700 Shannon Nelson wrote:
>>>>>>> Driver link failed with undefined references in some
>>>>>>> kernel config variations.
>>>>>> This is really vague and the patch is not very obvious.
> When IONIC=y and PTP_1588_CLOCK=m...
>
>>>>>>>    ionic-y := ionic_main.o ionic_bus_pci.o ionic_devlink.o ionic_dev.o \
>>>>>>>           ionic_debugfs.o ionic_lif.o ionic_rx_filter.o ionic_ethtool.o \
>>>>>>> -       ionic_txrx.o ionic_stats.o ionic_fw.o
>>>>>>> -ionic-$(CONFIG_PTP_1588_CLOCK) += ionic_phc.o
>>>>>>> +       ionic_txrx.o ionic_stats.o ionic_fw.o ionic_phc.o
>>>>>> So we'd replace a build dependency..
>>>>>>
>>>>>>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_phc.c b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
>>>>>>> index a87c87e86aef..30c78808c45a 100644
>>>>>>> --- a/drivers/net/ethernet/pensando/ionic/ionic_phc.c
>>>>>>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
>>>>>>> @@ -1,6 +1,8 @@
>>>>>>>    // SPDX-License-Identifier: GPL-2.0
>>>>>>>    /* Copyright(c) 2017 - 2021 Pensando Systems, Inc */
>>>>>>>    +#if IS_ENABLED(CONFIG_PTP_1588_CLOCK)
>>>>>>> +
>>>>>>>    #include <linux/netdevice.h>
>>>>>>>    #include <linux/etherdevice.h>
>>>>>>>    @@ -613,3 +615,4 @@ void ionic_lif_free_phc(struct ionic_lif *lif)
>>>>>>>        devm_kfree(lif->ionic->dev, lif->phc);
>>>>>>>        lif->phc = NULL;
>>>>>>>    }
>>>>>>> +#endif /* IS_ENABLED(CONFIG_PTP_1588_CLOCK) */
>>>>>> .. with an ifdef around an entire file? Does not feel very clean.
>>>>>>
>>>>>> The construct of using:
>>>>>>
>>>>>>      drv-$(CONFIG_PTP_1588_CLOCK) += ptp.o
>>>>>>
>>>>>> seems relatively common, why does it now work here?
>>>>>>
>>>>>> Maybe the config in question has PTP as a module and ionic built in?
>>>>>> Then you should add depends on PTP_1588_CLOCK || !PTP_1588_CLOCK.
>>>>>>
>>>>>> Maybe somehow the "ionic-y" confuses kbuild and it should be ionic-objs?
>>>>>>
>>>>>> At the very least we need a better explanation in the commit message.
>>>>>>
>>>>> I'll take a look if someone can point me to the .config file.
>>>>>
>>>> These are the notes I got from kernel test robot:
>>>> https://lore.kernel.org/lkml/202105041020.efEaBOYC-lkp@intel.com/
>>>> https://lore.kernel.org/lkml/202105041154.GrLZmjGh-lkp@intel.com/
>>>> https://lore.kernel.org/lkml/202105041634.paURyDp0-lkp@intel.com/
>>>> https://lore.kernel.org/lkml/202105050636.UXXDl7m2-lkp@intel.com/
>>> At first glance it looks like Jakub's suggestion of
>>>>>> Maybe the config in question has PTP as a module and ionic built in?
>>>>>> Then you should add depends on PTP_1588_CLOCK || !PTP_1588_CLOCK.
>>> is what is needed, but I'm still doing build testing ATM.
>> Nope, eat my words. These build issues are not about PTP.
>> I'm still looking.
> I have been trying to go to fast.. slow down, wait for the old computer.
>
> Back to Jakub's suggestion -- that works for me. (copy-paste, whitespace damaged)
>
>
> --- linux-next-20210506.orig/drivers/net/ethernet/pensando/Kconfig
> +++ linux-next-20210506/drivers/net/ethernet/pensando/Kconfig
> @@ -20,6 +20,7 @@ if NET_VENDOR_PENSANDO
>   config IONIC
>          tristate "Pensando Ethernet IONIC Support"
>          depends on 64BIT && PCI
> +       depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
>          select NET_DEVLINK
>          select DIMLIB
>          help
>
> If PTP_1588_CLOCK=m, the depends limits IONIC to =m (or disabled).
> If PTP_1588_CLOCK is disabled, IONIC can be any of y/m/n.
>

Thanks, I'll follow up with this.
sln


