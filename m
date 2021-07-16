Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243023CB3EB
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 10:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237527AbhGPIS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 04:18:56 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51406 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237415AbhGPISv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 04:18:51 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1m4J0O-0005fg-8y; Fri, 16 Jul 2021 16:15:32 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1m4J09-0000YN-HC; Fri, 16 Jul 2021 16:15:17 +0800
Date:   Fri, 16 Jul 2021 16:15:17 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andres Salomon <dilinger@queued.net>,
        linux-geode@lists.infradead.org, Matt Mackall <mpm@selenic.com>,
        linux-crypto@vger.kernel.org,
        Christian Gromm <christian.gromm@microchip.com>,
        Krzysztof Halasa <khc@pm.waw.pl>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin Schiller <ms@dev.tdt.de>, linux-x25@vger.kernel.org,
        wireguard@lists.zx2c4.com
Subject: Re: [PATCH 0/6 v2] treewide: rename 'mod_init' & 'mod_exit'
 functions to be module-specific
Message-ID: <20210716081517.GB2034@gondor.apana.org.au>
References: <20210711223148.5250-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210711223148.5250-1-rdunlap@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 11, 2021 at 03:31:42PM -0700, Randy Dunlap wrote:
> There are multiple (16) modules which use a module_init() function
> with the name 'mod_init' and a module_exit() function with the name
> 'mod_exit'. This can lead to confusion or ambiguity when reading
> crashes/oops/bugs etc. and when reading an initcall_debug log.
> 
> Example 1: (System.map file)
> 
> ffffffff83446d10 t mod_init
> ffffffff83446d18 t mod_init
> ffffffff83446d20 t mod_init
> ...
> ffffffff83454665 t mod_init
> ffffffff834548a4 t mod_init
> ffffffff83454a53 t mod_init
> ...
> ffffffff8345bd42 t mod_init
> ...
> ffffffff8345c916 t mod_init
> ffffffff8345c92a t mod_init
> ffffffff8345c93e t mod_init
> ffffffff8345c952 t mod_init
> ffffffff8345c966 t mod_init
> ...
> ffffffff834672c9 t mod_init
> 
> Example 2: (boot log when using 'initcall_debug')
> 
> [    0.252157] initcall mod_init+0x0/0x8 returned 0 after 0 usecs
> [    0.252180] initcall mod_init+0x0/0x8 returned 0 after 0 usecs
> [    0.252202] initcall mod_init+0x0/0x8 returned 0 after 0 usecs
> ...
> [    0.892907] initcall mod_init+0x0/0x23f returned -19 after 104 usecs
> [    0.913788] initcall mod_init+0x0/0x1af returned -19 after 9 usecs
> [    0.934353] initcall mod_init+0x0/0x49 returned -19 after 0 usecs
> ...
> [    1.454870] initcall mod_init+0x0/0x66 returned 0 after 72 usecs
> ...
> [    1.455527] initcall mod_init+0x0/0x14 returned 0 after 0 usecs
> [    1.455531] initcall mod_init+0x0/0x14 returned 0 after 0 usecs
> [    1.455536] initcall mod_init+0x0/0x14 returned 0 after 0 usecs
> [    1.455541] initcall mod_init+0x0/0x14 returned 0 after 0 usecs
> [    1.455545] initcall mod_init+0x0/0x52 returned 0 after 0 usecs
> ...
> [    1.588162] initcall mod_init+0x0/0xef returned 0 after 45 usecs
> 
> 
> v2: wireguard: changes per Jason
>     arm/crypto/curve25519-glue: add Russell's Acked-by
> 
> Cc: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Andres Salomon <dilinger@queued.net>
> Cc: linux-geode@lists.infradead.org
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: linux-crypto@vger.kernel.org
> Cc: Christian Gromm <christian.gromm@microchip.com>
> Cc: Krzysztof Halasa <khc@pm.waw.pl>
> Cc: netdev@vger.kernel.org
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Martin Schiller <ms@dev.tdt.de>
> Cc: linux-x25@vger.kernel.org
> Cc: wireguard@lists.zx2c4.com
> 
> [PATCH 1/6 v2] arm: crypto: rename 'mod_init' & 'mod_exit' functions to be module-specific
> [PATCH 2/6 v2] hw_random: rename 'mod_init' & 'mod_exit' functions to be module-specific
> [PATCH 3/6 v2] lib: crypto: rename 'mod_init' & 'mod_exit' functions to be module-specific
> [PATCH 4/6 v2] MOST: cdev: rename 'mod_init' & 'mod_exit' functions to be module-specific
> [PATCH 5/6 v2] net: hdlc: rename 'mod_init' & 'mod_exit' functions to be module-specific
> [PATCH 6/6 v2] net: wireguard: rename 'mod_init' & 'mod_exit' functions to be module-specific
> 
>  arch/arm/crypto/curve25519-glue.c  |    8 ++++----
>  drivers/char/hw_random/amd-rng.c   |    8 ++++----
>  drivers/char/hw_random/geode-rng.c |    8 ++++----
>  drivers/char/hw_random/intel-rng.c |    8 ++++----
>  drivers/char/hw_random/via-rng.c   |    8 ++++----
>  drivers/most/most_cdev.c           |    8 ++++----
>  drivers/net/wan/hdlc_cisco.c       |    8 ++++----
>  drivers/net/wan/hdlc_fr.c          |    8 ++++----
>  drivers/net/wan/hdlc_ppp.c         |    8 ++++----
>  drivers/net/wan/hdlc_raw.c         |    8 ++++----
>  drivers/net/wan/hdlc_raw_eth.c     |    8 ++++----
>  drivers/net/wan/hdlc_x25.c         |    8 ++++----
>  drivers/net/wireguard/main.c       |    8 ++++----
>  lib/crypto/blake2s.c               |    8 ++++----
>  lib/crypto/chacha20poly1305.c      |    8 ++++----
>  lib/crypto/curve25519.c            |    8 ++++----
>  16 files changed, 64 insertions(+), 64 deletions(-)

Patches 1-3 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
