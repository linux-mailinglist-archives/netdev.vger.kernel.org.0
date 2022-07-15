Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 255A5575DD3
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 10:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbiGOIrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 04:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbiGOIrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 04:47:09 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E7F814B4;
        Fri, 15 Jul 2022 01:47:07 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oCGyA-000nqB-Ie; Fri, 15 Jul 2022 18:46:44 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Jul 2022 16:46:42 +0800
Date:   Fri, 15 Jul 2022 16:46:42 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net,
        borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/3] crypto: Introduce ARIA symmetric cipher algorithm
Message-ID: <YtEpcsFsXD6xuDQS@gondor.apana.org.au>
References: <20220704094250.4265-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704094250.4265-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 04, 2022 at 09:42:47AM +0000, Taehee Yoo wrote:
> This patchset adds a new ARIA(RFC 5794) symmetric cipher algorithm.
> 
> Like SEED, the ARIA is a standard cipher algorithm in South Korea.
> Especially Government and Banking industry have been using this algorithm.
> So the implementation of ARIA will be useful for them and network vendors.
> 
> Usecases of this algorithm are TLS[1], and IPSec.
> 
> It is tested in x86 and MIPS with the tcrypt module.
> 
> The first patch is an implementation of ARIA algorithm.
> The second patch adds tests for ARIA.
> The third patch adds ARIA-kTLS feature.
> 
> ARIA128-kTLS Benchmark results:
> openssl-3.0-dev and iperf-ssl are used.
>   TLS
> [  3]  0.0- 1.0 sec   185 MBytes  1.55 Gbits/sec
> [  3]  1.0- 2.0 sec   186 MBytes  1.56 Gbits/sec
> [  3]  2.0- 3.0 sec   186 MBytes  1.56 Gbits/sec
> [  3]  3.0- 4.0 sec   186 MBytes  1.56 Gbits/sec
> [  3]  4.0- 5.0 sec   186 MBytes  1.56 Gbits/sec
> [  3]  0.0- 5.0 sec   927 MBytes  1.56 Gbits/sec
>   kTLS
> [  3]  0.0- 1.0 sec   198 MBytes  1.66 Gbits/sec
> [  3]  1.0- 2.0 sec   194 MBytes  1.62 Gbits/sec
> [  3]  2.0- 3.0 sec   194 MBytes  1.63 Gbits/sec
> [  3]  3.0- 4.0 sec   194 MBytes  1.63 Gbits/sec
> [  3]  4.0- 5.0 sec   194 MBytes  1.62 Gbits/sec
> [  3]  0.0- 5.0 sec   974 MBytes  1.63 Gbits/sec
> 
> The previous patch version[2].
> 
> [1] https://datatracker.ietf.org/doc/html/rfc6209
> [2] https://www.spinics.net/lists/linux-crypto/msg64704.html
> 
> v2:
>  - Add ARIA-kTLS feature.
> 
> Taehee Yoo (3):
>   crypto: Implement ARIA symmetric cipher algorithm
>   crypto: add ARIA testmgr tests
>   net: tls: Add ARIA-GCM algorithm
> 
>  crypto/Kconfig           |   15 +
>  crypto/Makefile          |    1 +
>  crypto/aria.c            |  288 ++++
>  crypto/tcrypt.c          |   38 +-
>  crypto/testmgr.c         |   31 +
>  crypto/testmgr.h         | 2860 ++++++++++++++++++++++++++++++++++++++
>  include/crypto/aria.h    |  461 ++++++
>  include/uapi/linux/tls.h |   30 +
>  net/tls/tls_main.c       |   62 +
>  net/tls/tls_sw.c         |   34 +
>  10 files changed, 3819 insertions(+), 1 deletion(-)
>  create mode 100644 crypto/aria.c
>  create mode 100644 include/crypto/aria.h

Patches 1-2 applied.  Thanks.

Note that I adjusted the tcrypt test numbers to accommodate for other
additions.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
