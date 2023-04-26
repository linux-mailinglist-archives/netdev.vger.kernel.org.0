Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C1E6EF147
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 11:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240095AbjDZJiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 05:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240044AbjDZJiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 05:38:12 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA81393;
        Wed, 26 Apr 2023 02:38:10 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1prbau-002Wmo-RS; Wed, 26 Apr 2023 17:37:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 26 Apr 2023 17:37:49 +0800
Date:   Wed, 26 Apr 2023 17:37:49 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     cai.huoqing@linux.dev, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netdevsim: fib: Make use of rhashtable_iter
Message-ID: <ZEjw7XXFro6zYYXz@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425144556.98799-1-cai.huoqing@linux.dev>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cai Huoqing <cai.huoqing@linux.dev> wrote:
> Iterating 'fib_rt_ht' by rhashtable_walk_next and rhashtable_iter directly
> instead of using list_for_each, because each entry of fib_rt_ht can be
> found by rhashtable API. And remove fib_rt_list.
> 
> Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
> ---
> drivers/net/netdevsim/fib.c | 37 ++++++++++++++++++-------------------
> 1 file changed, 18 insertions(+), 19 deletions(-)

What is the rationale for this patch? Are you trying to save
memory?

> @@ -1099,9 +1090,12 @@ static void nsim_fib_dump_inconsistent(struct notifier_block *nb)
>        /* The notifier block is still not registered, so we do not need to
>         * take any locks here.
>         */
> -       list_for_each_entry_safe(fib_rt, fib_rt_tmp, &data->fib_rt_list, list) {
> -               rhashtable_remove_fast(&data->fib_rt_ht, &fib_rt->ht_node,
> +       rhashtable_walk_enter(&data->fib_rt_ht, &hti);
> +       rhashtable_walk_start(&hti);
> +       while ((pos = rhashtable_walk_next(&hti))) {
> +               rhashtable_remove_fast(&data->fib_rt_ht, hti.p,
>                                       nsim_fib_rt_ht_params);
> +               fib_rt = rhashtable_walk_peek(&hti);
>                nsim_fib_rt_free(fib_rt, data);
>        }

In general rhashtable walks are not stable.  You may miss entries
or see entries twice.  They should be avoided unless absolutely
necessary.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
