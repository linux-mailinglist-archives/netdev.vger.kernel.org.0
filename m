Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074E9396442
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 17:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233562AbhEaPw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 11:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbhEaPuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 11:50:25 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C5AC08E9AF
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 07:34:04 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id r6so2769378ilj.1
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 07:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NcVYpSX49t8trK3HFTEm9MxOc7bF5TalzkVGbp2+Mm8=;
        b=TXOuCcEQqmXbkK8iQgEW3orS1n/esiRzw8x3PAg+0/Q0a7u0+MYJIlRbGRvHkYZTZB
         0yac0an/YY1u29rDUhu7qdxlKsSzu72IvKe/VAgQx5oqBdZO+kmR++lNjQwIuYoa6SFX
         SkMF4uL1D7JUF0Gad9oeDrxy7cwq+LxmFRhdM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NcVYpSX49t8trK3HFTEm9MxOc7bF5TalzkVGbp2+Mm8=;
        b=MU0vZA4Q60D9T+GzeWRx7EZAgN++o8dzMTH9CTE6hDifnAHsWqBptqq3Jqnn78+kjL
         1z/P4FS7mmVmJlZUrTW1c3dFg2541To2EgEevqq/1fPxuVOyF5XbtvrP9j/X6aKF8vgw
         /A5bZ8Yav3kpNluf46rldoKujFBtuhzMP1swYITXWWu3cJaKs1u1ABEyySWefLy2nHzb
         W+aGvvvFsUxpg3EDofV7lm8xpr8Rpag1q9Rtx2HTJd1btTTY4lxfoV6LvIkISOr+RRi/
         iedi1yLAFz04BzC2BQcDQU0U0C4rqiVddBdIKgo6o5iywnL9cuiTV5yvx0b0/VJudRrZ
         20sg==
X-Gm-Message-State: AOAM532e8tuMPkoTXkE5fenAjrNMXRY0awBI531pctP8jg+Sl17ShK5u
        wBYqhEio8BG+W4tDCK+0gYmANQ==
X-Google-Smtp-Source: ABdhPJxb9sAnFSZc+NWXH31Bpzm/veQvF4YxIn5+fFngnPEIVPBExdALMpKWpE2f+wGp2uGFs0BUnw==
X-Received: by 2002:a92:d282:: with SMTP id p2mr17416796ilp.143.1622471643575;
        Mon, 31 May 2021 07:34:03 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id c4sm7751445ioo.50.2021.05.31.07.34.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 07:34:03 -0700 (PDT)
Subject: Re: [PATCH net-next v7 2/3] net: ethernet: rmnet: Support for ingress
 MAPv5 checksum offload
To:     Jakub Kicinski <kuba@kernel.org>,
        Sharath Chandra Vurukala <sharathv@codeaurora.org>
Cc:     davem@davemloft.net, elder@kernel.org, cpratapa@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1622105322-2975-1-git-send-email-sharathv@codeaurora.org>
 <1622105322-2975-3-git-send-email-sharathv@codeaurora.org>
 <20210528155800.0514d249@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Alex Elder <elder@ieee.org>
Message-ID: <915b733f-6312-94b3-099d-3c11eb3d3b32@ieee.org>
Date:   Mon, 31 May 2021 09:34:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210528155800.0514d249@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 5:58 PM, Jakub Kicinski wrote:
> On Thu, 27 May 2021 14:18:41 +0530 Sharath Chandra Vurukala wrote:
>> Adding support for processing of MAPv5 downlink packets.
>> It involves parsing the Mapv5 packet and checking the csum header
>> to know whether the hardware has validated the checksum and is
>> valid or not.

Nice review Jakub.  I will wait for version 8 and will review that.

					-Alex

