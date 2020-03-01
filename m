Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68D201750EA
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 00:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgCAXUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 18:20:51 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38431 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgCAXUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 18:20:51 -0500
Received: by mail-wm1-f68.google.com with SMTP id u9so3104501wml.3
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 15:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Po3bQ1FDvw0jaZJNTDribYgNfZfYPBBa6cRZVoZLfbo=;
        b=JQoQUpVi+qUWyOCiD4WMCZWAPM+K1X/0UTvRn1Kr1JRALIQzxugV4blXD2jwP5cg0l
         hHGyqLsLH2APh01bMjo5+D1ZDuLr3vr3SBW3vQEXIzI92H9ZqzEzETL2cAJSjit9QEAf
         WrBziZ7tHl5RV6B4FOcoWUH6CZgS01A/sXWlGdEvKFdTamIs+1X5ql6Dr1JYmFCiweeB
         /bQRl6yCV1oBIXWCVhTOn0UARR/qgH5hVIKTRvH86ESeIIqyMzw3tvuEg/7gCIC7ftO2
         t3H/hRbc6/c3JAUMLBH0sp7BYKh+JBfyVvbupDsdHA5qFKJPvWIX+dcdUeN40NhnO9qO
         sfpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Po3bQ1FDvw0jaZJNTDribYgNfZfYPBBa6cRZVoZLfbo=;
        b=jGaMn/t4wBNmGX/YV4BtN1aPHWDtzL0qsbTeJEVH0QbqJuKP5vawH2T0Bjv3GHABnm
         UM2HOGC6rDNMflqLWyTZhWWPF7AnyuzuKWLurluKbbrH/ygySpJPDBSUUy1kKKzLfESi
         X/QRawmI3k1p+IoWf8zAmw1KzSVyOkANYQhO/oaCMC62fir2M5EaBoQjufcbqzPxXQY/
         8tcgRknimvaLbsKNa64wK+ds4lEZKfxrldQQXDDFZCxe/sMUh5iz4q7TAx4OvsQS60SE
         ZD94mJLeggUkS1IXAnPIqXwWvg7y9oUX5qmCMqshHKPQT+LMuXFzvv7dXb1OuHLZ2BPU
         +7yQ==
X-Gm-Message-State: APjAAAVqJfP0VgUGUh7dxq+atbqRvUyWBZPumVaetx+HfcR7REKgwL+6
        cnC2q+FwQ/MV4Na8/wBj6HV+uVBA
X-Google-Smtp-Source: APXvYqxikrAxozlUbEL6vCrLGD6gaYtLmHDyX1vPLIyFCkccCb7Ur9AaU/oEzhEcNIi6xVDPw0DC4g==
X-Received: by 2002:a05:600c:2409:: with SMTP id 9mr16681842wmp.140.1583104848714;
        Sun, 01 Mar 2020 15:20:48 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:19d8:a359:9f77:aae2? (p200300EA8F29600019D8A3599F77AAE2.dip0.t-ipconnect.de. [2003:ea:8f29:6000:19d8:a359:9f77:aae2])
        by smtp.googlemail.com with ESMTPSA id f17sm13554726wrj.28.2020.03.01.15.20.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2020 15:20:48 -0800 (PST)
Subject: Re: [PATCH net] net: phy: avoid clearing PHY interrupts twice in irq
 handler
To:     Michael Walle <michael@walle.cc>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
References: <2f468a46-e966-761c-8466-51601d8f11a3@gmail.com>
 <a0b161ebd332c9ea26bb62ccf73d1862@walle.cc>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <a33c33d6-621a-4139-0e81-eb0d0fd0e095@gmail.com>
Date:   Mon, 2 Mar 2020 00:20:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <a0b161ebd332c9ea26bb62ccf73d1862@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.03.2020 23:52, Michael Walle wrote:
> Am 2020-03-01 21:36, schrieb Heiner Kallweit:
>> On all PHY drivers that implement did_interrupt() reading the interrupt
>> status bits clears them. This means we may loose an interrupt that
>> is triggered between calling did_interrupt() and phy_clear_interrupt().
>> As part of the fix make it a requirement that did_interrupt() clears
>> the interrupt.
> 
> Looks good. But how would you use did_interrupt() and handle_interrupt()
> together? I guess you can't. At least not if handle_interrupt() has
> to read the pending bits again. So you'd have to handle custom
> interrupts in did_interrupt(). Any idea how to solve that?
> 
> [I know, this is only about fixing the lost interrupts.]
> 
Right, this one is meant for stable to fix the issue with the potentially
lost interrupts. Based on it I will submit a patch for net-next that
tackles the issue that did_interrupt() has to read (and therefore clear)
irq status bits and therefore makes them unusable for handle_interrupt().
The basic idea is that did_interrupt() is called only if handle_interrupt()
isn't implemented. handle_interrupt() has to include the did_interrupt
functionality. It can read the irq status once and store it in a variable
for later use.

> -michael
> 
>>
>> The Fixes tag refers to the first commit where the patch applies
>> cleanly.
>>
>> Fixes: 49644e68f472 ("net: phy: add callback for custom interrupt
>> handler to struct phy_driver")
>> Reported-by: Michael Walle <michael@walle.cc>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/phy/phy.c | 3 ++-
>>  include/linux/phy.h   | 1 +
>>  2 files changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
>> index d76e038cf..16e3fb79e 100644
>> --- a/drivers/net/phy/phy.c
>> +++ b/drivers/net/phy/phy.c
>> @@ -727,7 +727,8 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
>>          phy_trigger_machine(phydev);
>>      }
>>
>> -    if (phy_clear_interrupt(phydev))
>> +    /* did_interrupt() may have cleared the interrupt already */
>> +    if (!phydev->drv->did_interrupt && phy_clear_interrupt(phydev))
>>          goto phy_err;
>>      return IRQ_HANDLED;
>>
>> diff --git a/include/linux/phy.h b/include/linux/phy.h
>> index 80f8b2158..8b299476b 100644
>> --- a/include/linux/phy.h
>> +++ b/include/linux/phy.h
>> @@ -557,6 +557,7 @@ struct phy_driver {
>>      /*
>>       * Checks if the PHY generated an interrupt.
>>       * For multi-PHY devices with shared PHY interrupt pin
>> +     * Set interrupt bits have to be cleared.
>>       */
>>      int (*did_interrupt)(struct phy_device *phydev);

