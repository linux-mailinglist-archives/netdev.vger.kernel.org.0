Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BACCAA982
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 19:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390815AbfIEQ7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 12:59:54 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:49736 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728507AbfIEQ7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 12:59:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=X5UwKiV0EAfKocHoGuK5g2l4qyHfAtt7HoIzvyAXWSA=; b=WtxX3fE0Uyw2f5b4XVSLt+wIz
        qFCLxTnl56DKA5FNK2xcVKHI4eEMAN8z2unfeuhZrjlgrs+StxHpf6wqBuELm8DahSn+ZupIi1NKp
        2gORG5YFv5PCJV+hXeRDCXH8oYJbrmpHqeRhMr24zrWV7vSNQpiljq901rCcOy6nfnO7w6vOie/2X
        ICpBdn0nHpNr2EJtj2d8IAUe7BQKnjA4z1YkE1OopjohDVnG7P+m38U/EtkA4T9SlDYV8KhBbG/P8
        ntAFx+2yxjumH6lYSssEfJH3iBXHJZ8uclIgxBHa/LzTzsNbgB6Bv/DLlfBoZA1O+8ViFIVPQfyrj
        jH41PJwNQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40032)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1i5v6q-0003WW-0p; Thu, 05 Sep 2019 17:59:48 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1i5v6m-0005hy-3o; Thu, 05 Sep 2019 17:59:44 +0100
Date:   Thu, 5 Sep 2019 17:59:44 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     davem@davemloft.net, andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, shaulb@marvell.com,
        nadavh@marvell.com, ymarkman@marvell.com, marcin@marvell.com
Subject: Re: [PATCH] net: phylink: Fix flow control resolution
Message-ID: <20190905165943.GL13294@shell.armlinux.org.uk>
References: <1567701978-16056-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567701978-16056-1-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 05, 2019 at 07:46:18PM +0300, stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> Regarding to IEEE 802.3-2015 standard section 2
> 28B.3 Priority resolution - Table 28-3 - Pause resolution
> 
> In case of Local device Pause=1 AsymDir=0, Link partner
> Pause=1 AsymDir=1, Local device resolution should be enable PAUSE
> transmit, disable PAUSE receive.
> And in case of Local device Pause=1 AsymDir=1, Link partner
> Pause=1 AsymDir=0, Local device resolution should be enable PAUSE
> receive, disable PAUSE transmit.
> 
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> Reported-by: Shaul Ben-Mayor <shaulb@marvell.com>

Good catch, thanks for the patch.

Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
Fixes: 9525ae83959b ("phylink: add phylink infrastructure")

> ---
>  drivers/net/phy/phylink.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index a45c5de..a5a57ca 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -376,8 +376,8 @@ static void phylink_get_fixed_state(struct phylink *pl, struct phylink_link_stat
>   *  Local device  Link partner
>   *  Pause AsymDir Pause AsymDir Result
>   *    1     X       1     X     TX+RX
> - *    0     1       1     1     RX
> - *    1     1       0     1     TX
> + *    0     1       1     1     TX
> + *    1     1       0     1     RX
>   */
>  static void phylink_resolve_flow(struct phylink *pl,
>  				 struct phylink_link_state *state)
> @@ -398,7 +398,7 @@ static void phylink_resolve_flow(struct phylink *pl,
>  			new_pause = MLO_PAUSE_TX | MLO_PAUSE_RX;
>  		else if (pause & MLO_PAUSE_ASYM)
>  			new_pause = state->pause & MLO_PAUSE_SYM ?
> -				 MLO_PAUSE_RX : MLO_PAUSE_TX;
> +				 MLO_PAUSE_TX : MLO_PAUSE_RX;
>  	} else {
>  		new_pause = pl->link_config.pause & MLO_PAUSE_TXRX_MASK;
>  	}
> -- 
> 1.9.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
