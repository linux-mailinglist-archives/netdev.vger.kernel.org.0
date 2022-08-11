Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5C558F5A2
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 03:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbiHKBzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 21:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiHKBzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 21:55:38 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B999B2A43E
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 18:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TZKEypgVKuy8+rI+4m1UHVBBm6DwPHgM6483/el5fyw=; b=w6pdbMTEfId9z0FMGkMT1UlyjP
        lL1G6hyFsyTtoGeAkz0ESgKHJ/N74rnrOVFkRQgH/RP8J7H5wLLz8NPDovQJTr4Etn6+37W3loWft
        kdLb+aCD79VSD10CF616wiXCG+uIT/13XIQO3e6l3qzM+ks9ZiKLLoAz5RQ1yVLURmcw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oLxQ5-00Cz8n-Ah; Thu, 11 Aug 2022 03:55:33 +0200
Date:   Thu, 11 Aug 2022 03:55:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 01/16] net: txgbe: Store PCI info
Message-ID: <YvRhld5rD/xgITEg@lunn.ch>
References: <20220810085532.246613-1-jiawenwu@trustnetic.com>
 <20220810085532.246613-2-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810085532.246613-2-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/**
> + *  txgbe_set_lan_id_multi_port_pcie - Set LAN id for PCIe multiple port devices
> + *  @hw: pointer to the HW structure
> + *
> + *  Determines the LAN function id by reading memory-mapped registers
> + *  and swaps the port value if requested.
> + **/
> +s32 txgbe_set_lan_id_multi_port_pcie(struct txgbe_hw *hw)
> +{
> +	struct txgbe_bus_info *bus = &hw->bus;
> +	u32 reg;
> +
> +	reg = rd32(hw, TXGBE_CFG_PORT_ST);
> +	bus->lan_id = TXGBE_CFG_PORT_ST_LAN_ID(reg);
> +
> +	/* check for a port swap */
> +	reg = rd32(hw, TXGBE_MIS_PWR);
> +	if (TXGBE_MIS_PWR_LAN_ID(reg) == TXGBE_MIS_PWR_LAN_ID_1)
> +		bus->func = 0;
> +	else
> +		bus->func = bus->lan_id;
> +
> +	return 0;

If there is nothing useful to return, and there is nothing which can
go wrong, make functions void.

> +}
> +
> +/* cmd_addr is used for some special command:
> + * 1. to be sector address, when implemented erase sector command
> + * 2. to be flash address when implemented read, write flash address
> + */
> +u8 fmgr_cmd_op(struct txgbe_hw *hw, u32 cmd, u32 cmd_addr)
> +{
> +	u32 cmd_val = 0;
> +	u32 time_out = 0;
> +
> +	cmd_val = (cmd << SPI_CLK_CMD_OFFSET) |
> +		  (SPI_CLK_DIV << SPI_CLK_DIV_OFFSET) | cmd_addr;
> +	wr32(hw, SPI_H_CMD_REG_ADDR, cmd_val);
> +	while (1) {
> +		if (rd32(hw, SPI_H_STA_REG_ADDR) & 0x1)
> +			break;
> +
> +		if (time_out == SPI_TIME_OUT_VALUE)
> +			return 1;
> +
> +		time_out = time_out + 1;
> +		usleep_range(10, 20);
> +	}

Please use iopoll.h for code which looks like this.

> +
> +	return 0;

Don't use 0 or 1 as return values. Return -ETIMEDOUT on error, since
you want that error code to be returned to user space.

> +}
> +
> +u32 txgbe_flash_read_dword(struct txgbe_hw *hw, u32 addr)
> +{
> +	u8 status = fmgr_cmd_op(hw, SPI_CMD_READ_DWORD, addr);
> +
> +	if (status)
> +		return (u32)status;

Avoid casts where ever possible. Casts like this suggest your API
design is wrong between your helpers.

> +
> +	return rd32(hw, SPI_H_DAT_REG_ADDR);
> +}

How is the caller of this function meant to decide if the flash
contained 0x1, or the read timed out?

