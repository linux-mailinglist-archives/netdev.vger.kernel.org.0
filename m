Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C1E6652D3
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 05:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbjAKE3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 23:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235792AbjAKE2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 23:28:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9744D1A8
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 20:25:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4007AB81AD6
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 04:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9464FC433EF;
        Wed, 11 Jan 2023 04:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673411149;
        bh=bdlhi0OWTPPaL5C3KR3ZudY6qtZb61l/fy7oS/4tMKc=;
        h=From:To:Cc:Subject:Date:From;
        b=gOm8fkkGpVCjUyRv9ims4hVFm9zkwvbRQb/NcisMzYU9RwLdsCH61WA6sZsGbG1VJ
         JdPyUGfvuRvLFrlkSqqGYJ1gKoccKyOAjDAAwYHXe2+e5QA5SwRPXw7JanqiqdNk18
         e/PxXQwcX7JinQAREoa7WM9/QdpouFbJYi5FfuDNng/DC4+pdXA4c9Ly4utXGVE+Yb
         HXpX8Zq8hWG0dHKwvXgDyZGCZqHCl5AfHFM2GuhtrhbzFhpd3IUSrsKEmhBiq1Cjx9
         2kLtUbJdWanh75ezFl8wcTA/+Gj/Eh5/3dCncHrxWLDcCsSlr2F4pMJvetwmLDou2c
         1dq2tk3zLcCAQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        somnath.kotur@broadcom.com, andrew.gospodarek@broadcom.com,
        michael.chan@broadcom.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] bnxt: make sure we return pages to the pool
Date:   Tue, 10 Jan 2023 20:25:47 -0800
Message-Id: <20230111042547.987749-1-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before the commit under Fixes the page would have been released
from the pool before the napi_alloc_skb() call, so normal page
freeing was fine (released page == no longer in the pool).

After the change we just mark the page for recycling so it's still
in the pool if the skb alloc fails, we need to recycle.

Same commit added the same bug in the new bnxt_rx_multi_page_skb().

Fixes: 1dc4c557bfed ("bnxt: adding bnxt_xdp_build_skb to build skb from multibuffer xdp_buff")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 16ce7a90610c..240a7e8a7652 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -993,7 +993,7 @@ static struct sk_buff *bnxt_rx_multi_page_skb(struct bnxt *bp,
 			     DMA_ATTR_WEAK_ORDERING);
 	skb = build_skb(page_address(page), PAGE_SIZE);
 	if (!skb) {
-		__free_page(page);
+		page_pool_recycle_direct(rxr->page_pool, page);
 		return NULL;
 	}
 	skb_mark_for_recycle(skb);
@@ -1031,7 +1031,7 @@ static struct sk_buff *bnxt_rx_page_skb(struct bnxt *bp,
 
 	skb = napi_alloc_skb(&rxr->bnapi->napi, payload);
 	if (!skb) {
-		__free_page(page);
+		page_pool_recycle_direct(rxr->page_pool, page);
 		return NULL;
 	}
 
-- 
2.38.1

