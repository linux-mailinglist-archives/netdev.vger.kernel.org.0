Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADC463DD0F
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 19:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiK3SV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 13:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbiK3SUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 13:20:49 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E0A8C46A;
        Wed, 30 Nov 2022 10:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4c09+CUgf/2EPKD4iaGq2aTS0q8Ubfdgolp1/FJx814=; b=DysGmG6Tr3Q1hxLAFB2v+yoiX+
        RQjxudqAX9v2CpHHusShXSIll1fM9jg+KylojiYgu/tsLE2CBy7tmhoAN/GwGxB/n0h+buvrjcEoN
        9imHJYaMPKAWLcrn/KROi0AwImFIVyl2ECfwUw9iCMyhGz2Pgy7c1+JlNWRy1nLws7js=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0Rfo-003zJo-Vu; Wed, 30 Nov 2022 19:19:09 +0100
Date:   Wed, 30 Nov 2022 19:19:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Frank <Frank.Sae@motor-comm.com>, Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: Add driver for Motorcomm yt8531
 gigabit ethernet phy
Message-ID: <Y4eenBOnpWt17ovJ@lunn.ch>
References: <20221130094928.14557-1-Frank.Sae@motor-comm.com>
 <Y4copjAzKpGSeunB@shell.armlinux.org.uk>
 <Y4eOkiaRywaUJa9n@lunn.ch>
 <Y4eT25bT7T8W6UXW@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4eT25bT7T8W6UXW@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 05:33:15PM +0000, Russell King (Oracle) wrote:
> Hi Andrew,
> 
> On Wed, Nov 30, 2022 at 06:10:42PM +0100, Andrew Lunn wrote:
> > This is not the first time Russell has pointed out your locking is
> > wrong.
> > 
> > How about adding a check in functions which should be called with the
> > lock taken really do have the lock taken?
> 
> They already do:
> 
>         lockdep_assert_held_once(&bus->mdio_lock);
> 
> but I guess people just aren't testing their code with lockdep enabled.
> 
> The only other thing I can think of trying is to use mutex_trylock():
> 
> 	if (WARN_ON_ONCE(mutex_trylock(&bus->mdio_lock)))
> 		mutex_unlock(&bus->mdio_lock);
> 
> scattered throughout.

The ASSERT_RTNL() macro does this, it does not depend on lockdep.

And given the persistent sort of problems we have seen, you are
probably correct, lockdep is not being enabled by some developers.  I
guess they don't even know what it is.

	 Andrew
