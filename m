Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 163EF375DE2
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 02:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbhEGAW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 20:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233539AbhEGAW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 20:22:59 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB9BC061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 17:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=oWVOyNftvjacxe47iOwISLsdWFwBUZxtC2FVOHxQO8I=; b=akF02xvWQlPd9Q0a8KDLIXRlDu
        32dTzL+g659Fg8cd6QHH3JFNpaKviOTS49dJFBU0RnOQDOx1fPOLZrU/KNHlKP4bCEm5wpZsDWrUg
        XAY5aZE1HwrpWuc4ojyXjONLbFpQOjThv/j+IwRLu9+PfnmSGXZgQMrP3OWVhC7JSV4eTZsJ4q8c2
        9QKNZZrrzz5P7jkqGK7h1PHSae0ZjhzP2XZDxumCRR9P7WbxKhd486Ej1FysMmxXfgP9K14aUiIHL
        2mdO8r/mS6jo743XdxDmj3pnoSXYLvXQR+H3S+Wbr5DGY41ELssnW7Lb+4Wr1m6NJiHpuO724g1nO
        w76y2SYQ==;
Received: from [2601:1c0:6280:3f0::7376]
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1leoFi-006TJt-1R; Fri, 07 May 2021 00:21:58 +0000
Subject: Re: [PATCH v3 net] ionic: fix ptp support config breakage
To:     Jakub Kicinski <kuba@kernel.org>,
        Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, drivers@pensando.io,
        Allen Hubbe <allenbh@pensando.io>
References: <20210506041846.62502-1-snelson@pensando.io>
 <20210506171529.0d95c9da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <b3099289-0ae4-7a4f-6739-55f788418eb8@infradead.org>
Date:   Thu, 6 May 2021 17:21:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210506171529.0d95c9da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/6/21 5:15 PM, Jakub Kicinski wrote:
> On Wed,  5 May 2021 21:18:46 -0700 Shannon Nelson wrote:
>> Driver link failed with undefined references in some
>> kernel config variations.
> 
> This is really vague and the patch is not very obvious.
> 
>>  ionic-y := ionic_main.o ionic_bus_pci.o ionic_devlink.o ionic_dev.o \
>>  	   ionic_debugfs.o ionic_lif.o ionic_rx_filter.o ionic_ethtool.o \
>> -	   ionic_txrx.o ionic_stats.o ionic_fw.o
>> -ionic-$(CONFIG_PTP_1588_CLOCK) += ionic_phc.o
>> +	   ionic_txrx.o ionic_stats.o ionic_fw.o ionic_phc.o
> 
> So we'd replace a build dependency..
> 
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_phc.c b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
>> index a87c87e86aef..30c78808c45a 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_phc.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
>> @@ -1,6 +1,8 @@
>>  // SPDX-License-Identifier: GPL-2.0
>>  /* Copyright(c) 2017 - 2021 Pensando Systems, Inc */
>>  
>> +#if IS_ENABLED(CONFIG_PTP_1588_CLOCK)
>> +
>>  #include <linux/netdevice.h>
>>  #include <linux/etherdevice.h>
>>  
>> @@ -613,3 +615,4 @@ void ionic_lif_free_phc(struct ionic_lif *lif)
>>  	devm_kfree(lif->ionic->dev, lif->phc);
>>  	lif->phc = NULL;
>>  }
>> +#endif /* IS_ENABLED(CONFIG_PTP_1588_CLOCK) */
> 
> .. with an ifdef around an entire file? Does not feel very clean.
> 
> The construct of using:
> 
> 	drv-$(CONFIG_PTP_1588_CLOCK) += ptp.o
> 
> seems relatively common, why does it now work here?
> 
> Maybe the config in question has PTP as a module and ionic built in?
> Then you should add depends on PTP_1588_CLOCK || !PTP_1588_CLOCK.
> 
> Maybe somehow the "ionic-y" confuses kbuild and it should be ionic-objs?
> 
> At the very least we need a better explanation in the commit message.
> 

I'll take a look if someone can point me to the .config file.

-- 
~Randy

