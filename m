Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83311154E6C
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 22:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbgBFV4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 16:56:17 -0500
Received: from foss.arm.com ([217.140.110.172]:34904 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726765AbgBFV4R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Feb 2020 16:56:17 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8D5F830E;
        Thu,  6 Feb 2020 13:56:16 -0800 (PST)
Received: from [192.168.122.164] (unknown [10.118.30.29])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0F8A53F68E;
        Thu,  6 Feb 2020 13:56:16 -0800 (PST)
Subject: Re: [PATCH v1 1/7] mdio_bus: Introduce fwnode MDIO helpers
To:     Calvin Johnson <calvin.johnson@nxp.com>, linux.cj@gmail.com,
        Jon Nettleton <jon@solid-run.com>, linux@armlinux.org.uk,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        cristian.sovaiala@nxp.com, laurentiu.tudor@nxp.com,
        ioana.ciornei@nxp.com, V.Sethi@nxp.com, pankaj.bansal@nxp.com,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20200131153440.20870-1-calvin.johnson@nxp.com>
 <20200131153440.20870-2-calvin.johnson@nxp.com>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <371ff9b4-4de6-7a03-90f8-a1eae4d5402d@arm.com>
Date:   Wed, 5 Feb 2020 08:17:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200131153440.20870-2-calvin.johnson@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 1/31/20 9:34 AM, Calvin Johnson wrote:
> From: Marcin Wojtas <mw@semihalf.com>
> 
> This patch introduces fwnode helper for registering MDIO
> bus, as well as one for finding the PHY, basing on its
> firmware node pointer. Comparing to existing OF equivalent,
> fwnode_mdiobus_register() does not support:
>   * deprecated bindings (device whitelist, nor the PHY ID embedded
>     in the compatible string)
>   * MDIO bus auto scanning
> 
> Signed-off-by: Marcin Wojtas <mw@semihalf.com>
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---
> 
>   drivers/net/phy/mdio_bus.c | 218 +++++++++++++++++++++++++++++++++++++
>   include/linux/mdio.h       |   3 +
>   2 files changed, 221 insertions(+)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 229e480179ff..b1830ae2abd9 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -22,6 +22,7 @@
>   #include <linux/of_device.h>
>   #include <linux/of_mdio.h>
>   #include <linux/of_gpio.h>
> +#include <linux/of_irq.h>
>   #include <linux/netdevice.h>
>   #include <linux/etherdevice.h>
>   #include <linux/reset.h>
> @@ -725,6 +726,223 @@ static int mdio_uevent(struct device *dev, struct kobj_uevent_env *env)
>   	return 0;
>   }
>   
> +static int fwnode_mdiobus_register_phy(struct mii_bus *bus,
> +				       struct fwnode_handle *child, u32 addr)
> +{
> +	struct phy_device *phy;
> +	bool is_c45 = false;
> +	int rc;
> +
> +	rc = fwnode_property_match_string(child, "compatible",
> +					  "ethernet-phy-ieee802.3-c45");
> +	if (!rc)
> +		is_c45 = true;
> +
> +	phy = get_phy_device(bus, addr, is_c45);
> +	if (IS_ERR(phy))
> +		return PTR_ERR(phy);
> +
> +	phy->irq = bus->irq[addr];
> +
> +	if (to_of_node(child)) {
> +		rc = of_irq_get(to_of_node(child), 0);
> +		if (rc == -EPROBE_DEFER) {
> +			phy_device_free(phy);
> +			return rc;
> +		} else if (rc > 0) {
> +			phy->irq = rc;
> +			bus->irq[addr] = rc;
> +		}
> +	}
> +
> +	if (fwnode_property_read_bool(child, "broken-turn-around"))
> +		bus->phy_ignore_ta_mask |= 1 << addr;
> +
> +	/* Associate the fwnode with the device structure so it
> +	 * can be looked up later.
> +	 */
> +	phy->mdio.dev.fwnode = child;
> +
> +	/* All data is now stored in the phy struct, so register it */
> +	rc = phy_device_register(phy);
> +	if (rc) {
> +		phy_device_free(phy);
> +		fwnode_handle_put(child);
> +		return rc;
> +	}
> +
> +	dev_dbg(&bus->dev, "registered phy at address %i\n", addr);
> +
> +	return 0;
> +}
> +
> +static int fwnode_mdiobus_register_device(struct mii_bus *bus,
> +					  struct fwnode_handle *child, u32 addr)
> +{
> +	struct mdio_device *mdiodev;
> +	int rc;
> +
> +	mdiodev = mdio_device_create(bus, addr);
> +	if (IS_ERR(mdiodev))
> +		return PTR_ERR(mdiodev);
> +
> +	/* Associate the fwnode with the device structure so it
> +	 * can be looked up later.
> +	 */
> +	mdiodev->dev.fwnode = child;
> +
> +	/* All data is now stored in the mdiodev struct; register it. */
> +	rc = mdio_device_register(mdiodev);
> +	if (rc) {
> +		mdio_device_free(mdiodev);
> +		fwnode_handle_put(child);
> +		return rc;
> +	}
> +
> +	dev_dbg(&bus->dev, "registered mdio device at address %i\n", addr);
> +
> +	return 0;
> +}
> +
> +static int fwnode_mdio_parse_addr(struct device *dev,
> +				  const struct fwnode_handle *fwnode)
> +{
> +	u32 addr;
> +	int ret;
> +
> +	ret = fwnode_property_read_u32(fwnode, "reg", &addr);
> +	if (ret < 0) {
> +		dev_err(dev, "PHY node has no 'reg' property\n");
> +		return ret;
> +	}
> +
> +	/* A PHY must have a reg property in the range [0-31] */
> +	if (addr < 0 || addr >= PHY_MAX_ADDR) {
> +		dev_err(dev, "PHY address %i is invalid\n", addr);
> +		return -EINVAL;
> +	}
> +
> +	return addr;
> +}

