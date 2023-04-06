Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4ED6D91EA
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 10:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235527AbjDFIsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 04:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233176AbjDFIsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 04:48:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A054ED2
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 01:48:15 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1pkLH4-0001xA-6k; Thu, 06 Apr 2023 10:47:18 +0200
Received: from mfe by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1pkLGz-0004Sj-1e; Thu, 06 Apr 2023 10:47:13 +0200
Date:   Thu, 6 Apr 2023 10:47:13 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 06/12] net: phy: add phy_device_atomic_register helper
Message-ID: <20230406084713.qcnuutobu54pn3ht@pengutronix.de>
References: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
 <20230405-net-next-topic-net-phy-reset-v1-6-7e5329f08002@pengutronix.de>
 <ad0b0d90-04bf-457c-9bdf-a747d66871b5@lunn.ch>
 <20230405152225.tu3wmbcvchuugs5u@pengutronix.de>
 <a5a4e735-7b24-4933-b431-f36305689a79@lunn.ch>
 <20230405194353.pwuk7e6rxnha3uqi@pengutronix.de>
 <34e22343-fb11-4a85-bade-492fcbcfb436@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34e22343-fb11-4a85-bade-492fcbcfb436@lunn.ch>
User-Agent: NeoMutt/20180716
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23-04-05, Andrew Lunn wrote:
> > Currently we have one API which creates/allocates the 'struct
> > phy_device' and intialize the state which is:
> >    - phy_device_create()
> > 
> > This function requests a driver based on the phy_id/c45_ids. The ID have
> > to come from somewhere if autodection is used. For autodetection case
> >    - get_phy_device()
> > 
> > is called. This function try to access the phy without taken possible
> > hardware dependencies into account. These dependecies can be reset-lines
> > (in my case), clocks, supplies, ...
> > 
> > For taking fwnode (and possible dependencies) into account fwnode_mdio.c
> > was written which provides two helpers:
> >    - fwnode_mdiobus_register_phy()
> >    - fwnode_mdiobus_phy_device_register().
> > 
> > The of_mdio.c and of_mdiobus_register_phy() is just a wrapper around
> > fwnode_mdiobus_register_phy().
> 
> It seems to me that the real problem is that mdio_device_reset() takes
> an mdio_device. mdiobus_register_gpiod() and mdiobus_register_reset()
> also take an mdio_device. These are the functions you want to call
> before calling of_mdiobus_register_phy() in __of_mdiobus_register() to
> ensure the PHY is out of reset. But you don't have an mdio_device yet.

Of course, this was the problem as well and therefore I did the split in
the first two patches, to differentiate between allocation and init.

> So i think a better solution is to refactor this code. Move the
> resources into a structure of their own, and make that a member of
> mdio_device.

Sorry I can't follow you here, I did the refactoring already to
differentiate between phy_device_alloc() and phy_device_init(). The
parse and registration happen in between, like you descriped below. I
didn't changed/touched the mdio_device and phy_device structs since
those structs are very open and can be adapted by every driver.

> You can create a stack version of this resource structure
> in __of_mdiobus_register(), parse DT to fill it out by calling
> mdiobus_register_gpiod() and mdiobus_register_reset() taking this new
> structure, take it out of reset by calling mdio_device_reset(), and
> then call of_mdiobus_register_phy(). If a PHY is found, copy the
> values in the resulting mdio_device. If not, release the resources.

It is not just the reset, my approach would be the ground work for
adding support of other resources to, which are not handled yet. e.g.
phy-supply, clocks, pwdn-lines, ... With my approach it is far easier of
adding this 

> Doing it like this means there is no API change.

Why is it that important? All users of the current fwnode API are
changed and even better, they are replaced in a 2:1 ratio. The new API
is the repaired version of the fwnode API which is already used by ACPI
and OF to register a phy_device. For all non-ACPI/OF users the new API
provides a way to allocate/identify and register a new phy within a
single call.

Regards,
  Marco