> +int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit)
> +{
> +	u32 i = 0, reg = 0;
> +	int err = 0;
> +
> +	/* if there's flash existing */
> +	if (!(rd32(hw, TXGBE_SPI_STATUS) &
> +	      TXGBE_SPI_STATUS_FLASH_BYPASS)) {
> +		/* wait hw load flash done */
> +		for (i = 0; i < TXGBE_MAX_FLASH_LOAD_POLL_TIME; i++) {
> +			reg = rd32(hw, TXGBE_SPI_ILDR_STATUS);
> +			if (!(reg & check_bit)) {
> +				/* done */
> +				break;
> +			}
> +			msleep(200);
> +		}
> +		if (i == TXGBE_MAX_FLASH_LOAD_POLL_TIME)
> +			err = TXGBE_ERR_FLASH_LOADING_FAILED;

Use standard error codes, ETIMEDOUT.

> +/**
> + * txgbe_enumerate_functions - Get the number of ports this device has
> + * @adapter: adapter structure
> + *
> + * This function enumerates the phsyical functions co-located on a single slot,
> + * in order to determine how many ports a device has. This is most useful in
> + * determining the required GT/s of PCIe bandwidth necessary for optimal
> + * performance.
> + **/
> +static inline int txgbe_enumerate_functions(struct txgbe_adapter *adapter)

No inline functions. Let the compiler decide.

> +{
> +	struct pci_dev *entry, *pdev = adapter->pdev;
> +	int physfns = 0;
> +
> +	list_for_each_entry(entry, &pdev->bus->devices, bus_list) {
> +		/* When the devices on the bus don't all match our device ID,
> +		 * we can't reliably determine the correct number of
> +		 * functions. This can occur if a function has been direct
> +		 * attached to a virtual machine using VT-d, for example. In
> +		 * this case, simply return -1 to indicate this.
> +		 */
> +		if (entry->vendor != pdev->vendor ||
> +		    entry->device != pdev->device)
> +			return -1;

EINVAL? ENODEV?

> + *  txgbe_init_shared_code - Initialize the shared code
> + *  @hw: pointer to hardware structure
> + *
> + *  This will assign function pointers and assign the MAC type and PHY code.
> + **/
> +s32 txgbe_init_shared_code(struct txgbe_hw *hw)
> +{
> +	s32 status;
> +
> +	status = txgbe_init_ops(hw);
> +	return status;

just

	return txgbe_init_ops(hw);

> +}
> +
> +/**
> + * txgbe_sw_init - Initialize general software structures (struct txgbe_adapter)
> + * @adapter: board private structure to initialize
> + **/
> +static int txgbe_sw_init(struct txgbe_adapter *adapter)
> +{
> +	struct pci_dev *pdev = adapter->pdev;
> +	struct txgbe_hw *hw = &adapter->hw;
> +	u32 ssid = 0;
> +	int err = 0;
> +
> +	/* PCI config space info */
> +	hw->vendor_id = pdev->vendor;
> +	hw->device_id = pdev->device;
> +	hw->revision_id = pdev->revision;
> +	hw->oem_svid = pdev->subsystem_vendor;
> +	hw->oem_ssid = pdev->subsystem_device;
> +
> +	if (hw->oem_svid == PCI_VENDOR_ID_WANGXUN) {
> +		hw->subsystem_vendor_id = pdev->subsystem_vendor;
> +		hw->subsystem_device_id = pdev->subsystem_device;
> +	} else {
> +		ssid = txgbe_flash_read_dword(hw, 0xfffdc);
> +		if (ssid == 0x1) {

This is where you cannot differentiate between a timeout and a FLASH
containing 0x1.

> +			netif_err(adapter, probe, adapter->netdev,
> +				  "read of internal subsystem device id failed\n");
> +			return -ENODEV;
> +		}
> +		hw->subsystem_device_id = (u16)ssid >> 8 | (u16)ssid << 8;
> +	}
> +
> +	err = txgbe_init_shared_code(hw);
> +	if (err) {
> +		netif_err(adapter, probe, adapter->netdev,
> +			  "init_shared_code failed: %d\n", err);
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
>  static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
>  {
>  	struct txgbe_adapter *adapter = pci_get_drvdata(pdev);
> @@ -67,8 +192,9 @@ static int txgbe_probe(struct pci_dev *pdev,
>  		       const struct pci_device_id __always_unused *ent)
>  {
>  	struct txgbe_adapter *adapter = NULL;
> +	struct txgbe_hw *hw = NULL;
>  	struct net_device *netdev;
> -	int err;
> +	int err, expected_gts;
>  
>  	err = pci_enable_device_mem(pdev);
>  	if (err)
> @@ -107,6 +233,8 @@ static int txgbe_probe(struct pci_dev *pdev,
>  	adapter = netdev_priv(netdev);
>  	adapter->netdev = netdev;
>  	adapter->pdev = pdev;
> +	hw = &adapter->hw;
> +	adapter->msg_enable = (1 << DEFAULT_DEBUG_LEVEL_SHIFT) - 1;
>  
>  	adapter->io_addr = devm_ioremap(&pdev->dev,
>  					pci_resource_start(pdev, 0),
> @@ -115,11 +243,44 @@ static int txgbe_probe(struct pci_dev *pdev,
>  		err = -EIO;
>  		goto err_pci_release_regions;
>  	}
> +	hw->hw_addr = adapter->io_addr;
> +
> +	strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);
> +
> +	/* setup the private structure */
> +	err = txgbe_sw_init(adapter);
> +	if (err)
> +		goto err_pci_release_regions;
> +
> +	TCALL(hw, mac.ops.set_lan_id);

Don't use macros like this.

> +
> +	/* check if flash load is done after hw power up */
> +	err = txgbe_check_flash_load(hw, TXGBE_SPI_ILDR_STATUS_PERST);
> +	if (err)
> +		goto err_pci_release_regions;
> +	err = txgbe_check_flash_load(hw, TXGBE_SPI_ILDR_STATUS_PWRRST);
> +	if (err)
> +		goto err_pci_release_regions;
>  
>  	netdev->features |= NETIF_F_HIGHDMA;
>  
> +	/* pick up the PCI bus settings for reporting later */
> +	TCALL(hw, mac.ops.get_bus_info);
> +
>  	pci_set_drvdata(pdev, adapter);
>  
> +	/* calculate the expected PCIe bandwidth required for optimal
> +	 * performance. Note that some older parts will never have enough
> +	 * bandwidth due to being older generation PCIe parts. We clamp these
> +	 * parts to ensure that no warning is displayed, as this could confuse
> +	 * users otherwise.
> +	 */
> +	expected_gts = txgbe_enumerate_functions(adapter) * 10;
> +
> +	/* don't check link if we failed to enumerate functions */
> +	if (expected_gts > 0)
> +		txgbe_check_minimum_link(adapter);

What about expected_gts == -1?

> +
> +/* PCI bus speeds */
> +enum txgbe_bus_speed {
> +	txgbe_bus_speed_unknown	= 0,
> +	txgbe_bus_speed_33	= 33,
> +	txgbe_bus_speed_66	= 66,
> +	txgbe_bus_speed_100	= 100,
> +	txgbe_bus_speed_120	= 120,
> +	txgbe_bus_speed_133	= 133,
> +	txgbe_bus_speed_2500	= 2500,
> +	txgbe_bus_speed_5000	= 5000,
> +	txgbe_bus_speed_8000	= 8000,
> +	txgbe_bus_speed_reserved

Could you use pci_bus_speed from include/linux/pic.h


> +};
> +
> +/* PCI bus widths */
> +enum txgbe_bus_width {
> +	txgbe_bus_width_unknown	= 0,
> +	txgbe_bus_width_pcie_x1	= 1,
> +	txgbe_bus_width_pcie_x2	= 2,
> +	txgbe_bus_width_pcie_x4	= 4,
> +	txgbe_bus_width_pcie_x8	= 8,
> +	txgbe_bus_width_32	= 32,
> +	txgbe_bus_width_64	= 64,
> +	txgbe_bus_width_reserved

pcie_link_width?

It is much better to use existing enums that invent your own.

> +/* Error Codes */
> +#define TXGBE_ERR                                100
> +#define TXGBE_NOT_IMPLEMENTED                    0x7FFFFFFF
> +/* (-TXGBE_ERR, TXGBE_ERR): reserved for non-txgbe defined error code */
> +#define TXGBE_ERR_NOSUPP                        -(TXGBE_ERR + 0)
> +#define TXGBE_ERR_EEPROM                        -(TXGBE_ERR + 1)
> +#define TXGBE_ERR_EEPROM_CHECKSUM               -(TXGBE_ERR + 2)
> +#define TXGBE_ERR_PHY                           -(TXGBE_ERR + 3)

Use standard error codes, which you can return to user space.

> +
> +static inline bool TXGBE_REMOVED(void __iomem *addr)
> +{
> +	return unlikely(!addr);
> +}

This needs a comment to explain it!

> +
> +static inline u32
> +txgbe_rd32(u8 __iomem *base)
> +{
> +	return readl(base);
> +}

Pointless wrapper. Just use readl()!

> +
> +static inline u32
> +rd32(struct txgbe_hw *hw, u32 reg)
> +{
> +	u8 __iomem *base = READ_ONCE(hw->hw_addr);

It is very unusual for the hardware to change its address after
probe. In fact, it is very unusual for the hardware to change its
address ever.  I find this READ_ONCE very suspicious. Please explain.

> +	u32 val = TXGBE_FAILED_READ_REG;
> +
> +	if (unlikely(!base))
> +		return val;

Can this happen? If it does -ENODEV or -EIO would be the correct
return value.

Please go through the whole driver and fix up your function return
types and values, and checking for errors.

In general, functions should be int, return 0 on success, or a
negative error code on failure. Callers for functions should always
look for error codes, and return them up the call stack.

     Andrew
