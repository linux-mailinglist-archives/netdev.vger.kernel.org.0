Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBCFC5AA8CE
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 09:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234641AbiIBHgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 03:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbiIBHgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 03:36:07 -0400
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1885A53D2B
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 00:35:59 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imss.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id 3D5777F4A9;
        Fri,  2 Sep 2022 09:35:58 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2889334064;
        Fri,  2 Sep 2022 09:35:58 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E3503405A;
        Fri,  2 Sep 2022 09:35:58 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Fri,  2 Sep 2022 09:35:58 +0200 (CEST)
Received: from atlas.intranet.prolan.hu (atlas.intranet.prolan.hu [10.254.0.229])
        by fw2.prolan.hu (Postfix) with ESMTPS id CCFC17F4A9;
        Fri,  2 Sep 2022 09:35:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1662104157; bh=BfATqbZYQgFnaahUr7guN6Z7Y9sMOU9KAZ7zMQjSyuk=;
        h=Date:Subject:To:CC:References:From:In-Reply-To:From;
        b=cymMT1HQDZ/VBFfMJ6Gus9wrg5uOKpQNAXBwmwOxP+vvTKi+33+sgVrp3BWcyireZ
         YTwGHsN0t4F4RmDMBCzb+R0rUzPAzrMom3KQLMnoF+hUqbte693FcttcLIjKgYrjPu
         gp3iAsBDKdlaqTyaTLfKTceNCkIQHx95SqT7LetFqiUaQskXCHVaOeXdUL9fFOTdbd
         5qBx2ekxlX0cb66bvyWxcSKZKiBBxZieGdW6jbCnPOZzAgpz/caD9OHfhLqlbTWZwC
         l/9NLSmAvRf8JPNtPWbxmEqjVuqE6qroyLXD4WD3k9q+wNYDtZq1TotSGowX/p5AVY
         xtxe3511qBWQw==
Received: from [10.254.7.28] (10.254.7.28) by atlas.intranet.prolan.hu
 (10.254.0.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id 15.1.2507.12; Fri, 2
 Sep 2022 09:35:57 +0200
Message-ID: <6703a552-8d23-6136-c0b8-c68845d00aa8@prolan.hu>
Date:   Fri, 2 Sep 2022 09:35:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] net: fec: Use a spinlock to guard `fep->ptp_clk_on`
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>, <netdev@vger.kernel.org>
CC:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Andrew Lunn <andrew@lunn.ch>, <kernel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
References: <20220901140402.64804-1-csokas.bence@prolan.hu>
 <80f9cb5b-0e02-a367-5263-4fbffec055bb@gmail.com>
From:   =?UTF-8?B?Q3PDs2vDoXMgQmVuY2U=?= <csokas.bence@prolan.hu>
In-Reply-To: <80f9cb5b-0e02-a367-5263-4fbffec055bb@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.254.7.28]
X-ClientProxiedBy: atlas.intranet.prolan.hu (10.254.0.229) To
 atlas.intranet.prolan.hu (10.254.0.229)
X-EsetResult: clean, is OK
X-EsetId: 37303A29971EF456627561
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


On 2022. 09. 01. 18:26, Florian Fainelli wrote:
> 
>>       schedule_delayed_work(&fep->time_keep, HZ);
>>   }
>> @@ -599,8 +593,6 @@ void fec_ptp_init(struct platform_device *pdev, 
>> int irq_idx)
>>       }
>>       fep->ptp_inc = NSEC_PER_SEC / fep->cycle_speed;
>> -    spin_lock_init(&fep->tmreg_lock);
> 
> This change needs to be kept as there is no other code in the driver 
> that would initialize the tmreg_lock otherwise. Try building a kernel 
> with spinlock debugging enabled and you should see it barf with an 
> incorrect spinlock bad magic.

`fec_ptp_init()` is called from `fec_probe()`, which init's the spinlock:

 > @@ -3907,7 +3908,7 @@ fec_probe(struct platform_device *pdev)
 >         }
 >
 >         fep->ptp_clk_on = false;
 > -       mutex_init(&fep->ptp_clk_mutex);
 > +       spin_lock_init(&fep->tmreg_lock);

Bence
