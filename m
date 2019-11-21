Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0A8105D65
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 00:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfKUXsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 18:48:22 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35710 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfKUXsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 18:48:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Dqq07qjaLtHh6dGNj7IksBQ32SXK7l6MBVk0AK3DEuk=; b=cQge2uHZbWmeLO/zgfeohrHWj
        oVMC++Y0++SZ2XSYIwHICBtSvFh83ogC3u2SC3S3DOdnvXqTwnXyzn9e8rObw1nGkt3POMtxegaPi
        fkwC5fqR7VmApEfunCJub05WF1EeJIRbfOLADPNNaBVaBF3xS17h9j7wUsFkTZBdpSaVmnA11Saiw
        faWYnDMhR8dTUAFmIDIHr3UD8PlGJKq7I4ynniYkJf+uzIvPMvnewYtQMqwOTqwD3sEULDL/1JZCj
        ygH6jEvoKrjXiXGCxApy2HO0AZLueQaw+mYq/v9/sYoErPBKaXxbOwCHP3Q2TfSsHZs+Ny+VOLPGQ
        L4qhTNYTA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38704)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iXwBM-0001R3-Eq; Thu, 21 Nov 2019 23:48:16 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iXwBI-00039c-UH; Thu, 21 Nov 2019 23:48:12 +0000
Date:   Thu, 21 Nov 2019 23:48:12 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next 1/3] dpaa2-eth: do not hold rtnl_lock on
 phylink_create() or _destroy()
Message-ID: <20191121234812.GC25745@shell.armlinux.org.uk>
References: <1574363727-5437-1-git-send-email-ioana.ciornei@nxp.com>
 <1574363727-5437-2-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1574363727-5437-2-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 09:15:25PM +0200, Ioana Ciornei wrote:
> The rtnl_lock should not be held when calling phylink_create() or
> phylink_destroy() since it leads to the deadlock listed below:
> 
> [   18.656576]  rtnl_lock+0x18/0x20
> [   18.659798]  sfp_bus_add_upstream+0x28/0x90
> [   18.663974]  phylink_create+0x2cc/0x828
> [   18.667803]  dpaa2_mac_connect+0x14c/0x2a8
> [   18.671890]  dpaa2_eth_connect_mac+0x94/0xd8
> 
> Fix this by moving the _lock() and _unlock() calls just outside of
> phylink_of_phy_connect() and phylink_disconnect_phy().
> 
> Fixes: 719479230893 ("dpaa2-eth: add MAC/PHY support through phylink")
> Reported-by: Russell King <linux@armlinux.org.uk>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 ----
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 4 ++++
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> index 7ff147e89426..40290fea9e36 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> @@ -3431,12 +3431,10 @@ static irqreturn_t dpni_irq0_handler_thread(int irq_num, void *arg)
>  		set_mac_addr(netdev_priv(net_dev));
>  		update_tx_fqids(priv);
>  
> -		rtnl_lock();
>  		if (priv->mac)
>  			dpaa2_eth_disconnect_mac(priv);
>  		else
>  			dpaa2_eth_connect_mac(priv);
> -		rtnl_unlock();

As I said previously, this will not be safe if net_dev is actively
published to userspace, and I'm very disappointed that you have not
taken on board what I wrote.

	Thread 1				Thread 2
						rtnl_lock()
	dpaa2_eth_disconnect_mac();
	dpaa2_mac_disconnect(priv->mac)
	 phylink_disconnect_phy(mac->phylink);
						dpaa2_eth_get_link_ksettings()
	 phylink_destroy(mac->phylink);
						phylink_ethtool_ksettings_get(priv->mac->phylink, ...)
	  kfree(pl);
	  					phylink_ethtool_ksettings_get()
						now dereferences freed
						memory
	kfree(priv->mac);
	priv->mac = NULL;

Similar can happen with priv->mac.

As long as the netdev is published, paths such as those in thread 2 are
possible while thread 1 is running concurrently.

So, your patch is at best a band-aid around the deadlock issue I pointed
out, but in doing so exposes another problem.

I think there is a fundamental design problem, and merely tweaking some
locks will not fix it.

As I've already stated, the phylink is not designed to be created and
destroyed on a published network device.

>  	}
>  
>  	return IRQ_HANDLED;
> @@ -3675,9 +3673,7 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
>  #ifdef CONFIG_DEBUG_FS
>  	dpaa2_dbg_remove(priv);
>  #endif
> -	rtnl_lock();
>  	dpaa2_eth_disconnect_mac(priv);
> -	rtnl_unlock();
>  
>  	unregister_netdev(net_dev);
>  
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> index 84233e467ed1..0200308d1bc7 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> @@ -277,7 +277,9 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>  	}
>  	mac->phylink = phylink;
>  
> +	rtnl_lock();
>  	err = phylink_of_phy_connect(mac->phylink, dpmac_node, 0);
> +	rtnl_unlock();
>  	if (err) {
>  		netdev_err(net_dev, "phylink_of_phy_connect() = %d\n", err);
>  		goto err_phylink_destroy;
> @@ -301,7 +303,9 @@ void dpaa2_mac_disconnect(struct dpaa2_mac *mac)
>  	if (!mac->phylink)
>  		return;
>  
> +	rtnl_lock();
>  	phylink_disconnect_phy(mac->phylink);
> +	rtnl_unlock();
>  	phylink_destroy(mac->phylink);
>  	dpmac_close(mac->mc_io, 0, mac->mc_dev->mc_handle);
>  }
> -- 
> 1.9.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
