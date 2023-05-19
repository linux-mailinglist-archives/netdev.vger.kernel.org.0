Return-Path: <netdev+bounces-3860-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 095107093A4
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:38:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7926A1C2125C
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 09:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 980716108;
	Fri, 19 May 2023 09:38:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0155675
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 09:38:05 +0000 (UTC)
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E135F210D;
	Fri, 19 May 2023 02:37:34 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1pzwWa-00ApJo-MZ; Fri, 19 May 2023 17:35:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 May 2023 17:35:48 +0800
Date: Fri, 19 May 2023 17:35:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Dmitry Safonov <dima@arista.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Andy Lutomirski <luto@amacapital.net>,
	Bob Gilligan <gilligan@arista.com>,
	Dan Carpenter <error27@gmail.com>,
	David Laight <David.Laight@aculab.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Francesco Ruggeri <fruggeri05@gmail.com>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Ivan Delalande <colona@arista.com>,
	Leonard Crestez <cdleonard@gmail.com>,
	Salam Noureddine <noureddine@arista.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] crypto: shash - Allow cloning on algorithms with no
 init_tfm
Message-ID: <ZGdC9MDomBGRpccP@gondor.apana.org.au>
References: <ZGcyuyjJwZhdYS/G@gondor.apana.org.au>
 <E1pzvTZ-00AnMQ-5M@formenos.hmeau.com>
 <CAMj1kXGwS03zUBTGb7jmk1-6r+=a-HH+A-S9ZFTYRyJSzN0Xcg@mail.gmail.com>
 <ZGc7hCaDrnEFG8Lr@gondor.apana.org.au>
 <CAMj1kXEkz1QvkXWc8dCGhU_MPf+1M3P2+rAiLciuixnKCmRESg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXEkz1QvkXWc8dCGhU_MPf+1M3P2+rAiLciuixnKCmRESg@mail.gmail.com>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
	RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 11:31:30AM +0200, Ard Biesheuvel wrote:
>
> OK. So IIUC, cloning a keyless hash just shares the TFM and bumps the
> refcount, but here we must actually allocate a new TFM referring to
> the same algo, and this new TFM needs its key to be set before use, as
> it doesn't inherit it from the clonee, right? And this works in the
> same way as cloning an instance of the generic HMAC template, as this
> will just clone the inner shash too, and will also leave the key
> unset.

Yes that's pretty much it.  Cloning a tfm is basically exactly
the same as allocating a tfm, except that instead of going through
the init_tfm code-path it executes clone_tfm instead (thus allowing
any internal data structures to either be shared or allocated with
GFP_ATOMIC).

The key will be unset just like a freshly allocated tfm.

> If so,
> 
> Acked-by: Ard Biesheuvel <ardb@kernel.org>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

