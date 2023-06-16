Return-Path: <netdev+bounces-11399-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C6B16732F1D
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:52:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82164280CBE
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:52:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03600D313;
	Fri, 16 Jun 2023 10:51:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBCD79D4
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:51:50 +0000 (UTC)
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E855786AA;
	Fri, 16 Jun 2023 03:51:47 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1qA6gR-003lHK-Cz; Fri, 16 Jun 2023 18:28:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 Jun 2023 18:27:59 +0800
Date: Fri, 16 Jun 2023 18:27:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org,
	syzbot+6efc50cc1f8d718d6cb7@syzkaller.appspotmail.com,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] crypto: Fix af_alg_sendmsg(MSG_SPLICE_PAGES)
 sglist limit
Message-ID: <ZIw5L081E2GjdLrQ@gondor.apana.org.au>
References: <322883.1686863334@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <322883.1686863334@warthog.procyon.org.uk>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
	PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 10:08:54PM +0100, David Howells wrote:
> When af_alg_sendmsg() calls extract_iter_to_sg(), it passes MAX_SGL_ENTS as
> the maximum number of elements that may be written to, but some of the
> elements may already have been used (as recorded in sgl->cur), so
> extract_iter_to_sg() may end up overrunning the scatterlist.
> 
> Fix this to limit the number of elements to "MAX_SGL_ENTS - sgl->cur".
> 
> Note: It probably makes sense in future to alter the behaviour of
> extract_iter_to_sg() to stop if "sgtable->nents >= sg_max" instead, but
> this is a smaller fix for now.
> 
> The bug causes errors looking something like:
> 
> BUG: KASAN: slab-out-of-bounds in sg_assign_page include/linux/scatterlist.h:109 [inline]
> BUG: KASAN: slab-out-of-bounds in sg_set_page include/linux/scatterlist.h:139 [inline]
> BUG: KASAN: slab-out-of-bounds in extract_bvec_to_sg lib/scatterlist.c:1183 [inline]
> BUG: KASAN: slab-out-of-bounds in extract_iter_to_sg lib/scatterlist.c:1352 [inline]
> BUG: KASAN: slab-out-of-bounds in extract_iter_to_sg+0x17a6/0x1960 lib/scatterlist.c:1339
> 
> Fixes: bf63e250c4b1 ("crypto: af_alg: Support MSG_SPLICE_PAGES")
> Reported-by: syzbot+6efc50cc1f8d718d6cb7@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/r/000000000000b2585a05fdeb8379@google.com/
> Signed-off-by: David Howells <dhowells@redhat.com>
> Tested-by: syzbot+6efc50cc1f8d718d6cb7@syzkaller.appspotmail.com
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
>  crypto/af_alg.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

