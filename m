Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9316864FF91
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 17:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbiLRQEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 11:04:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbiLRQDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 11:03:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F165BF51;
        Sun, 18 Dec 2022 08:02:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC3EBB80B4D;
        Sun, 18 Dec 2022 16:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974DEC433D2;
        Sun, 18 Dec 2022 16:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379353;
        bh=QG4DOtGBvWPfutdY4gutfUHbJvS+CD5uT6XcePVcGuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sf5b51M0cUpLdEEzRznDGS+g0exWIKBCc8iZRUXyVMrbAbgp502n6p4FWsBSaN7qI
         YfJHMUqzVVFtbqDuaZ5vj71vaMGYfb4tnTN12R5TDnR4doRm3z6lU2fzus6J1Bkin2
         MYhvdjfSWXLYAYIUcXK+fgg2xOj5ftz3D10Mb3wDDLQFRojFVww5H3/xa2Su9t//RP
         hPTPqjUyScAkY7oUwAEIlTEFxfGC/RQZ+HczmEaKn/MhwkKMxXapqQDzKs/oy+Zdwn
         FMhTWDMlXUvHf6Mxb2FwveKc/d7goTDF2RZdlW2GxAQ5PE5sVdNLX/BZOrjdCWuEUy
         EozjKjajUJBiA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>, Rasesh Mody <rmody@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.1 11/85] bnx2: Use kmalloc_size_roundup() to match ksize() usage
Date:   Sun, 18 Dec 2022 11:00:28 -0500
Message-Id: <20221218160142.925394-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160142.925394-1-sashal@kernel.org>
References: <20221218160142.925394-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit d6dd508080a3cdc0ab34ebf66c3734f2dff907ad ]

Round up allocations with kmalloc_size_roundup() so that build_skb()'s
use of ksize() is always accurate and no special handling of the memory
is needed by KASAN, UBSAN_BOUNDS, nor FORTIFY_SOURCE.

Cc: Rasesh Mody <rmody@marvell.com>
Cc: GR-Linux-NIC-Dev@marvell.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221022021004.gonna.489-kees@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index fec57f1982c8..dbe310144780 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -5415,8 +5415,9 @@ bnx2_set_rx_ring_size(struct bnx2 *bp, u32 size)
 
 	bp->rx_buf_use_size = rx_size;
 	/* hw alignment + build_skb() overhead*/
-	bp->rx_buf_size = SKB_DATA_ALIGN(bp->rx_buf_use_size + BNX2_RX_ALIGN) +
-		NET_SKB_PAD + SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	bp->rx_buf_size = kmalloc_size_roundup(
+		SKB_DATA_ALIGN(bp->rx_buf_use_size + BNX2_RX_ALIGN) +
+		NET_SKB_PAD + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
 	bp->rx_jumbo_thresh = rx_size - BNX2_RX_OFFSET;
 	bp->rx_ring_size = size;
 	bp->rx_max_ring = bnx2_find_max_ring(size, BNX2_MAX_RX_RINGS);
-- 
2.35.1

