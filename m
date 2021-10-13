Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72BC42C539
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 17:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbhJMPwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 11:52:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234305AbhJMPwT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 11:52:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91D3B610CF;
        Wed, 13 Oct 2021 15:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634140215;
        bh=oylwUBstgY1cASsOeDmQ1JKml7R4+BGOMeENOLDZzrs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TWLJCjnTag71KberhdXSRz4YlakBZk7Yd7CDUje+JfW4oEoSbiobiqZyGcxHO8ZLh
         o8m+mTZdH+KAySDRdlHAcL3besPwWz5A3cmhYfTzPbk2SsMl/ocNTyix35WpoWdaLA
         Mf/62SbsQJVGgXb3nfkZVP4ANRvKiVvYsNVHBbQPUCT34cfYGuI6VV8l6hnhMfFAYW
         Rx1jjkA2PbYektXxzhD3wRrkCeVHc3pzIsZsbNPWHusju03hfPVPvz4ce7SyYDHsMP
         m6InWqyXQSVwmpqnAtK7qSIkhGCP03yjJzwPvjc+DBqSJBJlrA+WwgED2AkOgw7qUV
         PZqMmD3i8fy2g==
Date:   Wed, 13 Oct 2021 08:50:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andreas Oetken <ennoerlangen@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Murali Karicheri <m-karicheri2@ti.com>,
        Andreas Oetken <andreas.oetken@siemens-energy.com>
Subject: Re: [PATCH] net: hsr: Add support for redbox supervision frames
Message-ID: <20211013085014.4beb11e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211013072951.1697003-1-andreas.oetken@siemens-energy.com>
References: <20211013072951.1697003-1-andreas.oetken@siemens-energy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Oct 2021 09:29:51 +0200 Andreas Oetken wrote:
> added support for the redbox supervision frames
> as defined in the IEC-62439-3:2018.
> 
> Signed-off-by: Andreas Oetken <andreas.oetken@siemens-energy.com>

This does not apply to netdev/net-next.

> diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
> index fdd9c00082a8..b1677b0a9202 100644
> --- a/net/hsr/hsr_device.c
> +++ b/net/hsr/hsr_device.c
> @@ -511,9 +511,9 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
>  	}
>  	spin_unlock_irqrestore(&hsr->seqnr_lock, irqflags);
>  
> -	hsr_stag->HSR_TLV_type = type;
> +	hsr_stag->tlv.HSR_TLV_type = type;
>  	/* TODO: Why 12 in HSRv0? */
> -	hsr_stag->HSR_TLV_length = hsr->prot_version ?
> +	hsr_stag->tlv.HSR_TLV_length = hsr->prot_version ?
>  				sizeof(struct hsr_sup_payload) : 12;
>  
>  	/* Payload: MacAddressA */
> @@ -560,8 +560,8 @@ static void send_prp_supervision_frame(struct hsr_port *master,
>  	spin_lock_irqsave(&master->hsr->seqnr_lock, irqflags);
>  	hsr_stag->sequence_nr = htons(hsr->sup_sequence_nr);
>  	hsr->sup_sequence_nr++;
> -	hsr_stag->HSR_TLV_type = PRP_TLV_LIFE_CHECK_DD;
> -	hsr_stag->HSR_TLV_length = sizeof(struct hsr_sup_payload);
> +	hsr_stag->tlv.HSR_TLV_type = PRP_TLV_LIFE_CHECK_DD;
> +	hsr_stag->tlv.HSR_TLV_length = sizeof(struct hsr_sup_payload);
>  
>  	/* Payload: MacAddressA */
>  	hsr_sp = skb_put(skb, sizeof(struct hsr_sup_payload));
> diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
> index d4d434b9f598..312d6a86c124 100644
> --- a/net/hsr/hsr_forward.c
> +++ b/net/hsr/hsr_forward.c
> @@ -95,13 +95,13 @@ static bool is_supervision_frame(struct hsr_priv *hsr, struct sk_buff *skb)
>  			&((struct hsrv0_ethhdr_vlan_sp *)eth_hdr)->hsr_sup;
>  	}
>  
> -	if (hsr_sup_tag->HSR_TLV_type != HSR_TLV_ANNOUNCE &&
> -	    hsr_sup_tag->HSR_TLV_type != HSR_TLV_LIFE_CHECK &&
> -	    hsr_sup_tag->HSR_TLV_type != PRP_TLV_LIFE_CHECK_DD &&
> -	    hsr_sup_tag->HSR_TLV_type != PRP_TLV_LIFE_CHECK_DA)
> +	if (hsr_sup_tag->tlv.HSR_TLV_type != HSR_TLV_ANNOUNCE &&
> +	    hsr_sup_tag->tlv.HSR_TLV_type != HSR_TLV_LIFE_CHECK &&
> +	    hsr_sup_tag->tlv.HSR_TLV_type != PRP_TLV_LIFE_CHECK_DD &&
> +	    hsr_sup_tag->tlv.HSR_TLV_type != PRP_TLV_LIFE_CHECK_DA)
>  		return false;
> -	if (hsr_sup_tag->HSR_TLV_length != 12 &&
> -	    hsr_sup_tag->HSR_TLV_length != sizeof(struct hsr_sup_payload))
> +	if (hsr_sup_tag->tlv.HSR_TLV_length != 12 &&
> +	    hsr_sup_tag->tlv.HSR_TLV_length != sizeof(struct hsr_sup_payload))
>  		return false;
>  
>  	return true;
> diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
> index bb1351c38397..e7c6efbc41af 100644
> --- a/net/hsr/hsr_framereg.c
> +++ b/net/hsr/hsr_framereg.c
> @@ -265,6 +265,7 @@ void hsr_handle_sup_frame(struct hsr_frame_info *frame)
>  	struct hsr_port *port_rcv = frame->port_rcv;
>  	struct hsr_priv *hsr = port_rcv->hsr;
>  	struct hsr_sup_payload *hsr_sp;
> +	struct hsr_sup_tlv *hsr_sup_tlv;
>  	struct hsr_node *node_real;
>  	struct sk_buff *skb = NULL;
>  	struct list_head *node_db;
> @@ -312,6 +313,40 @@ void hsr_handle_sup_frame(struct hsr_frame_info *frame)
>  		/* Node has already been merged */
>  		goto done;
>  
> +	/* Leave the first HSR sup payload. */
> +	skb_pull(skb, sizeof(struct hsr_sup_payload));
> +
> +	/* Get second supervision tlv */
> +	hsr_sup_tlv = (struct hsr_sup_tlv *)skb->data;
> +	/* And check if it is a redbox mac TLV */
> +	if (hsr_sup_tlv->HSR_TLV_type == PRP_TLV_REDBOX_MAC) {
> +		/* We could stop here after pushing hsr_sup_payload,
> +		 * or proceed and allow macaddress_B and for redboxes.
> +		 */
> +		/* Sanity check length */
> +		if (hsr_sup_tlv->HSR_TLV_length != 6) {
> +			skb_push(skb, sizeof(struct hsr_sup_payload));
> +			goto done;
> +		}
> +		/* Leave the second HSR sup tlv. */
> +		skb_pull(skb, sizeof(struct hsr_sup_tlv));
> +
> +		/* Get redbox mac address. */
> +		hsr_sp = (struct hsr_sup_payload *)skb->data;
> +
> +		/* Check if redbox mac and node mac are equal. */
> +		if (!ether_addr_equal(node_real->macaddress_A, hsr_sp->macaddress_A)) {
> +			/* This is a redbox supervision frame for a VDAN! */
> +			/* Push second TLV and payload here */
> +			skb_push(skb, sizeof(struct hsr_sup_payload) + sizeof(struct hsr_sup_tlv));
> +			goto done;
> +		}
> +		/* Push second TLV here */
> +		skb_push(skb, sizeof(struct hsr_sup_tlv));
> +	}
> +	/* Push payload here */
> +	skb_push(skb, sizeof(struct hsr_sup_payload));

Is this code path handling frames from the network or user space? 
Does it need input checking?

>  	ether_addr_copy(node_real->macaddress_B, ethhdr->h_source);
>  	for (i = 0; i < HSR_PT_PORTS; i++) {
>  		if (!node_curr->time_in_stale[i] &&
> diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
> index bbaef001d55d..fc3bed792ba7 100644
> --- a/net/hsr/hsr_main.h
> +++ b/net/hsr/hsr_main.h
> @@ -43,6 +43,8 @@
>  #define PRP_TLV_LIFE_CHECK_DD		   20
>  /* PRP V1 life check for Duplicate Accept */
>  #define PRP_TLV_LIFE_CHECK_DA		   21
> +/* PRP V1 life redundancy box MAC address */
> +#define PRP_TLV_REDBOX_MAC		   30
>  
>  /* HSR Tag.
>   * As defined in IEC-62439-3:2010, the HSR tag is really { ethertype = 0x88FB,
> @@ -95,14 +97,18 @@ struct hsr_vlan_ethhdr {
>  	struct hsr_tag	hsr_tag;
>  } __packed;
>  
> +struct hsr_sup_tlv {
> +	__u8		HSR_TLV_type;
> +	__u8		HSR_TLV_length;

u8, __u8 is for uAPI headers, which this is not.

> +} __packed;

There's no need to pack structs which only have members of size 1.

