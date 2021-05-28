Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998033948FB
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 00:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbhE1W7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 18:59:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229500AbhE1W7g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 18:59:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D5566117A;
        Fri, 28 May 2021 22:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622242681;
        bh=JlEG/zQxxHilWYdiU0HA8CidwHpZOTrzJ+D1BxnKB7o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DaGrbtzot67fkFJv/4c9ggQVEMv/SWen+LHxrBCBjGPtAvXwgyB/ZzqkS+p7wwD4Q
         3Ok+tKPqQesy2VPB4IVYVMuNWwWzksONGzLOJbycybs9gcdekU/seQ364dAczmBI4k
         NZ+3ky3fK+P4qHgsF+AzB4cOKekgPnsHR8CAs2eWdXheaMUyaK5m9jS3u+PiZMviPO
         AEVnd2mkczKS7tc7BOVAKvW4XAIjDLuJIrcBq3DmJ4KJVabwUlyklAZoH+5/v0UEt1
         v6UG0S+ejjXZSLGVwHnQQg/JHzOLt3l7OLZt+grE4fgGy6jz1UJJfdV0vXPSqsCZUd
         uLTq7Wry4mapQ==
Date:   Fri, 28 May 2021 15:58:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sharath Chandra Vurukala <sharathv@codeaurora.org>
Cc:     davem@davemloft.net, elder@kernel.org, cpratapa@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v7 2/3] net: ethernet: rmnet: Support for
 ingress MAPv5 checksum offload
Message-ID: <20210528155800.0514d249@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1622105322-2975-3-git-send-email-sharathv@codeaurora.org>
References: <1622105322-2975-1-git-send-email-sharathv@codeaurora.org>
        <1622105322-2975-3-git-send-email-sharathv@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 May 2021 14:18:41 +0530 Sharath Chandra Vurukala wrote:
> Adding support for processing of MAPv5 downlink packets.
> It involves parsing the Mapv5 packet and checking the csum header
> to know whether the hardware has validated the checksum and is
> valid or not.
> 
> Based on the checksum valid bit the corresponding stats are
> incremented and skb->ip_summed is marked either CHECKSUM_UNNECESSARY
> or left as CHEKSUM_NONE to let network stack revalidate the checksum
> and update the respective snmp stats.
> 
> Current MAPV1 header has been modified, the reserved field in the
> Mapv1 header is now used for next header indication.
> 
> Signed-off-by: Sharath Chandra Vurukala <sharathv@codeaurora.org>

