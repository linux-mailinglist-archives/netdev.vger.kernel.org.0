Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678A73F70E7
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 10:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239308AbhHYIJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 04:09:38 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54326 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230124AbhHYIJf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 04:09:35 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mInxZ-0004dm-Th; Wed, 25 Aug 2021 16:08:33 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mInxJ-00051r-IH; Wed, 25 Aug 2021 16:08:17 +0800
Date:   Wed, 25 Aug 2021 16:08:17 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Leonard Crestez <cdleonard@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFCv3 05/15] tcp: authopt: Add crypto initialization
Message-ID: <20210825080817.GA19149@gondor.apana.org.au>
References: <cover.1629840814.git.cdleonard@gmail.com>
 <abb720b34b9eef1cc52ef68017334e27a2af83c6.1629840814.git.cdleonard@gmail.com>
 <30f73293-ea03-d18f-d923-0cf499d4b208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30f73293-ea03-d18f-d923-0cf499d4b208@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 04:34:58PM -0700, Eric Dumazet wrote:
> 
> On 8/24/21 2:34 PM, Leonard Crestez wrote:
> > The crypto_shash API is used in order to compute packet signatures. The
> > API comes with several unfortunate limitations:
> > 
> > 1) Allocating a crypto_shash can sleep and must be done in user context.
> > 2) Packet signatures must be computed in softirq context
> > 3) Packet signatures use dynamic "traffic keys" which require exclusive
> > access to crypto_shash for crypto_setkey.
> > 
> > The solution is to allocate one crypto_shash for each possible cpu for
> > each algorithm at setsockopt time. The per-cpu tfm is then borrowed from
> > softirq context, signatures are computed and the tfm is returned.
> > 
> 
> I could not see the per-cpu stuff that you mention in the changelog.

Perhaps it's time we moved the key information from the tfm into
the request structure for hashes? Or at least provide a way for
the key to be in the request structure in addition to the tfm as
the tfm model still works for IPsec.  Ard/Eric, what do you think
about that?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
