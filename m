Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9B258DD86
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 19:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245643AbiHIR4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 13:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245289AbiHIR4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 13:56:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BAB5B61
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 10:56:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E047DB8171A
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 17:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A36FC43470;
        Tue,  9 Aug 2022 17:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660067760;
        bh=qDVPPmoK3CAJJYxId1/i1zX3ZxTMpwTHD0SbE4yKjTk=;
        h=From:To:Cc:Subject:Date:From;
        b=AeZFLBFsaF8grtesaLm8dM+kkqD+J3W8wR8P6JjtItZRtfTrUuTb4WSUpysn1gfPV
         EJBDVT79R3biOKy8AVLcU1D1Nriq3nW5BnFfrUpAKJi23TYl1x0RFr4Qd0+k5AAznG
         FyVLSDcuqg93z+s2gPOtXUD8Ol1okmw0VMz2EqZYmrPVoTfKiEUwETTxOBUxuerVci
         lo3m3pCAjWc21KB8ycxXOTbnBnZGNv46dninVXvCU0rXVDItoVpGbKSuUfe5rYh9IB
         4w9SmP2E9EFRuUc9j+V6UYt9mgkpXAjLMWHwGgr4WfZMxUJl2W2GHgKxldIa1l/HfA
         utNFYxCIcgeJQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        tariqt@nvidia.com, maximmi@nvidia.com, borisp@nvidia.com,
        john.fastabend@gmail.com, Jakub Kicinski <kuba@kernel.org>,
        Ran Rozenstein <ranro@nvidia.com>
Subject: [PATCH net 1/2] tls: rx: device: bound the frag walk
Date:   Tue,  9 Aug 2022 10:55:43 -0700
Message-Id: <20220809175544.354343-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can't do skb_walk_frags() on the input skbs, because
the input skbs is really just a pointer to the tcp read
queue. We need to bound the "is decrypted" check by the
amount of data in the message.

Note that the walk in tls_device_reencrypt() is after a
CoW so the skb there is safe to walk. Actually in the
current implementation it can't have frags at all, but
whatever, maybe one day it will.

Reported-by: Tariq Toukan <tariqt@nvidia.com>
Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
Tested-by: Ran Rozenstein <ranro@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_device.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index e3e6cf75aa03..6ed41474bdf8 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -984,11 +984,17 @@ int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx)
 	int is_decrypted = skb->decrypted;
 	int is_encrypted = !is_decrypted;
 	struct sk_buff *skb_iter;
+	int left;
 
+	left = rxm->full_len - skb->len;
 	/* Check if all the data is decrypted already */
-	skb_walk_frags(skb, skb_iter) {
+	skb_iter = skb_shinfo(skb)->frag_list;
+	while (skb_iter && left > 0) {
 		is_decrypted &= skb_iter->decrypted;
 		is_encrypted &= !skb_iter->decrypted;
+
+		left -= skb_iter->len;
+		skb_iter = skb_iter->next;
 	}
 
 	trace_tls_device_decrypted(sk, tcp_sk(sk)->copied_seq - rxm->full_len,
-- 
2.37.1

