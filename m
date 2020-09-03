Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0960D25CC67
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729376AbgICVgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbgICVgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 17:36:54 -0400
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A57C061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 14:36:54 -0700 (PDT)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4BjDf804V7z1rrjv;
        Thu,  3 Sep 2020 23:36:41 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4BjDf108cyz1qspL;
        Thu,  3 Sep 2020 23:36:41 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id DAVvDrl0xbGM; Thu,  3 Sep 2020 23:36:39 +0200 (CEST)
X-Auth-Info: yKojWHgSQ3GXkOIv6BJpJfc2ykt2+30qMU41Hq3fk0Y=
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu,  3 Sep 2020 23:36:39 +0200 (CEST)
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
From:   Marek Vasut <marex@denx.de>
Message-ID: <b6397b39-c897-6e0a-6bf7-b6b24908de1a@denx.de>
Date:   Thu, 3 Sep 2020 23:36:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200903210011.GD3112546@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/3/20 11:00 PM, Andrew Lunn wrote:
> On Thu, Sep 03, 2020 at 10:27:12PM +0200, Marek Vasut wrote:
>> The phy_reset_after_clk_enable() does a PHY reset, which means the PHY
>> loses its register settings. The fec_enet_mii_probe() starts the PHY
>> and does the necessary calls to configure the PHY via PHY framework,
>> and loads the correct register settings into the PHY. Therefore,
>> fec_enet_mii_probe() should be called only after the PHY has been
>> reset, not before as it is now.
> 
> I think this patch is related to what Florian is currently doing with
> PHY clocks.

Which is what ? Details please.

> I think a better fix for the original problem is for the SMSC PHY
> driver to control the clock itself. If it clk_prepare_enables() the
> clock, it knows it will not be shut off again by the FEC run time
> power management.

The FEC MAC is responsible for generating the clock, the PHY clock are
not part of the clock framework as far as I can tell.

> All this phy_reset_after_clk_enable() can then go away.

I'm not sure about that. Also, this is a much simpler fix which can be
backported easily.
