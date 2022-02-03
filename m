Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEE24A8867
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352138AbiBCQLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:11:54 -0500
Received: from mga14.intel.com ([192.55.52.115]:19225 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352136AbiBCQLy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 11:11:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643904714; x=1675440714;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/uVsO8t3s2IrgsSfdudQoMzxJuHtxboILaSiiCvoLDc=;
  b=lcp6gJWOYnxkki68cY5f2h4gsnxqvPS9m2YzknG8qmmjWyPAnG70jCUa
   +4l4ntddsaPpOV8BBF9iq4G81s69elgTbWYKUzHx62TtY1DyWAZJvn5MP
   cImxRerVQuXZ3adex/P4Ygj0i5Hr4VnnA3Q7dxt7xJL6UykbeWPf7gtAA
   LMwPwPkVrRRiNY11xl2cueLOXuBSx+cab2ljNDtH8YOe0fgOA6bawCroC
   Gsp0XB4C4osKDhJo+JJ7IptH5Lf8X08HTmUkbuYPO5XqnlIKAuXDS8TLp
   6vI0s7pJLw5GqpN+hUoWnD6eTbC8FQ+Vppd3ii/z90LYHEpCbL8Z7ib9w
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10247"; a="248390987"
X-IronPort-AV: E=Sophos;i="5.88,340,1635231600"; 
   d="scan'208";a="248390987"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2022 08:11:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,340,1635231600"; 
   d="scan'208";a="538797223"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga008.jf.intel.com with ESMTP; 03 Feb 2022 08:11:52 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 213GBo51013711;
        Thu, 3 Feb 2022 16:11:50 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 2/3] net: gro: minor optimization for dev_gro_receive()
Date:   Thu,  3 Feb 2022 17:09:45 +0100
Message-Id: <20220203160945.13009-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <2a6db6d6ca415cb35cc7b3e4d9424baf0516d782.1643902526.git.pabeni@redhat.com>
References: <cover.1643902526.git.pabeni@redhat.com> <2a6db6d6ca415cb35cc7b3e4d9424baf0516d782.1643902526.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Thu,  3 Feb 2022 16:48:22 +0100

> While inspecting some perf report, I noticed that the compiler
> emits suboptimal code for the napi CB initialization, fetching
> and storing multiple times the memory for flags bitfield.
> This is with gcc 10.3.1, but I observed the same with older compiler
> versions.
> 
> We can help the compiler to do a nicer work clearing several
> fields at once using an u32 alias. The generated code is quite
> smaller, with the same number of conditional.
> 
> Before:
> objdump -t net/core/gro.o | grep " F .text"
> 0000000000000bb0 l     F .text	0000000000000357 dev_gro_receive
> 
> After:
> 0000000000000bb0 l     F .text	000000000000033c dev_gro_receive
> 
> RFC -> v1:
>  - use __struct_group to delimt the zeroed area (Alexander)

"delimit"?

> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  include/net/gro.h | 52 +++++++++++++++++++++++++----------------------
>  net/core/gro.c    | 18 +++++++---------
>  2 files changed, 35 insertions(+), 35 deletions(-)
> 
> diff --git a/include/net/gro.h b/include/net/gro.h
> index 8f75802d50fd..fa1bb0f0ad28 100644
> --- a/include/net/gro.h
> +++ b/include/net/gro.h
> @@ -29,46 +29,50 @@ struct napi_gro_cb {
>  	/* Number of segments aggregated. */
>  	u16	count;
>  
> -	/* Start offset for remote checksum offload */
> -	u16	gro_remcsum_start;
> +	/* Used in ipv6_gro_receive() and foo-over-udp */
> +	u16	proto;
>  
>  	/* jiffies when first packet was created/queued */
>  	unsigned long age;
>  
> -	/* Used in ipv6_gro_receive() and foo-over-udp */
> -	u16	proto;
> +	/* portion of the cb set to zero at every gro iteration */
> +	__struct_group(/* no tag */, zeroed, /* no attrs */,

Oh, only after sending this in my reply I noticed that there's
a shorthand for this

struct_group(name, ...)

means exactly

__struct_group(/* no tag */, name, /* no attrs */, ...)

Sorry for that. I got confused by that Kees used __struct_group()
directly in one place although there was a possibility to use short
struct_group() instead.
Since there should already be a v2 (see below), probably worth
changing.

> +
> +		/* Start offset for remote checksum offload */
> +		u16	gro_remcsum_start;
>  
> -	/* This is non-zero if the packet may be of the same flow. */
> -	u8	same_flow:1;
> +		/* This is non-zero if the packet may be of the same flow. */
> +		u8	same_flow:1;
>  
> -	/* Used in tunnel GRO receive */
> -	u8	encap_mark:1;
> +		/* Used in tunnel GRO receive */
> +		u8	encap_mark:1;
>  
> -	/* GRO checksum is valid */
> -	u8	csum_valid:1;
> +		/* GRO checksum is valid */
> +		u8	csum_valid:1;
>  
> -	/* Number of checksums via CHECKSUM_UNNECESSARY */
> -	u8	csum_cnt:3;
> +		/* Number of checksums via CHECKSUM_UNNECESSARY */
> +		u8	csum_cnt:3;
>  
> -	/* Free the skb? */
> -	u8	free:2;
> +		/* Free the skb? */
> +		u8	free:2;
>  #define NAPI_GRO_FREE		  1
>  #define NAPI_GRO_FREE_STOLEN_HEAD 2
>  
> -	/* Used in foo-over-udp, set in udp[46]_gro_receive */
> -	u8	is_ipv6:1;
> +		/* Used in foo-over-udp, set in udp[46]_gro_receive */
> +		u8	is_ipv6:1;
>  
> -	/* Used in GRE, set in fou/gue_gro_receive */
> -	u8	is_fou:1;
> +		/* Used in GRE, set in fou/gue_gro_receive */
> +		u8	is_fou:1;
>  
> -	/* Used to determine if flush_id can be ignored */
> -	u8	is_atomic:1;
> +		/* Used to determine if flush_id can be ignored */
> +		u8	is_atomic:1;
>  
> -	/* Number of gro_receive callbacks this packet already went through */
> -	u8 recursion_counter:4;
> +		/* Number of gro_receive callbacks this packet already went through */
> +		u8 recursion_counter:4;
>  
> -	/* GRO is done by frag_list pointer chaining. */
> -	u8	is_flist:1;
> +		/* GRO is done by frag_list pointer chaining. */
> +		u8	is_flist:1;
> +	);
>  
>  	/* used to support CHECKSUM_COMPLETE for tunneling protocols */
>  	__wsum	csum;
> diff --git a/net/core/gro.c b/net/core/gro.c
> index d43d42215bdb..fc56be9408c7 100644
> --- a/net/core/gro.c
> +++ b/net/core/gro.c
> @@ -435,6 +435,9 @@ static void gro_flush_oldest(struct napi_struct *napi, struct list_head *head)
>  	napi_gro_complete(napi, oldest);
>  }
>  
> +#define zeroed_len	(offsetof(struct napi_gro_cb, zeroed_end) - \
> +			 offsetof(struct napi_gro_cb, zeroed_start))
> +

A leftover from the RFC I guess? It's not used anywhere in the code,
so it doesn't break build.

>  static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff *skb)
>  {
>  	u32 bucket = skb_get_hash_raw(skb) & (GRO_HASH_BUCKETS - 1);
> @@ -459,29 +462,22 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
>  
>  		skb_set_network_header(skb, skb_gro_offset(skb));
>  		skb_reset_mac_len(skb);
> -		NAPI_GRO_CB(skb)->same_flow = 0;
> +		BUILD_BUG_ON(sizeof_field(struct napi_gro_cb, zeroed) != sizeof(u32));
> +		BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct napi_gro_cb, zeroed),
> +					 sizeof(u32))); /* Avoid slow unaligned acc */
> +		*(u32 *)&NAPI_GRO_CB(skb)->zeroed = 0;

Looks relatively elegant and self-explanatory to me, nice.

>  		NAPI_GRO_CB(skb)->flush = skb_is_gso(skb) || skb_has_frag_list(skb);
> -		NAPI_GRO_CB(skb)->free = 0;
> -		NAPI_GRO_CB(skb)->encap_mark = 0;
> -		NAPI_GRO_CB(skb)->recursion_counter = 0;
> -		NAPI_GRO_CB(skb)->is_fou = 0;
>  		NAPI_GRO_CB(skb)->is_atomic = 1;
> -		NAPI_GRO_CB(skb)->gro_remcsum_start = 0;
>  
>  		/* Setup for GRO checksum validation */
>  		switch (skb->ip_summed) {
>  		case CHECKSUM_COMPLETE:
>  			NAPI_GRO_CB(skb)->csum = skb->csum;
>  			NAPI_GRO_CB(skb)->csum_valid = 1;
> -			NAPI_GRO_CB(skb)->csum_cnt = 0;
>  			break;
>  		case CHECKSUM_UNNECESSARY:
>  			NAPI_GRO_CB(skb)->csum_cnt = skb->csum_level + 1;
> -			NAPI_GRO_CB(skb)->csum_valid = 0;
>  			break;
> -		default:
> -			NAPI_GRO_CB(skb)->csum_cnt = 0;
> -			NAPI_GRO_CB(skb)->csum_valid = 0;
>  		}
>  
>  		pp = INDIRECT_CALL_INET(ptype->callbacks.gro_receive,
> -- 
> 2.34.1

Al
