Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A65C34FC4F7
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 21:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349499AbiDKTV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 15:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348735AbiDKTVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 15:21:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E594103F
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 12:19:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C930AB81883
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 19:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492A9C385A9;
        Mon, 11 Apr 2022 19:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649704766;
        bh=i64tUFRw0dZXm2FVITl+PhOByQyNX2j5KKL9t6iiNsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdL18PhrmVMAF9tnFFJ6RGzAO/S3ZpumFKDUMd5iYQyfVfKAvHPBIglj57/AxeJWY
         0bpkm6pkgFFpNc9fHZoqlElwvdkmI0wKWz85TlEGmBovoHVBWvxET+QgGsNrx1T2GX
         kTYf9x/WYf1iU+V3OEF/z3Dge8nzvff6x+gAaM0u6Fjl3ay7Bsb528do+i1F6wVtWu
         s8AKDs50KnL7qTfqjPbH4/+gDgADJMHija/aNpGCFe8ZuMs0nX1pLPHWMOAiuvA5kA
         MGHlMqjXuVN6XcfBMJsH27kDy9we0cPZb7EnWnR85RTfXPCFowpf66DT7Jba95eob5
         8myK/RDj2Q8jg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 10/10] tls: rx: only copy IV from the packet for TLS 1.2
Date:   Mon, 11 Apr 2022 12:19:17 -0700
Message-Id: <20220411191917.1240155-11-kuba@kernel.org>
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

TLS 1.3 and ChaChaPoly don't carry IV in the packet.
The code before this change would copy out iv_size
worth of whatever followed the TLS header in the packet
and then for TLS 1.3 | ChaCha overwrite that with
the sequence number. Waste of cycles especially
with TLS 1.2 being close to dead and TLS 1.3 being
the common case.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index fcbb0e078d79..9432a2c985e3 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1482,20 +1482,20 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	}
 
 	/* Prepare IV */
-	err = skb_copy_bits(skb, rxm->offset + TLS_HEADER_SIZE,
-			    iv + iv_offset + prot->salt_size,
-			    prot->iv_size);
-	if (err < 0) {
-		kfree(mem);
-		return err;
-	}
 	if (prot->version == TLS_1_3_VERSION ||
-	    prot->cipher_type == TLS_CIPHER_CHACHA20_POLY1305)
+	    prot->cipher_type == TLS_CIPHER_CHACHA20_POLY1305) {
 		memcpy(iv + iv_offset, tls_ctx->rx.iv,
 		       prot->iv_size + prot->salt_size);
-	else
+	} else {
+		err = skb_copy_bits(skb, rxm->offset + TLS_HEADER_SIZE,
+				    iv + iv_offset + prot->salt_size,
+				    prot->iv_size);
+		if (err < 0) {
+			kfree(mem);
+			return err;
+		}
 		memcpy(iv + iv_offset, tls_ctx->rx.iv, prot->salt_size);
-
+	}
 	xor_iv_with_seq(prot, iv + iv_offset, tls_ctx->rx.rec_seq);
 
 	/* Prepare AAD */
-- 
2.34.1

