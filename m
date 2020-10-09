Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383C8289010
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387556AbgJIRea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731996AbgJIReY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 13:34:24 -0400
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D5AC0613D2
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 10:34:23 -0700 (PDT)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4C7FYm5dHMz1rsMZ;
        Fri,  9 Oct 2020 19:34:13 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4C7FYd02Qjz1qrDL;
        Fri,  9 Oct 2020 19:34:12 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id Tlm77RoGWFSK; Fri,  9 Oct 2020 19:34:11 +0200 (CEST)
X-Auth-Info: Ci2vTBAfAeUMdFbCudIYGLXS4Ghvwt3/RSI7w1cNlok=
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri,  9 Oct 2020 19:34:11 +0200 (CEST)
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
From:   Marek Vasut <marex@denx.de>
Message-ID: <6b8ec5fe-ca93-d2cf-3060-4f087fcdc85a@denx.de>
Date:   Fri, 9 Oct 2020 19:34:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201009081532.30411d62@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/9/20 5:15 PM, Jakub Kicinski wrote:
> On Fri, 9 Oct 2020 09:20:30 +0200 Marek Vasut wrote:
>>> Can you describe your problem in detail?  
>>
>> Yes, I tried to do that in the commit message and the extra detailed
>> comment above the code. What exactly do you not understand from that?
> 
> Why it's not bound on the first open

It is getting bound on the first open. The problem is in probe(), where
fec_enet_clk_enable(ndev, true) [yes, the name of that function is bad]
calls fec_enet_phy_reset_after_clk_enable() and the ndev->phydev is NULL
while there is already existing instance of that phydev .

So this patch adds this extra look up to get the phydev, which then
permits phy_reset_after_clk_enable() to call phy_device_reset() instead
of returning -ENODEV.

> (I'm guessing it's the first open
> that has the ndev->phydev == NULL? I shouldn't have to guess).

If I had a crystal ball that'd tell me all the review questions up
front, I would write perfect patches with all the feedback sorted out in
V1. Sorry, I don't have one ...

>>> To an untrained eye this looks pretty weird.  
>>
>> I see, I'm not quite sure how to address this comment.
> 
> If ndev->phydev sometimes is not-NULL on open, then that's a valid
> state to be in. Why not make sure that we're always in that state 
> and can depend on ndev->phydev rather than rummaging around for 
> the phy_device instance.

Nope, the problem is in probe() in this case.
