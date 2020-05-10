Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06251CCB98
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 16:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbgEJOoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 10:44:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51984 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728340AbgEJOoM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 10:44:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ynGBwTLPPyTNSdc9hrNBnl0diqDYt7DdwR50R6Z/OxQ=; b=TsVdJFr3wsp39dCCyPrF30hOZu
        izx0P1jK1y/Jfdp9ennqA4xyz26xyrmudn4kXQc6RozfygfYupcY1nk1MSfsJ0U0Z4zOH8+5A3v2j
        XAELzO75bTBhwFb1IyjdAmCyNZ9ZPbz1FUKsBMAbPL1JVsH0YReTNTyBwYleIfMfF4l4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jXnBa-001iB4-JK; Sun, 10 May 2020 16:44:10 +0200
Date:   Sun, 10 May 2020 16:44:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 3/4] net: phy: broadcom: add cable test support
Message-ID: <20200510144410.GI362499@lunn.ch>
References: <20200509223714.30855-1-michael@walle.cc>
 <20200509223714.30855-4-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509223714.30855-4-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 10, 2020 at 12:37:13AM +0200, Michael Walle wrote:
> Most modern broadcom PHYs support ECD (enhanced cable diagnostics). Add
> support for it in the bcm-phy-lib so they can easily be used in the PHY
> driver.
> 
> There are two access methods for ECD: legacy by expansion registers and
> via the new RDB registers which are exclusive. Provide functions in two
> variants where the PHY driver can from. To keep things simple for now,

can from ?

> +static int bcm_phy_report_length(struct phy_device *phydev, int result,
> +				 int pair)
> +{
> +	int val;
> +
> +	val = __bcm_phy_read_exp(phydev,
> +				 BCM54XX_EXP_ECD_PAIR_A_LENGTH_RESULTS + pair);
> +	if (val < 0)
> +		return val;
> +
> +	if (val == BCM54XX_ECD_LENGTH_RESULTS_INVALID)
> +		return 0;
> +
> +	/* intra-pair shorts report twice the length */
> +	if (result == BCM54XX_ECD_FAULT_TYPE_CROSS_SHORT)
> +		val >>= 1;

You mentioned this before. This seems odd. The pulse travelled the
same distance as for an open or shorted cable. The whole of time
domain reflectrometry is based on some sort of echo and you always
need to device by two. So why this special case?

Florian, do you have access to any erratas? Is this maybe fixed in
other revisions/family members?

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
