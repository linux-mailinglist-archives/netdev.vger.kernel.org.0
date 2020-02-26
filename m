Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBEC16FD0D
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 12:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgBZLMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 06:12:19 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:55679 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727362AbgBZLMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 06:12:18 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 8A61722EEB;
        Wed, 26 Feb 2020 12:12:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1582715536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dz8g00RXppiqUmDl/FLDhJ/QMklk0sBPolZqJe58GxE=;
        b=C9KP5DxXbwfxkTJP8Xz9aESRkGrP6o8anGPQCoD3pxJY87c8qoycQK5iQ3CNeTerKllkwr
        bAHJG4ouZJWDwBOi9msYaskCdn03b4seV4n33NGh1U5ntTG2qXcN8EAEnQwRbUlCHS6eZV
        exw4Yjr6pd3x3/d/mKbGgolhkct6u5U=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 26 Feb 2020 12:12:15 +0100
From:   Michael Walle <michael@walle.cc>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [RFC PATCH 1/2] net: phy: let the driver register its own IRQ
 handler
In-Reply-To: <3c7e1064-845e-d193-24ad-965211bf1e9a@gmail.com>
References: <20200225230819.7325-1-michael@walle.cc>
 <20200225230819.7325-2-michael@walle.cc>
 <3c7e1064-845e-d193-24ad-965211bf1e9a@gmail.com>
Message-ID: <18f531a691d0c4905552794bbb1be1e5@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: 8A61722EEB
X-Spamd-Result: default: False [1.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[8];
         NEURAL_HAM(-0.00)[-0.273];
         FREEMAIL_TO(0.00)[gmail.com];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         FREEMAIL_CC(0.00)[vger.kernel.org,lunn.ch,gmail.com,armlinux.org.uk,davemloft.net];
         MID_RHS_MATCH_FROM(0.00)[];
         SUSPICIOUS_RECIPS(1.50)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-02-26 08:27, schrieb Heiner Kallweit:
> On 26.02.2020 00:08, Michael Walle wrote:
>> There are more and more PHY drivers which has more than just the PHY
>> link change interrupts. For example, temperature thresholds or PTP
>> interrupts.
>> 
>> At the moment it is not possible to correctly handle interrupts for 
>> PHYs
>> which has a clear-on-read interrupt status register. It is also likely
>> that the current approach of the phylib isn't working for all PHYs out
>> there.
>> 
>> Therefore, this patch let the PHY driver register its own interrupt
>> handler. To notify the phylib about a link change, the interrupt 
>> handler
>> has to call the new function phy_drv_interrupt().
>> 
> 
> We have phy_driver callback handle_interrupt for custom interrupt
> handlers. Any specific reason why you can't use it for your purposes?

Yes, as mentioned above this wont work for PHYs which has a 
clear-on-read
status register, because you may loose interrupts between 
handle_interrupt()
and phy_clear_interrupt().

See also
  
https://lore.kernel.org/netdev/bd47f8e1ebc04fa98856ed8d89b91419@walle.cc/

And esp. Russell reply. I tried using handle_interrupt() but it won't 
work
unless you make the ack_interrupt a NOOP. but even then it won't work 
because
the ack_interrupt is also used during setup etc.

>> Signed-off-by: Michael Walle <michael@walle.cc>
>> ---
>>  drivers/net/phy/phy.c        | 15 +++++++++++++++
>>  drivers/net/phy/phy_device.c |  6 ++++--
>>  include/linux/phy.h          |  2 ++
>>  3 files changed, 21 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
>> index d76e038cf2cb..f25aacbcf1d9 100644
>> --- a/drivers/net/phy/phy.c
>> +++ b/drivers/net/phy/phy.c
>> @@ -942,6 +942,21 @@ void phy_mac_interrupt(struct phy_device *phydev)
>>  }
>>  EXPORT_SYMBOL(phy_mac_interrupt);
>> 
>> +/**
>> + * phy_drv_interrupt - PHY drivers says the link has changed
>> + * @phydev: phy_device struct with changed link
>> + *
>> + * The PHY driver may implement his own interrupt handler. It will 
>> call this
>> + * function to notify us about a link change. Trigger the state 
>> machine and
>> + * work a work queue.
>> + */
> 
> This function would duplicate phy_mac_interrupt().

