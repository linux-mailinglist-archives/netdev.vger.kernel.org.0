Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891116A654A
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 03:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjCACGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 21:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjCACGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 21:06:43 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B1636FD1
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 18:06:42 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pXBrS-00GidY-60; Wed, 01 Mar 2023 10:06:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 01 Mar 2023 10:06:30 +0800
Date:   Wed, 1 Mar 2023 10:06:30 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Aichun Li <liaichun@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, yanan@huawei.com,
        zhongxuan2@huawei.com
Subject: Re: [PATCH] af_key: Fix panic in dump_ah_combs()
Message-ID: <Y/6zJnNRXtpYyaSJ@gondor.apana.org.au>
References: <20230228140126.2208-1-liaichun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228140126.2208-1-liaichun@huawei.com>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
        PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 10:01:26PM +0800, Aichun Li wrote:
> Because the exclamation mark (!) is removed, the return value calculated by
>  count_esp_combs is smaller than that before ealg->available is removed. And in
>  dump_esp_combs, the number of struct sadb_combs in skb_put is larger than
>  alloc, This result in a buffer overrun.
> 
> [ 658.159619] ------------[ cut here ]------------
> [ 658.159629] kernel BUG at net/core/skbuff.c:110!
> [ 658.159733] invalid opcode: 0000 [#1] SMP KASAN NOPTI
> [ 658.160047] CPU: 14 PID: 107946 Comm: kernel_BUG_in_w Kdump: loaded Tainted: G I 5.10.0-60.18.0.50.x86_64 #1

Can you reproduce this on a mainline kernel?
 
> diff --git a/net/key/af_key.c b/net/key/af_key.c
> index 8bc7d3999..bf2859c37 100644
> --- a/net/key/af_key.c
> +++ b/net/key/af_key.c
> @@ -2927,7 +2927,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
>  		if (!ealg->pfkey_supported)
>  			continue;
>  
> -		if (!(ealg_tmpl_set(t, ealg)))
> +		if (!(ealg_tmpl_set(t, ealg) && ealg->available))
>  			continue;

This makes no sense.  You are making the result of
count_esp_combs smaller.  How can that prevent a buffer overrun
if it was too small to begin with?

PS we could remove those brackets though, that would be a good
clean-up patch.

-		if (!(ealg_tmpl_set(t, ealg)))
+		if (!ealg_tmpl_set(t, ealg))

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
