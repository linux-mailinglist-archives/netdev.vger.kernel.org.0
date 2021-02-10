Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC923160ED
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 09:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhBJI0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 03:26:15 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:57355 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbhBJIZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 03:25:57 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 74CE323E64;
        Wed, 10 Feb 2021 09:25:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612945506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+cNxpkdDuOwRJvNB3aKuwMpR+znNnj63c1Pb8vQebZc=;
        b=n7yhPtn1qWcaeOroSll+XLku+Qitl2q++/TN5pqVf3AV9HrJRKbI5NFUgN1vzj/mxIQzBL
        th29M4JrQJWmUXsZ/Xdm3wDy724HOM+uAJ0Ki+tWlX105/FLesV85ISF1wqpJjy3SXxPHK
        +GTijeVrB2UBTa/DkvNbne+VonVKnMc=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 10 Feb 2021 09:25:04 +0100
From:   Michael Walle <michael@walle.cc>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 7/9] net: phy: icplus: select page before writing
 control register
In-Reply-To: <d5672062-c619-02a4-3bbe-dad44371331d@gmail.com>
References: <20210209164051.18156-1-michael@walle.cc>
 <20210209164051.18156-8-michael@walle.cc>
 <d5672062-c619-02a4-3bbe-dad44371331d@gmail.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <e9d26cd6634a8c066809aa92e1481112@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Am 2021-02-10 08:03, schrieb Heiner Kallweit:
> On 09.02.2021 17:40, Michael Walle wrote:
>> Registers >= 16 are paged. Be sure to set the page. It seems this was
>> working for now, because the default is correct for the registers used
>> in the driver at the moment. But this will also assume, nobody will
>> change the page select register before linux is started. The page 
>> select
>> register is _not_ reset with a soft reset of the PHY.
>> 
>> Add read_page()/write_page() support for the IP101G and use it
>> accordingly.
>> 
>> Signed-off-by: Michael Walle <michael@walle.cc>
>> ---
>>  drivers/net/phy/icplus.c | 50 
>> +++++++++++++++++++++++++++++++---------
>>  1 file changed, 39 insertions(+), 11 deletions(-)
>> 
>> diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
>> index a6e1c7611f15..858b9326a72d 100644
>> --- a/drivers/net/phy/icplus.c
>> +++ b/drivers/net/phy/icplus.c
>> @@ -49,6 +49,8 @@ MODULE_LICENSE("GPL");
>>  #define IP101G_DIGITAL_IO_SPEC_CTRL			0x1d
>>  #define IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32		BIT(2)
>> 
>> +#define IP101G_DEFAULT_PAGE			16
>> +
>>  #define IP175C_PHY_ID 0x02430d80
>>  #define IP1001_PHY_ID 0x02430d90
>>  #define IP101A_PHY_ID 0x02430c54
>> @@ -250,23 +252,25 @@ static int ip101a_g_probe(struct phy_device 
>> *phydev)
>>  static int ip101a_g_config_init(struct phy_device *phydev)
>>  {
>>  	struct ip101a_g_phy_priv *priv = phydev->priv;
>> -	int err;
>> +	int oldpage, err;
>> +
>> +	oldpage = phy_select_page(phydev, IP101G_DEFAULT_PAGE);
>> 
>>  	/* configure the RXER/INTR_32 pin of the 32-pin IP101GR if needed: 
>> */
>>  	switch (priv->sel_intr32) {
>>  	case IP101GR_SEL_INTR32_RXER:
>> -		err = phy_modify(phydev, IP101G_DIGITAL_IO_SPEC_CTRL,
>> -				 IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32, 0);
>> +		err = __phy_modify(phydev, IP101G_DIGITAL_IO_SPEC_CTRL,
>> +				   IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32, 0);
>>  		if (err < 0)
>> -			return err;
>> +			goto out;
>>  		break;
>> 
>>  	case IP101GR_SEL_INTR32_INTR:
>> -		err = phy_modify(phydev, IP101G_DIGITAL_IO_SPEC_CTRL,
>> -				 IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32,
>> -				 IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32);
>> +		err = __phy_modify(phydev, IP101G_DIGITAL_IO_SPEC_CTRL,
>> +				   IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32,
>> +				   IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32);
>>  		if (err < 0)
>> -			return err;
>> +			goto out;
>>  		break;
>> 
>>  	default:
>> @@ -284,12 +288,14 @@ static int ip101a_g_config_init(struct 
>> phy_device *phydev)
>>  	 * reserved as 'write-one'.
>>  	 */
>>  	if (priv->model == IP101A) {
>> -		err = phy_set_bits(phydev, IP10XX_SPEC_CTRL_STATUS, 
>> IP101A_G_APS_ON);
>> +		err = __phy_set_bits(phydev, IP10XX_SPEC_CTRL_STATUS,
>> +				     IP101A_G_APS_ON);
>>  		if (err)
>> -			return err;
>> +			goto out;
>>  	}
>> 
>> -	return 0;
>> +out:
>> +	return phy_restore_page(phydev, oldpage, err);
> 
> If a random page was set before entering config_init, do we actually 
> want
> to restore it? Or wouldn't it be better to set the default page as part
> of initialization?

First, I want to convert this to the match_phy_device() and while at it,
I noticed that there is this one "problem". Short summary: the IP101A 
isn't
paged, the IP101G has serveral and if page 16 is selected it is more or
less compatible with the IP101A. My problem here is now how to share the
functions for both PHYs without duplicating all the code. Eg. the IP101A
will phy_read/phy_write/phy_modify(), that is, all the locked versions.
For the IP101G I'd either need the _paged() versions or the __phy ones
which don't take the mdio_bus lock.

Here is what I came up with:
(1) provide a common function which uses the __phy ones, then the
     callback for the A version will take the mdio_bus lock and calls
     the common one. The G version will use phy_{select,restore}_page().
(2) the phy_driver ops for A will also provde a .read/write_page()
     callback which is just a no-op. So A can just use the G versions.
(3) What Heiner mentioned here, just set the default page in
     config_init().

(1) will still bloat the code; (3) has the disadvantage, that the
userspace might fiddle around with the page register and then the
whole PHY driver goes awry. I don't know if we have to respect that
use case in general. I know there is an API to read/write the PHY
registers and it could happen.

That being said, I'm either fine with (2) and (3) but I'm preferring
(2).

BTW, this patch is still missing read/writes to the interrupt status
and control registers which is also paged.

-michael
