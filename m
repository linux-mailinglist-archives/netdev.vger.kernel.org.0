Return-Path: <netdev+bounces-12109-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEDBC7362D1
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 06:51:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45D04280F1E
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 04:51:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FF0915AD;
	Tue, 20 Jun 2023 04:51:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BBA1380
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 04:51:32 +0000 (UTC)
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413EF10D2;
	Mon, 19 Jun 2023 21:51:30 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1qBTKe-004xnx-6L; Tue, 20 Jun 2023 12:51:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 20 Jun 2023 12:51:08 +0800
Date: Tue, 20 Jun 2023 12:51:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org,
	syzbot+13a08c0bf4d212766c3c@syzkaller.appspotmail.com,
	syzbot+14234ccf6d0ef629ec1a@syzkaller.appspotmail.com,
	syzbot+4e2e47f32607d0f72d43@syzkaller.appspotmail.com,
	syzbot+472626bb5e7c59fb768f@syzkaller.appspotmail.com,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] crypto: af_alg/hash: Fix recvmsg() after
 sendmsg(MSG_MORE)
Message-ID: <ZJEwPLudZlrInzYs@gondor.apana.org.au>
References: <427646.1686913832@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <427646.1686913832@warthog.procyon.org.uk>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
	PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 12:10:32PM +0100, David Howells wrote:
> If an AF_ALG socket bound to a hashing algorithm is sent a zero-length
> message with MSG_MORE set and then recvmsg() is called without first
> sending another message without MSG_MORE set to end the operation, an oops
> will occur because the crypto context and result doesn't now get set up in
> advance because hash_sendmsg() now defers that as long as possible in the
> hope that it can use crypto_ahash_digest() - and then because the message
> is zero-length, it the data wrangling loop is skipped.
> 
> Fix this by handling zero-length sends at the top of the hash_sendmsg()
> function.  If we're not continuing the previous sendmsg(), then just ignore
> the send (hash_recvmsg() will invent something when called); if we are
> continuing, then we finalise the request at this point if MSG_MORE is not
> set to get any error here, otherwise the send is of no effect and can be
> ignored.
> 
> Whilst we're at it, remove the code to create a kvmalloc'd scatterlist if
> we get more than ALG_MAX_PAGES - this shouldn't happen.
> 
> Fixes: c662b043cdca ("crypto: af_alg/hash: Support MSG_SPLICE_PAGES")
> Reported-by: syzbot+13a08c0bf4d212766c3c@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/r/000000000000b928f705fdeb873a@google.com/
> Reported-by: syzbot+14234ccf6d0ef629ec1a@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/r/000000000000c047db05fdeb8790@google.com/
> Reported-by: syzbot+4e2e47f32607d0f72d43@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/r/000000000000bcca3205fdeb87fb@google.com/
> Reported-by: syzbot+472626bb5e7c59fb768f@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/r/000000000000b55d8805fdeb8385@google.com/
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reported-and-tested-by: syzbot+6efc50cc1f8d718d6cb7@syzkaller.appspotmail.com
> cc: Herbert Xu <herbert@gondor.apana.org.au>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: linux-crypto@vger.kernel.org
> cc: netdev@vger.kernel.org
> ---
>  crypto/algif_hash.c |   38 +++++++++++++++++++++++++-------------
>  1 file changed, 25 insertions(+), 13 deletions(-)
> 
> diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
> index dfb048cefb60..0ab43e149f0e 100644
> --- a/crypto/algif_hash.c
> +++ b/crypto/algif_hash.c
> @@ -76,13 +76,30 @@ static int hash_sendmsg(struct socket *sock, struct msghdr *msg,
>  
>  	lock_sock(sk);
>  	if (!continuing) {
> -		if ((msg->msg_flags & MSG_MORE))
> -			hash_free_result(sk, ctx);
> +		/* Discard a previous request that wasn't marked MSG_MORE. */
> +		hash_free_result(sk, ctx);

Please revert this change as I explained in the other message.

> +		if (!msg_data_left(msg))
> +			goto done; /* Zero-length; don't start new req */

This is still broken in the case of a zero-length message with
MSG_MORE set.  Here you will short-circuit out without ever calling
crypto_ahash_init.  However, hash_recvmsg will directly call
crypto_ahash_final on this, which is undefined.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

