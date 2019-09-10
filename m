Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81EDFAE4CA
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 09:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729638AbfIJHoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 03:44:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37334 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbfIJHoS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 03:44:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2oKSgZFqlyGhdjAQb6TuXzxf1Jr5gU3AbWxa6m49XdU=; b=OAP9ETSR8M0WS8oBIoazdmoQz6
        pL+Hh/1mlFx5dvEJky/+50P//Z4fp+q7pcNUMIxMOz5e1MIsA0GCHEaphUxyFjShzgN0QdShuxR3G
        8+LrN/+mz2AI60YM1mcvWCNzBwillJAZKzizFByCB+6azVTp+YOMO6mJLmv7POiHOwtY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i7aou-0008Gq-Ew; Tue, 10 Sep 2019 09:44:12 +0200
Date:   Tue, 10 Sep 2019 09:44:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/5] enetc: Fix if_mode extraction
Message-ID: <20190910074412.GA31298@lunn.ch>
References: <1567779344-30965-1-git-send-email-claudiu.manoil@nxp.com>
 <1567779344-30965-2-git-send-email-claudiu.manoil@nxp.com>
 <20190906195743.GD2339@lunn.ch>
 <VI1PR04MB48803DB044AB6CF66CACB89E96B70@VI1PR04MB4880.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB48803DB044AB6CF66CACB89E96B70@VI1PR04MB4880.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 09, 2019 at 04:24:01PM +0000, Claudiu Manoil wrote:
> >-----Original Message-----
> >From: Andrew Lunn <andrew@lunn.ch>
> >Sent: Friday, September 6, 2019 10:58 PM
> >To: Claudiu Manoil <claudiu.manoil@nxp.com>
> >Cc: David S . Miller <davem@davemloft.net>; Alexandru Marginean
> ><alexandru.marginean@nxp.com>; netdev@vger.kernel.org
> >Subject: Re: [PATCH net-next 1/5] enetc: Fix if_mode extraction
> >
> >On Fri, Sep 06, 2019 at 05:15:40PM +0300, Claudiu Manoil wrote:
> >> Fix handling of error return code. Before this fix,
> >> the error code was handled as unsigned type.
> >> Also, on this path if if_mode not found then just handle
> >> it as fixed link (i.e mac2mac connection).
> >>
> >> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> >> ---
> >>  drivers/net/ethernet/freescale/enetc/enetc_pf.c | 17 ++++++-----------
> >>  1 file changed, 6 insertions(+), 11 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> >b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> >> index 7d6513ff8507..3a556646a2fb 100644
> >> --- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> >> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> >> @@ -751,6 +751,7 @@ static int enetc_of_get_phy(struct enetc_ndev_priv
> >*priv)
> >>  	struct enetc_pf *pf = enetc_si_priv(priv->si);
> >>  	struct device_node *np = priv->dev->of_node;
> >>  	struct device_node *mdio_np;
> >> +	int phy_mode;
> >>  	int err;
> >>
> >>  	if (!np) {
> >> @@ -784,17 +785,11 @@ static int enetc_of_get_phy(struct enetc_ndev_priv
> >*priv)
> >>  		}
> >>  	}
> >>
> >> -	priv->if_mode = of_get_phy_mode(np);
> >> -	if (priv->if_mode < 0) {
> >> -		dev_err(priv->dev, "missing phy type\n");
> >> -		of_node_put(priv->phy_node);
> >> -		if (of_phy_is_fixed_link(np))
> >> -			of_phy_deregister_fixed_link(np);
> >> -		else
> >> -			enetc_mdio_remove(pf);
> >> -
> >> -		return -EINVAL;
> >> -	}
> >
> >Hi Claudiu
> >
> >It is not clear to me why it is no longer necessary to deregister the
> >fixed link, or remove the mdio bus?
> >
> >> +	phy_mode = of_get_phy_mode(np);
> >> +	if (phy_mode < 0)
> >> +		priv->if_mode = PHY_INTERFACE_MODE_NA; /* fixed link */
> >> +	else
> >> +		priv->if_mode = phy_mode;
> >
> 
> Hi Andrew,
> 
> The MAC2MAC connections are defined as fixed-link too, but without
> phy-mode/phy-connection-type properties.  We don't want to de-register
> these links.  Initial code was bogus in this regard.

Hi Claudiu

This is what is not clear in the change log. That this code is removed
because it is wrong. Please could you expand the explanation to make
this clearer.

> Current proposal is:
> 			ethernet@0,2 { /* SoC internal, connected to switch port 4 */
> 				compatible = "fsl,enetc";
> 				reg = <0x000200 0 0 0 0>;
> 				fixed-link {
> 					speed = <1000>;
> 					full-duplex;
> 				};
> 			};
> 			switch@0,5 {
> 				compatible = "mscc,felix-switch";
> 				[...]
> 				ports {
> 					#address-cells = <1>;
> 					#size-cells = <0>;
> 
> 					/* external ports */
> 					[...]
> 					/* internal SoC ports */
> 					port@4 { /* connected to ENETC port2 */
> 						reg = <4>;
> 						fixed-link {
> 							speed = <1000>;
> 							full-duplex;
> 						};
> 					};

So this connection between the SoC and the switch does not use tags?
Can it use tags? Does the hardware allow you to have two CPU ports,
and load balance over them?

This second half is just standard DSA. This looks good.

     Andrew



> 					port@5 { /* CPU port, connected to ENETC port3 */
> 						reg = <5>;
> 						ethernet = <&enetc_port3>;
> 						fixed-link {
> 							speed = <1000>;
> 							full-duplex;
> 						};
> 					};
> 				};
> 			};
> 			enetc_port3: ethernet@0,6 { /* SoC internal connected to switch port 5 */
> 				compatible = "fsl,enetc";
> 				reg = <0x000600 0 0 0 0>;
> 				fixed-link {
> 					speed = <1000>;
> 					full-duplex;
> 				};
> 			};
> 		};
> 
> Thanks.
> 
> Claudiu
