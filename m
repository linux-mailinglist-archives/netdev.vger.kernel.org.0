Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58DE69AC88
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 14:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjBQNao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 08:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjBQNaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 08:30:39 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1D666CD9;
        Fri, 17 Feb 2023 05:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ghnU0ZisXZwh5VkS5q4Fkuz7lysLPnv7IV/sFE3i7oM=; b=Q7yCstmIqDKO0f5KFR6g0BnjLz
        JUb3twezKpteyvOG4dFxFB/gU6A76MARZfY91zVvinXpo1YtZIDeHnfxRJ7BWiRcx4knTsBksF6Iv
        3kLorPWyLMKPq6vj8PgEPxGf8rvbEWeO8Rafh2YmGacwDhIODBkR4qtwaNufMukwxOcIhRayoYqsx
        uR/Bb2OpywoW+QoV3ZqK7vAojlMvNrE1HXD5KLW3HsB6U2zAHk0RZsxRti4kPoqGBwm29NU/vL4aG
        XoDgqnj02bQZaBwm7dUleb6m3ulKKfjH9qoEzRJIbDlcZ4S+9l3t70TttRk6rRlHYXZ6Fmy4tGyHS
        DhxLfaqg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48612)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pT0oS-00010B-FM; Fri, 17 Feb 2023 13:30:08 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pT0oQ-0006q7-Eh; Fri, 17 Feb 2023 13:30:06 +0000
Date:   Fri, 17 Feb 2023 13:30:06 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        richardcochran@gmail.com
Subject: Re: [PATCH net-next] net: phy: micrel: Add support for PTP_PF_PEROUT
 for lan8841
