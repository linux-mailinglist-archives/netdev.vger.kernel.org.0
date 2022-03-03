Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF114CC6C7
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 21:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236113AbiCCUFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 15:05:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbiCCUFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 15:05:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E1AAC1A6170
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 12:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646337895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IWgWeqE8A+9fsgzmiKdwf44Tn763EpUOGqFVkjmV2vc=;
        b=UAaXuxMul4OcS1VI2mJPwXUC972gw2dwr2u+9JnPblNI+lS3ediviD3/zHQJIBgvnhKkJL
        /0ejsDkVlaa7bnbeJg2KoVzLpuCSjE+/i0cvsZMK8tg5OTNZcgC0psYIECJ9lumQJVswIW
        2DULCHDpiAytCDt++44lpdkL5dfrF8s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534--ON0Nu3nMPOMI-QfFbsyKw-1; Thu, 03 Mar 2022 15:04:54 -0500
X-MC-Unique: -ON0Nu3nMPOMI-QfFbsyKw-1
Received: by mail-wm1-f69.google.com with SMTP id t2-20020a7bc3c2000000b003528fe59cb9so1851013wmj.5
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 12:04:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IWgWeqE8A+9fsgzmiKdwf44Tn763EpUOGqFVkjmV2vc=;
        b=oTTtbHsx7lm7U6m2HYAo9hKxR7qXSar1Lup6G+BkT0QwEChlsgTWDDT9wQ2R/1EBhS
         87SXqvxe1Ea4Hve2jpIfJJB4KQceFZ2saehRzscPS5lv4PLaw2a877vciORzJTH7kK1A
         leG1cJp/sjat29qMHQEANKryqi0i5v+UYC9OnLdaksnfpXvy7jqJsjVAo1UpIgb+Xp/W
         NRkDJYNd2bbIXmU/PVxwJH9WwOImcQk0zD4p65DPbQjjagZUeWF6PiNd75nkgnZ+LxUk
         XT9ENWGXHAhALWj7dWvmT5G3MMLxjfmwIwvqxz/W9Zkdxx4dqaFf5maRk+R3AjqTHfYA
         SkvA==
X-Gm-Message-State: AOAM530PppgUD08MFuuGKq8O8vgAIB1GxXmpmx3YKBW2oVJx/jcCEiMl
        VvL3PGGm7+4wPqNgEokNcxr2ycjdKqAqQu0tZm7x/bmEslnkfRNWpJCt3Rkx0SFvngUVxdvhV/6
        2/Uqk0nlq0KVr0BTs
X-Received: by 2002:a05:6000:16cb:b0:1ef:e0f8:94d6 with SMTP id h11-20020a05600016cb00b001efe0f894d6mr13665595wrf.485.1646337892793;
        Thu, 03 Mar 2022 12:04:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyhOpVU+RdNYvSKBGBNmCx3zRPhFDDfF76HPHnowMrCe96d8dsdEOFjCy/d54Bmrgyd2zC39w==
X-Received: by 2002:a05:6000:16cb:b0:1ef:e0f8:94d6 with SMTP id h11-20020a05600016cb00b001efe0f894d6mr13665579wrf.485.1646337892470;
        Thu, 03 Mar 2022 12:04:52 -0800 (PST)
Received: from [192.168.1.102] ([92.176.231.205])
        by smtp.gmail.com with ESMTPSA id d1-20020a056000114100b001efb97fae45sm2761733wrx.77.2022.03.03.12.04.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 12:04:51 -0800 (PST)
Message-ID: <e0fbf7c7-c09f-0f39-e53a-3118c1b2f193@redhat.com>
Date:   Thu, 3 Mar 2022 21:04:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net: bcmgenet: Return not supported if we don't have a
 WoL IRQ
Content-Language: en-US
To:     Jeremy Linton <jeremy.linton@arm.com>,
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
From:   Javier Martinez Canillas <javierm@redhat.com>
In-Reply-To: <922fab4e-0608-0d46-9379-026a51398b7a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jeremy,

On 3/3/22 21:00, Jeremy Linton wrote:
> Hi,
> 
> On 2/23/22 16:48, Jakub Kicinski wrote:
>> On Wed, 23 Feb 2022 09:54:26 -0800 Florian Fainelli wrote:
>>>> I have no problems working with you to improve the driver, the problem
>>>> I have is this is currently a regression in 5.17 so I would like to
>>>> see something land, whether it's reverting the other patch, landing
>>>> thing one or another straight forward fix and then maybe revisit as
>>>> whole in 5.18.
>>>
>>> Understood and I won't require you or me to complete this investigating
>>> before fixing the regression, this is just so we understand where it
>>> stemmed from and possibly fix the IRQ layer if need be. Given what I
>>> just wrote, do you think you can sprinkle debug prints throughout the
>>> kernel to figure out whether enable_irq_wake() somehow messes up the
>>> interrupt descriptor of interrupt and test that theory? We can do that
>>> offline if you want.
>>
>> Let me mark v2 as Deferred for now, then. I'm not really sure if that's
>> what's intended but we have 3 weeks or so until 5.17 is cut so we can
>> afford a few days of investigating.
>>
>> I'm likely missing the point but sounds like the IRQ subsystem treats
>> IRQ numbers as unsigned so if we pass a negative value "fun" is sort
>> of expected. Isn't the problem that device somehow comes with wakeup
>> capable being set already? Isn't it better to make sure device is not
>> wake capable if there's no WoL irq instead of adding second check?
>>
>> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>> index cfe09117fe6c..7dea44803beb 100644
>> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>> @@ -4020,12 +4020,12 @@ static int bcmgenet_probe(struct platform_device *pdev)
>>   
>>   	/* Request the WOL interrupt and advertise suspend if available */
>>   	priv->wol_irq_disabled = true;
>> -	if (priv->wol_irq > 0) {
>> +	if (priv->wol_irq > 0)
>>   		err = devm_request_irq(&pdev->dev, priv->wol_irq,
>>   				       bcmgenet_wol_isr, 0, dev->name, priv);
>> -		if (!err)
>> -			device_set_wakeup_capable(&pdev->dev, 1);
>> -	}
>> +	else
>> +		err = -ENOENT;
>> +	device_set_wakeup_capable(&pdev->dev, !err);
>>   
>>   	/* Set the needed headroom to account for any possible
>>   	 * features enabling/disabling at runtime
>>
> 
> 
> I duplicated the problem on rpi4/ACPI by moving to gcc12, so I have a/b 
> config that is close as I can achieve using gcc11 vs 12 and the one 
> built with gcc12 fails pretty consistently while the gcc11 works.
> 

Did Peter's patch instead of this one help ?

-- 
Best regards,

Javier Martinez Canillas
Linux Engineering
Red Hat

