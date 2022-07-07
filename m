Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28057569792
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 03:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234880AbiGGBfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 21:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234632AbiGGBfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 21:35:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CBB22E9FB
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 18:35:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0D83B81F68
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 01:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197FEC3411C;
        Thu,  7 Jul 2022 01:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657157718;
        bh=bFIp60geipwLSB+ICHh2QaeJhwkLqSi9HpX7SmnwQJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t96QVcsTnplZ5fmLHIgbJrRZV6ELwrsRghp7n3mpQhk1WM1zZWbW9Iq2z4AuQJK/K
         6+xXjYW5AImWD/IOPQCFEuWVvPUX+aGM/BygVcAOU3aFR88zmSWAuIaz1qa1x23KMm
         QbRfG5CCY9pX0sLatLOpPYAI7skquMrjwMSF0p8PHBJ1RUnGeb7Rm5bd5Aq3peGs5m
         7a2MJPl4orbY7+aijnwx0Xd3xfuFhZcBgmt8/zv3sfqLYDb470Mmm65wa0nzCH1SZT
         ukO70u820QVza81ynk87JH+R58bugYjClYdhs4HZb84gv1F04eQYXYHXTQnN39BYfi
         J50UfHMckryIQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/6] tls: rx: coalesce exit paths in tls_decrypt_sg()
Date:   Wed,  6 Jul 2022 18:35:08 -0700
Message-Id: <20220707013510.1372695-5-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220707013510.1372695-1-kuba@kernel.org>
References: <20220707013510.1372695-1-kuba@kernel.org>
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

