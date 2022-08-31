Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E82665A7323
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 03:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbiHaBDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 21:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbiHaBDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 21:03:04 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EC5AEDA9
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 18:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OVclk7PLTnK1/+dA1F+3Jbz+hBFDUDybRGS37gEcmGM=; b=xjz7fIMiIBhos+UOsN09m64uUD
        /F6vg3XQuGDYVjHjqBiXRkeSJy3kRvAGyzIjKrjgHnnuAdv141qfzVTHaqAU3XxeDaegq+yFc8yU5
        mOI3FLbhsmt1MSv5CHBLcMcwjG1aOy+ADSW91qnwnsI0e3eM4ekBx0v7z+TaAW/99QIg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oTBlC-00F8zB-L3; Wed, 31 Aug 2022 02:39:14 +0200
Date:   Wed, 31 Aug 2022 02:39:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v2 02/16] net: txgbe: Reset hardware
Message-ID: <Yw6tsmufKFoHzu4M@lunn.ch>
References: <20220830070454.146211-1-jiawenwu@trustnetic.com>
 <20220830070454.146211-3-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830070454.146211-3-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

n Tue, Aug 30, 2022 at 03:04:40PM +0800, Jiawen Wu wrote:
> Reset and initialize the hardware by configuring the MAC layer.
> 
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> ---
>  drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  14 ++
>  .../net/ethernet/wangxun/txgbe/txgbe_dummy.h  |  26 ++
>  drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 236 ++++++++++++++++++
>  drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   7 +
>  .../net/ethernet/wangxun/txgbe/txgbe_main.c   |   6 +
>  .../net/ethernet/wangxun/txgbe/txgbe_type.h   | 236 ++++++++++++++++++
>  6 files changed, 525 insertions(+)
> 
> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
> index a271a74b7ef7..42ffe70a6e4e 100644
> --- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
> @@ -23,6 +23,20 @@ struct txgbe_adapter {
>  	u16 msg_enable;
>  };
>  
> +#define TXGBE_INTR_ALL (~0ULL)
> +
> +static inline void txgbe_intr_disable(struct txgbe_hw *hw, u64 qmask)
> +{
> +	u32 mask;
> +
> +	mask = (qmask & 0xFFFFFFFF);
> +	if (mask)
> +		wr32(hw, TXGBE_PX_IMS(0), mask);
> +	mask = (qmask >> 32);
> +	if (mask)
> +		wr32(hw, TXGBE_PX_IMS(1), mask);
> +}

This appears to be only used in one place. So you should make it a
function in that one file. The compiler will then inline it, probable.

