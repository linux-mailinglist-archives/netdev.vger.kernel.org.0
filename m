Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 524FA5FB294
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 14:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiJKMmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 08:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiJKMmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 08:42:23 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5457B80EB5;
        Tue, 11 Oct 2022 05:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=KY83JvYoAV0pgz0kphFBxmsHspJ7rho//mBc72ItZhQ=; b=XVEEKAgezBOmP2SSc/BgX+GBjC
        IpZAfSTDQZOUzL9WlKfOlZSGDzfE4oI2KfySNqY+IXafimfiHInNXkoVd8U+xjbnrh3wOE8+7PBq4
        Nuh2QXEnvFtLgOSZ0PfDcuz/vI7vGYrNbcqioZUV+tWmBXH67fTUBKTky2xFSzPRrxzM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oiEZd-001iED-79; Tue, 11 Oct 2022 14:41:29 +0200
Date:   Tue, 11 Oct 2022 14:41:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Soha Jin <soha@lohu.info>
Cc:     'Giuseppe Cavallaro' <peppe.cavallaro@st.com>,
        'Alexandre Torgue' <alexandre.torgue@foss.st.com>,
        'Jose Abreu' <joabreu@synopsys.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Eric Dumazet' <edumazet@google.com>,
        'Jakub Kicinski' <kuba@kernel.org>,
        'Paolo Abeni' <pabeni@redhat.com>,
        'Yangyu Chen' <cyy@cyyself.name>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net: stmmac: use fwnode instead of of to configure
 driver
Message-ID: <Y0VkeSxv9IkJPHJj@lunn.ch>
References: <20221009162247.1336-1-soha@lohu.info>
 <20221009162247.1336-2-soha@lohu.info>
 <Y0SCuaVpAnbpMk72@lunn.ch>
 <9A100E763AFC9404+3a9901d8dd1f$56f01950$04d04bf0$@lohu.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9A100E763AFC9404+3a9901d8dd1f$56f01950$04d04bf0$@lohu.info>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 11, 2022 at 11:12:45AM +0800, Soha Jin wrote:
> Hi Andrew,
> 
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: Tuesday, October 11, 2022 4:38 AM
> > 
> > None of these are documented as being valid in ACPI. Do you need to ensure
> > they only come from DT, or you document them for ACPI, and get the ACPI
> > maintainers to ACK that they are O.K.
> 
> There is _DSD object in ACPI which is used to define Device Specific Data,
> and provide additional properties and information to the driver. With
> specific UUID listed in _DSD, a package can be used like Device Tree (a
> string key associated with a value), and this is also the object
> fwnode_property_* will parse with.
> 
> I have tested some of properties with a device describing stmmac device in
> ACPI, and it works. These properties should be the configuration to the
> driver, and is not related to the way configuring it. Moreover, these are
> described in _DSD and not a part of ACPI standard, there seems no need to
> ask ACPI maintainers.
> 
> Also, as described in Documentation/firmware-guide/acpi/enumeration.rst,
> there is a Device Tree Namespace Link HID (PRP0001) in kernel. PRP0001 can
> be used to describe a Device Tree in ACPI's _DSD object, and it just put DT
> properties in a _DSD package with the specific UUID I said above. But to
> utilize this feature, the driver seems need to use fwnode APIs.

The problem i see with ACPI is that everybody does it differently.
Each driver defines its own set of properties, which are different to
every other driver. You end up with snowflakes, each driver is unique,
making it harder to understand, you cannot transfer knowledge from one
driver to another. This is fine in the closed sources world of binary
blob drivers, you don't get to see other drivers that much. But for
Linux, everything is open, and we want you to look at other drivers,
copy the good ideas from other driver, make drivers look similar, so
they are easy to maintain. So ACPI snowflakes are bad.

DT on the other hand, through DT maintainers and general good
practices, splits its properties into driver unique and generic
properties. If there is a generic property for what you want to
express, you us it. Otherwise, you define a vendor property. If you
see the same vendor property a few times, you add a generic property,
since it is a concept which is shared by a number of drivers.  DT
documents all its properties.

The other problem is that people just seem to think they can stuff DT
properties into ACPI and call it done. But ACPI is not DT. DT has a
lot of history, things done wrong initially, and then corrected. We
don't want to just copy this history into ACPI. We want a clean
design, throwing away the history of things done wrongly. So i don't
expect ACPI to have any backwards compatibility hacks.

As you say, the ACPI standard says nothing about networking, or MDIO
busses, or PHYs. Which means we the Linux community can defines how
ACPI is used within networking, and we can say snowflakes are not
wanted. We can follow the good practices of DT, and document
everything.

So, please read
Documentation/firmware-guide/acpi/dsd/phy.rst. Anything generic to do
with PHYs, MDIO, etc should be documented in there. And your driver
should not handle any generic properties which are not listed in
there. Note that document says nothing about backwards compatibility.

Please add an
Documentation/firmware-guide/acpi/dsd/ethernet-controller.rst for all
the generic properties to do with the MAC driver, similar to the DT
document ethernet-controller.rst.

I would also suggest you add a document specific to this MAC driver,
documenting properties specific to it. Any DT properties which are
listed as deprecated, i don't expect to be seen implemented in ACPI.
The reset GPIO is a good example of this. Look at its horrible
history, how it is totally messed up in DT. Don't copy that mess into
ACPI.

> 
> > Backward compatibility only applies to DT. Anybody using ACPI should not
> > expect any backwards compatibility, they should be documented mandatory
> > properties right from the beginning.
> 
> Just do not want to mix the use of OF and fwnode APIs, I simply changed all
> OF property APIs with fwnode APIs. If you really think the backward
> compatibility should not exist in ACPI, I will change these compatible
> codes back to OF APIs.

Because ACPI is not DT, sometimes you do need to handle them
differently. If you have the exact same property in DT and ACPI, you
are just stuffing DT into ACPI, yes, you can use the fwnode APIs. But
when ACPI and DT differ, you need to use the lower level APIs to deal
with these differences.

     Andrew
