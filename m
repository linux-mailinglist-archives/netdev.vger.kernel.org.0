Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 599296EC6A3
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 08:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjDXG71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 02:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjDXG7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 02:59:25 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8490A10C;
        Sun, 23 Apr 2023 23:59:23 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 2BEFA6015E;
        Mon, 24 Apr 2023 08:59:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1682319560; bh=3tO6EbVQ8z0eptUMkn2/s5yOHPojDse+yfFlAtWzSHk=;
        h=From:To:Cc:Subject:Date:From;
        b=FgKxJXCqkW1O6MaQ9mOkf4fXsDK9sZvESxDfHqsE86G2edqmRxGMdNoRo/Ww1Zi3n
         1cPgFnejWV55P6EEKDk/6jytmh72sJzaAnpNXg+JUePBJRef7ajxv7r0qcDCsj+wzk
         dmAf4321PPMLARQpOtxgxEFh+nBIqjzq/ByIkdpbZAbraAbkEra4EW4ka2YqyxxcJZ
         HCYkKPohQ1gCd+we0IB025648EKcgENuEUwFM1rAbZQqWmQ/1EGC7NYuhEjwjVAeor
         HA3CN8QtVH2N4UQFhg22iVWCWyb6BIRS1kyi3nz2a0JFYTIIKs6YZrhQhyknQexPRj
         17O0w/9ZPmrzQ==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id VDsNyFfa392k; Mon, 24 Apr 2023 08:59:17 +0200 (CEST)
Received: by domac.alu.hr (Postfix, from userid 1014)
        id 998B86015F; Mon, 24 Apr 2023 08:59:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1682319557; bh=3tO6EbVQ8z0eptUMkn2/s5yOHPojDse+yfFlAtWzSHk=;
        h=From:To:Cc:Subject:Date:From;
        b=jt3vC/JeoOa4aKnvVNMGQ7v6xDQIlMRJb7LF8NLKu6L+x8YbIrnKKitxKew5iJ39q
         fQmdjVueQTVFADdgESxNkzgvPb1sTWouH7CzwiKnneCzpoh8x9sHUXFeH6J9QHAiz5
         6+ZLofUskV6UvMzj4gLFblNqlUDF8zJ/a2z0XXN+8eSyvQAbbw1/K16OlEdvJY8AJh
         Jub0zMblyHjgDRI/1SYNN8GVKHPoDzuc4EH8BPEYvcHc7gLA5CMOLR6O9wNARXw8hb
         hB32HL0GZJsZNJ/FDJz00JbhTKiWllXtiKu3QTtcgi1gjATpWcU0js3c5pAu2pknOq
         uo5LGrn/kq+kg==
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
Subject: [PATCH RFC v2 1/1] net: mac80211: fortify the spinlock against deadlock by interrupt
Date:   Mon, 24 Apr 2023 08:44:01 +0200
Message-Id: <20230424064359.45219-1-mirsad.todorovac@alu.unizg.hr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
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

Fixes: 4444bc2116ae
Link: https://lore.kernel.org/all/1f58a0d1-d2b9-d851-73c3-93fcc607501c@alu.unizg.hr/
Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc: Gregory Greenman <gregory.greenman@intel.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Alexander Wetzel <alexander@wetzel-home.de>
Signed-off-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
---
v2:
Minor rewording and clarification.
Cc:-ed people that replied to the original bug report (forgot in v1 by omission).

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

