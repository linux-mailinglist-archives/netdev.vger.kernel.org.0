Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E1B4250E8
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 12:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240817AbhJGKWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 06:22:51 -0400
Received: from mga03.intel.com ([134.134.136.65]:14341 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240795AbhJGKWm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 06:22:42 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10129"; a="226167762"
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="226167762"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 03:20:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="624193707"
Received: from kuha.fi.intel.com ([10.237.72.162])
  by fmsmga001.fm.intel.com with SMTP; 07 Oct 2021 03:20:43 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Thu, 07 Oct 2021 13:20:43 +0300
Date:   Thu, 7 Oct 2021 13:20:43 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, rafael@kernel.org,
        saravanak@google.com, mw@semihalf.com, andrew@lunn.ch,
        jeremy.linton@arm.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        robh+dt@kernel.org, frowand.list@gmail.com,
        devicetree@vger.kernel.org, snelson@pensando.io,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH net-next v3 4/9] device property: move mac addr helpers
 to eth.c
Message-ID: <YV7J+1nEW5iZ7hcx@kuha.fi.intel.com>
References: <20211007010702.3438216-1-kuba@kernel.org>
 <20211007010702.3438216-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007010702.3438216-5-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 06, 2021 at 06:06:57PM -0700, Jakub Kicinski wrote:
> Move the mac address helpers out, eth.c already contains
> a bunch of similar helpers.
> 
> Suggested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

