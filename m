Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C90D669E87D
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 20:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjBUTmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 14:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjBUTmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 14:42:15 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E62A2E0D5;
        Tue, 21 Feb 2023 11:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=tUqbGdu/IkGy6WimNah0x6diWTOuCAUJ6tw9nCwa0NM=; b=il
        cS7emX+PMhJ1ARIpyJ5mHkUc9XJtocU6jmMd2YnblzOW+b+nLJK/r0u/MH/Akd8ibCcGfsqarcdr6
        lEKLsaifpPUH9g9S7AhId1KDy5J1sdl5vGsvmEZh7aQVJje4tIpmvjAIKicEyy0OdGKHwOmAULTz8
        W1tnp2jgiKzlHWA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pUYWT-005dFQ-QN; Tue, 21 Feb 2023 20:41:57 +0100
Date:   Tue, 21 Feb 2023 20:41:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Doug Berger <opendmb@gmail.com>
Cc:     "Wang, Xiaolei" <Xiaolei.Wang@windriver.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: BCM54220: After the BCM54220 closes the auto-negotiation, the
 configuration forces the 1000M network port to be linked down all the time.
Message-ID: <Y/UehVXRNHuRprAv@lunn.ch>
References: <MW5PR11MB5764F9734ACFED2EF390DFF795A19@MW5PR11MB5764.namprd11.prod.outlook.com>
 <ae617cad-63dc-333f-c4c4-5266de88e4f8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ae617cad-63dc-333f-c4c4-5266de88e4f8@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 10:44:44AM -0800, Doug Berger wrote:
> On 2/17/2023 12:06 AM, Wang, Xiaolei wrote:
> > hi
> > 
> >      When I use the nxp-imx7 board, eth0 is connected to the PC, eth0 is turned off the auto-negotiation mode, and the configuration is forced to 10M, 100M, 1000M. When configured to force 1000M，
> >      The link status of phy status reg(0x1) is always 0, and the chip of phy is BCM54220, but I did not find the relevant datasheet on BCM official website, does anyone have any suggestions or the datasheet of BCM54220?
> > 
> > thanks
> > xiaolei
> > 
> It is my understanding that the 1000BASE-T PHY requires peers to take on
> asymmetric roles and that establishment of these roles requires negotiation
> which occurs during auto-negotiation. Some PHYs may allow manual programming
> of these roles, but it is not standardized and tools like ethtool do not
> support manual specification of such details.

Are you talking about ethtool -s [master-slave|preferred-master|preferred-slave|forced-master|forced-slave]

The broadcom PHYs call genphy_config_aneg() -> __genphy_config_aneg()
-> genphy_setup_master_slave() which should configure this, even when
auto-neg is off.

	 Andrew
