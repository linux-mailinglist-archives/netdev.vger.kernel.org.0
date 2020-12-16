Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639D82DC73C
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388815AbgLPTdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:33:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:57258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388813AbgLPTdP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 14:33:15 -0500
Date:   Wed, 16 Dec 2020 11:20:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608146457;
        bh=TS1IR2OjuR4ugpA0sKUVRrcnUvxPfL18g14qAk4wF6Y=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=l/Vp5UDEG/yAhKfiuh3YXPL4vrc55ysN7CzAHJkJCKlf6WnOlWdG4SuISjRjvjZ3i
         /f1+dvO2NTIbpQ4ZKvExaXeH2Hv6Gs2/cdjqkUALxJytDMpwItmh4hFSgiggmvo3TE
         N/iWleD0hFmgi3g4U9ZEhMnjbMB09B4VgeKD0YmwZkQanC3HM4P2HftnbjDqTqokNt
         nplctLXVqV8SdcfKyC7v2IPtWRADsr3G9vMj291Y8TJkD1y+EnAURqt9+YuEVDpSgP
         17pt7qLlysr3Y4XqEIEnIP4iZ4lSa9zt7lmp153NtEpk3UrKmzRTjip1M76fvs1ZQH
         IiYmUWc9R7gKQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH] net: mhi: Add raw IP mode support
Message-ID: <20201216112056.4224a4a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1607962344-26325-1-git-send-email-loic.poulain@linaro.org>
References: <1607962344-26325-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 17:12:24 +0100 Loic Poulain wrote:
> MHI net is protocol agnostic, the payload protocol depends on the modem
> configuration, which can be either RMNET (IP muxing and aggregation) or
> raw IP. This patch adds support for incomming IPv4/IPv6 packets, that
> was previously unconditionnaly reported as RMNET packets.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  drivers/net/mhi_net.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
> index 5af6247..a1fb2b8 100644
> --- a/drivers/net/mhi_net.c
> +++ b/drivers/net/mhi_net.c
> @@ -260,7 +260,18 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
>  		u64_stats_add(&mhi_netdev->stats.rx_bytes, skb->len);
>  		u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
>  
> -		skb->protocol = htons(ETH_P_MAP);
> +		switch (skb->data[0] & 0xf0) {
> +		case 0x40:
> +			skb->protocol = htons(ETH_P_IP);
> +			break;
> +		case 0x60:
> +			skb->protocol = htons(ETH_P_IPV6);
> +			break;
> +		default:
> +			skb->protocol = htons(ETH_P_MAP);
> +			break;
> +		}

This doesn't apply, there is a skb_put() right here in the networking
tree :S Are we missing some other fix?

>  		netif_rx(skb);
>  	}
>  

