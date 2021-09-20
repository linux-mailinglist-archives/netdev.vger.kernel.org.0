Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829464115FF
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 15:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239573AbhITNnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 09:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233575AbhITNnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 09:43:41 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C17C061574;
        Mon, 20 Sep 2021 06:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OH+GVeIdWaM8bBkd2TRp9ZRcX+WrRFhYL3tYwyLWkNA=; b=Vmy7EZ4gJpyBgHMkhiDI4D6tQn
        2cZxulJfBY9SbhZtdCy0RZK8B9ll5ravy32Idxqz1rJjkB1u8NNzT4psWza1dWZHZDaIgLUr6Fc6C
        bnAglaIe6lxAVKS0bS4KUB6aXVcP+VxNij2+PefTZANkpz13YCXYAZKpVD7MiyZ1Vgq4pWNEhABhE
        c+yVAbi08PCLM20tm/U43SwHi1Nw62OQkf/snmoi2fYBGXHSswwed4LgsOIb/KWMXaWdPbrCYvefw
        VQ0aVAFf5u5vLsK3C4E90/6f8C6pIwnllJHC5HzwentXAYBrN8a3gPOAUqM8tZ+w4wcrHp3FpUf3i
        XbsDyQaA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54670)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mSJYX-0001f9-SA; Mon, 20 Sep 2021 14:42:01 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mSJYW-0002L7-0w; Mon, 20 Sep 2021 14:42:00 +0100
Date:   Mon, 20 Sep 2021 14:42:00 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com,
        alexandre.belloni@bootlin.com, vladimir.oltean@nxp.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH net-next 03/12] phy: Add lan966x ethernet serdes PHY
 driver
Message-ID: <YUiPqJjsoBg99VbR@shell.armlinux.org.uk>
References: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
 <20210920095218.1108151-4-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920095218.1108151-4-horatiu.vultur@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 11:52:09AM +0200, Horatiu Vultur wrote:
> +static int lan966x_calc_sd6g40_setup_lane(struct lan966x_sd6g40_setup_args config,
> +					  struct lan966x_sd6g40_setup *ret_val)
> +{
> +	struct lan966x_sd6g40_mode_args sd6g40_mode;
> +	struct lan966x_sd6g40_mode_args *mode_args = &sd6g40_mode;
> +
> +	if (lan966x_sd6g40_get_conf_from_mode(config.mode, config.refclk125M,
> +					      mode_args))
> +		return -1;

This needs fixing to be a real negative error number.
lan966x_sd6g40_setup_lane() propagates this functions non-zero
return value, which is then propagated through lan966x_sd6g40_setup(),
and then through serdes_set_mode() to the PHY layer.

In general, I would suggest that _all_ int-returning functions in the
kernel that return a negative failure value _should_ _always_ return a
negative error code, so that your reviewers don't have to chase code
paths to work out whether a mistake such as the above exists.

To put it another way: never use "return -1" in the kernel.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
