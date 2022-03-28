Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA1E4E9A4F
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 17:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244097AbiC1PFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 11:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240427AbiC1PFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 11:05:31 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E6634677
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 08:03:50 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id gh15so12014219qvb.8
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 08:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=rHBrPvAQZEU9QBU1XsE1SsB3N/HclQVTC9ctYDM50n8=;
        b=Zn58brgWltLJagcF6Z2GrZpYN+uWkI1+5vjpcf3S75HK2cyvZtJ4fTpTFFRVYsNr8Q
         8IW+4DKP+BR8fNAe24vELRb9jGGDYVGDxvqh4MYVVaZmi8mJBw1tF1XxsjMMRe9eHojZ
         RvcOZ5hmVBCLj8MVEAIO+d0ri1Mr1iZ4uUuWIgFxwXp4fEk+t6j031Yyl8Xya5TQmxxN
         sYsWuD16jRM/mEdcKx7IBi/cJM4mIyur916eDgeOypTHSwTQ/tDp5x22eATHmwW8R3ov
         9skYslwQQSiRCg5fAq06TxZ18MdE2JFaive5kUE45En1CyCRiPk87m2p0WrfeF9K3+hr
         3dxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=rHBrPvAQZEU9QBU1XsE1SsB3N/HclQVTC9ctYDM50n8=;
        b=2NECzonm9Xw1P7hIKe6PZNzUzca1G/hbBhEZHD2w0yciP4evHQWSUuobvM/6HpS5r8
         UmwbOqdVEKoutz8Syklc6JJ0tzFGRWMi7oSlkbXas+TObWRez8EGVCYLSDsbHs+YUiEO
         /+Kqp+Sezm5IaNgZm2lwaefz++i727pX9HmdEOqLR18T60TcU07d3Piy0RiVKHI3tgXx
         UmT5MBFcnj1NfBXnHX+X/dWdxqltgWwyh5ZyCGengur6g6tvZq+dmY3N9tnax+nmAsOp
         azsMhbsh1lcnzXijue1Vx5S3O6PZMS3l0Zcs4q4EiMmpQvgOglW9932fZ729+yGKDQsx
         p7cg==
X-Gm-Message-State: AOAM532PgMRkRvqINfGUAEsdJH0j+0ms0uCS2JTCIJlvTMpUTrnSeLdc
        4T8tvwX4T4qZFp83qYjZjZg=
X-Google-Smtp-Source: ABdhPJwDiAt/NiaHlFYC43PWZ7s2yhLL6YeTo1O/XAzs7Fu26uPG1oSFV3fmkKRsin8hZQbB9gZTjA==
X-Received: by 2002:ad4:5948:0:b0:441:5d45:6d62 with SMTP id eo8-20020ad45948000000b004415d456d62mr21211706qvb.25.1648479829629;
        Mon, 28 Mar 2022 08:03:49 -0700 (PDT)
Received: from ?IPv6:2001:470:b:9c3:82ee:73ff:fe41:9a02? ([2001:470:b:9c3:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id m3-20020a05622a118300b002e1beed4908sm13101884qtk.3.2022.03.28.08.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 08:03:49 -0700 (PDT)
Message-ID: <2de8c5818582bd9dfe0406541e3326c2bed0b6f2.camel@gmail.com>
Subject: Re: [PATCH net v2] skbuff: disable coalescing for page_pool
 fragment recycling
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        ilias.apalodimas@linaro.org, hawk@kernel.org,
        alexanderduyck@fb.com, linyunsheng@huawei.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Date:   Mon, 28 Mar 2022 08:03:46 -0700
In-Reply-To: <20220328132258.78307-1-jean-philippe@linaro.org>
References: <20220328132258.78307-1-jean-philippe@linaro.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-3.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-03-28 at 14:22 +0100, Jean-Philippe Brucker wrote:
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
>     In tcp_try_coalesce(), __skb_frag_ref() takes a page reference to
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
> Prevent coalescing the SKB if it may hold shared page_pool fragment
> references.
> 
> Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in page pool")
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  net/core/skbuff.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 10bde7c6db44..56b45b9f0b4d 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -5276,6 +5276,13 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
>  	if (skb_cloned(to))
>  		return false;
>  
> +	/* We don't support taking page_pool frag references at the moment.
> +	 * If the SKB is cloned and could have page_pool frag references, don't
> +	 * coalesce it.
> +	 */
> +	if (skb_cloned(from) && from->pp_recycle)
> +		return false;
> +
>  	/* The page pool signature of struct page will eventually figure out
>  	 * which pages can be recycled or not but for now let's prohibit slab
>  	 * allocated and page_pool allocated SKBs from being coalesced.


This is close but not quite. Actually now that I think about it we can
probably alter the block below rather than adding a new one.

The issue is we want only reference counted pages in standard skbs, and
pp_frag_count pages in pp_recycle skbs. So we already had logic along
the lines of:
	if (to->pp_recycle != from->pp_recycle)
		return false;

I would say we need to change that because from->pp_recycle is the
piece that is probably too simplistic. Basically we will get a page
pool page if from->pp_recycle && !skb_cloned(from). So we can probably
just tweak the check below to be something along the lines of:
	if (to->pp_recycle != (from->pp_recycle && !skb_cloned(from)))
		return false;

That should actually increase the number of cases where we can
correctly coalesce frames while also addressing the issue you
discovered as it will only merge cloned skbs into standard skbs instead
of page pool ones.

