Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476A06734CD
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 10:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjASJvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 04:51:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjASJvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 04:51:35 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAC8676F2;
        Thu, 19 Jan 2023 01:51:30 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pIRZh-001hVL-5O; Thu, 19 Jan 2023 17:51:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 19 Jan 2023 17:51:13 +0800
Date:   Thu, 19 Jan 2023 17:51:13 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 1/4] crypto: Introduce crypto_pool
Message-ID: <Y8kSkW4X4vQdFyOl@gondor.apana.org.au>
References: <20230118214111.394416-1-dima@arista.com>
 <20230118214111.394416-2-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118214111.394416-2-dima@arista.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 09:41:08PM +0000, Dmitry Safonov wrote:
> Introduce a per-CPU pool of async crypto requests that can be used
> in bh-disabled contexts (designed with net RX/TX softirqs as users in
> mind). Allocation can sleep and is a slow-path.
> Initial implementation has only ahash as a backend and a fix-sized array
> of possible algorithms used in parallel.
> 
> Signed-off-by: Dmitry Safonov <dima@arista.com>
> ---
>  crypto/Kconfig        |   3 +
>  crypto/Makefile       |   1 +
>  crypto/crypto_pool.c  | 333 ++++++++++++++++++++++++++++++++++++++++++
>  include/crypto/pool.h |  46 ++++++
>  4 files changed, 383 insertions(+)
>  create mode 100644 crypto/crypto_pool.c
>  create mode 100644 include/crypto/pool.h

I'm still nacking this.

I'm currently working on per-request keys which should render
this unnecessary.  With per-request keys you can simply do an
atomic kmalloc when you compute the hash.

Modelling tcp_md5 is just propagating bad code.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
