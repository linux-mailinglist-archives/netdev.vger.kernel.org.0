Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6EF309132
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 02:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbhA3BOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 20:14:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233101AbhA3BCL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 20:02:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FC5564DD9;
        Sat, 30 Jan 2021 01:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611968490;
        bh=1lkQFTPKWiGJMf5OSr3Wu804WMTim4ZTfLxreJ4E9RI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ljA4dk5/6OGc5lVjs26m1lQHh2Q9wNoB7vUu7FaUVcd1m/EZdu6rO0i2FUwGT/EtG
         NGOjXXe0KH/D9391kbJyHV3Ko7A6dSxeL+037+/BTHvI5G+S8orlzTizHPcNMeTP5r
         1YJ8iZB2m8It5YmSd47Q/I+Uk7fFJL3uuqaGaxfmxEOJnpwkYCPAZlsnvfva8xf7vt
         Kmo7c8QXavTUB2wqJ29d9FiRbrYRQtmlhqBlDdqsV7BsTOjNro+ey6SUlHsa+tpIkp
         TNNuTLfv9ANihmK4mQmUYf08v1kFSlv/rrsFijQ3ZklxyjPK9G1kiHbBqsIEzHEuA5
         Qez4R3nF6xHPw==
Date:   Fri, 29 Jan 2021 17:01:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH net-next] net: mhi-net: Add de-aggeration support
Message-ID: <20210129170129.0a4a682a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1611589557-31012-1-git-send-email-loic.poulain@linaro.org>
References: <1611589557-31012-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 16:45:57 +0100 Loic Poulain wrote:
> When device side MTU is larger than host side MRU, the packets
> (typically rmnet packets) are split over multiple MHI transfers.
> In that case, fragments must be re-aggregated to recover the packet
> before forwarding to upper layer.
> 
> A fragmented packet result in -EOVERFLOW MHI transaction status for
> each of its fragments, except the final one. Such transfer was
> previoulsy considered as error and fragments were simply dropped.
> 
> This patch implements the aggregation mechanism allowing to recover
> the initial packet. It also prints a warning (once) since this behavior
> usually comes from a misconfiguration of the device (modem).
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

> +static struct sk_buff *mhi_net_skb_append(struct mhi_device *mhi_dev,
> +					  struct sk_buff *skb1,
> +					  struct sk_buff *skb2)
> +{
> +	struct sk_buff *new_skb;
> +
> +	/* This is the first fragment */
> +	if (!skb1)
> +		return skb2;
> +
> +	/* Expand packet */
> +	new_skb = skb_copy_expand(skb1, 0, skb2->len, GFP_ATOMIC);
> +	dev_kfree_skb_any(skb1);
> +	if (!new_skb)
> +		return skb2;

I don't get it, if you failed to grow the skb you'll return the next
fragment to the caller? So the frame just lost all of its data up to
where skb2 started? The entire fragment "train" should probably be
dropped at this point.

I think you can just hang the skbs off skb_shinfo(p)->frag_list.

Willem - is it legal to feed frag_listed skbs into netif_rx()?

> +	/* Append to expanded packet */
> +	memcpy(skb_put(new_skb, skb2->len), skb2->data, skb2->len);
> +
> +	/* free appended skb */
> +	dev_kfree_skb_any(skb2);
> +
> +	return new_skb;
> +}
> +
>  static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
>  				struct mhi_result *mhi_res)
>  {
> @@ -143,19 +169,44 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
>  	remaining = atomic_dec_return(&mhi_netdev->stats.rx_queued);
>  
>  	if (unlikely(mhi_res->transaction_status)) {
> -		dev_kfree_skb_any(skb);
> -
> -		/* MHI layer stopping/resetting the DL channel */
> -		if (mhi_res->transaction_status == -ENOTCONN)
> +		switch (mhi_res->transaction_status) {
> +		case -EOVERFLOW:
> +			/* Packet can not fit in one MHI buffer and has been
> +			 * split over multiple MHI transfers, do re-aggregation.
> +			 * That usually means the device side MTU is larger than
> +			 * the host side MTU/MRU. Since this is not optimal,
> +			 * print a warning (once).
> +			 */
> +			netdev_warn_once(mhi_netdev->ndev,
> +					 "Fragmented packets received, fix MTU?\n");
> +			skb_put(skb, mhi_res->bytes_xferd);
> +			mhi_netdev->skbagg = mhi_net_skb_append(mhi_dev,
> +								mhi_netdev->skbagg,
> +								skb);
> +			break;
> +		case -ENOTCONN:
> +			/* MHI layer stopping/resetting the DL channel */
> +			dev_kfree_skb_any(skb);
>  			return;
> -
> -		u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
> -		u64_stats_inc(&mhi_netdev->stats.rx_errors);
> -		u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
> +		default:
> +			/* Unknown error, simply drop */
> +			dev_kfree_skb_any(skb);
> +			u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
> +			u64_stats_inc(&mhi_netdev->stats.rx_errors);
> +			u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
> +		}
>  	} else {
> +		skb_put(skb, mhi_res->bytes_xferd);
> +
> +		if (mhi_netdev->skbagg) {
> +			/* Aggregate the final fragment */
> +			skb = mhi_net_skb_append(mhi_dev, mhi_netdev->skbagg, skb);
> +			mhi_netdev->skbagg = NULL;
> +		}
> +
>  		u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
>  		u64_stats_inc(&mhi_netdev->stats.rx_packets);
> -		u64_stats_add(&mhi_netdev->stats.rx_bytes, mhi_res->bytes_xferd);
> +		u64_stats_add(&mhi_netdev->stats.rx_bytes, skb->len);
>  		u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
>  
>  		switch (skb->data[0] & 0xf0) {
