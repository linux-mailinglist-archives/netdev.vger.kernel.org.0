Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAF14F83D
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 22:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfFVU5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 16:57:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49410 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbfFVU5b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Jun 2019 16:57:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oePEOBUvsBrcln8QForxiWhri9yf6+IUcHaEBSsdi/w=; b=nASuRUEENw6wlYLBmrsJ5oRi9W
        pm7kmBa2z+1ftH8shG31OizOzSGC9CN6XcqbVNc1w73iqO4ttBzfbrvWOCNrmz5XCmS8hxHZI3ELj
        vA+cIJCfMw/4kUj5miKevgCE8exySXKzF7LQpaabgIFH9clP9UDjQsEnwdGftl5wGdeo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hen4a-00048d-Rp; Sat, 22 Jun 2019 22:57:20 +0200
Date:   Sat, 22 Jun 2019 22:57:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, alexandru.marginean@nxp.com,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Allan Nielsen <Allan.Nielsen@microsemi.com>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Horghidan <catalin.horghidan@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 6/6] net/mssc/ocelot: Add basic Felix switch
 driver
Message-ID: <20190622205720.GK8497@lunn.ch>
References: <1561131532-14860-1-git-send-email-claudiu.manoil@nxp.com>
 <1561131532-14860-7-git-send-email-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561131532-14860-7-git-send-email-claudiu.manoil@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 21, 2019 at 06:38:52PM +0300, Claudiu Manoil wrote:
> This supports a switch core ethernet device from Microsemi
> (VSC9959) that can be integrated on different SoCs as a PCIe
> endpoint device.
> 
> The switchdev functionality is provided by the core Ocelot
> switch driver. In this regard, the current driver is an
> instance of Microsemi's Ocelot core driver.
> 
> The patch adds the PCI device driver part and defines the
> register map for the Felix switch core, as it has some
> differences in register addresses and bitfield mappings
> compared to the Ocelot switch.  Also some registers or
> bitfields present on Ocelot are not available on Felix.
> That's why this driver has its own register map instance.
> Other than that, the common registers and bitfields have the
> same functionality and share the same name.
> 
> In a few cases, some h/w operations have to be done differently
> on Felix due to missing bitfields.  This is the case for the
> switch core reset and init.  Because for this operation Ocelot
> uses some bits that are not present on Felix, the later has to
> use a register from the global registers block (GCB) instead.
> 
> Signed-off-by: Catalin Horghidan <catalin.horghidan@gmail.com>
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> ---
>  drivers/net/ethernet/mscc/Kconfig       |   8 +
>  drivers/net/ethernet/mscc/Makefile      |   9 +-
>  drivers/net/ethernet/mscc/felix_board.c | 392 +++++++++++++++++++++
>  drivers/net/ethernet/mscc/felix_regs.c  | 448 ++++++++++++++++++++++++
>  drivers/net/ethernet/mscc/ocelot.h      |   7 +
>  5 files changed, 862 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/net/ethernet/mscc/felix_board.c
>  create mode 100644 drivers/net/ethernet/mscc/felix_regs.c
> 
> diff --git a/drivers/net/ethernet/mscc/Kconfig b/drivers/net/ethernet/mscc/Kconfig
> index bcec0587cf61..e5a7fa69307e 100644
> --- a/drivers/net/ethernet/mscc/Kconfig
> +++ b/drivers/net/ethernet/mscc/Kconfig
> @@ -29,4 +29,12 @@ config MSCC_OCELOT_SWITCH_OCELOT
>  	  This driver supports the Ocelot network switch device as present on
>  	  the Ocelot SoCs.
>  
> +config MSCC_FELIX_SWITCH
> +	tristate "Felix switch driver"
> +	depends on MSCC_OCELOT_SWITCH
> +	depends on PCI
> +	help
> +	  This driver supports the Felix network switch device, connected as a
> +	  PCI device.
> +
>  endif # NET_VENDOR_MICROSEMI
> diff --git a/drivers/net/ethernet/mscc/Makefile b/drivers/net/ethernet/mscc/Makefile
> index 9a36c26095c8..81593feb2ea1 100644
> --- a/drivers/net/ethernet/mscc/Makefile
> +++ b/drivers/net/ethernet/mscc/Makefile
> @@ -1,5 +1,10 @@
>  # SPDX-License-Identifier: (GPL-2.0 OR MIT)
>  obj-$(CONFIG_MSCC_OCELOT_SWITCH) += mscc_ocelot_common.o
>  mscc_ocelot_common-y := ocelot.o ocelot_io.o
> -mscc_ocelot_common-y += ocelot_regs.o ocelot_tc.o ocelot_police.o ocelot_ace.o ocelot_flower.o
> -obj-$(CONFIG_MSCC_OCELOT_SWITCH_OCELOT) += ocelot_board.o
> +mscc_ocelot_common-y += ocelot_tc.o ocelot_police.o ocelot_ace.o ocelot_flower.o
> +
> +obj-$(CONFIG_MSCC_OCELOT_SWITCH_OCELOT) += mscc_ocelot.o
> +mscc_ocelot-$(CONFIG_MSCC_OCELOT_SWITCH_OCELOT) := ocelot_regs.o ocelot_board.o
> +
> +obj-$(CONFIG_MSCC_FELIX_SWITCH) += mscc_felix.o
> +mscc_felix-$(CONFIG_MSCC_FELIX_SWITCH) := felix_regs.o felix_board.o
> diff --git a/drivers/net/ethernet/mscc/felix_board.c b/drivers/net/ethernet/mscc/felix_board.c
> new file mode 100644
> index 000000000000..57f7a897b3ae
> --- /dev/null
> +++ b/drivers/net/ethernet/mscc/felix_board.c
> @@ -0,0 +1,392 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +/* Felix Switch driver
> + *
> + * Copyright 2018-2019 NXP
> + */
> +
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/netdevice.h>
> +#include <linux/phy_fixed.h>
> +#include <linux/phy.h>
> +#include <linux/of_mdio.h>
> +#include <linux/of_net.h>
> +#include <linux/iopoll.h>
> +#include <net/switchdev.h>
> +#include "ocelot.h"
> +
> +#define FELIX_DRV_VER_MAJ 1
> +#define FELIX_DRV_VER_MIN 0
> +
> +#define FELIX_DRV_STR	"Felix Switch driver"
> +#define FELIX_DRV_VER_STR __stringify(FELIX_DRV_VER_MAJ) "." \
> +			  __stringify(FELIX_DRV_VER_MIN)

