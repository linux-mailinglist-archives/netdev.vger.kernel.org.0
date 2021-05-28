Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0753E39490E
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 01:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhE1XNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 19:13:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhE1XNH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 19:13:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FC68613EB;
        Fri, 28 May 2021 23:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622243492;
        bh=6R6S4sFCJq92IstxTP9ek22qzcdli0PcwyHoyNTTrkU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qsBPeIy9Mj1YUWEX30WNcd5Nlp6nThlJQ/ma7GuKMXqlx0Oh5VQG0myAIWoLfRH3N
         8LB4P6BLQuYVb8HOuQEBdzxGIKL/BPHxtdvNZdkCheE8hX4IZaHailXDw8q2qpTs4t
         8cDArsgG+D1BAK6toogvZXTjucPP7+/KUtnAZBVhmV0VhIATiOEIuMxR3YVz/LhcEu
         YWsMbmQxzlMheFjnxGYodZKPOhtUz37G+pIT+MmZ94snbMJDziSZQWHR+MUzchqi5a
         /zG5Qjrg59El7yZGywKCf7UaixonmaJQl0ed8cuAMeqhw8Bh8l4WR4kFx5V4EvUFtB
         45VNy8LsMP0XQ==
Date:   Fri, 28 May 2021 16:11:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sharath Chandra Vurukala <sharathv@codeaurora.org>
Cc:     davem@davemloft.net, elder@kernel.org, cpratapa@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v7 3/3] net: ethernet: rmnet: Add support for
 MAPv5 egress packets
Message-ID: <20210528161131.5f7b9920@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1622105322-2975-4-git-send-email-sharathv@codeaurora.org>
References: <1622105322-2975-1-git-send-email-sharathv@codeaurora.org>
        <1622105322-2975-4-git-send-email-sharathv@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 May 2021 14:18:42 +0530 Sharath Chandra Vurukala wrote:
> Adding support for MAPv5 egress packets.
> 
> This involves adding the MAPv5 header and setting the csum_valid_required
> in the checksum header to request HW compute the checksum.
> 
> Corresponding stats are incremented based on whether the checksum is
> computed in software or HW.
> 
> New stat has been added which represents the count of packets whose
> checksum is calculated by the HW.
> 
> Signed-off-by: Sharath Chandra Vurukala <sharathv@codeaurora.org>

> +static void rmnet_map_v5_checksum_uplink_packet(struct sk_buff *skb,
> +						struct rmnet_port *port,
> +						struct net_device *orig_dev)
> +{
> +	struct rmnet_priv *priv = netdev_priv(orig_dev);
> +	struct rmnet_map_v5_csum_header *ul_header;
> +
> +	if (!(port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV5))
> +		return;

how can we get here if this condition is not met? Looks like defensive
programming.

> +	ul_header = skb_push(skb, sizeof(*ul_header));

Are you making sure you can modify head? I only see a check if there is
enough headroom but not if head is writable (skb_cow_head()).

> +	memset(ul_header, 0, sizeof(*ul_header));
> +	ul_header->header_info = u8_encode_bits(RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD,
> +						MAPV5_HDRINFO_HDR_TYPE_FMASK);

Is prepending the header required even when packet doesn't need
checksuming?

> +	if (skb->ip_summed == CHECKSUM_PARTIAL) {
> +		void *iph = (char *)ul_header + sizeof(*ul_header);

ip_hdr(skb)

> +		__sum16 *check;
> +		void *trans;
> +		u8 proto;
> +
> +		if (skb->protocol == htons(ETH_P_IP)) {
> +			u16 ip_len = ((struct iphdr *)iph)->ihl * 4;
> +
> +			proto = ((struct iphdr *)iph)->protocol;
> +			trans = iph + ip_len;
> +		} else if (skb->protocol == htons(ETH_P_IPV6)) {
> +#if IS_ENABLED(CONFIG_IPV6)
> +			u16 ip_len = sizeof(struct ipv6hdr);
> +
> +			proto = ((struct ipv6hdr *)iph)->nexthdr;
> +			trans = iph + ip_len;
> +#else
> +			priv->stats.csum_err_invalid_ip_version++;
> +			goto sw_csum;
> +#endif /* CONFIG_IPV6 */
> +		} else {
> +			priv->stats.csum_err_invalid_ip_version++;
> +			goto sw_csum;
> +		}
> +
> +		check = rmnet_map_get_csum_field(proto, trans);
> +		if (check) {
> +			skb->ip_summed = CHECKSUM_NONE;
> +			/* Ask for checksum offloading */
> +			ul_header->csum_info |= MAPV5_CSUMINFO_VALID_FLAG;
> +			priv->stats.csum_hw++;
> +			return;

Please try to keep the success path unindented.

> +		}
> +	}
> +
> +sw_csum:
> +	priv->stats.csum_sw++;
> +}
