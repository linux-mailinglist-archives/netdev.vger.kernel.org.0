Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A99A28A215
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388701AbgJJWyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731262AbgJJTFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:05:24 -0400
Received: from mo6-p00-ob.smtp.rzone.de (mo6-p00-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5300::11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5B6C05BD38;
        Sat, 10 Oct 2020 09:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1602347097;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=yaxlQrst36IygI7MJFDli/+6A/eBm0GVYENbEKpqTqY=;
        b=PX2rzFbeKg1RmEivQ2mjxlmpeouWeh/3lRtV6RsnOFjeocjqfKebM0HE1O7tOSutI4
        EKURmTVzILyygQnHt3AkAJXmruK6+DTX+GoA64bWcE19MoFJbc67HKEWKJfcEuJGQKfF
        U6FskbWpRoCa5ahG0xTTf6Q7Ro797JHLiRPHGTsVnDkKdwyPQ4PJY0TOCArIAUwuxLGw
        93UlFi7UG61KaPBAUuRIRAef8a4X9qxtvRvy5XBqTW9FtYCSYuhZHqcab+cptBaSZJw8
        oitHlfEjt53PFPG2aqcHPWw5ktVa5Z1lHV7w0pYWzyweTbeY9MNJkVFdeaUoCzwjnj+d
        wL0Q==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3HMbEWLW0JK2wEH"
X-RZG-CLASS-ID: mo00
Received: from [192.168.50.177]
        by smtp.strato.de (RZmta 47.2.1 DYNA|AUTH)
        with ESMTPSA id D0b41cw9AGOmM2g
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sat, 10 Oct 2020 18:24:48 +0200 (CEST)
Subject: Re: [PATCH 08/17] can: add ISO 15765-2:2016 transport protocol
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de
References: <20201007213159.1959308-1-mkl@pengutronix.de>
 <20201007213159.1959308-9-mkl@pengutronix.de>
 <20201009175751.5c54097f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <bcebf26e-3cfb-c7aa-e7fc-4faa744b9c2f@hartkopp.net>
 <20201010084421.308645a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <10c8b62c-e522-aaa4-2e75-d1c1bd630735@hartkopp.net>
Date:   Sat, 10 Oct 2020 18:24:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201010084421.308645a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10.10.20 17:44, Jakub Kicinski wrote:
> On Sat, 10 Oct 2020 16:29:06 +0200 Oliver Hartkopp wrote:
>>>> diff --git a/net/can/Kconfig b/net/can/Kconfig
>>>> index 25436a715db3..021fe03a8ed6 100644
>>>> --- a/net/can/Kconfig
>>>> +++ b/net/can/Kconfig
>>>> @@ -55,6 +55,19 @@ config CAN_GW
>>>>    
>>>>    source "net/can/j1939/Kconfig"
>>>>    
>>>> +config CAN_ISOTP
>>>> +	tristate "ISO 15765-2:2016 CAN transport protocol"
>>>> +	default y
>>>
>>> default should not be y unless there is a very good reason.
>>> I don't see such reason here. This is new functionality, users
>>> can enable it if they need it.
>>
>> Yes. I agree. But there is a good reason for it.
>> The ISO 15765-2 protocol is used for vehicle diagnosis and is a *very*
>> common CAN bus use case.
> 
> More common than j1939? (Google uses words like 'widely used' and
> 'common' :)) To give you some perspective we don't enable Ethernet
> vlan support by default, vlans are pretty common, too.
> 
>> The config item only shows up when CONFIG_CAN is selected and then ISO
>> 15765-2 should be enabled too. I have implemented and maintained the
>> out-of-tree driver for ~12 years now and the people have real problems
>> using e.g. Ubuntu with signed kernel modules when they need this protocol.
>>
>> Therefore the option should default to 'y' to make sure the common
>> distros (that enable CONFIG_CAN) enable ISO-TP too.
> 
> I understand the motivation, but Linus had pushed back on defaulting to
> 'y' many times over the years, please read this:
> 
> https://lkml.org/lkml/2012/1/6/354
> 
> This really must not pop up on his screen as default 'y' when he does
> an oldconfig after pulling the networking tree..
> 

Ok. Understood.

I'll remove the default=y then. Would it be ok to add some text like

If you want to perfrom automotive vehicle diagnostic services (UDS), say 
'y'.

?

Best regards,
Oliver
