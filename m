Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE1D134F36
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgAHV73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:59:29 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:47029 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726390AbgAHV70 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 16:59:26 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id d72a25a0;
        Wed, 8 Jan 2020 21:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=z7T7sTA5oRZMsD0geCtnpKcFR
        l0=; b=hpc7Fie2XGfKrGbG1NaHWuP3zeV0UnDRgjunH4BOVL5tO2reT4ulVNGjo
        sYEIYd2rRpnWdyDW3xUAjJUswJMuClb8aosgFU/WMVFQFyWJoz6l0HyEiNYf61Zf
        cYSZHUHdOnQnC85M4CuHopx9BAMSztaGMN+sDYRpt6gIyAlXzX+SfNx9dXoiTWtz
        /eispTu4j2IwqA0fPue9KcH34ZX+Tbf8aO0h7Aw5/MDse/zMAn0acvz1M6cuEdAE
        71tiNBgxLwcdD4MEmvpLNMYUN44BC+veH8gYd9CuJQtoJpTK05iHyL3T25hWIK1R
        wgRywNSvbFEmg7OsYyddPnFPQFjfg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6c5895cb (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Wed, 8 Jan 2020 21:00:02 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net,
        siva.kallam@broadcom.com, christopher.lee@cspi.com,
        ecree@solarflare.com, johannes.berg@intel.com
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4/8] net: tg3: use skb_list_walk_safe helper for gso segments
Date:   Wed,  8 Jan 2020 16:59:05 -0500
Message-Id: <20200108215909.421487-5-Jason@zx2c4.com>
In-Reply-To: <20200108215909.421487-1-Jason@zx2c4.com>
References: <20200108215909.421487-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a straight-forward conversion case for the new function, and
while we're at it, we can remove a null write to skb->next by replacing
it with skb_mark_not_on_list.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 460b4992914a..88466255bf66 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -7874,8 +7874,8 @@ static netdev_tx_t tg3_start_xmit(struct sk_buff *, struct net_device *);
 static int tg3_tso_bug(struct tg3 *tp, struct tg3_napi *tnapi,
 		       struct netdev_queue *txq, struct sk_buff *skb)
 {
-	struct sk_buff *segs, *nskb;
 	u32 frag_cnt_est = skb_shinfo(skb)->gso_segs * 3;
+	struct sk_buff *segs, *seg, *next;
 
 	/* Estimate the number of fragments in the worst case */
 	if (unlikely(tg3_tx_avail(tnapi) <= frag_cnt_est)) {
@@ -7898,12 +7898,10 @@ static int tg3_tso_bug(struct tg3 *tp, struct tg3_napi *tnapi,
 	if (IS_ERR(segs) || !segs)
 		goto tg3_tso_bug_end;
 
-	do {
-		nskb = segs;
-		segs = segs->next;
-		nskb->next = NULL;
-		tg3_start_xmit(nskb, tp->dev);
-	} while (segs);
+	skb_list_walk_safe(segs, seg, next) {
+		skb_mark_not_on_list(seg);
+		tg3_start_xmit(seg, tp->dev);
+	}
 
 tg3_tso_bug_end:
 	dev_consume_skb_any(skb);
-- 
2.24.1

