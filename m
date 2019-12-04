Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB948112EC7
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 16:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbfLDPmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 10:42:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36832 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728324AbfLDPmb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 10:42:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pYIRrNUJ71hfV0xdZn8g7ojj1OdsBo6oYX8md6hF2ik=; b=tB1V65KqhCCg+UG1LGXf5pKlzt
        cMl6UfKGw6sAtii9rXHET8caV1yEB4AXeQxed9a44OoBT8iAznBAkpbDikgxcRuU4jHFcNiA/ScOZ
        F7237hANCh2e14sdTceiNj43tqKvm29rDPt3UNGN/G5h5UHHo/N820XMxvMvNkqmoSsA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1icWnI-0002fC-KH; Wed, 04 Dec 2019 16:42:24 +0100
Date:   Wed, 4 Dec 2019 16:42:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mian Yousaf Kaukab <ykaukab@suse.de>
Cc:     netdev@vger.kernel.org, rric@kernel.org, tharvey@gateworks.com,
        linux-kernel@vger.kernel.org, sgoutham@cavium.com,
        davem@davemloft.net, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: thunderx: start phy before starting autonegotiation
Message-ID: <20191204154224.GE21904@lunn.ch>
References: <20191204152651.13418-1-ykaukab@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204152651.13418-1-ykaukab@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 04, 2019 at 04:26:51PM +0100, Mian Yousaf Kaukab wrote:
> Since "2b3e88ea6528 net: phy: improve phy state checking"
> phy_start_aneg() expects phy state to be >= PHY_UP. Call phy_start()
> before calling phy_start_aneg() during probe so that autonegotiation
> is initiated.
> 
> Network fails without this patch on Octeon TX.
> 
> Signed-off-by: Mian Yousaf Kaukab <ykaukab@suse.de>
> ---
>  drivers/net/ethernet/cavium/thunder/thunder_bgx.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
> index 1e09fdb63c4f..504644257aff 100644
> --- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
> +++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
> @@ -1115,6 +1115,7 @@ static int bgx_lmac_enable(struct bgx *bgx, u8 lmacid)
>  				       phy_interface_mode(lmac->lmac_type)))
>  			return -ENODEV;
>  
> +		phy_start(lmac->phydev);
>  		phy_start_aneg(lmac->phydev);
>  		return 0;

phy_start() will start aneg, if aneg is configured. So you should be
able to remove the call to phy_start_aneg().

     Andrew
