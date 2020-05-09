Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E64C1CC489
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 22:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgEIUYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 16:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgEIUYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 16:24:04 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E00C061A0C;
        Sat,  9 May 2020 13:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Ovp60dOLbmU0FjmDu4qGjwa600Oef/D69yTe/N2EhaQ=; b=DESptJacxrGsnUAD2HqdxUnJO
        fblN0fe85eRUB4xGX6rkQ7kxqcrSB9Fu847sM5AV4dhFCc6fHcvhD3pku4ASXzHrf4RhCIgLOFgWu
        i9masJY1pOdokGllp2+FT8dQR+jo/Ctt6CuejlM8lj3BR3wWX82ER0GW0q5dE6P4kVidVyhl8lHdk
        RyQzJyKh1A2TuGtq2h42K866aO+QNQ22UbuDTHGxoFCAVwYG7xMGYE/XqpeGtAtjICePGBvzbaTXx
        7nW30MWhUrqVQRzYRD8AfhpVCj16q+gEDmfULy38nMjtBstrv/5Te0u64SdxuQfpP/0OEl4r4fzWB
        YUmQkBPhA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:38158)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jXW0s-00056T-03; Sat, 09 May 2020 21:23:58 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jXW0p-00039v-Hq; Sat, 09 May 2020 21:23:55 +0100
Date:   Sat, 9 May 2020 21:23:55 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Stefan Chulski <stefanc@marvell.com>
Subject: Re: [PATCH net] mvpp2: enable rxhash only on the first port
Message-ID: <20200509202355.GL1551@shell.armlinux.org.uk>
References: <20200509141546.5750-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509141546.5750-1-mcroce@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 09, 2020 at 04:15:46PM +0200, Matteo Croce wrote:
> Currently rxhash only works on the first port of the CP (Communication
> Processor). Enabling it on other ports completely blocks packet reception.
> This patch only adds rxhash as supported feature to the first port,
> so rxhash can't be enabled on other ports:
> 
> 	# ethtool -K eth0 rxhash on
> 	# ethtool -K eth1 rxhash on
> 	# ethtool -K eth2 rxhash on
> 	Cannot change receive-hashing
> 	Could not change any device features
> 	# ethtool -K eth3 rxhash on
> 	Cannot change receive-hashing
> 	Could not change any device features
> 
> Fixes: 895586d5dc32 ("net: mvpp2: cls: Use RSS contexts to handle RSS tables")
> Signed-off-by: Matteo Croce <mcroce@redhat.com>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index 2b5dad2ec650..ba71583c7ae3 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -5423,7 +5423,8 @@ static int mvpp2_port_probe(struct platform_device *pdev,
>  			    NETIF_F_HW_VLAN_CTAG_FILTER;
>  
>  	if (mvpp22_rss_is_supported()) {
> -		dev->hw_features |= NETIF_F_RXHASH;
> +		if (port->id == 0)
> +			dev->hw_features |= NETIF_F_RXHASH;
>  		dev->features |= NETIF_F_NTUPLE;
>  	}

I seem to have discovered the cause of the problem in the old thread,
so I suggest we wait and see whether anyone offers up a proper
solution to this regression before we rush to completely disable
this feature.

I would suggest with a high degress of confidence based on my
research that prior to the offending commit (895586d5dc32), rx
hashing was working fine, distributing interrupts across the cores.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
