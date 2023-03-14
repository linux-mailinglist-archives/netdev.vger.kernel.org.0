Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09BFD6B92BD
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 13:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjCNMLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 08:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjCNMLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 08:11:23 -0400
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.215])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B282262304
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=xuSq0
        V+uZt6AXmAjjEVxy63yR46ZHcah4FIGHQex5ZU=; b=LyOtgSIggX1sdKPQqJ+AY
        kzRnxNPp9CkGU/VAnSH3HTccHRBAgEmAsB092FOn0xdkjJRF6nOwtLjOGdzUWr91
        X7xJ60unhSGKOUs30JvsfRmgiYgyfWe41FZ664g5f36mPI3PRWlSJRHRMowYHvrq
        lBvJNahaGGxAliXC0lWjG8=
Received: from localhost.localdomain (unknown [101.230.162.50])
        by zwqz-smtp-mta-g0-3 (Coremail) with SMTP id _____wA3kwUdZBBk6asTAA--.6181S2;
        Tue, 14 Mar 2023 20:10:05 +0800 (CST)
From:   Tao Liu <taoliu828@163.com>
To:     paulb@nvidia.com, roid@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, taoliu828@163.com
Subject: [PATCH for-5.10] skbuff: Fix nfct leak on napi stolen
Date:   Tue, 14 Mar 2023 20:10:17 +0800
Message-Id: <20230314121017.1929515-1-taoliu828@163.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wA3kwUdZBBk6asTAA--.6181S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZFWrtr18XrWktF4ktF15CFg_yoW8GrWfpF
        WDGFW7Kr4DGF1kArWkuF1kXryYgws5XF13W3yrua4fJrn0qr18tF9Y9a4avF4UCr4kJFW3
        XrsI9r1Ygr4kXaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U4CJXUUUUU=
X-Originating-IP: [101.230.162.50]
X-CM-SenderInfo: xwdrzxbxysmqqrwthudrp/1tbiVwAyFFetqRtYrQAAsM
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Upstream commit [0] had fixed this issue, and backported to kernel 5.10.54.
However, nf_reset_ct() added in skb_release_head_state() instead of
napi_skb_free_stolen_head(), which lead to leakage still exist in 5.10.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8550ff8d8c75416e984d9c4b082845e57e560984

Fixes: 570341f10ecc ("skbuff: Release nfct refcount on napi stolen or re-used skbs"))
Signed-off-by: Tao Liu <taoliu828@163.com>
---
 net/core/dev.c    | 1 +
 net/core/skbuff.c | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8cbcb6a104f2..413c2a08d79d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6111,6 +6111,7 @@ EXPORT_SYMBOL(gro_find_complete_by_type);
 
 static void napi_skb_free_stolen_head(struct sk_buff *skb)
 {
+	nf_reset_ct(skb);
 	skb_dst_drop(skb);
 	skb_ext_put(skb);
 	kmem_cache_free(skbuff_head_cache, skb);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 668a9d0fbbc6..09cdefe5e1c8 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -659,7 +659,6 @@ static void kfree_skbmem(struct sk_buff *skb)
 
 void skb_release_head_state(struct sk_buff *skb)
 {
-	nf_reset_ct(skb);
 	skb_dst_drop(skb);
 	if (skb->destructor) {
 		WARN_ON(in_irq());
-- 
2.31.1

