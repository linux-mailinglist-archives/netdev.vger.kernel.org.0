Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA6E3FE8D6
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 07:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236226AbhIBFoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 01:44:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231153AbhIBFoP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 01:44:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C426A60238;
        Thu,  2 Sep 2021 05:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630561394;
        bh=hjHUyru37UsQhLCqhmVDxmrouYvn6mWq2Wkx5ZFD1lA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LXohJie3Iy3D7O32IvK39+KLuPXHlyeICS20tMns5LF8muNnCdiMWYdQvba9wW7AG
         xJFzKxyXye2xwRvNxyI5RAxL43Yfk8A1kgd4ABdFT7Uqltu/51irNJS7IqraI7OIlh
         A+C+jj9IoBkdVa59EhFAboJkK9/jsVzuXt0BWYys=
Date:   Thu, 2 Sep 2021 07:43:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 1/3] net: phy: don't bind genphy in
 phy_attach_direct if the specific driver defers probe
Message-ID: <YTBkbvYYy2f/b3r2@kroah.com>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210901225053.1205571-2-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901225053.1205571-2-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 01:50:51AM +0300, Vladimir Oltean wrote:
> There are systems where the PHY driver might get its probe deferred due
> to a missing supplier, like an interrupt-parent, gpio, clock or whatever.
> 
> If the phy_attach_direct call happens right in between probe attempts,
> the PHY library is greedy and assumes that a specific driver will never
> appear, so it just binds the generic PHY driver.
> 
> In certain cases this is the wrong choice, because some PHYs simply need
> the specific driver. The specific PHY driver was going to probe, given
> enough time, but this doesn't seem to matter to phy_attach_direct.
> 
> To solve this, make phy_attach_direct check whether a specific PHY
> driver is pending or not, and if it is, just defer the probing of the
> MAC that's connecting to us a bit more too.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/base/dd.c            | 21 +++++++++++++++++++--
>  drivers/net/phy/phy_device.c |  8 ++++++++
>  include/linux/device.h       |  1 +
>  3 files changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 1c379d20812a..b22073b0acd2 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -128,13 +128,30 @@ static void deferred_probe_work_func(struct work_struct *work)
>  }
>  static DECLARE_WORK(deferred_probe_work, deferred_probe_work_func);
>  
> +static bool __device_pending_probe(struct device *dev)
> +{
> +	return !list_empty(&dev->p->deferred_probe);
> +}
> +
> +bool device_pending_probe(struct device *dev)
> +{
> +	bool pending;
> +
> +	mutex_lock(&deferred_probe_mutex);
> +	pending = __device_pending_probe(dev);
> +	mutex_unlock(&deferred_probe_mutex);
> +
> +	return pending;
> +}
> +EXPORT_SYMBOL_GPL(device_pending_probe);
> +
>  void driver_deferred_probe_add(struct device *dev)
>  {
>  	if (!dev->can_match)
>  		return;
>  
>  	mutex_lock(&deferred_probe_mutex);
> -	if (list_empty(&dev->p->deferred_probe)) {
> +	if (!__device_pending_probe(dev)) {
>  		dev_dbg(dev, "Added to deferred list\n");
>  		list_add_tail(&dev->p->deferred_probe, &deferred_probe_pending_list);
>  	}
> @@ -144,7 +161,7 @@ void driver_deferred_probe_add(struct device *dev)
>  void driver_deferred_probe_del(struct device *dev)
>  {
>  	mutex_lock(&deferred_probe_mutex);
> -	if (!list_empty(&dev->p->deferred_probe)) {
> +	if (__device_pending_probe(dev)) {
>  		dev_dbg(dev, "Removed from deferred list\n");
>  		list_del_init(&dev->p->deferred_probe);
>  		__device_set_deferred_probe_reason(dev, NULL);
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 52310df121de..2c22a32f0a1c 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -1386,8 +1386,16 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
>  
>  	/* Assume that if there is no driver, that it doesn't
>  	 * exist, and we should use the genphy driver.
> +	 * The exception is during probing, when the PHY driver might have
> +	 * attempted a probe but has requested deferral. Since there might be
> +	 * MAC drivers which also attach to the PHY during probe time, try
> +	 * harder to bind the specific PHY driver, and defer the MAC driver's
> +	 * probing until then.

Wait, no, this should not be a "special" thing, and why would the list
of deferred probe show this?

If a bus wants to have this type of "generic vs. specific" logic, then
it needs to handle it in the bus logic itself as that does NOT fit into
the normal driver model at all.  Don't try to get a "hint" of this by
messing with the probe function list.

thanks,

greg k-h
