Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D8A30F76C
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 17:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237760AbhBDQOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 11:14:16 -0500
Received: from mga17.intel.com ([192.55.52.151]:9911 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237631AbhBDQIx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 11:08:53 -0500
IronPort-SDR: Ne2SAtKc+EH0M1ksC1PlkWB0DaoY9Eedgarc+dfebN3fdcnjNmnfMY1xuz25oM9IRSRttwUj4I
 nJ/DNawnSp/g==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="161025234"
X-IronPort-AV: E=Sophos;i="5.79,401,1602572400"; 
   d="scan'208";a="161025234"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 08:07:22 -0800
IronPort-SDR: c+jdb7JXd2t0VvhuqvSTRHc8VZqvpxiZQkpv5pP/W+iBiIYeiOSskyD9PO9X9b1QCnqysaqy4e
 75gUFQ1AB0GQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,401,1602572400"; 
   d="scan'208";a="434006013"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga001.jf.intel.com with ESMTP; 04 Feb 2021 08:07:20 -0800
Date:   Thu, 4 Feb 2021 16:58:03 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Camelia Groza <camelia.groza@nxp.com>
Cc:     kuba@kernel.org, davem@davemloft.net, madalin.bucur@oss.nxp.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 2/3] dpaa_eth: reduce data alignment requirements for
 the A050385 erratum
Message-ID: <20210204155803.GC2580@ranger.igk.intel.com>
References: <cover.1612275417.git.camelia.groza@nxp.com>
 <6e534e4b2da14bb57331446e950a49f237f979c0.1612275417.git.camelia.groza@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e534e4b2da14bb57331446e950a49f237f979c0.1612275417.git.camelia.groza@nxp.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 07:34:43PM +0200, Camelia Groza wrote:
> The 256 byte data alignment is required for preventing DMA transaction
> splits when crossing 4K page boundaries. Since XDP deals only with page
> sized buffers or less, this restriction isn't needed. Instead, the data
> only needs to be aligned to 64 bytes to prevent DMA transaction splits.
> 
> These lessened restrictions can increase performance by widening the pool
> of permitted data alignments and preventing unnecessary realignments.
> 
> Fixes: ae680bcbd06a ("dpaa_eth: implement the A050385 erratum workaround for XDP")
> Signed-off-by: Camelia Groza <camelia.groza@nxp.com>

Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> ---
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index e1d041c35ad9..78dfa05f6d55 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -2192,7 +2192,7 @@ static int dpaa_a050385_wa_xdpf(struct dpaa_priv *priv,
>  	 * byte frame headroom. If the XDP program uses all of it, copy the
>  	 * data to a new buffer and make room for storing the backpointer.
>  	 */
> -	if (PTR_IS_ALIGNED(xdpf->data, DPAA_A050385_ALIGN) &&
> +	if (PTR_IS_ALIGNED(xdpf->data, DPAA_FD_DATA_ALIGNMENT) &&
>  	    xdpf->headroom >= priv->tx_headroom) {
>  		xdpf->headroom = priv->tx_headroom;
>  		return 0;
> -- 
> 2.17.1
> 
