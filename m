Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85F26DD836
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 12:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjDKKpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 06:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjDKKpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 06:45:05 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8F144BF;
        Tue, 11 Apr 2023 03:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ImctafnwqPsPi7ix8f1fEqK/59TTEsSB6UiwQdAadWY=; b=JQRaw21VTog7foN8U46Ot+c17c
        jlriJnoIwChH5GwUrhg9Uhii8PYsk/S/yL25zz5MnMOkYyySpkETD/wZt0R1VTpMe80AVXzzHaq+f
        op27Vb+1xK3VqqZD5953nvHLHrHl0taf3g+BU+nJ70Aoca+occyKt/Ttic/tHQf0pU5cf82lTX4Er
        BxlC7CqTeDMwW2p/6Msg3KEYgRBBGaAHUb+lM1gsXiWa7mcCRmHh8CxERoO73fXVFu57Bc5HsNknt
        AN5bxFdz7HkF2D+NcXThofuS0LaMpGDf1ST8l4bXrOj6O7MSK+VKIb3WDnEy2IUbzlW6Eh7cWvk+m
        w3BPFOLw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46152)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pmBUJ-0005nY-Cs; Tue, 11 Apr 2023 11:44:35 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pmBUI-00042k-OV; Tue, 11 Apr 2023 11:44:34 +0100
Date:   Tue, 11 Apr 2023 11:44:34 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v2 6/6] net: txgbe: Support phylink MAC layer
Message-ID: <ZDU6EtWVL5JqqerL@shell.armlinux.org.uk>
References: <20230411092725.104992-1-jiawenwu@trustnetic.com>
 <20230411092725.104992-7-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411092725.104992-7-jiawenwu@trustnetic.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 05:27:25PM +0800, Jiawen Wu wrote:
> Add phylink support to Wangxun 10Gb Ethernet controller, for the 10GBASE-R
> and 1000BASE-X interfaces.
> 
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> ---
>  .../ethernet/wangxun/txgbe/txgbe_ethtool.c    |  34 ++++++
>  .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  19 ++-
>  .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 111 +++++++++++++++++-
>  .../net/ethernet/wangxun/txgbe/txgbe_type.h   |   5 +
>  4 files changed, 156 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c
> index d914e9a05404..43ca84c90637 100644
> --- a/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c
> @@ -6,11 +6,45 @@
>  #include <linux/netdevice.h>
>  
>  #include "../libwx/wx_ethtool.h"
> +#include "../libwx/wx_type.h"
> +#include "txgbe_type.h"
>  #include "txgbe_ethtool.h"

I wonder if a small helper would be useful in txgbe_type.h:

static inline struct txgbe *netdev_to_txgbe(struct net_device *netdev)
{
	struct wx *wx = netdev_priv(netdev);

	return wx->priv;
}

