Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 487435A8000
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 16:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbiHaOVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 10:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbiHaOVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 10:21:54 -0400
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20FC57556
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 07:21:51 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imss.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id D02F47F53D;
        Wed, 31 Aug 2022 16:21:49 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 914DC34064;
        Wed, 31 Aug 2022 16:21:49 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70B9E3405A;
        Wed, 31 Aug 2022 16:21:49 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Wed, 31 Aug 2022 16:21:49 +0200 (CEST)
Received: from atlas.intranet.prolan.hu (atlas.intranet.prolan.hu [10.254.0.229])
        by fw2.prolan.hu (Postfix) with ESMTPS id 3ABD27F53D;
        Wed, 31 Aug 2022 16:21:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1661955708; bh=MrkMNQeJ3CXE1whf73Z2LQMtI0tae7mDAW6tGoEPqFI=;
        h=Date:Subject:To:CC:References:From:In-Reply-To:From;
        b=D/+GHIAyXH+21YTliNzis5kACN5oP+WKSh36RjrtrtGu2TgE0nTH2Hh2gZsxuKDz+
         z9H7VRFuDV6v/RKESf1WIsGlMdQJ0MkhbZp/a+h20HQgkIXbYFlDOXGCG0lrUochaZ
         ZpnFkpaUZfSWBbKgNa9W+fBnd0VrU1RbmehVifJ0djkBkJeFZMRRJ2jrULUcdLWSqu
         ZZdeGFZD+lL35zKdEw1pMww6xuFKs90+VjMIVV4OAkRIVbs7Ldo0138mLniUqTzREW
         rEN5ywYoK8bOyScyXbYSmVzfnUHGgsfc7ujsZu/sx8hv9mj+3jQ7LLcJK7KHT7uYsh
         9VFyNYELnHHTw==
Received: from [10.254.7.28] (10.254.7.28) by atlas.intranet.prolan.hu
 (10.254.0.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id 15.1.2507.12; Wed, 31
 Aug 2022 16:21:47 +0200
Message-ID: <79e46d59-436c-ca82-cad4-15c3cb13b1cf@prolan.hu>
Date:   Wed, 31 Aug 2022 16:21:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] Use a spinlock to guard `fep->ptp_clk_on`
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <kernel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
References: <20220831125631.173171-1-csokas.bence@prolan.hu>
 <Yw9qO+3WqqTUAsIG@lunn.ch>
From:   =?UTF-8?B?Q3PDs2vDoXMgQmVuY2U=?= <csokas.bence@prolan.hu>
In-Reply-To: <Yw9qO+3WqqTUAsIG@lunn.ch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.254.7.28]
X-ClientProxiedBy: atlas.intranet.prolan.hu (10.254.0.229) To
 atlas.intranet.prolan.hu (10.254.0.229)
X-EsetResult: clean, is OK
X-EsetId: 37303A29971EF456637D67
X-TM-AS-GCONF: 00
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2022. 08. 31. 16:03, Andrew Lunn wrote:
>> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
>> index b0d60f898249..98d8f8d6034e 100644
>> --- a/drivers/net/ethernet/freescale/fec_main.c
>> +++ b/drivers/net/ethernet/freescale/fec_main.c
>> @@ -2029,6 +2029,7 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
>>   {
>>   	struct fec_enet_private *fep = netdev_priv(ndev);
>>   	int ret;
>> +	unsigned long flags;
> 
> Please keep to reverse christmas tree

checkpatch didn't tell me that was a requirement... Easy to fix though.

>    
>>   	if (enable) {
>>   		ret = clk_prepare_enable(fep->clk_enet_out);
>> @@ -2036,15 +2037,15 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
>>   			return ret;
>>   
>>   		if (fep->clk_ptp) {
>> -			mutex_lock(&fep->ptp_clk_mutex);
>> +			spin_lock_irqsave(&fep->ptp_clk_lock, flags);
> 
> Is the ptp hardware accessed in interrupt context? If not, you can use
> a plain spinlock, not _irqsave..

`fec_suspend()` calls `fec_enet_clk_enable()`, which may be a 
non-preemptible context, I'm not sure how the PM subsystem's internals 
work...
Besides, with the way this driver is built, function call dependencies 
all over the place, I think it's better safe than sorry. I don't think 
there is any disadvantage (besides maybe a few lost cycles) of using 
_irqsave in regular process context anyways.

Bence