>>
>> Based on the checksum valid bit the corresponding stats are
>> incremented and skb->ip_summed is marked either CHECKSUM_UNNECESSARY
>> or left as CHEKSUM_NONE to let network stack revalidate the checksum
>> and update the respective snmp stats.
>>
>> Current MAPV1 header has been modified, the reserved field in the
>> Mapv1 header is now used for next header indication.
>>
>> Signed-off-by: Sharath Chandra Vurukala <sharathv@codeaurora.org>
> 
>> @@ -300,8 +301,11 @@ struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
>>  struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
>>  				      struct rmnet_port *port)
>>  {
>> +	struct rmnet_map_v5_csum_header *next_hdr = NULL;
>> +	void *data = skb->data;
>>  	struct rmnet_map_header *maph;
> 
> Please maintain reverse xmas tree ordering
> 
>>  	struct sk_buff *skbn;
>> +	u8 nexthdr_type;
>>  	u32 packet_len;
>>  
>>  	if (skb->len == 0)
>> @@ -310,8 +314,18 @@ struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
>>  	maph = (struct rmnet_map_header *)skb->data;
>>  	packet_len = ntohs(maph->pkt_len) + sizeof(*maph);
>>  
>> -	if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4)
>> +	if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4) {
>>  		packet_len += sizeof(struct rmnet_map_dl_csum_trailer);
>> +	} else if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV5) {
>> +		if (!(maph->flags & MAP_CMD_FLAG)) {
>> +			packet_len += sizeof(*next_hdr);
>> +			if (maph->flags & MAP_NEXT_HEADER_FLAG)
>> +				next_hdr = (data + sizeof(*maph));
> 
> brackets unnecessary
> 
>> +			else
>> +				/* Mapv5 data pkt without csum hdr is invalid */
>> +				return NULL;
>> +		}
>> +	}
>>  
>>  	if (((int)skb->len - (int)packet_len) < 0)
>>  		return NULL;
>> @@ -320,6 +334,13 @@ struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
>>  	if (!maph->pkt_len)
>>  		return NULL;
>>  
>> +	if (next_hdr) {
>> +		nexthdr_type = u8_get_bits(next_hdr->header_info,
>> +					   MAPV5_HDRINFO_HDR_TYPE_FMASK);
>> +		if (nexthdr_type != RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD)
>> +			return NULL;
>> +	}
>> +
>>  	skbn = alloc_skb(packet_len + RMNET_MAP_DEAGGR_SPACING, GFP_ATOMIC);
>>  	if (!skbn)
>>  		return NULL;
>> @@ -414,3 +435,37 @@ void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
>>  
>>  	priv->stats.csum_sw++;
>>  }
>> +
>> +/* Process a MAPv5 packet header */
>> +int rmnet_map_process_next_hdr_packet(struct sk_buff *skb,
>> +				      u16 len)
>> +{
>> +	struct rmnet_priv *priv = netdev_priv(skb->dev);
>> +	struct rmnet_map_v5_csum_header *next_hdr;
>> +	u8 nexthdr_type;
>> +	int rc = 0;
> 
> rc is not meaningfully used
> 
>> +	next_hdr = (struct rmnet_map_v5_csum_header *)(skb->data +
>> +			sizeof(struct rmnet_map_header));
>> +
>> +	nexthdr_type = u8_get_bits(next_hdr->header_info,
>> +				   MAPV5_HDRINFO_HDR_TYPE_FMASK);
>> +
>> +	if (nexthdr_type == RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD) {
>> +		if (unlikely(!(skb->dev->features & NETIF_F_RXCSUM))) {
>> +			priv->stats.csum_sw++;
>> +		} else if (next_hdr->csum_info & MAPV5_CSUMINFO_VALID_FLAG) {
>> +			priv->stats.csum_ok++;
>> +			skb->ip_summed = CHECKSUM_UNNECESSARY;
>> +		} else {
>> +			priv->stats.csum_valid_unset++;
>> +		}
>> +
>> +		/* Pull csum v5 header */
>> +		skb_pull(skb, sizeof(*next_hdr));
>> +	} else {
>> +		return -EINVAL;
> 
> flip condition, return early
> 
>> +	}
>> +
>> +	return rc;
>> +}
>> diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
>> index 4efb537..8502ccc 100644
>> --- a/include/linux/if_rmnet.h
>> +++ b/include/linux/if_rmnet.h
>> @@ -1,5 +1,5 @@
>>  /* SPDX-License-Identifier: GPL-2.0-only
>> - * Copyright (c) 2013-2019, The Linux Foundation. All rights reserved.
>> + * Copyright (c) 2013-2019, 2021 The Linux Foundation. All rights reserved.
>>   */
>>  
>>  #ifndef _LINUX_IF_RMNET_H_
>> @@ -14,8 +14,10 @@ struct rmnet_map_header {
>>  /* rmnet_map_header flags field:
>>   *  PAD_LEN:	number of pad bytes following packet data
>>   *  CMD:	1 = packet contains a MAP command; 0 = packet contains data
>> + *  NEXT_HEADER	1 = packet contains V5 CSUM header 0 = no V5 CSUM header
> 
> Colon missing?
> 
>>   */
>>  #define MAP_PAD_LEN_MASK		GENMASK(5, 0)
>> +#define MAP_NEXT_HEADER_FLAG		BIT(6)
>>  #define MAP_CMD_FLAG			BIT(7)
>>  
>>  struct rmnet_map_dl_csum_trailer {
>> @@ -45,4 +47,26 @@ struct rmnet_map_ul_csum_header {
>>  #define MAP_CSUM_UL_UDP_FLAG		BIT(14)
>>  #define MAP_CSUM_UL_ENABLED_FLAG	BIT(15)
>>  
>> +/* MAP CSUM headers */
>> +struct rmnet_map_v5_csum_header {
>> +	u8 header_info;
>> +	u8 csum_info;
>> +	__be16 reserved;
>> +} __aligned(1);
> 
> __aligned() seems rather pointless here but ok.
> 
>> +/* v5 header_info field
>> + * NEXT_HEADER:  Represents whether there is any other header
> 
> double space
> 
>> + * HEADER TYPE: represents the type of this header
> 
> On previous line you used _ for a space, and started from capital
> letter. Please be consistent.
> 
>> + *
>> + * csum_info field
>> + * CSUM_VALID_OR_REQ:
>> + * 1 = for UL, checksum computation is requested.
>> + * 1 = for DL, validated the checksum and has found it valid
>> + */
>> +
>> +#define MAPV5_HDRINFO_NXT_HDR_FLAG	BIT(0)
>> +#define MAPV5_HDRINFO_HDR_TYPE_FMASK	GENMASK(7, 1)
>> +#define MAPV5_CSUMINFO_VALID_FLAG	BIT(7)
>> +
>> +#define RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD 2
>>  #endif /* !(_LINUX_IF_RMNET_H_) */

