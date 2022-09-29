Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C182C5EF806
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 16:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235605AbiI2OxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 10:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235596AbiI2OxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 10:53:23 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B987513F2B5
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PLOq8BIwsz+UflE+hcRtraRq6nRH4gVDNLJqeZrYCk4=; b=FGSHmPfUuSzD4WcZpZdlnWAKiU
        KU3oP+2y+eFencNPmnyJDSp7hvPYRsNIg5b5Dc/+a5hZVfSy8tQ3LdqTjbMRss+7eR4koHopWJ+q1
        K1yyZkQQoCFPK+PM+cK2t1dhqxn6eEgitTtD74KAU33uBXVhYzovp7C07cWE5wlzDL7I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oduuV-000crR-BG; Thu, 29 Sep 2022 16:53:11 +0200
Date:   Thu, 29 Sep 2022 16:53:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Subject: Re: PHY firmware update method
Message-ID: <YzWxV/eqD2UF8GHt@lunn.ch>
References: <bf53b9b3660f992d53fe8d68ea29124a@walle.cc>
 <YzQ96z73MneBIfvZ@lunn.ch>
 <YzVDZ4qrBnANEUpm@nanopsycho>
 <YzWPXcf8kXrd73PC@lunn.ch>
 <20220929071209.77b9d6ce@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929071209.77b9d6ce@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 07:12:09AM -0700, Jakub Kicinski wrote:
> On Thu, 29 Sep 2022 14:28:13 +0200 Andrew Lunn wrote:
> > If we want to make the PHY a component of an existing devlink for a
> > MAC, we somehow have to find that devlink instance. A PHY is probably
> > a property of a port, so we can call netdev_to_devlink_port(), which
> > gives us a way into devlink.
> > 
> > However, the majority of MAC drivers don't have a devlink
> > instance. What do we do then? Have phylib create the devlink instance
> > for the MAC driver? That seems very wrong.
> > 
> > Which is why i was thinking the PHY should have its own devlink
> > instance.
> 
> Tricky stuff, how would you expose the topology of the system to 
> the user? My initial direction would also be component. Although 
> it may be weird if MAC has a way to flash "all" components in one go,
> and that did not flash the PHY :S

~/linux/drivers/net$ grep -r PHYLIB | wc
    114     394    4791

~/linux/drivers/net$ grep -r NET_DEVLINK | wc
     20      60     945

And, of those 20 using DEVLINK, only 4 appear to use PHYLIB.

> Either way I don't think we can avoid MACs having a devlink instance
> because there needs to be some form of topology formed.

In the past, we have tried to make PHYLIB features just work, without
MAC changes. It does not scale otherwise. Cable testing just works if
the PHY supports it, without the MAC driver being changed. PHY stats
work without MAC changes. PHY based PTP works without MAC changes, SFP
module EEPROM dumping works without MAC changes. Why should PHY
firmware upgrade need MAC changes? The MAC does not even care. All it
should see is that the link is down while the upgrade happens.

Maybe devlink is the wrong interface, if it is going to force us to
make MAC changes for most devices to actual make use of this PHY
feature.

     Andrew
