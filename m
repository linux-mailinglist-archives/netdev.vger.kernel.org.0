Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF8C318291
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 01:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhBKAVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 19:21:16 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33874 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229669AbhBKAVN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 19:21:13 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9zie-005Qrv-Ck; Thu, 11 Feb 2021 01:20:28 +0100
Date:   Thu, 11 Feb 2021 01:20:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, Luka Perkov <luka.perkov@sartura.hr>
Subject: Re: [PATCH v2 net-next 3/4] net: phy: Add Qualcomm QCA807x driver
Message-ID: <YCR4TNHYjxmROPe2@lunn.ch>
References: <20210210125523.2146352-1-robert.marko@sartura.hr>
 <20210210125523.2146352-4-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210125523.2146352-4-robert.marko@sartura.hr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int qca807x_psgmii_config(struct phy_device *phydev)
> +{
> +	struct device_node *node = phydev->mdio.dev.of_node;
> +	int psgmii_az, tx_amp, ret = 0;
> +	u32 tx_driver_strength_dt;
> +
> +	/* Workaround to enable AZ transmitting ability */
> +	if (of_property_read_bool(node, "qcom,psgmii-az")) {
> +		psgmii_az = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, PSGMII_MODE_CTRL);
> +		psgmii_az &= ~PSGMII_MODE_CTRL_AZ_WORKAROUND_MASK;
> +		psgmii_az |= FIELD_PREP(PSGMII_MODE_CTRL_AZ_WORKAROUND_MASK, 0xc);
> +		ret = phy_write_mmd(phydev, MDIO_MMD_PMAPMD, PSGMII_MODE_CTRL, psgmii_az);
> +		psgmii_az = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, PSGMII_MODE_CTRL);
> +	}
> +
> +	/* PSGMII/QSGMII TX amp set to DT defined value instead of default 600mV */
> +	if (!of_property_read_u32(node, "qcom,tx-driver-strength", &tx_driver_strength_dt)) {
> +		int tx_driver_strength;
> +
> +		switch (tx_driver_strength_dt) {
> +		case 140:
> +			tx_driver_strength = 0;
> +			break;
> +		case 160:
> +			tx_driver_strength = 1;
> +			break;
> +		case 180:
> +			tx_driver_strength = 2;
> +			break;
> +		case 200:
> +			tx_driver_strength = 3;
> +			break;
> +		case 220:
> +			tx_driver_strength = 4;
> +			break;
> +		case 240:
> +			tx_driver_strength = 5;
> +			break;
> +		case 260:
> +			tx_driver_strength = 6;
> +			break;
> +		case 280:
> +			tx_driver_strength = 7;
> +			break;
> +		case 300:
> +			tx_driver_strength = 8;
> +			break;
> +		case 320:
> +			tx_driver_strength = 9;
> +			break;
> +		case 400:
> +			tx_driver_strength = 10;
> +			break;
> +		case 500:
> +			tx_driver_strength = 11;
> +			break;
> +		case 600:
> +			tx_driver_strength = 12;
> +			break;
> +		default:
> +			tx_driver_strength = 12;
> +			break;

Please return -EINVAL here. The value in DT is not valid, so you
should error out. If there is no value at all, then it is O.K. to
default to 12.

     Andrew