> +static int txgbe_nway_reset(struct net_device *netdev)
> +{
> +	struct wx *wx = netdev_priv(netdev);
> +	struct txgbe *txgbe;
> +
> +	txgbe = (struct txgbe *)wx->priv;

Then all of these can be simply:

	struct txgbe *txgbe = netdev_to_txgbe(netdev);

> +	return phylink_ethtool_nway_reset(txgbe->phylink);
> +}
> +
> +static int txgbe_get_link_ksettings(struct net_device *netdev,
> +				    struct ethtool_link_ksettings *cmd)
> +{
> +	struct wx *wx = netdev_priv(netdev);
> +	struct txgbe *txgbe;
> +
> +	txgbe = (struct txgbe *)wx->priv;
> +	return phylink_ethtool_ksettings_get(txgbe->phylink, cmd);
> +}
> +
> +static int txgbe_set_link_ksettings(struct net_device *netdev,
> +				    const struct ethtool_link_ksettings *cmd)
> +{
> +	struct wx *wx = netdev_priv(netdev);
> +	struct txgbe *txgbe;
> +
> +	txgbe = (struct txgbe *)wx->priv;
> +	return phylink_ethtool_ksettings_set(txgbe->phylink, cmd);
> +}
> +
>  static const struct ethtool_ops txgbe_ethtool_ops = {
>  	.get_drvinfo		= wx_get_drvinfo,
> +	.nway_reset		= txgbe_nway_reset,
>  	.get_link		= ethtool_op_get_link,
> +	.get_link_ksettings	= txgbe_get_link_ksettings,
> +	.set_link_ksettings	= txgbe_set_link_ksettings,
>  };
>  
>  void txgbe_set_ethtool_ops(struct net_device *netdev)
> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> index d8108ab30818..f640ff1a084e 100644
> --- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> @@ -7,6 +7,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/string.h>
>  #include <linux/etherdevice.h>
> +#include <linux/phylink.h>
>  #include <net/ip.h>
>  #include <linux/if_vlan.h>
>  
> @@ -204,7 +205,7 @@ static int txgbe_request_irq(struct wx *wx)
>  
>  static void txgbe_up_complete(struct wx *wx)
>  {
> -	u32 reg;
> +	struct txgbe *txgbe = (struct txgbe *)wx->priv;

Personal choice I guess, but normally we tend to rely on compilers
accepting the implicit cast from void * to whatever struct pointer
in the kernel.

>  
>  	wx_control_hw(wx, true);
>  	wx_configure_vectors(wx);
> @@ -213,24 +214,16 @@ static void txgbe_up_complete(struct wx *wx)
>  	smp_mb__before_atomic();
>  	wx_napi_enable_all(wx);
>  
> +	phylink_start(txgbe->phylink);
> +
>  	/* clear any pending interrupts, may auto mask */
>  	rd32(wx, WX_PX_IC(0));
>  	rd32(wx, WX_PX_IC(1));
>  	rd32(wx, WX_PX_MISC_IC);
>  	txgbe_irq_enable(wx, true);
>  
> -	/* Configure MAC Rx and Tx when link is up */
> -	reg = rd32(wx, WX_MAC_RX_CFG);
> -	wr32(wx, WX_MAC_RX_CFG, reg);
> -	wr32(wx, WX_MAC_PKT_FLT, WX_MAC_PKT_FLT_PR);
> -	reg = rd32(wx, WX_MAC_WDG_TIMEOUT);
> -	wr32(wx, WX_MAC_WDG_TIMEOUT, reg);
> -	reg = rd32(wx, WX_MAC_TX_CFG);
> -	wr32(wx, WX_MAC_TX_CFG, (reg & ~WX_MAC_TX_CFG_SPEED_MASK) | WX_MAC_TX_CFG_SPEED_10G);
> -
>  	/* enable transmits */
>  	netif_tx_start_all_queues(wx->netdev);
> -	netif_carrier_on(wx->netdev);
>  }
>  
>  static void txgbe_reset(struct wx *wx)
> @@ -264,7 +257,6 @@ static void txgbe_disable_device(struct wx *wx)
>  		wx_disable_rx_queue(wx, wx->rx_ring[i]);
>  
>  	netif_tx_stop_all_queues(netdev);
> -	netif_carrier_off(netdev);
>  	netif_tx_disable(netdev);
>  
>  	wx_irq_disable(wx);
> @@ -295,8 +287,11 @@ static void txgbe_disable_device(struct wx *wx)
>  
>  static void txgbe_down(struct wx *wx)
>  {
> +	struct txgbe *txgbe = (struct txgbe *)wx->priv;
> +
>  	txgbe_disable_device(wx);
>  	txgbe_reset(wx);
> +	phylink_stop(txgbe->phylink);
>  
>  	wx_clean_all_tx_rings(wx);
>  	wx_clean_all_rx_rings(wx);
> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
> index 123fa7ed9039..84dc3e850036 100644
> --- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
> @@ -13,6 +13,7 @@
>  #include <linux/pci.h>
>  
>  #include "../libwx/wx_type.h"
> +#include "../libwx/wx_lib.h"
>  #include "../libwx/wx_hw.h"
>  #include "txgbe_type.h"
>  #include "txgbe_phy.h"
> @@ -445,6 +446,98 @@ static int txgbe_mdio_pcs_init(struct txgbe *txgbe)
>  	return 0;
>  }
>  
> +static struct phylink_pcs *txgbe_phylink_mac_select(struct phylink_config *config,
> +						    phy_interface_t interface)
> +{
> +	struct wx *wx = netdev_priv(to_net_dev(config->dev));
> +	struct txgbe *txgbe = (struct txgbe *)wx->priv;

	struct txgbr *txgbe = netdev_to_txgbe(to_net_dev(config->dev));

> +
> +	return &txgbe->pcs;
> +}
> +

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
