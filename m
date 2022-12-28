Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C636583E3
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 17:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234967AbiL1QxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 11:53:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234983AbiL1Qwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 11:52:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894FEE8C;
        Wed, 28 Dec 2022 08:47:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FD82B8172A;
        Wed, 28 Dec 2022 16:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5482FC433EF;
        Wed, 28 Dec 2022 16:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246065;
        bh=QG4DOtGBvWPfutdY4gutfUHbJvS+CD5uT6XcePVcGuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NSC3jzwmY8oLYQ297txHXMp6n7QtegWyNqdEpKho0Yee6bb5XgbxnDKHtHHdTLb5Y
         s8Y2J6Hfo3H03kPxkVF+Gn3ALzLQ/1EKOgjMMs/tmyXH9IVkGixj3oSrOrzclA3ldY
         7tfxn0ZUsMTYnkxP4pQ2d96WWV6Iy8q8gTSciVWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rasesh Mody <rmody@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0975/1146] bnx2: Use kmalloc_size_roundup() to match ksize() usage
Date:   Wed, 28 Dec 2022 15:41:54 +0100
Message-Id: <20221228144356.835878357@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



