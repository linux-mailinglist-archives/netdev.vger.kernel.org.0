Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4159CC27D
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 20:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbfJDSSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 14:18:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33198 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfJDSSe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 14:18:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KgvhD2KWl5QxHzscY/loy1FsMMZ1HUlegulTjj4OyJE=; b=52FMSBoGGOKPLgNs3i/kbh/7FL
        eXbUyHUHxfa+uhxWpnFAnNmgIkMdYavEoPyi4t47cNMSLnnMluHzr/hoE+H0V8RDJQrQ/fTnGqeot
        shjdKR8VdNOjmbrk/ZXthPGEmDhZnAT7yFngWxrSHtluHeyDUrU4WWngdUWrXXGP4X90=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iGS9s-0002jd-Ix; Fri, 04 Oct 2019 20:18:28 +0200
Date:   Fri, 4 Oct 2019 20:18:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Subject: Re: [PATCH 3/3] dpaa2-eth: Avoid unbounded while loops
Message-ID: <20191004181828.GB9935@lunn.ch>
References: <1570180893-9538-1-git-send-email-ioana.ciornei@nxp.com>
 <1570180893-9538-4-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1570180893-9538-4-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 04, 2019 at 12:21:33PM +0300, Ioana Ciornei wrote:
> From: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> 
> Throughout the driver there are several places where we wait
> indefinitely for DPIO portal commands to be executed, while
> the portal returns a busy response code.
> 
> Even though in theory we are guaranteed the portals become
> available eventually, in practice the QBMan hardware module
> may become unresponsive in various corner cases.
> 
> Make sure we can never get stuck in an infinite while loop
> by adding a retry counter for all portal commands.
> 
> Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 30 ++++++++++++++++++++----
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h |  8 +++++++
>  2 files changed, 33 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> index 2c5072fa9aa0..29702756734c 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> @@ -221,6 +221,7 @@ static void xdp_release_buf(struct dpaa2_eth_priv *priv,
>  			    struct dpaa2_eth_channel *ch,
>  			    dma_addr_t addr)
>  {
> +	int retries = 0;
>  	int err;
>  
>  	ch->xdp.drop_bufs[ch->xdp.drop_cnt++] = addr;
> @@ -229,8 +230,11 @@ static void xdp_release_buf(struct dpaa2_eth_priv *priv,
>  
>  	while ((err = dpaa2_io_service_release(ch->dpio, priv->bpid,
>  					       ch->xdp.drop_bufs,
> -					       ch->xdp.drop_cnt)) == -EBUSY)
> +					       ch->xdp.drop_cnt)) == -EBUSY) {
> +		if (retries++ >= DPAA2_ETH_SWP_BUSY_RETRIES)
> +			break;
>  		cpu_relax();
> +	}
>  
>  	if (err) {
>  		free_bufs(priv, ch->xdp.drop_bufs, ch->xdp.drop_cnt);
> @@ -458,7 +462,7 @@ static int consume_frames(struct dpaa2_eth_channel *ch,
>  	struct dpaa2_eth_fq *fq = NULL;
>  	struct dpaa2_dq *dq;
>  	const struct dpaa2_fd *fd;
> -	int cleaned = 0;
> +	int cleaned = 0, retries = 0;
>  	int is_last;
>  
>  	do {
> @@ -469,6 +473,11 @@ static int consume_frames(struct dpaa2_eth_channel *ch,
>  			 * the store until we get some sort of valid response
>  			 * token (either a valid frame or an "empty dequeue")
>  			 */
> +			if (retries++ >= DPAA2_ETH_SWP_BUSY_RETRIES) {
> +				netdev_err_once(priv->net_dev,
> +						"Unable to read a valid dequeue response\n");
> +				return 0;
> +			}
>  			continue;

Hi Ioana

It seems a bit odd that here you could return -ETIMEDOUT, but you
print an error, and return 0. But in the two cases above in void
functions, you don't print anything.

Please at least return -ETIMEDOUT when you can.

       Andrew
