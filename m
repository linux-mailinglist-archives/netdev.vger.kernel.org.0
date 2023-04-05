Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A965F6D8724
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 21:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbjDETof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 15:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbjDETod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 15:44:33 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426BFEE
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 12:44:30 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1pk930-00087L-Th; Wed, 05 Apr 2023 21:43:58 +0200
Received: from mfe by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1pk92v-0005ZW-QA; Wed, 05 Apr 2023 21:43:53 +0200
Date:   Wed, 5 Apr 2023 21:43:53 +0200
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
Message-ID: <20230405194353.pwuk7e6rxnha3uqi@pengutronix.de>
References: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
 <20230405-net-next-topic-net-phy-reset-v1-6-7e5329f08002@pengutronix.de>
 <ad0b0d90-04bf-457c-9bdf-a747d66871b5@lunn.ch>
 <20230405152225.tu3wmbcvchuugs5u@pengutronix.de>
 <a5a4e735-7b24-4933-b431-f36305689a79@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5a4e735-7b24-4933-b431-f36305689a79@lunn.ch>
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
> > The current fwnode_mdio.c don't provide the proper helper functions yet.
> > Instead the parsing is spread between fwnode_mdiobus_register_phy() and
> > fwnode_mdiobus_phy_device_register(). Of course these can be extracted
> > and exported but I don't see the benefit. IMHO it just cause jumping
> > around files and since fwnode is a proper firmware abstraction we could
> > use is directly wihin core/lib files.
> 
> No, assuming fwnode is the proper firmware abstraction is wrong. You
> need to be very careful any time you convert of_ to fwnode_ and look
> at the history of every property. Look at the number of deprecated OF
> properties in Documentation/devicetree/bindings. They should never be
> moved to fwnode_ because then you are moving deprecated properties to
> ACPI, which never had them in the first place! 

The handling of deprecated properties is always a pain. Drivers handling
deprecated properties correctly for of_ should handle it correctly for
fwnode_ too. IMHO it would be driver bug if not existing deprecated
properties cause an error.  Of course there will be properties which
need special attention for ACPI case but I don't see a problem for
deprecated properties since those must be handled correctly for of_ case
too.

> You cannot assume DT and ACPI are the same thing, have the same
> binding. And the same is true, in theory, in the opposite direction.
> We don't want the DT properties polluted with ACPI only properties.
> Not that anybody takes ACPI seriously in networking.

My assumption was that ACPI is becoming more closer to OF and the
fwnode/device abstraction is the abstraction to have one driver
interacting correctly with OF and ACPI. As I said above there will be
some corner-cases which need special attention of course :/

Also while answering this mail, I noticed that there are already some
'small' fwnode/device_ helpers within phy_device.c. So why not bundling
everything within phy_device.c?

> > I know and I thought about adding the firmware parsing helpers first but
> > than I went this way. I can split this of course to make the patch
> > smaller.
> 
> Please do. Also, i read your commit message thinking it was a straight
> copy of the code, and hence i did not need to review the code. But in
> fact it is new code. So i need to take a close look at it.
> 
> But what i think is most important for this patchset is the
> justification for not fixing the current API. Why is it broken beyond
> repair?

Currently we have one API which creates/allocates the 'struct
phy_device' and intialize the state which is:
   - phy_device_create()

This function requests a driver based on the phy_id/c45_ids. The ID have
to come from somewhere if autodection is used. For autodetection case
   - get_phy_device()

is called. This function try to access the phy without taken possible
hardware dependencies into account. These dependecies can be reset-lines
(in my case), clocks, supplies, ...

For taking fwnode (and possible dependencies) into account fwnode_mdio.c
was written which provides two helpers:
   - fwnode_mdiobus_register_phy()
   - fwnode_mdiobus_phy_device_register().

The of_mdio.c and of_mdiobus_register_phy() is just a wrapper around
fwnode_mdiobus_register_phy().

fwnode_mdiobus_register_phy():
   1st) calls get_phy_device() in case of autodection or c45. If phy_id
        is provided and !c45 case phy_device_create() is called to get a
	'struct phy_device'
        - The autodection/c45 case try to access the PHYID registers
	  which is not possible, please see above.
   2nd) call fwnode_mdiobus_phy_device_register() or
        phy_device_register() directly.
	- phy_device_register() is the first time we taking the possible
	  hardware reset line into account, which is far to late.

fwnode_mdiobus_phy_device_register():
   - takes a 'struct phy_device' as parameter, again this have to come
     from somewhere.
   - calls phy_device_register() which is taken the possibel hardware
     reset into account, again to late.

Why do I need the autodection? Because PHYs can be changed due to EOL,
cheaper device, ... I don't wanna have a new devicetree/firmware for the
updated product, just let the magic happen :)

Why do I introduce a new API?
  1st) There are working users of get_phy_device() and I don't wanna
       break their systems, so I left this logic untouched. 
  2nd) The fwnode API is replaced by this new one, since it is
       broken (please see above). 
  3rd) IMHO the 'phy request/phy create' handling is far to complex
       therefore I introduced a single API which:
       - intialize all structures and states
       - prepare the device for interaction by using fwnode
       - initialize/detect the device and requests the coorect phy
	 module
       - applies the fixups
       - add the device to the kernel
       - finally return the 'struct phy_device' to the user, so the
	 driver can do $stuff.
  4th) The new 'struct phy_device_config' makes it easier to
       adapt/extend the API.

Thanks a lot for your fast response and feedback :)

Regards,
  Marco
