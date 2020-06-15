Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FDE1FA33D
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 00:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgFOWOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 18:14:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbgFOWOC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 18:14:02 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D8A820768;
        Mon, 15 Jun 2020 22:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592259241;
        bh=BalKvlkU/X62vY3z0X3JeF0wdiabo3C81dWr+J3AuCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bTHhY+i0Hz0BLT4lRBj7YI6zOgwCpQQ37RXK4bs4TcmL+YJIQ5B2vCrH17hhTdGCJ
         u+1bYH9gAt56S5xL90NWjw9FF1BEfhnnXLOaG6QKI9fFC8Q1bI2GnLMfRZb07A1Geu
         JyrREYNTcNII6hMRO+e5AZY7cVLuyUlosL3dH3GA=
From:   Eric Biggers <ebiggers@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net v5 1/3] esp, ah: consolidate the crypto algorithm selections
Date:   Mon, 15 Jun 2020 15:13:16 -0700
Message-Id: <20200615221318.149558-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
In-Reply-To: <20200615221318.149558-1-ebiggers@kernel.org>
References: <20200615221318.149558-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Instead of duplicating the algorithm selections between INET_AH and
INET6_AH and between INET_ESP and INET6_ESP, create new tristates
XFRM_AH and XFRM_ESP that do the algorithm selections, and make these be
selected by the corresponding INET* options.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Corentin Labbe <clabbe@baylibre.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 net/ipv4/Kconfig | 16 ++--------------
 net/ipv6/Kconfig | 16 ++--------------
 net/xfrm/Kconfig | 20 ++++++++++++++++++++
 3 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 6ecbb0ced177..c0653de6d00e 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -340,11 +340,7 @@ config NET_FOU_IP_TUNNELS
 
 config INET_AH
 	tristate "IP: AH transformation"
-	select XFRM_ALGO
-	select CRYPTO
-	select CRYPTO_HMAC
-	select CRYPTO_MD5
-	select CRYPTO_SHA1
+	select XFRM_AH
 	help
 	  Support for IPsec AH.
 
@@ -352,15 +348,7 @@ config INET_AH
 
 config INET_ESP
 	tristate "IP: ESP transformation"
-	select XFRM_ALGO
-	select CRYPTO
-	select CRYPTO_AUTHENC
-	select CRYPTO_HMAC
-	select CRYPTO_MD5
-	select CRYPTO_CBC
-	select CRYPTO_SHA1
-	select CRYPTO_DES
-	select CRYPTO_ECHAINIV
+	select XFRM_ESP
 	help
 	  Support for IPsec ESP.
 
diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index 992cf45fb4f6..05f99d30b8be 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -49,11 +49,7 @@ config IPV6_OPTIMISTIC_DAD
 
 config INET6_AH
 	tristate "IPv6: AH transformation"
-	select XFRM_ALGO
-	select CRYPTO
-	select CRYPTO_HMAC
-	select CRYPTO_MD5
-	select CRYPTO_SHA1
+	select XFRM_AH
 	help
 	  Support for IPsec AH.
 
@@ -61,15 +57,7 @@ config INET6_AH
 
 config INET6_ESP
 	tristate "IPv6: ESP transformation"
-	select XFRM_ALGO
-	select CRYPTO
-	select CRYPTO_AUTHENC
-	select CRYPTO_HMAC
-	select CRYPTO_MD5
-	select CRYPTO_CBC
-	select CRYPTO_SHA1
-	select CRYPTO_DES
-	select CRYPTO_ECHAINIV
+	select XFRM_ESP
 	help
 	  Support for IPsec ESP.
 
diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
index b5d4a1ef04b9..d140707faddc 100644
--- a/net/xfrm/Kconfig
+++ b/net/xfrm/Kconfig
@@ -67,6 +67,26 @@ config XFRM_STATISTICS
 
 	  If unsure, say N.
 
+config XFRM_AH
+	tristate
+	select XFRM_ALGO
+	select CRYPTO
+	select CRYPTO_HMAC
+	select CRYPTO_MD5
+	select CRYPTO_SHA1
+
+config XFRM_ESP
+	tristate
+	select XFRM_ALGO
+	select CRYPTO
+	select CRYPTO_AUTHENC
+	select CRYPTO_HMAC
+	select CRYPTO_MD5
+	select CRYPTO_CBC
+	select CRYPTO_SHA1
+	select CRYPTO_DES
+	select CRYPTO_ECHAINIV
+
 config XFRM_IPCOMP
 	tristate
 	select XFRM_ALGO
-- 
2.27.0.290.gba653c62da-goog

