Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7D8215FFE5
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 19:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgBOS4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 13:56:41 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47918 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbgBOS4g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 13:56:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sTrrSaNiKEriqCui8iDv1CgMwzwZVOaJgr4nhQNQwKs=; b=2zlQhSfvqYjYmO9qK5MBSW+W1Q
        /1iub/Y8hjHYx5TWUKFlytjEyKBoW0ov8yz8DFoczNZsOZIaymmFXHl6XlPrfB8FmR6QXUnTCQHMK
        2bbm8SybkN9Rf4GlLYYxWMyJe7C37Duy/DQjYPVk7QUVn+Noq8bq1FHDbwdUU4TxGNTo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j32cC-00059z-AO; Sat, 15 Feb 2020 19:56:32 +0100
Date:   Sat, 15 Feb 2020 19:56:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 03/10] net: add linkmode helper for setting flow
 control advertisement
Message-ID: <20200215185632.GT31084@lunn.ch>
References: <20200215154839.GR25745@shell.armlinux.org.uk>
 <E1j2zhE-0003XA-E4@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1j2zhE-0003XA-E4@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 15, 2020 at 03:49:32PM +0000, Russell King wrote:
> Add a linkmode helper to set the flow control advertisement in an
> ethtool linkmode mask according to the tx/rx capabilities. This
> implementation is moved from phylib, and documented with an
> analysis of its shortcomings.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/linkmode.c   | 51 ++++++++++++++++++++++++++++++++++++
>  drivers/net/phy/phy_device.c | 17 +-----------
>  include/linux/linkmode.h     |  2 ++
>  3 files changed, 54 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/phy/linkmode.c b/drivers/net/phy/linkmode.c
> index 969918795228..f60560fe3499 100644
> --- a/drivers/net/phy/linkmode.c
> +++ b/drivers/net/phy/linkmode.c
> @@ -42,3 +42,54 @@ void linkmode_resolve_pause(const unsigned long *local_adv,
>  	}
>  }
>  EXPORT_SYMBOL_GPL(linkmode_resolve_pause);
> +
> +/**
> + * linkmode_set_pause - set the pause mode advertisement
> + * @advertisement: advertisement in ethtool format
> + * @tx: boolean from ethtool struct ethtool_pauseparam tx_pause member
> + * @rx: boolean from ethtool struct ethtool_pauseparam rx_pause member
> + *
> + * Configure the advertised Pause and Asym_Pause bits according to the
> + * capabilities of provided in @tx and @rx.
> + *
> + * We convert as follows:
> + *  tx rx  Pause AsymDir
> + *  0  0   0     0
> + *  0  1   1     1
> + *  1  0   0     1
> + *  1  1   1     0
> + *
> + * Note: this translation from ethtool tx/rx notation to the advertisement
> + * is actually very problematical. Here are some examples:
> + *
> + * For tx=0 rx=1, meaning transmit is unsupported, receive is supported:
> + *
> + *  Local device  Link partner
> + *  Pause AsymDir Pause AsymDir Result
> + *    1     1       1     0     TX + RX - but we have no TX support.
> + *    1     1       0     1	Only this gives RX only
> + *
> + * For tx=1 rx=1, meaning we have the capability to transmit and receive
> + * pause frames:
> + *
> + *  Local device  Link partner
> + *  Pause AsymDir Pause AsymDir Result
> + *    1     0       0     1     Disabled - but since we do support tx and rx,
> + *				this should resolve to RX only.
> + *
> + * Hence, asking for:
> + *  rx=1 tx=0 gives Pause+AsymDir advertisement, but we may end up
> + *            resolving to tx+rx pause or only rx pause depending on
> + *            the partners advertisement.
> + *  rx=0 tx=1 gives AsymDir only, which will only give tx pause if
> + *            the partners advertisement allows it.
> + *  rx=1 tx=1 gives Pause only, which will only allow tx+rx pause
> + *            if the other end also advertises Pause.
> + */

It is good to document this.

With the change to netlink ethtool, we have the option to change the
interface to user space, or at least, easily add another way for
userspace to configure things. Maybe you can think of a better API?

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
