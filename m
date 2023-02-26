Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8725F6A325A
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 16:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjBZPdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 10:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjBZPdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 10:33:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6FB1C7C5
        for <netdev@vger.kernel.org>; Sun, 26 Feb 2023 07:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677425340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rTktfxZwtI3edyA7DLn/cAMf6iDgc+CleFwYcc1Xf6o=;
        b=DUFb91NePo45/9GpfoYDgorpRnKgNVFyoWboXXaA4lTMcUm8ALLFFHwcElKjwVN+W6yZ+L
        BM+etHLfZuOlPDU5yoiNwtdBSa9CfeevMB47+e3DPNuL3gbk7RZ2bB1kETFe61xv5WAAvg
        VsJUUawK0UuJt9nnXmTms+XFey3J9Q4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-128-ONcoYF-hOR29o3NhmBn8TA-1; Sun, 26 Feb 2023 10:15:05 -0500
X-MC-Unique: ONcoYF-hOR29o3NhmBn8TA-1
Received: by mail-qk1-f197.google.com with SMTP id bi9-20020a05620a318900b007423009db80so2620716qkb.7
        for <netdev@vger.kernel.org>; Sun, 26 Feb 2023 07:15:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rTktfxZwtI3edyA7DLn/cAMf6iDgc+CleFwYcc1Xf6o=;
        b=365/xDMHXdkjcOlMdmrFk7jV8ZjtqbZ4Lm/3om/bq0PXzv90SA6SEtF14U629F4/iO
         AnwRTnrn/TwstU2N6gNhsl3HR/p/6/piuqWvw7k8XX6IcKcYBvuQR08wTYPRCLiPP9kG
         kdJfV4fLICXoWTqX33agKI0mr3kQ2RM5KmR8X2Qxsf55brqWjWziK8V0SK8bKMrK4TN+
         i3pSxoCN5+Bal/bYltSWqJaojaf64QoUHUmJzoyj7XZK9zMzv3ZTOLbNXyKHmcSWmjyF
         6jZTuuu1A2NPMNFhyJ+1FCDvBqJlcKa/YytE04E178bAqLqx1uR3tBa+QF1MFUAVIHOK
         6tSQ==
X-Gm-Message-State: AO0yUKUhgBVtQ5iCa2oOfvaFSTEmciR6/wPrHCc90VPczb2W+K/mfcDl
        zJi5GUkmBsNbOkoB435LJ3pPU1ksFI84J4qbyogQdFXNiPMxuGGjLwy2IzLDwfXJYrp7GvrGeZv
        CGYpxtcoSmkdKmV8a
X-Received: by 2002:a05:622a:306:b0:3bf:cae4:296c with SMTP id q6-20020a05622a030600b003bfcae4296cmr8080283qtw.65.1677424505000;
        Sun, 26 Feb 2023 07:15:05 -0800 (PST)
X-Google-Smtp-Source: AK7set+mgsMR8WIzdmn8+0YXxIypXauyD4KLACbG8laibpGHvIIR1aKNjfnpSmGoph7EE92bIXOGxg==
X-Received: by 2002:a05:622a:306:b0:3bf:cae4:296c with SMTP id q6-20020a05622a030600b003bfcae4296cmr8080246qtw.65.1677424504739;
        Sun, 26 Feb 2023 07:15:04 -0800 (PST)
Received: from [192.168.1.19] (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id x30-20020ac84d5e000000b003bfb62a377fsm3075739qtv.3.2023.02.26.07.15.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Feb 2023 07:15:04 -0800 (PST)
Subject: Re: [PATCH] net: lan743x: LAN743X selects FIXED_PHY to resolve a link
 error
To:     Simon Horman <simon.horman@corigine.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steen.hegelund@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
References: <20230219150321.2683358-1-trix@redhat.com>
 <Y/JnZwUEXycgp8QJ@corigine.com> <Y/LKpsjteUAXVIb0@lunn.ch>
 <Y/MXNWKrrI3aRju+@corigine.com> <Y/QskwGx+A1jACB2@lunn.ch>
 <Y/TvS+D76/N0WyWc@corigine.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <04374e51-c7e5-b1d9-d617-d1abf47ec44b@redhat.com>
Date:   Sun, 26 Feb 2023 07:15:01 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <Y/TvS+D76/N0WyWc@corigine.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/21/23 8:20 AM, Simon Horman wrote:
> +Arnd
>
> On Tue, Feb 21, 2023 at 03:29:39AM +0100, Andrew Lunn wrote:
>> On Mon, Feb 20, 2023 at 07:46:13AM +0100, Simon Horman wrote:
>>> On Mon, Feb 20, 2023 at 02:19:34AM +0100, Andrew Lunn wrote:
>>>> On Sun, Feb 19, 2023 at 07:16:07PM +0100, Simon Horman wrote:
>>>>> On Sun, Feb 19, 2023 at 10:03:21AM -0500, Tom Rix wrote:
>>>>>> A rand config causes this link error
>>>>>> drivers/net/ethernet/microchip/lan743x_main.o: In function `lan743x_netdev_open':
>>>>>> drivers/net/ethernet/microchip/lan743x_main.c:1512: undefined reference to `fixed_phy_register'
>>>>>>
>>>>>> lan743x_netdev_open is controlled by LAN743X
>>>>>> fixed_phy_register is controlled by FIXED_PHY
>>>>>>
>>>>>> So LAN743X should also select FIXED_PHY
>>>>>>
>>>>>> Signed-off-by: Tom Rix <trix@redhat.com>
>>>>> Hi Tom,
>>>>>
>>>>> I am a little confused by this.
>>>>>
>>>>> I did manage to cook up a config with LAN743X=m and FIXED_PHY not set.
>>>>> But I do not see a build failure, and I believe that is because
>>>>> when FIXED_PHY is not set then a stub version of fixed_phy_register(),
>>>>> defined as static inline in include/linux/phy_fixed.h, is used.
>>>>>
>>>>> Ref: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/include/linux/phy_fixed.h?h=main&id=675f176b4dcc2b75adbcea7ba0e9a649527f53bd#n42
>>>> I'n guessing, but it could be that LAN743X is built in, and FIXED_PHY
>>>> is a module? What might be needed is
>>>>
>>>> depends on FIXED_PHY || FIXED_PHY=n
>>> Thanks Andrew,
>>>
>>> LAN743X=y and FIXED_PHY=m does indeed produce the problem that Tom
>>> describes. And his patch does appear to resolve the problem.
>> O.K. So the commit message needs updating to describe the actual
>> problem.
> Yes, that would be a good improvement.
>
> Perhaps a fixes tag too?
>
>>> Unfortunately your proposed solution seems to run foul of a complex
>>> dependency situation.
>> I was never any good at Kconfig. Arnd is the expert at solving
>> problems like this.
>>
>> You want either everything built in, or FIXED_PHY built in and LAN743X
>> modular, or both modular.
> I _think_ the patch, which uses select FIXED_PHY for LAN743X,
> achieves that.
>
> I CCed Arnd in case he has any input. Though I think I read
> in an recent email from him that he is out most of this week.

I was out last week as well :)

I considered this a cleanup rather than a fix, I can add that fixes tag.

 From my point of view this is a linking problem, I don't mind 
changing,  what commit message should I use ?

Tom

>

