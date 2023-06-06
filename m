Return-Path: <netdev+bounces-8336-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C54CC723C13
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:44:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75864281575
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 08:44:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F34C5111B9;
	Tue,  6 Jun 2023 08:44:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E325697
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:44:29 +0000 (UTC)
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4FCE8;
	Tue,  6 Jun 2023 01:44:27 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1q6SIH-00HGuE-0X; Tue, 06 Jun 2023 16:43:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 06 Jun 2023 16:43:57 +0800
Date: Tue, 6 Jun 2023 16:43:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-crypto@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 10/10] crypto: af_alg/hash: Support
 MSG_SPLICE_PAGES
Message-ID: <ZH7xzYfwQoWZLUYa@gondor.apana.org.au>
References: <20230530141635.136968-1-dhowells@redhat.com>
 <20230530141635.136968-11-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530141635.136968-11-dhowells@redhat.com>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
	PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 03:16:34PM +0100, David Howells wrote:
>
> -	if (limit > sk->sk_sndbuf)
> -		limit = sk->sk_sndbuf;
> +	/* Don't limit to ALG_MAX_PAGES if the pages are all already pinned. */
> +	if (!user_backed_iter(&msg->msg_iter))
> +		max_pages = INT_MAX;
> +	else
> +		max_pages = min_t(size_t, max_pages,
> +				  DIV_ROUND_UP(sk->sk_sndbuf, PAGE_SIZE));

What's the purpose of relaxing this limit? Even if there is a reason
for this shouldn't this be in a patch by itself?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

