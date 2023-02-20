Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7B769C7D0
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 10:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbjBTJmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 04:42:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjBTJmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 04:42:36 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F64312BFD;
        Mon, 20 Feb 2023 01:42:33 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pU2gA-00DJtI-Ig; Mon, 20 Feb 2023 17:41:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 20 Feb 2023 17:41:50 +0800
Date:   Mon, 20 Feb 2023 17:41:50 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Laight <David.Laight@aculab.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 01/21] net/tcp: Prepare tcp_md5sig_pool for TCP-AO
Message-ID: <Y/NAXtPrOkzjLewO@gondor.apana.org.au>
References: <20230215183335.800122-1-dima@arista.com>
 <20230215183335.800122-2-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215183335.800122-2-dima@arista.com>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
        PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 06:33:15PM +0000, Dmitry Safonov wrote:
> TCP-AO similarly to TCP-MD5 needs to allocate tfms on a slow-path, which
> is setsockopt() and use crypto ahash requests on fast paths, which are
> RX/TX softirqs. It as well needs a temporary/scratch buffer for
> preparing the hashing request.
> 
> Extend tcp_md5sig_pool to support other hashing algorithms than MD5.
> Move it in a separate file.
> 
> This patch was previously submitted as more generic crypto_pool [1],
> but Herbert nacked making it generic crypto API. His view is that crypto
> requests should be atomically allocated on fast-paths. So, in this
> version I don't move this pool anywhere outside TCP, only extending it
> for TCP-AO use-case. It can be converted once there will be per-request
> hashing crypto keys.
> 
> [1]: https://lore.kernel.org/all/20230118214111.394416-1-dima@arista.com/T/#u
> Signed-off-by: Dmitry Safonov <dima@arista.com>
> ---
>  include/net/tcp.h        |  48 ++++--
>  net/ipv4/Kconfig         |   4 +
>  net/ipv4/Makefile        |   1 +
>  net/ipv4/tcp.c           | 103 +++---------
>  net/ipv4/tcp_ipv4.c      |  97 +++++++-----
>  net/ipv4/tcp_minisocks.c |  21 ++-
>  net/ipv4/tcp_sigpool.c   | 333 +++++++++++++++++++++++++++++++++++++++
>  net/ipv6/tcp_ipv6.c      |  58 +++----
>  8 files changed, 493 insertions(+), 172 deletions(-)
>  create mode 100644 net/ipv4/tcp_sigpool.c

Please wait for my per-request hash work before you resubmit this.
Once that's in place all you need is a single tfm for the whole
system.

As to request pools what exactly is the point of that? Just kmalloc
them on demand.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
