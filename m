Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091231F58D7
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 18:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbgFJQPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 12:15:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727992AbgFJQPO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 12:15:14 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D119120734;
        Wed, 10 Jun 2020 16:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591805714;
        bh=68Za/4/OkgN1E2Gq9Y+zxhWeO1WdiaXkDnm/z4tnw0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kRkZQr9eoMiH8JrG9GXuKntne92gH4t+ojz6hvar2FVJ7Yc8FmtZob6do/UuLqxok
         GKhAfwkFf/w7hZIatFWqYwaJ/fAhHGOh2C9aZAYnuL3Q5n/AMt+3pcGXCCo0CdCZbA
         LWXoCD3nG2eXcW6rgi+Dc7mZltB0jQDzpHZ0unK8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net v4 1/3] esp, ah: consolidate the crypto algorithm selections
Date:   Wed, 10 Jun 2020 09:14:35 -0700
Message-Id: <20200610161437.4290-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200610161437.4290-1-ebiggers@kernel.org>
References: <20200610161437.4290-1-ebiggers@kernel.org>
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
index 23ba5045e3d3c1..39a7a21744dc03 100644
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
 	---help---
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
 	---help---
 	  Support for IPsec ESP.
 
diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index 4f03aece2980fb..70313f16319dd2 100644
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
 	---help---
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
 	---help---
 	  Support for IPsec ESP.
 
diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
index b7fd9c83841605..169c22140709f7 100644
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
2.26.2

