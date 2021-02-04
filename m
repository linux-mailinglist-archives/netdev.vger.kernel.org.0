Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B1330EF2E
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 10:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbhBDJB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 04:01:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:14801 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231367AbhBDJB4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 04:01:56 -0500
IronPort-SDR: odar9NWcFjx8xYnVO9RU4pwG6xJlV6BR7XeklVQr0muH8y//MtiBY9dXPeLCbiFHO8BsZftzTE
 VdfYxUDfSs/w==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="181345758"
X-IronPort-AV: E=Sophos;i="5.79,400,1602572400"; 
   d="scan'208";a="181345758"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 01:01:14 -0800
IronPort-SDR: iKmfqZSAaiVKcGxjlFVkXgVilZiWE+a+iariVSL4HT5TUs8ouHi1BejU/yxgvF1zdhFIccDM5y
 2Nih4p4McA3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,400,1602572400"; 
   d="scan'208";a="579813960"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga006.fm.intel.com with ESMTP; 04 Feb 2021 01:01:13 -0800
Date:   Thu, 4 Feb 2021 09:51:58 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Camelia Groza <camelia.groza@nxp.com>
Cc:     kuba@kernel.org, davem@davemloft.net, madalin.bucur@oss.nxp.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 1/3] dpaa_eth: reserve space for the xdp_frame under
 the A050385 erratum
Message-ID: <20210204085158.GA2580@ranger.igk.intel.com>
References: <cover.1612275417.git.camelia.groza@nxp.com>
 <b2e61a1ac55004ecbbe326cd878cd779df22aae8.1612275417.git.camelia.groza@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2e61a1ac55004ecbbe326cd878cd779df22aae8.1612275417.git.camelia.groza@nxp.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 07:34:42PM +0200, Camelia Groza wrote:
> When the erratum workaround is triggered, the newly created xdp_frame
> structure is stored at the start of the newly allocated buffer. Avoid
> the structure from being overwritten by explicitly reserving enough
> space in the buffer for storing it.
> 
> Account for the fact that the structure's size might increase in time by
> aligning the headroom to DPAA_FD_DATA_ALIGNMENT bytes, thus guaranteeing
> the data's alignment.
> 
> Fixes: ae680bcbd06a ("dpaa_eth: implement the A050385 erratum workaround for XDP")
> Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
> ---
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index 4360ce4d3fb6..e1d041c35ad9 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -2182,6 +2182,7 @@ static int dpaa_a050385_wa_xdpf(struct dpaa_priv *priv,
>  	struct xdp_frame *new_xdpf, *xdpf = *init_xdpf;
>  	void *new_buff;
>  	struct page *p;
> +	int headroom;
>  
>  	/* Check the data alignment and make sure the headroom is large
>  	 * enough to store the xdpf backpointer. Use an aligned headroom
> @@ -2197,19 +2198,31 @@ static int dpaa_a050385_wa_xdpf(struct dpaa_priv *priv,
>  		return 0;
>  	}
>  
> +	/* The new xdp_frame is stored in the new buffer. Reserve enough space
> +	 * in the headroom for storing it along with the driver's private
> +	 * info. The headroom needs to be aligned to DPAA_FD_DATA_ALIGNMENT to
> +	 * guarantee the data's alignment in the buffer.
> +	 */
> +	headroom = ALIGN(sizeof(*new_xdpf) + priv->tx_headroom,
> +			 DPAA_FD_DATA_ALIGNMENT);
> +
> +	/* Assure the extended headroom and data fit in a one-paged buffer */
> +	if (headroom + xdpf->len > DPAA_BP_RAW_SIZE)

This check might make more sense if you would be accounting for
skb_shared_info as well I suppose, so that you know you'll still provide
enough tailroom for future xdp multibuf support. Didn't all the previous
code path make sure that there's a room for that?

> +		return -ENOMEM;
> +
>  	p = dev_alloc_pages(0);
>  	if (unlikely(!p))
>  		return -ENOMEM;
>  
>  	/* Copy the data to the new buffer at a properly aligned offset */
>  	new_buff = page_address(p);
> -	memcpy(new_buff + priv->tx_headroom, xdpf->data, xdpf->len);
> +	memcpy(new_buff + headroom, xdpf->data, xdpf->len);
>  
>  	/* Create an XDP frame around the new buffer in a similar fashion
>  	 * to xdp_convert_buff_to_frame.
>  	 */
>  	new_xdpf = new_buff;
> -	new_xdpf->data = new_buff + priv->tx_headroom;
> +	new_xdpf->data = new_buff + headroom;
>  	new_xdpf->len = xdpf->len;
>  	new_xdpf->headroom = priv->tx_headroom;
>  	new_xdpf->frame_sz = DPAA_BP_RAW_SIZE;
> -- 
> 2.17.1
> 
