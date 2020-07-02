Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD5421210B
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 12:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgGBKWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 06:22:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728323AbgGBKUV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 06:20:21 -0400
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE787206DD;
        Thu,  2 Jul 2020 10:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593685220;
        bh=h4X388artUNIVz+IWAOlQwFeJ3Od7WTT7Py6PUtGojE=;
        h=From:To:Cc:Subject:Date:From;
        b=A9ZkuZDHiPRmAAIULwilEVaJNM4a3NENPr7Q0BVVzdpHbUZvpJri/EOl5Mn9KzVha
         uBVtqfVU9BlnMzB0aziUSNQnWwdkmZi9kR/dmM5ud59EX3Eqvsg+JixtTFB7diQqIK
         tDPmsf2nmtZJ0CecESB5Z3LqUucylh19S8p7sZY4=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-nfs@vger.kernel.org
Subject: [RFC PATCH 0/7] crypto: get rid of ecb(arc4)
Date:   Thu,  2 Jul 2020 12:19:40 +0200
Message-Id: <20200702101947.682-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RC4 algorithm does not fit the sckipher model very well: it is a stream
cipher that combines the key and IV into a single vector, which implies that
using the same key more than once amounts to stream cipher IV reuse, and
therefore catastrophic failure.

So let's replace the remaining legacy users (WEP and TKIP in the staging
tree) to the ARC4 library interface, which does not rely on the crypto API
at all. Also, remove the obsolete RC4-HMAC-MD5 algorithm from the SUNRPC
driver stack.

NOTE: It should not be too difficult to switch the kerberos code over to
the ARC4 library interface as well, given that much of it uses a different
code path already. But we should only do so if we really need to keep this
support around, and it seems that this was only ever intended as a transitional
algorithm for Windows NT/2000 clients.

That leaves no remaining users of the ecb(arc4) skcipher, so we can remove
any implementations as well.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Anna Schumaker <anna.schumaker@netapp.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Cc: linux-nfs@vger.kernel.org

Ard Biesheuvel (7):
  staging/rtl8192e: switch to RC4 library interface
  staging/rtl8192u: switch to RC4 library interface
  SUNRPC: remove RC4-HMAC-MD5 support from KerberosV
  crypto: remove ARC4 support from the skcipher API
  crypto: n2 - remove ecb(arc4) support
  crypto: bcm-iproc - remove ecb(arc4) support
  crypto: tcrypt - remove ecb(arc4) testing/benchmarking support

 crypto/Kconfig                                |  12 -
 crypto/Makefile                               |   1 -
 crypto/arc4.c                                 |  76 -----
 crypto/tcrypt.c                               |  21 +-
 crypto/testmgr.c                              |   7 -
 crypto/testmgr.h                              |  62 ----
 drivers/crypto/bcm/cipher.c                   |  96 +-----
 drivers/crypto/bcm/cipher.h                   |   1 -
 drivers/crypto/bcm/spu.c                      |  23 +-
 drivers/crypto/bcm/spu.h                      |   1 -
 drivers/crypto/bcm/spu2.c                     |  12 +-
 drivers/crypto/bcm/spu2.h                     |   1 -
 drivers/crypto/n2_core.c                      |  46 ---
 drivers/net/wireless/intel/ipw2x00/Kconfig    |   1 -
 drivers/net/wireless/intersil/hostap/Kconfig  |   1 -
 drivers/staging/rtl8192e/Kconfig              |   4 +-
 drivers/staging/rtl8192e/rtllib_crypt_tkip.c  |  70 +----
 drivers/staging/rtl8192e/rtllib_crypt_wep.c   |  72 +----
 drivers/staging/rtl8192u/Kconfig              |   1 +
 .../rtl8192u/ieee80211/ieee80211_crypt_tkip.c |  82 +-----
 .../rtl8192u/ieee80211/ieee80211_crypt_wep.c  |  64 +---
 include/linux/sunrpc/gss_krb5.h               |  11 -
 include/linux/sunrpc/gss_krb5_enctypes.h      |   9 +-
 net/sunrpc/Kconfig                            |   1 -
 net/sunrpc/auth_gss/gss_krb5_crypto.c         | 276 ------------------
 net/sunrpc/auth_gss/gss_krb5_mech.c           |  95 ------
 net/sunrpc/auth_gss/gss_krb5_seal.c           |   1 -
 net/sunrpc/auth_gss/gss_krb5_seqnum.c         |  87 ------
 net/sunrpc/auth_gss/gss_krb5_unseal.c         |   1 -
 net/sunrpc/auth_gss/gss_krb5_wrap.c           |  65 +----
 30 files changed, 78 insertions(+), 1122 deletions(-)
 delete mode 100644 crypto/arc4.c

-- 
2.17.1

