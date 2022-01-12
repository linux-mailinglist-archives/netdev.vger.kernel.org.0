Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5F248CB09
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356274AbiALScm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356295AbiALScJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:32:09 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927C2C061759;
        Wed, 12 Jan 2022 10:32:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8C12CCE1E21;
        Wed, 12 Jan 2022 18:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC72AC36AE5;
        Wed, 12 Jan 2022 18:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642012319;
        bh=SIOFpKrKnQowDOnmtxefi+bybl5zeZB6n3VbvATVFBY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V4aeHa5QLi8d5BOg6sv0gr+x+PgLEzDphY5W9nRxsHjh6z4a/6EMHng9D75BAM6Ct
         zNP0R2wv/Frb46fN9k47C2rGg5Z4eRDU45dl2liVB9tycOqrsJLcjnR1ET4JSX14sV
         ANVlYcpU4KpPTW8Ymr0tMG7NqGErK0wEyelLvM92Qj10ktOFFrm8RAOAbdIoplI3mk
         5SdR7b+RMwmWXQwkKn7vvl7Qib4xy9W29MrbwtCBeWkkLk+v/Vn32DaMTggmUi7aAw
         1B5awF8+2fvKHU7F8hodfx9vInNNVpOFRAyWQMfoK0NaB6tdknpS3MpGI4/vknMPsV
         aIgS2bSCn6J+Q==
Date:   Wed, 12 Jan 2022 10:31:57 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        wireguard@lists.zx2c4.com, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, geert@linux-m68k.org, tytso@mit.edu,
        gregkh@linuxfoundation.org, jeanphilippe.aumasson@gmail.com,
        ardb@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH crypto 1/2] lib/crypto: blake2s-generic: reduce code size
 on small systems
Message-ID: <Yd8enQTocuCSQVkT@gmail.com>
References: <CAHmME9qbnYmhvsuarButi6s=58=FPiti0Z-QnGMJ=OsMzy1eOg@mail.gmail.com>
 <20220111134934.324663-1-Jason@zx2c4.com>
 <20220111134934.324663-2-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111134934.324663-2-Jason@zx2c4.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 02:49:33PM +0100, Jason A. Donenfeld wrote:
> Re-wind the loops entirely on kernels optimized for code size. This is
> really not good at all performance-wise. But on m68k, it shaves off 4k
> of code size, which is apparently important.
> 
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  lib/crypto/blake2s-generic.c | 30 ++++++++++++++++++------------
>  1 file changed, 18 insertions(+), 12 deletions(-)
> 
> diff --git a/lib/crypto/blake2s-generic.c b/lib/crypto/blake2s-generic.c
> index 75ccb3e633e6..990f000e22ee 100644
> --- a/lib/crypto/blake2s-generic.c
> +++ b/lib/crypto/blake2s-generic.c
> @@ -46,7 +46,7 @@ void blake2s_compress_generic(struct blake2s_state *state, const u8 *block,
>  {
>  	u32 m[16];
>  	u32 v[16];
> -	int i;
> +	int i, j;
>  
>  	WARN_ON(IS_ENABLED(DEBUG) &&
>  		(nblocks > 1 && inc != BLAKE2S_BLOCK_SIZE));
> @@ -86,17 +86,23 @@ void blake2s_compress_generic(struct blake2s_state *state, const u8 *block,
>  	G(r, 6, v[2], v[ 7], v[ 8], v[13]); \
>  	G(r, 7, v[3], v[ 4], v[ 9], v[14]); \
>  } while (0)
> -		ROUND(0);
> -		ROUND(1);
> -		ROUND(2);
> -		ROUND(3);
> -		ROUND(4);
> -		ROUND(5);
> -		ROUND(6);
> -		ROUND(7);
> -		ROUND(8);
> -		ROUND(9);
> -
> +		if (IS_ENABLED(CONFIG_CC_OPTIMIZE_FOR_SIZE)) {
> +			for (i = 0; i < 10; ++i) {
> +				for (j = 0; j < 8; ++j)
> +					G(i, j, v[j % 4], v[((j + (j / 4)) % 4) + 4], v[((j + 2 * (j / 4)) % 4) + 8], v[((j + 3 * (j / 4)) % 4) + 12]);
> +			}

How about unrolling the inner loop but not the outer one?  Wouldn't that give
most of the benefit, without hurting performance as much?

If you stay with this approach and don't unroll either loop, can you use 'r' and
'i' instead of 'i' and 'j', to match the naming in G()?

Also, please wrap lines at 80 columns.

- Eric
