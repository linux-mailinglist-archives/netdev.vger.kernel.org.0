Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7E515218B
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 21:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbgBDUfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 15:35:18 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:47346 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727445AbgBDUfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 15:35:17 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 014KZ5VG105411;
        Tue, 4 Feb 2020 14:35:05 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1580848505;
        bh=IocsJb4lt8ba4aTh9yVCxKQrrItDY600pxBV4Igcxn0=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=huoOQfewWrW/q7cjEvE35DCyOuUXPTBgUqHbU3Sj1MZWfpT0+BXXCbSxeurZ0U1qg
         sZ/GsO5c2gWh2L1JSWu4Mkf+uRzhiID1M0IwdvI1Ir4KwYYhj7rfxcY1vMTo1JosIM
         RcNugpb/cbW9z5U8w5Aw7KHF/vfyypvfSzqSozfA=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 014KZ5vu126333
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 4 Feb 2020 14:35:05 -0600
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 4 Feb
 2020 14:35:05 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 4 Feb 2020 14:35:05 -0600
Received: from [128.247.59.107] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 014KZ4rE087244;
        Tue, 4 Feb 2020 14:35:04 -0600
Subject: Re: [PATCH net-next v2] net: phy: dp83867: Add speed optimization
 feature
To:     Heiner Kallweit <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>
CC:     <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200204181319.27381-1-dmurphy@ti.com>
 <f977a302-16fc-de68-e84b-d41a0eca4c12@gmail.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <29de8f3f-d9ba-88b3-ca48-61936c012172@ti.com>
Date:   Tue, 4 Feb 2020 14:30:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <f977a302-16fc-de68-e84b-d41a0eca4c12@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heiner

On 2/4/20 2:08 PM, Heiner Kallweit wrote:
> On 04.02.2020 19:13, Dan Murphy wrote:
>> Set the speed optimization bit on the DP83867 PHY.
>> This feature can also be strapped on the 64 pin PHY devices
>> but the 48 pin devices do not have the strap pin available to enable
>> this feature in the hardware.  PHY team suggests to have this bit set.
>>
>> With this bit set the PHY will auto negotiate and report the link
>> parameters in the PHYSTS register.  This register provides a single
>> location within the register set for quick access to commonly accessed
>> information.
>>
>> In this case when auto negotiation is on the PHY core reads the bits
>> that have been configured or if auto negotiation is off the PHY core
>> reads the BMCR register and sets the phydev parameters accordingly.
>>
>> This Giga bit PHY can throttle the speed to 100Mbps or 10Mbps to accomodate a
>> 4-wire cable.  If this should occur the PHYSTS register contains the
>> current negotiated speed and duplex mode.
>>
>> In overriding the genphy_read_status the dp83867_read_status will do a
>> genphy_read_status to setup the LP and pause bits.  And then the PHYSTS
>> register is read and the phydev speed and duplex mode settings are
>> updated.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> net-next is closed currently. See here for details:
> https://www.kernel.org/doc/Documentation/networking/netdev-FAQ.txt
> Reopening will be announced on the netdev mailing list, you can also
> check net-next status here: http://vger.kernel.org/~davem/net-next.html
>
Thanks Heiner for the link I RTM.  I will wait for the opening.

Dan

