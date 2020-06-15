Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF6D1FA342
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 00:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgFOWOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 18:14:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgFOWOC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 18:14:02 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D53912078E;
        Mon, 15 Jun 2020 22:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592259242;
        bh=/+9oMm841PV2DS5+tXwvS9/SSKKKymrkweEl/gCWAiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M2ftYjM53KgV8apDXYNHPm1wPJE0jdf/PA5zQpqM/DRw4C8obH+vF857cOwcHEMLJ
         Q09YY7KV86SbGG3wFhmeu2oyqFcSZOJLRcm+cSyxHFWXU8+fC8cIApJTr1Ecrrsmpi
         L5jYCBV/sdqwvm5qT82y4XD1AP0ADhfyuFE4ULjY=
From:   Eric Biggers <ebiggers@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net v5 2/3] esp: select CRYPTO_SEQIV
Date:   Mon, 15 Jun 2020 15:13:17 -0700
Message-Id: <20200615221318.149558-3-ebiggers@kernel.org>
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
---
 net/xfrm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
index d140707faddc..bfb45ee56e5f 100644
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
2.27.0.290.gba653c62da-goog