Message-ID: <Y++BXkdXO8oysQ8M@shell.armlinux.org.uk>
References: <20230217075213.2366042-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217075213.2366042-1-horatiu.vultur@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 08:52:13AM +0100, Horatiu Vultur wrote:
> +static void lan8841_ptp_perout_off(struct kszphy_ptp_priv *ptp_priv, int pin)
> +{
> +	struct phy_device *phydev = ptp_priv->phydev;
> +	u16 tmp;
> +
> +	tmp = phy_read_mmd(phydev, 2, LAN8841_GPIO_EN) & LAN8841_PTP_GPIO_MASK;
> +	tmp &= ~BIT(pin);
> +	phy_write_mmd(phydev, 2, LAN8841_GPIO_EN, tmp);

Problem 1: doesn't check the return value of phy_read_mmd(), so a
spurious error results in an error code written back to the register.

Issue 2: please use phy_modify_mmd() and definitions for the MMD. It
probably also makes sense to cache the mask. Thus, this whole thing
becomes:

	u16 mask = ~(LAN8841_PTP_GPIO_MASK | BIT(pin));

	phy_modify_mmd(phydev, MDIO_MMD_WIS, LAN8841_GPIO_EN, mask, 0);
	phy_modify_mmd(phydev, MDIO_MMD_WIS, LAN8841_GPIO_DIR, mask, 0);
	phy_modify_mmd(phydev, MDIO_MMD_WIS, LAN8841_GPIO_BUF, mask, 0);

although I'm not sure why you need to mask off bits 15:11.

> +
> +	tmp = phy_read_mmd(phydev, 2, LAN8841_GPIO_DIR) & LAN8841_PTP_GPIO_MASK;
> +	tmp &= ~BIT(pin);
> +	phy_write_mmd(phydev, 2, LAN8841_GPIO_DIR, tmp);
> +
> +	tmp = phy_read_mmd(phydev, 2, LAN8841_GPIO_BUF) & LAN8841_PTP_GPIO_MASK;
> +	tmp &= ~BIT(pin);
> +	phy_write_mmd(phydev, 2, LAN8841_GPIO_BUF, tmp);
> +}
> +
> +static void lan8841_ptp_perout_on(struct kszphy_ptp_priv *ptp_priv, int pin)
> +{
> +	struct phy_device *phydev = ptp_priv->phydev;
> +	u16 tmp;
> +
> +	tmp = phy_read_mmd(phydev, 2, LAN8841_GPIO_EN) & LAN8841_PTP_GPIO_MASK;
> +	tmp |= BIT(pin);
> +	phy_write_mmd(phydev, 2, LAN8841_GPIO_EN, tmp);
> +
> +	tmp = phy_read_mmd(phydev, 2, LAN8841_GPIO_DIR) & LAN8841_PTP_GPIO_MASK;
> +	tmp |= BIT(pin);
> +	phy_write_mmd(phydev, 2, LAN8841_GPIO_DIR, tmp);
> +
> +	tmp = phy_read_mmd(phydev, 2, LAN8841_GPIO_BUF) & LAN8841_PTP_GPIO_MASK;
> +	tmp |= BIT(pin);
> +	phy_write_mmd(phydev, 2, LAN8841_GPIO_BUF, tmp);

Similar as above.

> +static void lan8841_ptp_remove_event(struct kszphy_ptp_priv *ptp_priv, int pin,
> +				     u8 event)
> +{
> +	struct phy_device *phydev = ptp_priv->phydev;
> +	u8 offset;
> +	u16 tmp;
> +
> +	/* Not remove pin from the event. GPIO_DATA_SEL1 contains the GPIO
> +	 * pins 0-4 while GPIO_DATA_SEL2 contains GPIO pins 5-9, therefore
> +	 * depending on the pin, it requires to read a different register
> +	 */
> +	if (pin < 5) {
> +		tmp = phy_read_mmd(phydev, 2, LAN8841_GPIO_DATA_SEL1);
> +		offset = pin;
> +	} else {
> +		tmp = phy_read_mmd(phydev, 2, LAN8841_GPIO_DATA_SEL2);
> +		offset = pin - 5;
> +	}
> +	tmp &= ~(LAN8841_GPIO_DATA_SEL_GPIO_DATA_SEL_EVENT_MASK << (3 * offset));
> +	if (pin < 5)
> +		phy_write_mmd(phydev, 2, LAN8841_GPIO_DATA_SEL1, tmp);
> +	else
> +		phy_write_mmd(phydev, 2, LAN8841_GPIO_DATA_SEL2, tmp);

This could be much simpler using phy_modify_mmd().

> +
> +	/* Disable the event */
> +	tmp = phy_read_mmd(phydev, 2, LAN8841_PTP_GENERAL_CONFIG);
> +	if (event == LAN8841_EVENT_A) {
> +		tmp &= ~LAN8841_PTP_GENERAL_CONFIG_LTC_EVENT_POL_A;
> +		tmp &= ~LAN8841_PTP_GENERAL_CONFIG_LTC_EVENT_A_MASK;
> +	} else {
> +		tmp &= ~LAN8841_PTP_GENERAL_CONFIG_LTC_EVENT_POL_A;
> +		tmp &= ~LAN8841_PTP_GENERAL_CONFIG_LTC_EVENT_A_MASK;
> +	}
> +	phy_write_mmd(phydev, 2, LAN8841_PTP_GENERAL_CONFIG, tmp);

Ditto... and the theme seems to continue throughout the rest of this
patch.

> +static int lan8841_ptp_perout(struct ptp_clock_info *ptp,
> +			      struct ptp_clock_request *rq, int on)
> +{
> +	struct kszphy_ptp_priv *ptp_priv = container_of(ptp, struct kszphy_ptp_priv,
> +							ptp_clock_info);
> +	struct phy_device *phydev = ptp_priv->phydev;
> +	struct timespec64 ts_on, ts_period;
> +	s64 on_nsec, period_nsec;
> +	int pulse_width;
> +	int pin;
> +
> +	if (rq->perout.flags & ~PTP_PEROUT_DUTY_CYCLE)
> +		return -EOPNOTSUPP;
> +
> +	pin = ptp_find_pin(ptp_priv->ptp_clock, PTP_PF_PEROUT, rq->perout.index);
> +	if (pin == -1 || pin >= LAN8841_PTP_GPIO_NUM)
> +		return -EINVAL;
> +
> +	if (!on) {
> +		lan8841_ptp_perout_off(ptp_priv, pin);
> +		lan8841_ptp_remove_event(ptp_priv, LAN8841_EVENT_A, pin);
> +		return 0;
> +	}
> +
> +	ts_on.tv_sec = rq->perout.on.sec;
> +	ts_on.tv_nsec = rq->perout.on.nsec;
> +	on_nsec = timespec64_to_ns(&ts_on);
> +
> +	ts_period.tv_sec = rq->perout.period.sec;
> +	ts_period.tv_nsec = rq->perout.period.nsec;
> +	period_nsec = timespec64_to_ns(&ts_period);
> +
> +	if (period_nsec < 200) {
> +		phydev_warn(phydev,
> +			    "perout period too small, minimum is 200 nsec\n");

I'm not sure using the kernel log to print such things is a good idea,
especially without rate limiting.

> @@ -3874,7 +4220,24 @@ static int lan8841_probe(struct phy_device *phydev)
>  	priv = phydev->priv;
>  	ptp_priv = &priv->ptp_priv;
>  
> +	ptp_priv->pin_config = devm_kmalloc_array(&phydev->mdio.dev,
> +						  LAN8841_PTP_GPIO_NUM,
> +						  sizeof(*ptp_priv->pin_config),
> +						  GFP_KERNEL);

devm_kcalloc() to avoid the memset() below?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
