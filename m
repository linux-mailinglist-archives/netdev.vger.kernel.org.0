Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE2F52B0A6
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 05:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbiERDNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 23:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiERDNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 23:13:06 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FD75621D
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 20:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TbUafIfXptqfV/Yu72Ku9MAqnJOFsX4rkpBtae2isqY=; b=VnPFPIQnW6ENVl5Osg2QW8iwfh
        JJzya9cKfIHt+vWPclVvKZ2b0QLJo1ZCaeMHFQYXM0vFsm+wW91KYICiHC8BGy4VDDq1LNnWqO1hw
        5b/EaWNKiRmTwwvTCuD5KhM/O3HjGtVtpJfQdj+dB7yLGoEQv6MiDp1Z+cimQ2k3iXYo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nrA7M-003FWX-8h; Wed, 18 May 2022 05:12:56 +0200
Date:   Wed, 18 May 2022 05:12:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: txgbe: Add build support for txgbe
Message-ID: <YoRkONdJlIU0ymd6@lunn.ch>
References: <20220517092109.8161-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517092109.8161-1-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +Support
> +=======
> +If you got any problem, contact Wangxun support team via support@trustnetic.com

Since this is now a mainline driver, you should be doing support out
in the open. So indicate your should also Cc: netdev, so other members
of the networking community using this hardware can learn as well from
peoples questions.

> +config TXGBE
> +	tristate "Wangxun(R) 10GbE PCI Express adapters support"
> +	depends on PCI
> +	depends on PTP_1588_CLOCK_OPTIONAL
> +	select PHYLIB

The current driver does not depend on PTP nor need PHYLIB. Please add
these when they are actually needed.

> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
> @@ -0,0 +1,76 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (c) 2015 - 2017 Beijing WangXun Technology Co., Ltd. */
> +
> +#ifndef _TXGBE_H_
> +#define _TXGBE_H_
> +
> +#include "txgbe_type.h"
> +
> +#ifndef MAX_REQUEST_SIZE
> +#define MAX_REQUEST_SIZE 256
> +#endif

Why the #ifndef? What could be setting it?

A TXGBE_ prefix would also be good.

> +
> +#define TXGBE_MAX_FDIR_INDICES          63
> +
> +#define MAX_TX_QUEUES   (TXGBE_MAX_FDIR_INDICES + 1)

Prefix here as well.

> +
> +/* board specific private data structure */
> +struct txgbe_adapter {
> +	/* OS defined structs */
> +	struct net_device *netdev;
> +	struct pci_dev *pdev;
> +
> +	unsigned long state;
> +
> +	/* structs defined in txgbe_hw.h */
> +	struct txgbe_hw hw;
> +	u16 msg_enable;
> +
> +	u8 __iomem *io_addr;    /* Mainly for iounmap use */
> +};
> +
> +enum txgbe_state_t {
> +	__TXGBE_TESTING,
> +	__TXGBE_RESETTING,
> +	__TXGBE_DOWN,
> +	__TXGBE_HANGING,
> +	__TXGBE_DISABLED,
> +	__TXGBE_REMOVING,
> +	__TXGBE_SERVICE_SCHED,
> +	__TXGBE_SERVICE_INITED,
> +	__TXGBE_IN_SFP_INIT,
> +	__TXGBE_PTP_RUNNING,
> +	__TXGBE_PTP_TX_IN_PROGRESS,
> +};
> +
> +#define TXGBE_NAME "txgbe"
> +
> +static inline struct device *pci_dev_to_dev(struct pci_dev *pdev)
> +{
> +	return &pdev->dev;
> +}

Does not have any value. &pdev->dev; is shorter than
pci_dev_to_dev(pdev), there are no casts here, etc.

