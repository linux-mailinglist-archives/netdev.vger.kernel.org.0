Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB14340CA0
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbhCRSOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230442AbhCRSON (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 14:14:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFCD364F1D;
        Thu, 18 Mar 2021 18:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616091253;
        bh=WJXaBc1cx6NHSgO4bTyGgYj1KQJ1lQp91QwR6cje2b8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0CdMRYcTVzwIzuvqKX7REkGrA7lLw6QB9kaqCtYe8SQmyisxQLhEGAAI6jtNPhS6x
         k5u7m0E2kXjDtPzgV3rFCfo0gTglUgfKrjbqolTtAOyBsKnVSdxQ2Dnlt64BkOJdI7
         qvpKf+QjCpQRo/er2C7inkYOG8LK+tF1KIbEEW6w=
Date:   Thu, 18 Mar 2021 19:14:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: Re: [PATCH net V2 1/1] net: phy: fix invalid phy id when probe using
 C22
Message-ID: <YFOYclhA75hjmQHY@kroah.com>
References: <20210318090937.26465-1-vee.khee.wong@intel.com>
 <b63c5068-1203-fcb6-560d-1d2419bb39b0@gmail.com>
 <c921bf7f-e4d1-eefa-c5ae-024d5e8a4845@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c921bf7f-e4d1-eefa-c5ae-024d5e8a4845@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 09:02:22AM -0700, Florian Fainelli wrote:
> 
> 
> On 3/18/2021 6:25 AM, Heiner Kallweit wrote:
> > On 18.03.2021 10:09, Wong Vee Khee wrote:
> >> When using Clause-22 to probe for PHY devices such as the Marvell
> >> 88E2110, PHY ID with value 0 is read from the MII PHYID registers
> >> which caused the PHY framework failed to attach the Marvell PHY
> >> driver.
> >>
> >> Fixed this by adding a check of PHY ID equals to all zeroes.
> >>
> > 
> > I was wondering whether we have, and may break, use cases where a PHY,
> > for whatever reason, reports PHY ID 0, but works with the genphy
> > driver. And indeed in swphy_read_reg() we return PHY ID 0, therefore
> > the patch may break the fixed phy.
> > Having said that I think your patch is ok, but we need a change of
> > the PHY ID reported by swphy_read_reg() first.
> > At a first glance changing the PHY ID to 0x00000001 in swphy_read_reg()
> > should be sufficient. This value shouldn't collide with any real world
> > PHY ID.
> 
> It most likely would not, but it could be considered an ABI breakage,
> unless we filter out what we report to user-space via SIOGCMIIREG and
> /sys/class/mdio_bus/*/*/phy_id
> 
> Ideally we would have assigned an unique PHY OUI to the fixed PHY but
> that would have required registering Linux as a vendor, and the process
> is not entirely clear to me about how to go about doing that.

If you need me to do that under the umbrella of the Linux Foundation,
I'll be glad to do so if you point me at the proper group to do that
with.

We did this for a few years with the USB-IF and have a vendor id
assigned to us for Linux through them, until they kicked us out because.
But as the number is in a global namespace, it can't be reused so we
keep it :)

thanks,

greg k-h