> @@ -300,8 +301,11 @@ struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
>  struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
>  				      struct rmnet_port *port)
>  {
> +	struct rmnet_map_v5_csum_header *next_hdr = NULL;
> +	void *data = skb->data;
>  	struct rmnet_map_header *maph;

Please maintain reverse xmas tree ordering

>  	struct sk_buff *skbn;
> +	u8 nexthdr_type;
>  	u32 packet_len;
>  
>  	if (skb->len == 0)
> @@ -310,8 +314,18 @@ struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
>  	maph = (struct rmnet_map_header *)skb->data;
>  	packet_len = ntohs(maph->pkt_len) + sizeof(*maph);
>  
> -	if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4)
> +	if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4) {
>  		packet_len += sizeof(struct rmnet_map_dl_csum_trailer);
> +	} else if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV5) {
> +		if (!(maph->flags & MAP_CMD_FLAG)) {
> +			packet_len += sizeof(*next_hdr);
> +			if (maph->flags & MAP_NEXT_HEADER_FLAG)
> +				next_hdr = (data + sizeof(*maph));

brackets unnecessary

> +			else
> +				/* Mapv5 data pkt without csum hdr is invalid */
> +				return NULL;
> +		}
> +	}
>  
>  	if (((int)skb->len - (int)packet_len) < 0)
>  		return NULL;
> @@ -320,6 +334,13 @@ struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
>  	if (!maph->pkt_len)
>  		return NULL;
>  
> +	if (next_hdr) {
> +		nexthdr_type = u8_get_bits(next_hdr->header_info,
> +					   MAPV5_HDRINFO_HDR_TYPE_FMASK);
> +		if (nexthdr_type != RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD)
> +			return NULL;
> +	}
> +
>  	skbn = alloc_skb(packet_len + RMNET_MAP_DEAGGR_SPACING, GFP_ATOMIC);
>  	if (!skbn)
>  		return NULL;
> @@ -414,3 +435,37 @@ void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
>  
>  	priv->stats.csum_sw++;
>  }
> +
> +/* Process a MAPv5 packet header */
> +int rmnet_map_process_next_hdr_packet(struct sk_buff *skb,
> +				      u16 len)
> +{
> +	struct rmnet_priv *priv = netdev_priv(skb->dev);
> +	struct rmnet_map_v5_csum_header *next_hdr;
> +	u8 nexthdr_type;
> +	int rc = 0;

rc is not meaningfully used

> +	next_hdr = (struct rmnet_map_v5_csum_header *)(skb->data +
> +			sizeof(struct rmnet_map_header));
> +
> +	nexthdr_type = u8_get_bits(next_hdr->header_info,
> +				   MAPV5_HDRINFO_HDR_TYPE_FMASK);
> +
> +	if (nexthdr_type == RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD) {
> +		if (unlikely(!(skb->dev->features & NETIF_F_RXCSUM))) {
> +			priv->stats.csum_sw++;
> +		} else if (next_hdr->csum_info & MAPV5_CSUMINFO_VALID_FLAG) {
> +			priv->stats.csum_ok++;
> +			skb->ip_summed = CHECKSUM_UNNECESSARY;
> +		} else {
> +			priv->stats.csum_valid_unset++;
> +		}
> +
> +		/* Pull csum v5 header */
> +		skb_pull(skb, sizeof(*next_hdr));
> +	} else {
> +		return -EINVAL;

flip condition, return early

> +	}
> +
> +	return rc;
> +}
> diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
> index 4efb537..8502ccc 100644
> --- a/include/linux/if_rmnet.h
> +++ b/include/linux/if_rmnet.h
> @@ -1,5 +1,5 @@
>  /* SPDX-License-Identifier: GPL-2.0-only
> - * Copyright (c) 2013-2019, The Linux Foundation. All rights reserved.
> + * Copyright (c) 2013-2019, 2021 The Linux Foundation. All rights reserved.
>   */
>  
>  #ifndef _LINUX_IF_RMNET_H_
> @@ -14,8 +14,10 @@ struct rmnet_map_header {
>  /* rmnet_map_header flags field:
>   *  PAD_LEN:	number of pad bytes following packet data
>   *  CMD:	1 = packet contains a MAP command; 0 = packet contains data
> + *  NEXT_HEADER	1 = packet contains V5 CSUM header 0 = no V5 CSUM header

Colon missing?

>   */
>  #define MAP_PAD_LEN_MASK		GENMASK(5, 0)
> +#define MAP_NEXT_HEADER_FLAG		BIT(6)
>  #define MAP_CMD_FLAG			BIT(7)
>  
>  struct rmnet_map_dl_csum_trailer {
> @@ -45,4 +47,26 @@ struct rmnet_map_ul_csum_header {
>  #define MAP_CSUM_UL_UDP_FLAG		BIT(14)
>  #define MAP_CSUM_UL_ENABLED_FLAG	BIT(15)
>  
> +/* MAP CSUM headers */
> +struct rmnet_map_v5_csum_header {
> +	u8 header_info;
> +	u8 csum_info;
> +	__be16 reserved;
> +} __aligned(1);

__aligned() seems rather pointless here but ok.

> +/* v5 header_info field
> + * NEXT_HEADER:  Represents whether there is any other header

double space

> + * HEADER TYPE: represents the type of this header

On previous line you used _ for a space, and started from capital
letter. Please be consistent.

> + *
> + * csum_info field
> + * CSUM_VALID_OR_REQ:
> + * 1 = for UL, checksum computation is requested.
> + * 1 = for DL, validated the checksum and has found it valid
> + */
> +
> +#define MAPV5_HDRINFO_NXT_HDR_FLAG	BIT(0)
> +#define MAPV5_HDRINFO_HDR_TYPE_FMASK	GENMASK(7, 1)
> +#define MAPV5_CSUMINFO_VALID_FLAG	BIT(7)
> +
> +#define RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD 2
>  #endif /* !(_LINUX_IF_RMNET_H_) */
