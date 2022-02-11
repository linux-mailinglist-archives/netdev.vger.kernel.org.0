Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7344B2F86
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 22:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353744AbiBKVlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 16:41:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbiBKVlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 16:41:11 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FFEEC6D;
        Fri, 11 Feb 2022 13:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=rm0L+g8d02pQ49JYPdifRHUJjiEEX1ttH645kywwIYM=; b=tHCY3TKXj9WNvHpcFpkBWQe9nm
        xO6QBxt+2ahM1G+8O62wl+6KJjjN+tpEkNer+SF7MHOKmMwpGfzk/W6WZx8oVpWgfSJmqfyX+Royg
        sKparTb42Y0YHsKCcJyv0+7xHaOpbvvYZFxoWjEf41PzsaDMLzZz8u2cXjNS103rr29o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nIdey-005WZh-FA; Fri, 11 Feb 2022 22:40:56 +0100
Date:   Fri, 11 Feb 2022 22:40:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Veerasenareddy Burru <vburru@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        Satananda Burla <sburla@marvell.com>
Subject: Re: [PATCH 4/4] octeon_ep: add ethtool support for Octeon PCI
 Endpoint NIC.
Message-ID: <YgbX6N5efWf7J4ds@lunn.ch>
References: <20220210213306.3599-1-vburru@marvell.com>
 <20220210213306.3599-5-vburru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210213306.3599-5-vburru@marvell.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void octep_get_drvinfo(struct net_device *netdev,
> +			      struct ethtool_drvinfo *info)
> +{
> +	struct octep_device *oct = netdev_priv(netdev);
> +
> +	strscpy(info->driver, OCTEP_DRV_NAME, sizeof(info->driver));
> +	strscpy(info->version, OCTEP_DRV_VERSION_STR, sizeof(info->version));

A driver version string is meaningless. If you don't set it, the core
will fill in the kernel version, which is actually usable information.

> +static int octep_get_link_ksettings(struct net_device *netdev,
> +				    struct ethtool_link_ksettings *cmd)
> +{
> +	struct octep_device *oct = netdev_priv(netdev);
> +	struct octep_iface_link_info *link_info;
> +	u32 advertised, supported;
> +
> +	ethtool_link_ksettings_zero_link_mode(cmd, supported);
> +	ethtool_link_ksettings_zero_link_mode(cmd, advertising);
> +
> +	octep_get_link_info(oct);
> +
> +	advertised = oct->link_info.advertised_modes;
> +	supported = oct->link_info.supported_modes;
> +	link_info = &oct->link_info;
> +
> +	if (supported & BIT(OCTEP_LINK_MODE_10GBASE_T))
> +		ethtool_link_ksettings_add_link_mode(cmd, supported, 10000baseT_Full);
> +	if (supported & BIT(OCTEP_LINK_MODE_10GBASE_R))
> +		ethtool_link_ksettings_add_link_mode(cmd, supported, 10000baseR_FEC);

....

> +
> +	if (advertised & BIT(OCTEP_LINK_MODE_10GBASE_T))
> +		ethtool_link_ksettings_add_link_mode(cmd, advertising, 10000baseT_Full);
> +	if (advertised & BIT(OCTEP_LINK_MODE_10GBASE_R))
> +		ethtool_link_ksettings_add_link_mode(cmd, advertising, 10000baseR_FEC);

It looks like you are doing the same thing twice, just different
variables. Pull this out into a helper.

Do you know what the link partner is advertising? It is useful debug
information if your firmware will tell you.

> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> index 700852fd4c3a..00c6ca047332 100644
> --- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> @@ -827,7 +827,7 @@ static int octep_set_mac(struct net_device *netdev, void *p)
>  		return err;
>  
>  	memcpy(oct->mac_addr, addr->sa_data, ETH_ALEN);
> -	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
> +	eth_hw_addr_set(netdev, addr->sa_data);
>  
>  	return 0;
>  }
> @@ -1067,7 +1068,7 @@ static int octep_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	netdev->mtu = OCTEP_DEFAULT_MTU;
>  
>  	octep_get_mac_addr(octep_dev, octep_dev->mac_addr);
> -	memcpy(netdev->dev_addr, octep_dev->mac_addr, netdev->addr_len);
> +	eth_hw_addr_set(netdev, octep_dev->mac_addr);

These two changes don't belong here.

      Andrew
