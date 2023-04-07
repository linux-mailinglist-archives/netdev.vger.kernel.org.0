Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0536DAEA3
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 16:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbjDGOOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 10:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjDGOOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 10:14:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A396F6E95
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 07:14:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F41664B5C
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 14:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392EBC433D2;
        Fri,  7 Apr 2023 14:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680876843;
        bh=xggwqxu0u/kDNE/3crGUPys0emGU9M53Y1CBWZTD7YA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lGi3KIJYpAT4lozcRiI958XPqYvAUsGBer2KGTs3HGsavIxk3VgQi0h/1yUxV5gHG
         n3V5/ZHUQvcswxCWfQqwu0WVi0TEqoUWKf6DzCCQVvRYM/TLjIFwMg/xu+2ae2LkOr
         AWeB5EmTsS+e1vsp3UK7i807Wj3nC1RYdPXFLSdv8Y/pz1VUdaE7trVQrq0/0Iq1jp
         zEGHRdoscPf19oTbaZ55AUr1zqa2ZHLEIcKhjkTdTVVFSfjWYHMquGi1YASgGpmu71
         zyhYckTZu54SVD+vYSh+3QS/OJVbBe8VjqRBYn/RSYInmWN7wFfpOK6qEmwJE3yRt9
         1XRZ/QXLwdtlQ==
Date:   Fri, 7 Apr 2023 07:14:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>
Subject: Re: [RFC net-next v2 1/3] net: skb: plumb napi state thru skb
 freeing paths
Message-ID: <20230407071402.09fa792f@kernel.org>
In-Reply-To: <2628d71f-ef66-6ea9-61da-6d01c04fbda9@huawei.com>
References: <20230405232100.103392-1-kuba@kernel.org>
        <20230405232100.103392-2-kuba@kernel.org>
        <2628d71f-ef66-6ea9-61da-6d01c04fbda9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Apr 2023 17:15:15 +0800 Yunsheng Lin wrote:
> On 2023/4/6 7:20, Jakub Kicinski wrote:
> > We maintain a NAPI-local cache of skbs which is fed by napi_consume_skb().
> > Going forward we will also try to cache head and data pages.
> > Plumb the "are we in a normal NAPI context" information thru
> > deeper into the freeing path, up to skb_release_data() and
> > skb_free_head()/skb_pp_recycle().
> > 
> > Use "bool in_normal_napi" rather than bare "int budget",
> > the further we get from NAPI the more confusing the budget
> > argument may seem (particularly whether 0 or MAX is the
> > correct value to pass in when not in NAPI).

> > @@ -839,7 +839,7 @@ static void skb_clone_fraglist(struct sk_buff *skb)
> >  		skb_get(list);
> >  }
> >  
> > -static bool skb_pp_recycle(struct sk_buff *skb, void *data)
> > +static bool skb_pp_recycle(struct sk_buff *skb, void *data, bool in_normal_napi)  
> 
> What does *normal* means in 'in_normal_napi'?
> can we just use in_napi?

Technically netpoll also calls NAPI, that's why I threw in the
"normal". If folks prefer in_napi or some other name I'm more 
than happy to change. Naming is hard.

> > @@ -1226,7 +1228,7 @@ static void napi_skb_cache_put(struct sk_buff *skb)
> >  
> >  void __kfree_skb_defer(struct sk_buff *skb)
> >  {
> > -	skb_release_all(skb, SKB_DROP_REASON_NOT_SPECIFIED);
> > +	skb_release_all(skb, SKB_DROP_REASON_NOT_SPECIFIED, false);
> >  	napi_skb_cache_put(skb);  
> 
> Is there any reson not to call skb_release_all() with in_normal_napi
> being true while napi_skb_cache_put() is called here?

True, __kfree_skb_defer() needs more work also. I'll set in to true 
in the PATCH posting and clean up the function in a follow up.
