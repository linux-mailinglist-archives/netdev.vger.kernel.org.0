Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C10DDDB989
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 00:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438272AbfJQWLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 18:11:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51616 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727050AbfJQWLF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 18:11:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sz6zQ8Mb9YB2sNXIi/B27RoIpiviOG0/Q0D9+81o9Dg=; b=J4GTqHSggiwchqgrExNR31pG34
        uGZhO0IJz0QeiV9dBzXQR5P7t+fLawYPQdggqmtI5u5kKktt+BpVrYhTnmaVO0ksRj9jq/qH8gWkO
        c8p1SIc7mEFBQnx6srZxwVpSulO4qVLyMgC9+nPI72sqKmQI5/CUN/iqEObJCIlPPnck=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iLDz3-0006pz-Tg; Fri, 18 Oct 2019 00:11:01 +0200
Date:   Fri, 18 Oct 2019 00:11:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>, hkallweit1@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, olteanv@gmail.com,
        rmk+kernel@armlinux.org.uk, cphealy@gmail.com,
        Jose Abreu <joabreu@synopsys.com>
Subject: Re: [PATCH net-next v2 2/2] net: phy: Add ability to debug RGMII
 connections
Message-ID: <20191017221101.GB24810@lunn.ch>
References: <20191017214453.18934-1-f.fainelli@gmail.com>
 <20191017214453.18934-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017214453.18934-3-f.fainelli@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If all is well, we stop iterating over all possible RGMII combinations
> and offer the one that is deemed suitable which is what an user should
> be trying by configuring the platform appropriately.

Hi Florian

This is no longer true. You now iterate over all modes.

> +int phy_rgmii_debug_probe(struct phy_device *phydev)
> +{

> +	/* Now probe all modes */
> +	for (i = 0; i < ARRAY_SIZE(rgmii_modes); i++) {
> +		ret = phy_rgmii_probe_interface(priv, rgmii_modes[i]);
> +		if (ret == 0)
> +			netdev_info(ndev, "Determined \"%s\" to be correct\n",
> +				    phy_modes(rgmii_modes[i]));
> +	}

I see two different use cases for this code.

1) Find the right mode

2) Test if the PHY driver is doing the right thing with different
modes.

You are concentrating more on the first, but i think the second is
also important. I think we can give the novice user a few more
guidelines. We can count the number of modes which work. If that count
!= 1, we know we have a driver problem. We should ask the user to
report the problem, including details of the MAC and PHY driver.

       Andrew
