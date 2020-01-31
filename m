Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4C7714F237
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgAaScv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:32:51 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:48794 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbgAaScv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 13:32:51 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 00VIWj0P063141;
        Fri, 31 Jan 2020 12:32:45 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1580495565;
        bh=q2HZkUr28QG6cWoG52S+ZRVcQYY3XCcEI2XJl8Y38Io=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=xUXjddQ8VRVzGoFCZSj7lLubniGGZVbFrsysmwmFQpqkfztFCgZHMiQQCjpu4/sM1
         1Rf1Z75Tc4MpG1HQqbpzH75g2SPoT4w9VKOlhJ+IRBlvPyPYQDkn64zAKHIpdmYfZE
         gdHD4cwv2lQ+2cgsJoLP+YjmjRO4D0zC3jVucRo4=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 00VIWjpo121344
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 31 Jan 2020 12:32:45 -0600
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 31
 Jan 2020 12:32:45 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 31 Jan 2020 12:32:45 -0600
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00VIWjEx001278;
        Fri, 31 Jan 2020 12:32:45 -0600
Subject: Re: [PATCH net-master 1/1] net: phy: dp83867: Add speed optimization
 feature
To:     Florian Fainelli <f.fainelli@gmail.com>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>, <bunk@kernel.org>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <grygorii.strashko@ti.com>
References: <20200131151110.31642-1-dmurphy@ti.com>
 <20200131151110.31642-2-dmurphy@ti.com>
 <8f0e7d61-9433-4b23-5563-4dde03cd4b4a@gmail.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <d03b5867-a55b-9abc-014f-69ce156b09f3@ti.com>
Date:   Fri, 31 Jan 2020 12:29:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <8f0e7d61-9433-4b23-5563-4dde03cd4b4a@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian

On 1/31/20 11:49 AM, Florian Fainelli wrote:
> On 1/31/20 7:11 AM, Dan Murphy wrote:
>> Set the speed optimization bit on the DP83867 PHY.
>> This feature can also be strapped on the 64 pin PHY devices
>> but the 48 pin devices do not have the strap pin available to enable
>> this feature in the hardware.  PHY team suggests to have this bit set.
> OK, but why and how does that optimization work exactly?

I described this in the cover letter.  And it is explained in the data 
sheet Section 8.4.6.6

>   Departing from
> the BMSR reads means you possibly are going to introduce bugs and/or
> incomplete information. For instance, you set phydev->pause and
> phydev->asym_pause to 0 now, is there no way to extract what the link
> partner has advertised?

I was using the marvel.c as my template as it appears to have a separate 
status register as well.

Instead of setting those bits in the call back I can call the 
genphy_read_status then override the duplex and speed based on the 
physts register like below.  This way link status and pause values can 
be updated and then we can update the speed and duplex settings.

       ret = genphy_read_status(phydev);
     if (ret)
         return ret;

     if (status < 0)
         return status;

     if (status & DP83867_PHYSTS_DUPLEX)
         phydev->duplex = DUPLEX_FULL;
     else
         phydev->duplex = DUPLEX_HALF;

     if (status & DP83867_PHYSTS_1000)
         phydev->speed = SPEED_1000;
     else if (status & DP83867_PHYSTS_100)
         phydev->speed = SPEED_100;
     else
         phydev->speed = SPEED_10;


>> With this bit set the PHY will auto negotiate and report the link
>> parameters in the PHYSTS register and not in the BMCR.
> That should be BMSR, the BMCR is about control, not status.

OK.

Dan

