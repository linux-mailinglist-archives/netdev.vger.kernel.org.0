Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F672C30AE
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 20:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404309AbgKXTTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 14:19:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:62208 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391022AbgKXTTh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 14:19:37 -0500
IronPort-SDR: S+ar7CT5k9GLk0Uq+L75rqpySEVDs43KvgcZwUE2f4Kze+iKPizlknw1JUD6YgBK1v5MuOF9hR
 CWf2C9oo4/Mg==
X-IronPort-AV: E=McAfee;i="6000,8403,9815"; a="172160404"
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="172160404"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 11:19:34 -0800
IronPort-SDR: 5XL5SA9mfJKwLrTGBPZq2dMEMNogQexk3LvQOLBSgZpOqSzzeFNIC4Jq9M1THdZs9y2Iaf0UgQ
 TijH/Iui+RZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="361995567"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga004.fm.intel.com with ESMTP; 24 Nov 2020 11:19:32 -0800
Date:   Tue, 24 Nov 2020 20:11:36 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Camelia Groza <camelia.groza@nxp.com>
Cc:     kuba@kernel.org, brouer@redhat.com, saeed@kernel.org,
        davem@davemloft.net, madalin.bucur@oss.nxp.com,
        ioana.ciornei@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 3/7] dpaa_eth: limit the possible MTU range
 when XDP is enabled
Message-ID: <20201124191136.GB12808@ranger.igk.intel.com>
References: <cover.1606150838.git.camelia.groza@nxp.com>
 <654d6300001825e542341bc052c31433b48b1913.1606150838.git.camelia.groza@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <654d6300001825e542341bc052c31433b48b1913.1606150838.git.camelia.groza@nxp.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 07:36:21PM +0200, Camelia Groza wrote:
> Implement the ndo_change_mtu callback to prevent users from setting an
> MTU that would permit processing of S/G frames. The maximum MTU size
> is dependent on the buffer size.
> 
> Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
> ---
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 40 ++++++++++++++++++++------
>  1 file changed, 31 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index 8acce62..ee076f4 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -2756,23 +2756,44 @@ static int dpaa_eth_stop(struct net_device *net_dev)
>  	return err;
>  }
>  
> +static bool xdp_validate_mtu(struct dpaa_priv *priv, int mtu)
> +{
> +	int max_contig_data = priv->dpaa_bp->size - priv->rx_headroom;
> +
> +	/* We do not support S/G fragments when XDP is enabled.
> +	 * Limit the MTU in relation to the buffer size.
> +	 */
> +	if (mtu + VLAN_ETH_HLEN + ETH_FCS_LEN > max_contig_data) {

Do you support VLAN double tagging? We normally take into acount to two vlan
headers in these checks.

Other than that:
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> +		dev_warn(priv->net_dev->dev.parent,
> +			 "The maximum MTU for XDP is %d\n",
> +			 max_contig_data - VLAN_ETH_HLEN - ETH_FCS_LEN);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static int dpaa_change_mtu(struct net_device *net_dev, int new_mtu)
> +{
> +	struct dpaa_priv *priv = netdev_priv(net_dev);
> +
> +	if (priv->xdp_prog && !xdp_validate_mtu(priv, new_mtu))
> +		return -EINVAL;
> +
> +	net_dev->mtu = new_mtu;
> +	return 0;
> +}
> +
>  static int dpaa_setup_xdp(struct net_device *net_dev, struct bpf_prog *prog)
>  {
>  	struct dpaa_priv *priv = netdev_priv(net_dev);
>  	struct bpf_prog *old_prog;
> -	int err, max_contig_data;
> +	int err;
>  	bool up;
>  
> -	max_contig_data = priv->dpaa_bp->size - priv->rx_headroom;
> -
>  	/* S/G fragments are not supported in XDP-mode */
> -	if (prog &&
> -	    (net_dev->mtu + VLAN_ETH_HLEN + ETH_FCS_LEN > max_contig_data)) {
> -		dev_warn(net_dev->dev.parent,
> -			 "The maximum MTU for XDP is %d\n",
> -			 max_contig_data - VLAN_ETH_HLEN - ETH_FCS_LEN);
> +	if (prog && !xdp_validate_mtu(priv, net_dev->mtu))
>  		return -EINVAL;
> -	}
>  
>  	up = netif_running(net_dev);
>  
> @@ -2870,6 +2891,7 @@ static int dpaa_ioctl(struct net_device *net_dev, struct ifreq *rq, int cmd)
>  	.ndo_set_rx_mode = dpaa_set_rx_mode,
>  	.ndo_do_ioctl = dpaa_ioctl,
>  	.ndo_setup_tc = dpaa_setup_tc,
> +	.ndo_change_mtu = dpaa_change_mtu,
>  	.ndo_bpf = dpaa_xdp,
>  };
>  
> -- 
> 1.9.1
> 
