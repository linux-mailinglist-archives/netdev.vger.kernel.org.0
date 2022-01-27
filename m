Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0575B49EDF0
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 23:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237142AbiA0WIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 17:08:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58772 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235693AbiA0WIY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 17:08:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Y9EU687a9UwzFTfloNqKuncj4i6DFJQQyO6iIyxPciM=; b=5Lc1tpNKJspzXG1ecOiGZCt2e7
        BwkSsyWhYL0lS0DAJBBzRIggLLfckSHg+WfLdehKZHfG6gMU9YGsNfMMCWdycWpbtXdvLP3ApNEaE
        ZmXCFjyADHzlguzJ4iN+8BhvsS3WVFUthVVU6ZFdva6tzM8M1rFG6XydIqUyojDefgt4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nDCwI-0033QT-27; Thu, 27 Jan 2022 23:08:22 +0100
Date:   Thu, 27 Jan 2022 23:08:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 4/5] net: lan743x: Add support of selection
 between SGMII and GMII Interface
Message-ID: <YfMX1ob3+1RT+d8/@lunn.ch>
References: <20220127173055.308918-1-Raju.Lakkaraju@microchip.com>
 <20220127173055.308918-5-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127173055.308918-5-Raju.Lakkaraju@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	/* GPY211 Interface enable */
> +	chip_ver = lan743x_csr_read(adapter, FPGA_REV);
> +	if (chip_ver) {
> +		netif_info(adapter, drv, adapter->netdev,
> +			   "FPGA Image version: 0x%08X\n", chip_ver);

We try to avoid spamming the kernel logs, so:

netif_dbg()

> +		if (chip_ver & FPGA_SGMII_OP) {
> +			sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);
> +			sgmii_ctl |= SGMII_CTL_SGMII_ENABLE_;
> +			sgmii_ctl &= ~SGMII_CTL_SGMII_POWER_DN_;
> +			lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
> +			netif_info(adapter, drv, adapter->netdev, "SGMII operation\n");
> +		} else {
> +			sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);
> +			sgmii_ctl &= ~SGMII_CTL_SGMII_ENABLE_;
> +			sgmii_ctl |= SGMII_CTL_SGMII_POWER_DN_;
> +			lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
> +			netif_info(adapter, drv, adapter->netdev, "GMII operation\n");
> +		}
> +	} else {
> +		chip_ver = lan743x_csr_read(adapter, STRAP_READ);
> +		netif_info(adapter, drv, adapter->netdev,
> +			   "ASIC Image version: 0x%08X\n", chip_ver);

Here as well

> +		if (chip_ver & STRAP_READ_SGMII_EN_) {
> +			sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);
> +			sgmii_ctl |= SGMII_CTL_SGMII_ENABLE_;
> +			sgmii_ctl &= ~SGMII_CTL_SGMII_POWER_DN_;
> +			lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
> +			netif_info(adapter, drv, adapter->netdev, "SGMII operation\n");

And def initially this and the next one.

> +		} else {
> +			sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);
> +			sgmii_ctl &= ~SGMII_CTL_SGMII_ENABLE_;
> +			sgmii_ctl |= SGMII_CTL_SGMII_POWER_DN_;
> +			lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
> +			netif_info(adapter, drv, adapter->netdev, "GMII operation\n");
> +		}
> +	}

  Andrew
