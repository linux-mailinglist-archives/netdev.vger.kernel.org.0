Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7752398070
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 06:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhFBEke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 00:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229744AbhFBEkd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 00:40:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D9D2610E7;
        Wed,  2 Jun 2021 04:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622608731;
        bh=21FyACrIYYe/gZyiRrdPvkvisSOkr/1qMXI30OMpcZo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CTbvv3zKCzWoqJWgE/aZ3BDFg4mFJgsO0I6t9EAAkMIyvV1Wv742B16eTjODTS3xY
         tSYqgrDsjxCdI0MB87neo6gS/OdqYQY1nHOVM2hqAwVj4Z1CXkrIz8LKGGadE/wTrt
         6AOLdkr4k95cp3G7i+5rg94uOEmSPtaWokv3hN+d5DTjiSPx6QBFPjoPIKRQatT0m/
         2PE7cn3PBOI+xtZ4v//OvOT/UDaujdq2+6J7YB2N7RYSA35Rs1WqSUMnfA3b1vaxup
         7xiM3LR26zlhdACbRJ1MrNMOV0tjbB8QDswD6+D/RZOpz+sRAmm/69ijEFWVPyg5yl
         petRBt3SeHA8g==
Date:   Wed, 2 Jun 2021 07:38:47 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     David Thompson <davthompson@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        limings@nvidia.com, Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v6] Add Mellanox BlueField Gigabit Ethernet
 driver
Message-ID: <YLcLV+p4yZGjdMHO@unreal>
References: <20210601122455.1025-1-davthompson@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601122455.1025-1-davthompson@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 08:24:55AM -0400, David Thompson wrote:
> This patch adds build and driver logic for the "mlxbf_gige"
> Ethernet driver from Mellanox Technologies. The second
> generation BlueField SoC from Mellanox supports an
> out-of-band GigaBit Ethernet management port to the Arm
> subsystem.  This driver supports TCP/IP network connectivity
> for that port, and provides back-end routines to handle
> basic ethtool requests.
> 
> The driver interfaces to the Gigabit Ethernet block of
> BlueField SoC via MMIO accesses to registers, which contain
> control information or pointers describing transmit and
> receive resources.  There is a single transmit queue, and
> the port supports transmit ring sizes of 4 to 256 entries.
> There is a single receive queue, and the port supports
> receive ring sizes of 32 to 32K entries. The transmit and
> receive rings are allocated from DMA coherent memory. There
> is a 16-bit producer and consumer index per ring to denote
> software ownership and hardware ownership, respectively.
> 
> The main driver logic such as probe(), remove(), and netdev
> ops are in "mlxbf_gige_main.c".  Logic in "mlxbf_gige_rx.c"
> and "mlxbf_gige_tx.c" handles the packet processing for
> receive and transmit respectively.
> 
> The logic in "mlxbf_gige_ethtool.c" supports the handling
> of some basic ethtool requests: get driver info, get ring
> parameters, get registers, and get statistics.
> 
> The logic in "mlxbf_gige_mdio.c" is the driver controlling
> the Mellanox BlueField hardware that interacts with a PHY
> device via MDIO/MDC pins.  This driver does the following:
>   - At driver probe time, it configures several BlueField MDIO
>     parameters such as sample rate, full drive, voltage and MDC
>   - It defines functions to read and write MDIO registers and
>     registers the MDIO bus.
>   - It defines the phy interrupt handler reporting a
>     link up/down status change
>   - This driver's probe is invoked from the main driver logic
>     while the phy interrupt handler is registered in ndo_open.
> 
> Driver limitations
>   - Only supports 1Gbps speed
>   - Only supports GMII protocol
>   - Supports maximum packet size of 2KB
>   - Does not support scatter-gather buffering
> 
> Testing
>   - Successful build of kernel for ARM64, ARM32, X86_64
>   - Tested ARM64 build on FastModels & Palladium
>   - Tested ARM64 build on several Mellanox boards that are built with
>     the BlueField-2 SoC.  The testing includes coverage in the areas
>     of networking (e.g. ping, iperf, ifconfig, route), file transfers
>     (e.g. SCP), and various ethtool options relevant to this driver.
> 
> v5 -> v6

Please put changelog under "---" below your SOBs. We don't need to see
this history in the git log.

>   Fixed use of COMPILE_TEST for ARM32 build; changed driver to not
>   depend on CONFIG_ACPI for ARM32 build
> v4 -> v5
>   Created a separate interrupt controller for the GPIO PHY interrupt
>   and as a result, the GIGE driver no longer depends on GPIO driver
>   Updated the logic in mlxbf_gige_adjust_link() to store the negotiated
>   pause settings into the driver's private settings.
>   Modified logic to only change enable bit in RX_DMA register
>   Changed logic to only map and unmap the actual length of the TX SKB,
>   instead using the default size.
>   Added better error handling to open() method
>   Modified receive packet logic to use polarity bit to signify ownership
>   (software vs. hardware) of the RX CQE slot
> v3 -> v4
>   Main driver module broken out into rx, tx, intr, and ethtool modules
>   Removed some GPIO PHY interrupt logic; moved to GPIO_MLXBF2 driver
> v2 -> v3
>   Added logic to handle PHY link up/down interrupts
>   Use streaming DMA mapping for packet buffers
>   Changed logic to use standard iopoll methods
>   Changed PHY logic to not allow C45 transactions
>   Enhanced the error handling in open() method
>   Enhanced start_xmit() method to use xmit_more mechanism
>   Added support for ndo_get_stats64
>   Removed standard stats from "ethtool -S" output
> v1 -> v2:
>   Fixed all warnings raised by "make C=1" and "make W=1"
>     a) Changed logic in mlxbf_gige_rx_deinit() and mlxbf_gige_tx_deinit()
>        to initialize relevant pointers as NULL, not 0
>     b) Change mlxbf_gige_get_mac_rx_filter() to return void,
>        as this function's return status is not used by caller
>     c) Fixed type definition of "buff" in mlxbf_gige_get_regs()
> 
> Signed-off-by: David Thompson <davthompson@nvidia.com>
> Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
> Reviewed-by: Liming Sun <limings@nvidia.com>
> ---

The patch generates checkpatch warnings.

 CHECK: spinlock_t definition without comment
 #272: FILE: drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h:87:
 +	spinlock_t lock;

 CHECK: spinlock_t definition without comment
 #273: FILE: drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h:88:
 +	spinlock_t gpio_lock;

 CHECK: Macro argument 'tx_wqe_addr' may be better as '(tx_wqe_addr)' to avoid precedence issues
 #328: FILE: drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h:143:
 +#define MLXBF_GIGE_TX_WQE_PKT_LEN(tx_wqe_addr) \
 +	(*(tx_wqe_addr + 1) & MLXBF_GIGE_TX_WQE_PKT_LEN_MASK)

 CHECK: multiple assignments should be avoided
 #1271: FILE: drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c:374:
 +	phydev->irq = priv->mdiobus->irq[addr] = priv->phy_irq;

Thanks
