Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95115375E49
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 03:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbhEGBRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 21:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbhEGBRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 21:17:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B490C061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 18:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:From:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=F9c7m1JqpG8qBWhb+ge3VCRcmL+8egPDGSGHsXn48d0=; b=fH54zs18mZlBMIgkaLR6BMVnsf
        6/2vpB3hk9uSmjtsTye+J7EqCvbO02DaEESKhF4aAv4TPmsRx/DZny7upzxPxxLaS4DsIMsuIluPq
        KtgxW+JAe3MpwNEN5EgCgwchYbSbDry0U9pfVJyQKOWMsnRe+yat52DFyrbzR/1LNjruGWMCU6aaQ
        FLDLDDYf3c/r4JvtaVBbhgH6Ymad7DpX9s7alsEUEqM24O0+QxqRdKFgY8UEFrhkt9jgm62nXLe2G
        pveNznOb3Ise3LYSFeOQfUjR9RMy46b3blcM8nWeUgFGnxwg0ejwBXD1Tmyinu0QxodNY5+i3+N8h
        hQ976dPg==;
Received: from [2601:1c0:6280:3f0::7376]
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lep6o-006VEi-6p; Fri, 07 May 2021 01:16:50 +0000
Subject: Re: [PATCH v3 net] ionic: fix ptp support config breakage
From:   Randy Dunlap <rdunlap@infradead.org>
To:     Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, drivers@pensando.io,
        Allen Hubbe <allenbh@pensando.io>
References: <20210506041846.62502-1-snelson@pensando.io>
 <20210506171529.0d95c9da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b3099289-0ae4-7a4f-6739-55f788418eb8@infradead.org>
 <d412627d-467d-8e19-f4b6-2899afa1845d@pensando.io>
 <4e831e77-0688-f3a9-1202-76f88230c7a8@infradead.org>
Message-ID: <4f3f61ad-08dd-0bba-bd8e-8cb16b466012@infradead.org>
Date:   Thu, 6 May 2021 18:16:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <4e831e77-0688-f3a9-1202-76f88230c7a8@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/6/21 6:12 PM, Randy Dunlap wrote:
> On 5/6/21 5:48 PM, Shannon Nelson wrote:
>> On 5/6/21 5:21 PM, Randy Dunlap wrote:
>>> On 5/6/21 5:15 PM, Jakub Kicinski wrote:
>>>> On Wed,  5 May 2021 21:18:46 -0700 Shannon Nelson wrote:
>>>>> Driver link failed with undefined references in some
>>>>> kernel config variations.
>>>> This is really vague and the patch is not very obvious.
>>>>
>>>>>   ionic-y := ionic_main.o ionic_bus_pci.o ionic_devlink.o ionic_dev.o \
>>>>>          ionic_debugfs.o ionic_lif.o ionic_rx_filter.o ionic_ethtool.o \
>>>>> -       ionic_txrx.o ionic_stats.o ionic_fw.o
>>>>> -ionic-$(CONFIG_PTP_1588_CLOCK) += ionic_phc.o
>>>>> +       ionic_txrx.o ionic_stats.o ionic_fw.o ionic_phc.o
>>>> So we'd replace a build dependency..
>>>>
>>>>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_phc.c b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
>>>>> index a87c87e86aef..30c78808c45a 100644
>>>>> --- a/drivers/net/ethernet/pensando/ionic/ionic_phc.c
>>>>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
>>>>> @@ -1,6 +1,8 @@
>>>>>   // SPDX-License-Identifier: GPL-2.0
>>>>>   /* Copyright(c) 2017 - 2021 Pensando Systems, Inc */
>>>>>   +#if IS_ENABLED(CONFIG_PTP_1588_CLOCK)
>>>>> +
>>>>>   #include <linux/netdevice.h>
>>>>>   #include <linux/etherdevice.h>
>>>>>   @@ -613,3 +615,4 @@ void ionic_lif_free_phc(struct ionic_lif *lif)
>>>>>       devm_kfree(lif->ionic->dev, lif->phc);
>>>>>       lif->phc = NULL;
>>>>>   }
>>>>> +#endif /* IS_ENABLED(CONFIG_PTP_1588_CLOCK) */
>>>> .. with an ifdef around an entire file? Does not feel very clean.
>>>>
>>>> The construct of using:
>>>>
>>>>     drv-$(CONFIG_PTP_1588_CLOCK) += ptp.o
>>>>
>>>> seems relatively common, why does it now work here?
>>>>
>>>> Maybe the config in question has PTP as a module and ionic built in?
>>>> Then you should add depends on PTP_1588_CLOCK || !PTP_1588_CLOCK.
>>>>
>>>> Maybe somehow the "ionic-y" confuses kbuild and it should be ionic-objs?
>>>>
>>>> At the very least we need a better explanation in the commit message.
>>>>
>>> I'll take a look if someone can point me to the .config file.
>>>
>>
>> These are the notes I got from kernel test robot:
>> https://lore.kernel.org/lkml/202105041020.efEaBOYC-lkp@intel.com/
>> https://lore.kernel.org/lkml/202105041154.GrLZmjGh-lkp@intel.com/
>> https://lore.kernel.org/lkml/202105041634.paURyDp0-lkp@intel.com/
>> https://lore.kernel.org/lkml/202105050636.UXXDl7m2-lkp@intel.com/
> 
> At first glance it looks like Jakub's suggestion of
>>>> Maybe the config in question has PTP as a module and ionic built in?
>>>> Then you should add depends on PTP_1588_CLOCK || !PTP_1588_CLOCK.
> 
> is what is needed, but I'm still doing build testing ATM.

Nope, eat my words. These build issues are not about PTP.
I'm still looking.

-- 
~Randy