FWIW:

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
> v2: new patch
> ---
>  drivers/base/property.c     | 63 -------------------------------------
>  include/linux/etherdevice.h |  6 ++++
>  include/linux/property.h    |  4 ---
>  net/ethernet/eth.c          | 63 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 69 insertions(+), 67 deletions(-)
> 
> diff --git a/drivers/base/property.c b/drivers/base/property.c
> index 453918eb7390..f1f35b48ab8b 100644
> --- a/drivers/base/property.c
> +++ b/drivers/base/property.c
> @@ -15,7 +15,6 @@
>  #include <linux/of_graph.h>
>  #include <linux/of_irq.h>
>  #include <linux/property.h>
> -#include <linux/etherdevice.h>
>  #include <linux/phy.h>
>  
>  struct fwnode_handle *dev_fwnode(struct device *dev)
> @@ -935,68 +934,6 @@ int device_get_phy_mode(struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(device_get_phy_mode);
>  
> -static void *fwnode_get_mac_addr(struct fwnode_handle *fwnode,
> -				 const char *name, char *addr,
> -				 int alen)
> -{
> -	int ret = fwnode_property_read_u8_array(fwnode, name, addr, alen);
> -
> -	if (ret == 0 && alen == ETH_ALEN && is_valid_ether_addr(addr))
> -		return addr;
> -	return NULL;
> -}
> -
> -/**
> - * fwnode_get_mac_address - Get the MAC from the firmware node
> - * @fwnode:	Pointer to the firmware node
> - * @addr:	Address of buffer to store the MAC in
> - * @alen:	Length of the buffer pointed to by addr, should be ETH_ALEN
> - *
> - * Search the firmware node for the best MAC address to use.  'mac-address' is
> - * checked first, because that is supposed to contain to "most recent" MAC
> - * address. If that isn't set, then 'local-mac-address' is checked next,
> - * because that is the default address.  If that isn't set, then the obsolete
> - * 'address' is checked, just in case we're using an old device tree.
> - *
> - * Note that the 'address' property is supposed to contain a virtual address of
> - * the register set, but some DTS files have redefined that property to be the
> - * MAC address.
> - *
> - * All-zero MAC addresses are rejected, because those could be properties that
> - * exist in the firmware tables, but were not updated by the firmware.  For
> - * example, the DTS could define 'mac-address' and 'local-mac-address', with
> - * zero MAC addresses.  Some older U-Boots only initialized 'local-mac-address'.
> - * In this case, the real MAC is in 'local-mac-address', and 'mac-address'
> - * exists but is all zeros.
> -*/
> -void *fwnode_get_mac_address(struct fwnode_handle *fwnode, char *addr, int alen)
> -{
> -	char *res;
> -
> -	res = fwnode_get_mac_addr(fwnode, "mac-address", addr, alen);
> -	if (res)
> -		return res;
> -
> -	res = fwnode_get_mac_addr(fwnode, "local-mac-address", addr, alen);
> -	if (res)
> -		return res;
> -
> -	return fwnode_get_mac_addr(fwnode, "address", addr, alen);
> -}
> -EXPORT_SYMBOL(fwnode_get_mac_address);
> -
> -/**
> - * device_get_mac_address - Get the MAC for a given device
> - * @dev:	Pointer to the device
> - * @addr:	Address of buffer to store the MAC in
> - * @alen:	Length of the buffer pointed to by addr, should be ETH_ALEN
> - */
> -void *device_get_mac_address(struct device *dev, char *addr, int alen)
> -{
> -	return fwnode_get_mac_address(dev_fwnode(dev), addr, alen);
> -}
> -EXPORT_SYMBOL(device_get_mac_address);
> -
>  /**
>   * fwnode_irq_get - Get IRQ directly from a fwnode
>   * @fwnode:	Pointer to the firmware node
> diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
> index c8442d954d19..b3b6591d84c6 100644
> --- a/include/linux/etherdevice.h
> +++ b/include/linux/etherdevice.h
> @@ -26,9 +26,15 @@
>  
>  #ifdef __KERNEL__
>  struct device;
> +struct fwnode_handle;
> +
>  int eth_platform_get_mac_address(struct device *dev, u8 *mac_addr);
>  unsigned char *arch_get_platform_mac_address(void);
>  int nvmem_get_mac_address(struct device *dev, void *addrbuf);
> +void *device_get_mac_address(struct device *dev, char *addr, int alen);
> +void *fwnode_get_mac_address(struct fwnode_handle *fwnode,
> +			     char *addr, int alen);
> +
>  u32 eth_get_headlen(const struct net_device *dev, const void *data, u32 len);
>  __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev);
>  extern const struct header_ops eth_header_ops;
> diff --git a/include/linux/property.h b/include/linux/property.h
> index 357513a977e5..4fb081684255 100644
> --- a/include/linux/property.h
> +++ b/include/linux/property.h
> @@ -389,11 +389,7 @@ const void *device_get_match_data(struct device *dev);
>  
>  int device_get_phy_mode(struct device *dev);
>  
> -void *device_get_mac_address(struct device *dev, char *addr, int alen);
> -
>  int fwnode_get_phy_mode(struct fwnode_handle *fwnode);
> -void *fwnode_get_mac_address(struct fwnode_handle *fwnode,
> -			     char *addr, int alen);
>  struct fwnode_handle *fwnode_graph_get_next_endpoint(
>  	const struct fwnode_handle *fwnode, struct fwnode_handle *prev);
>  struct fwnode_handle *
> diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
> index b57530c231a6..9ea45aae04ee 100644
> --- a/net/ethernet/eth.c
> +++ b/net/ethernet/eth.c
> @@ -51,6 +51,7 @@
>  #include <linux/if_ether.h>
>  #include <linux/of_net.h>
>  #include <linux/pci.h>
> +#include <linux/property.h>
>  #include <net/dst.h>
>  #include <net/arp.h>
>  #include <net/sock.h>
> @@ -558,3 +559,65 @@ int nvmem_get_mac_address(struct device *dev, void *addrbuf)
>  	return 0;
>  }
>  EXPORT_SYMBOL(nvmem_get_mac_address);
> +
> +static void *fwnode_get_mac_addr(struct fwnode_handle *fwnode,
> +				 const char *name, char *addr,
> +				 int alen)
> +{
> +	int ret = fwnode_property_read_u8_array(fwnode, name, addr, alen);
> +
> +	if (ret == 0 && alen == ETH_ALEN && is_valid_ether_addr(addr))
> +		return addr;
> +	return NULL;
> +}
> +
> +/**
> + * fwnode_get_mac_address - Get the MAC from the firmware node
> + * @fwnode:	Pointer to the firmware node
> + * @addr:	Address of buffer to store the MAC in
> + * @alen:	Length of the buffer pointed to by addr, should be ETH_ALEN
> + *
> + * Search the firmware node for the best MAC address to use.  'mac-address' is
> + * checked first, because that is supposed to contain to "most recent" MAC
> + * address. If that isn't set, then 'local-mac-address' is checked next,
> + * because that is the default address.  If that isn't set, then the obsolete
> + * 'address' is checked, just in case we're using an old device tree.
> + *
> + * Note that the 'address' property is supposed to contain a virtual address of
> + * the register set, but some DTS files have redefined that property to be the
> + * MAC address.
> + *
> + * All-zero MAC addresses are rejected, because those could be properties that
> + * exist in the firmware tables, but were not updated by the firmware.  For
> + * example, the DTS could define 'mac-address' and 'local-mac-address', with
> + * zero MAC addresses.  Some older U-Boots only initialized 'local-mac-address'.
> + * In this case, the real MAC is in 'local-mac-address', and 'mac-address'
> + * exists but is all zeros.
> + */
> +void *fwnode_get_mac_address(struct fwnode_handle *fwnode, char *addr, int alen)
> +{
> +	char *res;
> +
> +	res = fwnode_get_mac_addr(fwnode, "mac-address", addr, alen);
> +	if (res)
> +		return res;
> +
> +	res = fwnode_get_mac_addr(fwnode, "local-mac-address", addr, alen);
> +	if (res)
> +		return res;
> +
> +	return fwnode_get_mac_addr(fwnode, "address", addr, alen);
> +}
> +EXPORT_SYMBOL(fwnode_get_mac_address);
> +
> +/**
> + * device_get_mac_address - Get the MAC for a given device
> + * @dev:	Pointer to the device
> + * @addr:	Address of buffer to store the MAC in
> + * @alen:	Length of the buffer pointed to by addr, should be ETH_ALEN
> + */
> +void *device_get_mac_address(struct device *dev, char *addr, int alen)
> +{
> +	return fwnode_get_mac_address(dev_fwnode(dev), addr, alen);
> +}
> +EXPORT_SYMBOL(device_get_mac_address);
> -- 
> 2.31.1

thanks,

-- 
heikki