> +
>  extern char txgbe_driver_name[];
>  
>  __maybe_unused static struct device *txgbe_hw_to_dev(const struct txgbe_hw *hw)
> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
> index 822306f5eaba..9b87bca57324 100644
> --- a/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
> @@ -19,16 +19,42 @@
>  #define TUP4 TUP(p4)
>  
>  /* struct txgbe_mac_operations */
> +static int txgbe_stop_adapter_dummy(struct txgbe_hw *TUP0)
> +{
> +	return -EPERM;

This is a bit of an odd error code. -EOPNOTSUPP would be more
normal.

I do wonder what all this dummy stuff is for... 

> +/**
> + *  txgbe_stop_adapter - Generic stop Tx/Rx units
> + *  @hw: pointer to hardware structure
> + *
> + *  Sets the adapter_stopped flag within txgbe_hw struct. Clears interrupts,
> + *  disables transmit and receive units. The adapter_stopped flag is used by
> + *  the shared code and drivers to determine if the adapter is in a stopped
> + *  state and should not touch the hardware.
> + **/
> +int txgbe_stop_adapter(struct txgbe_hw *hw)
> +{
> +	u16 i;
> +
> +	/* Set the adapter_stopped flag so other driver functions stop touching
> +	 * the hardware
> +	 */
> +	hw->adapter_stopped = true;
> +
> +	/* Disable the receive unit */
> +	hw->mac.ops.disable_rx(hw);
> +
> +	/* Set interrupt mask to stop interrupts from being generated */
> +	txgbe_intr_disable(hw, TXGBE_INTR_ALL);
> +
> +	/* Clear any pending interrupts, flush previous writes */
> +	wr32(hw, TXGBE_PX_MISC_IC, 0xffffffff);
> +	wr32(hw, TXGBE_BME_CTL, 0x3);
> +
> +	/* Disable the transmit unit.  Each queue must be disabled. */
> +	for (i = 0; i < hw->mac.max_tx_queues; i++) {
> +		wr32m(hw, TXGBE_PX_TR_CFG(i),
> +		      TXGBE_PX_TR_CFG_SWFLSH | TXGBE_PX_TR_CFG_ENABLE,
> +		      TXGBE_PX_TR_CFG_SWFLSH);
> +	}
> +
> +	/* Disable the receive unit by stopping each queue */
> +	for (i = 0; i < hw->mac.max_rx_queues; i++) {
> +		wr32m(hw, TXGBE_PX_RR_CFG(i),
> +		      TXGBE_PX_RR_CFG_RR_EN, 0);
> +	}
> +
> +	/* flush all queues disables */
> +	TXGBE_WRITE_FLUSH(hw);
> +
> +	/* Prevent the PCI-E bus from hanging by disabling PCI-E master
> +	 * access and verify no pending requests
> +	 */
> +	return txgbe_disable_pcie_master(hw);

Interesting. You use it here....

> +}
> +
> +/**
> + *  txgbe_disable_pcie_master - Disable PCI-express master access
> + *  @hw: pointer to hardware structure
> + *
> + *  Disables PCI-Express master access and verifies there are no pending
> + *  requests. TXGBE_ERR_MASTER_REQUESTS_PENDING is returned if master disable
> + *  bit hasn't caused the master requests to be disabled, else 0
> + *  is returned signifying master requests disabled.
> + **/
> +int txgbe_disable_pcie_master(struct txgbe_hw *hw)
> +{
> +	struct txgbe_adapter *adapter = container_of(hw, struct txgbe_adapter, hw);
> +	int status = 0;
> +	u32 val;

But define it here, afterwards. Wrong order. Swap this around, and
remove the forward reference. And should this also be static? Is it
used in any other object file?

Because you have it in the wrong order, the compiler cannot easily
inline it. The optimised won't do as good a job as if it had seen it
first before it was also used. Also, because it is not static, the
compiler needs to keep a copy around for the linker to use with
another object file.

So....

Define functions before you use them.

Make them static if possible.

Header files should only contain definitions of functions which are
used between object files, not within an object file.

> +
> +	/* Always set this bit to ensure any future transactions are blocked */
> +	pci_clear_master(adapter->pdev);
> +
> +	/* Exit if master requests are blocked */
> +	if (!(rd32(hw, TXGBE_PX_TRANSACTION_PENDING)))
> +		goto out;
> +
> +	/* Poll for master request bit to clear */
> +	status = read_poll_timeout(rd32, val, !val, 100, TXGBE_PCI_MASTER_DISABLE_TIMEOUT,
> +				   false, hw, TXGBE_PX_TRANSACTION_PENDING);
> +	if (status == 0)
> +		goto out;
> +
> +	txgbe_info(hw, "PCIe transaction pending bit did not clear.\n");

This should probably be dev_err(), since i assume it is fatal?

> +out:
> +	return status;
> +}
> +
>  /* cmd_addr is used for some special command:
>   * 1. to be sector address, when implemented erase sector command
>   * 2. to be flash address when implemented read, write flash address
> @@ -57,6 +143,61 @@ int txgbe_flash_read_dword(struct txgbe_hw *hw, u32 addr, u32 *data)
>  	return ret;
>  }
>  
> +/**
> + *  txgbe_init_thermal_sensor_thresh - Inits thermal sensor thresholds
> + *  @hw: pointer to hardware structure
> + *
> + *  Inits the thermal sensor thresholds according to the NVM map
> + *  and save off the threshold and location values into mac.thermal_sensor_data
> + **/
> +void txgbe_init_thermal_sensor_thresh(struct txgbe_hw *hw)

This appears to be only used within this object file. So it should be
static.

It is a good idea to use objdump --syms and look for symbols which are
of global scope, Are they really used outside of the object file?

>  int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit)
>  {
>  	u32 i = 0, reg = 0;
> @@ -94,5 +235,100 @@ void txgbe_init_ops(struct txgbe_hw *hw)
>  	struct txgbe_mac_info *mac = &hw->mac;
>  
>  	/* MAC */
> +	mac->ops.stop_adapter = txgbe_stop_adapter;
>  	mac->ops.set_lan_id = txgbe_set_lan_id_multi_port_pcie;
> +	mac->ops.reset_hw = txgbe_reset_hw;
> +
> +	/* RAR */
> +	mac->ops.disable_rx = txgbe_disable_rx;
> +
> +	mac->max_rx_queues      = TXGBE_SP_MAX_RX_QUEUES;
> +	mac->max_tx_queues      = TXGBE_SP_MAX_TX_QUEUES;
> +
> +	/* Manageability interface */
> +	mac->ops.init_thermal_sensor_thresh = txgbe_init_thermal_sensor_thresh;

You set this here...

> +}
> +
> +void txgbe_reset_misc(struct txgbe_hw *hw)
> +{
> +	int i;

...

> +
> +	txgbe_init_thermal_sensor_thresh(hw);

But then call it directly. Does mac->ops.init_thermal_sensor_thresh
have an reason to exist?

And then i have to wonder about all the other things in mac->ops.
Given spectra/meltdown etc, jumping through a pointer is expensive.
It is O.K. to do it on the slow path, but you don't want it on the hot
path if you can avoid it.

> +#define TXGBE_WRITE_FLUSH(H) rd32(H, TXGBE_MIS_PWR)

What does this do? You are using readl() not readl_relaxed(), so you
already have a barrier operation. Is that not sufficient?

	Andrew
