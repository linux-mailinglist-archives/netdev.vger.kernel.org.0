Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAF2CD39C5
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 09:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbfJKHCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 03:02:03 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:35867 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbfJKHCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 03:02:02 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 46qJm82GhGz1rXPd;
        Fri, 11 Oct 2019 09:02:00 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 46qJm81LHxz1qqkT;
        Fri, 11 Oct 2019 09:02:00 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id I27qKmI7jnZp; Fri, 11 Oct 2019 09:01:58 +0200 (CEST)
X-Auth-Info: QT47btBBmK7H2f1iGZq+Rw/TmLzpjx30cRYWULv4hTs=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 11 Oct 2019 09:01:58 +0200 (CEST)
Subject: Re: [PATCH V2 1/2] net: phy: micrel: Discern KSZ8051 and KSZ8795 PHYs
To:     Simon Horman <horms@verge.net.au>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
References: <20191010194622.28742-1-marex@denx.de>
 <20191011055707.stsk5dwwg7acfmnv@verge.net.au>
From:   Marek Vasut <marex@denx.de>
Message-ID: <cb1edacc-d85c-0f79-687f-88e4ce349f00@denx.de>
Date:   Fri, 11 Oct 2019 08:52:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191011055707.stsk5dwwg7acfmnv@verge.net.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/19 7:57 AM, Simon Horman wrote:
[...]
>> +static int ksz8795_match_phy_device(struct phy_device *phydev)
>> +{
>> +	int ret;
>> +
>> +	if ((phydev->phy_id & MICREL_PHY_ID_MASK) != PHY_ID_KSZ8795)
>> +		return 0;
>> +
>> +	ret = phy_read(phydev, MII_BMSR);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	/* See comment in ksz8051_match_phy_device() for details. */
>> +	return !(ret & BMSR_ERCAP);
>> +}
>> +
> 
> Hi Marek,
> 
> given the similarity between ksz8051_match_phy_device() and
> ksz8795_match_phy_device() I wonder if a common helper is appropriate.

Then one (or both) of them look like this:

static int ksz8795_match_phy_device(struct phy_device *phydev)
{
        int ret;

        /* See comment in ksz8051_match_phy_device() for details. */
        ret = ksz8051_match_phy_device(phydev);
        if (ret < 0)
                return ret;

        return !ret;
}

It's not that much better.
