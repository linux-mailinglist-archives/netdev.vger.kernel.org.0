Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD6B154F04
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 23:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbgBFWlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 17:41:01 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:53526 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbgBFWlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 17:41:01 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 016MeqRk122715;
        Thu, 6 Feb 2020 16:40:53 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1581028853;
        bh=Mu7qRJS2jLmIsrKLZLL/BI6cfeKEUL45gFIFdonUaCg=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=BCGxdyIF+r7MKJxrR+4vnFOqOsoC5fJrZD17W/KAGF4NZYNf+0bsB+8enI3kCLc+U
         FJ+YfDeEzuab1wwUkeBUgM8TBrqY8wgvo1emM4Q9ZJOkxRLTV7ZRz8C5nose9nSCkY
         czX1aGOD9nh3rUryRJUDGE3cUApp2L2GxWyPUF7M=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 016Meqsr078565
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 6 Feb 2020 16:40:52 -0600
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 6 Feb
 2020 16:40:52 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 6 Feb 2020 16:40:52 -0600
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 016Meq3d009707;
        Thu, 6 Feb 2020 16:40:52 -0600
Subject: Re: [PATCH net-next v2] net: phy: dp83867: Add speed optimization
 feature
To:     Heiner Kallweit <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>
CC:     <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200204181319.27381-1-dmurphy@ti.com>
 <0ebcd40d-b9cc-1a76-bb18-91d8350aa1cd@gmail.com>
 <47b9b462-6649-39a7-809f-613ce832bd5c@ti.com>
 <59ce70e0-4404-cade-208d-d089ed238f30@gmail.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <8fa98423-9c3c-62c9-1e5a-29b2eef555e3@ti.com>
Date:   Thu, 6 Feb 2020 16:36:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <59ce70e0-4404-cade-208d-d089ed238f30@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heiner

On 2/6/20 4:28 PM, Heiner Kallweit wrote:
> On 06.02.2020 23:13, Dan Murphy wrote:
>> Heiner
>>
>> On 2/5/20 3:16 PM, Heiner Kallweit wrote:
>>> On 04.02.2020 19:13, Dan Murphy wrote:
>>>> Set the speed optimization bit on the DP83867 PHY.
>>>> This feature can also be strapped on the 64 pin PHY devices
>>>> but the 48 pin devices do not have the strap pin available to enable
>>>> this feature in the hardware.  PHY team suggests to have this bit set.
>>>>
>>>> With this bit set the PHY will auto negotiate and report the link
>>>> parameters in the PHYSTS register.  This register provides a single
>>>> location within the register set for quick access to commonly accessed
>>>> information.
>>>>
>>>> In this case when auto negotiation is on the PHY core reads the bits
>>>> that have been configured or if auto negotiation is off the PHY core
>>>> reads the BMCR register and sets the phydev parameters accordingly.
>>>>
>>>> This Giga bit PHY can throttle the speed to 100Mbps or 10Mbps to accomodate a
>>>> 4-wire cable.  If this should occur the PHYSTS register contains the
>>>> current negotiated speed and duplex mode.
>>>>
>>>> In overriding the genphy_read_status the dp83867_read_status will do a
>>>> genphy_read_status to setup the LP and pause bits.  And then the PHYSTS
>>>> register is read and the phydev speed and duplex mode settings are
>>>> updated.
>>>>
>>>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>>>> ---
>>>> v2 - Updated read status to call genphy_read_status first, added link_change
>>>> callback to notify of speed change and use phy_set_bits - https://lore.kernel.org/patchwork/patch/1188348/
>>>>
>>> As stated in the first review, it would be appreciated if you implement
>>> also the downshift tunable. This could be a separate patch in this series.
>>> Most of the implementation would be boilerplate code.
>>
>> I looked at this today and there are no registers that allow tuning the downshift attempts.  There is only a RO register that tells you how many attempts it took to achieve a link.  So at the very least we could put in the get_tunable but there will be no set.
>>
> The get operation for the downshift tunable should return after how many failed
> attempts the PHY starts a downshift. This doesn't match with your description of
> this register, so yes: Implementing the tunable for this PHY doesn't make sense.
True.  This register is only going to return 1,2,4 and 8.  And it is 
defaulted to 4 attempts.
>
> However this register may be useful in the link_change_notify() callback to
> figure out whether a downshift happened, to trigger the info message you had in
> your first version.

Thats a good idea but.. The register is defaulted to always report 4 
attempts were made. It never reports 0 attempts so we would never know 
the truth behind the reporting.  Kinda like matching the speeds.

Dan

