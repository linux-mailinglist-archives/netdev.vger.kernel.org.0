Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31907257C06
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 17:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbgHaPRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 11:17:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728245AbgHaPRB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 11:17:01 -0400
Received: from e123331-lin.nice.arm.com (adsl-83.46.190.3.tellas.gr [46.190.3.83])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 473A320767;
        Mon, 31 Aug 2020 15:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887020;
        bh=LGgb8U6bWThvJSrtQmHIl0vs2R6ChNQjL+AvZ8r4Trs=;
        h=From:To:Cc:Subject:Date:From;
        b=mMfctBfdrkXKD/xzBvAlgVjjoy7RxsKAkYfgvrIDSNSJrrLecq0DGRCx2qqu2UhwB
         egqaQUEEBDXpqk8vGeEouLRxXW9UDHMHu/Y47gL9EM+dtHB+HYcPGtFl14lJ6rhLWd
         y1SwSj3Z3OyDfFJbP//jQB0sK405PEP1ZwgPJS/0=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-nfs@vger.kernel.org
Subject: [PATCH v3 0/7] crypto: mark ecb(arc4) skcipher as obsolete
Date:   Mon, 31 Aug 2020 18:16:42 +0300
Message-Id: <20200831151649.21969-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RC4 hasn't aged very well, and is a poor fit for the skcipher API so it
would be good if we could get rid of the ecb(arc4) drivers in the kernel
at some point in the future. This prevents new users from creeping in, and
allows us to improve the skcipher API without having to care too much about
obsolete algorithms that may be difficult to support going forward.

So let's get rid of any remaining in-kernel users, either by switching them
to the arc4 library API (for cases which simply cannot change algorithms,
e.g., WEP), or dropping the code entirely. Also remove the remaining h/w
accelerated implementations, and mark the generic s/w implementation as
obsolete in Kconfig.

Changes since v2:
- depend on CRYPTO_USER_API not CRYPTO_USER
- rename CRYPTO_USER_ENABLE_OBSOLETE to CRYPTO_USER_API_ENABLE_OBSOLETE for
  clarity

Changes since RFC [0]:
- keep ecb(arc4) generic C implementation, and the associated test vectors,
  but print a warning about ecb(arc4) being obsolete so we can identify
  remaining users
- add a Kconfig option to en/disable obsolete algorithms that are only kept
  around to prevent breaking users that rely on it via the socket interface
- add a patch to clean up some bogus Kconfig dependencies
- add acks to patches #1, #2 and #3

[0] https://lore.kernel.org/driverdev-devel/20200702101947.682-1-ardb@kernel.org/

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Anna Schumaker <anna.schumaker@netapp.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Cc: linux-nfs@vger.kernel.org

Ard Biesheuvel (7):
  staging/rtl8192e: switch to RC4 library interface
  staging/rtl8192u: switch to RC4 library interface
  SUNRPC: remove RC4-HMAC-MD5 support from KerberosV
  crypto: n2 - remove ecb(arc4) support
  crypto: bcm-iproc - remove ecb(arc4) support
  net: wireless: drop bogus CRYPTO_xxx Kconfig selects
  crypto: arc4 - mark ecb(arc4) skcipher as obsolete

 crypto/Kconfig                                |  10 +
 crypto/arc4.c                                 |  10 +
 drivers/crypto/bcm/cipher.c                   |  96 +-----
 drivers/crypto/bcm/cipher.h                   |   1 -
 drivers/crypto/bcm/spu.c                      |  23 +-
 drivers/crypto/bcm/spu.h                      |   1 -
 drivers/crypto/bcm/spu2.c                     |  12 +-
 drivers/crypto/bcm/spu2.h                     |   1 -
 drivers/crypto/n2_core.c                      |  46 ---
 drivers/net/wireless/intel/ipw2x00/Kconfig    |   4 -
 drivers/net/wireless/intersil/hostap/Kconfig  |   4 -
 drivers/staging/rtl8192e/Kconfig              |   4 +-
 drivers/staging/rtl8192e/rtllib_crypt_tkip.c  |  70 +----
 drivers/staging/rtl8192e/rtllib_crypt_wep.c   |  72 +----
 drivers/staging/rtl8192u/Kconfig              |   1 +
 .../rtl8192u/ieee80211/ieee80211_crypt_tkip.c |  81 +----
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
 26 files changed, 97 insertions(+), 949 deletions(-)

-- 
2.17.1

