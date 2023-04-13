Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 579866E041A
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 04:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjDMCcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 22:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjDMCcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 22:32:17 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2756583
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 19:32:13 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pmmkY-00FJvw-Cp; Thu, 13 Apr 2023 10:31:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 13 Apr 2023 10:31:50 +0800
Date:   Thu, 13 Apr 2023 10:31:50 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, alexander.duyck@gmail.com, hkallweit1@gmail.com,
        andrew@lunn.ch, willemb@google.com, michael.chan@broadcom.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v3 7/7] net: piggy back on the memory barrier in
 bql when waking queues
Message-ID: <ZDdplm8j626TvDC9@gondor.apana.org.au>
References: <20230405223134.94665-1-kuba@kernel.org>
 <20230405223134.94665-8-kuba@kernel.org>
 <ZC52VRfUOOObx2fw@gondor.apana.org.au>
 <20230406174140.36930b15@kernel.org>
 <ZDZKaoPaiy6Itj7P@gondor.apana.org.au>
 <20230412065408.59e02bb7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412065408.59e02bb7@kernel.org>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 06:54:08AM -0700, Jakub Kicinski wrote:
>
> I don't understand what you're trying to argue. The whole point of 
> the patch is to use the BQL barrier and BQL returns early, before 
> the barrier.

I'm saying that the smp_mb should be unconditional in all cases.
As it stands the only time when smp_mb will be skipped is when the
TX cleaner finds no work to do.  That's an extremely unlikely case
and there is no point in skipping the barrier just for that.

> I don't think many people actually build kernels with BQL=n so the other
> branch is more *documentation* than it is relevant, executed code.

No I'm not referring to BQL, I'm referring to bytes/pkts == 0.

Looking into the git history, the bytes == 0 check wasn't even
meant for the barrier as the barrier was added later.  So it
was simply there to make the BQL code function correctly.  All
we have to do is move the check around the BQL code and then
the smp_mb can be done unconditionally.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
