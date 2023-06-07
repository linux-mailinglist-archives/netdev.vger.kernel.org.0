Return-Path: <netdev+bounces-8742-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A7EB47257FB
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:39:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13B9B1C20D78
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:38:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2CF45683;
	Wed,  7 Jun 2023 08:38:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A603A5664
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:38:59 +0000 (UTC)
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E841706
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 01:38:53 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1q6ogp-000749-Kx; Wed, 07 Jun 2023 16:38:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 07 Jun 2023 16:38:47 +0800
Date: Wed, 7 Jun 2023 16:38:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: netdev@vger.kernel.org, David George <David.George@sophos.com>,
	Markus Trapp <markus.trapp@secunet.com>
Subject: [PATCH] xfrm: Use xfrm_state selector for BEET input
Message-ID: <ZIBCFyszqwJlZd/V@gondor.apana.org.au>
References: <ZAr3rc+QvKs50xkm@gondor.apana.org.au>
 <ZH8OSd1ElPIKCFa+@gauss3.secunet.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZH8OSd1ElPIKCFa+@gauss3.secunet.de>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
	PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 12:45:29PM +0200, Steffen Klassert wrote:
>
> the assumption that the L4 protocol on BEET mode can be
> just IPIP or BEETPH seems not to be correct. One of
> our testcaces hit the second WARN_ON_ONCE() in
> xfrm_prepare_input. In that case the L4 protocol
> is UDP. Looks like we need some other way to
> dertermine the inner protocol family.

Oops, that was a thinko on my part:

---8<---
For BEET the inner address and therefore family is stored in the
xfrm_state selector.  Use that when decapsulating an input packet
instead of incorrectly relying on a non-existent tunnel protocol.

Fixes: 5f24f41e8ea6 ("xfrm: Remove inner/outer modes from input path")
Reported-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 39fb91ff23d9..bdaed1d1ff97 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -330,11 +330,10 @@ xfrm_inner_mode_encap_remove(struct xfrm_state *x,
 {
 	switch (x->props.mode) {
 	case XFRM_MODE_BEET:
-		switch (XFRM_MODE_SKB_CB(skb)->protocol) {
-		case IPPROTO_IPIP:
-		case IPPROTO_BEETPH:
+		switch (x->sel.family) {
+		case AF_INET:
 			return xfrm4_remove_beet_encap(x, skb);
-		case IPPROTO_IPV6:
+		case AF_INET6:
 			return xfrm6_remove_beet_encap(x, skb);
 		}
 		break;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

