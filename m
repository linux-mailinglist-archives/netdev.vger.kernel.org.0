Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E761B6EDB38
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 07:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbjDYFfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 01:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232303AbjDYFfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 01:35:07 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E5C5FF3
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 22:35:03 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1prBK7-001znK-7b; Tue, 25 Apr 2023 13:34:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 25 Apr 2023 13:34:44 +0800
Date:   Tue, 25 Apr 2023 13:34:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tobias Brunner <tobias@strongswan.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH ipsec] xfrm: Ensure consistent address families when
 resolving templates
Message-ID: <ZEdmdDAwnuslrdvA@gondor.apana.org.au>
References: <6dcb6a58-2699-9cde-3e34-57c142dbcf14@strongswan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6dcb6a58-2699-9cde-3e34-57c142dbcf14@strongswan.org>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 03:23:02PM +0200, Tobias Brunner wrote:
> xfrm_state_find() uses `encap_family` of the current template with
> the passed local and remote addresses to find a matching state.
> This check makes sure that there is no mismatch and out-of-bounds
> read in mixed-family scenarios where optional tunnel or BEET mode
> templates were skipped that would have changed the addresses to
> match the current template's family.
> 
> This basically enforces the same check as validate_tmpl(), just at
> runtime when one or more optional templates might have been skipped.
> 
> Signed-off-by: Tobias Brunner <tobias@strongswan.org>
> ---
>  net/xfrm/xfrm_policy.c | 5 +++++
>  1 file changed, 5 insertions(+)

I'm confused.  By skipping, you're presumably referring to IPcomp.

For IPcomp, skipping should only occur on inbound, but your patch
is changing a code path that's only invoked for outbound.  What's
going on?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
