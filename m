Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E629A18C414
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 01:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbgCTAGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 20:06:32 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:52060 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgCTAGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 20:06:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8qi+iV+fQQdTTexvzRrFrcQ8I1oKPDORa9Iph4ORAg4=; b=OkVIESTob/5h7hS0ujHkIKgxI
        tpeOP4/Kr5QINJ9AC91AUqubdzTjIN42PwyQQnTdtWkBQFzFPcmLR5sANmF7NOYemJN6N/pXwWl81
        z9NHbRNo9zttjzUmB77uHraLFASojAOSKPs8Dim44DoT6PNpLm4jFD/v30rcoFISTsi8lL+Elqi1/
        mkrVvxm2w68Fds2nsTqgxHdkFISZly2iO1/SN+p9/yYbb43pT3xOwRoNLa+SyDExz41gvIscjg8YF
        z7JNusKiforHCrtvJPl/u6Jcg3POWtzArCwSy1uIroX5ZGst3k/G+QqpiX/RoUks1zeqQp0YYLrKi
        ZN7m6Lo8w==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:55350)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jF5BC-0005A4-1J; Fri, 20 Mar 2020 00:06:26 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jF5B9-0005Ck-0k; Fri, 20 Mar 2020 00:06:23 +0000
Date:   Fri, 20 Mar 2020 00:06:22 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com
Subject: Re: [PATCH net-next] net: dsa: sja1105: Add support for the SGMII
 port
Message-ID: <20200320000622.GI25745@shell.armlinux.org.uk>
References: <20200319235313.26579-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319235313.26579-1-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 01:53:13AM +0200, Vladimir Oltean wrote:
> @@ -774,10 +881,14 @@ static void sja1105_mac_config(struct dsa_switch *ds, int port,
>  		return;
>  	}
>  
> -	if (link_an_mode == MLO_AN_INBAND) {
> +	if (link_an_mode == MLO_AN_INBAND && !is_sgmii) {
>  		dev_err(ds->dev, "In-band AN not supported!\n");
>  		return;
>  	}
> +
> +	if (is_sgmii)
> +		sja1105_sgmii_config(priv, port, link_an_mode == MLO_AN_INBAND,
> +				     state->speed);

Please avoid new usages of state->speed in mac_config() - I'm trying
to eliminate them now that the mac_link_up() patches are in.  If you
need to set the PCS for the link speed, please hook that into
mac_link_up() instead.

>  }
>  
>  static void sja1105_mac_link_down(struct dsa_switch *ds, int port,
> @@ -833,7 +944,8 @@ static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
>  	phylink_set(mask, 10baseT_Full);
>  	phylink_set(mask, 100baseT_Full);
>  	phylink_set(mask, 100baseT1_Full);
> -	if (mii->xmii_mode[port] == XMII_MODE_RGMII)
> +	if (mii->xmii_mode[port] == XMII_MODE_RGMII ||
> +	    mii->xmii_mode[port] == XMII_MODE_SGMII)
>  		phylink_set(mask, 1000baseT_Full);
>  
>  	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
> @@ -841,6 +953,82 @@ static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
>  		   __ETHTOOL_LINK_MODE_MASK_NBITS);
>  }
>  
> +static int sja1105_mac_pcs_get_state(struct dsa_switch *ds, int port,
> +				     struct phylink_link_state *state)
> +{
> +	struct sja1105_private *priv = ds->priv;
> +	int bmcr;
> +
> +	bmcr = sja1105_sgmii_read(priv, MII_BMCR);
> +	if (bmcr < 0)
> +		return bmcr;
> +
> +	state->an_enabled = !!(bmcr & BMCR_ANENABLE);
> +
> +	if (state->an_enabled) {

mac_pcs_get_state() is only called when in in-band AN mode, so this
is not useful.  If it's called with AN disabled, that's a bug.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
