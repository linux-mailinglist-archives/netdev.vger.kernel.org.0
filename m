Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E11521153E
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 23:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgGAVhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 17:37:41 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:36678 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbgGAVhk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 17:37:40 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jqkQB-0000Jb-U0; Thu, 02 Jul 2020 07:37:37 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 02 Jul 2020 07:37:35 +1000
Date:   Thu, 2 Jul 2020 07:37:35 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Marco Elver <elver@google.com>
Subject: Re: [PATCH v2 net] tcp: md5: refine
 tcp_md5_do_add()/tcp_md5_hash_key() barriers
Message-ID: <20200701213735.GA13349@gondor.apana.org.au>
References: <20200701184304.3685065-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701184304.3685065-1-edumazet@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 01, 2020 at 11:43:04AM -0700, Eric Dumazet wrote:
> My prior fix went a bit too far, according to Herbert and Mathieu.
> 
> Since we accept that concurrent TCP MD5 lookups might see inconsistent
> keys, we can use READ_ONCE()/WRITE_ONCE() instead of smp_rmb()/smp_wmb()
> 
> Clearing all key->key[] is needed to avoid possible KMSAN reports,
> if key->keylen is increased. Since tcp_md5_do_add() is not fast path,
> using __GFP_ZERO to clear all struct tcp_md5sig_key is simpler.
> 
> data_race() was added in linux-5.8 and will prevent KCSAN reports,
> this can safely be removed in stable backports, if data_race() is
> not yet backported.
> 
> v2: use data_race() both in tcp_md5_hash_key() and tcp_md5_do_add()
> 
> Fixes: 6a2febec338d ("tcp: md5: add missing memory barriers in tcp_md5_do_add()/tcp_md5_hash_key()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Marco Elver <elver@google.com>
> ---
>  net/ipv4/tcp.c      |  8 ++++----
>  net/ipv4/tcp_ipv4.c | 19 ++++++++++++++-----
>  2 files changed, 18 insertions(+), 9 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
