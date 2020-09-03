Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888C725CD16
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 00:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgICWDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 18:03:55 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:42478 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbgICWDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 18:03:54 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4BjFFN4bsPz1qrfk;
        Fri,  4 Sep 2020 00:03:52 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4BjFFN3pygz1qspX;
        Fri,  4 Sep 2020 00:03:52 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id Gc9bd-labMFB; Fri,  4 Sep 2020 00:03:42 +0200 (CEST)
X-Auth-Info: G22/DlSixUJS40Z8+N2uvmjwi/d8bCDgj6ZQ2EYL51c=
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri,  4 Sep 2020 00:03:42 +0200 (CEST)
Subject: Re: [PATCH] net: fec: Fix PHY init after phy_reset_after_clk_enable()
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        "David S . Miller" <davem@davemloft.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Richard Leitner <richard.leitner@skidata.com>,
        Shawn Guo <shawnguo@kernel.org>
References: <20200903202712.143878-1-marex@denx.de>
 <20200903210011.GD3112546@lunn.ch>
 <b6397b39-c897-6e0a-6bf7-b6b24908de1a@denx.de>
 <20200903215331.GG3112546@lunn.ch>
From:   Marek Vasut <marex@denx.de>
Message-ID: <02ce2afb-7b9f-ba35-63a5-7496c7a39e6e@denx.de>
Date:   Fri, 4 Sep 2020 00:03:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200903215331.GG3112546@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/3/20 11:53 PM, Andrew Lunn wrote:
> On Thu, Sep 03, 2020 at 11:36:39PM +0200, Marek Vasut wrote:
>> On 9/3/20 11:00 PM, Andrew Lunn wrote:
>>> On Thu, Sep 03, 2020 at 10:27:12PM +0200, Marek Vasut wrote:
>>>> The phy_reset_after_clk_enable() does a PHY reset, which means the PHY
>>>> loses its register settings. The fec_enet_mii_probe() starts the PHY
>>>> and does the necessary calls to configure the PHY via PHY framework,
>>>> and loads the correct register settings into the PHY. Therefore,
>>>> fec_enet_mii_probe() should be called only after the PHY has been
>>>> reset, not before as it is now.
>>>
>>> I think this patch is related to what Florian is currently doing with
>>> PHY clocks.
>>
>> Which is what ? Details please.
> 
> Have you used b4 before?
> 
> b4 am 20200903043947.3272453-1-f.fainelli@gmail.com

That might be a fix for the long run, but I doubt there's any chance to
backport it all to stable, is there ?

>>> I think a better fix for the original problem is for the SMSC PHY
>>> driver to control the clock itself. If it clk_prepare_enables() the
>>> clock, it knows it will not be shut off again by the FEC run time
>>> power management.
>>
>> The FEC MAC is responsible for generating the clock, the PHY clock are
>> not part of the clock framework as far as I can tell.
> 
> I'm not sure this is true. At least:
> 
> https://elixir.bootlin.com/linux/latest/source/arch/arm/boot/dts/imx6ul-kontron-n6x1x-s.dtsi#L123
> 
> and there are a few more examples:
> 
> imx6ul-14x14-evk.dtsi:			clocks = <&clks IMX6UL_CLK_ENET_REF>;
> imx6ul-kontron-n6x1x-s.dtsi:			clocks = <&clks IMX6UL_CLK_ENET_REF>;
> imx6ul-kontron-n6x1x-som-common.dtsi:			clocks = <&clks IMX6UL_CLK_ENET_REF>;
> imx6ull-myir-mys-6ulx.dtsi:			clocks = <&clks IMX6UL_CLK_ENET_REF>;
> imx6ul-phytec-phycore-som.dtsi:			clocks = <&clks IMX6UL_CLK_ENET_REF>;
> 
> Maybe it is just IMX6?

This is reference clock for the FEC inside the SoC, you probably want to
control the clock going out of the SoC and into the PHY, which is
different clock than the one described in the DT, right ?
