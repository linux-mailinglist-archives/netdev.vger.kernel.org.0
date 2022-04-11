Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540984FC4F2
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 21:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349416AbiDKTVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 15:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233762AbiDKTVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 15:21:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82FF103C
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 12:19:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ECC761530
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 19:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C16C385AD;
        Mon, 11 Apr 2022 19:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649704763;
        bh=kj/wJqFucolwHKdpsm8e6modbsyI0QwuyF+MS8O//W4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H1ejE9w/bWuIstWV9hvpEc1rJMatrwQYHiEdKzfxXGwoXpygiF2hCIMtN49vB8Kbx
         Y0ddK0n69+UF4KmC8UARhQ9NCGIx1tuKAAHUnFvIs09DZOes0xkUkSonvQbZw+spOX
         xFQ4JiwCBcwkp6GPI+tNYRN4j+fRtwcmAZCyKCMP0fu38V1HyhAd6mOVBPT+EAPFhP
         lgWil8z/BLG9hqbMHsWfx0QMMfoVPwQzhAga4GWynXWiU3yRLBIUhBWHsaEunzBy+V
         pP9oaFi3lPChp9w/dEk1Aun8Al/xO0kzfITzUlW0kpgH6ppaOsUQs1rUYdJ8VtRivL
         nTMdXFTd/Q9xw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 04/10] tls: rx: don't handle TLS 1.3 in the async crypto callback
Date:   Mon, 11 Apr 2022 12:19:11 -0700
Message-Id: <20220411191917.1240155-5-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220411191917.1240155-1-kuba@kernel.org>
References: <20220411191917.1240155-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Async crypto never worked with TLS 1.3 and was explicitly disabled in
commit 8497ded2d16c ("net/tls: Disable async decrytion for tls1.3").
There's no need for us to handle TLS 1.3 padding in the async cb.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index c8378396e616..b3a15dc3d4eb 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -188,17 +188,12 @@ static void tls_decrypt_done(struct crypto_async_request *req, int err)
 		tls_err_abort(skb->sk, err);
 	} else {
 		struct strp_msg *rxm = strp_msg(skb);
-		int pad;
 
-		pad = padding_length(prot, skb);
-		if (pad < 0) {
-			ctx->async_wait.err = pad;
-			tls_err_abort(skb->sk, pad);
-		} else {
-			rxm->full_len -= pad;
-			rxm->offset += prot->prepend_size;
-			rxm->full_len -= prot->overhead_size;
-		}
+		/* No TLS 1.3 support with async crypto */
+		WARN_ON(prot->tail_size);
+
+		rxm->offset += prot->prepend_size;
+		rxm->full_len -= prot->overhead_size;
 	}
 
 	/* After using skb->sk to propagate sk through crypto async callback
-- 
2.34.1

