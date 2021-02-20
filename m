Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22AA320573
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 13:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhBTMww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 07:52:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhBTMwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Feb 2021 07:52:50 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20F8C061574;
        Sat, 20 Feb 2021 04:52:09 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id h98so8851223wrh.11;
        Sat, 20 Feb 2021 04:52:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0tR0TOAYEuGHdERPvVTexth/QYZWyi3r7lB02iejQNk=;
        b=lzhCiUZVCi3QTfbc3QFiIjhwKk4T/co+c+jwFiIiXzTnymLGBB85aERwRD49l9w7Gj
         Punvjyw1ts3kD0Vw8BvZeiHKg6j8yS3jYE+g7DUtglA11RAo8tNgCFJQZceo96QCq1F6
         T4vA6ob7Z9OV8Ua4nvnlrwYKywGxERaV+7yphQ6XcAP7+DWzM2ce1PKhelvBYRK0pGf4
         muPr5zlo+9PXnpK/5Nx80zm2IbCcljWDL1AY4uscqVH6pgo/L7j9AqgVYWbXj1OXT5y7
         npP/URca50nHTK/C7/fZ8nWKe9f83Ms0M0BaXOey85aJ/XP+f+Z+yj6m7kG1Tq+PaCoM
         Oxzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0tR0TOAYEuGHdERPvVTexth/QYZWyi3r7lB02iejQNk=;
        b=enaSX6eVbUSKNYXJ7oMTgTFvEmwpqr14RWxTdf8hcOfz3+vbJvw5jHOo8N8kQml13p
         TNEmkP2CV40k+Ni3QWMruITIth6hUpOPUep1CgwZyQLoPfFTSXV6VfVHJqJquXrq3HFI
         m8PqxobNmrXQfcK96yFV+D36AlzA5fuC1lo5x7ApJ3XGXF9b/osHqD8CstUIjXxyi6hj
         LK3O7ll71kODR6lRW1bLmoEvTlIKQMmW/iB/4LeBpF1gWf2CpX+gDZtAvqM1VCPzD1+A
         WcliDuP3DbDoKaQZnINhtTS4Gh59JnsOCgevaxyxSLbCAL71BDGpZHxBoByEzqTZz/4f
         4zZA==
X-Gm-Message-State: AOAM533Fkakc/TIAUczLYPOs10YdP77CWYJdS0SMafHpSHaCZSATcPLG
        fSyrXUVRHNS/PQZoJQ1qGjQ=
X-Google-Smtp-Source: ABdhPJzq6Ke+5kkkAVoEyehvoIf2H/w1SB7G4ZOR9T7OOUTUv8qz6yR+jz1Bd3QM1pP8xzEBPq+KGA==
X-Received: by 2002:adf:e807:: with SMTP id o7mr5889907wrm.372.1613825527582;
        Sat, 20 Feb 2021 04:52:07 -0800 (PST)
Received: from ?IPv6:2003:ea:8f39:5b00:dd09:3fe2:bc2d:e480? (p200300ea8f395b00dd093fe2bc2de480.dip0.t-ipconnect.de. [2003:ea:8f39:5b00:dd09:3fe2:bc2d:e480])
        by smtp.googlemail.com with ESMTPSA id u198sm30192885wmu.1.2021.02.20.04.52.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Feb 2021 04:52:06 -0800 (PST)
Subject: Re: [PATCH 01/20] net: phy: realtek: Fix events detection failure in
 LPI mode
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        linux-kernel@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Jose Abreu <joabreu@synopsys.com>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
References: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
 <20210208140341.9271-2-Sergey.Semin@baikalelectronics.ru>
 <8300d9ca-b877-860f-a975-731d6d3a93a5@gmail.com>
 <20210209101528.3lf47ouaedfgq74n@mobilestation>
 <a652c69b-94d3-9dc6-c529-1ebc0ed407ac@gmail.com>
 <20210209105646.GP1463@shell.armlinux.org.uk>
 <20210210164720.migzigazyqsuxwc6@mobilestation>
 <20210211103941.GW1463@shell.armlinux.org.uk>
 <20210220090248.oiyonlfucvmgzw6d@mobilestation>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <4dcecf82-f222-4957-f5fc-e8f9d073599c@gmail.com>
Date:   Sat, 20 Feb 2021 13:51:56 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210220090248.oiyonlfucvmgzw6d@mobilestation>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.02.2021 10:02, Serge Semin wrote:
> On Thu, Feb 11, 2021 at 10:39:41AM +0000, Russell King - ARM Linux admin wrote:
>> On Wed, Feb 10, 2021 at 07:47:20PM +0300, Serge Semin wrote:
>>> On Tue, Feb 09, 2021 at 10:56:46AM +0000, Russell King - ARM Linux admin wrote:
>>>> On Tue, Feb 09, 2021 at 11:37:29AM +0100, Heiner Kallweit wrote:
>>>>> Right, adding something like a genphy_{read,write}_mmd() doesn't make
>>>>> too much sense for now. What I meant is just exporting mmd_phy_indirect().
>>>>> Then you don't have to open-code the first three steps of a mmd read/write.
>>>>> And it requires no additional code in phylib.
>>>>
>>>> ... but at the cost that the compiler can no longer inline that code,
>>>> as I mentioned in my previous reply. (However, the cost of the accesses
>>>> will be higher.) On the plus side, less I-cache footprint, and smaller
>>>> kernel code.
>>>
>>> Just to note mmd_phy_indirect() isn't defined with inline specifier,
>>> but just as static and it's used twice in the
>>> drivers/net/phy/phy-core.c unit. So most likely the compiler won't
>>> inline the function code in there.
>>
>> You can't always tell whether the compiler will inline a static function
>> or not.
> 
> Andrew, Heiner, Russell, what is your final decision about this? Shall
> we export the mmd_phy_indirect() method, implement new
> genphy_{read,write}_mmd() or just leave the patch as is manually
> accessing the MMD register in the driver?
> 

If in doubt, leaving the patch as is would be fine with me.

> -Sergey
> 
>>
>>> Anyway it's up to the PHY
>>> library maintainers to decide. Please settle the issue with Heiner and
>>> Andrew then. I am ok with both solutions and will do as you decide.
>>
>> FYI, *I* am one of the phylib maintainers.
>>
>> -- 
>> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
>> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