Yes I wasn't sure, if I should just call that function of if it might
change in the future. Also the description doesn't fit. Renaming the 
function
sounded also bad, because its an exported symbol.

I'm open to suggestions ;)

> 
>> +void phy_drv_interrupt(struct phy_device *phydev)
>> +{
>> +	/* Trigger a state machine change */
>> +	phy_trigger_machine(phydev);
>> +}
>> +EXPORT_SYMBOL(phy_drv_interrupt);
>> +
>>  static void mmd_eee_adv_to_linkmode(unsigned long *advertising, u16 
>> eee_adv)
>>  {
>>  	linkmode_zero(advertising);
>> diff --git a/drivers/net/phy/phy_device.c 
>> b/drivers/net/phy/phy_device.c
>> index 6a5056e0ae77..6d8c94e61251 100644
>> --- a/drivers/net/phy/phy_device.c
>> +++ b/drivers/net/phy/phy_device.c
>> @@ -965,7 +965,8 @@ int phy_connect_direct(struct net_device *dev, 
>> struct phy_device *phydev,
>>  		return rc;
>> 
>>  	phy_prepare_link(phydev, handler);
>> -	if (phy_interrupt_is_valid(phydev))
>> +	if (phy_interrupt_is_valid(phydev) &&
>> +	    phydev->drv->flags & PHY_HAS_OWN_IRQ_HANDLER)
>>  		phy_request_interrupt(phydev);
> 
> Here most likely a ! is missing. because as-is you would break
> current phylib interrupt mode.

whoops you're right. nice catch.

> Where in the PHY driver (in which
> callback) do you want to register your own interrupt handler?

In the _probe() see patch 2/2.

-michael

>> 
>>  	return 0;
>> @@ -2411,7 +2412,8 @@ EXPORT_SYMBOL(phy_validate_pause);
>> 
>>  static bool phy_drv_supports_irq(struct phy_driver *phydrv)
>>  {
>> -	return phydrv->config_intr && phydrv->ack_interrupt;
>> +	return ((phydrv->config_intr && phydrv->ack_interrupt) ||
>> +		phydrv->flags & PHY_HAS_OWN_IRQ_HANDLER);
>>  }
>> 
>>  /**
>> diff --git a/include/linux/phy.h b/include/linux/phy.h
>> index c570e162e05e..46f73b94fd60 100644
>> --- a/include/linux/phy.h
>> +++ b/include/linux/phy.h
>> @@ -75,6 +75,7 @@ extern const int phy_10gbit_features_array[1];
>> 
>>  #define PHY_IS_INTERNAL		0x00000001
>>  #define PHY_RST_AFTER_CLK_EN	0x00000002
>> +#define PHY_HAS_OWN_IRQ_HANDLER	0x00000004
>>  #define MDIO_DEVICE_IS_PHY	0x80000000
>> 
>>  /* Interface Mode definitions */
>> @@ -1235,6 +1236,7 @@ int phy_drivers_register(struct phy_driver 
>> *new_driver, int n,
>>  void phy_state_machine(struct work_struct *work);
>>  void phy_queue_state_machine(struct phy_device *phydev, unsigned long 
>> jiffies);
>>  void phy_mac_interrupt(struct phy_device *phydev);
>> +void phy_drv_interrupt(struct phy_device *phydev);
>>  void phy_start_machine(struct phy_device *phydev);
>>  void phy_stop_machine(struct phy_device *phydev);
>>  void phy_ethtool_ksettings_get(struct phy_device *phydev,
>> 
