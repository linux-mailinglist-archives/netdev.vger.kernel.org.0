Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD16530359
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 15:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345868AbiEVNbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 09:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234645AbiEVNbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 09:31:22 -0400
Received: from azure-sdnproxy-2.icoremail.net (azure-sdnproxy.icoremail.net [52.175.55.52])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 99BF465E6;
        Sun, 22 May 2022 06:31:16 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [124.236.130.193])
        by mail-app3 (Coremail) with SMTP id cC_KCgDnXk4QO4pixPeoAA--.22593S2;
        Sun, 22 May 2022 21:31:04 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-wireless@vger.kernel.org
Cc:     pontus.fuchs@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH wireless] ar5523: Fix deadlock bugs caused by cancel_work_sync in ar5523_stop
Date:   Sun, 22 May 2022 21:30:55 +0800
Message-Id: <20220522133055.96405-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cC_KCgDnXk4QO4pixPeoAA--.22593S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Cr1DWry8WFyrAr13WrWDCFg_yoW8Xr1xpF
        4F9rW7WFW8AFWjq3yDXF4fZ3WrG3ZrKF12kr13Wws5uFZ3J3WaqF1jkFyIgr1vvrW7Xaya
        vF47ZrWfZ3WY9r7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
        Y2ka0xkIwI1lc2xSY4AK67AK6ry8MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
        1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
        b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
        vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
        cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa
        73UjIFyTuYvjfUnpnQUUUUU
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgQSAVZdtZ0PcQAIsA
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the work item is running, the cancel_work_sync in ar5523_stop will
not return until work item is finished. If we hold mutex_lock and use
cancel_work_sync to wait the work item to finish, the work item such as
ar5523_tx_wd_work and ar5523_tx_work also require mutex_lock. As a result,
the ar5523_stop will be blocked forever. One of the race conditions is
shown below:

    (Thread 1)             |   (Thread 2)
ar5523_stop                |
  mutex_lock(&ar->mutex)   | ar5523_tx_wd_work
                           |   mutex_lock(&ar->mutex)
  cancel_work_sync         |   ...

This patch moves cancel_work_sync out of mutex_lock in order to mitigate
deadlock bugs.

Fixes: b7d572e1871d ("ar5523: Add new driver")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 drivers/net/wireless/ath/ar5523/ar5523.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 9cabd342d15..99d6b13ffcf 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -1071,8 +1071,10 @@ static void ar5523_stop(struct ieee80211_hw *hw)
 	ar5523_cmd_write(ar, WDCMSG_TARGET_STOP, NULL, 0, 0);
 
 	del_timer_sync(&ar->tx_wd_timer);
+	mutex_unlock(&ar->mutex);
 	cancel_work_sync(&ar->tx_wd_work);
 	cancel_work_sync(&ar->rx_refill_work);
+	mutex_lock(&ar->mutex);
 	ar5523_cancel_rx_bufs(ar);
 	mutex_unlock(&ar->mutex);
 }
-- 
2.17.1

