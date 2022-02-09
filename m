Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB2E4AFBDD
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 19:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241682AbiBISvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 13:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241125AbiBISuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 13:50:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7999AC0045D0;
        Wed,  9 Feb 2022 10:45:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26384B82378;
        Wed,  9 Feb 2022 18:45:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F62C340E7;
        Wed,  9 Feb 2022 18:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644432353;
        bh=a9EQqjP8Moh9UJFD7jPKklyh82183AP2lb4+Dlz/juE=;
        h=From:To:Cc:Subject:Date:From;
        b=DsUE9Oiq/O1rT5aRp+zm7WPQwMqi+JLsq50k7i4qijrTNVc6FOJSnlqzbq/IiI6c/
         l+vPlRfh3WwcaxhD3IdLZtimkoPsCDZ8pKeLM1jDLCuN8u6fIVgqtPLA94b8guyybF
         y+acc/4qk/AgeSJI5exw2b6q5wmwcggzr0GB4zPaLyifZ8wbxXACO/8ylGKqDrzt8f
         RxZPyJ82xRw8mORYmvSYj9vLLw5F78FhsrxGzWx/X7NXAuyHKmS4tJJtTm7Dvfg2ev
         Fl3VDpZ8E4a7vmaoDHHmY1im4q6gMiY4YsTBf4y+noLlm5in/oDfqv/TlDXsY3/k7j
         4Xm/3Q2bkDGQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 1/7] net: ieee802154: at86rf230: Stop leaking skb's
Date:   Wed,  9 Feb 2022 13:45:44 -0500
Message-Id: <20220209184550.48481-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
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
index ce3b7fb7eda09..80c8e9abb402e 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -108,6 +108,7 @@ struct at86rf230_local {
 	unsigned long cal_timeout;
 	bool is_tx;
 	bool is_tx_from_off;
+	bool was_tx;
 	u8 tx_retry;
 	struct sk_buff *tx_skb;
 	struct at86rf230_state_change tx;
@@ -351,7 +352,11 @@ at86rf230_async_error_recover_complete(void *context)
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
@@ -360,7 +365,11 @@ at86rf230_async_error_recover(void *context)
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

