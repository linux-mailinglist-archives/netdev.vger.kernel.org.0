Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6770E6F1B35
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 17:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346338AbjD1PMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 11:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346252AbjD1PMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 11:12:02 -0400
Received: from out-29.mta0.migadu.com (out-29.mta0.migadu.com [IPv6:2001:41d0:1004:224b::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35B81993
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 08:12:00 -0700 (PDT)
Date:   Fri, 28 Apr 2023 23:11:55 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682694718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6K5PGPkhqqfDzHS0/ulvxssY7bWoPWduvYOiThv73BU=;
        b=EagoKORfAA/gP/NgSqLBPbLwEBKC7pUad6jXfuRyMNNUp8dv1O1Tc9U2mdYpnS+Hiftzfx
        IT3bgwyh5rlQNyeUqjH+iZVCjUJRDp2aYagi64TLpTED8O+gVQ0ACLkSslgDxVKBeWGaxr
        ZnS4lWSyeXZhKO9RmEhJqLlUcHtFh00=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Cai Huoqing <cai.huoqing@linux.dev>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netdevsim: fib: Make use of rhashtable_iter
Message-ID: <ZEviO+NPFP/IoiO2@chq-MS-7D45>
References: <20230425144556.98799-1-cai.huoqing@linux.dev>
 <ZEjw7XXFro6zYYXz@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZEjw7XXFro6zYYXz@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26 4月 23 17:37:49, Herbert Xu wrote:
> Cai Huoqing <cai.huoqing@linux.dev> wrote:
> > Iterating 'fib_rt_ht' by rhashtable_walk_next and rhashtable_iter directly
> > instead of using list_for_each, because each entry of fib_rt_ht can be
> > found by rhashtable API. And remove fib_rt_list.
> > 
> > Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
> > ---
> > drivers/net/netdevsim/fib.c | 37 ++++++++++++++++++-------------------
> > 1 file changed, 18 insertions(+), 19 deletions(-)
> 
> What is the rationale for this patch? Are you trying to save
> memory?
Hi 
Thanks for your reply,

I think not need to use two structs to link fib_rt node, 
fib_rt_list is redundant.

Thanks,
Cai-

> 
> > @@ -1099,9 +1090,12 @@ static void nsim_fib_dump_inconsistent(struct notifier_block *nb)
> >        /* The notifier block is still not registered, so we do not need to
> >         * take any locks here.
> >         */
> > -       list_for_each_entry_safe(fib_rt, fib_rt_tmp, &data->fib_rt_list, list) {
> > -               rhashtable_remove_fast(&data->fib_rt_ht, &fib_rt->ht_node,
> > +       rhashtable_walk_enter(&data->fib_rt_ht, &hti);
> > +       rhashtable_walk_start(&hti);
> > +       while ((pos = rhashtable_walk_next(&hti))) {
> > +               rhashtable_remove_fast(&data->fib_rt_ht, hti.p,
> >                                       nsim_fib_rt_ht_params);
> > +               fib_rt = rhashtable_walk_peek(&hti);
> >                nsim_fib_rt_free(fib_rt, data);
> >        }
> 
> In general rhashtable walks are not stable.  You may miss entries
> or see entries twice.  They should be avoided unless absolutely
> necessary.
Agree, but how about using rhashtable_free_and_destroy here
instead of rhashtable_walk_next in this patch.

> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
