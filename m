Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9E928A3C6
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731402AbgJJW4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731350AbgJJTxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:53:46 -0400
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B790FC0613D8
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 02:09:57 -0700 (PDT)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4C7fJ13Jg0z1rlx2;
        Sat, 10 Oct 2020 11:08:47 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4C7fHz5v2Vz1qvgb;
        Sat, 10 Oct 2020 11:08:47 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id PoY3bUC0oe0z; Sat, 10 Oct 2020 11:08:46 +0200 (CEST)
X-Auth-Info: HZbH1y+lJTbskC0HSi87Gotaz3m1xMNFGozerO0or5c=
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sat, 10 Oct 2020 11:08:46 +0200 (CEST)
Subject: Re: [PATCH] net: fec: Fix phy_device lookup for
 phy_reset_after_clk_enable()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        "David S . Miller" <davem@davemloft.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Richard Leitner <richard.leitner@skidata.com>,
        Shawn Guo <shawnguo@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20201006202029.254212-1-marex@denx.de>
 <110b63bb-9096-7ce0-530f-45dffed09077@gmail.com>
 <9f882603-2419-5931-fe8f-03c2a28ac785@denx.de>
 <20201008174619.282b3482@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <da024643-e7bc-3470-64ad-96277655f494@denx.de>
 <20201009081532.30411d62@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <6b8ec5fe-ca93-d2cf-3060-4f087fcdc85a@denx.de>
 <20201009110230.3d8693df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <338cdf37-2b26-84ce-fdb6-f22f756df163@denx.de>
Date:   Sat, 10 Oct 2020 10:45:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201009110230.3d8693df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/9/20 8:02 PM, Jakub Kicinski wrote:
> On Fri, 9 Oct 2020 19:34:10 +0200 Marek Vasut wrote:
>>>>> To an untrained eye this looks pretty weird.    
>>>>
>>>> I see, I'm not quite sure how to address this comment.  
>>>
>>> If ndev->phydev sometimes is not-NULL on open, then that's a valid
>>> state to be in. Why not make sure that we're always in that state 
>>> and can depend on ndev->phydev rather than rummaging around for 
>>> the phy_device instance.  
>>
>> Nope, the problem is in probe() in this case.
> 
> In that case it would be cleaner to pass fep and phydev as arguments
> into fec_enet_clk_enable(), rather than netdev, and have only probe()
> do the necessary dance.

So correction, the problem does only happen in open(), in probe() the
phydev->drv is still NULL so the PHY reset cannot be triggered. In
open(), first the clock have to be enabled, then the reset must toggle,
then the PHY IDs can be reliably read.

I suspect reset in probe() will need another patch.
