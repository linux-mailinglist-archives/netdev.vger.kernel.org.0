Return-Path: <netdev+bounces-12108-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8DE57362BF
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 06:48:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C16481C20B09
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 04:48:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EA7815AD;
	Tue, 20 Jun 2023 04:48:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A241380
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 04:48:12 +0000 (UTC)
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D8210E4;
	Mon, 19 Jun 2023 21:48:09 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1qBTHE-004xjz-Qx; Tue, 20 Jun 2023 12:47:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 20 Jun 2023 12:47:36 +0800
Date: Tue, 20 Jun 2023 12:47:36 +0800
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
Message-ID: <ZJEvaGyiRj509XY8@gondor.apana.org.au>
References: <ZIw8y2w+A+t5u+IJ@gondor.apana.org.au>
 <ZIw4+Go7ZIth+CsY@gondor.apana.org.au>
 <1679829.1686785273@warthog.procyon.org.uk>
 <426353.1686911878@warthog.procyon.org.uk>
 <1132301.1687193246@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1132301.1687193246@warthog.procyon.org.uk>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
	PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023 at 05:47:26PM +0100, David Howells wrote:
>
> The free here:
> 
> 	if (!continuing) {
> 		if ((msg->msg_flags & MSG_MORE))
> 			hash_free_result(sk, ctx);
> 
> only happens in the following case:
> 
> 	send(hashfd, "", 0, 0);
> 	send(hashfd, "", 0, MSG_MORE);  <--- by this

Yes and that's what I'm complaining about.

> and the patch changes how this case works if no data is given.  In Linus's
> tree, it will create a result, init the crypto and finalise it in
> hash_sendmsg(); with this patch that case is then handled by hash_recvmsg().
> If you consider the following sequence:
> 
> 	send(hashfd, "", 0, 0);
> 	send(hashfd, "", 0, 0);
> 	send(hashfd, "", 0, 0);
> 	send(hashfd, "", 0, 0);
> 
> Upstream, the first one will create a result and then each of them will init
> and finalise a hash, whereas with my patch, the first one will release any
> outstanding result and then none of them will do any crypto ops.

This is correct.  If MSG_MORE is not set, then the hash will be
finalised.  In which case if there is already a result allocated
then we should reuse it and not free it.

If MSG_MORE is set, then we can delay the allocation of the result,
in which case it makes sense to free any previous results since
the next request may not come for a very long time (or perhaps even
never).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

