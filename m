Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF9C1F4A79
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 02:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgFJA5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 20:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgFJA5p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 20:57:45 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57FDC2078C;
        Wed, 10 Jun 2020 00:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591750664;
        bh=1VHYOFq6Hh8pYrYgBpr7MiYq+c0pldyy3vs15UpfgZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GkwnvswEp/4d8XU0ugPiRb3ZrWlW4Gyta0V4Z2OhsYdEhmHVEuW7YwIntAbdp425K
         fbM/J1nd/yNtgWN/j6qzKmGfY6nzbsJ2W7PSG7nZDIvAuZvYRegMaK4Mnu6GLdt4c6
         Rkhcc8fa7dg4xZpLN1mo9CsjsopC/Fm95KruwkpQ=
From:   Eric Biggers <ebiggers@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net v3 3/3] esp, ah: modernize the crypto algorithm selections
Date:   Tue,  9 Jun 2020 17:54:02 -0700
Message-Id: <20200610005402.152495-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200610005402.152495-1-ebiggers@kernel.org>
References: <20200610005402.152495-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The crypto algorithms selected by the ESP and AH kconfig options are
out-of-date with the guidance of RFC 8221, which lists the legacy
algorithms MD5 and DES as "MUST NOT" be implemented, and some more
modern algorithms like AES-GCM and HMAC-SHA256 as "MUST" be implemented.
But the options select the legacy algorithms, not the modern ones.

Therefore, modify these options to select the MUST algorithms --
and *only* the MUST algorithms.

Also improve the help text.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Suggested-by: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Corentin Labbe <clabbe@baylibre.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 net/ipv4/Kconfig | 21 +++++++++++++++++++--
 net/ipv6/Kconfig | 21 +++++++++++++++++++--
 net/xfrm/Kconfig | 15 +++++++++------
 3 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 39a7a21744dc03..14fc8d6582499b 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -342,7 +342,17 @@ config INET_AH
 	tristate "IP: AH transformation"
 	select XFRM_AH
 	---help---
-	  Support for IPsec AH.
+	  Support for IPsec AH (Authentication Header).
+
+	  AH can be used with various authentication algorithms.  Besides
+	  enabling AH support itself, this option enables the generic
+	  implementations of the algorithms that RFC 8221 lists as MUST be
+	  implemented.  If you need any other algorithms, you'll need to enable
+	  them in the crypto API.  You should also enable accelerated
+	  implementations of any needed algorithms when available.
+
+	  Note that RFC 8221 considers AH itself to be "NOT RECOMMENDED".  It is
+	  better to use ESP only, using an AEAD cipher such as AES-GCM.
 
 	  If unsure, say Y.
 
@@ -350,7 +360,14 @@ config INET_ESP
 	tristate "IP: ESP transformation"
 	select XFRM_ESP
 	---help---
-	  Support for IPsec ESP.
+	  Support for IPsec ESP (Encapsulating Security Payload).
+
+	  ESP can be used with various encryption and authentication algorithms.
+	  Besides enabling ESP support itself, this option enables the generic
+	  implementations of the algorithms that RFC 8221 lists as MUST be
+	  implemented.  If you need any other algorithms, you'll need to enable
+	  them in the crypto API.  You should also enable accelerated
+	  implementations of any needed algorithms when available.
 
 	  If unsure, say Y.
 
diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index 70313f16319dd2..7398085ab10d58 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -51,7 +51,17 @@ config INET6_AH
 	tristate "IPv6: AH transformation"
 	select XFRM_AH
 	---help---
-	  Support for IPsec AH.
+	  Support for IPsec AH (Authentication Header).
+
+	  AH can be used with various authentication algorithms.  Besides
+	  enabling AH support itself, this option enables the generic
+	  implementations of the algorithms that RFC 8221 lists as MUST be
+	  implemented.  If you need any other algorithms, you'll need to enable
+	  them in the crypto API.  You should also enable accelerated
+	  implementations of any needed algorithms when available.
+
+	  Note that RFC 8221 considers AH itself to be "NOT RECOMMENDED".  It is
+	  better to use ESP only, using an AEAD cipher such as AES-GCM.
 
 	  If unsure, say Y.
 
@@ -59,7 +69,14 @@ config INET6_ESP
 	tristate "IPv6: ESP transformation"
 	select XFRM_ESP
 	---help---
-	  Support for IPsec ESP.
+	  Support for IPsec ESP (Encapsulating Security Payload).
+
+	  ESP can be used with various encryption and authentication algorithms.
+	  Besides enabling ESP support itself, this option enables the generic
+	  implementations of the algorithms that RFC 8221 lists as MUST be
+	  implemented.  If you need any other algorithms, you'll need to enable
+	  them in the crypto API.  You should also enable accelerated
+	  implementations of any needed algorithms when available.
 
 	  If unsure, say Y.
 
diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
index b2ff8df2c836ef..e77ba529229cf5 100644
--- a/net/xfrm/Kconfig
+++ b/net/xfrm/Kconfig
@@ -67,26 +67,29 @@ config XFRM_STATISTICS
 
 	  If unsure, say N.
 
+# This option selects XFRM_ALGO along with the AH authentication algorithms that
+# RFC 8221 lists as MUST be implemented.
 config XFRM_AH
 	tristate
 	select XFRM_ALGO
 	select CRYPTO
 	select CRYPTO_HMAC
-	select CRYPTO_MD5
-	select CRYPTO_SHA1
+	select CRYPTO_SHA256
 
+# This option selects XFRM_ALGO along with the ESP encryption and authentication
+# algorithms that RFC 8221 lists as MUST be implemented.
 config XFRM_ESP
 	tristate
 	select XFRM_ALGO
 	select CRYPTO
+	select CRYPTO_AES
 	select CRYPTO_AUTHENC
-	select CRYPTO_HMAC
-	select CRYPTO_MD5
 	select CRYPTO_CBC
-	select CRYPTO_SHA1
-	select CRYPTO_DES
 	select CRYPTO_ECHAINIV
+	select CRYPTO_GCM
+	select CRYPTO_HMAC
 	select CRYPTO_SEQIV
+	select CRYPTO_SHA256
 
 config XFRM_IPCOMP
 	tristate
-- 
2.26.2