Driver version strings are pretty pointless. What you really want to
know if the specific kernel version.

> +
> +#define FELIX_PORT_RES_START	0x0100000
> +#define FELIX_PORT_RES_SIZE	0x10000

This should really be in device tree. You then get a lot closer to the
binding for mscc-ocelot, and you can reuse more of its code.

> +static void felix_release_ports(struct ocelot *ocelot)
> +{
> +	struct ocelot_port *ocelot_port;
> +	struct phy_device *phydev;
> +	struct device_node *dn;
> +	int i;
> +
> +	for (i = 0; i < ocelot->num_phys_ports; i++) {
> +		ocelot_port = ocelot->ports[i];
> +		if (!ocelot_port || !ocelot_port->phy || !ocelot_port->dev)
> +			continue;

Phys are often optional, e.g. an RGMII interface to another switch, or
an SFP port.

> +
> +		phydev = ocelot_port->phy;
> +		unregister_netdev(ocelot_port->dev);
> +		free_netdev(ocelot_port->dev);
> +
> +		if (phy_is_pseudo_fixed_link(phydev)) {
> +			dn = phydev->mdio.dev.of_node;
> +			/* decr refcnt: of_phy_register_fixed_link */
> +			of_phy_deregister_fixed_link(dn);
> +		}
> +		phy_device_free(phydev); /* decr refcnt: of_phy_find_device */

To be on the safe side, you should probably not free the netdev until
you free the phydev.

This function also seems pretty generic. Should it be shared?

> +static int felix_ports_init(struct pci_dev *pdev)
> +{
> +	struct ocelot *ocelot = pci_get_drvdata(pdev);
> +	struct device_node *np = ocelot->dev->of_node;
> +	struct device_node *phy_node, *portnp;
> +	struct phy_device *phydev;
> +	void __iomem *port_regs;
> +	resource_size_t base;
> +	u32 port;
> +	int err;
> +
> +	ocelot->num_phys_ports = FELIX_MAX_NUM_PHY_PORTS;
> +
> +	np = of_get_child_by_name(np, "ethernet-ports");
> +	if (!np) {
> +		dev_err(&pdev->dev, "ethernet-ports sub-node not found\n");
> +		return -ENODEV;
> +	}
> +
> +	/* alloc netdev for each port */
> +	err = ocelot_init(ocelot);
> +	if (err)
> +		return err;
> +
> +	base = pci_resource_start(pdev, FELIX_SWITCH_BAR);
> +	for_each_available_child_of_node(np, portnp) {
> +		struct resource res = {};
> +		int phy_mode;
> +
> +		if (!portnp || !portnp->name ||
> +		    of_node_cmp(portnp->name, "port") ||

The name of the node should not matter.

> +static int felix_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> +
> +	register_netdevice_notifier(&ocelot_netdevice_nb);
> +	register_switchdev_notifier(&ocelot_switchdev_nb);
> +	register_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);

This is also shared. So maybe move it into a common function?

> +
> +	dev_info(&pdev->dev, "%s v%s\n", FELIX_DRV_STR, FELIX_DRV_VER_STR);
> +	return 0;
> +
> +err_ports_init:
> +err_chip_init:
> +err_sw_core_init:
> +	pci_iounmap(pdev, regs);
> +err_iomap:
> +err_resource_len:
> +err_alloc_ocelot:
> +err_dma:
> +	pci_disable_device(pdev);
> +
> +	return err;
> +}
> +
> +static void felix_pci_remove(struct pci_dev *pdev)
> +{
> +	struct ocelot *ocelot;
> +
> +	ocelot = pci_get_drvdata(pdev);
> +
> +	/* stop workqueue thread */
> +	ocelot_deinit(ocelot);
> +	unregister_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);
> +	unregister_switchdev_notifier(&ocelot_switchdev_nb);
> +	unregister_netdevice_notifier(&ocelot_netdevice_nb);

This is also common.

     Andrew
