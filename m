Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27D345A7239
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 02:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiHaAGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 20:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiHaAGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 20:06:51 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460357F243
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 17:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3wGtyeff4F8YC4yFGBBqb6Xb/3ai2kHmo4npnzGAXSc=; b=Dc375fBgMRrOa/nETPotFFhTnN
        b6JHl4kk2yP9qSFIRKa9Ozp2h3GdgqM98Mix7BUsln5RSMhk39bwxiT+lL2zJCpvMCGxjIViIpwxq
        V2OGzqXySkYBhF9rXFAh/w6FMUiH6fwctSZJtye3Ri6u/nO0YOfiw92znWk3CpJ14Qk4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oTBFl-00F8sZ-HH; Wed, 31 Aug 2022 02:06:45 +0200
Date:   Wed, 31 Aug 2022 02:06:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v2 01/16] net: txgbe: Store PCI info
Message-ID: <Yw6mFbl8abA1lgma@lunn.ch>
References: <20220830070454.146211-1-jiawenwu@trustnetic.com>
 <20220830070454.146211-2-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830070454.146211-2-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
> @@ -0,0 +1,34 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd. */
> +
> +#ifndef _TXGBE_DUMMY_H_
> +#define _TXGBE_DUMMY_H_
> +
> +#ifdef TUP
> +#elif defined(__GNUC__)
> +  #define TUP(x) x##_unused __always_unused
> +#elif defined(__LCLINT__)
> +  #define TUP(x) x /*@unused@*/
> +#else
> +  #define TUP(x) x
> +#endif /*TUP*/
> +#define TUP0 TUP(p0)
> +#define TUP1 TUP(p1)
> +#define TUP2 TUP(p2)
> +#define TUP3 TUP(p3)
> +#define TUP4 TUP(p4)

Please avoid macro magic, unless really needed.

> +
> +/* struct txgbe_mac_operations */
> +static void txgbe_bus_set_lan_id_dummy(struct txgbe_hw *TUP0)
> +{
> +}

Seems pointless, so just remove this function, and then you don't need
the macro magic.

> +
> +static void txgbe_init_ops_dummy(struct txgbe_hw *hw)
> +{
> +	struct txgbe_mac_info *mac = &hw->mac;
> +
> +	/* MAC */
> +	mac->ops.set_lan_id = txgbe_bus_set_lan_id_dummy;

Just set it to NULL. A user can first check if its NULL, and not call
it, or return -EOPNOTSUPP etc.


> +/* cmd_addr is used for some special command:
> + * 1. to be sector address, when implemented erase sector command
> + * 2. to be flash address when implemented read, write flash address
> + */
> +int txgbe_fmgr_cmd_op(struct txgbe_hw *hw, u32 cmd, u32 cmd_addr)
> +{
> +	u32 cmd_val = 0, val = 0;
> +
> +	cmd_val = (cmd << SPI_CLK_CMD_OFFSET) |
> +		  (SPI_CLK_DIV << SPI_CLK_DIV_OFFSET) | cmd_addr;
> +	wr32(hw, SPI_H_CMD_REG_ADDR, cmd_val);
> +
> +	return read_poll_timeout(rd32, val, (val & 0x1), 10, SPI_TIME_OUT_VALUE,
> +				 false, hw, SPI_H_STA_REG_ADDR);
> +}
> +

> +int txgbe_flash_read_dword(struct txgbe_hw *hw, u32 addr, u32 *data)
> +{
> +	int ret = 0;
> +
> +	ret = txgbe_fmgr_cmd_op(hw, SPI_CMD_READ_DWORD, addr);
> +	if (ret == -ETIMEDOUT)
> +		return ret;

Are you absolutely sure it will never return any other error code?
The pattern in the kernel is

> +	if (ret)
> +		return ret;

or

> +	if (ret < 0)
> +		return ret;

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

This is what iopoll.h is for. Any sort of loop waiting for something
to happen should use one of the helpers in there.

> +		if (i == TXGBE_MAX_FLASH_LOAD_POLL_TIME) {
> +			err = -ETIMEDOUT;
> +			txgbe_info(hw, "Check flash load timeout.\n");

Either dev_err() if this is fatal, or dev_dbg() if it is
not. dev_info() is not used very often, maybe just in your probe
function when you have found your hardware.

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
> +		err = txgbe_flash_read_dword(hw, 0xfffdc, &ssid);
> +		if (err == -ETIMEDOUT) {
> +			netif_err(adapter, probe, adapter->netdev,
> +				  "read of internal subsystem device id failed\n");
> +			return -ENODEV;

Don't turn an -ETIMEDOUT into an -ENODEV.  In general, never convert
from one error code to another, unless you have a really good reason,
and if you do, comment why. -ETIMEDOUT is useful information, it helps
narrow down the problem.

> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
> index b2e329f50bae..3b1dd104373b 100644
> --- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
> @@ -4,7 +4,9 @@
>  #ifndef _TXGBE_TYPE_H_
>  #define _TXGBE_TYPE_H_
>  
> +#include <linux/pci.h>
>  #include <linux/types.h>
> +#include <linux/iopoll.h>
>  #include <linux/netdevice.h>

These should be in the .c file. Avoid them in header files, since you
will include more headers than actually needed, slowing down the
build. A lot of time is spent in the build processing useless
headers. Please don't make it worse.

>  
>  /************ txgbe_register.h ************/
> @@ -54,4 +56,153 @@
>  /* Revision ID */
>  #define TXGBE_SP_MPW  1
>  
> +/**************** Global Registers ****************************/
> +/* chip control Registers */
> +#define TXGBE_MIS_RST                   0x1000C
> +#define TXGBE_MIS_PWR                   0x10000
> +#define TXGBE_MIS_CTL                   0x10004
> +#define TXGBE_MIS_PF_SM                 0x10008
> +#define TXGBE_MIS_PRB_CTL               0x10010
> +#define TXGBE_MIS_ST                    0x10028
> +#define TXGBE_MIS_SWSM                  0x1002C
> +#define TXGBE_MIS_RST_ST                0x10030
> +
> +#define TXGBE_MIS_RST_SW_RST            0x00000001U
> +#define TXGBE_MIS_RST_LAN0_RST          0x00000002U
> +#define TXGBE_MIS_RST_LAN1_RST          0x00000004U
> +#define TXGBE_MIS_RST_LAN0_CHG_ETH_MODE 0x20000000U
> +#define TXGBE_MIS_RST_LAN1_CHG_ETH_MODE 0x40000000U
> +#define TXGBE_MIS_RST_GLOBAL_RST        0x80000000U

Generally that would be BIT(0), BIT(1), BIT(2), BIT(29), BIT(30),
BIT(31).  I find this easier to read, especially when it is bit(21),
somewhere in the middle.

Please consider changing all the #defines that are for bits.

       Andrew
