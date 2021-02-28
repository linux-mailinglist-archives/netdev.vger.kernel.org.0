Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83FDF327449
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 21:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhB1UBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 15:01:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:51658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230167AbhB1UBJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Feb 2021 15:01:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AE2F64E31;
        Sun, 28 Feb 2021 20:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614542428;
        bh=5q3YS68bOwuJKSB/PWYD733stmRtwFoTtqdDdWLahdQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fYcWAXHFvfqoyra/riTilY5g83xDLeGSJCMsMsb3TlrQtjtGD2SsroYb4g4vdGbBd
         iVIbaja0GYun0qbuXebhPWCtaVJhh/u3gWx1L9chMe4UOH7rK48Dtc66ZJVQa3QxRi
         7o4LmE06M9Z/FrE2SSY71nNPtQ7hlDlkZwbK5ygpnBg4crjIenF66PURTt1oCz2va3
         2nyT96kV8y7qW3mc8HeqGJJVqBS0jRWFvfscOUNSs4347oZJbZsDqhF96rE6R+5Tbf
         vt7Uafw7AmGMMQa14/2H82KJdYJZEV2ToH/iXykL4jQOUUOEeHV4+/MGKrwRPFHCcy
         367Wu8sY3UO8w==
Date:   Sun, 28 Feb 2021 12:00:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Sven Schuchmann <schuchmann@schleissheimer.de>
Subject: Re: [PATCH net] net: phy: ti: take into account all possible
 interrupt sources
Message-ID: <20210228120027.76488180@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210226153020.867852-1-ciorneiioana@gmail.com>
References: <20210226153020.867852-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Feb 2021 17:30:20 +0200 Ioana Ciornei wrote:
> diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
> index be1224b4447b..f7a2ec150e54 100644
> --- a/drivers/net/phy/dp83822.c
> +++ b/drivers/net/phy/dp83822.c
> @@ -290,6 +290,7 @@ static int dp83822_config_intr(struct phy_device *phydev)
>  
>  static irqreturn_t dp83822_handle_interrupt(struct phy_device *phydev)
>  {
> +	bool trigger_machine = false;
>  	int irq_status;
>  
>  	/* The MISR1 and MISR2 registers are holding the interrupt status in
> @@ -305,7 +306,7 @@ static irqreturn_t dp83822_handle_interrupt(struct phy_device *phydev)
>  		return IRQ_NONE;
>  	}
>  	if (irq_status & ((irq_status & GENMASK(7, 0)) << 8))
> -		goto trigger_machine;
> +		trigger_machine = true;
>  
>  	irq_status = phy_read(phydev, MII_DP83822_MISR2);
>  	if (irq_status < 0) {
> @@ -313,11 +314,11 @@ static irqreturn_t dp83822_handle_interrupt(struct phy_device *phydev)
>  		return IRQ_NONE;
>  	}
>  	if (irq_status & ((irq_status & GENMASK(7, 0)) << 8))
> -		goto trigger_machine;
> +		trigger_machine = true;
>  
> -	return IRQ_NONE;
> +	if (!trigger_machine)
> +		return IRQ_NONE;
>  
> -trigger_machine:
>  	phy_trigger_machine(phydev);
>  
>  	return IRQ_HANDLED;

Would it be better to code it up as:

	irqreturn_t ret = IRQ_NONE;

	if (irq_status & ...)
		ret = IRQ_HANDLED;

	/* .. */

	if (ret != IRQ_NONE)
		phy_trigger_machine(phydev);

	return ret;

That reads a tiny bit better to me, but it's probably majorly
subjective so I'm happy with existing patch if you prefer it.
