Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E535EF573
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 14:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbiI2M2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 08:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233495AbiI2M2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 08:28:24 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A15F149D12
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 05:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=MDmt62mvFfcgipFXIZFhOYE8Cin092OGeFHr8iDUKjg=; b=JgokQ+cbSU44loS9iy4RX32Zrg
        RDCBXNlkRA/cKNPUx7TuI/FNd/WM7g50yMstmt2G8+C+EN67LxIh0uBNUK4FhVk7pZ9pL8I9Vc+hA
        o0BXj+YSa51kEoP5Vmrl6kWHrcaLz0JbPN5LXQl+bnzcX0hd3+cSqMxbjzfCACpcPVPM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1odseD-000c8A-Kg; Thu, 29 Sep 2022 14:28:13 +0200
Date:   Thu, 29 Sep 2022 14:28:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        kuba@kernel.org
Subject: Re: PHY firmware update method
Message-ID: <YzWPXcf8kXrd73PC@lunn.ch>
References: <bf53b9b3660f992d53fe8d68ea29124a@walle.cc>
 <YzQ96z73MneBIfvZ@lunn.ch>
 <YzVDZ4qrBnANEUpm@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzVDZ4qrBnANEUpm@nanopsycho>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >devlink has become the standard way for upgrading firmware on complex
> >network devices, like NICs and TOR switches. That is probably a good
> >solution here. The problem is, what devlink instance to use. Only a
> >few MAC drivers are using devlink, so it is unlikely the MAC driver
> >the PHY is attached to has a devlink instance. Do we create a devlink
> >instance for the PHY?
> 
> Ccing Jakub. I don't think it is good idea to create a devlink instance
> per-PHY. However, on the other hand, we have a devlink instance per
> devlink linecard now. The devlink linecard however has devlink
> representation, which PHY does not have.
> 
> Perhaps now is the time to dust-off my devlink components implementation
> and use it for PHYs? IDF. Jakub, WDYT.

If we want to make the PHY a component of an existing devlink for a
MAC, we somehow have to find that devlink instance. A PHY is probably
a property of a port, so we can call netdev_to_devlink_port(), which
gives us a way into devlink.

However, the majority of MAC drivers don't have a devlink
instance. What do we do then? Have phylib create the devlink instance
for the MAC driver? That seems very wrong.

Which is why i was thinking the PHY should have its own devlink
instance.

Or we do firmware upgrade some other way.

	Andrew
