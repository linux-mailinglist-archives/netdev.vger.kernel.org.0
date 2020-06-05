Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26CE1EFF3B
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 19:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgFERkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 13:40:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726964AbgFERkc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 13:40:32 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B35AF2074B;
        Fri,  5 Jun 2020 17:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591378831;
        bh=7D3XjGzbRg6Jq6RxFvqO1AqFKQNP5hS7j9CSvr4SzbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=suaM17HTrVwYsM+l4kBUvOo8Iw+JTne9FhuHGuKZhSRL2Ezyzr/Vb/S5/oCa6bWZA
         j5RvYtn3cnRwLYh05Sv4s7JLNOFKNWMIlCkodDcAcK9keJYbuktndzjs0GeOMt1xKX
         CK2/SJbYwRcrd5q/7Hv5gJMFPHCkH1RPtkKQZAJ8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net v2] esp: select CRYPTO_SEQIV when useful
Date:   Fri,  5 Jun 2020 10:39:31 -0700
Message-Id: <20200605173931.241085-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0.278.ge193c7cf3a9-goog
In-Reply-To: <20200605064748.GA595@gondor.apana.org.au>
References: <20200605064748.GA595@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

CRYPTO_CTR no longer selects CRYPTO_SEQIV, which breaks IPsec for users
who need any of the algorithms that use seqiv.  These users now would
need to explicitly enable CRYPTO_SEQIV.

There doesn't seem to be a clear rule on what algorithms the IPsec
options (INET_ESP and INET6_ESP) actually select, as apparently none is
*always* required.  They currently select just a particular subset,
along with CRYPTO_ECHAINIV which is the other IV generator template.

As a compromise between too many and too few selections, select
CRYPTO_SEQIV if either CRYPTO_CTR or CRYPTO_CHACHA20POLY1305 is enabled.
These are the algorithms that can use seqiv for IPsec.  (Note: GCM and
CCM can too, but those both use CTR.)

Fixes: f23efcbcc523 ("crypto: ctr - no longer needs CRYPTO_SEQIV")
Cc: Corentin Labbe <clabbe@baylibre.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

v2: added the 'if' condition and updated commit message

 net/ipv4/Kconfig | 1 +
 net/ipv6/Kconfig | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 23ba5045e3d3..6520b30883cf 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -361,6 +361,7 @@ config INET_ESP
 	select CRYPTO_SHA1
 	select CRYPTO_DES
 	select CRYPTO_ECHAINIV
+	select CRYPTO_SEQIV if CRYPTO_CTR || CRYPTO_CHACHA20POLY1305
 	---help---
 	  Support for IPsec ESP.
 
diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index 4f03aece2980..c78adb0f5339 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -70,6 +70,7 @@ config INET6_ESP
 	select CRYPTO_SHA1
 	select CRYPTO_DES
 	select CRYPTO_ECHAINIV
+	select CRYPTO_SEQIV if CRYPTO_CTR || CRYPTO_CHACHA20POLY1305
 	---help---
 	  Support for IPsec ESP.
 
-- 
2.27.0.278.ge193c7cf3a9-goog

