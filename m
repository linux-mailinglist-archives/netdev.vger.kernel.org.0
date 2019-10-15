Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57B08D76C1
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 14:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729351AbfJOMqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 08:46:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45474 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfJOMqd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 08:46:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bK3bIbr1yVop27twgFaEBQrU9ejkC0EQSbEo7oTzKqk=; b=TIFbIvhUjHgmibjnIKzCruEwL8
        FyEbPgV/A9G85i/LnnFt4w1FDF6BeDUnu/b2AJ2N16gZs0vIyf1ZqG2gzQaM8nDS0n3TtYtiJVqdf
        pkXdOG6pc1pXG6eOiy8S0R29mSd6Lc2cIas9f4PlACoEmdpHa3p3L/yT9quGXkm11utk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iKLn5-0000gA-MZ; Tue, 15 Oct 2019 14:19:03 +0200
Date:   Tue, 15 Oct 2019 14:19:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>
Subject: Re: [PATCH v2 net-next 10/12] net: aquantia: add support for Phy
 access
Message-ID: <20191015121903.GK19861@lunn.ch>
References: <cover.1570531332.git.igor.russkikh@aquantia.com>
 <09f7d525783b31730ca3bdbaa52c962a141284a5.1570531332.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09f7d525783b31730ca3bdbaa52c962a141284a5.1570531332.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 08, 2019 at 10:56:56AM +0000, Igor Russkikh wrote:
> From: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
> 
> GPIO PIN control and access is done by direct phy manipulation.
> Here we add an aq_phy module which is able to access phy registers
> via MDIO access mailbox.
> 
> Access is controlled via HW semaphore.
> 
> Co-developed-by: Nikita Danilov <nikita.danilov@aquantia.com>
> Signed-off-by: Nikita Danilov <nikita.danilov@aquantia.com>
> Signed-off-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
> Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>

Hi Igor

Is the Atlantic a combined MAC and PHY in one silicon, or are there
two devices? Could the Atlantic MAC be used in combination with for
example a Marvell PHY?

> diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_phy.c b/drivers/net/ethernet/aquantia/atlantic/aq_phy.c
> new file mode 100644
> index 000000000000..51ae921e3e1f
> --- /dev/null
> +++ b/drivers/net/ethernet/aquantia/atlantic/aq_phy.c
> @@ -0,0 +1,147 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* aQuantia Corporation Network Driver
> + * Copyright (C) 2018-2019 aQuantia Corporation. All rights reserved
> + */
> +
> +#include "aq_phy.h"
> +
> +bool aq_mdio_busy_wait(struct aq_hw_s *aq_hw)
> +{
> +	int err = 0;
> +	u32 val;
> +
> +	err = readx_poll_timeout_atomic(hw_atl_mdio_busy_get, aq_hw,
> +					val, val == 0U, 10U, 100000U);
> +
> +	if (err < 0)
> +		return false;
> +
> +	return true;
> +}
> +
> +u16 aq_mdio_read_word(struct aq_hw_s *aq_hw, u16 mmd, u16 addr)
> +{
> +	u16 phy_addr = aq_hw->phy_id << 5 | mmd;
> +
> +	/* Set Address register. */
> +	hw_atl_glb_mdio_iface4_set(aq_hw, (addr & HW_ATL_MDIO_ADDRESS_MSK) <<
> +				   HW_ATL_MDIO_ADDRESS_SHIFT);
> +	/* Send Address command. */
> +	hw_atl_glb_mdio_iface2_set(aq_hw, HW_ATL_MDIO_EXECUTE_OPERATION_MSK |
> +				   (3 << HW_ATL_MDIO_OP_MODE_SHIFT) |
> +				   ((phy_addr & HW_ATL_MDIO_PHY_ADDRESS_MSK) <<
> +				    HW_ATL_MDIO_PHY_ADDRESS_SHIFT));
> +
> +	aq_mdio_busy_wait(aq_hw);
> +
> +	/* Send Read command. */
> +	hw_atl_glb_mdio_iface2_set(aq_hw, HW_ATL_MDIO_EXECUTE_OPERATION_MSK |
> +				   (1 << HW_ATL_MDIO_OP_MODE_SHIFT) |
> +				   ((phy_addr & HW_ATL_MDIO_PHY_ADDRESS_MSK) <<
> +				    HW_ATL_MDIO_PHY_ADDRESS_SHIFT));
> +	/* Read result. */
> +	aq_mdio_busy_wait(aq_hw);
> +
> +	return (u16)hw_atl_glb_mdio_iface5_get(aq_hw);
> +}
> +
> +void aq_mdio_write_word(struct aq_hw_s *aq_hw, u16 mmd, u16 addr, u16 data)
> +{
> +	u16 phy_addr = aq_hw->phy_id << 5 | mmd;
> +
> +	/* Set Address register. */
> +	hw_atl_glb_mdio_iface4_set(aq_hw, (addr & HW_ATL_MDIO_ADDRESS_MSK) <<
> +				   HW_ATL_MDIO_ADDRESS_SHIFT);
> +	/* Send Address command. */
> +	hw_atl_glb_mdio_iface2_set(aq_hw, HW_ATL_MDIO_EXECUTE_OPERATION_MSK |
> +				   (3 << HW_ATL_MDIO_OP_MODE_SHIFT) |
> +				   ((phy_addr & HW_ATL_MDIO_PHY_ADDRESS_MSK) <<
> +				    HW_ATL_MDIO_PHY_ADDRESS_SHIFT));
> +
> +	aq_mdio_busy_wait(aq_hw);
> +
> +	hw_atl_glb_mdio_iface3_set(aq_hw, (data & HW_ATL_MDIO_WRITE_DATA_MSK) <<
> +				   HW_ATL_MDIO_WRITE_DATA_SHIFT);
> +	/* Send Write command. */
> +	hw_atl_glb_mdio_iface2_set(aq_hw, HW_ATL_MDIO_EXECUTE_OPERATION_MSK |
> +				   (2 << HW_ATL_MDIO_OP_MODE_SHIFT) |
> +				   ((phy_addr & HW_ATL_MDIO_PHY_ADDRESS_MSK) <<
> +				    HW_ATL_MDIO_PHY_ADDRESS_SHIFT));
> +
> +	aq_mdio_busy_wait(aq_hw);
> +}
> +
> +u16 aq_phy_read_reg(struct aq_hw_s *aq_hw, u16 mmd, u16 address)
> +{
> +	int err = 0;
> +	u32 val;
> +
> +	err = readx_poll_timeout_atomic(hw_atl_sem_mdio_get, aq_hw,
> +					val, val == 1U, 10U, 100000U);
> +
> +	if (err < 0) {
> +		err = 0xffff;
> +		goto err_exit;
> +	}
> +
> +	err = aq_mdio_read_word(aq_hw, mmd, address);
> +
> +	hw_atl_reg_glb_cpu_sem_set(aq_hw, 1U, HW_ATL_FW_SM_MDIO);
> +
> +err_exit:
> +	return err;
> +}
> +
> +void aq_phy_write_reg(struct aq_hw_s *aq_hw, u16 mmd, u16 address, u16 data)
> +{
> +	int err = 0;
> +	u32 val;
> +
> +	err = readx_poll_timeout_atomic(hw_atl_sem_mdio_get, aq_hw,
> +					val, val == 1U, 10U, 100000U);
> +	if (err < 0)
> +		return;
> +
> +	aq_mdio_write_word(aq_hw, mmd, address, data);
> +	hw_atl_reg_glb_cpu_sem_set(aq_hw, 1U, HW_ATL_FW_SM_MDIO);
> +}

You have here the code needed to implement a real Linux MDIO bus
driver. Are the MDIO pins exposed? Could somebody combine the chip
with say a Marvell Ethernet switch? You then need access to the MDIO
bus to control the switch. So by using a Linux MDIO bus driver, you
make it easy for somebody to do that. You can keep with your firmware
mostly driving the PHY.

> +
> +bool aq_phy_init_phy_id(struct aq_hw_s *aq_hw)
> +{
> +	u16 val;
> +
> +	for (aq_hw->phy_id = 0; aq_hw->phy_id < HW_ATL_PHY_ID_MAX;
> +	     ++aq_hw->phy_id) {
> +		/* PMA Standard Device Identifier 2: Address 1.3 */
> +		val = aq_phy_read_reg(aq_hw, MDIO_MMD_PMAPMD, 3);
> +
> +		if (val != 0xffff)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
> +bool aq_phy_init(struct aq_hw_s *aq_hw)
> +{
> +	u32 dev_id;
> +
> +	if (aq_hw->phy_id == HW_ATL_PHY_ID_MAX)
> +		if (!aq_phy_init_phy_id(aq_hw))
> +			return false;
> +
> +	/* PMA Standard Device Identifier:
> +	 * Address 1.2 = MSW,
> +	 * Address 1.3 = LSW
> +	 */
> +	dev_id = aq_phy_read_reg(aq_hw, MDIO_MMD_PMAPMD, 2);
> +	dev_id <<= 16;
> +	dev_id |= aq_phy_read_reg(aq_hw, MDIO_MMD_PMAPMD, 3);
> +
> +	if (dev_id == 0xffffffff) {
> +		aq_hw->phy_id = HW_ATL_PHY_ID_MAX;
> +		return false;
> +	}

For future proofing, should you not check it is actually one of your
PHYs?

Thanks
	Andrew
