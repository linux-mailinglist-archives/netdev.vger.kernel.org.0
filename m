Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A430F5849C8
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 04:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbiG2CbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 22:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbiG2Ca7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 22:30:59 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F10A6A9E4;
        Thu, 28 Jul 2022 19:30:58 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oHFln-005h7C-M5; Fri, 29 Jul 2022 12:30:33 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 Jul 2022 10:30:31 +0800
Date:   Fri, 29 Jul 2022 10:30:31 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Abhishek Shah <abhishek.shah@columbia.edu>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, linux-kernel@vger.kernel.org,
        Gabriel Ryan <gabe@cs.columbia.edu>,
        Fan Du <fan.du@windriver.com>
Subject: Re: Race 1 in net/xfrm/xfrm_algo.c
Message-ID: <YuNGR/5U5pSo6YM3@gondor.apana.org.au>
References: <CAEHB24-9hXY+TgQKxJB4bE9a9dFD9C+Lan+ShBwpvwaHVAGMFg@mail.gmail.com>
 <YtoWqEkKzvimzWS5@gondor.apana.org.au>
 <CAEHB249ygptvp9wpynMF7zZ2Kcet0+bwLVuVg5UReZHOU1+8HA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEHB249ygptvp9wpynMF7zZ2Kcet0+bwLVuVg5UReZHOU1+8HA@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 08:00:00PM -0400, Abhishek Shah wrote:
> Dear Herbert,
> 
> Thanks for your quick reply and sorry for not being more clear about the
> inconsistencies. We identified security implications when algorithms
> disappear or reappear during the execution of *compose_sadb_supported*.
> 
> In more detail,
> 
> 1) If after *xfrm_count_pfkey_auth_supported* has finished counting the
> available algos, a secondary thread changes the availability of an algo
> through *xfrm_probe_algs*, it will return an incorrect number of available
> algorithms. If an algo was added during the racing access, the code
> allocates a buffer that is smaller than the number of available algorithms
> at net/key/af_key.c#L1619
> <https://elixir.bootlin.com/linux/v5.18-rc5/source/net/key/af_key.c#L1619>.
> This will result in an out of bounds write when the buffer is later
> populated at net/key/af_key.c#L1657
> <https://elixir.bootlin.com/linux/v5.18-rc5/source/net/key/af_key.c#L1657>.

OK this is a real bug caused by this commit:

commit 283bc9f35bbbcb0e9ab4e6d2427da7f9f710d52d
Author: Fan Du <fan.du@windriver.com>
Date:   Thu Nov 7 17:47:50 2013 +0800

    xfrm: Namespacify xfrm state/policy locks

It neglected to convert xfrm_probe_algs to namespaces so the
previous assumption of exclusive ownership of xfrm_algo_list
by the current afkey request is no longer true.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
