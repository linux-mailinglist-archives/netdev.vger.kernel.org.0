Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA6E24EDA5
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 16:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgHWO2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 10:28:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40480 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbgHWO2y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 10:28:54 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k9qz7-00BN35-V6; Sun, 23 Aug 2020 16:28:37 +0200
Date:   Sun, 23 Aug 2020 16:28:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sumera Priyadarsini <sylphrenadin@gmail.com>
Cc:     davem@davemloft.net, Julia.Lawall@lip6.fr, sean.wang@mediatek.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: Add of_node_put() before break statement
Message-ID: <20200823142837.GD2588906@lunn.ch>
References: <20200823140116.6606-1-sylphrenadin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200823140116.6606-1-sylphrenadin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 23, 2020 at 07:31:16PM +0530, Sumera Priyadarsini wrote:
> Every iteration of for_each_child_of_node() decrements
> the reference count of the previous node, however when control
> is transferred from the middle of the loop, as in the case of
> a return or break or goto, there is no decrement thus ultimately
> resulting in a memory leak.
> 
> Fix a potential memory leak in mt7530.c by inserting of_node_put()
> before the break statement.
> 
> Issue found with Coccinelle.
> 
> Signed-off-by: Sumera Priyadarsini <sylphrenadin@gmail.com>
> ---
>  drivers/net/dsa/mt7530.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 8dcb8a49ab67..af83e5034842 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -1334,6 +1334,7 @@ mt7530_setup(struct dsa_switch *ds)
>  				if (id == 4)
>  					priv->p5_intf_sel = P5_INTF_SEL_PHY_P4;
>  			}
> +			of_node_put(mac_np);
>  			of_node_put(phy_node);
>  			break;
>  		}

Within the same loop is:

                       if (phy_node->parent == priv->dev->of_node->parent) {
                                ret = of_get_phy_mode(mac_np, &interface);
                                if (ret && ret != -ENODEV)
                                        return ret;


shouldn't this also have a put?

	  Andrew
