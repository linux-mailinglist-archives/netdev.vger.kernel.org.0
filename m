Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 902A04EC4C9
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 14:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236650AbiC3Mqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 08:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345436AbiC3MqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 08:46:21 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74496C93F
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 05:41:43 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id u3so29141926wrg.3
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 05:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ntNw1/K6MzgroAQUZycU3BVrpDXQ208LuoqMSrH8JKU=;
        b=h5F3LVbj+xzXh9NZGsFmCvF9woGph5wtXj5/CPNvsahEeaH75KhEWJiULV/gjqs1tQ
         HbYwFzeNj05fUmoL+twz4e5AJDLM0g1G9gJC0xD1ULBMPH5dA4P8HduRmw21TG7JM2W7
         J1h+8JjyJAGBtl2Uieg1RgiYUD+NKCHiYk1Jfuq+LFABveZ+aEtjJNSbeXA0Ocb75ldq
         XzvbRpS4N0rBsWNz4BOSsTFVTlrCsHEaWag1QK1L8JuKKhEX8DhKNGx+F8YDMEWDxCpt
         t0N9SXR/sYCNtWxq2hzX7mmpmT2RfMT9kOI2JuZ2/9oztozcM4SZl6XWKADUvJ647PjN
         VmVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ntNw1/K6MzgroAQUZycU3BVrpDXQ208LuoqMSrH8JKU=;
        b=XQYioLsXbNypACmkP84ZSb73Kq74autoE+pq2OtJ55NQyRVDqB9Ppzny0HkosHMZeR
         DYVA25MMv7R1ytgLsDz0zi2hty7d5Wnk1I5cDZwZNzb6OCy0a6qhmspAFKTR800EBMQO
         gdgmw7SPdw8Kk+kYHdhZlEvYehCPTNZn4mRz/sA1WyHji/fQw4ZY0ops7RJS6i31/x3+
         CNDxnZUg+hnml4uaVfm7cbAlI9/8ujC3bm+NWKqWeUqXegr7CWJxVI5FzT3cgkptTmrn
         eEJxRRRA1KyVMushHew40neZVZP9nPVYDu2a1smPvT8LUlhJ7RjNzx34u2bJ8EaaMd+N
         cZLQ==
X-Gm-Message-State: AOAM531QPV+pS0OfKzYZ7drxbpVYWh7Jq231FNiWPuGEwZJlPHLjQkyL
        XOYiJmvqaHR3E3cpYOIDxoXqSA==
X-Google-Smtp-Source: ABdhPJwR9SzzRqEnJ2hXX5XoFqkbE0jg/8d2+sCsSD2JlQ9n//OBzVKq8ca0/ehZClZ4SO/5WisyEg==
X-Received: by 2002:a05:6000:ca:b0:203:dbf3:8f8a with SMTP id q10-20020a05600000ca00b00203dbf38f8amr36588860wrx.10.1648644102441;
        Wed, 30 Mar 2022 05:41:42 -0700 (PDT)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id a4-20020a05600c348400b0038cd743830esm4681557wmq.29.2022.03.30.05.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 05:41:42 -0700 (PDT)
Date:   Wed, 30 Mar 2022 13:41:17 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     ilias.apalodimas@linaro.org, hawk@kernel.org,
        alexanderduyck@fb.com, linyunsheng@huawei.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] skbuff: disable coalescing for page_pool fragment
 recycling
Message-ID: <YkRP7XwvdgFbvGsk@myrica>
References: <20220328132258.78307-1-jean-philippe@linaro.org>
 <2de8c5818582bd9dfe0406541e3326c2bed0b6f2.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2de8c5818582bd9dfe0406541e3326c2bed0b6f2.camel@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 28, 2022 at 08:03:46AM -0700, Alexander H Duyck wrote:
