Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3142658DD87
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 19:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245652AbiHIR4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 13:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245635AbiHIR4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 13:56:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9872ECE5
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 10:56:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47A0EB8171C
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 17:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D83C433B5;
        Tue,  9 Aug 2022 17:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660067761;
        bh=h0bnw0p4KMurbKgNMYVTQW3VrgCwPqGqO3dHqOq7I74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vq6miwB3Tuj8VjTHwSLJa2u53MUC1GnJmDP773abxJZRe/4Pj503Xis4acOF9KfAo
         V8UWh3W+IkUAXeFT4wdukChRHegwND1qQuE5GDRRUcxMNdZzR3vB7+RKs+dLOMButa
         UQEmxenm0WL3hmHL3moPIRG5QnnAwrjoBWXLlZpYOT+82skMwekNAYKmOIVNMZd4m/
         E07xyELvqnjw91jV0AZN5ZUBw+ApiO+hE77fgE+ZU5iwcmih2liwNEq52vyHNTbY/2
         mJzyhLqdvqKp2aGvxcb62PQu+8Lus9CC/OQ2+8DoIxcsNIN+TJisoWEOb5CKkyVXeO
         O8nFrQiYknvnA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        tariqt@nvidia.com, maximmi@nvidia.com, borisp@nvidia.com,
        john.fastabend@gmail.com, Jakub Kicinski <kuba@kernel.org>,
        Ran Rozenstein <ranro@nvidia.com>
Subject: [PATCH net 2/2] tls: rx: device: don't try to copy too much on detach
Date:   Tue,  9 Aug 2022 10:55:44 -0700
Message-Id: <20220809175544.354343-2-kuba@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175544.354343-1-kuba@kernel.org>
References: <20220809175544.354343-1-kuba@kernel.org>
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

Another device offload bug, we use the length of the output
skb as an indication of how much data to copy. But that skb
is sized to offset + record length, and we start from offset.
So we end up double-counting the offset which leads to
skb_copy_bits() returning -EFAULT.

Reported-by: Tariq Toukan <tariqt@nvidia.com>
Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
Tested-by: Ran Rozenstein <ranro@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_strp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index f0b7c9122fba..9b79e334dbd9 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -41,7 +41,7 @@ static struct sk_buff *tls_strp_msg_make_copy(struct tls_strparser *strp)
 	struct sk_buff *skb;
 	int i, err, offset;
 
-	skb = alloc_skb_with_frags(0, strp->anchor->len, TLS_PAGE_ORDER,
+	skb = alloc_skb_with_frags(0, strp->stm.full_len, TLS_PAGE_ORDER,
 				   &err, strp->sk->sk_allocation);
 	if (!skb)
 		return NULL;
-- 
2.37.1

