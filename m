Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371D659EC95
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 21:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbiHWTkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 15:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233294AbiHWTkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 15:40:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA6010E4FB;
        Tue, 23 Aug 2022 11:37:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75305B82052;
        Tue, 23 Aug 2022 18:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD021C433B5;
        Tue, 23 Aug 2022 18:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661279834;
        bh=DSpae36fXxOyMZuan/4/6KolNH5h3bBOf50hVyPoyAs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eMQXMPjH/uFtyjrmlaTeRitp32JIDRmrDKtD+gWYPOmd8u9GXVvdf6SSJfUSQZTsC
         2azgkVjO/641BjhkUs3TUcLk6XuB08Irc4e/IqnGa7cddIwD5Gm7wnGP6oYWd2rH7s
         xXHQeL2mgdaoxXZV0c7tEwusRk8uv3k5DhSFNEFRfAzLxoHV98JdJXZTLC85FV6h0f
         znVsMaZDUFXZFUxO/USlT3w2H41XuYA3iNXonkL56LjfsU2QB6VWaAOqSiCvJCPvOs
         mSmQBPj70rFNXIEkZqQh3eHM3/6vOlcB6UgeSxn2g9BBP/+KlWSOkdqX3ov53PVzT6
         2YGCWxUB4LV0w==
Date:   Tue, 23 Aug 2022 11:37:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
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
Message-ID: <20220823113712.4c530516@kernel.org>
In-Reply-To: <YwTguA0azox3j5vi@lunn.ch>
References: <20220817112554.383-1-Frank.Sae@motor-comm.com>
        <20220822202147.4be904de@kernel.org>
        <YwTguA0azox3j5vi@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Aug 2022 16:14:16 +0200 Andrew Lunn wrote:
> On Mon, Aug 22, 2022 at 08:21:47PM -0700, Jakub Kicinski wrote:
> > On Wed, 17 Aug 2022 19:25:54 +0800 Frank wrote:  
> > > +static int yt8521_fiber_config_aneg(struct phy_device *phydev)
> > > +{
> > > +	int err, changed;
> > > +	u16 adv;
> > > +
> > > +	if (phydev->autoneg != AUTONEG_ENABLE)
> > > +		return yt8521_fiber_setup_forced(phydev);
> > > +
> > > +	err =  ytphy_modify_ext_with_lock(phydev, YTPHY_MISC_CONFIG_REG,
> > > +					  YTPHY_MCR_FIBER_SPEED_MASK,
> > > +					  YTPHY_MCR_FIBER_1000BX);
> > > +	if (err < 0)
> > > +		return err;
> > > +
> > > +	/* enable Fiber auto sensing */
> > > +	err =  ytphy_modify_ext_with_lock(phydev, YT8521_LINK_TIMER_CFG2_REG,
> > > +					  0, YT8521_LTCR_EN_AUTOSEN);
> > > +	if (err < 0)
> > > +		return err;
> > > +
> > > +	/* Setup fiber advertisement */
> > > +	adv = ADVERTISE_1000XFULL | ADVERTISE_1000XPAUSE |
> > > +	      ADVERTISE_1000XPSE_ASYM;  
> > 
> > Is it okay to ignore phydev->advertising and always set the same mask?  
> 
> The user could of changed the pause settings, which are going to be
> ignored here. Also, you should not assume the MAC can actually do
> asymmetric pause, not all can. phydev->advertising will be set to only
> include what the MAC can actually do.
> 
> The whole concept of having two line sides connected to one MAC and
> seeing which gets link first is unsupported in Linux. In theory, you
> want to be able to configure each line side differently. Maybe you
> want autoneg on copper, but fixed on fibre, asymmetric pause with
> fibre, but symmetric pause on copper, etc. Since there is only one
> instance of phydev here, you don't have anywhere to store two sets of
> configuration, nor any sort of kAPI to deal with two phydev structures
> etc. So the user experience is not so great.
> 
> With the Marvell Switches which also have this capability, i actually
> ignore it, use the phy-mode it decide which should be used, either
> copper or fibre, and leave the other powered off so it can never get
> link. There is at least one Marvell PHY which does however support
> first up wins, so this behaviour is not new. I just don't recommend
> it.
> 
> And it gets even more interesting when the SFP is actually copper. But
> since the integration with phylink is missing in this driver, that is
> not supported here.

Interesting. Just to confirm - regardless of the two-sided design..
-edness.. IIUC my question has merit and we need v5?
