Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4651D5A7F85
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 16:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbiHaOEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 10:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbiHaOEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 10:04:23 -0400
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BD0D6BB5
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 07:04:15 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imsva.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id AA4D67F53D;
        Wed, 31 Aug 2022 16:04:11 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8817434064;
        Wed, 31 Aug 2022 16:04:11 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 703E13405A;
        Wed, 31 Aug 2022 16:04:11 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Wed, 31 Aug 2022 16:04:11 +0200 (CEST)
Received: from atlas.intranet.prolan.hu (atlas.intranet.prolan.hu [10.254.0.229])
        by fw2.prolan.hu (Postfix) with ESMTPS id 474807F53D;
        Wed, 31 Aug 2022 16:04:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1661954651; bh=yUTkUyK5cA+MyO/0wzy5rqI0ntj5bTFNfdBfG9/u5Bk=;
        h=Date:Subject:To:CC:References:From:In-Reply-To:From;
        b=sD4vnwPWkf2mDB45JSorLjDS/V6+Ee/7r8nJEv+bXaQGtpDRTQNn+GJ+a+pmYxHYq
         u7ERph1d80b10FHSG24Und2qzSIKw6t6/M5KJNaXJI45mkEZYu/8wXzHfiZj/IH80j
         3dGm5GJaFBYf5ut3cZNmMrsdMs4/Y8FZLOQc4BZFCCPLNSHNvuew6/nUoJi+2YXcqc
         q95MVaGGkBRjF/kxKTajbRl5PrfP3mxcFwwRvIwxnfLZmNMRR4e2YRVY1ZYhjK+qgo
         UEMQ7fZ8llf85zy+6roMOYTkHYV+hA2Hp79Bireg64OZyxy9cIJyGFADRb4VRyYWB9
         DbU+yOODOPNgg==
Received: from [10.254.7.28] (10.254.7.28) by atlas.intranet.prolan.hu
 (10.254.0.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id 15.1.2507.12; Wed, 31
 Aug 2022 16:04:10 +0200
Message-ID: <3b6d6d70-c754-d26b-bdba-6046086868fa@prolan.hu>
Date:   Wed, 31 Aug 2022 16:04:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] Use a spinlock to guard `fep->ptp_clk_on`
Content-Language: en-US
To:     Richard Cochran <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        <kernel@pengutronix.de>, Marc Kleine-Budde <mkl@pengutronix.de>
References: <20220831125631.173171-1-csokas.bence@prolan.hu>
 <Yw9n/JfdenzRkAyq@hoboy.vegasvil.org>
From:   =?UTF-8?B?Q3PDs2vDoXMgQmVuY2U=?= <csokas.bence@prolan.hu>
In-Reply-To: <Yw9n/JfdenzRkAyq@hoboy.vegasvil.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
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


On 2022. 08. 31. 15:54, Richard Cochran wrote:
> On Wed, Aug 31, 2022 at 02:56:31PM +0200, Csókás Bence wrote:
> 
>> diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
>> index c74d04f4b2fd..dc8564a1f2d2 100644
>> --- a/drivers/net/ethernet/freescale/fec_ptp.c
>> +++ b/drivers/net/ethernet/freescale/fec_ptp.c
>> @@ -365,21 +365,21 @@ static int fec_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
>>    */
>>   static int fec_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
>>   {
>> -	struct fec_enet_private *adapter =
>> +	struct fec_enet_private *fep =
>>   	    container_of(ptp, struct fec_enet_private, ptp_caps);
>>   	u64 ns;
>> -	unsigned long flags;
>> +	unsigned long flags, flags2;
>>   
>> -	mutex_lock(&adapter->ptp_clk_mutex);
>> +	spin_lock_irqsave(&fep->ptp_clk_lock, flags);
>>   	/* Check the ptp clock */
>> -	if (!adapter->ptp_clk_on) {
>> -		mutex_unlock(&adapter->ptp_clk_mutex);
>> +	if (!fep->ptp_clk_on) {
> 
> BTW This test is silly. If functionality isn't available then the code
> should simply not register the clock in the first place.

As I understand, `ptp_clk_on` is a flag indicating whether `clk_ipg` is 
running or not, and not a capability thing. The driver switches it 
run-time in `fec_enet_clk_enable()`.

> 
>> +		spin_unlock_irqrestore(&fep->ptp_clk_lock, flags);
>>   		return -EINVAL;
>>   	}
>> -	spin_lock_irqsave(&adapter->tmreg_lock, flags);
>> -	ns = timecounter_read(&adapter->tc);
>> -	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
>> -	mutex_unlock(&adapter->ptp_clk_mutex);
>> +	spin_lock_irqsave(&fep->tmreg_lock, flags2);
>> +	ns = timecounter_read(&fep->tc);
>> +	spin_unlock_irqrestore(&fep->tmreg_lock, flags2);
>> +	spin_unlock_irqrestore(&fep->ptp_clk_lock, flags);
> 
> Two spin locks?  Why not just use one?

One guards the FEC_ATIME_* registers, the other the `ptp_clk_on` flag. 
For instance, `fec_ptp_adjfreq()` takes `tmreg_lock` but not 
`ptp_clk_lock`, and similarly `fec_enet_clk_enable()` takes 
`ptp_clk_lock` but not `tmreg_lock`.

> 
> Thanks,
> Richard
