Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 068BE64F3FD
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 23:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiLPWV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 17:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiLPWU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 17:20:56 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79D337202
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 14:19:30 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 3160185098;
        Fri, 16 Dec 2022 23:19:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1671229169;
        bh=bj854G/7Rp4j3Je+CK5gOvgMIfPGsuKIkJ0QDdF+6HI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=bUj+JChEFEoKd70dCbxE/Re4wfmE5ZmAmCYmzTFNL6ELpP4zH8840h4MYI4/D51au
         dkD60TV/kVYIit0gaFF4KZtaB9FzXUCprEKysHVGyG+iTnq//C6M0vOxGl+mc5atxg
         FjeS0WCExCHQIHSynKXTcvZHndS3cTLd07OAXWMJSPMegcieEFt6lpNdS+c/sQ50Bx
         Yv741mRUmRTzIcn480DaM+hetW5I3IPMVgCKj31TaAGcFS9dbwaaLxRJpnKqXydLS6
         s6wlcuOhwE9vGB07KRJKG2b/Zm/6/l3nn4ALVqClmGEE+DJGhi7qVoMeB/0OndEotz
         3FuJmh3pzOuKA==
Message-ID: <7a50a241-0a93-3e44-bcc7-b9e07c62d616@denx.de>
Date:   Fri, 16 Dec 2022 23:19:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] net: ks8851: Drop IRQ threading
Content-Language: en-US
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Geoff Levand <geoff@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@nvidia.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
References: <20221216124731.122459-1-marex@denx.de>
 <CANn89i+08T_1pDZ-FWikarVq=5q4MVAx=+mRkSqeinfb10OdOg@mail.gmail.com>
 <Y5zpMILXRnW2+dBU@google.com>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <Y5zpMILXRnW2+dBU@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/16/22 22:54, Dmitry Torokhov wrote:
> On Fri, Dec 16, 2022 at 02:23:04PM +0100, Eric Dumazet wrote:
>> On Fri, Dec 16, 2022 at 1:47 PM Marek Vasut <marex@denx.de> wrote:
>>>
>>> Request non-threaded IRQ in the KSZ8851 driver, this fixes the following warning:
>>> "
>>> NOHZ tick-stop error: Non-RCU local softirq work is pending, handler #08!!!
>>
>> This changelog is a bit terse.
>>
>> Why can other drivers use request_threaded_irq(), but not this one ?
> 
> This one actually *has* to use threading, as (as far as I can see) the
> "lock" that is being taken in ks8851_irq for the SPI variant of the
> device is actually a mutex, so we have to be able to sleep in the
> interrupt handler...

So maybe we should use threaded one for the SPI variant and non-threaded 
one for the Parallel bus variant ?
