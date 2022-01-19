Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFC149352E
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 07:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351231AbiASG6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 01:58:54 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:59680 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345647AbiASG6x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jan 2022 01:58:53 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nA4vY-0008Th-0i; Wed, 19 Jan 2022 17:58:41 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 19 Jan 2022 17:58:40 +1100
Date:   Wed, 19 Jan 2022 17:58:40 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: authenc - Fix sleep in atomic context in decrypt_tail
Message-ID: <Yee2oKxPSLaYY31N@gondor.apana.org.au>
References: <Yd1SIHUNdLIvKhzz@Red>
 <YeD4rt1OVnEMBr+A@gondor.apana.org.au>
 <YeD6vt47+pAl0SxG@gondor.apana.org.au>
 <YeEiWmkyNwfgQgmn@Red>
 <YeZx1aVL0HnT9tCB@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeZx1aVL0HnT9tCB@Red>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 08:52:53AM +0100, Corentin Labbe wrote:
>
> With my patch, I got:
> [   38.515668] BUG: sleeping function called from invalid context at crypto/skcipher.c:482
> [   38.523708] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 84, name: 1c15000.crypto-
> [   38.532176] preempt_count: 200, expected: 0
> [   38.536381] CPU: 6 PID: 84 Comm: 1c15000.crypto- Not tainted 5.16.0-next-20220115-00124-g13473e8fac33-dirty #116
> [   38.546551] Hardware name: Allwinner A83t board
> [   38.551100]  unwind_backtrace from show_stack+0x10/0x14
> [   38.556358]  show_stack from dump_stack_lvl+0x40/0x4c
> [   38.561428]  dump_stack_lvl from __might_resched+0x118/0x154
> [   38.567107]  __might_resched from skcipher_walk_virt+0xe8/0xec
> [   38.572955]  skcipher_walk_virt from crypto_cbc_decrypt+0x2c/0x170
> [   38.579147]  crypto_cbc_decrypt from crypto_skcipher_decrypt+0x38/0x5c
> [   38.585680]  crypto_skcipher_decrypt from authenc_verify_ahash_done+0x18/0x34
> [   38.592825]  authenc_verify_ahash_done from crypto_finalize_request+0x6c/0xe4
> [   38.599974]  crypto_finalize_request from sun8i_ss_hash_run+0x73c/0xb98
> [   38.606602]  sun8i_ss_hash_run from crypto_pump_work+0x1a8/0x330
> [   38.612616]  crypto_pump_work from kthread_worker_fn+0xa8/0x1c4
> [   38.618550]  kthread_worker_fn from kthread+0xf0/0x110
> [   38.623701]  kthread from ret_from_fork+0x14/0x2c
> [   38.628414] Exception stack(0xc2247fb0 to 0xc2247ff8)
> [   38.633468] 7fa0:                                     00000000 00000000 00000000 00000000
> [   38.641640] 7fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [   38.649809] 7fe0:i 00000000 00000000 00000000 00000000 00000013 00000000
> 
> This is when testing hmac(sha1) on my crypto driver sun8i-ss and crypto testing authenc(hmac-sha1-sun8i-ss,cbc(aes-generic)).
> 
> Do you have any idea to better fix my issue ?

This backtrace is caused by a bug in authenc:

---8<---
The function crypto_authenc_decrypt_tail discards its flags
argument and always relies on the flags from the original request
when starting its sub-request.

This is clearly wrong as it may cause the SLEEPABLE flag to be
set when it shouldn't.

Fixes: 92d95ba91772 ("crypto: authenc - Convert to new AEAD interface")
Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 670bf1a01d00..17f674a7cdff 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -253,7 +253,7 @@ static int crypto_authenc_decrypt_tail(struct aead_request *req,
 		dst = scatterwalk_ffwd(areq_ctx->dst, req->dst, req->assoclen);
 
 	skcipher_request_set_tfm(skreq, ctx->enc);
-	skcipher_request_set_callback(skreq, aead_request_flags(req),
+	skcipher_request_set_callback(skreq, flags,
 				      req->base.complete, req->base.data);
 	skcipher_request_set_crypt(skreq, src, dst,
 				   req->cryptlen - authsize, req->iv);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
