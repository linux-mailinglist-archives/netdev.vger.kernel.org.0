Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431852B0FAB
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 21:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgKLU4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 15:56:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:36672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726844AbgKLU4D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 15:56:03 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B6E222227;
        Thu, 12 Nov 2020 20:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605214562;
        bh=K/nknkRZIdwaNmljoW5rAoMu3QYlkYLVH0+Ym0LD+zg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=16xfNjDlmioQ8JIjxRWcWA6Ah4p5THoR4gGnUTnqdAciH3zhj8kh7TTv4eoaNQR+0
         6e2S1pDgoo4JaoDduenwYD2z8Nhm0uOxTmE926ieqTqJ/RMTzYn94IhX6gDy5o0tCx
         6Ej9o4l5F3uvyiHuxtwxfxXn2bzTuVHA8um266ZE=
Message-ID: <2380dc4cfc21ab598623a20c2569c8bf6444c12d.camel@kernel.org>
Subject: Re: [PATCH net-next 4/7] dpaa_eth: add XDP_TX support
From:   Saeed Mahameed <saeed@kernel.org>
To:     Camelia Groza <camelia.groza@nxp.com>, kuba@kernel.org,
        brouer@redhat.com, davem@davemloft.net
Cc:     madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        netdev@vger.kernel.org
Date:   Thu, 12 Nov 2020 12:55:59 -0800
In-Reply-To: <ba14ff6342f74c6cdc086d31c2ca77248f371003.1605181416.git.camelia.groza@nxp.com>
References: <cover.1605181416.git.camelia.groza@nxp.com>
         <ba14ff6342f74c6cdc086d31c2ca77248f371003.1605181416.git.camelia.groza@nxp.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-11-12 at 20:10 +0200, Camelia Groza wrote:
> Use an xdp_frame structure for managing the frame. Store a
> backpointer to
> the structure at the start of the buffer before enqueueing. Use the
> XDP
> API for freeing the buffer when it returns to the driver on the TX
> confirmation path.
> 
> This approach will be reused for XDP REDIRECT.
> 
> Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
> ---
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 129
> ++++++++++++++++++++++++-
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.h |   2 +
>  2 files changed, 126 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index b9b0db2..343d693 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -1130,6 +1130,24 @@ static int dpaa_fq_init(struct dpaa_fq
> *dpaa_fq, bool td_enable)
>  
>  	dpaa_fq->fqid = qman_fq_fqid(fq);
>  
> +	if (dpaa_fq->fq_type == FQ_TYPE_RX_DEFAULT ||
> +	    dpaa_fq->fq_type == FQ_TYPE_RX_PCD) {
> +		err = xdp_rxq_info_reg(&dpaa_fq->xdp_rxq, dpaa_fq-
> >net_dev,
> +				       dpaa_fq->fqid);
> +		if (err) {
> +			dev_err(dev, "xdp_rxq_info_reg failed\n");
> +			return err;
> +		}
> +
> +		err = xdp_rxq_info_reg_mem_model(&dpaa_fq->xdp_rxq,
> +						 MEM_TYPE_PAGE_ORDER0,
> NULL);

why not MEM_TYPE_PAGE_POOL? 

@Jesper how can we encourage new drivers to implement XDP
with MEM_TYPE_PAGE_POOL ?



