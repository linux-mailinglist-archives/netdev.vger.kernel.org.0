Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82078358932
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhDHQDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:03:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232103AbhDHQDD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 12:03:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4E78610F8;
        Thu,  8 Apr 2021 16:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617897771;
        bh=Q0wWDw1OxgwpjX52l5QxSa7TFbhSsZqrjGEEcc+tBUE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I5/m+X+7Ve3Iy11ihZ4B6ZimObNBDR4Z4whSJdRV6Lo7U80O1wYn/4SeiB60lhC9C
         AsLnIrYo3bZbX0V+bwa6CJnQomtlQqmKDr2LgB8iOFpzh3tpfio9mYuRzPdqnWMKHz
         oSe8JtVUsGAWlTaMMQ3GZGJANSO+XckFPhTnHUCGf+eDuhL8vPjgPqTa44x5zLddbQ
         fKi4HeQWMrrlRbPI2qH+8dcTAUNcA6YZcKfZiI08e0PqX0Jz/0SE9F23nrC3N4B3in
         qQUmHKO5J3R+xz84N0DAK0PGsvIPXM0ZDxOnwi3CUnpC7DwbsbEt6USPoXHvAN6onn
         am72A+Oc5pDFw==
Date:   Thu, 8 Apr 2021 09:02:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [net-next, v2, 2/2] enetc: support PTP Sync packet one-step
 timestamping
Message-ID: <20210408090250.21dee5c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210408111350.3817-3-yangbo.lu@nxp.com>
References: <20210408111350.3817-1-yangbo.lu@nxp.com>
        <20210408111350.3817-3-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  8 Apr 2021 19:13:50 +0800 Yangbo Lu wrote:
> This patch is to add support for PTP Sync packet one-step timestamping.
> Since ENETC single-step register has to be configured dynamically per
> packet for correctionField offeset and UDP checksum update, current
> one-step timestamping packet has to be sent only when the last one
> completes transmitting on hardware. So, on the TX below things are done
> by the patch:
> 
> - For one-step timestamping packet, queue to skb queue.
> - Start a work to transmit skbs in queue.
> - For other skbs, transmit immediately.
> - mutex lock used to ensure the last one-step timestamping packet has
>   already been transmitted on hardware before transmitting current one.
> 
> And the configuration for one-step timestamping on ENETC before
> transmitting is,
> 
> - Set one-step timestamping flag in extension BD.
> - Write 30 bits current timestamp in tstamp field of extension BD.
> - Update PTP Sync packet originTimestamp field with current timestamp.
> - Configure single-step register for correctionField offeset and UDP
>   checksum update.
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>

> @@ -432,9 +544,12 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
>  			xdp_return_frame(xdp_frame);
>  			tx_swbd->xdp_frame = NULL;
>  		} else if (skb) {
> -			if (unlikely(do_tstamp)) {
> +			if (unlikely(tx_swbd->skb->cb[0] &
> +				     ENETC_F_TX_ONESTEP_SYNC_TSTAMP)) {
> +				mutex_unlock(&priv->onestep_tstamp_lock);
> +			} else if (unlikely(do_twostep_tstamp)) {
>  				enetc_tstamp_tx(skb, tstamp);
> -				do_tstamp = false;
> +				do_twostep_tstamp = false;
>  			}
>  			napi_consume_skb(skb, napi_budget);
>  			tx_swbd->skb = NULL;
> @@ -1863,6 +1978,47 @@ static int enetc_phylink_connect(struct net_device *ndev)
>  	return 0;
>  }
>  
> +static void enetc_tx_onestep_tstamp(struct work_struct *work)
> +{
> +	struct enetc_ndev_priv *priv;
> +	struct sk_buff *skb;
> +
> +	priv = container_of(work, struct enetc_ndev_priv, tx_onestep_tstamp);
> +
> +	while (true) {
> +		skb = skb_dequeue(&priv->tx_skbs);
> +		if (!skb)
> +			return;
> +
> +		/* Lock before TX one-step timestamping packet, and release
> +		 * when the packet has been sent on hardware, or transmit
> +		 * failure.
> +		 */
> +		mutex_lock(&priv->onestep_tstamp_lock);

Using a lock to wake up a producer is not a great idea. It usually
breaks advanced features like priority inheritance. Probably doesn't
matter for a struct mutex, but I think it may still make lockdep
complain.

Why not make it work with a flag?

start_xmit:

	if (skb->cb[0] & ONESTEP) {
		if (priv->flags & ONESTEP_BUSY) {
			skb_queue_tail(&priv->tx_skbs, skb);
			return ...;
		}
		priv->flags |= ONESTEP_BUSY;
	}

clean_tx:

	/* don't clear ONESTEP_BUSY, we need the tx lock */
	if (skb->cb[0] & ONESTEP)
		queue_work(...);

work:

	netif_tx_lock()
	skb = skb_dequeue();
	if (skb)
		start_xmit(skb)
	else
		priv->flags &= ~ONESTEP_BUSY;
	netif_tx_unlock()

> +		netif_tx_lock(priv->ndev);
> +		enetc_start_xmit(skb, priv->ndev);
> +		netif_tx_unlock(priv->ndev);
> +	}
> +}
> +
> +static int enetc_tx_onestep_tstamp_init(struct enetc_ndev_priv *priv)
> +{
> +	priv->enetc_ptp_wq = alloc_workqueue("enetc_ptp_wq", 0, 0);
> +	if (!priv->enetc_ptp_wq)
> +		return -ENOMEM;
> +
> +	INIT_WORK(&priv->tx_onestep_tstamp, enetc_tx_onestep_tstamp);
> +	skb_queue_head_init(&priv->tx_skbs);
> +
> +	return 0;
> +}
> +
> +static void enetc_tx_onestep_tstamp_deinit(struct enetc_ndev_priv *priv)
> +{
> +	destroy_workqueue(priv->enetc_ptp_wq);
> +}

Why allocate a separate workqueue for one work? You can queue your
work on the system workqueue.
