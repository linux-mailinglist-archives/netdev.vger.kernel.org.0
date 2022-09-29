Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCDF5EFB37
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 18:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235714AbiI2Qq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 12:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235974AbiI2QqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 12:46:18 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA55A1B14F0
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 09:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Liy0wMIkh2+Rfuk5mT8Qir9+2A0Wu+BwwVNhlsYbdRg=; b=Oen30pajUjcQ0JVFux8gAWhBEY
        ByVBPpPzrxCdwsnfRbTI0D1XGnjedb1zFnH9Te4u8/iVqbNAd4yFPqrYOeRIs1XTbXtPzblgysmp9
        rykKkchBR9DZa/HWnEje19LMUXoqFNZDtJt4F16326pWkud7H1TLxgCCsOb9GIa2t+8A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1odwft-000dWz-BX; Thu, 29 Sep 2022 18:46:13 +0200
Date:   Thu, 29 Sep 2022 18:46:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v3 2/3] net: txgbe: Reset hardware
Message-ID: <YzXL1WoOwUnU93Lq@lunn.ch>
References: <20220929093424.2104246-1-jiawenwu@trustnetic.com>
 <20220929093424.2104246-3-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929093424.2104246-3-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 05:34:23PM +0800, Jiawen Wu wrote:
> Reset and initialize the hardware by configuring the MAC layer.
> 
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> ---
>  drivers/net/ethernet/wangxun/libwx/wx_hw.c    | 160 ++++++++++++++++++
>  drivers/net/ethernet/wangxun/libwx/wx_hw.h    |   2 +
>  drivers/net/ethernet/wangxun/libwx/wx_type.h  | 144 ++++++++++++++++
>  drivers/net/ethernet/wangxun/txgbe/Makefile   |   3 +-
>  drivers/net/ethernet/wangxun/txgbe/txgbe.h    |   5 +-
>  drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c |  86 ++++++++++
>  drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   9 +
>  .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  21 +++
>  .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  11 +-
>  9 files changed, 432 insertions(+), 9 deletions(-)
>  create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
>  create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
> 
> diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
> index fed51c2f3071..76f88cfb2476 100644
> --- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
> +++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
> @@ -7,6 +7,21 @@
>  #include "wx_type.h"
>  #include "wx_hw.h"
>  
> +static void wx_intr_disable(struct wx_hw *wxhw, u64 qmask)
> +{
> +	u32 mask;
> +
> +	mask = (qmask & 0xFFFFFFFF);
> +	if (mask)
> +		wr32(wxhw, WX_PX_IMS(0), mask);
> +
> +	if (wxhw->mac.type == wx_mac_sp) {
> +		mask = (qmask >> 32);
> +		if (mask)
> +			wr32(wxhw, WX_PX_IMS(1), mask);
> +	}
> +}
> +
>  /* cmd_addr is used for some special command:
>   * 1. to be sector address, when implemented erase sector command
>   * 2. to be flash address when implemented read, write flash address
> @@ -56,6 +71,151 @@ int wx_check_flash_load(struct wx_hw *hw, u32 check_bit)
>  }
>  EXPORT_SYMBOL(wx_check_flash_load);
>  
> +static void wx_disable_rx(struct wx_hw *wxhw)
> +{
> +	u32 pfdtxgswc;
> +	u32 rxctrl;
> +
> +	rxctrl = rd32(wxhw, WX_RDB_PB_CTL);
> +	if (rxctrl & WX_RDB_PB_CTL_RXEN) {
> +		pfdtxgswc = rd32(wxhw, WX_PSR_CTL);
> +		if (pfdtxgswc & WX_PSR_CTL_SW_EN) {
> +			pfdtxgswc &= ~WX_PSR_CTL_SW_EN;
> +			wr32(wxhw, WX_PSR_CTL, pfdtxgswc);
> +			wxhw->mac.set_lben = true;
> +		} else {
> +			wxhw->mac.set_lben = false;
> +		}
> +		rxctrl &= ~WX_RDB_PB_CTL_RXEN;
> +		wr32(wxhw, WX_RDB_PB_CTL, rxctrl);
> +
> +		if (!(((wxhw->subsystem_device_id & WX_NCSI_MASK) == WX_NCSI_SUP) ||
> +		      ((wxhw->subsystem_device_id & WX_WOL_MASK) == WX_WOL_SUP))) {
> +			/* disable mac receiver */
> +			wr32m(wxhw, WX_MAC_RX_CFG,
> +			      WX_MAC_RX_CFG_RE, 0);
> +		}
> +	}
> +}
> +
> +/**
> + *  wx_disable_pcie_master - Disable PCI-express master access
> + *  @wxhw: pointer to hardware structure
> + *
> + *  Disables PCI-Express master access and verifies there are no pending
> + *  requests.
> + **/
> +static int wx_disable_pcie_master(struct wx_hw *wxhw)
> +{
> +	int status = 0;
> +	u32 val;
> +
> +	/* Always set this bit to ensure any future transactions are blocked */
> +	pci_clear_master(wxhw->pdev);
> +
> +	/* Exit if master requests are blocked */
> +	if (!(rd32(wxhw, WX_PX_TRANSACTION_PENDING)))
> +		return 0;
> +
> +	/* Poll for master request bit to clear */
> +	status = read_poll_timeout(rd32, val, !val, 100, WX_PCI_MASTER_DISABLE_TIMEOUT,
> +				   false, wxhw, WX_PX_TRANSACTION_PENDING);
> +	if (status < 0)
> +		wx_err(wxhw, "PCIe transaction pending bit did not clear.\n");
> +
> +	return status;
> +}
> +
> +/**
> + *  wx_stop_adapter - Generic stop Tx/Rx units
> + *  @hw: pointer to hardware structure
> + *
> + *  Sets the adapter_stopped flag within wx_hw struct. Clears interrupts,
> + *  disables transmit and receive units. The adapter_stopped flag is used by
> + *  the shared code and drivers to determine if the adapter is in a stopped
> + *  state and should not touch the hardware.
> + **/
> +int wx_stop_adapter(struct wx_hw *wxhw)
> +{
> +	u16 i;
> +
> +	/* Set the adapter_stopped flag so other driver functions stop touching
> +	 * the hardware
> +	 */
> +	wxhw->adapter_stopped = true;
> +
> +	/* Disable the receive unit */
> +	wx_disable_rx(wxhw);
> +
> +	/* Set interrupt mask to stop interrupts from being generated */
> +	wx_intr_disable(wxhw, WX_INTR_ALL);
> +
> +	/* Clear any pending interrupts, flush previous writes */
> +	wr32(wxhw, WX_PX_MISC_IC, 0xffffffff);
> +	wr32(wxhw, WX_BME_CTL, 0x3);
> +
> +	/* Disable the transmit unit.  Each queue must be disabled. */
> +	for (i = 0; i < wxhw->mac.max_tx_queues; i++) {
> +		wr32m(wxhw, WX_PX_TR_CFG(i),
> +		      WX_PX_TR_CFG_SWFLSH | WX_PX_TR_CFG_ENABLE,
> +		      WX_PX_TR_CFG_SWFLSH);
> +	}
> +
> +	/* Disable the receive unit by stopping each queue */
> +	for (i = 0; i < wxhw->mac.max_rx_queues; i++) {
> +		wr32m(wxhw, WX_PX_RR_CFG(i),
> +		      WX_PX_RR_CFG_RR_EN, 0);
> +	}
> +
> +	/* flush all queues disables */
> +	WX_WRITE_FLUSH(wxhw);

Please don't hide memory barriers like this. Memory barriers are hard,
so you want them in plain view, so you can understand them.

> +/* flush PCI read and write */
> +#define WX_WRITE_FLUSH(H) rd32(H, WX_MIS_PWR)

I don't think you actually need to do anything here. rd32 is using
readl():

static inline u32 readl(const volatile void __iomem *addr)
{
	u32 val;

	__io_br();
	val = __le32_to_cpu((__le32 __force)__raw_readl(addr));
	__io_ar(val);
	return val;
}

So you have an IO barrier before and a read barrier afterwards.  So
all i think you need is a mb(), not a full rd32().

   Andrew
