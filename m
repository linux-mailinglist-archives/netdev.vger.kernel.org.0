Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429E92002E1
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 09:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730965AbgFSHnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 03:43:53 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:34768 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730936AbgFSHnv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 03:43:51 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 845EF20571;
        Fri, 19 Jun 2020 09:43:49 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id olScncvDS-tl; Fri, 19 Jun 2020 09:43:49 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 59C4B2057E;
        Fri, 19 Jun 2020 09:43:47 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 19 Jun 2020 09:43:47 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 19 Jun
 2020 09:43:46 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id ED131318022D;
 Fri, 19 Jun 2020 09:43:45 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 3/5] esp, ah: consolidate the crypto algorithm selections
Date:   Fri, 19 Jun 2020 09:43:40 +0200
Message-ID: <20200619074342.14095-4-steffen.klassert@secunet.com>
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
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/Kconfig | 16 ++--------------
 net/ipv6/Kconfig | 16 ++--------------
 net/xfrm/Kconfig | 20 ++++++++++++++++++++
 3 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 23ba5045e3d3..39a7a21744dc 100644
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
index 4f03aece2980..70313f16319d 100644
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
index b7fd9c838416..169c22140709 100644
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
2.17.1

