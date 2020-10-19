Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29429292DAC
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 20:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730866AbgJSSnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 14:43:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730710AbgJSSnW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 14:43:22 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 895C0222E9;
        Mon, 19 Oct 2020 18:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603133002;
        bh=b2QJk34z+3ifQSCj/0BnigPQn31Jz5SJrS4DHmzD/vk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OAyygtJSOw+Yi89YFc+Vm0nHE25PALgzP9u5e0/nmkuS+ux1ygPQDB0+ZXkeixSWP
         Veh8reTviWp6TvT2wvjeBbVXuALTYFsUBwIXmTGenH/5U0OnHRZx/b2fPugHCqqIzw
         N5MgRga6PmDZB0iaBMFysPi1rrWma/ugYLEYG7gk=
Date:   Mon, 19 Oct 2020 11:43:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        vaibhavgupta40@gmail.com, christophe.jaillet@wanadoo.fr,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtl8180: avoid accessing the data mapped to streaming
 DMA
Message-ID: <20201019114319.1b699ffa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201019025420.3789-1-baijiaju1990@gmail.com>
References: <20201019025420.3789-1-baijiaju1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 10:54:20 +0800 Jia-Ju Bai wrote:
> +	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
> +		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
> +			priv->seqno += 0x10;
> +		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
> +		hdr->seq_ctrl |= cpu_to_le16(priv->seqno);
> +	}
> +
>  	mapping = dma_map_single(&priv->pdev->dev, skb->data, skb->len,
>  				 DMA_TO_DEVICE);
>  
> @@ -534,13 +541,6 @@ static void rtl8180_tx(struct ieee80211_hw *dev,
>  
>  	spin_lock_irqsave(&priv->lock, flags);
>  
> -	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
> -		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
> -			priv->seqno += 0x10;

You're taking the priv->seqno access and modification from under
priv->lock. Is that okay?
