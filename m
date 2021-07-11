Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0563C3FB8
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 00:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbhGKWeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 18:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhGKWen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 18:34:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95563C0613E8;
        Sun, 11 Jul 2021 15:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=Mo6qpJjml5U8iLYgc9vnqw2QRu2qtGojLIGPXWhslFE=; b=KScQpnoW/TzXIY7cNb0X+9rSTc
        VObwFUOiCt5HhPY75lZjfPLHLVTbCMD/VuuLAIMQ6hApemoQ3hw+wz9SbNb1RYnuqNuz9S+iJZ+qC
        qpwFw/szYblDg5BxhQ6jVt5jV5/IgXdKU5VdSizKG8cz9ymXhlV4DVkqXcDBzZ7ZHVtx/kbFP+gAT
        2xBpaSPyAWZdj1ri7FYqhc25RuGLS9aH0tO+XVxQvViZyD8FqCesqZvCyGJ3VPiVzrGrb2MIdT0i3
        u85KjU46Lwn0uiOOAqTZbFPM8Kx/3MxtWtNzLLZXUIJrII87eXv7QPEgz3iehZU173pcqyK7SzmnD
        JpVvManQ==;
Received: from [2601:1c0:6280:3f0::aefb] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2hzK-005U4u-Es; Sun, 11 Jul 2021 22:31:50 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andres Salomon <dilinger@queued.net>,
        linux-geode@lists.infradead.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        Christian Gromm <christian.gromm@microchip.com>,
        Krzysztof Halasa <khc@pm.waw.pl>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin Schiller <ms@dev.tdt.de>, linux-x25@vger.kernel.org,
        wireguard@lists.zx2c4.com
Subject: [PATCH 0/6 v2] treewide: rename 'mod_init' & 'mod_exit' functions to be module-specific
Date:   Sun, 11 Jul 2021 15:31:42 -0700
Message-Id: <20210711223148.5250-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are multiple (16) modules which use a module_init() function
with the name 'mod_init' and a module_exit() function with the name
'mod_exit'. This can lead to confusion or ambiguity when reading
crashes/oops/bugs etc. and when reading an initcall_debug log.

Example 1: (System.map file)

ffffffff83446d10 t mod_init
ffffffff83446d18 t mod_init
ffffffff83446d20 t mod_init
...
ffffffff83454665 t mod_init
ffffffff834548a4 t mod_init
ffffffff83454a53 t mod_init
...
ffffffff8345bd42 t mod_init
...
ffffffff8345c916 t mod_init
ffffffff8345c92a t mod_init
ffffffff8345c93e t mod_init
ffffffff8345c952 t mod_init
ffffffff8345c966 t mod_init
...
ffffffff834672c9 t mod_init

Example 2: (boot log when using 'initcall_debug')

[    0.252157] initcall mod_init+0x0/0x8 returned 0 after 0 usecs
[    0.252180] initcall mod_init+0x0/0x8 returned 0 after 0 usecs
[    0.252202] initcall mod_init+0x0/0x8 returned 0 after 0 usecs
...
[    0.892907] initcall mod_init+0x0/0x23f returned -19 after 104 usecs
[    0.913788] initcall mod_init+0x0/0x1af returned -19 after 9 usecs
[    0.934353] initcall mod_init+0x0/0x49 returned -19 after 0 usecs
...
[    1.454870] initcall mod_init+0x0/0x66 returned 0 after 72 usecs
...
[    1.455527] initcall mod_init+0x0/0x14 returned 0 after 0 usecs
[    1.455531] initcall mod_init+0x0/0x14 returned 0 after 0 usecs
[    1.455536] initcall mod_init+0x0/0x14 returned 0 after 0 usecs
[    1.455541] initcall mod_init+0x0/0x14 returned 0 after 0 usecs
[    1.455545] initcall mod_init+0x0/0x52 returned 0 after 0 usecs
...
[    1.588162] initcall mod_init+0x0/0xef returned 0 after 45 usecs


v2: wireguard: changes per Jason
    arm/crypto/curve25519-glue: add Russell's Acked-by

Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andres Salomon <dilinger@queued.net>
Cc: linux-geode@lists.infradead.org
Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
Cc: Christian Gromm <christian.gromm@microchip.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Martin Schiller <ms@dev.tdt.de>
Cc: linux-x25@vger.kernel.org
Cc: wireguard@lists.zx2c4.com

[PATCH 1/6 v2] arm: crypto: rename 'mod_init' & 'mod_exit' functions to be module-specific
[PATCH 2/6 v2] hw_random: rename 'mod_init' & 'mod_exit' functions to be module-specific
[PATCH 3/6 v2] lib: crypto: rename 'mod_init' & 'mod_exit' functions to be module-specific
[PATCH 4/6 v2] MOST: cdev: rename 'mod_init' & 'mod_exit' functions to be module-specific
[PATCH 5/6 v2] net: hdlc: rename 'mod_init' & 'mod_exit' functions to be module-specific
[PATCH 6/6 v2] net: wireguard: rename 'mod_init' & 'mod_exit' functions to be module-specific

 arch/arm/crypto/curve25519-glue.c  |    8 ++++----
 drivers/char/hw_random/amd-rng.c   |    8 ++++----
 drivers/char/hw_random/geode-rng.c |    8 ++++----
 drivers/char/hw_random/intel-rng.c |    8 ++++----
 drivers/char/hw_random/via-rng.c   |    8 ++++----
 drivers/most/most_cdev.c           |    8 ++++----
 drivers/net/wan/hdlc_cisco.c       |    8 ++++----
 drivers/net/wan/hdlc_fr.c          |    8 ++++----
 drivers/net/wan/hdlc_ppp.c         |    8 ++++----
 drivers/net/wan/hdlc_raw.c         |    8 ++++----
 drivers/net/wan/hdlc_raw_eth.c     |    8 ++++----
 drivers/net/wan/hdlc_x25.c         |    8 ++++----
 drivers/net/wireguard/main.c       |    8 ++++----
 lib/crypto/blake2s.c               |    8 ++++----
 lib/crypto/chacha20poly1305.c      |    8 ++++----
 lib/crypto/curve25519.c            |    8 ++++----
 16 files changed, 64 insertions(+), 64 deletions(-)
