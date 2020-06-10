Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F9D1F4A7B
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 02:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgFJA5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 20:57:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgFJA5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 20:57:44 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0005820734;
        Wed, 10 Jun 2020 00:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591750664;
        bh=9Zc/budDCcjpP9+7eBZitSza2xMGomdP6wTPFIeWg2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ldAi1YkeBwlrY/WeGkfEnEcMYGHOlQGFiF7iEEL4Ok2pK4Dhs9x0zxhIcZZLRQ0oX
         hRrKY5NVlg/PY1eLyztb4d+jw6C63QWYDLowy6+05D8Lv0Ufj8o6YYe6rOVjh05rUm
         2T6GWJ4guaQeC7HfmxTxUy6u6fhrnAcL4bpO/1ko=
From:   Eric Biggers <ebiggers@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net v3 2/3] esp: select CRYPTO_SEQIV
Date:   Tue,  9 Jun 2020 17:54:01 -0700
Message-Id: <20200610005402.152495-3-ebiggers@kernel.org>
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

Commit f23efcbcc523 ("crypto: ctr - no longer needs CRYPTO_SEQIV") made
CRYPTO_CTR stop selecting CRYPTO_SEQIV.  This breaks IPsec for most
users since GCM and several other encryption algorithms require "seqiv"
-- and RFC 8221 lists AES-GCM as "MUST" be implemented.

Just make XFRM_ESP select CRYPTO_SEQIV.

Fixes: f23efcbcc523 ("crypto: ctr - no longer needs CRYPTO_SEQIV") made
Cc: Corentin Labbe <clabbe@baylibre.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 net/xfrm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
index 169c22140709f7..b2ff8df2c836ef 100644
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
2.26.2

