Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03F02002E2
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 09:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730996AbgFSHn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 03:43:56 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:34776 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730919AbgFSHnv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 03:43:51 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2186720573;
        Fri, 19 Jun 2020 09:43:50 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id g2enMlhLWltp; Fri, 19 Jun 2020 09:43:49 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8756920581;
        Fri, 19 Jun 2020 09:43:47 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 19 Jun 2020 09:43:47 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 19 Jun
 2020 09:43:46 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id F3E8F318027B;
 Fri, 19 Jun 2020 09:43:45 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 5/5] esp, ah: modernize the crypto algorithm selections
Date:   Fri, 19 Jun 2020 09:43:42 +0200
Message-ID: <20200619074342.14095-6-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200619074342.14095-1-steffen.klassert@secunet.com>
References: <20200619074342.14095-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
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

Note that other algorithms may still be explicitly enabled in the
kconfig, and the choice of which to actually use is still controlled by
userspace.  This change only modifies the list of algorithms for which
kernel support is guaranteed to be present.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Suggested-by: Steffen Klassert <steffen.klassert@secunet.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Corentin Labbe <clabbe@baylibre.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/Kconfig | 18 ++++++++++++++++--
 net/ipv6/Kconfig | 18 ++++++++++++++++--
 net/xfrm/Kconfig | 15 +++++++++------
 3 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 39a7a21744dc..dc9dfaef77e5 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -342,7 +342,14 @@ config INET_AH
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
 
 	  If unsure, say Y.
 
@@ -350,7 +357,14 @@ config INET_ESP
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
index 70313f16319d..414a68b16869 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -51,7 +51,14 @@ config INET6_AH
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
 
 	  If unsure, say Y.
 
@@ -59,7 +66,14 @@ config INET6_ESP
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
index b2ff8df2c836..e77ba529229c 100644
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
2.17.1

