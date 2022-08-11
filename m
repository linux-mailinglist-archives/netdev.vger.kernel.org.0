Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF9BF58FA00
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 11:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbiHKJYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 05:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234353AbiHKJYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 05:24:05 -0400
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229A972EC9
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 02:24:03 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imsva.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id C94187F4F5;
        Thu, 11 Aug 2022 11:23:59 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3C0B34064;
        Thu, 11 Aug 2022 11:23:59 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CED03405A;
        Thu, 11 Aug 2022 11:23:59 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Thu, 11 Aug 2022 11:23:59 +0200 (CEST)
Received: from atlas.intranet.prolan.hu (atlas.intranet.prolan.hu [10.254.0.229])
        by fw2.prolan.hu (Postfix) with ESMTPS id 6E1437F4F5;
        Thu, 11 Aug 2022 11:23:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1660209839; bh=k93DRgqXzscCkBoTxJi6XD/z6GceBqq3VknW66E5qCQ=;
        h=Date:Subject:To:CC:References:From:In-Reply-To:From;
        b=HI+5eGjSITbQ22IMYvtkui5g4nHyuhKYch/+FG11ticwYSiCMgMF7/8n4wvBzgcGi
         FcYX1dl61bQH4XlCtzj8rfjssUsdKqB4WztDMnsLgON3A7k+z0r8vyWGOqp+ocB5e3
         3kxr++OJot7wJanPozGHJ9BssoYafWnr6Evw8jpywJUDBW2rZppTDbev5beEmPIIn+
         h8h6Icf4bSTfk2umO2TlgozTc6XWjDkHmvlEHA9ymddJIyzQN8vwCj/WQSGR+tAQOk
         /bzEvqBw90RqJQQxpy6OMPTc32CC4AoCZDRFU5Tzayaei+IDUTmT9XzcHyGzPTqDle
         dmWURLfF2ERzg==
Received: from [10.254.7.28] (10.254.7.28) by atlas.intranet.prolan.hu
 (10.254.0.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id 15.1.2507.9; Thu, 11
 Aug 2022 11:23:58 +0200
Message-ID: <9aa60160-8d8e-477f-991a-b2f4cc72ddf6@prolan.hu>
Date:   Thu, 11 Aug 2022 11:23:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] fec: Restart PPS after link state change
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>
References: <20220809124119.29922-1-csokas.bence@prolan.hu>
 <YvKZNcVfYdLw7bkm@lunn.ch> <299d74d5-2d56-23f6-affc-78bb3ae3e03c@prolan.hu>
 <YvRH06S/7E6J8RY0@lunn.ch>
From:   =?UTF-8?B?Q3PDs2vDoXMgQmVuY2U=?= <csokas.bence@prolan.hu>
In-Reply-To: <YvRH06S/7E6J8RY0@lunn.ch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.254.7.28]
X-ClientProxiedBy: atlas.intranet.prolan.hu (10.254.0.229) To
 atlas.intranet.prolan.hu (10.254.0.229)
X-EsetResult: clean, is OK
X-EsetId: 37303A29971EF456617362
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


On 2022. 08. 11. 2:05, Andrew Lunn wrote:
>>>
>>>>    	/* Whack a reset.  We should wait for this.
>>>>    	 * For i.MX6SX SOC, enet use AXI bus, we use disable MAC
>>>> @@ -1119,6 +1120,13 @@ fec_restart(struct net_device *ndev)
>>>>    	if (fep->bufdesc_ex)
>>>>    		fec_ptp_start_cyclecounter(ndev);
>>>> +	/* Restart PPS if needed */
>>>> +	if (fep->pps_enable) {
>>>> +		/* Clear flag so fec_ptp_enable_pps() doesn't return immediately */
>>>> +		fep->pps_enable = 0;
>>>
>>> If reset causes PPS to stop, maybe it would be better to do this
>>> unconditionally?
>>
>> But if it wasn't enabled before the reset in the first place, we wouldn't
>> want to unexpectedly start it.
> 
> We should decide what fep->pps_enable actually means. It should be
> enabled, or it is actually enabled? Then it becomes clear if the reset
> function should clear it to reflect the hardware, or if the
> fec_ptp_enable_pps() should not be looking at it, and needs to read
> the status from the hardware.
> 

`fep->pps_enable` is the state of the PPS the driver *believes* to be 
the case. After a reset, this belief may or may not be true anymore: if 
the driver believed formerly that the PPS is down, then after a reset, 
its belief will still be correct, thus nothing needs to be done about 
the situation. If, however, the driver thought that PPS was up, after 
controller reset, it no longer holds, so we need to update our 
world-view (`fep->pps_enable = 0;`), and then correct for the fact that 
PPS just unexpectedly stopped.

>>> Also, if it is always outputting, don't you need to stop it in
>>> fec_drv_remove(). You probably don't want to still going after the
>>> driver is unloaded.
>>
>> Good point, that is one exception we could make to the above statement
>> (though even in this case, userspace *really* should disable PPS before
>> unloading the module).
> 
> Never trust userspace. Ever.

Amen. Said issue is already fixed in the next version of the patch.

> 
>        Andrew

Bence
