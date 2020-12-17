Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAFB02DCD99
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 09:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727155AbgLQI0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 03:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgLQI0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 03:26:39 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F48AC0617A7
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 00:25:58 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1kpobh-0003su-Ub; Thu, 17 Dec 2020 09:25:53 +0100
Subject: Re: [PATCH 1/2] net: stmmac: retain PTP-clock at hwtstamp_set
To:     Jakub Kicinski <kuba@kernel.org>,
        Holger Assmann <h.assmann@pengutronix.de>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rayagond Kokatanur <rayagond@vayavyalabs.com>,
        kernel@pengutronix.de, Michael Olbrich <m.olbrich@pengutronix.de>,
        Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>
References: <20201216113239.2980816-1-h.assmann@pengutronix.de>
 <20201216171334.1e36fbff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
Message-ID: <ae5371c0-ea53-6885-a25b-b44e9fe0b615@pengutronix.de>
Date:   Thu, 17 Dec 2020 09:25:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201216171334.1e36fbff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 17.12.20 02:13, Jakub Kicinski wrote:
>> +			netdev_warn(priv->dev, "HW Timestamping init failed: %pe\n",
>> +					ERR_PTR(ret));
> 
> why convert to ERR_PTR and use %pe and not just %d?

To get a symbolic error name if support is compiled in (note the `e' after %p).

> 
> also continuation misaligned
> 
>> +		} else {
>> +			ret = stmmac_init_ptp(priv);
>> +			if (ret == -EOPNOTSUPP)
>> +				netdev_warn(priv->dev, "PTP not supported by HW\n");
>> +			else if (ret)
>> +				netdev_warn(priv->dev, "PTP init failed\n");
>> +		}
>>  	}
>>  
>>  	priv->eee_tw_timer = STMMAC_DEFAULT_TWT_LS;
>> @@ -5290,8 +5330,7 @@ int stmmac_resume(struct device *dev)
>>  		/* enable the clk previously disabled */
>>  		clk_prepare_enable(priv->plat->stmmac_clk);
>>  		clk_prepare_enable(priv->plat->pclk);
>> -		if (priv->plat->clk_ptp_ref)
>> -			clk_prepare_enable(priv->plat->clk_ptp_ref);
>> +		stmmac_init_hwtstamp(priv);
> 
> This was optional, now you always init?

Indeed, omitting the if condition here will lead to a needless warning on every reset.

Cheers,
Ahmad

> 
>>  		/* reset the phy so that it's ready */
>>  		if (priv->mii)
>>  			stmmac_mdio_reset(priv->mii);
>>
>> base-commit: 3db1a3fa98808aa90f95ec3e0fa2fc7abf28f5c9
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
