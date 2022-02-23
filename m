Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E711C4C12C2
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 13:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240470AbiBWMcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 07:32:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbiBWMcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 07:32:20 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB4989CCD;
        Wed, 23 Feb 2022 04:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=l65YBP0/Ao5VqwBl6JqRspKSljrEgHu0Gb3hdhIP+fk=; b=EHF8GZ43BfeA3j4U/oSe40Zu66
        8FI5J/s9exDY25bMTZfaUNgz0Fm7vZm+/d2NfBWBSXaisVDLi2qV0Du2/tfbXFitf1NMGz2ioj7ha
        nH5wntdSeV97wxL6spnxYbqWdOyeXWpZcHUsz2vIlfPe7xpcBucYtMjtdMKSgn6Hw4EA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nMqo0-007n0F-72; Wed, 23 Feb 2022 13:31:40 +0100
Date:   Wed, 23 Feb 2022 13:31:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
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
Subject: Re: [RFC 10/10] net: sfp: add support for fwnode
Message-ID: <YhYpLJPXxAm0FEtm@lunn.ch>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220221162652.103834-11-clement.leger@bootlin.com>
 <YhPSkz8+BIcdb72R@smile.fi.intel.com>
 <20220222142513.026ad98c@fixe.home>
 <YhYZAc5+Q1rN3vhk@smile.fi.intel.com>
 <888f9f1a-ca5a-1250-1423-6c012ec773e2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <888f9f1a-ca5a-1250-1423-6c012ec773e2@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If I understand this series correctly then this is about a PCI-E card
> which has an I2C controller on the card and behind that I2C-controller
> there are a couple if I2C muxes + I2C clients.

They are not i2c clients in the normal sense. The i2c bus connects to
an SFP cage. You can hot plug different sort of network modules into
the cage. So for example fibre optic modules or copper modules. The
modules have an 'at24' like block of memory, which is a mix of EEPROM
and status values. For copper modules, there is an MDIO over I2C
protocol which allows access to the Copper Ethernet PHY inside the
module.

The current device tree binding is that you have a node for the SFP
cage, which includes a phandle to the i2c bus, plus a list of GPIOs
connected to pins on the SFP cage. The SFP driver will then directly
access the memory, maybe instantiate an mdio-over-i2c device if
needed, and control the GPIOs. The Ethernet driver then has an OF node
with a phandle pointing to the SFP device.

The whole design of this is based around the hardware being a
collection of standard parts, i2c bus, i2c mux, gpio controller,
ethernet controller, each with their own driver as part of a linux
subsystem, and then having some glue to put all the parts
together. And at the moment, that glue is DT.

> Note the above all relies on my interpretation of this patch set,
> which may be wrong, since as said the patch-set does seem to be
> lacking when it comes to documentation / motivation of the patches.

I think some examples from DT will help with this.

  Andrew
