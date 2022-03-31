Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B934EE1C9
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 21:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235676AbiCaTi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 15:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234059AbiCaTi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 15:38:26 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72A01EA5EF
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 12:36:38 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id j18so1186123wrd.6
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 12:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=he90mHZvGKqmwNtg2CeJD3KfnSCa0YA4/AGcciW1LZo=;
        b=vPytl+P9plTSsZhzpHcNaYllqDMTmxO+t30QxHSwPMjCTuzhBZb3k0gjwQQESnjhJR
         ExeVA1Dn2ndJ5GOPbNCmNVUn66LO3s+ym2lgd0v1Vk6lkrzYVnVNYrhXyJ6QxKNF4KfP
         8TLgcYg1pGmwr5GxwCY2YAt/JTHOsuRRIXBGpdF6DvFOTiRwrc6TMQL3pt1ZkSTMmm9z
         /I0VXohTPNASkKatRS+fv5dhaIKGVSUaJ8wfk2Zs3pp6XUFXrKgjUM+68/YYAfkDvS1u
         Gij51Z8JDe1zCQVSaFjZ0CZMWsaAlupH+RI2sgIKRe7cEHNaID3KmoSO2KVMX1axta3T
         Q/Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=he90mHZvGKqmwNtg2CeJD3KfnSCa0YA4/AGcciW1LZo=;
        b=GpKu/g2gmOJu96aFs8fA/fXi6HYBhZNC7q7UVl+ZLwWzgwAejzXk6upmLKcqMW7QPa
         VKAMgnQMEafTBWhWI1S1zbG94hNOh7KuwLjswLhDghqQOPXszx88FOB0PcaG5sj/FeXT
         2wMVxHEqj/nAmSuabofOEDVAzHFpL6qNuYgOLRJeMcXAUUnwWMsn5c65KtQSzF36zBL4
         aZKF/16p+4j5fwL6P+3phtum0dylBhOMPjoXypCktWnBociDQkjfcfD1npbipDcC8IGb
         ikdg11D7S22MEL5EbgSyL6Wbv4WoYaOvGWf1WMz9cAXsN6shPrBUm8xCKE3SAavcZkpP
         WBDg==
X-Gm-Message-State: AOAM53323219xqbJql2ap5pTNF3rYGmCmxhB5Mjo9fgnHvxH29M+F/8w
        Ag7Cuzmu0Z3s4M+XBgeE0/Mu8Q==
X-Google-Smtp-Source: ABdhPJwHj4OTg5TsZUW13blKHr5gxfSlBm11kYH76VRLnGXq7PnIXhKugYnRUa+pEuDj60qLZ0AQNw==
X-Received: by 2002:a5d:6405:0:b0:204:1ef:56e8 with SMTP id z5-20020a5d6405000000b0020401ef56e8mr5236835wru.677.1648755397227;
        Thu, 31 Mar 2022 12:36:37 -0700 (PDT)
Received: from hades (athedsl-4461682.home.otenet.gr. [94.71.4.98])
        by smtp.gmail.com with ESMTPSA id o10-20020a5d47ca000000b00203fb25165esm377490wrc.6.2022.03.31.12.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 12:36:36 -0700 (PDT)
Date:   Thu, 31 Mar 2022 22:36:34 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     alexanderduyck@fb.com, linyunsheng@huawei.com, hawk@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v3] skbuff: fix coalescing for page_pool fragment
 recycling