> >  (3b) Now while handling TCP, coalesce SKB3 with SKB1:
> > 
> >       tcp_v4_rcv(SKB3)
> >         tcp_try_coalesce(to=SKB1, from=SKB3)    // succeeds
> >         kfree_skb_partial(SKB3)
> >           skb_release_data(SKB3)                // drops one dataref
> > 
> >                       SKB1 _____ PAGE1
> >                            \____
> >                       SKB2 _____ PAGE2
> >                                  /
> >                 RX_BD3 _________/
> > 
> >     In tcp_try_coalesce(), __skb_frag_ref() takes a page reference to
> >     PAGE2, where it should instead have increased the page_pool frag
> >     reference, pp_frag_count. Without coalescing, when releasing both
> >     SKB2 and SKB3, a single reference to PAGE2 would be dropped. Now
> >     when releasing SKB1 and SKB2, two references to PAGE2 will be
> >     dropped, resulting in underflow.
> > 
> >  (3c) Drop SKB2:
> > 
> >       af_packet_rcv(SKB2)
> >         consume_skb(SKB2)
> >           skb_release_data(SKB2)                // drops second dataref
> >             page_pool_return_skb_page(PAGE2)    // drops one pp_frag_count
> > 
> >                       SKB1 _____ PAGE1
> >                            \____
> >                                  PAGE2
> >                                  /
> >                 RX_BD3 _________/
> > 
> > (4) Userspace calls recvmsg()
> >     Copies SKB1 and releases it. Since SKB3 was coalesced with SKB1, we
> >     release the SKB3 page as well:
> > 
> >     tcp_eat_recv_skb(SKB1)
> >       skb_release_data(SKB1)
> >         page_pool_return_skb_page(PAGE1)
> >         page_pool_return_skb_page(PAGE2)        // drops second pp_frag_count
> > 
> > (5) PAGE2 is freed, but the third RX descriptor was still using it!
> >     In our case this causes IOMMU faults, but it would silently corrupt
> >     memory if the IOMMU was disabled.
> > 
> > Prevent coalescing the SKB if it may hold shared page_pool fragment
> > references.
> > 
> > Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in page pool")
> > Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > ---
> >  net/core/skbuff.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 10bde7c6db44..56b45b9f0b4d 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -5276,6 +5276,13 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
> >  	if (skb_cloned(to))
> >  		return false;
> >  
> > +	/* We don't support taking page_pool frag references at the moment.
> > +	 * If the SKB is cloned and could have page_pool frag references, don't
> > +	 * coalesce it.
> > +	 */
> > +	if (skb_cloned(from) && from->pp_recycle)
> > +		return false;
> > +
> >  	/* The page pool signature of struct page will eventually figure out
> >  	 * which pages can be recycled or not but for now let's prohibit slab
> >  	 * allocated and page_pool allocated SKBs from being coalesced.
> 
> 
> This is close but not quite. Actually now that I think about it we can
> probably alter the block below rather than adding a new one.
> 
> The issue is we want only reference counted pages in standard skbs, and
> pp_frag_count pages in pp_recycle skbs. So we already had logic along
> the lines of:
> 	if (to->pp_recycle != from->pp_recycle)
> 		return false;
> 
> I would say we need to change that because from->pp_recycle is the
> piece that is probably too simplistic. Basically we will get a page
> pool page if from->pp_recycle && !skb_cloned(from). So we can probably
> just tweak the check below to be something along the lines of:
> 	if (to->pp_recycle != (from->pp_recycle && !skb_cloned(from)))
> 		return false;

Just to confirm this is fine: the behavior now changes for
to->pp_recycle == 0, from->pp_recycle == 1 and skb_cloned(from) == 1
In this case we now coalesce and take a page ref. So the page has two refs
and two pp_frag_count. (3c) drops one pp_frag_count. If there wasn't
another RX desc holding a pp_frag_count (ie. no step (5)), that would also
drop a page ref, but since 'to' SKB is holding a second page ref the page
is not recycled. That reference gets dropped at (4) and the page is freed
there.  With step (5), the page would get recycled into page_pool, but
without (5) the page is discarded.

I guess it works, just want to make sure that it's OK to mix page_pool
pp_frag_count and normal reference counting at the same time.

Thanks,
Jean

> 
> That should actually increase the number of cases where we can
> correctly coalesce frames while also addressing the issue you
> discovered as it will only merge cloned skbs into standard skbs instead
> of page pool ones.
> 
