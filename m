Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A191C5709AC
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 20:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbiGKSEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 14:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbiGKSEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 14:04:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE9B1EADF;
        Mon, 11 Jul 2022 11:04:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19F96B80E4A;
        Mon, 11 Jul 2022 18:03:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A79CC341C8;
        Mon, 11 Jul 2022 18:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657562637;
        bh=mCBd8b09ydPs61XWBzNZW3Jvis9MI3ZBw0K33RhQuQc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bPHJ6HpySPrM18KQCSn1D2BSyAWr1t8nXDVWvcVJeMqTUhh2A4ji8ah3hE/BbuFNJ
         5EiJ/oYRDSYqkDgdBs/GBIRgf6ukxQjAF/Zd3zvzpkXj+mJ2a5qg4k+sBur4rgcFgD
         5iyur9y6k1itXK6qdtWdr9onEG+9ZJXd9hb55VWDu54Xz/U+ImoPDKAqRfNq45khQk
         Qugx1B33faTd3h0e1ILPv+fX64KbhWJHQkq7Jvw+DOGGsZu9N9dtnVvJRyUf8GnuFV
         wmoS7LJ4hnCbMJe3zfDR6DFAE1Upr/ahAz8Zzwa6x6NsnvaPqfv7/k9Do0KrdPOPay
         AtkMxtKCKoieQ==
Date:   Mon, 11 Jul 2022 11:03:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "Jason A . Donenfeld " <Jason@zx2c4.com>,
        bpf@vger.kernel.org
Subject: Re: [PATCH 2/2] crypto: make the sha1 library optional
Message-ID: <20220711110348.4c951fff@kernel.org>
In-Reply-To: <20220709211849.210850-3-ebiggers@kernel.org>
References: <20220709211849.210850-1-ebiggers@kernel.org>
        <20220709211849.210850-3-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  9 Jul 2022 14:18:49 -0700 Eric Biggers wrote:
> Since the Linux RNG no longer uses sha1_transform(), the SHA-1 library
> is no longer needed unconditionally.  Make it possible to build the
> Linux kernel without the SHA-1 library by putting it behind a kconfig
> option, and selecting this new option from the kconfig options that gate
> the remaining users: CRYPTO_SHA1 for crypto/sha1_generic.c, BPF for
> kernel/bpf/core.c, and IPV6 for net/ipv6/addrconf.c.
> 
> Unfortunately, since BPF is selected by NET, for now this can only make
> a difference for kernels built without networking support.

> diff --git a/init/Kconfig b/init/Kconfig
> index c984afc489dead..d8d0b4bdfe4195 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1472,6 +1472,7 @@ config HAVE_PCSPKR_PLATFORM
>  # interpreter that classic socket filters depend on
>  config BPF
>  	bool
> +	select CRYPTO_LIB_SHA1
>  

Let's give it an explicit CC: bpf@

> diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
> index bf2e5e5fe14273..658bfed1df8b17 100644
> --- a/net/ipv6/Kconfig
> +++ b/net/ipv6/Kconfig
> @@ -7,6 +7,7 @@
>  menuconfig IPV6
>  	tristate "The IPv6 protocol"
>  	default y
> +	select CRYPTO_LIB_SHA1
>  	help
>  	  Support for IP version 6 (IPv6).

FWIW:
Acked-by: Jakub Kicinski <kuba@kernel.org>
