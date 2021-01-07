Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B1D2EE79F
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 22:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbhAGVZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 16:25:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55828 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbhAGVZW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 16:25:22 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kxclq-00Gkhr-4A; Thu, 07 Jan 2021 22:24:38 +0100
Date:   Thu, 7 Jan 2021 22:24:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        laurentiu.tudor@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH 4/6] dpaa2-eth: retry the probe when the MAC is not yet
 discovered on the bus
Message-ID: <X/d8FkhFsfnlp2hA@lunn.ch>
References: <20210107153638.753942-1-ciorneiioana@gmail.com>
 <20210107153638.753942-5-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107153638.753942-5-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 05:36:36PM +0200, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> The fsl_mc_get_endpoint() function now returns -EPROBE_DEFER when the
> dpmac device was not yet discovered by the fsl-mc bus. When this
> happens, pass the error code up so that we can retry the probe at a
> later time.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> index f3f53e36aa00..3297e390476b 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> @@ -4042,6 +4042,10 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
>  
>  	dpni_dev = to_fsl_mc_device(priv->net_dev->dev.parent);
>  	dpmac_dev = fsl_mc_get_endpoint(dpni_dev);
> +
> +	if (PTR_ERR(dpmac_dev) == -EPROBE_DEFER)
> +		return PTR_ERR(dpmac_dev);
> +
>  	if (IS_ERR_OR_NULL(dpmac_dev) || dpmac_dev->dev.type != &fsl_mc_bus_dpmac_type)

Hi Ioana

Given the previous change, i don't think dpmac_dev can be NULL, so you
can change this to IS_ERR(). IS_ERR_OR_NULL() often triggers extra
review work because it is easy to get it wrong, so removing it is nice.

       Andrew
