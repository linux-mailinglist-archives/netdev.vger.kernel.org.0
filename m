Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092265B9AD2
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 14:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiIOMbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 08:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiIOMbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 08:31:11 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D763867145;
        Thu, 15 Sep 2022 05:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=I3ZAy4aja56eP0j0nEZoT9Ay84KDfaJyzdgAhvllAHM=; b=VkAOkLrV7evLiiuzNEH4hxRYA4
        vdL5ZAvpajdNldEnXqkhRVW3Lb2XV5swN0nTSSA4/EqPb/FGI+BnnJCAoUTWxtfLp0r/XG/mPx0Hb
        ibvk/eWWiXEK2tStMrpKk9UQ+zCHBYWttoPfY7k4VC2YpNuDWIJgl1gSHo35LI11+q4I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oYo0y-00GowF-9i; Thu, 15 Sep 2022 14:30:44 +0200
Date:   Thu, 15 Sep 2022 14:30:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Choong Yong Liang <yong.liang.choong@linux.intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Dan Murphy <dmurphy@ti.com>,
        Song Yoong Siang <yoong.siang.song@intel.com>,
        Cacho Gerome <g-cacho@ti.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/1] net: phy: dp83867: perform phy reset after
 modifying auto-neg setting
Message-ID: <YyMa9BNjgRYrc3z3@lunn.ch>
References: <20220915090258.2154767-1-yong.liang.choong@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220915090258.2154767-1-yong.liang.choong@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 15, 2022 at 05:02:58AM -0400, Choong Yong Liang wrote:
> From: Song Yoong Siang <yoong.siang.song@intel.com>
> 
> In the case where TI DP83867 is connected back-to-back with another TI
> DP83867, SEEDs match will occurs when advertised link speed is changed from
> 100 Mbps to 1 Gbps, which causing Master/Slave resolution fails and restart
> of the auto-negotiation. As a result, TI DP83867 copper auto-negotiation
> completion will takes up to 15 minutes.

802.3 seems to indicate that if the seeds match, it should immediately
generate a new random seed and try the master/slave selection
again. So you seem to be saying this part is broken.

> To resolve the issue, this patch implemented phy reset (software restart
> which perform a full reset, but not including registers) immediately after
> modifying auto-negotiation setting. By applying reset to the phy, it would
> also reset the lfsr which would increase the probability of SEEDS being
> different and help in Master/Slave resolution.

So this just increases the likelihood of different seed values. The 15
minute wait could still happen. The link peer seed value should be
accessible via the autoneg page registers. Can the local seed value be
determined? Linux can then detect that the same seed is being used and
give the PHY a kick to pick a new seed.

Is there anything useful in register 10 bit, 15?

So long as you don't use interrupts, phylib is going to poll the PHY
once per second. It seems like you can get a better workaround by
using that polling to check if the PHY as got stuck, and give it a
kick.

	Andrew
