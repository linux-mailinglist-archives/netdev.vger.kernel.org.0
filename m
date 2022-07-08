Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F7A56AF87
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 03:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236802AbiGHBDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 21:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236787AbiGHBDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 21:03:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C934C64E1
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 18:03:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5496461806
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 01:03:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6539AC341D0;
        Fri,  8 Jul 2022 01:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657242207;
        bh=bFIp60geipwLSB+ICHh2QaeJhwkLqSi9HpX7SmnwQJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ee5lgy1KDpgn8PSlADUqiG52Z/91n7ADGlhFj2h/AzNUE7Nn9WvBY2MC5Uhr7g3kI
         1MoHvmqQLPNpp7ij9XKq6eOLJSXRnIK0js2kdPFKIP5YVUxeYI32G/FGZot/+BYp0a
         YvauaC7dCBsWPRjlZ5e2nib8lsaX7vt+GQ0ycTJivsmJEM+efPhCeE3/PJG9zm8a7S
         Aw+B/Ceutuc+ZcJ4bJelhOyMGZcq51S9AWBJjZ6JgwvvyRtcBgYrv57iERzNacHIY9
         E4Kt8psbailTj1vav89HLbINdoUKpIHxt07N+NfDP5VqW0fFGRg0+JFT/df80tUYaA
         FOTjlevFJmYQw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 4/6] tls: rx: coalesce exit paths in tls_decrypt_sg()
Date:   Thu,  7 Jul 2022 18:03:12 -0700
Message-Id: <20220708010314.1451462-5-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220708010314.1451462-1-kuba@kernel.org>
References: <20220708010314.1451462-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jump to the free() call, instead of having to remember
to free the memory in multiple places.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 5534962963c2..2afcf99105fb 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1494,10 +1494,8 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 		err = skb_copy_bits(skb, rxm->offset + TLS_HEADER_SIZE,
 				    &dctx->iv[iv_offset] + prot->salt_size,
 				    prot->iv_size);
-		if (err < 0) {
-			kfree(mem);
-			return err;
-		}
+		if (err < 0)
+			goto exit_free;
 		memcpy(&dctx->iv[iv_offset], tls_ctx->rx.iv, prot->salt_size);
 	}
 	xor_iv_with_seq(prot, &dctx->iv[iv_offset], tls_ctx->rx.rec_seq);
@@ -1513,10 +1511,8 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	err = skb_to_sgvec(skb, &sgin[1],
 			   rxm->offset + prot->prepend_size,
 			   rxm->full_len - prot->prepend_size);
-	if (err < 0) {
-		kfree(mem);
-		return err;
-	}
+	if (err < 0)
+		goto exit_free;
 
 	if (n_sgout) {
 		if (out_iov) {
@@ -1559,7 +1555,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	/* Release the pages in case iov was mapped to pages */
 	for (; pages > 0; pages--)
 		put_page(sg_page(&sgout[pages]));
-
+exit_free:
 	kfree(mem);
 	return err;
 }
-- 
2.36.1

