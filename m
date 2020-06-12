Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7BB1F77BC
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 14:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgFLMMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 08:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgFLMMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 08:12:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A21C03E96F;
        Fri, 12 Jun 2020 05:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yK0/1c9HKj2vF/aVFuOZ5pmsjzwvYf0jnH1dHlUlTaU=; b=Cx7RuQ86PB3ddeJ2xmouu/uKH
        0xZPWb+ognvv1FUceCJLBroZnRKagl9MUwZtLcQp8ifCoKSPaAwBSg4qyIg59XcxrGEzZ1WpyLaEk
        nZkhKYaSi41JVrdTtOpk1kAa8Xu+KrKX4mGgpSu43l7w0/ltuajXq80uObZcLGWovVTnzm4LMdwJu
        OWqfGyzdRtsPRxXmhNB/TADT39c2G+V63xY3xMmen/TWEoCLRDExipNWDvbGZaCmnebG5czbGfhXb
        jTrEsyyS9XksQmjs06sI57lA/Y4zG5RqGVuRMxKa3hEg04XGdwd9B+35wJaHd79bY8WzLTHMLyRV0
        Ycld0pp5w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44620)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jjiY4-0002oG-A5; Fri, 12 Jun 2020 13:12:40 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jjiY3-0006G9-Lp; Fri, 12 Jun 2020 13:12:39 +0100
Date:   Fri, 12 Jun 2020 13:12:39 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH v2] net: mvneta: Fix Serdes configuration for 2.5Gbps
 modes
Message-ID: <20200612121239.GJ1551@shell.armlinux.org.uk>
References: <20200612083847.29942-1-s.hauer@pengutronix.de>
 <20200612084710.GC1551@shell.armlinux.org.uk>
 <20200612100114.GE1551@shell.armlinux.org.uk>
 <20200612101820.GF1551@shell.armlinux.org.uk>
 <20200612120604.GT11869@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200612120604.GT11869@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 12, 2020 at 02:06:04PM +0200, Sascha Hauer wrote:
> And here is the same patch which applies on master and the net tree.
> It works as expected on my Armada XP in 2.5Gbps mode. Provided you are
> happy with the patch I can send it as a formal patch on monday if by
> then you haven't done that already.

As mentioned in one of my replies, there's a bug the patch I sent...

> @@ -3533,9 +3535,6 @@ static int mvneta_comphy_init(struct mvneta_port *pp)
>  {
>  	int ret;
>  
> -	if (!pp->comphy)
> -		return 0;
> -
>  	ret = phy_set_mode_ext(pp->comphy, PHY_MODE_ETHERNET,
>  			       pp->phy_interface);

mvneta_comphy_init() needs to be passed the interface mode, and pass it
thrugh to phy_set_mode_ext().

>  	if (ret)
> @@ -3544,11 +3543,49 @@ static int mvneta_comphy_init(struct mvneta_port *pp)
>  	return phy_power_on(pp->comphy);
>  }
>  
> +static int mvneta_config_interface(struct mvneta_port *pp,
> +				   phy_interface_t interface)
> +{
> +	int ret = 0;
> +
> +	if (pp->comphy) {
> +		if (interface == PHY_INTERFACE_MODE_SGMII ||
> +		    interface == PHY_INTERFACE_MODE_1000BASEX ||
> +		    interface == PHY_INTERFACE_MODE_2500BASEX) {
> +			ret = mvneta_comphy_init(pp);

and this needs to be:
			ret = mvneta_comphy_init(pp, interface);

Otherwise, the comphy uses the _old_ interface mode each time this
function is called.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
