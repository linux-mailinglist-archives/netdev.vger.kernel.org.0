Return-Path: <netdev+bounces-11391-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D178732DF9
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:28:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE494281719
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:28:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DF6918B1D;
	Fri, 16 Jun 2023 10:28:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7376F18B0A
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:28:41 +0000 (UTC)
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1888059C1;
	Fri, 16 Jun 2023 03:28:19 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1qA6fY-003lEH-TO; Fri, 16 Jun 2023 18:27:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 Jun 2023 18:27:04 +0800
Date: Fri, 16 Jun 2023 18:27:04 +0800
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
Subject: Re: [PATCH net-next] crypto: af_alg/hash: Fix recvmsg() after
 sendmsg(MSG_MORE)
Message-ID: <ZIw4+Go7ZIth+CsY@gondor.apana.org.au>
References: <1679829.1686785273@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1679829.1686785273@warthog.procyon.org.uk>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
	PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 12:27:53AM +0100, David Howells wrote:
>     
> If an AF_ALG socket bound to a hashing algorithm is sent a zero-length
> message with MSG_MORE set and then recvmsg() is called without first
> sending another message without MSG_MORE set to end the operation, an oops
> will occur because the crypto context and result doesn't now get set up in
> advance because hash_sendmsg() now defers that as long as possible in the
> hope that it can use crypto_ahash_digest() - and then because the message
> is zero-length, it the data wrangling loop is skipped.
> 
> Fix this by always making a pass of the loop, even in the case that no data
> is provided to the sendmsg().
> 
> Fix also extract_iter_to_sg() to handle a zero-length iterator by returning
> 0 immediately.
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
> Tested-by: syzbot+13a08c0bf4d212766c3c@syzkaller.appspotmail.com
> Tested-by: syzbot+14234ccf6d0ef629ec1a@syzkaller.appspotmail.com
> Tested-by: syzbot+4e2e47f32607d0f72d43@syzkaller.appspotmail.com
> Tested-by: syzbot+472626bb5e7c59fb768f@syzkaller.appspotmail.com
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
>  crypto/algif_hash.c |   21 +++++----------------
>  lib/scatterlist.c   |    2 +-
>  2 files changed, 6 insertions(+), 17 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

