Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB1B59E87A
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343500AbiHWQ70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 12:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343592AbiHWQ6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 12:58:48 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF11F7695A;
        Tue, 23 Aug 2022 07:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FhxKkGuRSJCPS19swjGEpnaR6PB5g9G56uDDnI2exs8=; b=qBS8PF3KUObRGOHxSsX/YZs/JT
        oPZPmI2danpk1ls93Xk7LLn78aiRupWSJa4LhoN9kfVoqsHp72lhYjr38lFER1XwSa9YqNEbpzb50
        3bVClJu5cbnGW8I6bY0N8L/8ZwwCuiB/uQOzJ3gZfM7S6cL/mlTkpwgIhpG8zfZ3dh/U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oQUfY-00EMAk-OF; Tue, 23 Aug 2022 16:14:16 +0200
Date:   Tue, 23 Aug 2022 16:14:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Frank <Frank.Sae@motor-comm.com>, Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4.4] net: phy: Add driver for Motorcomm yt8521 gigabit
 ethernet phy
Message-ID: <YwTguA0azox3j5vi@lunn.ch>
References: <20220817112554.383-1-Frank.Sae@motor-comm.com>
 <20220822202147.4be904de@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822202147.4be904de@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 08:21:47PM -0700, Jakub Kicinski wrote:
> On Wed, 17 Aug 2022 19:25:54 +0800 Frank wrote:
> > +static int yt8521_fiber_config_aneg(struct phy_device *phydev)
> > +{
> > +	int err, changed;
> > +	u16 adv;
> > +
> > +	if (phydev->autoneg != AUTONEG_ENABLE)
> > +		return yt8521_fiber_setup_forced(phydev);
> > +
> > +	err =  ytphy_modify_ext_with_lock(phydev, YTPHY_MISC_CONFIG_REG,
> > +					  YTPHY_MCR_FIBER_SPEED_MASK,
> > +					  YTPHY_MCR_FIBER_1000BX);
> > +	if (err < 0)
> > +		return err;
> > +
> > +	/* enable Fiber auto sensing */
> > +	err =  ytphy_modify_ext_with_lock(phydev, YT8521_LINK_TIMER_CFG2_REG,
> > +					  0, YT8521_LTCR_EN_AUTOSEN);
> > +	if (err < 0)
> > +		return err;
> > +
> > +	/* Setup fiber advertisement */
> > +	adv = ADVERTISE_1000XFULL | ADVERTISE_1000XPAUSE |
> > +	      ADVERTISE_1000XPSE_ASYM;
> 
> Is it okay to ignore phydev->advertising and always set the same mask?

The user could of changed the pause settings, which are going to be
ignored here. Also, you should not assume the MAC can actually do
asymmetric pause, not all can. phydev->advertising will be set to only
include what the MAC can actually do.

The whole concept of having two line sides connected to one MAC and
seeing which gets link first is unsupported in Linux. In theory, you
want to be able to configure each line side differently. Maybe you
want autoneg on copper, but fixed on fibre, asymmetric pause with
fibre, but symmetric pause on copper, etc. Since there is only one
instance of phydev here, you don't have anywhere to store two sets of
configuration, nor any sort of kAPI to deal with two phydev structures
etc. So the user experience is not so great.

With the Marvell Switches which also have this capability, i actually
ignore it, use the phy-mode it decide which should be used, either
copper or fibre, and leave the other powered off so it can never get
link. There is at least one Marvell PHY which does however support
first up wins, so this behaviour is not new. I just don't recommend
it.

And it gets even more interesting when the SFP is actually copper. But
since the integration with phylink is missing in this driver, that is
not supported here.

	Andrew

