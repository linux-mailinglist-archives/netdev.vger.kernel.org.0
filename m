Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A283419590A
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 15:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbgC0OdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 10:33:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34100 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbgC0OdW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 10:33:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Zp1OoLvazhS4meLDNmjOyUF912Zg68lT1M9OqwGJoow=; b=ZnCfv6uQNoYQaISgKq6Dv8/UtU
        vNZzf0HJr0P52YogYg4tECAikJrUnNlw9GGW09A/tUbE+EenLWgWGEir643PqVY6HddYqnHnqlW1s
        9ooE070zcqu9zBXL6YWoUfz1jWwp6dWVNr7YtxT0jzt/benGcecFzOdPXiXJtI25VX2g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jHq2q-0002HB-Mp; Fri, 27 Mar 2020 15:33:12 +0100
Date:   Fri, 27 Mar 2020 15:33:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florinel Iordache <florinel.iordache@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 6/9] net: phy: add backplane kr driver support
Message-ID: <20200327143312.GH11004@lunn.ch>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
 <1585230682-24417-7-git-send-email-florinel.iordache@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585230682-24417-7-git-send-email-florinel.iordache@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 03:51:19PM +0200, Florinel Iordache wrote:
> Add support for backplane kr generic driver including link training
> (ieee802.3ap/ba) and fixed equalization algorithm
> 
> Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
> ---
>  drivers/net/phy/Kconfig                   |    2 +
>  drivers/net/phy/Makefile                  |    1 +
>  drivers/net/phy/backplane/Kconfig         |   20 +
>  drivers/net/phy/backplane/Makefile        |    9 +
>  drivers/net/phy/backplane/backplane.c     | 1538 +++++++++++++++++++++++++++
>  drivers/net/phy/backplane/backplane.h     |  262 +++++
>  drivers/net/phy/backplane/eq_fixed.c      |   83 ++
>  drivers/net/phy/backplane/equalization.h  |  282 +++++
>  drivers/net/phy/backplane/link_training.c | 1604 +++++++++++++++++++++++++++++
>  drivers/net/phy/backplane/link_training.h |   34 +
>  10 files changed, 3835 insertions(+)
>  create mode 100644 drivers/net/phy/backplane/Kconfig
>  create mode 100644 drivers/net/phy/backplane/Makefile
>  create mode 100644 drivers/net/phy/backplane/backplane.c
>  create mode 100644 drivers/net/phy/backplane/backplane.h
>  create mode 100644 drivers/net/phy/backplane/eq_fixed.c
>  create mode 100644 drivers/net/phy/backplane/equalization.h
>  create mode 100644 drivers/net/phy/backplane/link_training.c
>  create mode 100644 drivers/net/phy/backplane/link_training.h
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index cc7f1df..abab4e5 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -523,6 +523,8 @@ config XILINX_GMII2RGMII
>  	  the Reduced Gigabit Media Independent Interface(RGMII) between
>  	  Ethernet physical media devices and the Gigabit Ethernet controller.
>  
> +source "drivers/net/phy/backplane/Kconfig"
> +
>  endif # PHYLIB
>  
>  config MICREL_KS8995MA
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index 70774ab..0b867fb 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -101,3 +101,4 @@ obj-$(CONFIG_STE10XP)		+= ste10Xp.o
>  obj-$(CONFIG_TERANETICS_PHY)	+= teranetics.o
>  obj-$(CONFIG_VITESSE_PHY)	+= vitesse.o
>  obj-$(CONFIG_XILINX_GMII2RGMII) += xilinx_gmii2rgmii.o
> +obj-$(CONFIG_ETH_BACKPLANE)	+= backplane/
> diff --git a/drivers/net/phy/backplane/Kconfig b/drivers/net/phy/backplane/Kconfig
> new file mode 100644
> index 0000000..9ec54b5
> --- /dev/null
> +++ b/drivers/net/phy/backplane/Kconfig
> @@ -0,0 +1,20 @@
> +# SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
> +config ETH_BACKPLANE
> +	tristate "Ethernet Backplane support"
> +	depends on OF_MDIO
> +	help
> +	  This module provides driver support for Ethernet Operation over
> +	  Electrical Backplanes. It includes Backplane generic
> +	  driver including support for Link Training (IEEE802.3ap/ba).
> +	  Based on the link quality, a signal equalization is required.
> +	  The standard specifies that a start-up algorithm should be in place
> +	  in order to get the link up.
> +
> +config ETH_BACKPLANE_FIXED
> +	tristate "Fixed: No Equalization algorithm"
> +	depends on ETH_BACKPLANE
> +	help
> +	  This module provides a driver to setup fixed user configurable
> +	  coefficient values for backplanes equalization. This means
> +	  No Equalization algorithm is used to adapt the initial coefficients
> +	  initially set by the user.
> \ No newline at end of file
> diff --git a/drivers/net/phy/backplane/Makefile b/drivers/net/phy/backplane/Makefile
> new file mode 100644
> index 0000000..ded6f2d
> --- /dev/null
> +++ b/drivers/net/phy/backplane/Makefile
> @@ -0,0 +1,9 @@
> +# SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
> +#
> +# Makefile for Ethernet Backplane driver
> +#
> +
> +obj-$(CONFIG_ETH_BACKPLANE) += eth_backplane.o
> +obj-$(CONFIG_ETH_BACKPLANE_FIXED) += eq_fixed.o
> +
> +eth_backplane-objs	:= backplane.o link_training.o
> diff --git a/drivers/net/phy/backplane/backplane.c b/drivers/net/phy/backplane/backplane.c
> new file mode 100644
> index 0000000..1b580bc
> --- /dev/null
> +++ b/drivers/net/phy/backplane/backplane.c
> @@ -0,0 +1,1538 @@
> +// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
> +/* Backplane driver
> + *
> + * Copyright 2015 Freescale Semiconductor, Inc.
> + * Copyright 2018-2020 NXP
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mii.h>
> +#include <linux/mdio.h>
> +#include <linux/ethtool.h>
> +#include <linux/io.h>
> +#include <linux/of.h>
> +#include <linux/of_net.h>
> +#include <linux/of_address.h>
> +#include <linux/of_platform.h>
> +#include <linux/timer.h>
> +#include <linux/delay.h>
> +#include <linux/workqueue.h>
> +#include <linux/netdevice.h>
> +#include <linux/list.h>
> +
> +#include "backplane.h"
> +#include "link_training.h"
> +
> +/* KR timeouts in milliseconds */
> +#define KR_TIMEOUT_1				100
> +#define KR_TIMEOUT_2				1000
> +#define KR_DENY_RT_INTERVAL			3000
> +#define KR_LT_TIMEOUT				500
> +
> +/* KR timings in interations */
> +#define KR_AN_WAIT_ITERATIONS			5
> +#define KR_TRAIN_STEP_ITERATIONS		2
> +#define CDR_LOCK_RETRY_COUNT			3
> +
> +/* AN status register (Clause 45) (MMD 7): MDIO_STAT1 */
> +#define AN_LINK_UP_MASK				0x04
> +
> +/* Logging buffer size */
> +#define LOG_BUFFER_SIZE				200
> +
> +/* Backplane custom logging */
> +#define BPDEV_LOG(name) \
> +	char log_buffer[LOG_BUFFER_SIZE]; \
> +	va_list args; va_start(args, msg); \
> +	vsnprintf(log_buffer, LOG_BUFFER_SIZE - 1, msg, args); \
> +	if (!bpphy->attached_dev) \
> +		dev_##name(&bpphy->mdio.dev, log_buffer); \
> +	else \
> +		dev_##name(&bpphy->mdio.dev, "%s: %s", \
> +			netdev_name(bpphy->attached_dev), log_buffer); \
> +	va_end(args)
> +
> +/* Backplane features */
> +__ETHTOOL_DECLARE_LINK_MODE_MASK(backplane_features) __ro_after_init;
> +EXPORT_SYMBOL(backplane_features);
> +
> +const int backplane_common_features_array[] = {
> +	ETHTOOL_LINK_MODE_Backplane_BIT,
> +	ETHTOOL_LINK_MODE_Autoneg_BIT,
> +	ETHTOOL_LINK_MODE_MII_BIT,
> +};
> +
> +const int backplane_protocol_features_array[] = {
> +	ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
> +	ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
> +};
> +
> +/* map string key to pointer data */
> +struct spmap_node {
> +	struct list_head entry;
> +	const char *key;
> +	void *pdata;
> +};
> +
> +/* registered equalization algorithms info */
> +static LIST_HEAD(eqalg_list);
> +
> +/* lanes attached to an equalization algorithm */
> +static LIST_HEAD(lnalg_list);
> +
> +/* Backplane mutex between all KR PHY threads */
> +static struct mutex backplane_lock;
> +
> +static int get_backplane_speed(phy_interface_t bp_mode)
> +{
> +	switch (bp_mode) {
> +	case PHY_INTERFACE_MODE_10GKR:
> +		return SPEED_10000;
> +	case PHY_INTERFACE_MODE_40GKR4:
> +		return SPEED_40000;
> +	default:
> +		pr_err("%s: Unsupported backplane phy interface\n",
> +		       BACKPLANE_DRIVER_NAME);
> +		return SPEED_UNKNOWN;
> +	}
> +	return SPEED_UNKNOWN;
> +}
> +
> +static enum ethtool_link_mode_bit_indices
> +	get_backplane_supported_mode(phy_interface_t bp_mode)
> +{
> +	switch (bp_mode) {
> +	case PHY_INTERFACE_MODE_10GKR:
> +		return ETHTOOL_LINK_MODE_10000baseKR_Full_BIT;
> +	case PHY_INTERFACE_MODE_40GKR4:
> +		return ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT;
> +	default:
> +		pr_err("%s: Unsupported backplane phy interface\n",
> +		       BACKPLANE_DRIVER_NAME);
> +		return ETHTOOL_LINK_MODE_Backplane_BIT;
> +	}
> +	return ETHTOOL_LINK_MODE_Backplane_BIT;
> +}
> +
> +static int spmap_add(struct list_head *list, const char *key, void *pdata)
> +{
> +	struct spmap_node *node;
> +
> +	/* create a new entry with desired key */
> +	node = kzalloc(sizeof(*node), GFP_KERNEL);
> +	if (!node)
> +		return -ENOMEM;
> +
> +	node->key = key;
> +	node->pdata = pdata;
> +
> +	list_add(&node->entry, list);
> +
> +	return 0;
> +}
> +
> +static const struct equalization_algorithm *eq_find(const char *key)
> +{
> +	struct spmap_node *eqalg, *eqalg_tmp;
> +
> +	if (!key)
> +		return NULL;
> +
> +	/* search desired single key */
> +	list_for_each_entry_safe(eqalg, eqalg_tmp, &eqalg_list, entry) {
> +		if (strcmp(eqalg->key, key) == 0)
> +			return (struct equalization_algorithm *)eqalg->pdata;
> +	}
> +	return NULL;
> +}
> +
> +static void backplane_features_init(void)
> +{
> +	linkmode_set_bit_array(backplane_common_features_array,
> +			       ARRAY_SIZE(backplane_common_features_array),
> +			       backplane_features);
> +
> +	linkmode_set_bit_array(backplane_protocol_features_array,
> +			       ARRAY_SIZE(backplane_protocol_features_array),
> +			       backplane_features);
> +}
> +
> +static u32 le_ioread32(void __iomem *reg)
> +{
> +	return ioread32(reg);
> +}
> +
> +static void le_iowrite32(u32 value, void __iomem *reg)
> +{
> +	iowrite32(value, reg);
> +}
> +
> +static u32 be_ioread32(void __iomem *reg)
> +{
> +	return ioread32be(reg);
> +}
> +
> +static void be_iowrite32(u32 value, void __iomem *reg)
> +{
> +	iowrite32be(value, reg);
> +}
> +
> +static void training_status_init(struct training_status *trst)
> +{
> +	trst->done_training = false;
> +	trst->remote_tx_complete = false;
> +	trst->remote_tx_running = false;
> +	trst->sent_init = false;
> +	trst->lp_rx_ready = 0;
> +	trst->local_tx_running = false;
> +}
> +
> +static void init_krln(struct kr_lane_info *krln, bool revert_default)
> +{
> +	if (revert_default)
> +		backplane_default_kr_lane(krln);
> +
> +	training_status_init(&krln->trst);
> +	krln->state = DETECTING_LP;
> +	krln->an_acquired = false;
> +
> +	krln->ld_update = 0;
> +	krln->prev_ld_update = 0;
> +	krln->ld_last_nonhold_update = 0;
> +	krln->lp_status = 0;
> +	krln->lp_last_change_status = 0;
> +	krln->last_lp_update_status[C_M1] = 0;
> +	krln->last_lp_update_status[C_Z0] = 0;
> +	krln->last_lp_update_status[C_P1] = 0;
> +	krln->ld_status = 0;
> +	krln->move_back_prev = false;
> +	krln->move_back_cnt = 0;
> +	krln->move_back_lp_status = 0;
> +
> +	lt_init_ld(krln);
> +}
> +
> +static void setup_supported_linkmode(struct phy_device *bpphy)
> +{
> +	struct backplane_phy_info *bp_phy = bpphy->priv;
> +	int i;
> +
> +	/* Clear all supported backplane protocols features
> +	 * and setup only the currently configured protocol
> +	 */
> +	for (i = 0; i < ARRAY_SIZE(backplane_protocol_features_array); i++)
> +		linkmode_clear_bit(backplane_protocol_features_array[i],
> +				   bpphy->supported);
> +
> +	linkmode_set_bit(get_backplane_supported_mode(bp_phy->bp_mode),
> +			 bpphy->supported);
> +}
> +
> +/* Read AN Link Status */
> +static int is_an_link_up(struct phy_device *bpphy)
> +{
> +	struct backplane_phy_info *bp_phy = bpphy->priv;
> +	int ret, val = 0;
> +
> +	mutex_lock(&bp_phy->bpphy_lock);
> +
> +	/* Read twice because Link_Status is LL (Latched Low) bit */
> +	val = phy_read_mmd(bpphy, MDIO_MMD_AN, bp_phy->bp_dev.mdio.an_status);
> +	val = phy_read_mmd(bpphy, MDIO_MMD_AN, bp_phy->bp_dev.mdio.an_status);

Why not just 

val = phy_read_mmd(bpphy, MDIO_MMD_AN, MDIO_CTRL1);

Or is your hardware not actually conformant to the standard?

There has also been a lot of discussion of reading the status twice is
correct or not. Don't you care the link has briefly gone down and up
again?

	Andrew
