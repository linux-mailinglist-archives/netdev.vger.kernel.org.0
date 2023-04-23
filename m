Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16D306EBE10
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 10:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjDWIkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 04:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDWIka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 04:40:30 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A6D1BC2;
        Sun, 23 Apr 2023 01:40:28 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id CD7696015E;
        Sun, 23 Apr 2023 10:40:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1682239225; bh=NrrlTJuO2WOxeh84ut/e47TmcJC+8c5WzWqQwG1PyZM=;
        h=From:To:Cc:Subject:Date:From;
        b=wGp+Td+o+UT/S6x13KMiwr0evq+FpgQ35SnO8axIUu1KndCG36ab4g5H1X4Epe3X5
         6iOrEGvFXGj9f7rf24cu1DQAZILmvknxsGVUI0Zxlc14EjNvaGVEWorFC9toty2Ptq
         EwE8KW2hnmkpIYqu1n+HTfz5YeyvhvOCE1UCzuPxH3/SvbKzCao5yTWqJbJ3OqoVOE
         ta1429MrqTlEilYvh5OCUJWYispnfe8OKkB/ZALFSRhdXiPWTBGzma4uoS+VheP5/j
         pu0wqE0xul5MA3/5vJ14wr3Hc//4rURDTsgGsiwM6bl24cooj3dRi/yQ1ZhflHlH2v
         DMUTbw9U2/6cA==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2RCTnkPxMSfa; Sun, 23 Apr 2023 10:40:22 +0200 (CEST)
Received: by domac.alu.hr (Postfix, from userid 1014)
        id 3B93C6015F; Sun, 23 Apr 2023 10:40:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1682239222; bh=NrrlTJuO2WOxeh84ut/e47TmcJC+8c5WzWqQwG1PyZM=;
        h=From:To:Cc:Subject:Date:From;
        b=h6uu9H21cv/CQb7i/w6iaZiCtnHDd6k/JZ+kg3zkyo1LktTCzrRay48eAqqhjYPQ6
         RAQf+ap1wI8HeWv8va3hg/gja8U0bd+SpzUc1mwbr36D1q4DO51T7VG9qNA74jzASw
         k7FpCRsZYQEMzpAwLz8Asf/vIGPtUvKOxOUPLZJUtqdxQ7KjzNbOlgf7eREPpR6ntb
         Flg8d1UDCPNnoh2bVgZzp4cwO0KLOUaNFb30Cp6iwKZffA0XPcvYAsOvBkDlNUDgCR
         DgEGflKgN0lXN0aY4Mt5Koh/SIFr6/FMc1SzHnfwBS/fJLDaW6X5PvgsITHiV7zJRB
         vvby6RT8r9xkQ==
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
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [PATCH RFC v1 1/1] net: mac80211: fortify the spinlock against deadlock in interrupt
Date:   Sun, 23 Apr 2023 10:24:05 +0200
Message-Id: <20230423082403.49143-1-mirsad.todorovac@alu.unizg.hr>
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

In the function ieee80211_tx_dequeue() there is a locking sequence:

begin:
	spin_lock(&local->queue_stop_reason_lock);
	q_stopped = local->queue_stop_reasons[q];
	spin_unlock(&local->queue_stop_reason_lock);

However small the chance (increased by ftracetest), an asynchronous
interrupt can occur in between of spin_lock() and spin_unlock(),
and the interrupt routine will attempt to lock the same
&local->queue_stop_reason_lock again.

This is the only remaining spin_lock() on local->queue_stop_reason_lock
that did not disable interrupts and could have possibly caused the deadlock
on the same CPU (core).

This will cause a costly reset of the CPU and wifi device or an
altogether hang in the single CPU and single core scenario.

This is the probable reproduce of the deadlock:

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
Cc: Alexander Wetzel <alexander@wetzel-home.de>
Signed-off-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
---
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