Almost assuredly this is wrong, the _ADR method exists to identify a 
device on its parent bus. The DT reg property shouldn't be used like 
this in an ACPI enviroment.

Further, there are a number of other dt bindings in this set that seem 
inappropriate in common/shared ACPI code paths. That is because AFAIK 
the _DSD methods are there to provide device implementation specific 
behaviors, not as standardized methods for a generic classes of devices. 
Its vaguly the equivlant of the "vendor,xxxx" properties in DT.

This has been a discussion point on/off for a while with any attempt to 
publicly specify/standardize for all OS vendors what they might find 
encoded in a DSD property. The few year old "WORK_IN_PROGRESS" link on 
the uefi page has a few suggested ones

https://uefi.org/sites/default/files/resources/nic-request-v2.pdf

Anyway, the use of phy-handle with a reference to the phy device on a 
shared MDIO is a techically workable solution to the problem brought up 
in the RPI/ACPI thread as well. OTOH, it suffers from the use of DSD and 
at a minimum should probably be added to the document linked above if 
its found to be the best way to handle this. Although, in the common 
case of a mdio bus, matching acpi described devices with their 
discovered counterparts (note the device() defintion in the spec 
19.6.30) only to define DSD refrences is a bit overkill.

Put another way, while seemingly not nessiary if a bus can be probed, a 
nic/device->mdio->phy can be described in the normal ACPI heirarchy with 
only appropriatly nested CRS and ADR resources. Its the shared nature of 
the MDIO bus that causes problems.



