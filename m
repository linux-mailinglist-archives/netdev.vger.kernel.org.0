Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686036D39C9
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 20:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbjDBSXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 14:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjDBSXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 14:23:09 -0400
Received: from mx23lb.world4you.com (mx23lb.world4you.com [81.19.149.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DF15266
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 11:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=s8dV6msCIRQDoFOhRFM4coVL5X5TWQ1m65bka4r4fh8=; b=fDzJpk7H9tWVVsZWySHHmeyTiE
        lzH2M7oyyq4XUZPHsxkNheSuLX+Zv03oAM/C7YRLJ0Cez3kn6PnMQjXrAUq4azeS6icvyUpbTIy6I
        OXH80zyq5W8XV/aNevIOBkDhr6dqVyq+AvGAPeqqnr3NrKK40jOVThWFKLpm3WNvrd5g=;
Received: from [88.117.56.218] (helo=[10.0.0.160])
        by mx23lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pj2M3-0005T1-Ea; Sun, 02 Apr 2023 20:23:03 +0200
Message-ID: <a9f0f57f-a73c-72dd-3fc6-fe22e2d3e466@engleder-embedded.com>
Date:   Sun, 2 Apr 2023 20:23:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next RFC v2] Add NDOs for hardware timestamp get/set
To:     Maxim Georgiev <glipus@gmail.com>, kory.maincent@bootlin.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com
References: <20230402142435.47105-1-glipus@gmail.com>
Content-Language: en-US
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <20230402142435.47105-1-glipus@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.04.23 16:24, Maxim Georgiev wrote:
> Current NIC driver API demands drivers supporting hardware timestamping
> to support SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTLs. Handling these IOCTLs
> requires dirivers to implement request parameter structure translation

dirivers -> drivers

> between user and kernel address spaces, handling possible
> translation failures, etc. This translation code is pretty much
> identical across most of the NIC drivers that support SIOCGHWTSTAMP/
> SIOCSHWTSTAMP.
> This patch extends NDO functiuon set with ndo_hwtstamp_get/set

functiuon -> function

> functions, implements SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTL translation
> to ndo_hwtstamp_get/set function calls including parameter structure
> translation and translation error handling.
> 
> This patch is sent out as RFC.
> It still pending on basic testing. Implementing ndo_hwtstamp_get/set
> in netdevsim driver should allow manual testing of the request
> translation logic. Also is there a way to automate this testing?
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Maxim Georgiev <glipus@gmail.com>
> ---
> Changes in v2:
> - Introduced kernel_hwtstamp_config structure
> - Added netlink_ext_ack* and kernel_hwtstamp_config* as NDO hw timestamp
>    function parameters
> - Reodered function variable declarations in dev_hwtstamp()
> - Refactored error handling logic in dev_hwtstamp()
> - Split dev_hwtstamp() into GET and SET versions
> - Changed net_hwtstamp_validate() to accept struct hwtstamp_config *
>    as a parameter
> ---
>   drivers/net/ethernet/intel/e1000e/netdev.c | 39 ++++++-----
>   drivers/net/netdevsim/netdev.c             | 26 +++++++
>   drivers/net/netdevsim/netdevsim.h          |  1 +
>   include/linux/netdevice.h                  | 21 ++++++
>   include/uapi/linux/net_tstamp.h            | 15 ++++
>   net/core/dev_ioctl.c                       | 81 ++++++++++++++++++----
>   6 files changed, 149 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index 6f5c16aebcbf..5b98f7257c77 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -6161,7 +6161,9 @@ static int e1000_mii_ioctl(struct net_device *netdev, struct ifreq *ifr,
>   /**
>    * e1000e_hwtstamp_set - control hardware time stamping
>    * @netdev: network interface device structure
> - * @ifr: interface request
> + * @config: hwtstamp_config structure containing request parameters
> + * @kernel_config: kernel version of config parameter structure.
> + * @extack: netlink request parameters.

'.' at end of parameter line or not? You mixed it.

>    *
>    * Outgoing time stamping can be enabled and disabled. Play nice and
>    * disable it when requested, although it shouldn't cause any overhead
> @@ -6174,20 +6176,19 @@ static int e1000_mii_ioctl(struct net_device *netdev, struct ifreq *ifr,
>    * specified. Matching the kind of event packet is not supported, with the
>    * exception of "all V2 events regardless of level 2 or 4".
>    **/
> -static int e1000e_hwtstamp_set(struct net_device *netdev, struct ifreq *ifr)
> +static int e1000e_hwtstamp_set(struct net_device *netdev,
> +			       struct hwtstamp_config *config,
> +			       struct kernel_hwtstamp_config *kernel_config,
> +			       struct netlink_ext_ack *extack)
>   {
>   	struct e1000_adapter *adapter = netdev_priv(netdev);
> -	struct hwtstamp_config config;
>   	int ret_val;
>   
> -	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
> -		return -EFAULT;
> -
> -	ret_val = e1000e_config_hwtstamp(adapter, &config);
> +	ret_val = e1000e_config_hwtstamp(adapter, config);
>   	if (ret_val)
>   		return ret_val;
>   
> -	switch (config.rx_filter) {
> +	switch (config->rx_filter) {
>   	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
>   	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
>   	case HWTSTAMP_FILTER_PTP_V2_SYNC:
> @@ -6199,22 +6200,24 @@ static int e1000e_hwtstamp_set(struct net_device *netdev, struct ifreq *ifr)
>   		 * by hardware so notify the caller the requested packets plus
>   		 * some others are time stamped.
>   		 */
> -		config.rx_filter = HWTSTAMP_FILTER_SOME;
> +		config->rx_filter = HWTSTAMP_FILTER_SOME;
>   		break;
>   	default:
>   		break;
>   	}
> -
> -	return copy_to_user(ifr->ifr_data, &config,
> -			    sizeof(config)) ? -EFAULT : 0;
> +	return ret_val;

I would expect 'return 0;'.

>   }
>   
> -static int e1000e_hwtstamp_get(struct net_device *netdev, struct ifreq *ifr)
> +static int e1000e_hwtstamp_get(struct net_device *netdev,
> +			       struct hwtstamp_config *config,
> +			       struct kernel_hwtstamp_config *kernel_config,
> +			       struct netlink_ext_ack *extack)
>   {
>   	struct e1000_adapter *adapter = netdev_priv(netdev);
>   
> -	return copy_to_user(ifr->ifr_data, &adapter->hwtstamp_config,
> -			    sizeof(adapter->hwtstamp_config)) ? -EFAULT : 0;
> +	memcpy(config, &adapter->hwtstamp_config,
> +	       sizeof(adapter->hwtstamp_config));
> +	return 0;
>   }
>   
>   static int e1000_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
> @@ -6224,10 +6227,6 @@ static int e1000_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
>   	case SIOCGMIIREG:
>   	case SIOCSMIIREG:
>   		return e1000_mii_ioctl(netdev, ifr, cmd);
> -	case SIOCSHWTSTAMP:
> -		return e1000e_hwtstamp_set(netdev, ifr);
> -	case SIOCGHWTSTAMP:
> -		return e1000e_hwtstamp_get(netdev, ifr);
>   	default:
>   		return -EOPNOTSUPP;
>   	}
> @@ -7365,6 +7364,8 @@ static const struct net_device_ops e1000e_netdev_ops = {
>   	.ndo_set_features = e1000_set_features,
>   	.ndo_fix_features = e1000_fix_features,
>   	.ndo_features_check	= passthru_features_check,
> +	.ndo_hwtstamp_get	= e1000e_hwtstamp_get,
> +	.ndo_hwtstamp_set	= e1000e_hwtstamp_set,
>   };
>   
>   /**
> diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
> index 35fa1ca98671..502715c6e9e1 100644
> --- a/drivers/net/netdevsim/netdev.c
> +++ b/drivers/net/netdevsim/netdev.c
> @@ -238,6 +238,30 @@ nsim_set_features(struct net_device *dev, netdev_features_t features)
>   	return 0;
>   }
>   
> +static int
> +nsim_hwtstamp_get(struct net_device *dev,
> +		  struct hwtstamp_config *config,
> +		  struct kernel_hwtstamp_config *kernel_config,
> +		  struct netlink_ext_ack *extack)
> +{
> +	struct netdevsim *ns = netdev_priv(dev);
> +
> +	memcpy(config, &ns->hw_tstamp_config, sizeof(ns->hw_tstamp_config));
> +	return 0;
> +}
> +
> +static int
> +nsim_hwtstamp_ges(struct net_device *dev,

nsim_hwtstamp_ges -> nsim_hwtstamp_get

> +		  struct hwtstamp_config *config,
> +		  struct kernel_hwtstamp_config *kernel_config,
> +		  struct netlink_ext_ack *extack)
> +{
> +	struct netdevsim *ns = netdev_priv(dev);
> +
> +	memcpy(&ns->hw_tstamp_config, config, sizeof(ns->hw_tstamp_config));
> +	return 0;
> +}
> +
>   static const struct net_device_ops nsim_netdev_ops = {
>   	.ndo_start_xmit		= nsim_start_xmit,
>   	.ndo_set_rx_mode	= nsim_set_rx_mode,
> @@ -256,6 +280,8 @@ static const struct net_device_ops nsim_netdev_ops = {
>   	.ndo_setup_tc		= nsim_setup_tc,
>   	.ndo_set_features	= nsim_set_features,
>   	.ndo_bpf		= nsim_bpf,
> +	.ndo_hwtstamp_get	= nsim_hwtstamp_get,
> +	.ndo_hwtstamp_set	= nsim_hwtstamp_get,

nsim_hwtstamp_get -> nsim_hwtstamp_set

>   };
>   
>   static const struct net_device_ops nsim_vf_netdev_ops = {
> diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
> index 7d8ed8d8df5c..c6efd2383552 100644
> --- a/drivers/net/netdevsim/netdevsim.h
> +++ b/drivers/net/netdevsim/netdevsim.h
> @@ -102,6 +102,7 @@ struct netdevsim {
>   	} udp_ports;
>   
>   	struct nsim_ethtool ethtool;
> +	struct hwtstamp_config hw_tstamp_config;
>   };
>   
>   struct netdevsim *
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index c8c634091a65..078c9284930a 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -57,6 +57,8 @@
>   struct netpoll_info;
>   struct device;
>   struct ethtool_ops;
> +struct hwtstamp_config;
> +struct kernel_hwtstamp_config;
>   struct phy_device;
>   struct dsa_port;
>   struct ip_tunnel_parm;
> @@ -1411,6 +1413,17 @@ struct netdev_net_notifier {
>    *	Get hardware timestamp based on normal/adjustable time or free running
>    *	cycle counter. This function is required if physical clock supports a
>    *	free running cycle counter.
> + *	int (*ndo_hwtstamp_get)(struct net_device *dev,
> + *				struct hwtstamp_config *config,
> + *				struct kernel_hwtstamp_config *kernel_config,
> + *				struct netlink_ext_ack *extack);
> + *	Get hardware timestamping parameters currently configured  for NIC

'configured  for' -> 'configured for'

> + *	device.
> + *	int (*ndo_hwtstamp_set)(struct net_device *dev,
> + *				struct hwtstamp_config *config,
> + *				struct kernel_hwtstamp_config *kernel_config,
> + *				struct netlink_ext_ack *extack);
> + *	Set hardware timestamping parameters for NIC device.
>    */
>   struct net_device_ops {
>   	int			(*ndo_init)(struct net_device *dev);
> @@ -1645,6 +1658,14 @@ struct net_device_ops {
>   	ktime_t			(*ndo_get_tstamp)(struct net_device *dev,
>   						  const struct skb_shared_hwtstamps *hwtstamps,
>   						  bool cycles);
> +	int			(*ndo_hwtstamp_get)(struct net_device *dev,
> +						    struct hwtstamp_config *config,
> +						    struct kernel_hwtstamp_config *kernel_config,
> +						    struct netlink_ext_ack *extack);
> +	int			(*ndo_hwtstamp_set)(struct net_device *dev,
> +						    struct hwtstamp_config *config,
> +						    struct kernel_hwtstamp_config *kernel_config,
> +						    struct netlink_ext_ack *extack);
>   };
>   
>   struct xdp_metadata_ops {
> diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_tstamp.h
> index a2c66b3d7f0f..547f73beb479 100644
> --- a/include/uapi/linux/net_tstamp.h
> +++ b/include/uapi/linux/net_tstamp.h
> @@ -79,6 +79,21 @@ struct hwtstamp_config {
>   	int rx_filter;
>   };
>   
> +/**
> + * struct kernel_hwtstamp_config - %SIOCGHWTSTAMP and %SIOCSHWTSTAMP parameter
> + *
> + * @dummy:	a placeholder field added to work around empty struct language
> + *		restriction
> + *
> + * This structure passed as a parameter to NDO methods called in
> + * response to SIOCGHWTSTAMP and SIOCSHWTSTAMP IOCTLs.
> + * The structure is effectively empty for now. Before adding new fields
> + * to the structure "dummy" placeholder field should be removed.
> + */
> +struct kernel_hwtstamp_config {
> +	u8 dummy;
> +};
> +
>   /* possible values for hwtstamp_config->flags */
>   enum hwtstamp_flags {
>   	/*
> diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
> index 846669426236..c145afb3f77e 100644
> --- a/net/core/dev_ioctl.c
> +++ b/net/core/dev_ioctl.c
> @@ -183,22 +183,18 @@ static int dev_ifsioc_locked(struct net *net, struct ifreq *ifr, unsigned int cm
>   	return err;
>   }
>   
> -static int net_hwtstamp_validate(struct ifreq *ifr)
> +static int net_hwtstamp_validate(struct hwtstamp_config *cfg)
>   {
> -	struct hwtstamp_config cfg;
>   	enum hwtstamp_tx_types tx_type;
>   	enum hwtstamp_rx_filters rx_filter;
>   	int tx_type_valid = 0;
>   	int rx_filter_valid = 0;
>   
> -	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
> -		return -EFAULT;
> -
> -	if (cfg.flags & ~HWTSTAMP_FLAG_MASK)
> +	if (cfg->flags & ~HWTSTAMP_FLAG_MASK)
>   		return -EINVAL;
>   
> -	tx_type = cfg.tx_type;
> -	rx_filter = cfg.rx_filter;
> +	tx_type = cfg->tx_type;
> +	rx_filter = cfg->rx_filter;
>   
>   	switch (tx_type) {
>   	case HWTSTAMP_TX_OFF:
> @@ -277,6 +273,63 @@ static int dev_siocbond(struct net_device *dev,
>   	return -EOPNOTSUPP;
>   }
>   
> +static int dev_hwtstamp_get(struct net_device *dev, struct ifreq *ifr)
> +{
> +	const struct net_device_ops *ops = dev->netdev_ops;
> +	struct hwtstamp_config config;
> +	int err;
> +
> +	err = dsa_ndo_eth_ioctl(dev, ifr, SIOCGHWTSTAMP);
> +	if (err == 0 || err != -EOPNOTSUPP)
> +		return err;
> +
> +	if (!ops->ndo_hwtstamp_get)
> +		return dev_eth_ioctl(dev, ifr, SIOCGHWTSTAMP);
> +
> +	if (!netif_device_present(dev))
> +		return -ENODEV;
> +
> +	err = ops->ndo_hwtstamp_get(dev, &config, NULL, NULL);
> +	if (err)
> +		return err;
> +
> +	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +static int dev_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
> +{
> +	const struct net_device_ops *ops = dev->netdev_ops;
> +	struct hwtstamp_config config;
> +	int err;
> +
> +	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
> +		return -EFAULT;
> +
> +	err = net_hwtstamp_validate(&config);
> +	if (err)
> +		return err;
> +
> +	err = dsa_ndo_eth_ioctl(dev, ifr, SIOCSHWTSTAMP);
> +	if (err == 0 || err != -EOPNOTSUPP)
> +		return err;
> +
> +	if (!ops->ndo_hwtstamp_set)
> +		return dev_eth_ioctl(dev, ifr, SIOCSHWTSTAMP);
> +
> +	if (!netif_device_present(dev))
> +		return -ENODEV;
> +
> +	err = ops->ndo_hwtstamp_set(dev, &config, NULL, NULL);
> +	if (err)
> +		return err;
> +
> +	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
> +		return -EFAULT;
> +	return 0;
> +}
> +
>   static int dev_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
>   			      void __user *data, unsigned int cmd)
>   {
> @@ -391,11 +444,11 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
>   		rtnl_lock();
>   		return err;
>   
> +	case SIOCGHWTSTAMP:
> +		return dev_hwtstamp_get(dev, ifr);
> +
>   	case SIOCSHWTSTAMP:
> -		err = net_hwtstamp_validate(ifr);
> -		if (err)
> -			return err;
> -		fallthrough;
> +		return dev_hwtstamp_set(dev, ifr);
>   
>   	/*
>   	 *	Unknown or private ioctl
> @@ -407,9 +460,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
>   
>   		if (cmd == SIOCGMIIPHY ||
>   		    cmd == SIOCGMIIREG ||
> -		    cmd == SIOCSMIIREG ||
> -		    cmd == SIOCSHWTSTAMP ||
> -		    cmd == SIOCGHWTSTAMP) {
> +		    cmd == SIOCSMIIREG) {
>   			err = dev_eth_ioctl(dev, ifr, cmd);
>   		} else if (cmd == SIOCBONDENSLAVE ||
>   		    cmd == SIOCBONDRELEASE ||
