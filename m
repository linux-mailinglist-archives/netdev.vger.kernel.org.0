Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1904133E0E2
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 22:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhCPVyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 17:54:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229545AbhCPVyc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 17:54:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D568B64F75;
        Tue, 16 Mar 2021 21:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615931672;
        bh=cq0tdhMaaWvuMNhpv3wfqehn4+KPZO5zc8VD6x0LNXU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ABhWD67aElNLZC24Hnqnc9bqSi/9fUpgRmivnEnuQ2J4XaDBOMEbTIRQCn/a7fz/6
         iJRBcExTl4EJpkXdV7ah20wQXgf9jvRYSBwv0Rj68IjH2ZisN6wChayAP/Jx/Dgb1u
         iGzlXPTVItm0r/S9EgE5/mZPOlSI7rXUx42HpuRcUHRhBuqOMq4k4a0dAN6/3h0Ogp
         k3Uhlzui2PiE5qpzByNLr0iBE6kllAQdkLkapgHqhgb+R5cZXnFVPTWoblUGaf1icp
         rTIVRrjqaQhFfyTVNJTTr/GqAporHIh+C4QSG96G8BInTSCg+ySTlK5DdrNkVp8k1p
         qNVIQihnYY7vg==
Date:   Tue, 16 Mar 2021 14:54:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, drivers@pensando.io
Subject: Re: [PATCH net] ionic: linearize tso skb with too many frags
Message-ID: <20210316145431.232672d5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210316185243.30053-1-snelson@pensando.io>
References: <20210316185243.30053-1-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Mar 2021 11:52:43 -0700 Shannon Nelson wrote:
> We were linearizing non-TSO skbs that had too many frags, but
> we weren't checking number of frags on TSO skbs.  This could
> lead to a bad page reference when we received a TSO skb with
> more frags than the Tx descriptor could support.
> 
> Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  .../net/ethernet/pensando/ionic/ionic_txrx.c  | 28 ++++++++++---------
>  1 file changed, 15 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
> index 162a1ff1e9d2..462b0d106be4 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
> @@ -1079,25 +1079,27 @@ static int ionic_tx_descs_needed(struct ionic_queue *q, struct sk_buff *skb)
>  {
>  	int sg_elems = q->lif->qtype_info[IONIC_QTYPE_TXQ].max_sg_elems;
>  	struct ionic_tx_stats *stats = q_to_tx_stats(q);
> +	int ndescs;
>  	int err;
>  
> -	/* If TSO, need roundup(skb->len/mss) descs */
> +	/* If TSO, need roundup(skb->len/mss) descs
> +	 * If non-TSO, just need 1 desc and nr_frags sg elems
> +	 */
>  	if (skb_is_gso(skb))
> -		return (skb->len / skb_shinfo(skb)->gso_size) + 1;
> +		ndescs = (skb->len / skb_shinfo(skb)->gso_size) + 1;

Slightly unrelated but why not gso_segs? len / gso_size + 1 could be
over counting, not to mention that div is expensive.

Are you segmenting in the driver? Why do you need #segs descriptors?

> +	else
> +		ndescs = 1;
>  
> -	/* If non-TSO, just need 1 desc and nr_frags sg elems */
> -	if (skb_shinfo(skb)->nr_frags <= sg_elems)
> -		return 1;
> +	/* If too many frags, linearize */
> +	if (skb_shinfo(skb)->nr_frags > sg_elems) {
> +		err = skb_linearize(skb);
> +		if (err)
> +			return err;
>  
> -	/* Too many frags, so linearize */
> -	err = skb_linearize(skb);
> -	if (err)
> -		return err;
> -
> -	stats->linearize++;
> +		stats->linearize++;
> +	}
>  
> -	/* Need 1 desc and zero sg elems */
> -	return 1;
> +	return ndescs;

I'd be tempted to push back on the refactoring here, you could've 
just replaced return 1;s with return ndescs;s without changing 
the indentation.. this will give all backporters a pause. But 
not the end of the world, I guess.

>  }
>  
>  static int ionic_maybe_stop_tx(struct ionic_queue *q, int ndescs)
