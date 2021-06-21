Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B423AF106
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 18:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbhFUQ41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 12:56:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47952 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233483AbhFUQy3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 12:54:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jaDryQKrGcLdUuIlHGlcHnVBpuzpZlL3j5CmdvJL+k4=; b=aWUR+/R5EO1aRCxQCNGCMZoRE4
        T4sp0dVTbrRIowJsEUvMopr0XmqD5ScuH7jZxGhfUmUCCRvmxHLyGtZFlxa4XmziuKEEnW6XW5+xb
        zYjin4yF5NkBvAO/63hV/d/mFfqVtThkyAkVvbIiveJ54BoxUN1YehSTCAmKebiDCBEQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lvN9R-00AXl6-E3; Mon, 21 Jun 2021 18:51:57 +0200
Date:   Mon, 21 Jun 2021 18:51:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Qing Zhang <zhangqing@loongson.cn>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: stmmac: pci: Add dwmac support for Loongson
Message-ID: <YNDDrQVuCjlWTEou@lunn.ch>
References: <37057fe8-f7d1-7ee0-01c7-916577526b5b@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37057fe8-f7d1-7ee0-01c7-916577526b5b@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 04:51:28PM +0100, Colin Ian King wrote:
> Hi,
> 
> Static analysis by Coverity on today's linux-next has found an issue in
> function loongson_dwmac_probe with the following commit:
> 
> commit 30bba69d7db40e732d6c0aa6d4890c60d717e314
> Author: Qing Zhang <zhangqing@loongson.cn>
> Date:   Fri Jun 18 10:53:34 2021 +0800
> 
>     stmmac: pci: Add dwmac support for Loongson
> 
> The analysis is as follows:
> 
> 110        plat->phy_interface = device_get_phy_mode(&pdev->dev);
> 
> Enum compared against 0
> (NO_EFFECT)
> unsigned_compare: This less-than-zero comparison of an
> unsigned value is never true. plat->phy_interface < 0U.
> 
> 111        if (plat->phy_interface < 0)
> 112                dev_err(&pdev->dev, "phy_mode not found\n");
> 
> Enum plat->phy_interface is unsigned, so can't be negative and so the
> comparison will always be false.
> 
> A possible fix is to use int variable ret for the assignment and check:
> 
> 
>         ret = device_get_phy_mode(&pdev->dev);
>         if (ret < 0)
>                 dev_err(&pdev->dev, "phy_mode not found\n");
>         plat->phy_interface = ret;
> 
> ..however, I think the dev_err may need handling too, e.g.
> 
>         ret = device_get_phy_mode(&pdev->dev);
>         if (ret < 0) {
>                 dev_err(&pdev->dev, "phy_mode not found\n");
> 		ret = -ENODEV;
> 		goto cleanup;		/* needs to be written */
> 	}
>         plat->phy_interface = ret;

Potentially a cleaner fix is to use of_get_phy_mode(), which separates
the success/error value from the phy_interface_t.

    Andrew
