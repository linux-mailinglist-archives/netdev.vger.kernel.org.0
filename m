Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1C1612018
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 06:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiJ2Ela (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 00:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiJ2El3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 00:41:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA335C4D95
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 21:41:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6847DB80CA9
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 04:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C14C433D6;
        Sat, 29 Oct 2022 04:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667018485;
        bh=TF0NeW2tUeGo4T06PMCduBq7mJrrlyhHS4WuLAPg1jU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VXXp1SD53bdAEDOxe4gCCC6EbFTF4seKg+jALr9CrgOOb1JMLnRH/SwyamLuBU9M7
         bMcQXPh6MU1Xx6/8ZHSdNVeRpy52PRP0vwLUlkc4gLzLdoG56vBrghRvo73F6UMdy3
         s3AH5l5gxVLCGUO0+hs87Ja1FmwG6ji2V59HRWskfNpDOaZ59xpDtXGxvJA/F90abD
         YRqXQrQsaK+TTH7D2YvKBJTk2IRsUE1/+6ZH+pX7b78OlljBbBZAiD134FVGw7lRxt
         4c7wyes8u+qJv1bhh031KInFTi9eIBw/uB8kQpw4m+sZGYZ967kHK4lyR+Y4dhS6bv
         asFCMtDq2pDSw==
Date:   Fri, 28 Oct 2022 21:41:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Benc <jbenc@redhat.com>
Cc:     netdev@vger.kernel.org, Shmulik Ladkani <shmulik@metanetworks.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tomas Hruby <tomas@tigera.io>,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        alexanderduyck@meta.com, willemb@google.com,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net] net: gso: fix panic on frag_list with mixed head
 alloc types
Message-ID: <20221028214123.1ac0fc87@kernel.org>
In-Reply-To: <559cea869928e169240d74c386735f3f95beca32.1666858629.git.jbenc@redhat.com>
References: <559cea869928e169240d74c386735f3f95beca32.1666858629.git.jbenc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Oct 2022 10:20:56 +0200 Jiri Benc wrote:
> Since commit 3dcbdb134f32 ("net: gso: Fix skb_segment splat when
> splitting gso_size mangled skb having linear-headed frag_list"), it is
> allowed to change gso_size of a GRO packet. However, that commit assumes
> that "checking the first list_skb member suffices; i.e if either of the
> list_skb members have non head_frag head, then the first one has too".
> 
> It turns out this assumption does not hold. We've seen BUG_ON being hit
> in skb_segment when skbs on the frag_list had differing head_frag. That
> particular case was with vmxnet3; looking at the driver, it indeed uses
> different skb allocation strategies based on the packet size.

Where are you looking? I'm not seeing it TBH.

I don't think the driver is that important, tho, __napi_alloc_skb() 
will select page backing or kmalloc, all by itself.

The patch LGTM, adding more CCs in case I'm missing something.

> The last packet in frag_list can thus be kmalloced if it is
> sufficiently small. And there's nothing preventing drivers from
> mixing things even more freely.
> 
> There are three different locations where this can be fixed:
> 
> (1) We could check head_frag in GRO and not allow GROing skbs with
>     different head_frag. However, that would lead to performance
>     regression (at least on vmxnet3) on normal forward paths with
>     unmodified gso_size, where mixed head_frag is not a problem.
> 
> (2) Set a flag in bpf_skb_net_grow and bpf_skb_net_shrink indicating
>     that NETIF_F_SG is undesirable. That would need to eat a bit in
>     sk_buff. Furthermore, that flag can be unset when all skbs on the
>     frag_list are page backed. To retain good performance,
>     bpf_skb_net_grow/shrink would have to walk the frag_list.
> 
> (3) Walk the frag_list in skb_segment when determining whether
>     NETIF_F_SG should be cleared. This of course slows things down.
> 
> This patch implements (3). To limit the performance impact in
> skb_segment, the list is walked only for skbs with SKB_GSO_DODGY set
> that have gso_size changed. Normal paths thus will not hit it.
> 
> Fixes: 3dcbdb134f32 ("net: gso: Fix skb_segment splat when splitting
> gso_size mangled skb having linear-headed frag_list") Signed-off-by:
> Jiri Benc <jbenc@redhat.com>

> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 1d9719e72f9d..bbf3acff44c6 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -4134,23 +4134,25 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
>  	int i = 0;
>  	int pos;
>  
> -	if (list_skb && !list_skb->head_frag && skb_headlen(list_skb) &&
> -	    (skb_shinfo(head_skb)->gso_type & SKB_GSO_DODGY)) {
> -		/* gso_size is untrusted, and we have a frag_list with a linear
> -		 * non head_frag head.
> -		 *
> -		 * (we assume checking the first list_skb member suffices;
> -		 * i.e if either of the list_skb members have non head_frag
> -		 * head, then the first one has too).
> -		 *
> -		 * If head_skb's headlen does not fit requested gso_size, it
> -		 * means that the frag_list members do NOT terminate on exact
> -		 * gso_size boundaries. Hence we cannot perform skb_frag_t page
> -		 * sharing. Therefore we must fallback to copying the frag_list
> -		 * skbs; we do so by disabling SG.
> -		 */
> -		if (mss != GSO_BY_FRAGS && mss != skb_headlen(head_skb))
> -			features &= ~NETIF_F_SG;
> +	if ((skb_shinfo(head_skb)->gso_type & SKB_GSO_DODGY) &&
> +	    mss != GSO_BY_FRAGS && mss != skb_headlen(head_skb)) {
> +		struct sk_buff *check_skb;
> +
> +		for (check_skb = list_skb; check_skb; check_skb = check_skb->next) {
> +			if (skb_headlen(check_skb) && !check_skb->head_frag) {
> +				/* gso_size is untrusted, and we have a frag_list with
> +				 * a linear non head_frag item.
> +				 *
> +				 * If head_skb's headlen does not fit requested gso_size,
> +				 * it means that the frag_list members do NOT terminate
> +				 * on exact gso_size boundaries. Hence we cannot perform
> +				 * skb_frag_t page sharing. Therefore we must fallback to
> +				 * copying the frag_list skbs; we do so by disabling SG.
> +				 */
> +				features &= ~NETIF_F_SG;
> +				break;
> +			}
> +		}
>  	}
>  
>  	__skb_push(head_skb, doffset);

