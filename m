Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D646784921
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 12:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbfHGKJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 06:09:34 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:35853 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbfHGKJe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Aug 2019 06:09:34 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 463S0X0wZpz9sNF;
        Wed,  7 Aug 2019 20:09:32 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: Re: [PATCH net-next v2] ibmveth: Allow users to update reported speed and duplex
In-Reply-To: <1565108588-17331-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1565108588-17331-1-git-send-email-tlfalcon@linux.ibm.com>
Date:   Wed, 07 Aug 2019 20:09:26 +1000
Message-ID: <87imr9uw15.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thomas Falcon <tlfalcon@linux.ibm.com> writes:
> Reported ethtool link settings for the ibmveth driver are currently
> hardcoded and no longer reflect the actual capabilities of supported
> hardware. There is no interface designed for retrieving this information
> from device firmware nor is there any way to update current settings
> to reflect observed or expected link speeds.
>
> To avoid breaking existing configurations, retain current values as
> default settings but let users update them to match the expected
> capabilities of underlying hardware if needed. This update would
> allow the use of configurations that rely on certain link speed
> settings, such as LACP. This patch is based on the implementation
> in virtio_net.
>
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> ---
> v2: Updated default driver speed/duplex settings to avoid
>     breaking existing setups

Thanks.

I won't give you an ack because I don't know jack about network drivers
these days, but I think that alleviates my concern about breaking
existing setups. I'll leave the rest of the review up to the networking
folks.

cheers

> diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
> index d654c23..5dc634f 100644
> --- a/drivers/net/ethernet/ibm/ibmveth.c
> +++ b/drivers/net/ethernet/ibm/ibmveth.c
> @@ -712,31 +712,68 @@ static int ibmveth_close(struct net_device *netdev)
>  	return 0;
>  }
>  
> -static int netdev_get_link_ksettings(struct net_device *dev,
> -				     struct ethtool_link_ksettings *cmd)
> +static bool
> +ibmveth_validate_ethtool_cmd(const struct ethtool_link_ksettings *cmd)
>  {
> -	u32 supported, advertising;
> -
> -	supported = (SUPPORTED_1000baseT_Full | SUPPORTED_Autoneg |
> -				SUPPORTED_FIBRE);
> -	advertising = (ADVERTISED_1000baseT_Full | ADVERTISED_Autoneg |
> -				ADVERTISED_FIBRE);
> -	cmd->base.speed = SPEED_1000;
> -	cmd->base.duplex = DUPLEX_FULL;
> -	cmd->base.port = PORT_FIBRE;
> -	cmd->base.phy_address = 0;
> -	cmd->base.autoneg = AUTONEG_ENABLE;
> -
> -	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.supported,
> -						supported);
> -	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.advertising,
> -						advertising);
> +	struct ethtool_link_ksettings diff1 = *cmd;
> +	struct ethtool_link_ksettings diff2 = {};
> +
> +	diff2.base.port = PORT_OTHER;
> +	diff1.base.speed = 0;
> +	diff1.base.duplex = 0;
> +	diff1.base.cmd = 0;
> +	diff1.base.link_mode_masks_nwords = 0;
> +	ethtool_link_ksettings_zero_link_mode(&diff1, advertising);
> +
> +	return !memcmp(&diff1.base, &diff2.base, sizeof(diff1.base)) &&
> +		bitmap_empty(diff1.link_modes.supported,
> +			     __ETHTOOL_LINK_MODE_MASK_NBITS) &&
> +		bitmap_empty(diff1.link_modes.advertising,
> +			     __ETHTOOL_LINK_MODE_MASK_NBITS) &&
> +		bitmap_empty(diff1.link_modes.lp_advertising,
> +			     __ETHTOOL_LINK_MODE_MASK_NBITS);
> +}
> +
> +static int ibmveth_set_link_ksettings(struct net_device *dev,
> +				      const struct ethtool_link_ksettings *cmd)
> +{
> +	struct ibmveth_adapter *adapter = netdev_priv(dev);
> +	u32 speed;
> +	u8 duplex;
> +
> +	speed = cmd->base.speed;
> +	duplex = cmd->base.duplex;
> +	/* don't allow custom speed and duplex */
> +	if (!ethtool_validate_speed(speed) ||
> +	    !ethtool_validate_duplex(duplex) ||
> +	    !ibmveth_validate_ethtool_cmd(cmd))
> +		return -EINVAL;
> +	adapter->speed = speed;
> +	adapter->duplex = duplex;
>  
>  	return 0;
>  }
>  
> -static void netdev_get_drvinfo(struct net_device *dev,
> -			       struct ethtool_drvinfo *info)
> +static int ibmveth_get_link_ksettings(struct net_device *dev,
> +				      struct ethtool_link_ksettings *cmd)
> +{
> +	struct ibmveth_adapter *adapter = netdev_priv(dev);
> +
> +	cmd->base.speed = adapter->speed;
> +	cmd->base.duplex = adapter->duplex;
> +	cmd->base.port = PORT_OTHER;
> +
> +	return 0;
> +}
> +
> +static void ibmveth_init_link_settings(struct ibmveth_adapter *adapter)
> +{
> +	adapter->duplex = DUPLEX_FULL;
> +	adapter->speed = SPEED_1000;
> +}
> +
> +static void ibmveth_get_drvinfo(struct net_device *dev,
> +				struct ethtool_drvinfo *info)
>  {
>  	strlcpy(info->driver, ibmveth_driver_name, sizeof(info->driver));
>  	strlcpy(info->version, ibmveth_driver_version, sizeof(info->version));
> @@ -965,12 +1002,13 @@ static void ibmveth_get_ethtool_stats(struct net_device *dev,
>  }
>  
>  static const struct ethtool_ops netdev_ethtool_ops = {
> -	.get_drvinfo		= netdev_get_drvinfo,
> +	.get_drvinfo		= ibmveth_get_drvinfo,
>  	.get_link		= ethtool_op_get_link,
>  	.get_strings		= ibmveth_get_strings,
>  	.get_sset_count		= ibmveth_get_sset_count,
>  	.get_ethtool_stats	= ibmveth_get_ethtool_stats,
> -	.get_link_ksettings	= netdev_get_link_ksettings,
> +	.get_link_ksettings	= ibmveth_get_link_ksettings,
> +	.set_link_ksettings	= ibmveth_set_link_ksettings
>  };
>  
>  static int ibmveth_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
> @@ -1647,6 +1685,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
>  	adapter->netdev = netdev;
>  	adapter->mcastFilterSize = *mcastFilterSize_p;
>  	adapter->pool_config = 0;
> +	ibmveth_init_link_settings(adapter);
>  
>  	netif_napi_add(netdev, &adapter->napi, ibmveth_poll, 16);
>  
> diff --git a/drivers/net/ethernet/ibm/ibmveth.h b/drivers/net/ethernet/ibm/ibmveth.h
> index 4e9bf34..db96c88 100644
> --- a/drivers/net/ethernet/ibm/ibmveth.h
> +++ b/drivers/net/ethernet/ibm/ibmveth.h
> @@ -162,6 +162,9 @@ struct ibmveth_adapter {
>      u64 tx_send_failed;
>      u64 tx_large_packets;
>      u64 rx_large_packets;
> +    /* Ethtool settings */
> +    u8 duplex;
> +    u32 speed;
>  };
>  
>  /*
> -- 
> 1.8.3.1
