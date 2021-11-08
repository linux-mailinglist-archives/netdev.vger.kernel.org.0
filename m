Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9D44481AA
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 15:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237626AbhKHO20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 09:28:26 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:57604 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234601AbhKHO2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 09:28:25 -0500
Subject: Re: [PATCH] phy: phy_ethtool_ksettings_set: Don't discard
 phy_start_aneg's return
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636381540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UhQkxGQODLZIA/Wz5X/+8PfIi4GUMdwLbiCmCwa9LYc=;
        b=o2u7KmRqHeNqECKExCnCSlQkiO/fNNPXS7D943cy8hi1i6Efi/ew8Np/L/ZahSvJQEkuof
        qsnYXE9twvnqEbmvGPbFV+3plwu473kX2rSePnPmwHYHguoIjr9S2s2mkwtnU8mbO3Mlvd
        AeWkTTzOZeTsPsphn7aZiV6VcJPprnckglrY8+xoCEwFHeAml5uWYcB1SrQKVixDUUf7XP
        LNMopslgzkqOZLmxaQxx8FIrc77DaRiWVuP0FszuzlnFoxjHJGm/7T2oJaEBIUQJBBgzyv
        N+UP4v8WTWIhwUOrVcIETpMObrw/sE3iBZwxl2O9fSLXBbEsXUBZ6y8aps+DLg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636381540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UhQkxGQODLZIA/Wz5X/+8PfIi4GUMdwLbiCmCwa9LYc=;
        b=Ve6np4KhwHrJTAhOqGWcbWrRA3kDVJs86Axw3832qm1iaTsMHD4zlNVVdiqNVkUlHGblmW
        QSojZMS4s+O7KuAA==
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <linux@armlinux.org.uk>, davem@davemloft.net,
        netdev@vger.kernel.org,
        Benedikt Spranger <b.spranger@linutronix.de>
References: <20211105153648.8337-1-bage@linutronix.de>
 <6e1844e5-cbee-5d50-e304-efa785405922@gmail.com>
From:   Bastian Germann <bage@linutronix.de>
Message-ID: <108f9fe7-54ec-d601-d091-bac6178624cf@linutronix.de>
Date:   Mon, 8 Nov 2021 15:25:40 +0100
MIME-Version: 1.0
In-Reply-To: <6e1844e5-cbee-5d50-e304-efa785405922@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE-frami
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 06.11.21 um 22:52 schrieb Heiner Kallweit:
> On 05.11.2021 16:36, bage@linutronix.de wrote:
>> From: Bastian Germann <bage@linutronix.de>
>>
>> Take the return of phy_start_aneg into account so that ethtool will handle
>> negotiation errors and not silently accept invalid input.
>>
>> Fixes: 2d55173e71b0 ("phy: add generic function to support ksetting support")
>> Signed-off-by: Bastian Germann <bage@linutronix.de>
>> Reviewed-by: Benedikt Spranger <b.spranger@linutronix.de>
> 
> In addition to what Andrew said already:
> 
> - This patch won't apply on net due to a4db9055fdb9.

Hi Heiner,

Thanks for your remarks. I would have gotten the first one right if the netdev
tree was documented in the MAINTAINERS file (T: ...) and not only in netdev-FAQ.

Maybe you want to address that.

Thanks,
Bastian

> - Patch misses the "net" annotation.
> - Prefix should be "net: phy:", not "phy:".
> 
> At least the formal aspects should have been covered by the internal review.
> 
>> ---
>>   drivers/net/phy/phy.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
>> index a3bfb156c83d..f740b533abba 100644
>> --- a/drivers/net/phy/phy.c
>> +++ b/drivers/net/phy/phy.c
>> @@ -770,6 +770,8 @@ static int phy_poll_aneg_done(struct phy_device *phydev)
>>   int phy_ethtool_ksettings_set(struct phy_device *phydev,
>>   			      const struct ethtool_link_ksettings *cmd)
>>   {
>> +	int ret = 0;
> 
> Why initializing ret?
> 
>> +
>>   	__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
>>   	u8 autoneg = cmd->base.autoneg;
>>   	u8 duplex = cmd->base.duplex;
>> @@ -815,10 +817,10 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
>>   	phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
>>   
>>   	/* Restart the PHY */
>> -	_phy_start_aneg(phydev);
>> +	ret = _phy_start_aneg(phydev);
>>   
>>   	mutex_unlock(&phydev->lock);
>> -	return 0;
>> +	return ret;
>>   }
>>   EXPORT_SYMBOL(phy_ethtool_ksettings_set);
>>   
>>
> 
