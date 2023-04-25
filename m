Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3714D6EDFAA
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 11:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbjDYJsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 05:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232430AbjDYJsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 05:48:17 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [IPv6:2001:b68:2:2800::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CCA12CB5;
        Tue, 25 Apr 2023 02:47:31 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id CE1ED6015F;
        Tue, 25 Apr 2023 11:47:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1682416047; bh=7yxZu0Emw84OkpuQ1sf7+2iZskuUnjHQc2X91hkquQk=;
        h=From:To:Cc:Subject:Date:From;
        b=lDwrjC9y6XA+afif1yRsJfJyDjHdXFCI3Dm/AQhg0VQZZtQHpTvyiBK42GVO+Yiv3
         JBpl7TEa72NPqEYnfBdm/svg/pWCsb2FhBX4Ntx6mLeoq7tigAMdQ+5rwvy4q8rmih
         GDBLuq3+37SkjpG2RYX8HkaRHkGR+V1i55KF+Afn9GMQManB6uLk2MiNm/6QWChTgv
         cf9RWn7k8lViMmykbOHt7Pz/gKkCzgG2SuqkwhBcawq5uDJkOwjR8FacBhv4TAaBIt
         1HKhhvwRokEIxxcZoTheO5IReWmQZxlXFszJHEKBkjlbEULjGld9f1nHUo1pcH2NDU
         g7AMePdnl7VZA==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id b8MUtoYMLe1w; Tue, 25 Apr 2023 11:47:23 +0200 (CEST)
Received: by domac.alu.hr (Postfix, from userid 1014)
        id 3740E60161; Tue, 25 Apr 2023 11:47:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1682416043; bh=7yxZu0Emw84OkpuQ1sf7+2iZskuUnjHQc2X91hkquQk=;
        h=From:To:Cc:Subject:Date:From;
        b=0EKZlnKR9EENnvvgBisYAiHjccl97DjOFMDo+IabYY33VrmZO3GXb60JDOGIROqlE
         +2mT+7CVlbEkSQKVT4reqcZy7CB+usY5Xtk/5tox2oyIz5/ebIoaSn35MELBDJzDno
         Ps10tb1UIu2nLrYmZA43QuNSPBQHMC6ujD7ANFJ+SkSujt2+N4WbZ59FZ5xcobG/eM
         7uxLOxUHxonJrlhC+hIRU208KHWU5PVF6u7KMV6L4lydNjwNkS21UUb0FzHtfFtZZx
         OUnLwn2PrrlOeczdzG38ipG1S75Bm6UQXsYsz5TQN74LI4fedNyfy30tMBAaYUJvWe
         wR/38vLKq8SyA==
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
To:     Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [PATCH v3 1/1] wifi: mac80211: fortify the spinlock against deadlock by interrupt
Date:   Tue, 25 Apr 2023 11:35:48 +0200
Message-Id: <20230425093547.1131-1-mirsad.todorovac@alu.unizg.hr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the function ieee80211_tx_dequeue() there is a particular locking
sequence:

begin:
	spin_lock(&local->queue_stop_reason_lock);
	q_stopped = local->queue_stop_reasons[q];
	spin_unlock(&local->queue_stop_reason_lock);

However small the chance (increased by ftracetest), an asynchronous
interrupt can occur in between of spin_lock() and spin_unlock(),
and the interrupt routine will attempt to lock the same
&local->queue_stop_reason_lock again.

This will cause a costly reset of the CPU and the wifi device or an
altogether hang in the single CPU and single core scenario.

This is the probable trace of the deadlock:

Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  Possible unsafe locking scenario:
Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:        CPU0
Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:        ----
Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:   lock(&local->queue_stop_reason_lock);
Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:   <Interrupt>
Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:     lock(&local->queue_stop_reason_lock);
Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:
                                                 *** DEADLOCK ***

Fixes: 4444bc2116ae ("wifi: mac80211: Proper mark iTXQs for resumption")
Link: https://lore.kernel.org/all/1f58a0d1-d2b9-d851-73c3-93fcc607501c@alu.unizg.hr/
Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc: Gregory Greenman <gregory.greenman@intel.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/all/cdc80531-f25f-6f9d-b15f-25e16130b53a@alu.unizg.hr/
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Alexander Wetzel <alexander@wetzel-home.de>
Signed-off-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
---
v2 -> v3:
- Fix the Fixes: tag as advised.
- change the net: to wifi: to comply with the original patch that
  is being fixed.
v1 -> v2:
- Minor rewording and clarification.
- Cc:-ed people that replied to the original bug report (forgotten
  in v1 by omission).

 net/mac80211/tx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7699fb410670..45cb8e7bcc61 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3781,6 +3781,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	ieee80211_tx_result r;
 	struct ieee80211_vif *vif = txq->vif;
 	int q = vif->hw_queue[txq->ac];
+	unsigned long flags;
 	bool q_stopped;
 
 	WARN_ON_ONCE(softirq_count() == 0);
@@ -3789,9 +3790,9 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 		return NULL;
 
 begin:
-	spin_lock(&local->queue_stop_reason_lock);
+	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 	q_stopped = local->queue_stop_reasons[q];
-	spin_unlock(&local->queue_stop_reason_lock);
+	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 
 	if (unlikely(q_stopped)) {
 		/* mark for waking later */
-- 
2.30.2

