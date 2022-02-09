Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D614AFA1A
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 19:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239443AbiBISei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 13:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238559AbiBISeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 13:34:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D35C05CB82;
        Wed,  9 Feb 2022 10:34:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9541361C2E;
        Wed,  9 Feb 2022 18:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC76C340ED;
        Wed,  9 Feb 2022 18:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644431678;
        bh=VIQquFzGDHKbKcmGm6RKoojybnkJGoVldTQZYNSMAJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ay5hcCABTP76R8059701L4gYnD9mQLChW31po+xx6ARpmUs1CsCkCFwdkuZdiLCUV
         4QV5EYbz8dpn3y7NtE3aB+8XMWMWYImCQacaSRqc+hXmACPOoUAffz1tXp7hWLYxJx
         rTQLXKIxaGpRl5MEenaq0NNLwlS2do2ef/rTlnS4vl1mUGYMMHbsjp0sXb3vm+MIZP
         WdBsO9YBZRn+LT9wkGQp7QHkYY8SFStBVBuUQfQ4c9+UTes+K/gv93CGAkdrvxBkG+
         ei5oiY5SVrZ9cLmGEFn6iPt2E6fFhs67bpvpS6syTBCzXBMGICVlbIA/Rinkh84vuL
         TtAiRvEZg0jGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 10/42] net: ieee802154: at86rf230: Stop leaking skb's
Date:   Wed,  9 Feb 2022 13:32:42 -0500
Message-Id: <20220209183335.46545-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209183335.46545-1-sashal@kernel.org>
References: <20220209183335.46545-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit e5ce576d45bf72fd0e3dc37eff897bfcc488f6a9 ]

Upon error the ieee802154_xmit_complete() helper is not called. Only
ieee802154_wake_queue() is called manually. In the Tx case we then leak
the skb structure.

Free the skb structure upon error before returning when appropriate.

As the 'is_tx = 0' cannot be moved in the complete handler because of a
possible race between the delay in switching to STATE_RX_AACK_ON and a
new interrupt, we introduce an intermediate 'was_tx' boolean just for
this purpose.

There is no Fixes tag applying here, many changes have been made on this
area and the issue kind of always existed.

Suggested-by: Alexander Aring <alex.aring@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Acked-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20220125121426.848337-4-miquel.raynal@bootlin.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/at86rf230.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index 7d67f41387f55..4f5ef8a9a9a87 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -100,6 +100,7 @@ struct at86rf230_local {
 	unsigned long cal_timeout;
 	bool is_tx;
 	bool is_tx_from_off;
+	bool was_tx;
 	u8 tx_retry;
 	struct sk_buff *tx_skb;
 	struct at86rf230_state_change tx;
@@ -343,7 +344,11 @@ at86rf230_async_error_recover_complete(void *context)
 	if (ctx->free)
 		kfree(ctx);
 
-	ieee802154_wake_queue(lp->hw);
+	if (lp->was_tx) {
+		lp->was_tx = 0;
+		dev_kfree_skb_any(lp->tx_skb);
+		ieee802154_wake_queue(lp->hw);
+	}
 }
 
 static void
@@ -352,7 +357,11 @@ at86rf230_async_error_recover(void *context)
 	struct at86rf230_state_change *ctx = context;
 	struct at86rf230_local *lp = ctx->lp;
 
-	lp->is_tx = 0;
+	if (lp->is_tx) {
+		lp->was_tx = 1;
+		lp->is_tx = 0;
+	}
+
 	at86rf230_async_state_change(lp, ctx, STATE_RX_AACK_ON,
 				     at86rf230_async_error_recover_complete);
 }
-- 
2.34.1