Message-ID: <YkYCwi8X1EC1sm87@hades>
References: <20220331102440.1673-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331102440.1673-1-jean-philippe@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 31, 2022 at 11:24:41AM +0100, Jean-Philippe Brucker wrote:
> Fix a use-after-free when using page_pool with page fragments. We
> encountered this problem during normal RX in the hns3 driver:
> 
> (1) Initially we have three descriptors in the RX queue. The first one
>     allocates PAGE1 through page_pool, and the other two allocate one
>     half of PAGE2 each. Page references look like this:
> 
>                 RX_BD1 _______ PAGE1
>                 RX_BD2 _______ PAGE2
>                 RX_BD3 _________/
> 
> (2) Handle RX on the first descriptor. Allocate SKB1, eventually added
>     to the receive queue by tcp_queue_rcv().
> 
> (3) Handle RX on the second descriptor. Allocate SKB2 and pass it to
>     netif_receive_skb():
> 
>     netif_receive_skb(SKB2)
>       ip_rcv(SKB2)
>         SKB3 = skb_clone(SKB2)
> 
>     SKB2 and SKB3 share a reference to PAGE2 through
>     skb_shinfo()->dataref. The other ref to PAGE2 is still held by
>     RX_BD3:
> 
>                       SKB2 ---+- PAGE2
>                       SKB3 __/   /
>                 RX_BD3 _________/
> 
>  (3b) Now while handling TCP, coalesce SKB3 with SKB1:
> 
>       tcp_v4_rcv(SKB3)
>         tcp_try_coalesce(to=SKB1, from=SKB3)    // succeeds
>         kfree_skb_partial(SKB3)
>           skb_release_data(SKB3)                // drops one dataref
> 
>                       SKB1 _____ PAGE1
>                            \____
>                       SKB2 _____ PAGE2
>                                  /
>                 RX_BD3 _________/
> 
>     In skb_try_coalesce(), __skb_frag_ref() takes a page reference to
>     PAGE2, where it should instead have increased the page_pool frag
>     reference, pp_frag_count. Without coalescing, when releasing both
>     SKB2 and SKB3, a single reference to PAGE2 would be dropped. Now
>     when releasing SKB1 and SKB2, two references to PAGE2 will be
>     dropped, resulting in underflow.
> 
>  (3c) Drop SKB2:
> 
>       af_packet_rcv(SKB2)
>         consume_skb(SKB2)
>           skb_release_data(SKB2)                // drops second dataref
>             page_pool_return_skb_page(PAGE2)    // drops one pp_frag_count
> 
>                       SKB1 _____ PAGE1
>                            \____
>                                  PAGE2
>                                  /
>                 RX_BD3 _________/
> 
> (4) Userspace calls recvmsg()
>     Copies SKB1 and releases it. Since SKB3 was coalesced with SKB1, we
>     release the SKB3 page as well:
> 
>     tcp_eat_recv_skb(SKB1)
>       skb_release_data(SKB1)
>         page_pool_return_skb_page(PAGE1)
>         page_pool_return_skb_page(PAGE2)        // drops second pp_frag_count
> 
> (5) PAGE2 is freed, but the third RX descriptor was still using it!
>     In our case this causes IOMMU faults, but it would silently corrupt
>     memory if the IOMMU was disabled.
> 
> Change the logic that checks whether pp_recycle SKBs can be coalesced.
> We still reject differing pp_recycle between 'from' and 'to' SKBs, but
> in order to avoid the situation described above, we also reject
> coalescing when both 'from' and 'to' are pp_recycled and 'from' is
> cloned.
> 
> The new logic allows coalescing a cloned pp_recycle SKB into a page
> refcounted one, because in this case the release (4) will drop the right
> reference, the one taken by skb_try_coalesce().
> 
> Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in page pool")
> Suggested-by: Alexander Duyck <alexanderduyck@fb.com>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
> v2: https://lore.kernel.org/netdev/20220328132258.78307-1-jean-philippe@linaro.org/
> v1: https://lore.kernel.org/netdev/20220324172913.26293-1-jean-philippe@linaro.org/
> ---
>  net/core/skbuff.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index ea51e23e9247..2d6ef6d7ebf5 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -5244,11 +5244,18 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
>  	if (skb_cloned(to))
>  		return false;
>  
> -	/* The page pool signature of struct page will eventually figure out
> -	 * which pages can be recycled or not but for now let's prohibit slab
> -	 * allocated and page_pool allocated SKBs from being coalesced.
> +	/* In general, avoid mixing slab allocated and page_pool allocated
> +	 * pages within the same SKB. However when @to is not pp_recycle and
> +	 * @from is cloned, we can transition frag pages from page_pool to
> +	 * reference counted.
> +	 *
> +	 * On the other hand, don't allow coalescing two pp_recycle SKBs if
> +	 * @from is cloned, in case the SKB is using page_pool fragment
> +	 * references (PP_FLAG_PAGE_FRAG). Since we only take full page
> +	 * references for cloned SKBs at the moment that would result in
> +	 * inconsistent reference counts.
>  	 */
> -	if (to->pp_recycle != from->pp_recycle)
> +	if (to->pp_recycle != (from->pp_recycle && !skb_cloned(from)))
>  		return false;
>  
>  	if (len <= skb_tailroom(to)) {
> -- 
> 2.25.1
> 

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

