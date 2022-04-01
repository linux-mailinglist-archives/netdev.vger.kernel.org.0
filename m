Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADEA4EF0E6
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347882AbiDAOgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347633AbiDAOdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:33:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6622F25664E;
        Fri,  1 Apr 2022 07:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D636B8240E;
        Fri,  1 Apr 2022 14:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D23BC36AF8;
        Fri,  1 Apr 2022 14:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823418;
        bh=fClYw0h0vjp076jfaNI0Hj1eCWF7x7bOsKy8xtc1bWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YTN7GacEnXpcROdzZf+e2Cc9r8fgr+BbqEfy2dQRMqpNUfRo9xPB0KLYXqWOynsLA
         5syYGH/pGx7PfaRmOWqSkXT+AZoxsRgNBSugkLmUBvW1cOr3555EKd/NpZNrx7178A
         j2GLnLAGziM+ViOJdVQ9owm2/rwo5JCCbrOwIXX4dkhfmlBA3LE+Wygoo196lArg3+
         a4kydj68wtsoPr4/gINqRc0QXbRbfH+1vvgvbuMnWYVr7QbDkv6LiksGxFvqplRz+j
         21XaIUZKddBN678baG6AoyfCsfXRXcSsZKt5RbAhVYU/h8dmKOKyp5Kf/Gfp3gVJMV
         JxMkP0J1JYocA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Kosina <jkosina@suse.cz>, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 085/149] rtw89: fix RCU usage in rtw89_core_txq_push()
Date:   Fri,  1 Apr 2022 10:24:32 -0400
Message-Id: <20220401142536.1948161-85-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
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

From: Jiri Kosina <jkosina@suse.cz>

[ Upstream commit f3d825a35920714fb7f73e4d4f36ea2328860660 ]

ieee80211_tx_h_select_key() is performing a series of RCU dereferences,
but rtw89_core_txq_push() is calling it (via ieee80211_tx_dequeue_ni())
without RCU read-side lock held; fix that.

This addresses the splat below.

 =============================
 WARNING: suspicious RCU usage
 5.17.0-rc4-00003-gccad664b7f14 #3 Tainted: G            E
 -----------------------------
 net/mac80211/tx.c:593 suspicious rcu_dereference_check() usage!

 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 2 locks held by kworker/u33:0/184:
  #0: ffff9c0b14811d38 ((wq_completion)rtw89_tx_wq){+.+.}-{0:0}, at: process_one_work+0x258/0x660
  #1: ffffb97380cf3e78 ((work_completion)(&rtwdev->txq_work)){+.+.}-{0:0}, at: process_one_work+0x258/0x660

 stack backtrace:
 CPU: 8 PID: 184 Comm: kworker/u33:0 Tainted: G            E     5.17.0-rc4-00003-gccad664b7f14 #3 473b49ab0e7c2d6af2900c756bfd04efd7a9de13
 Hardware name: LENOVO 20UJS2B905/20UJS2B905, BIOS R1CET63W(1.32 ) 04/09/2021
 Workqueue: rtw89_tx_wq rtw89_core_txq_work [rtw89_core]
 Call Trace:
  <TASK>
  dump_stack_lvl+0x58/0x71
  ieee80211_tx_h_select_key+0x2c0/0x530 [mac80211 911c23e2351c0ae60b597a67b1204a5ea955e365]
  ieee80211_tx_dequeue+0x1a7/0x1260 [mac80211 911c23e2351c0ae60b597a67b1204a5ea955e365]
  rtw89_core_txq_work+0x1a6/0x420 [rtw89_core b39ba493f2e517ad75e0f8187ecc24edf58bbbea]
  process_one_work+0x2d8/0x660
  worker_thread+0x39/0x3e0
  ? process_one_work+0x660/0x660
  kthread+0xe5/0x110
  ? kthread_complete_and_exit+0x20/0x20
  ret_from_fork+0x22/0x30
  </TASK>

 =============================
 WARNING: suspicious RCU usage
 5.17.0-rc4-00003-gccad664b7f14 #3 Tainted: G            E
 -----------------------------
 net/mac80211/tx.c:607 suspicious rcu_dereference_check() usage!

 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 2 locks held by kworker/u33:0/184:
  #0: ffff9c0b14811d38 ((wq_completion)rtw89_tx_wq){+.+.}-{0:0}, at: process_one_work+0x258/0x660
  #1: ffffb97380cf3e78 ((work_completion)(&rtwdev->txq_work)){+.+.}-{0:0}, at: process_one_work+0x258/0x660

 stack backtrace:
 CPU: 8 PID: 184 Comm: kworker/u33:0 Tainted: G            E     5.17.0-rc4-00003-gccad664b7f14 #3 473b49ab0e7c2d6af2900c756bfd04efd7a9de13
 Hardware name: LENOVO 20UJS2B905/20UJS2B905, BIOS R1CET63W(1.32 ) 04/09/2021
 Workqueue: rtw89_tx_wq rtw89_core_txq_work [rtw89_core]
 Call Trace:
  <TASK>
  dump_stack_lvl+0x58/0x71
  ieee80211_tx_h_select_key+0x464/0x530 [mac80211 911c23e2351c0ae60b597a67b1204a5ea955e365]
  ieee80211_tx_dequeue+0x1a7/0x1260 [mac80211 911c23e2351c0ae60b597a67b1204a5ea955e365]
  rtw89_core_txq_work+0x1a6/0x420 [rtw89_core b39ba493f2e517ad75e0f8187ecc24edf58bbbea]
  process_one_work+0x2d8/0x660
  worker_thread+0x39/0x3e0
  ? process_one_work+0x660/0x660
  kthread+0xe5/0x110
  ? kthread_complete_and_exit+0x20/0x20
  ret_from_fork+0x22/0x30
  </TASK>

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/nycvar.YFH.7.76.2202152037000.11721@cbobk.fhfr.pm
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index a0737eea9f81..9632e7f218dd 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -1509,11 +1509,12 @@ static void rtw89_core_txq_push(struct rtw89_dev *rtwdev,
 	unsigned long i;
 	int ret;
 
+	rcu_read_lock();
 	for (i = 0; i < frame_cnt; i++) {
 		skb = ieee80211_tx_dequeue_ni(rtwdev->hw, txq);
 		if (!skb) {
 			rtw89_debug(rtwdev, RTW89_DBG_TXRX, "dequeue a NULL skb\n");
-			return;
+			goto out;
 		}
 		rtw89_core_txq_check_agg(rtwdev, rtwtxq, skb);
 		ret = rtw89_core_tx_write(rtwdev, vif, sta, skb, NULL);
@@ -1523,6 +1524,8 @@ static void rtw89_core_txq_push(struct rtw89_dev *rtwdev,
 			break;
 		}
 	}
+out:
+	rcu_read_unlock();
 }
 
 static u32 rtw89_check_and_reclaim_tx_resource(struct rtw89_dev *rtwdev, u8 tid)
-- 
2.34.1

