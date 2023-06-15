Return-Path: <netdev+bounces-11038-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6E387313B9
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 11:28:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A03F51C20E5B
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 09:28:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A16DC5690;
	Thu, 15 Jun 2023 09:28:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958FE53BA
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 09:28:28 +0000 (UTC)
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352311BD2;
	Thu, 15 Jun 2023 02:28:26 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1q9jGq-003GV3-LL; Thu, 15 Jun 2023 17:28:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Jun 2023 17:28:00 +0800
Date: Thu, 15 Jun 2023 17:28:00 +0800
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
Message-ID: <ZIrZoKSFTibdKa95@gondor.apana.org.au>
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
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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

I don't think this is right.  If it's a zero-length message with
MSG_MORE set, it should be ignored until a recvmsg(2) call is made.

In any case, this patch doesn't fix all the syzbot reports.

We need to think about reverting this change if it can't be fixed
in time.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

