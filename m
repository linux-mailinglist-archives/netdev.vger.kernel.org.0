Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765122EB1DA
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 18:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730563AbhAERyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 12:54:43 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:39471 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730432AbhAERyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 12:54:43 -0500
X-Greylist: delayed 13287 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2021 12:54:42 EST
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4D9Kqg0HLpz1rtjY;
        Tue,  5 Jan 2021 18:53:50 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4D9Kqf2lX4z1sFWN;
        Tue,  5 Jan 2021 18:53:50 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id bdRTq9AALQHK; Tue,  5 Jan 2021 18:53:49 +0100 (CET)
X-Auth-Info: cRxU0o+2DUCCB76WaXiC4ayoOQZKrG7SE7uAPYK39/E=
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue,  5 Jan 2021 18:53:49 +0100 (CET)
Subject: Re: [PATCH] [RFC] net: phy: smsc: Add magnetics VIO regulator support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20210105161533.250865-1-marex@denx.de> <X/SkAOV6s9vbSYh1@lunn.ch>
From:   Marek Vasut <marex@denx.de>
Message-ID: <75b9c711-54af-8d21-f7aa-dc4662ed2234@denx.de>
Date:   Tue, 5 Jan 2021 18:53:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <X/SkAOV6s9vbSYh1@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/21 6:38 PM, Andrew Lunn wrote:
>> +static void smsc_link_change_notify(struct phy_device *phydev)
>> +{
>> +	struct smsc_phy_priv *priv = phydev->priv;
>> +
>> +	if (!priv->vddio)
>> +		return;
>> +
>> +	if (phydev->state == PHY_HALTED)
>> +		regulator_disable(priv->vddio);
>> +
>> +	if (phydev->state == PHY_NOLINK)
>> +		regulator_enable(priv->vddio);
> 
> NOLINK is an interesting choice. Could you explain that please.

It's the first state after interface is up.

> I fear this is not going to be very robust to state machine
> changes. And since it is hidden away in a driver, it is going to be
> forgotten about. You might want to think about making it more robust.

I marked the patch as RFC because I would like input on how to implement 
this properly. Note that since the regulator supplies the magnetics, 
which might be shared between multiple ports with different PHYs, I 
don't think this code should even be in the PHY driver, but somewhere 
else -- but I don't know where.
