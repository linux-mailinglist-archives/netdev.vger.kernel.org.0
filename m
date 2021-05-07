Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D7B375E06
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 02:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbhEGAtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 20:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhEGAto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 20:49:44 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942C7C061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 17:48:45 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id h11so6627860pfn.0
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 17:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=KXmyP+9gf7JW+NByBVKkUA1UdyWmqKq2FyoGZCOgUaM=;
        b=2MHOKqsip+t0GYheak3XDbsMRhqZ9A6yl4rU0oStES7z+6iC6Sg4jpGsurNi3Z7nWt
         g4Cm+vGKWEKUAn4CM/00TVA7KKsCLL5MFHI6s5c2f1mFVhW3pnHUfjr6GS6vz39pLTHw
         4wQc1gq+sFiS/GYX0m+ZrYZFO9CP9uutWGNXEwAq9qfiQRSuS3iSrDofEJvZL8fBN1u2
         bw1bhdwz9nycaouMLzj9lDrVk4L59ntZJVMYht8eteOCXpRCejliLEg67moiAxfKmW6n
         1EJ8u5Igiq2EciY4uKUerdhtqCPFsAiwS/EREVdyguZPbIHGqF30OVY24ddYkscrdVcS
         rKBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=KXmyP+9gf7JW+NByBVKkUA1UdyWmqKq2FyoGZCOgUaM=;
        b=RYgqKfh6GBS+rVwQruGhHkU0qcxFdYyc32t3X6KzUVkNA3FS7yiu2LnIuj9F4U2TfA
         dcGvgs4AeJNeWw+fPwkk/WYXBphxnr9tU3V7ChGWewrRQPIIB7Fo0qe/lN9+0qGihGmx
         OGykgdyOyhMhrnHkIBAtjkEVmP5S1vT+vMg7iPPXgGesLhc7KNPpAjKrHYlFw1radcJY
         qHHx5jelavtGeB7QHAATPY7tIPH3/gJmsSysutozWfvTg0y4VjxBM42rzG5msTZHkSJz
         bbrlpg45ePBove2dcMJccEgDpoAWjRr/YFaTnyckuF9VKcap9MFRgtnvJE2viqHw//1Y
         qwQQ==
X-Gm-Message-State: AOAM533QGq3LGDaB5D4zgJBp/UwdZzx/TnJRcW9Nh6n8ElIyNAJ8xyv/
        H4j3PtcTnQcqRHSxN8bBiBBiPw==
X-Google-Smtp-Source: ABdhPJy586FDOMh0R8EdJ1PNcUeuAeYQpjKr72XitX+7+rfYz28v3P+rFAuAKAhcScFRRJgUcuUsGg==
X-Received: by 2002:a63:da0a:: with SMTP id c10mr7125479pgh.255.1620348524981;
        Thu, 06 May 2021 17:48:44 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id 5sm3145550pfi.43.2021.05.06.17.48.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 17:48:44 -0700 (PDT)
Subject: Re: [PATCH v3 net] ionic: fix ptp support config breakage
To:     Randy Dunlap <rdunlap@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, drivers@pensando.io,
        Allen Hubbe <allenbh@pensando.io>
References: <20210506041846.62502-1-snelson@pensando.io>
 <20210506171529.0d95c9da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b3099289-0ae4-7a4f-6739-55f788418eb8@infradead.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <d412627d-467d-8e19-f4b6-2899afa1845d@pensando.io>
Date:   Thu, 6 May 2021 17:48:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <b3099289-0ae4-7a4f-6739-55f788418eb8@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/6/21 5:21 PM, Randy Dunlap wrote:
> On 5/6/21 5:15 PM, Jakub Kicinski wrote:
>> On Wed,  5 May 2021 21:18:46 -0700 Shannon Nelson wrote:
>>> Driver link failed with undefined references in some
>>> kernel config variations.
>> This is really vague and the patch is not very obvious.
>>
>>>   ionic-y := ionic_main.o ionic_bus_pci.o ionic_devlink.o ionic_dev.o \
>>>   	   ionic_debugfs.o ionic_lif.o ionic_rx_filter.o ionic_ethtool.o \
>>> -	   ionic_txrx.o ionic_stats.o ionic_fw.o
>>> -ionic-$(CONFIG_PTP_1588_CLOCK) += ionic_phc.o
>>> +	   ionic_txrx.o ionic_stats.o ionic_fw.o ionic_phc.o
>> So we'd replace a build dependency..
>>
>>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_phc.c b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
>>> index a87c87e86aef..30c78808c45a 100644
>>> --- a/drivers/net/ethernet/pensando/ionic/ionic_phc.c
>>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
>>> @@ -1,6 +1,8 @@
>>>   // SPDX-License-Identifier: GPL-2.0
>>>   /* Copyright(c) 2017 - 2021 Pensando Systems, Inc */
>>>   
>>> +#if IS_ENABLED(CONFIG_PTP_1588_CLOCK)
>>> +
>>>   #include <linux/netdevice.h>
>>>   #include <linux/etherdevice.h>
>>>   
>>> @@ -613,3 +615,4 @@ void ionic_lif_free_phc(struct ionic_lif *lif)
>>>   	devm_kfree(lif->ionic->dev, lif->phc);
>>>   	lif->phc = NULL;
>>>   }
>>> +#endif /* IS_ENABLED(CONFIG_PTP_1588_CLOCK) */
>> .. with an ifdef around an entire file? Does not feel very clean.
>>
>> The construct of using:
>>
>> 	drv-$(CONFIG_PTP_1588_CLOCK) += ptp.o
>>
>> seems relatively common, why does it now work here?
>>
>> Maybe the config in question has PTP as a module and ionic built in?
>> Then you should add depends on PTP_1588_CLOCK || !PTP_1588_CLOCK.
>>
>> Maybe somehow the "ionic-y" confuses kbuild and it should be ionic-objs?
>>
>> At the very least we need a better explanation in the commit message.
>>
> I'll take a look if someone can point me to the .config file.
>

These are the notes I got from kernel test robot:
https://lore.kernel.org/lkml/202105041020.efEaBOYC-lkp@intel.com/
https://lore.kernel.org/lkml/202105041154.GrLZmjGh-lkp@intel.com/
https://lore.kernel.org/lkml/202105041634.paURyDp0-lkp@intel.com/
https://lore.kernel.org/lkml/202105050636.UXXDl7m2-lkp@intel.com/

sln

