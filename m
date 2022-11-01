Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E946143EE
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 05:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiKAEkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 00:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKAEkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 00:40:13 -0400
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0A8165B6
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 21:40:11 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1opj3Q-008gPV-Gy; Tue, 01 Nov 2022 12:39:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 01 Nov 2022 12:39:48 +0800
Date:   Tue, 1 Nov 2022 12:39:48 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Antony Antony <antony.antony@secunet.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Leon Romanovsky <leon@kernel.org>, Roth Mark <rothm@mail.com>,
        Zhihao Chen <chenzhihao@meizu.com>,
        Tobias Brunner <tobias@strongswan.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] xfrm: Fix oops in __xfrm_state_delete()
Message-ID: <Y2CjFGCHGaMMTrHu@gondor.apana.org.au>
References: <20221031152612.o3h44x3whath4iyp@intra2net.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031152612.o3h44x3whath4iyp@intra2net.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 04:26:12PM +0100, Thomas Jarosch wrote:
>
> diff --git a/net/key/af_key.c b/net/key/af_key.c
> index c85df5b958d2..65a9ede62d65 100644
> --- a/net/key/af_key.c
> +++ b/net/key/af_key.c
> @@ -3382,7 +3382,7 @@ static int pfkey_send_new_mapping(struct xfrm_state *x, xfrm_address_t *ipaddr,
>  	hdr->sadb_msg_len = size / sizeof(uint64_t);
>  	hdr->sadb_msg_errno = 0;
>  	hdr->sadb_msg_reserved = 0;
> -	hdr->sadb_msg_seq = x->km.seq = get_acqseq();
> +	hdr->sadb_msg_seq = get_acqseq();

This looks broken.  x->km.seq is part of the state which you are
changing.  Shouldn't you do whatever xfrm_user does in the same
situation?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
