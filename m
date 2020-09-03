Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77BB25CE0A
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 00:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729565AbgICWpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 18:45:51 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:42575 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729458AbgICWpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 18:45:49 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4BjG9l2DTrz1qrM7;
        Fri,  4 Sep 2020 00:45:47 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4BjG9l1VRRz1qspZ;
        Fri,  4 Sep 2020 00:45:47 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id igdqtmomGqIL; Fri,  4 Sep 2020 00:45:45 +0200 (CEST)
X-Auth-Info: t/+wZhYq2dbYGIGiOrzAMqiCdrPIDq1i3LyhWQ4izjU=
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri,  4 Sep 2020 00:45:45 +0200 (CEST)
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
 <02ce2afb-7b9f-ba35-63a5-7496c7a39e6e@denx.de>
 <20200903220847.GI3112546@lunn.ch>
From:   Marek Vasut <marex@denx.de>
Message-ID: <c67eb631-a16d-0b52-c2f8-92d017e39258@denx.de>
Date:   Fri, 4 Sep 2020 00:45:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200903220847.GI3112546@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/4/20 12:08 AM, Andrew Lunn wrote:
>>> b4 am 20200903043947.3272453-1-f.fainelli@gmail.com
>>
>> That might be a fix for the long run, but I doubt there's any chance to
>> backport it all to stable, is there ?
> 
> No. For stable we need something simpler.

Like this patch ?

>>>>> I think a better fix for the original problem is for the SMSC PHY
>>>>> driver to control the clock itself. If it clk_prepare_enables() the
>>>>> clock, it knows it will not be shut off again by the FEC run time
>>>>> power management.
>>>>
>>>> The FEC MAC is responsible for generating the clock, the PHY clock are
>>>> not part of the clock framework as far as I can tell.
>>>
>>> I'm not sure this is true. At least:
>>>
>>> https://elixir.bootlin.com/linux/latest/source/arch/arm/boot/dts/imx6ul-kontron-n6x1x-s.dtsi#L123
>>>
>>> and there are a few more examples:
>>>
>>> imx6ul-14x14-evk.dtsi:			clocks = <&clks IMX6UL_CLK_ENET_REF>;
>>> imx6ul-kontron-n6x1x-s.dtsi:			clocks = <&clks IMX6UL_CLK_ENET_REF>;
>>> imx6ul-kontron-n6x1x-som-common.dtsi:			clocks = <&clks IMX6UL_CLK_ENET_REF>;
>>> imx6ull-myir-mys-6ulx.dtsi:			clocks = <&clks IMX6UL_CLK_ENET_REF>;
>>> imx6ul-phytec-phycore-som.dtsi:			clocks = <&clks IMX6UL_CLK_ENET_REF>;
>>>
>>> Maybe it is just IMX6?
>>
>> This is reference clock for the FEC inside the SoC, you probably want to
>> control the clock going out of the SoC and into the PHY, which is
>> different clock than the one described in the DT, right ?
> 
> I _think_ this is the external clock which is feed to the PHY. Why
> else put it in the phy node in DT? And it has the name "rmii-ref"
> which again suggests it is the RMII clock, not something internal to
> the FEC.
> 
> To be sure, we would need to check the datasheet.

On iMX6Q where I have this issue (which btw is a very different SoC than
iMX6UL), this is not part of the PHY node. See
arch/arm/boot/dts/imx6qdl.dtsi . The SoC generates the clock and feeds
it into both the FEC and the PHY there.

Either way, this seems way out of scope for a bugfix which just corrects
the order of PHY reset/init, doesn't it?