> +
> +/**
> + * fwnode_mdiobus_child_is_phy - Return true if the child is a PHY node.
> + * It must either:
> + * o Compatible string of "ethernet-phy-ieee802.3-c45"
> + * o Compatible string of "ethernet-phy-ieee802.3-c22"
> + * Checking "compatible" property is done, in order to follow the DT binding.
> + */
> +static bool fwnode_mdiobus_child_is_phy(struct fwnode_handle *child)
> +{
> +	int ret;
> +
> +	ret = fwnode_property_match_string(child, "compatible",
> +					   "ethernet-phy-ieee802.3-c45");
> +	if (!ret)
> +		return true;
> +
> +	ret = fwnode_property_match_string(child, "compatible",
> +					   "ethernet-phy-ieee802.3-c22");
> +	if (!ret)
> +		return true;
> +
> +	if (!fwnode_property_present(child, "compatible"))
> +		return true;
> +
> +	return false;
> +}
> +
> +/**
> + * fwnode_mdiobus_register - Register mii_bus and create PHYs from the fwnode
> + * @bus: pointer to mii_bus structure
> + * @fwnode: pointer to fwnode_handle of MDIO bus.
> + *
> + * This function registers the mii_bus structure and registers a phy_device
> + * for each child node of @fwnode.
> + */
> +int fwnode_mdiobus_register(struct mii_bus *bus, struct fwnode_handle *fwnode)
> +{
> +	struct fwnode_handle *child;
> +	int addr, rc;
> +	int default_gpio_reset_delay_ms = 10;
> +
> +	/* Do not continue if the node is disabled */
> +	if (!fwnode_device_is_available(fwnode))
> +		return -ENODEV;
> +
> +	/* Mask out all PHYs from auto probing. Instead the PHYs listed in
> +	 * the firmware nodes are populated after the bus has been registered.
> +	 */
> +	bus->phy_mask = ~0;
> +
> +	bus->dev.fwnode = fwnode;
> +
> +	/* Get bus level PHY reset GPIO details */
> +	bus->reset_delay_us = default_gpio_reset_delay_ms;
> +	fwnode_property_read_u32(fwnode, "reset-delay-us",
> +				 &bus->reset_delay_us);
> +
> +	/* Register the MDIO bus */
> +	rc = mdiobus_register(bus);
> +	if (rc)
> +		return rc;
> +
> +	/* Loop over the child nodes and register a phy_device for each PHY */
> +	fwnode_for_each_child_node(fwnode, child) {
> +		addr = fwnode_mdio_parse_addr(&bus->dev, child);
> +		if (addr < 0)
> +			continue;
> +
> +		if (fwnode_mdiobus_child_is_phy(child))
> +			rc = fwnode_mdiobus_register_phy(bus, child, addr);
> +		else
> +			rc = fwnode_mdiobus_register_device(bus, child, addr);
> +		if (rc)
> +			goto unregister;
> +	}
> +
> +	return 0;
> +
> +unregister:
> +	mdiobus_unregister(bus);
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL(fwnode_mdiobus_register);
> +
> +/* Helper function for fwnode_phy_find_device */
> +static int fwnode_phy_match(struct device *dev, const void *phy_fwnode)
> +{
> +	return dev->fwnode == phy_fwnode;
> +}
> +
> +/**
> + * fwnode_phy_find_device - find the phy_device associated to fwnode
> + * @phy_fwnode: Pointer to the PHY's fwnode
> + *
> + * If successful, returns a pointer to the phy_device with the embedded
> + * struct device refcount incremented by one, or NULL on failure.
> + */
> +struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode)
> +{
> +	struct device *d;
> +	struct mdio_device *mdiodev;
> +
> +	if (!phy_fwnode)
> +		return NULL;
> +
> +	d = bus_find_device(&mdio_bus_type, NULL, phy_fwnode, fwnode_phy_match);
> +	if (d) {
> +		mdiodev = to_mdio_device(d);
> +		if (mdiodev->flags & MDIO_DEVICE_FLAG_PHY)
> +			return to_phy_device(d);
> +		put_device(d);
> +	}
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL(fwnode_phy_find_device);
> +
>   struct bus_type mdio_bus_type = {
>   	.name		= "mdio_bus",
>   	.match		= mdio_bus_match,
> diff --git a/include/linux/mdio.h b/include/linux/mdio.h
> index a7604248777b..5c600bb1183c 100644
> --- a/include/linux/mdio.h
> +++ b/include/linux/mdio.h
> @@ -327,6 +327,9 @@ int mdiobus_unregister_device(struct mdio_device *mdiodev);
>   bool mdiobus_is_registered_device(struct mii_bus *bus, int addr);
>   struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr);
>   
> +int fwnode_mdiobus_register(struct mii_bus *bus, struct fwnode_handle *fwnode);
> +struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode);
> +
>   /**
>    * mdio_module_driver() - Helper macro for registering mdio drivers
>    *
> 

