Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501F8615CB8
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 08:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiKBHIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 03:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbiKBHId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 03:08:33 -0400
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB372205C0
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 00:08:23 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oq7qL-00976U-Gq; Wed, 02 Nov 2022 15:07:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 02 Nov 2022 15:07:57 +0800
Date:   Wed, 2 Nov 2022 15:07:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Antony Antony <antony.antony@secunet.com>
Cc:     Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Leon Romanovsky <leon@kernel.org>, Roth Mark <rothm@mail.com>,
        Zhihao Chen <chenzhihao@meizu.com>,
        Tobias Brunner <tobias@strongswan.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] xfrm: Fix oops in __xfrm_state_delete()
Message-ID: <Y2IXTc1M6K7KaQwW@gondor.apana.org.au>
References: <20221031152612.o3h44x3whath4iyp@intra2net.com>
 <Y2CjFGCHGaMMTrHu@gondor.apana.org.au>
 <Y2FvHZiWejxRiIS8@moon.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2FvHZiWejxRiIS8@moon.secunet.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 08:10:21PM +0100, Antony Antony wrote:
>
> xfrm_user sets msg_seq to zero in mapping change message. seq is only useful for

Oh I had misread the patch and thought this was send_acquire.

> acquire message. I think setting to zero would be a better fix.
> 
> -	hdr->sadb_msg_seq = x->km.seq = get_acqseq();
> +	hdr->sadb_msg_seq = 0;
> 
> While increasing x->km.seq in every call to pfkey_send_new_mapping()
> could be an issue, would it alone explan the crash?

Probably, if you change the state without moving it to the right
hash slot then the xfrm state hash table will be inconsistent.

We should copy the xfrm_user behaviour which is to leave x->km.seq
alone.  So the patch should change the above line to

	hdr->sadb_msg_seq = x->km.seq;

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
