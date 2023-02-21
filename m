Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1782569DA82
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 06:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbjBUFyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 00:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjBUFyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 00:54:16 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C20FF20
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 21:54:13 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pULbE-00DnSg-AD; Tue, 21 Feb 2023 13:54:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 21 Feb 2023 13:54:00 +0800
Date:   Tue, 21 Feb 2023 13:54:00 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David George <David.George@sophos.com>
Cc:     Sri Sakthi <srisakthi.s@gmail.com>,
        "steffen.klassert@secunet.com" <steffen.klassert@secunet.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Srisakthi Subramaniam <Srisakthi.Subramaniam@sophos.com>,
        Vimal Agrawal <Vimal.Agrawal@sophos.com>
Subject: [PATCH] xfrm: Allow transport-mode states with AF_UNSPEC selector
Message-ID: <Y/RceGnV2JLvRmXC@gondor.apana.org.au>
References: <CA+t5pP=6E4RvKiPdS4fm_Z2M2BLKPkd6jewtF0Y_Ci_w-oTb+w@mail.gmail.com>
 <Y+8Pg5JzOBntLcWA@gondor.apana.org.au>
 <CA+t5pP=NRQUax5ogB32dZN74Mk2qq_ZY7OgNro8JmckVkQsQyw@mail.gmail.com>
 <Y+861os+ZbBWVvvi@gondor.apana.org.au>
 <LO0P265MB604061D3617058B2B07D534CE0A49@LO0P265MB6040.GBRP265.PROD.OUTLOOK.COM>
 <Y/RDBnFoROo5+xcm@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/RDBnFoROo5+xcm@gondor.apana.org.au>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
        PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 12:05:26PM +0800, Herbert Xu wrote:
> 
> OK I wasn't aware of this.  This definitely looks buggy.  We need
> to fix this bogus check.

It looks like I actually added this bogus check :)

Does this patch work for you?

---8<---
xfrm state selectors are matched against the inner-most flow
which can be of any address family.  Therefore middle states
in nested configurations need to carry a wildcard selector in
order to work at all.

However, this is currently forbidden for transport-mode states.

Fix this by removing the unnecessary check.

Fixes: 13996378e658 ("[IPSEC]: Rename mode to outer_mode and add inner_mode")
Reported-by: David George <David.George@sophos.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 89c731f4f0c7..6f53841cd162 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2815,11 +2815,6 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload,
 			goto error;
 		}
 
-		if (!(inner_mode->flags & XFRM_MODE_FLAG_TUNNEL)) {
-			NL_SET_ERR_MSG(extack, "Only tunnel modes can accommodate an AF_UNSPEC selector");
-			goto error;
-		}
-
 		x->inner_mode = *inner_mode;
 
 		if (x->props.family == AF_INET)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
