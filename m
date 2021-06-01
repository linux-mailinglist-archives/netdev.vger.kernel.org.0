Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE09397A6C
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 21:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234725AbhFATIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 15:08:30 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:26627 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234628AbhFATI3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 15:08:29 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622574408; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=RLJZcAic9n4wt3SI64JCzsrj0R3LMnnmYmskqIV6rjc=;
 b=oDoVivnnyQSLrDlKvVOxHlKqSdfIYH9ea/XibFlb2g1yiFJUqk0kXK0TDNFDED5Hzln/11q0
 jEq/n/CdSTg1UarEIoRfUOW+kiekjajUbjDBmrNWwFBqnN4duH6qLKcOWOysMqhR4IYyA+n0
 01h08mTGJHlkH4NFHHaVE3nAm5Y=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 60b68533ea2aacd729dc3c35 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 01 Jun 2021 19:06:27
 GMT
Sender: sharathv=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C8B77C433D3; Tue,  1 Jun 2021 19:06:26 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: sharathv)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B3377C4338A;
        Tue,  1 Jun 2021 19:06:25 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 02 Jun 2021 00:36:25 +0530
From:   sharathv@codeaurora.org
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, elder@kernel.org, cpratapa@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v7 2/3] net: ethernet: rmnet: Support for ingress
 MAPv5 checksum offload
In-Reply-To: <20210528155800.0514d249@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <1622105322-2975-1-git-send-email-sharathv@codeaurora.org>
 <1622105322-2975-3-git-send-email-sharathv@codeaurora.org>
 <20210528155800.0514d249@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Message-ID: <c843c5923929761e092fddbab29412be@codeaurora.org>
X-Sender: sharathv@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-05-29 04:28, Jakub Kicinski wrote:
> On Thu, 27 May 2021 14:18:41 +0530 Sharath Chandra Vurukala wrote:
>> Adding support for processing of MAPv5 downlink packets.
>> It involves parsing the Mapv5 packet and checking the csum header
>> to know whether the hardware has validated the checksum and is
>> valid or not.
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
>> @@ -300,8 +301,11 @@ struct rmnet_map_header 
>> *rmnet_map_add_map_header(struct sk_buff *skb,
>>  struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
>>  				      struct rmnet_port *port)
>>  {
>> +	struct rmnet_map_v5_csum_header *next_hdr = NULL;
>> +	void *data = skb->data;
>>  	struct rmnet_map_header *maph;
> 
> Please maintain reverse xmas tree ordering

Thanks Jakub for the review, I will address all the comments that you 
gave in the next subsequent patch.
> 
>>  	struct sk_buff *skbn;
>> +	u8 nexthdr_type;
>>  	u32 packet_len;
>> 
>>  	if (skb->len == 0)
>> @@ -310,8 +314,18 @@ struct sk_buff *rmnet_map_deaggregate(struct 
>> sk_buff *skb,
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
Will take care in next patch.
>> +			else
>> +				/* Mapv5 data pkt without csum hdr is invalid */
>> +				return NULL;
>> +		}
>> +	}
>> 
>>  	if (((int)skb->len - (int)packet_len) < 0)
>>  		return NULL;
>> @@ -320,6 +334,13 @@ struct sk_buff *rmnet_map_deaggregate(struct 
>> sk_buff *skb,
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
>> @@ -414,3 +435,37 @@ void rmnet_map_checksum_uplink_packet(struct 
>> sk_buff *skb,
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
Sure will take care in next patch.
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
>> - * Copyright (c) 2013-2019, The Linux Foundation. All rights 
>> reserved.
>> + * Copyright (c) 2013-2019, 2021 The Linux Foundation. All rights 
>> reserved.
>>   */
>> 
>>  #ifndef _LINUX_IF_RMNET_H_
>> @@ -14,8 +14,10 @@ struct rmnet_map_header {
>>  /* rmnet_map_header flags field:
>>   *  PAD_LEN:	number of pad bytes following packet data
>>   *  CMD:	1 = packet contains a MAP command; 0 = packet contains data
>> + *  NEXT_HEADER	1 = packet contains V5 CSUM header 0 = no V5 CSUM 
>> header
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

Sure, will take care in next patch.

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
