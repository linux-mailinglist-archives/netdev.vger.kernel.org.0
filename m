Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294F033E101
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 23:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbhCPV7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 17:59:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229962AbhCPV7g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 17:59:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECA6464DFB;
        Tue, 16 Mar 2021 21:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615931976;
        bh=aTj2/QFOAu35eD4uSeHGwkUTJ0NKAZlQwVQwA5Z3hJs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rhKxmQK1oug+QdpdoOB6sl7rOz2G2X3Kyn8YwDhCUHrGczKiyi/rRAi30p5u+bZwW
         s2W8jpknEt3jlIcq86tqbEGuJeBwGVWVOLyu9nY/tJPBwOxLdUAM6iEVMyVHbbGk7j
         6dghAJAiRQQ18T5ntrqo/uIgV3rWMkyce+JSJTaehhgqos4u7KAdduGqA+sBjq1e3+
         bT8cjTjDxAg7yIIZn2hufSBTs3M54j2jzno33+IxQWrro3wHl2cimc+Ft2fYkVBZJB
         amNnvt0hg5v4tlyBF8cnbvBEvIV9wG5fnXPKquJk3kh8n11LRHcAMpu9M59u7sCHsL
         VR1Kbgr1igZjA==
Date:   Tue, 16 Mar 2021 14:59:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bhaskar Upadhaya <bupadhaya@marvell.com>
Cc:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>, <davem@davemloft.net>
Subject: Re: [PATCH net 1/2] qede: fix to disable start_xmit functionality
 during self adapter test
Message-ID: <20210316145935.6544c29b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1615919650-4262-2-git-send-email-bupadhaya@marvell.com>
References: <1615919650-4262-1-git-send-email-bupadhaya@marvell.com>
        <1615919650-4262-2-git-send-email-bupadhaya@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Mar 2021 11:34:09 -0700 Bhaskar Upadhaya wrote:
> start_xmit function should not be called during the execution of self
> adapter test, netif_tx_disable() gives this guarantee, since it takes
> the transmit queue lock while marking the queue stopped.  This will
> wait for the transmit function to complete before returning.
> 
> Fixes: 16f46bf054f8 ("qede: add implementation for internal loopback test.")
> Signed-off-by: Bhaskar Upadhaya <bupadhaya@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> ---
>  drivers/net/ethernet/qlogic/qede/qede_ethtool.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
> index 1560ad3d9290..f9702cc7bc55 100644
> --- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
> +++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
> @@ -1611,7 +1611,7 @@ static int qede_selftest_run_loopback(struct qede_dev *edev, u32 loopback_mode)
>  		return -EINVAL;
>  	}
>  
> -	qede_netif_stop(edev);
> +	netif_tx_disable(edev->ndev);

But an interrupt can come in after and enable Tx again.
I think you should keep the qede_netif_stop() here instead of moving 
it down, no?

>  	/* Bring up the link in Loopback mode */
>  	memset(&link_params, 0, sizeof(link_params));
> @@ -1623,6 +1623,8 @@ static int qede_selftest_run_loopback(struct qede_dev *edev, u32 loopback_mode)
>  	/* Wait for loopback configuration to apply */
>  	msleep_interruptible(500);
>  
> +	qede_netif_stop(edev);
> +
>  	/* Setting max packet size to 1.5K to avoid data being split over
>  	 * multiple BDs in cases where MTU > PAGE_SIZE.
>  	 */

