Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29084929F2
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 16:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242234AbiARP5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 10:57:47 -0500
Received: from mga03.intel.com ([134.134.136.65]:53430 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230519AbiARP5q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jan 2022 10:57:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642521466; x=1674057466;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SmRoUzLDiexspw7+m2McrT/jXxMUlugaFlvcANVzwWU=;
  b=SphQcm8e1u4BlSh0+kbR/SObfBjdgTjOL8jCU6H9TSl69B5ITLfv3jFk
   /hB/824j7hoFaI0XXbCt07cxWMqlh9USwsOLXIHLNRxMb3DSw6jE+A4ID
   aVEOidcvQXQ/tLKAepyePZY8qEnSUDA5CB860kAP+skrMz/XvDflDHQ4Q
   SB1VxD4WvktIYkR2D5yfKqbTWktI7oLs68JGs54Hl1spW6O7AY/fdWEh9
   kqaaxT7Deh/+7XT/SmlI5RSpQ+DCqtUhW+Z81f9ypgji3PC0mOdCgm7VW
   HwdUMO5xIwAarC7E/NyYtktmvrVisShiRbEKyxe3/ZBG2xhcnKQQiQAYp
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10230"; a="244802585"
X-IronPort-AV: E=Sophos;i="5.88,297,1635231600"; 
   d="scan'208";a="244802585"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 07:57:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,297,1635231600"; 
   d="scan'208";a="530327566"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga007.fm.intel.com with ESMTP; 18 Jan 2022 07:57:44 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 20IFvhXE000415;
        Tue, 18 Jan 2022 15:57:43 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [RFC PATCH 2/3] net: gro: minor optimization for dev_gro_receive()
Date:   Tue, 18 Jan 2022 16:56:20 +0100
Message-Id: <20220118155620.27706-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <35d722e246b7c4afb6afb03760df6f664db4ef05.1642519257.git.pabeni@redhat.com>
References: <cover.1642519257.git.pabeni@redhat.com> <35d722e246b7c4afb6afb03760df6f664db4ef05.1642519257.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Tue, 18 Jan 2022 16:24:19 +0100

> While inspecting some perf report, I noticed that the compiler
> emits suboptimal code for the napi CB initialization, fetching
> and storing multiple times the memory for flags bitfield.
> This is with gcc 10.3.1, but I observed the same with older compiler
> versions.
> 
> We can help the compiler to do a nicer work e.g. initially setting
> all the bitfield to 0 using an u16 alias. The generated code is quite
> smaller, with the same number of conditional
> 
> Before:
> objdump -t net/core/gro.o | grep " F .text"
> 0000000000000bb0 l     F .text	0000000000000357 dev_gro_receive
> 
> After:
> 0000000000000bb0 l     F .text	000000000000033c dev_gro_receive
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  include/net/gro.h | 13 +++++++++----
>  net/core/gro.c    | 16 +++++-----------
>  2 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/include/net/gro.h b/include/net/gro.h
> index 8f75802d50fd..a068b27d341f 100644
> --- a/include/net/gro.h
> +++ b/include/net/gro.h
> @@ -29,14 +29,17 @@ struct napi_gro_cb {
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
> +	u32	zeroed_start[0];
> +
> +	/* Start offset for remote checksum offload */
> +	u16	gro_remcsum_start;
>  
>  	/* This is non-zero if the packet may be of the same flow. */
>  	u8	same_flow:1;
> @@ -70,6 +73,8 @@ struct napi_gro_cb {
>  	/* GRO is done by frag_list pointer chaining. */
>  	u8	is_flist:1;
>  
> +	u32	zeroed_end[0];

This should be wrapped in struct_group() I believe, or compilers
will start complaining soon. See [0] for the details.
Adding Kees to the CCs.

> +
>  	/* used to support CHECKSUM_COMPLETE for tunneling protocols */
>  	__wsum	csum;
>  
> diff --git a/net/core/gro.c b/net/core/gro.c
> index d43d42215bdb..b9ebe9298731 100644
> --- a/net/core/gro.c
> +++ b/net/core/gro.c
> @@ -435,6 +435,9 @@ static void gro_flush_oldest(struct napi_struct *napi, struct list_head *head)
>  	napi_gro_complete(napi, oldest);
>  }
>  
> +#define zeroed_len	(offsetof(struct napi_gro_cb, zeroed_end) - \
> +			 offsetof(struct napi_gro_cb, zeroed_start))
> +
>  static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff *skb)
>  {
>  	u32 bucket = skb_get_hash_raw(skb) & (GRO_HASH_BUCKETS - 1);
> @@ -459,29 +462,20 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
>  
>  		skb_set_network_header(skb, skb_gro_offset(skb));
>  		skb_reset_mac_len(skb);
> -		NAPI_GRO_CB(skb)->same_flow = 0;
> +		BUILD_BUG_ON(zeroed_len != sizeof(NAPI_GRO_CB(skb)->zeroed_start[0]));
> +		NAPI_GRO_CB(skb)->zeroed_start[0] = 0;
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

[0] https://lore.kernel.org/linux-hardening/20220112220652.3952944-1-keescook@chromium.org

Thanks,
Al
