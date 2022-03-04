Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDD04CDADA
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241384AbiCDRfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236903AbiCDRer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:34:47 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E3841CD9D0
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:33:48 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2B04F1424;
        Fri,  4 Mar 2022 09:33:48 -0800 (PST)
Received: from [192.168.122.164] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D43D73F73D;
        Fri,  4 Mar 2022 09:33:47 -0800 (PST)
Message-ID: <6fc548ca-1195-8941-5caa-2e3384debad7@arm.com>
Date:   Fri, 4 Mar 2022 11:33:43 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net: bcmgenet: Return not supported if we don't have a
 WoL IRQ
Content-Language: en-US
To:     Javier Martinez Canillas <javierm@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Peter Robinson <pbrobinson@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
References: <20220222095348.2926536-1-pbrobinson@gmail.com>
 <f79df42b-ff25-edaa-7bf3-00b44b126007@gmail.com>
 <CALeDE9NGckRoatePdaWFYqHXHcOJ2Xzd4PGLOoNWDibzPB_zXQ@mail.gmail.com>
 <734024dc-dadd-f92d-cbbb-c8dc9c955ec3@gmail.com>
 <CALeDE9Nk8gvCS425pJe5JCgcfSZugSnYwzGOkxhszrBz3Da6Fg@mail.gmail.com>
 <3ae3a9fc-9dd1-00c6-4ae8-a65df3ed225f@gmail.com>
 <CALeDE9PK9JkFkbTc36HOZH8CG8MM3OMhKJ24FKioKF5bspSPkA@mail.gmail.com>
 <6cefe7ca-842b-d3af-0299-588b9307703b@gmail.com>
 <20220223144818.2f9ce725@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <922fab4e-0608-0d46-9379-026a51398b7a@arm.com>
 <e0fbf7c7-c09f-0f39-e53a-3118c1b2f193@redhat.com>
From:   Jeremy Linton <jeremy.linton@arm.com>
In-Reply-To: <e0fbf7c7-c09f-0f39-e53a-3118c1b2f193@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 3/3/22 14:04, Javier Martinez Canillas wrote:
> Hello Jeremy,
> 
> On 3/3/22 21:00, Jeremy Linton wrote:
>> Hi,
>>
>> On 2/23/22 16:48, Jakub Kicinski wrote:
>>> On Wed, 23 Feb 2022 09:54:26 -0800 Florian Fainelli wrote:
>>>>> I have no problems working with you to improve the driver, the problem
>>>>> I have is this is currently a regression in 5.17 so I would like to
>>>>> see something land, whether it's reverting the other patch, landing
>>>>> thing one or another straight forward fix and then maybe revisit as
>>>>> whole in 5.18.
>>>>
>>>> Understood and I won't require you or me to complete this investigating
>>>> before fixing the regression, this is just so we understand where it
>>>> stemmed from and possibly fix the IRQ layer if need be. Given what I
>>>> just wrote, do you think you can sprinkle debug prints throughout the
>>>> kernel to figure out whether enable_irq_wake() somehow messes up the
>>>> interrupt descriptor of interrupt and test that theory? We can do that
>>>> offline if you want.
>>>
>>> Let me mark v2 as Deferred for now, then. I'm not really sure if that's
>>> what's intended but we have 3 weeks or so until 5.17 is cut so we can
>>> afford a few days of investigating.
>>>
>>> I'm likely missing the point but sounds like the IRQ subsystem treats
>>> IRQ numbers as unsigned so if we pass a negative value "fun" is sort
>>> of expected. Isn't the problem that device somehow comes with wakeup
>>> capable being set already? Isn't it better to make sure device is not
>>> wake capable if there's no WoL irq instead of adding second check?
>>>
>>> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>>> index cfe09117fe6c..7dea44803beb 100644
>>> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>>> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>>> @@ -4020,12 +4020,12 @@ static int bcmgenet_probe(struct platform_device *pdev)
>>>    
>>>    	/* Request the WOL interrupt and advertise suspend if available */
>>>    	priv->wol_irq_disabled = true;
>>> -	if (priv->wol_irq > 0) {
>>> +	if (priv->wol_irq > 0)
>>>    		err = devm_request_irq(&pdev->dev, priv->wol_irq,
>>>    				       bcmgenet_wol_isr, 0, dev->name, priv);
>>> -		if (!err)
>>> -			device_set_wakeup_capable(&pdev->dev, 1);
>>> -	}
>>> +	else
>>> +		err = -ENOENT;
>>> +	device_set_wakeup_capable(&pdev->dev, !err);
>>>    
>>>    	/* Set the needed headroom to account for any possible
>>>    	 * features enabling/disabling at runtime
>>>
>>
>>
>> I duplicated the problem on rpi4/ACPI by moving to gcc12, so I have a/b
>> config that is close as I can achieve using gcc11 vs 12 and the one
>> built with gcc12 fails pretty consistently while the gcc11 works.
>>
> 
> Did Peter's patch instead of this one help ?
> 

No, it seems to be the same problem. The second irq is registered, but 
never seems to fire. There are a couple odd compiler warnings about 
infinite recursion in memcpy()/etc I was looking at, but nothing really 
pops out. Its like the adapter never gets the command submissions 
(although link/up/down appear to be working/etc).


