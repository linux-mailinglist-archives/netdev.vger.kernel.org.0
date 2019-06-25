Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 173CE52671
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 10:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbfFYIYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 04:24:08 -0400
Received: from mx.0dd.nl ([5.2.79.48]:36406 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbfFYIYH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 04:24:07 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 1B11C5FE8C;
        Tue, 25 Jun 2019 10:24:06 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="RJLDHEVW";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id D17F31CC905E;
        Tue, 25 Jun 2019 10:24:05 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com D17F31CC905E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1561451045;
        bh=81baUAKeAgxKW4Xwojp9lsyrtNx0oeNqTdLY8KnvPZ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RJLDHEVW85CJKT+06SIAKyo0lnnjBcBY9gIzK7SYT1jcppOpNQxcLKnahAl4jHx8T
         odFOUcX3cTKBjsI7fSSgpejHZgU0p64HyWb+B5s/XrYxYOw7wJm8Rp6kMPqvnK+AHX
         UdzCcYeilIK2j1vzp/DYGJCkjgedD8tx0JVSsGFNTQIYTOKeEyuWx1nH4Gk49lkMGH
         fxFnn2z8IvHo8zoGo/QAAm7k1b8t3zZJoAHe5jqmMnkfCeOq5HXylzkdvs5mBzC23N
         RfPWfgH2wb9Y6VWycWM8jxIeK5BOgu/xuqJFxY19vuxy/1PgKbiEe9PrAOmoTHrnLV
         gVuWWnAi9BHCg==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Tue, 25 Jun 2019 08:24:05 +0000
Date:   Tue, 25 Jun 2019 08:24:05 +0000
Message-ID: <20190625082405.Horde.AOfGPj5A9INWyS39F-pCQ27@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     sean.wang@mediatek.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, matthias.bgg@gmail.com,
        vivien.didelot@gmail.com, frank-w@public-files.de,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH RFC net-next 5/5] net: dsa: mt7530: Add
 mediatek,ephy-handle to isolate external phy
References: <20190624145251.4849-1-opensource@vdorst.com>
 <20190624145251.4849-6-opensource@vdorst.com>
 <20190624215248.GC31306@lunn.ch>
In-Reply-To: <20190624215248.GC31306@lunn.ch>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Andrew Lunn <andrew@lunn.ch>:

Hi Andrew,

>> +static int mt7530_isolate_ephy(struct dsa_switch *ds,
>> +			       struct device_node *ephy_node)
>> +{
>> +	struct phy_device *phydev = of_phy_find_device(ephy_node);
>> +	int ret;
>> +
>> +	if (!phydev)
>> +		return 0;
>> +
>> +	ret = phy_modify(phydev, MII_BMCR, 0, (BMCR_ISOLATE | BMCR_PDOWN));
>
> genphy_suspend() does what you want.

In case my device has AT8033 PHY which act as a RGMII-to-SGMII  
converter for the
SFP cage.

Qoute of the AR8031/33 datasheet:

The AR8033 device supports the low power mode with software power-down.
To enter the standard IEEE power-down mode, set the bit[11] POWER_DOWN of
Control register - copper page or Control register — fiber page to 1.
In this mode, AR8033 ignores all MAC interface signals except the MDC/MDIO and
does not respond to any activity on the media side. AR8033 cannot wake  
up on its
own and is only waken up by setting the POWER_DOWN bit to 0.


Does "standard IEEE power-down mode" describ this behavior that in power-down
mode the RGMII are also put in tri-state?

Reading the datasheet does not give me any clues.
Putting RGMII signals in tri-state is important in this case.

>
>> +	if (ret)
>> +		dev_err(ds->dev, "Failed to put phy %s in isolation mode!\n",
>> +			ephy_node->full_name);
>> +	else
>> +		dev_info(ds->dev, "Phy %s in isolation mode!\n",
>> +			 ephy_node->full_name);
>
> No need to clog up the system with yet more kernel messages.

OK, I remove it.

>
>    Andrew

Greats,

René



