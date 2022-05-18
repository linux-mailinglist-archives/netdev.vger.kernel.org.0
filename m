Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D1152BA6A
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236887AbiERMag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236946AbiERM3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:29:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F41118014;
        Wed, 18 May 2022 05:28:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 967316168A;
        Wed, 18 May 2022 12:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BF5C36AE2;
        Wed, 18 May 2022 12:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876905;
        bh=QthLUezj51OHIH/d94GCmVVj5dFJwmK1Ae4LYtY9Z2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P0plilsyT74Gx/8nWpnnRizMiye9QukeV7BEQg9OKLQDkmdWtkwrJ7U+0UjMH/p1g
         ZrEUpXOp5+tNoCYh+9qWxW6FcrYQTBzAG/tDJ4sGmZZw9LM+XsRM+tu8dE63Gl36Hx
         753SwF31SNLYu0cgRlTo5uytPfeWmJdx4GLDB6fB1s4cemYIVR/NYa7tQspiPWNZ3l
         6MWVzOJku32KjqbeC8MgBs01h5rXkczd+PUJa9mLOT8h/pm25N6IzAaK1BkFQruiQ7
         d0H5ljLlguv5OOnY4jywm9I9Y5eDTDIOtHDAT33KTt1D2W3w2DUrSl4WcCXFRJX3Iu
         Q26wqbiqQic0g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grant Grundler <grundler@chromium.org>,
        Aashay Shringarpure <aashay@google.com>,
        Yi Chou <yich@google.com>,
        Shervin Oloumi <enlightened@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, irusskikh@marvell.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 12/17] net: atlantic: fix "frag[0] not initialized"
Date:   Wed, 18 May 2022 08:27:46 -0400
Message-Id: <20220518122753.342758-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122753.342758-1-sashal@kernel.org>
References: <20220518122753.342758-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grant Grundler <grundler@chromium.org>

[ Upstream commit 62e0ae0f4020250f961cf8d0103a4621be74e077 ]

In aq_ring_rx_clean(), if buff->is_eop is not set AND
buff->len < AQ_CFG_RX_HDR_SIZE, then hdr_len remains equal to
buff->len and skb_add_rx_frag(xxx, *0*, ...) is not called.

The loop following this code starts calling skb_add_rx_frag() starting
with i=1 and thus frag[0] is never initialized. Since i is initialized
to zero at the top of the primary loop, we can just reference and
post-increment i instead of hardcoding the 0 when calling
skb_add_rx_frag() the first time.

Reported-by: Aashay Shringarpure <aashay@google.com>
Reported-by: Yi Chou <yich@google.com>
Reported-by: Shervin Oloumi <enlightened@google.com>
Signed-off-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 72f8751784c3..7cf5a48e9a7d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -445,7 +445,7 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 		       ALIGN(hdr_len, sizeof(long)));
 
 		if (buff->len - hdr_len > 0) {
-			skb_add_rx_frag(skb, 0, buff->rxdata.page,
+			skb_add_rx_frag(skb, i++, buff->rxdata.page,
 					buff->rxdata.pg_off + hdr_len,
 					buff->len - hdr_len,
 					AQ_CFG_RX_FRAME_MAX);
@@ -454,7 +454,6 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 
 		if (!buff->is_eop) {
 			buff_ = buff;
-			i = 1U;
 			do {
 				next_ = buff_->next;
 				buff_ = &self->buff_ring[next_];
-- 
2.35.1

