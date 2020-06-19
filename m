Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956662002DF
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 09:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730952AbgFSHnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 03:43:50 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:34748 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730919AbgFSHnt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 03:43:49 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 901B72051F;
        Fri, 19 Jun 2020 09:43:48 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id SbAvJBeKkk60; Fri, 19 Jun 2020 09:43:46 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B8ED82055E;
        Fri, 19 Jun 2020 09:43:46 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 19 Jun 2020 09:43:46 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 19 Jun
 2020 09:43:46 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id F01B2318024D;
 Fri, 19 Jun 2020 09:43:45 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 4/5] esp: select CRYPTO_SEQIV
Date:   Fri, 19 Jun 2020 09:43:41 +0200
Message-ID: <20200619074342.14095-5-steffen.klassert@secunet.com>
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

Commit f23efcbcc523 ("crypto: ctr - no longer needs CRYPTO_SEQIV") made
CRYPTO_CTR stop selecting CRYPTO_SEQIV.  This breaks IPsec for most
users since GCM and several other encryption algorithms require "seqiv"
-- and RFC 8221 lists AES-GCM as "MUST" be implemented.

Just make XFRM_ESP select CRYPTO_SEQIV.

Fixes: f23efcbcc523 ("crypto: ctr - no longer needs CRYPTO_SEQIV")
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Corentin Labbe <clabbe@baylibre.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
index 169c22140709..b2ff8df2c836 100644
--- a/net/xfrm/Kconfig
+++ b/net/xfrm/Kconfig
@@ -86,6 +86,7 @@ config XFRM_ESP
 	select CRYPTO_SHA1
 	select CRYPTO_DES
 	select CRYPTO_ECHAINIV
+	select CRYPTO_SEQIV
 
 config XFRM_IPCOMP
 	tristate
-- 
2.17.1

