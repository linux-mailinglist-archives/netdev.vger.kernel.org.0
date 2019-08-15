Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 136278EFD6
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 17:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbfHOP4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 11:56:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35168 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728808AbfHOP4Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 11:56:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ov7dPyabCyiRcxel7x3yzFfHip1TotcljD9mwn6rrvQ=; b=pjoQK+i9+56Wg2QY0g85OQTTFN
        Twouk/kyM8bguCSsUW8j/Ns7mmDT804se1M7CBUDk2PZ73nQR7Tpf+5AzCzDRJUP2k3o5LQ6/PKZU
        cyPloMbVJbU0yNQfwWiRUK8IOLyuTcZ9s1S1tdj2W0feZborseTtmMyAfgFkO+ZHdI5o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hyI6n-0001fl-5z; Thu, 15 Aug 2019 17:56:13 +0200
Date:   Thu, 15 Aug 2019 17:56:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Herber <christian.herber@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/1] Added BASE-T1 PHY support to PHY Subsystem
Message-ID: <20190815155613.GE15291@lunn.ch>
References: <20190815153209.21529-1-christian.herber@nxp.com>
 <20190815153209.21529-2-christian.herber@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815153209.21529-2-christian.herber@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 03:32:29PM +0000, Christian Herber wrote:
> BASE-T1 is a category of Ethernet PHYs.
> They use a single copper pair for transmission.
> This patch add basic support for this category of PHYs.
> It coveres the discovery of abilities and basic configuration.
> It includes setting fixed speed and enabling auto-negotiation.
> BASE-T1 devices should always Clause-45 managed.
> Therefore, this patch extends phy-c45.c.
> While for some functions like auto-neogtiation different registers are
> used, the layout of these registers is the same for the used fields.
> Thus, much of the logic of basic Clause-45 devices can be reused.
> 
> Signed-off-by: Christian Herber <christian.herber@nxp.com>
> ---
>  drivers/net/phy/phy-c45.c    | 113 +++++++++++++++++++++++++++++++----
>  drivers/net/phy/phy-core.c   |   4 +-
>  include/uapi/linux/ethtool.h |   2 +
>  include/uapi/linux/mdio.h    |  21 +++++++
>  4 files changed, 129 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
> index b9d4145781ca..9ff0b8c785de 100644
> --- a/drivers/net/phy/phy-c45.c
> +++ b/drivers/net/phy/phy-c45.c
> @@ -8,13 +8,23 @@
>  #include <linux/mii.h>
>  #include <linux/phy.h>
>  
> +#define IS_100BASET1(phy) (linkmode_test_bit( \
> +			   ETHTOOL_LINK_MODE_100baseT1_Full_BIT, \
> +			   (phy)->supported))
> +#define IS_1000BASET1(phy) (linkmode_test_bit( \
> +			    ETHTOOL_LINK_MODE_1000baseT1_Full_BIT, \
> +			    (phy)->supported))

Hi Christian

We already have the flag phydev->is_gigabit_capable. Maybe add a flag
phydev->is_t1_capable

> +
> +static u32 get_aneg_ctrl(struct phy_device *phydev);
> +static u32 get_aneg_stat(struct phy_device *phydev);

No forward declarations please. Put the code in the right order so
they are not needed.

Thanks

     Andrew
