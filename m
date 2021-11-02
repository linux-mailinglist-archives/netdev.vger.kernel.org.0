Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B75944385F
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 23:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbhKBWZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 18:25:18 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:53400 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbhKBWZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 18:25:17 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 1A2MMVmL033203;
        Tue, 2 Nov 2021 17:22:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1635891751;
        bh=EWoKALA1neeSaE7F/1sCg2PXFHd8kYNZEQDePCQn0nc=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=U3g9J8MhI7gITPLK4QoAdrh+1Mkh3pmORSJ/qiiX2JdwifzoinFz2NPNZDrSWhVid
         e+PvidFBaT4guizOITXEzLgqK5spA3sX+5uDgQcMjSPa0apRwAqnC8rO4gVhd3n6u3
         hiA7i2Th6p+1yVDAk71vtIbL1habitGVQJkCL6OY=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 1A2MMVKF124026
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 2 Nov 2021 17:22:31 -0500
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 2
 Nov 2021 17:22:30 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 2 Nov 2021 17:22:31 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 1A2MMSTY005600;
        Tue, 2 Nov 2021 17:22:29 -0500
Subject: Re: [RFC PATCH] net: phy/mdio: enable mmd indirect access through
 phy_mii_ioctl()
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
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
 <e18f17bd-9e77-d3ef-cc1e-30adccb7cdd5@ti.com>
 <828e2d69-be15-fe69-48d8-9cfc29c4e76e@ti.com> <YYGxvomL/0tiPzvV@lunn.ch>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <8d24c421-064c-9fee-577a-cbbf089cdf33@ti.com>
Date:   Wed, 3 Nov 2021 00:22:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YYGxvomL/0tiPzvV@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 02/11/2021 23:46, Andrew Lunn wrote:
>> @@ -300,8 +301,18 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
>>                          prtad = mii_data->phy_id;
>>                          devad = mii_data->reg_num;
>>                  }
>> -               mii_data->val_out = mdiobus_read(phydev->mdio.bus, prtad,
>> -                                                devad);
>> +
>> +               if (prtad != phydev->mdio.addr)
>> +                       phydev_rq = mdiobus_get_phy(phydev->mdio.bus, prtad);
>> +
>> +               if (!phydev_rq) {
>> +                       mii_data->val_out = mdiobus_read(phydev->mdio.bus, prtad, devad);
>> +               } else if (mdio_phy_id_is_c45(mii_data->phy_id) && !phydev->is_c45) {
>> +                       mii_data->val_out = phy_read_mmd(phydev_rq, mdio_phy_id_devad(mii_data->phy_id), mii_data->reg_num);
>> +               } else {
>> +                       mii_data->val_out = phy_read(phydev_rq, mii_data->reg_num);
>> +               }
>> +
> 
> One thing i don't like about this is you have little idea what it has
> actually done.
> 
> If you pass a C45 address, i expect a C45 access. If i pass a C22 i
> expect a C22 access.

I might be doing smth wrong and that's why it's RFC.
I wanted to understand if i hook into the kernel side first correctly, so
if above doesn't violate PHYs/mdiodev access any more there seems reason
try to continue.

> 
> What i find interesting is that you and the other resent requester are
> using the same user space tool. If you implement C45 over C22 in that
> tool, you get your solution, and it will work for older kernels as
> well. Also, given the diverse implementations of this IOTCL, it
> probably works for more drivers than just those using phy_mii_ioctl().

Do you mean change uapi, like
  add mdio_phy_id_is_c45_over_c22() and
  flag #define MDIO_PHY_ID_C45_OVER_C22 0x4000?

Thank you for your comments and patience.	

-- 
Best regards,
grygorii