> +#define txgbe_dev_info(format, arg...) \
> +	dev_info(&adapter->pdev->dev, format, ## arg)
> +#define txgbe_dev_warn(format, arg...) \
> +	dev_warn(&adapter->pdev->dev, format, ## arg)
> +#define txgbe_dev_err(format, arg...) \
> +	dev_err(&adapter->pdev->dev, format, ## arg)
> +#define txgbe_dev_notice(format, arg...) \
> +	dev_notice(&adapter->pdev->dev, format, ## arg)
> +#define txgbe_dbg(msglvl, format, arg...) \
> +	netif_dbg(adapter, msglvl, adapter->netdev, format, ## arg)
> +#define txgbe_info(msglvl, format, arg...) \
> +	netif_info(adapter, msglvl, adapter->netdev, format, ## arg)
> +#define txgbe_err(msglvl, format, arg...) \
> +	netif_err(adapter, msglvl, adapter->netdev, format, ## arg)
> +#define txgbe_warn(msglvl, format, arg...) \
> +	netif_warn(adapter, msglvl, adapter->netdev, format, ## arg)
> +#define txgbe_crit(msglvl, format, arg...) \
> +	netif_crit(adapter, msglvl, adapter->netdev, format, ## arg)

It is pretty unusual to use wrappers like this. It is also bad
practice for a macro to access something which is not passed to it as
a parameter. I suggest you remove all these.

> +
> +#define TXGBE_FAILED_READ_CFG_DWORD 0xffffffffU
> +#define TXGBE_FAILED_READ_CFG_WORD  0xffffU
> +#define TXGBE_FAILED_READ_CFG_BYTE  0xffU
> +
> +#endif /* _TXGBE_H_ */
> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> new file mode 100644
> index 000000000000..17a30629f76a
> --- /dev/null
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> @@ -0,0 +1,332 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2015 - 2017 Beijing WangXun Technology Co., Ltd. */
> +
> +#include <linux/types.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/netdevice.h>
> +#include <linux/string.h>
> +#include <linux/aer.h>
> +#include <linux/etherdevice.h>
> +
> +#include "txgbe.h"
> +
> +char txgbe_driver_name[32] = TXGBE_NAME;
> +static const char txgbe_driver_string[] =
> +			"WangXun 10 Gigabit PCI Express Network Driver";
> +
> +static const char txgbe_copyright[] =
> +	"Copyright (c) 2015 -2017 Beijing WangXun Technology Co., Ltd";

Only until 2017? You don't need this anyway, you have the copyright on
the top of each file.

> +
> +/* txgbe_pci_tbl - PCI Device ID Table
> + *
> + * Wildcard entries (PCI_ANY_ID) should come last
> + * Last entry must be all 0s
> + *
> + * { Vendor ID, Device ID, SubVendor ID, SubDevice ID,
> + *   Class, Class Mask, private data (not used) }
> + */
> +static const struct pci_device_id txgbe_pci_tbl[] = {
> +	{ PCI_VDEVICE(TRUSTNETIC, TXGBE_DEV_ID_SP1000), 0},
> +	{ PCI_VDEVICE(TRUSTNETIC, TXGBE_DEV_ID_WX1820), 0},
> +	/* required last entry */
> +	{ .device = 0 }
> +};
> +MODULE_DEVICE_TABLE(pci, txgbe_pci_tbl);
> +
> +MODULE_AUTHOR("Beijing WangXun Technology Co., Ltd, <software@trustnetic.com>");
> +MODULE_DESCRIPTION("WangXun(R) 10 Gigabit PCI Express Network Driver");
> +MODULE_LICENSE("GPL");

Traditionally, all MODULE_* things come at the end. 

> +#define DEFAULT_DEBUG_LEVEL_SHIFT 3
> +
> +static struct workqueue_struct *txgbe_wq;

No globals. 

> +
> +static bool txgbe_check_cfg_remove(struct txgbe_hw *hw, struct pci_dev *pdev);

Forwards references should only be needed if you have mutually
recursive functions. For anything else, move the code around to avoid
them.

> +
> +static void txgbe_remove_adapter(struct txgbe_hw *hw)
> +{
> +	struct txgbe_adapter *adapter = hw->back;
> +
> +	if (!hw->hw_addr)
> +		return;
> +	hw->hw_addr = NULL;
> +	txgbe_dev_err("Adapter removed\n");

It is not an error, modules can be unloaded, drivers unbound etc.

> +}
> +
> +/**
> + * txgbe_sw_init - Initialize general software structures (struct txgbe_adapter)
> + * @adapter: board private structure to initialize
> + *
> + * txgbe_sw_init initializes the Adapter private data structure.
> + * Fields are initialized based on PCI device information and
> + * OS network device settings (MTU size).
> + **/
> +static int txgbe_sw_init(struct txgbe_adapter *adapter)
> +{
> +	struct txgbe_hw *hw = &adapter->hw;
> +	struct pci_dev *pdev = adapter->pdev;
> +	int err = 0;
> +
> +	/* PCI config space info */
> +	hw->vendor_id = pdev->vendor;
> +	hw->device_id = pdev->device;
> +	pci_read_config_byte(pdev, PCI_REVISION_ID, &hw->revision_id);
> +	if (hw->revision_id == TXGBE_FAILED_READ_CFG_BYTE &&
> +	    txgbe_check_cfg_remove(hw, pdev)) {
> +		txgbe_err(probe, "read of revision id failed\n");
> +		err = -ENODEV;
> +		goto out;

goto out is used when you have something to cleanup on error. If there
is no cleanup needed, just return -ENODEV.

> +	}
> +	hw->subsystem_vendor_id = pdev->subsystem_vendor;
> +	hw->subsystem_device_id = pdev->subsystem_device;
> +
> +	pci_read_config_word(pdev, PCI_SUBSYSTEM_ID, &hw->subsystem_id);
> +	if (hw->subsystem_id == TXGBE_FAILED_READ_CFG_WORD) {
> +		txgbe_err(probe, "read of subsystem id failed\n");
> +		err = -ENODEV;
> +		goto out;

And this goto is pointless.

> +	}
> +
> +out:
> +	return err;
> +}
> +
> +static int __txgbe_shutdown(struct pci_dev *pdev, bool *enable_wake)

Please avoid __foo, unless you already have a _foo. And if you do have
foo, _foo and __foo, you should probably think about better names.

> +{
> +	struct txgbe_adapter *adapter = pci_get_drvdata(pdev);
> +	struct net_device *netdev = adapter->netdev;
> +
> +	netif_device_detach(netdev);
> +
> +	if (!test_and_set_bit(__TXGBE_DISABLED, &adapter->state))
> +		pci_disable_device(pdev);
> +
> +	return 0;

Looks like this should be a void function.


> +}
> +
> +static void txgbe_shutdown(struct pci_dev *pdev)
> +{
> +	bool wake;
> +
> +	__txgbe_shutdown(pdev, &wake);
> +
> +	if (system_state == SYSTEM_POWER_OFF) {
> +		pci_wake_from_d3(pdev, wake);
> +		pci_set_power_state(pdev, PCI_D3hot);
> +	}
> +}
> +
> +/**
> + * txgbe_probe - Device Initialization Routine
> + * @pdev: PCI device information struct
> + * @ent: entry in txgbe_pci_tbl
> + *
> + * Returns 0 on success, negative on failure
> + *
> + * txgbe_probe initializes an adapter identified by a pci_dev structure.
> + * The OS initialization, configuring of the adapter private structure,
> + * and a hardware reset occur.
> + **/
> +static int txgbe_probe(struct pci_dev *pdev,
> +		       const struct pci_device_id __always_unused *ent)
> +{
> +	struct net_device *netdev;
> +	struct txgbe_adapter *adapter = NULL;
> +	struct txgbe_hw *hw = NULL;
> +	int err, pci_using_dac;
> +	unsigned int indices = MAX_TX_QUEUES;
> +	bool disable_dev = false;

Reverse christmas tree. That is, sort these lines longest to shortest.

> +
> +	err = pci_enable_device_mem(pdev);
> +	if (err)
> +		return err;
> +
> +	if (!dma_set_mask(pci_dev_to_dev(pdev), DMA_BIT_MASK(64)) &&
> +	    !dma_set_coherent_mask(pci_dev_to_dev(pdev), DMA_BIT_MASK(64))) {
> +		pci_using_dac = 1;
> +	} else {
> +		err = dma_set_mask(pci_dev_to_dev(pdev), DMA_BIT_MASK(32));
> +		if (err) {
> +			err = dma_set_coherent_mask(pci_dev_to_dev(pdev),
> +						    DMA_BIT_MASK(32));
> +			if (err) {
> +				dev_err(pci_dev_to_dev(pdev),
> +					"No usable DMA configuration, aborting\n");
> +				goto err_dma;
> +			}
> +		}
> +		pci_using_dac = 0;
> +	}
> +
> +	err = pci_request_selected_regions(pdev,
> +					   pci_select_bars(pdev, IORESOURCE_MEM),
> +					   txgbe_driver_name);
> +	if (err) {
> +		dev_err(pci_dev_to_dev(pdev),
> +			"pci_request_selected_regions failed 0x%x\n", err);
> +		goto err_pci_reg;
> +	}
> +
> +	hw = vmalloc(sizeof(*hw));

Why vmalloc? Is *hw very big? 

> +	if (!hw)
> +		return -ENOMEM;

This should probably by a goto, to unwind what you have done above.

> +
> +	hw->vendor_id = pdev->vendor;
> +	hw->device_id = pdev->device;
> +	vfree(hw);

??? You just allocated it?

> +	pci_enable_pcie_error_reporting(pdev);
> +	pci_set_master(pdev);
> +	/* errata 16 */
> +	if (MAX_REQUEST_SIZE == 512) {

So this probably has something to do with my question above. Please
explain.

> +		pcie_capability_clear_and_set_word(pdev, PCI_EXP_DEVCTL,
> +						   PCI_EXP_DEVCTL_READRQ,
> +						   0x2000);
> +	} else {
> +		pcie_capability_clear_and_set_word(pdev, PCI_EXP_DEVCTL,
> +						   PCI_EXP_DEVCTL_READRQ,
> +						   0x1000);
> +	}
> +
> +	netdev = alloc_etherdev_mq(sizeof(struct txgbe_adapter), indices);

devm_alloc_etherdev_mqs(). Using devm makes your cleanup code simpler
and so less buggy.

> +	if (!netdev) {
> +		err = -ENOMEM;
> +		goto err_alloc_etherdev;
> +	}
> +
> +	SET_NETDEV_DEV(netdev, pci_dev_to_dev(pdev));
> +
> +	adapter = netdev_priv(netdev);
> +	adapter->netdev = netdev;
> +	adapter->pdev = pdev;
> +	hw = &adapter->hw;
> +	hw->back = adapter;

You should not need this. container_of() will get you from hw to adapter.

> +	adapter->msg_enable = (1 << DEFAULT_DEBUG_LEVEL_SHIFT) - 1;
> +
> +	hw->hw_addr = ioremap(pci_resource_start(pdev, 0),
> +			      pci_resource_len(pdev, 0));

devm_ioremap()

> +	adapter->io_addr = hw->hw_addr;

Suggests you don't actually have a clean separation. So why have hw?

> +	if (!hw->hw_addr) {
> +		err = -EIO;
> +		goto err_ioremap;
> +	}
> +
> +	strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);

The device gets a name when you register it. It is very unusual to do
this. It needs an explanation.

> +
> +	/* setup the private structure */
> +	err = txgbe_sw_init(adapter);
> +	if (err)
> +		goto err_sw_init;
> +
> +	if (pci_using_dac)
> +		netdev->features |= NETIF_F_HIGHDMA;

There should probably be a return 0; here, so the probe is
successful. Without that, you cannot test the remove function.

> +
> +err_sw_init:
> +	iounmap(adapter->io_addr);
> +err_ioremap:
> +	disable_dev = !test_and_set_bit(__TXGBE_DISABLED, &adapter->state);
> +	free_netdev(netdev);
> +err_alloc_etherdev:
> +	pci_release_selected_regions(pdev,
> +				     pci_select_bars(pdev, IORESOURCE_MEM));
> +err_pci_reg:
> +err_dma:
> +	if (!adapter || disable_dev)
> +		pci_disable_device(pdev);

Having an if in unwind code like this is very unusual. Is it really
needed?

> +	return err;
> +}
> +
> +/**
> + * txgbe_remove - Device Removal Routine
> + * @pdev: PCI device information struct
> + *
> + * txgbe_remove is called by the PCI subsystem to alert the driver
> + * that it should release a PCI device.  The could be caused by a
> + * Hot-Plug event, or because the driver is going to be removed from
> + * memory.
> + **/
> +static void txgbe_remove(struct pci_dev *pdev)
> +{
> +	struct txgbe_adapter *adapter = pci_get_drvdata(pdev);
> +	struct net_device *netdev;
> +	bool disable_dev;
> +
> +	/* if !adapter then we already cleaned up in probe */
> +	if (!adapter)
> +		return;

Remove is only called if the probe was success. So adapter is valid,
no test needed.

> +	netdev = adapter->netdev;
> +
> +	iounmap(adapter->io_addr);
> +	pci_release_selected_regions(pdev,
> +				     pci_select_bars(pdev, IORESOURCE_MEM));
> +
> +	disable_dev = !test_and_set_bit(__TXGBE_DISABLED, &adapter->state);
> +	free_netdev(netdev);
> +
> +	pci_disable_pcie_error_reporting(pdev);
> +
> +	if (disable_dev)
> +		pci_disable_device(pdev);

And this test is probably not needed.

> +}
> +
> +static bool txgbe_check_cfg_remove(struct txgbe_hw *hw, struct pci_dev *pdev)
> +{
> +	u16 value;
> +
> +	pci_read_config_word(pdev, PCI_VENDOR_ID, &value);
> +	if (value == TXGBE_FAILED_READ_CFG_WORD) {
> +		txgbe_remove_adapter(hw);
> +		return true;
> +	}
> +	return false;

This needs a comment to explain what is happening here, because it is
not clear to me.


> +}
> +
> +static struct pci_driver txgbe_driver = {
> +	.name     = txgbe_driver_name,
> +	.id_table = txgbe_pci_tbl,
> +	.probe    = txgbe_probe,
> +	.remove   = txgbe_remove,
> +	.shutdown = txgbe_shutdown,
> +};
> +
> +/**
> + * txgbe_init_module - Driver Registration Routine
> + *
> + * txgbe_init_module is the first routine called when the driver is
> + * loaded. All it does is register with the PCI subsystem.
> + **/
> +static int __init txgbe_init_module(void)
> +{
> +	int ret;
> +
> +	pr_info("%s\n", txgbe_driver_string);
> +	pr_info("%s\n", txgbe_copyright);

Don't spam the kernel log with useless information.

> +
> +	txgbe_wq = create_singlethread_workqueue(txgbe_driver_name);
> +	if (!txgbe_wq) {
> +		pr_err("%s: Failed to create workqueue\n", txgbe_driver_name);
> +		return -ENOMEM;
> +	}

Why do you need a global work queue? I suggest you start with a plain
PCI device, no __init and __exit functions. You can add this work
queue along with the code which uses it. It will then be clear why it
is needed.

> +/* Little Endian defines */
> +#ifndef __le16
> +#define __le16  u16
> +#endif
> +#ifndef __le32
> +#define __le32  u32
> +#endif
> +#ifndef __le64
> +#define __le64  u64
> +
> +#endif
> +#ifndef __be16
> +/* Big Endian defines */
> +#define __be16  u16
> +#define __be32  u32
> +#define __be64  u64

The kernel provides these. No need for your own.

