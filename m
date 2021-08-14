Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350B03EC37A
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 17:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238688AbhHNPXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 11:23:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50010 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238633AbhHNPXc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 11:23:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+xcyqJGzVSzEHEA1fuUegCx0faWqscCzNFFs988EPSQ=; b=JeEF3Gbl/zVxAi7G0NZONVh8rX
        x+bAcdPs1O2cIuLTVlZD3zJEyxsVB6/P0rf/9SMH9fEEfxzVa03u8DCRhoICnb5iIRNx88j/mqXVl
        oOJj531k7PO9kEIwpOqG53+8OJIxHuzPlXTBgIsxBmH/RGvk4uw0x6pO1sIkTFhuGQKU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mEvUr-0004vU-Fz; Sat, 14 Aug 2021 17:22:53 +0200
Date:   Sat, 14 Aug 2021 17:22:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, kernel-team@android.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v1 2/2] of: property: fw_devlink: Add support for
 "phy-handle" property
Message-ID: <YRffzVgP2eBw7HRz@lunn.ch>
References: <20210814023132.2729731-1-saravanak@google.com>
 <20210814023132.2729731-3-saravanak@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210814023132.2729731-3-saravanak@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saravana

> Hi Andrew,
> 

> Also there
> are so many phy related properties that my head is spinning. Is there a
> "phy" property (which is different from "phys") that treated exactly as
> "phy-handle"?

Sorry, i don't understand your question.

> +	/*
> +	 * Device tree nodes pointed to by phy-handle never have struct devices
> +	 * created for them even if they have a "compatible" property. So
> +	 * return the parent node pointer.
> +	 */

We have a classic bus with devices on it. The bus master is registers
with linux using one of the mdiobus_register() calls. That then
enumerates the bus, looking at the 32 possible address on the bus,
using mdiobus_scan. It then gets a little complex, due to
history.

Originally, the only thing you could have on an MDIO bus was a
PHY. But devices on MDIO busses are more generic, and Linux gained
support for Ethernet switches on an MDIO bus, and there are a few
other sort device. So to keep the PHY API untouched, but to add these
extra devices, we added the generic struct mdio_device which
represents any sort of device on an MDIO bus. This has a struct device
embedded in it.

When we scan the bus and find a PHY, a struct phy_device is created,
which has an embedded struct mdio_device. The struct device in that is
then registered with the driver core.

So a phy-handle does point to a device, but you need to do an object
orientated style look at the base class to find it.

	   Andrew
