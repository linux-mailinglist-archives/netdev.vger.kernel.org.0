Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206E64435BA
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 19:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235162AbhKBSk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 14:40:29 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:37948 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235253AbhKBSkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 14:40:21 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 1A2IbM7M087989;
        Tue, 2 Nov 2021 13:37:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1635878242;
        bh=kahu1RrAQ8a3NUn7pdiksp8ndZsSm/fSJHPMdl9Wqn4=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=U0eNHkxK5PVYpVxJhoYzaZ8E/+nV0czPYsP+4M8rDZiUrcwYa5Fv8ylDS9zM58uzC
         x8q/CW5tMwpFUlR8ljCO3jr3evn63vETUj2c7o9qjwQ9goIXXQtsvcOAjIeM3LQeoJ
         f0ED8UomDgld6YMaDf+JzuzGCtSFW4lBix+GWviI=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 1A2IbMMp050537
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 2 Nov 2021 13:37:22 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 2
 Nov 2021 13:37:22 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 2 Nov 2021 13:37:21 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 1A2IbJDf130527;
        Tue, 2 Nov 2021 13:37:20 -0500
Subject: Re: [RFC PATCH] net: phy/mdio: enable mmd indirect access through
 phy_mii_ioctl()
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
References: <20211101182859.24073-1-grygorii.strashko@ti.com>
 <YYBBHsFEwGdPJw3b@lunn.ch> <YYBF3IZoSN6/O6AL@shell.armlinux.org.uk>
 <YYCLJnY52MoYfxD8@lunn.ch> <YYExmHYW49jOjfOt@shell.armlinux.org.uk>
 <bc9df441-49bf-5c8a-891c-cc3f0db00aba@ti.com>
 <YYF4ZQHqc1jJsE/+@shell.armlinux.org.uk>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <e18f17bd-9e77-d3ef-cc1e-30adccb7cdd5@ti.com>
Date:   Tue, 2 Nov 2021 20:37:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YYF4ZQHqc1jJsE/+@shell.armlinux.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell, Andrew,

Thanks a lot for you comments.

On 02/11/2021 19:41, Russell King (Oracle) wrote:
> On Tue, Nov 02, 2021 at 07:19:46PM +0200, Grygorii Strashko wrote:
>> It would require MDIO bus lock, which is not a solution,
>> or some sort of batch processing, like for mmd:
>>   w reg1 val1
>>   w reg2 val2
>>   w reg1 val3
>>   r reg2
>>
>> What Kernel interface do you have in mind?
> 
> That is roughly what I was thinking, but Andrew has basically said no
> to it.
> 
>> Sry, but I have to note that demand for this become terribly high, min two pings in months
> 
> Feel free to continue demanding it, but it seems that at least two of
> the phylib maintainers are in agreement that providing generic
> emulation of C45 accesses in kernel space is just not going to happen.
> 

not ready to give up.

One more idea how about mdiobus_get_phy(), so we can search for PHY and
if present try to use proper API phy_read/phy_write_mmd?


-- 
Best regards,
grygorii
