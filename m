Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22F794BF6D1
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 11:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbiBVK6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 05:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbiBVK6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 05:58:18 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B624A0BDF;
        Tue, 22 Feb 2022 02:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=tt2KhEzno4SSpvoBFwwMrMWWv+N9o6uA/stvGaf5lSE=; b=AO
        HvMXrZrWStEnGsgs9gZhZPmO9GcvX7J3xMNzncM3FRcviTELxwSwaacOGnhTgAhyw01+6RIoudXoF
        e4hgPdBzvKvnCJo4Tu+tLdOKmq8XxcbB7VA0s8nN3CFMbGDBg7936LXMeHshvTdmkyPnFyV9opbYo
        +rMWDeS6HNpRtk8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nMSrT-007bPd-CS; Tue, 22 Feb 2022 11:57:39 +0100
Date:   Tue, 22 Feb 2022 11:57:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [RFC 09/10] i2c: mux: add support for fwnode
Message-ID: <YhTBo03f5pY+J/R6@lunn.ch>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220221162652.103834-10-clement.leger@bootlin.com>
 <YhPSDTAPiTvEESnO@smile.fi.intel.com>
 <20220222095325.52419021@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220222095325.52419021@fixe.home>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 09:53:25AM +0100, Clément Léger wrote:
> Le Mon, 21 Feb 2022 19:55:25 +0200,
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> a écrit :
> 
> > On Mon, Feb 21, 2022 at 05:26:51PM +0100, Clément Léger wrote:
> > > Modify i2c_mux_add_adapter() to use with fwnode API to allow creating
> > > mux adapters with fwnode based devices. This allows to have a node
> > > independent support for i2c muxes.  
> > 
> > I^2C muxes have their own description for DT and ACPI platforms, I'm not sure
> > swnode should be used here at all. Just upload a corresponding SSDT overlay or
> > DT overlay depending on the platform. Can it be achieved?
> > 
> 
> Problem is that this PCIe card can be plugged either in a X86 platform
> using ACPI or on a ARM one with device-tree. So it means I should have
> two "identical" descriptions for each platforms.

ACPI != DT.

I know people like stuffing DT properties into ACPI tables, when ACPI
does not have a binding. But in this case, there is a well defined
ACPI mechanism for I2C muxes. You cannot ignore it because it is
different to DT. So you need to handle the muxes in both the ACPI way
and the DT way.

For other parts of what you are doing, you might be able to get away
by just stuffing DT properties into ACPI tables. But that is not for
me to decide, that is up to the ACPI maintainers.

	Andrew
