Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3056EF465
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 14:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240747AbjDZMgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 08:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240010AbjDZMgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 08:36:38 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF58E10E6;
        Wed, 26 Apr 2023 05:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vHcNuWEf+AFAbxJ4dXQKQXsqpEkSlzqI6bfHVncgfXk=; b=LC3WshsNOs8oQzf4YG0RM5OCs3
        PxLLN2e84jhyMnaVNMTuKQCyo4Zo7KB4hIC8u/xFlJgg1SSEVtlYL679+oUxyhDkKa3K2shMy19BL
        NF/imoU23D9p4exQncWeE4Xe7hSQqUdxziwmyGFUvw3jHmROjyluWeCjxU5H+oSUdOb8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1preNi-00BGmQ-CW; Wed, 26 Apr 2023 14:36:22 +0200
Date:   Wed, 26 Apr 2023 14:36:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, srk@ti.com
Subject: Re: [RFC PATCH 1/2] net: phy: dp83867: add w/a for packet errors
 seen with short cables
Message-ID: <38d9b4f9-06b5-4920-8b09-daa115bd52f4@lunn.ch>
References: <20230425054429.3956535-1-s-vadapalli@ti.com>
 <20230425054429.3956535-2-s-vadapalli@ti.com>
 <f29411d2-c596-4a07-8b6a-7d6e203c25e0@lunn.ch>
 <540149d0-a353-7225-7c58-a4e9738b7c7c@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540149d0-a353-7225-7c58-a4e9738b7c7c@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> @@ -934,8 +935,20 @@ static int dp83867_phy_reset(struct phy_device *phydev)
> >>  
> >>  	usleep_range(10, 20);
> >>  
> >> -	return phy_modify(phydev, MII_DP83867_PHYCTRL,
> >> +	err = phy_modify(phydev, MII_DP83867_PHYCTRL,
> >>  			 DP83867_PHYCR_FORCE_LINK_GOOD, 0);
> >> +	if (err < 0)
> >> +		return err;
> >> +
> >> +	phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_DSP_FFE_CFG, 0X0E81);
> > 
> > Maybe check the return code for errors?
> 
> The return value of phy_write_mmd() doesn't have to be checked since it will be
> zero for the following reasons:
> The dp83867 driver does not have a custom .write_mmd method. Also, the dp83867
> phy does not support clause 45. Due to this, within __phy_write_mmd(), the ELSE
> statement will be executed, which results in the return value being zero.

Interesting.

I would actually say __phy_write_mmd() is broken, and should be
returning what __mdiobus_write() returns.

You should assume it will get fixed, and check the return value. And
it does no harm to check the return value.

    Andrew
