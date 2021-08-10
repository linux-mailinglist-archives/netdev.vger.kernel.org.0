Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666BF3E5580
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 10:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236689AbhHJIdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 04:33:46 -0400
Received: from mga14.intel.com ([192.55.52.115]:14775 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229564AbhHJIdo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 04:33:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="214590714"
X-IronPort-AV: E=Sophos;i="5.84,309,1620716400"; 
   d="scan'208";a="214590714"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2021 01:33:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,309,1620716400"; 
   d="scan'208";a="483961752"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga008.fm.intel.com with ESMTP; 10 Aug 2021 01:33:17 -0700
Received: from linux.intel.com (vwong3-iLBPG3.png.intel.com [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 8C3CD580922;
        Tue, 10 Aug 2021 01:33:15 -0700 (PDT)
Date:   Tue, 10 Aug 2021 16:33:12 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/1] net: dsa: sja1105: fix error handling on NULL
 returned by xpcs_create()
Message-ID: <20210810083312.GA30383@linux.intel.com>
References: <20210810063513.1757614-1-vee.khee.wong@linux.intel.com>
 <20210810082528.rff3aembgge62pd6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810082528.rff3aembgge62pd6@skbuf>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 08:25:29AM +0000, Vladimir Oltean wrote:
> Hi VK,
> 
> On Tue, Aug 10, 2021 at 02:35:13PM +0800, Wong Vee Khee wrote:
> > There is a possibility xpcs_create() returned a NULL and this is not
> > handled properly in the sja1105 driver.
> > 
> > Fixed this by using IS_ERR_ON_NULL() instead of IS_ERR().
> > 
> > Fixes: 3ad1d171548e ("net: dsa: sja1105: migrate to xpcs for SGMII")
> > Cc: Vladimir Olten <vladimir.oltean@nxp.com>
> > Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> > ---
> >  drivers/net/dsa/sja1105/sja1105_mdio.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
> > index 19aea8fb76f6..2c69a759ce6e 100644
> > --- a/drivers/net/dsa/sja1105/sja1105_mdio.c
> > +++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
> > @@ -438,7 +438,7 @@ static int sja1105_mdiobus_pcs_register(struct sja1105_private *priv)
> >  		}
> >  
> >  		xpcs = xpcs_create(mdiodev, priv->phy_mode[port]);
> > -		if (IS_ERR(xpcs)) {
> > +		if (IS_ERR_OR_NULL(xpcs)) {
> >  			rc = PTR_ERR(xpcs);
> >  			goto out_pcs_free;
> >  		}
> > -- 
> > 2.25.1
> > 
> 
> I think posting to 'net' is a bit drastic for this patch. I agree it is
> an issue but it has bothered absolutely nobody so far, and if sending
> this patch to 'net' means you'll be blocked with your patches until the
> 'net'->'net-next' merge, I'm not sure it's worth it.
>

Sounds reasonable for me. I will marked V2 to target net-next.
 
> Anyway, I don't think that PTR_ERR(xpcs) does the right thing when
> IS_NULL(xpcs). So how about you make this change:
> 
> -----------------------------[ cut here ]-----------------------------
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> index a5d150c5f3d8..ca12bf986d4d 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> @@ -415,7 +415,7 @@ int stmmac_xpcs_setup(struct mii_bus *bus)
>  			continue;
>  
>  		xpcs = xpcs_create(mdiodev, mode);
> -		if (IS_ERR_OR_NULL(xpcs)) {
> +		if (IS_ERR(xpcs)) {
>  			mdio_device_free(mdiodev);
>  			continue;
>  		}
> diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
> index 63fda3fc40aa..4bd61339823c 100644
> --- a/drivers/net/pcs/pcs-xpcs.c
> +++ b/drivers/net/pcs/pcs-xpcs.c
> @@ -1089,7 +1089,7 @@ struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
>  
>  	xpcs = kzalloc(sizeof(*xpcs), GFP_KERNEL);
>  	if (!xpcs)
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
>  
>  	xpcs->mdiodev = mdiodev;
>  
> -----------------------------[ cut here ]-----------------------------
