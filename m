Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 570FE63E790
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 03:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiLACOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 21:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLACOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 21:14:54 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7812862DC
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 18:14:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=AWYONY4OtWmBCVvgaY1Wq+1qizR7PPLF6prnj0iBV/s=; b=Jc17KBYNHIHmq0mcatiq/l6nAl
        pXD/TmNtPGDLbc8m6mr1KRb/4UR76TYZBktNAmbc4G82rACkKiFn7OsjZSl6UTOUUbUurLLb/fsP2
        oEUQYEhtgCKBudrfpccHTxDz+F/EdX52CLWqv8Aq983n0rUqLJgUtkDpu1pYqmLJ+L9Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0Z6B-0041ON-S7; Thu, 01 Dec 2022 03:14:51 +0100
Date:   Thu, 1 Dec 2022 03:14:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Help on PHY not supporting autoneg
Message-ID: <Y4gOG5rFwlezsfoD@lunn.ch>
References: <Y4dJgj4Z8516tJwx@gvm01>
 <Y4d3fV8lUhUehCq6@lunn.ch>
 <Y4fgT1kjX9LTULOi@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4fgT1kjX9LTULOi@gvm01>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> /root # ethtool eth0
> Settings for eth0:
>         Supported ports: [ MII ]
>         Supported link modes:   10baseT1S_P2MP/Half
>         Supported pause frame use: Symmetric Receive-only
>         Supports auto-negotiation: No
>         Supported FEC modes: Not reported
>         Advertised link modes:  10baseT1S_P2MP/Half
>         Advertised pause frame use: Symmetric Receive-only

That looks odd. The PHY should indicate if it supports pause
negotiation. Since this PHY does not support autoneg, it should not be
saying it can negotiate pause. So i'm wondering why it is saying this
here. Same for 'Supported pause'.

>         Advertised auto-negotiation: No
>         Advertised FEC modes: Not reported
>         Speed: 10Mb/s
>         Duplex: Half
>         Auto-negotiation: off
>         Port: Twisted Pair
>         PHYAD: 8
>         Transceiver: external
>         MDI-X: off (auto)

Given that this is a T1 PHY does MDI-X have any meaning? The (auto)
indicates the PHY is returning mdix_ctrl=ETH_TP_MDI_AUTO, when it
should be returning ETH_TP_MDI_INVALID to indicate it is not
supported.

>         Supports Wake-on: d
>         Wake-on: d
>         Current message level: 0x0000003f (63)
>                                drv probe link timer ifdown ifup
>         Link detected: yes
> 
> 
> > What exactly is LINK_CONTROL. It is not one of the Linux names for a
> > bit in BMCR.
> The 802.3cg standard define link_control as a varibale set by autoneg.
> In factm it is tied to the BMCR_ANENABLE bit. The standard further
> specifies that when AN is not supported, this bit can be supplied in a
> vendor-specific way. A common thing to do is to just leave it tied to
> the BMCR_ANENABLE bit.
> 
> So, the "problem" seems to lie in the genphy_setup_forced() function.
> More precisely, where you pointed me at: 
> >       return phy_modify(phydev, MII_BMCR,
> >                         ~(BMCR_LOOPBACK | BMCR_ISOLATE | BMCR_PDOWN), ctl);
> > 
> 
> In my view we have two choices to handle LINK_CONTROL.
> 
> 1. Just let the PHY driver override the config_aneg() callback as I did.
> This may be a bit counter-intuitive because of the function name, but it
> works.
> 
> 2. in phylib, distinguish the case of a PHY having aneg disabled from a
> PHY NOT supporting aneg. In the latter case, don't touch the control
> register and/or provide a separate callback for "starting" the PHY
> (e.g., set_link_ctrl)

2) sounds wrong. As you said, it is vendor-specific. As such you
cannot trust it to mean anything. The standard has left it undefined,
so you cannot do anything in generic code. I would also worry about
breaking older PHYs who have never had this bit set.

So i would go with 1). As i said, the function name is not ideal, but
it has been like this since forever.

   Andrew
