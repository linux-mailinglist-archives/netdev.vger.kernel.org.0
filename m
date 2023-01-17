Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B9466E018
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 15:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbjAQON5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 09:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbjAQONm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 09:13:42 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF153BD86;
        Tue, 17 Jan 2023 06:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kkWpEbdhvO9/WJMoBB3MOxQsl6iaZufmOeTDARQQiuM=; b=RusiT9QT2rv87W+fSdOaBIPtk2
        dfGWgfX+1Hj73f0cxDv+9PxhuIwIVLCHIHmW0+ONwGfQztRC3+9fmE4hElqwowvjFw9gGmgNKYNMc
        z08s0j/mqLljUnuNUG+YnPaNb1V0FWPMWNdueaxC79cKZVFLLU4rGNw1pgS4kmPp/XXA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pHmiQ-002KUd-8i; Tue, 17 Jan 2023 15:13:30 +0100
Date:   Tue, 17 Jan 2023 15:13:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lars-Peter Clausen <lars@metafoo.de>
Cc:     Pierluigi Passaro <pierluigi.passaro@gmail.com>,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eran.m@variscite.com, nate.d@variscite.com,
        francesco.f@variscite.com, pierluigi.p@variscite.com
Subject: Re: [PATCH] net: mdio: force deassert MDIO reset signal
Message-ID: <Y8atCtZdV96cj3n1@lunn.ch>
References: <20230115161006.16431-1-pierluigi.p@variscite.com>
 <Y8QzI2VUY6//uBa/@lunn.ch>
 <f691f339-9e50-b968-01e1-1821a2f696e7@metafoo.de>
 <Y8SSb+tJsfJ3/DvH@lunn.ch>
 <cc338014-8a2b-87e9-7684-20b57aae4ac3@metafoo.de>
 <Y8alV6FUKsN2x2XZ@lunn.ch>
 <54eb0ee4-7d9e-7025-f984-b1e026c18c3d@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54eb0ee4-7d9e-7025-f984-b1e026c18c3d@metafoo.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > I think part of the problem is that for C45 there are a few other fields
> > > that get populated by the ID detection, such as devices_in_package and
> > > mmds_present. Is this something we can do after running the PHY drivers
> > > probe function? Or is it too late at that point?
> > As i hinted, it needs somebody to actually debug this and figure out
> > why it does not work.
> > 
> > I think what i did above is part of the solution. You need to actually
> > read the ID from the DT, which if you never call fwnode_get_phy_id()
> > you never do.
> > 
> > You then need to look at phy_bus_match() and probably remove the
> > 
> > 		return 0;
> > 	} else {
> > 
> > so that C22 style ID matching is performed if matching via
> > c45_ids.device_ids fails.
> 
> Sorry, I've should have been more clear. I did try your proposed change a
> while ago. The problem why it does not work is that there are other fields
> in the phy data structure that get initialized when reading the IDs for C45.
> Such as which MMD addresses are valid.

So lets take this one step at a time.

Does this change at least get the driver loaded?

There is some code in phy-c45.c which needs
phydev->c45_ids.mmds_present. So maybe after the driver has probed,
and the device should be accessible, we need to call get_phy_c45_ids()
to fill in the missing IDs?

   Andrew
