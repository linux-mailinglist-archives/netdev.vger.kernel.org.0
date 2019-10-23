Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85DEDE1BCE
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 15:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405611AbfJWNKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 09:10:41 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:59654 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405591AbfJWNKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 09:10:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=sO/+tJUgxVQjrPnnyo261w6vrBpEsmB674LDfxhnhV4=; b=Er/6wopV0gx2Kcpr3YujZBfoJ
        ZEvNMJFeetO6+s0vz4FEK1ibmVW7J/bcSH2Yj5jdRTVWc2Fixm+Zowm51oK26abG0VHFe45QZeSG8
        8heq0hq76oW2zQG3MgwEeNK8K76CC7B2vrz7nebE/KjEsZCqVb+pyy/qOxU06LxofC+jbyl5T4LCq
        j3MsCG8LfSxvfWS1m6k+PSKn4yjyPZ6CyDig5fiMnfMbJ8DnhhTAKqTiCQKvVYd2Wq6ytQvqiDEUX
        6Fq6u+w2e1q3wd4XiF64NBY92ZJ8+7GQOLS2FyF0QtLFHUD1zELdz7sA41YY5F3aZxGmX7T/XpORW
        /kKCEnU6g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58078)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iNGPM-00053t-Bk; Wed, 23 Oct 2019 14:10:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iNGPI-0005Zk-Ef; Wed, 23 Oct 2019 14:10:32 +0100
Date:   Wed, 23 Oct 2019 14:10:32 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next] phylink: add ASSERT_RTNL() on phylink connect
 functions
Message-ID: <20191023131032.GZ25745@shell.armlinux.org.uk>
References: <1571833940-26250-1-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571833940-26250-1-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 03:32:20PM +0300, Ioana Ciornei wrote:
> The appropriate assert on the rtnl lock is not present in phylink's
> connect functions which makes unusual calls to them not to be catched.
> Add the appropriate ASSERT_RTNL().

As I previously replied, this is not necessary.  It is safe to attach
PHYs _prior_ to the netdev being registered without taking the rtnl
lock, just like phylib's phy_connect()/phy_attach() are safe.

> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
>  drivers/net/phy/phylink.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index be7a2c0fa59b..d0aa0c861b2d 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -786,6 +786,8 @@ static int __phylink_connect_phy(struct phylink *pl, struct phy_device *phy,
>   */
>  int phylink_connect_phy(struct phylink *pl, struct phy_device *phy)
>  {
> +	ASSERT_RTNL();
> +
>  	/* Use PHY device/driver interface */
>  	if (pl->link_interface == PHY_INTERFACE_MODE_NA) {
>  		pl->link_interface = phy->interface;
> @@ -815,6 +817,8 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
>  	struct phy_device *phy_dev;
>  	int ret;
>  
> +	ASSERT_RTNL();
> +
>  	/* Fixed links and 802.3z are handled without needing a PHY */
>  	if (pl->link_an_mode == MLO_AN_FIXED ||
>  	    (pl->link_an_mode == MLO_AN_INBAND &&
> -- 
> 1.9.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
