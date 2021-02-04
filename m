Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD2230F73B
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 17:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237778AbhBDQHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 11:07:06 -0500
Received: from mga04.intel.com ([192.55.52.120]:42475 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237359AbhBDQGn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 11:06:43 -0500
IronPort-SDR: DtNVJsyHhMQ3DtSuipBu83/mLZT+gW2lsfhCF/4O4+vV6C85n43WRhsSyTgbz8OkHE/7UYNIhc
 M9YnwEcUgWwQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="178707174"
X-IronPort-AV: E=Sophos;i="5.79,401,1602572400"; 
   d="scan'208";a="178707174"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 08:05:58 -0800
IronPort-SDR: HpeXdAZvn8Drw5Ux+jjt5efMmIKP6OtdrB/4DJgy2GrNLzIRm3CLafn3gGfe1BnI02E/KQkxrA
 ibvdpzRjyK0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,401,1602572400"; 
   d="scan'208";a="415223229"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Feb 2021 08:05:56 -0800
Date:   Thu, 4 Feb 2021 16:56:39 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Camelia Groza <camelia.groza@nxp.com>
Cc:     kuba@kernel.org, davem@davemloft.net, madalin.bucur@oss.nxp.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 3/3] dpaa_eth: try to move the data in place for the
 A050385 erratum
Message-ID: <20210204155639.GB2580@ranger.igk.intel.com>
References: <cover.1612275417.git.camelia.groza@nxp.com>
 <387f3f2efeab12a7cb2b6933e3be10704dac48bf.1612275417.git.camelia.groza@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <387f3f2efeab12a7cb2b6933e3be10704dac48bf.1612275417.git.camelia.groza@nxp.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 07:34:44PM +0200, Camelia Groza wrote:
> The XDP frame's headroom might be large enough to accommodate the
> xdpf backpointer as well as shifting the data to an aligned address.
> 
> Try this first before resorting to allocating a new buffer and copying
> the data.
> 
> Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Camelia Groza <camelia.groza@nxp.com>

Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> ---
>  .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 20 ++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index 78dfa05f6d55..d093b56dc30f 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -2180,8 +2180,9 @@ static int dpaa_a050385_wa_xdpf(struct dpaa_priv *priv,
>  				struct xdp_frame **init_xdpf)
>  {
>  	struct xdp_frame *new_xdpf, *xdpf = *init_xdpf;
> -	void *new_buff;
> +	void *new_buff, *aligned_data;
>  	struct page *p;
> +	u32 data_shift;
>  	int headroom;
>  
>  	/* Check the data alignment and make sure the headroom is large
> @@ -2198,6 +2199,23 @@ static int dpaa_a050385_wa_xdpf(struct dpaa_priv *priv,
>  		return 0;
>  	}
>  
> +	/* Try to move the data inside the buffer just enough to align it and
> +	 * store the xdpf backpointer. If the available headroom isn't large
> +	 * enough, resort to allocating a new buffer and copying the data.
> +	 */
> +	aligned_data = PTR_ALIGN_DOWN(xdpf->data, DPAA_FD_DATA_ALIGNMENT);
> +	data_shift = xdpf->data - aligned_data;
> +
> +	/* The XDP frame's headroom needs to be large enough to accommodate
> +	 * shifting the data as well as storing the xdpf backpointer.
> +	 */
> +	if (xdpf->headroom  >= data_shift + priv->tx_headroom) {
> +		memmove(aligned_data, xdpf->data, xdpf->len);
> +		xdpf->data = aligned_data;
> +		xdpf->headroom = priv->tx_headroom;
> +		return 0;
> +	}
> +
>  	/* The new xdp_frame is stored in the new buffer. Reserve enough space
>  	 * in the headroom for storing it along with the driver's private
>  	 * info. The headroom needs to be aligned to DPAA_FD_DATA_ALIGNMENT to
> -- 
> 2.17.1
> 
