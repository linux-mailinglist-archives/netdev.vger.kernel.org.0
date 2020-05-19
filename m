Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A661D934D
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 11:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgESJ1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 05:27:31 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.95]:25951 "EHLO
        smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgESJ1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 05:27:30 -0400
X-Greylist: delayed 1477 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 May 2020 05:27:29 EDT
Received: from [46.237.200.88] (helo=brian.int1.clnt.de)
        by smtprelay06.ispgateway.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92.3)
        (envelope-from <joe@clnt.de>)
        id 1jaxo5-0004jr-Re; Tue, 19 May 2020 10:41:01 +0200
Received: from localhost ([127.0.0.1])
        by brian.int1.clnt.de with esmtp (Exim 4.90_1)
        (envelope-from <joe@clnt.de>)
        id 1jaxo5-00022k-Au; Tue, 19 May 2020 10:41:01 +0200
Date:   Tue, 19 May 2020 10:41:01 +0200 (CEST)
From:   =?ISO-8859-15?Q?J=F6rg_Willmann?= <joe@clnt.de>
X-X-Sender: joerg@brian.int1.clnt.de
To:     "Badel, Laurent" <LaurentBadel@eaton.com>
cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "alexander.levin@microsoft.com" <alexander.levin@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Quette, Arnaud" <ArnaudQuette@Eaton.com>
Subject: RE: [EXTERNAL]  Re: [PATCH 2/2] Reset PHY in phy_init_hw() before
 interrupt configuration
In-Reply-To: <CH2PR17MB35427EF2FAE4E31FCA144F89DFAA0@CH2PR17MB3542.namprd17.prod.outlook.com>
Message-ID: <alpine.DEB.2.21.2005191036500.7651@brian.int1.clnt.de>
References: <CH2PR17MB3542BB17A1FA1764ACE3B20EDFAD0@CH2PR17MB3542.namprd17.prod.outlook.com> <338bd206-673d-6f3e-0402-822707af5075@gmail.com> <CH2PR17MB35427EF2FAE4E31FCA144F89DFAA0@CH2PR17MB3542.namprd17.prod.outlook.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1301859258-1589877661=:7651"
X-Df-Sender: am9lcmd3QGVzancuZGU=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1301859258-1589877661=:7651
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT



On Thu, 30 Apr 2020, Badel, Laurent wrote:

> -----Original Message-----
>> From: Heiner Kallweit <hkallweit1@gmail.com>
>> Sent: Wednesday, April 29, 2020 7:06 PM
>> To: Badel, Laurent <LaurentBadel@eaton.com>; fugang.duan@nxp.com;
>> netdev@vger.kernel.org; andrew@lunn.ch; f.fainelli@gmail.com;
>> linux@armlinux.org.uk; richard.leitner@skidata.com;
>> davem@davemloft.net; alexander.levin@microsoft.com;
>> gregkh@linuxfoundation.org
>> Cc: Quette, Arnaud <ArnaudQuette@Eaton.com>
>> Subject: [EXTERNAL] Re: [PATCH 2/2] Reset PHY in phy_init_hw() before
>> interrupt configuration
>>
>> On 29.04.2020 11:03, Badel, Laurent wrote:
>>> ﻿Description: this patch adds a reset of the PHY in phy_init_hw()
>>> for PHY drivers bearing the PHY_RST_AFTER_CLK_EN flag.
>>>
>>> Rationale: due to the PHY reset reverting the interrupt mask to default,
>>> it is necessary to either perform the reset before PHY configuration,
>>> or re-configure the PHY after reset. This patch implements the former
>>> as it is simpler and more generic.
>>>
>>> Fixes: 1b0a83ac04e383e3bed21332962b90710fcf2828 ("net: fec: add
>> phy_reset_after_clk_enable() support")
>>> Signed-off-by: Laurent Badel <laurentbadel@eaton.com>
>>>
>>> ---
>>>  drivers/net/phy/phy_device.c | 7 +++++--
>>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>>> index 28e3c5c0e..2cc511364 100644
>>> --- a/drivers/net/phy/phy_device.c
>>> +++ b/drivers/net/phy/phy_device.c
>>> @@ -1082,8 +1082,11 @@ int phy_init_hw(struct phy_device *phydev)
>>>  {
>>>  	int ret = 0;
>>>
>>> -	/* Deassert the reset signal */
>>> -	phy_device_reset(phydev, 0);
>>> +	/* Deassert the reset signal
>>> +	 * If the PHY needs a reset, do it now
>>> +	 */
>>> +	if (!phy_reset_after_clk_enable(phydev))
>>
>> If reset is asserted when entering phy_init_hw(), then
>> phy_reset_after_clk_enable() basically becomes a no-op.
>> Still it should work as expected due to the reset signal being
>> deasserted. It would be worth describing in the comment
>> why the code still works in this case.
>>
>
> Thank you for the comment, this is a very good point.
> I will make sure to include some description when resubmitting.
> I had previously tested this and what I saw was that the first
> time you bring up the interface, the reset is not asserted so
> that phy_reset_after_clk_enable() is effective.
> The subsequent times the interface is brought up, the reset
> is already asserted when entering phy_init_hw(), so that
> it becomes a no-op as you correctly pointed out. However,
> that didn't cause any problem on my board, presumably because
> in that case the clock is already running when the PHY comes
> out of reset.
> I will re-test this carefully against the 'net' tree, though,
> before coming to conclusions.
>
I have two additional things to take into account:
* phy_reset_after_clk_enable() shoulnd't be longer called that way since 
it is now misleading -> the phy is no longer reset after clock enable but 
during hw_init()
* how about fec_resume()? I don't think hw_init() is called then and so 
phy_reset_after_clk_enable() will no longer be called.

>>> +		phy_device_reset(phydev, 0);
>>>
>>>  	if (!phydev->drv)
>>>  		return 0;
>>>
>
>
--8323329-1301859258-1589877661=:7651--
