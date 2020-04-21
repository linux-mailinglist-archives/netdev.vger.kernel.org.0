Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7479F1B23AA
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 12:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbgDUKU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 06:20:57 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:51697 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbgDUKUz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 06:20:55 -0400
Received: from tarshish (unknown [10.0.8.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id B1A1F44046D;
        Tue, 21 Apr 2020 13:20:52 +0300 (IDT)
References: <616c799433477943d782bda9d8a825d56fc70c9d.1587459886.git.baruch@tkos.co.il> <20200421091720.GB25745@shell.armlinux.org.uk>
User-agent: mu4e 1.2.0; emacs 26.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net] net: phy: marvell10g: limit soft reset to 88x3310
In-reply-to: <20200421091720.GB25745@shell.armlinux.org.uk>
Date:   Tue, 21 Apr 2020 13:20:52 +0300
Message-ID: <87tv1db0mz.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Tue, Apr 21 2020, Russell King - ARM Linux admin wrote:
> On Tue, Apr 21, 2020 at 12:04:46PM +0300, Baruch Siach wrote:
>> The MV_V2_PORT_CTRL_SWRST bit in MV_V2_PORT_CTRL is reserved on 88E2110.
>> Setting SWRST on 88E2110 breaks packets transfer after interface down/up
>> cycle.
>>
>> Fixes: 8f48c2ac85ed ("net: marvell10g: soft-reset the PHY when coming out of low power")
>> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
>
> Okay, the presence of 88E2110 combined with 88X3310 support is going to
> be a constant source of pain in terms of maintanence, since I know
> nothing about this PHY, nor do I have any way to test my changes there.
>
> I think we need to think about how to deal with that - do we split the
> code, so that 88X3310 can be maintained separately from 88E2110 (even
> though most of the code may be the same), or can someone send me a board
> that has the 88E2110 on (I can't purchase as I have no funds to do so.)

I'll contact you in private about hardware availability.

> So, I guess splitting the code is likely to be the only solution.

This situation is no different than other drivers that support many
variants of the same basic hardware. FEC and mvneta driver come to mind
as examples. Hardware availability limitation is always a challenge.

I don't think this justifies splitting the code. But that's your call.

Thanks for reviewing,
baruch

>> ---
>>  drivers/net/phy/marvell10g.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
>> index d3cb88651ad2..601686f64341 100644
>> --- a/drivers/net/phy/marvell10g.c
>> +++ b/drivers/net/phy/marvell10g.c
>> @@ -263,7 +263,8 @@ static int mv3310_power_up(struct phy_device *phydev)
>>  	ret = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
>>  				 MV_V2_PORT_CTRL_PWRDOWN);
>>
>> -	if (priv->firmware_ver < 0x00030000)
>> +	if (phydev->drv->phy_id != MARVELL_PHY_ID_88X3310 ||
>> +	    priv->firmware_ver < 0x00030000)
>>  		return ret;
>>
>>  	return phy_set_bits_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,

--
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
