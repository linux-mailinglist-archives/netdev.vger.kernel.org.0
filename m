Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8143769A508
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 06:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjBQFYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 00:24:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBQFYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 00:24:36 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CBE5B74E
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 21:24:33 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pStEJ-00CIQX-Js; Fri, 17 Feb 2023 13:24:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Feb 2023 13:24:19 +0800
Date:   Fri, 17 Feb 2023 13:24:19 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Sri Sakthi <srisakthi.s@gmail.com>
Cc:     steffen.klassert@secunet.com, davem@davemloft.net,
        netdev@vger.kernel.org, srisakthi.subramaniam@sophos.com,
        david.george@sophos.com, Vimal.Agrawal@sophos.com
Subject: Re: xfrm: Pass on correct AF value to xfrm_state_find
Message-ID: <Y+8Pg5JzOBntLcWA@gondor.apana.org.au>
References: <CA+t5pP=6E4RvKiPdS4fm_Z2M2BLKPkd6jewtF0Y_Ci_w-oTb+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+t5pP=6E4RvKiPdS4fm_Z2M2BLKPkd6jewtF0Y_Ci_w-oTb+w@mail.gmail.com>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
        PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 04:01:21PM +0530, Sri Sakthi wrote:
> 
> IP compression enabled flow uses 2 xfrms, a tunnel mode SA followed by a
> transport mode SA like the sample ip x p pasted below,
> 
> src 10.171.96.0/20 dst 10.171.80.0/20
> 
> dir out priority 379519
> 
> tmpl src 2b01:7660:6:c::aab:1c7 dst 2b01:7660:6:c::aab:30
> 
> proto comp reqid 4 mode tunnel
> 
> tmpl src :: dst ::
  ^^^^^^^^^^^^^^^^^^ should be IPv4
> 
> proto esp reqid 4 mode transport

This looks like a configuration error to me.  You are first
compressing the packet, which occurs in tunnel mode, and that's
the point where your IPv4 packet becomes IPv6.  So everything
beyond this should be IPv6.

You then apply ESP to the IPv6 packet.  So the ESP SA/policy
should be v6/v6.

However, the policy selector for the ESP transform should still
be IPv4.  This is because the policy selector on a nested policy
is matched against the inner-most flow, and not one level below
(don't ask me why, it was this way before I got here :)

In your case your ESP policy selector says that it has to be IPv6,
while the inner-most flow is IPv4.  That's why it doesn't work.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
