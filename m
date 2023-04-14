Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A78E6E2334
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 14:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbjDNM1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 08:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjDNM1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 08:27:04 -0400
X-Greylist: delayed 140 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 14 Apr 2023 05:27:01 PDT
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [20.228.234.168])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 89B9F1BEA;
        Fri, 14 Apr 2023 05:27:01 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [218.12.19.98])
        by mail-app3 (Coremail) with SMTP id cC_KCgCHwgFyRjlkR70BAA--.3418S2;
        Fri, 14 Apr 2023 20:26:35 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     rajur@chelsio.com, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net] cxgb4: fix use after free bugs caused by circular dependency problem
Date:   Fri, 14 Apr 2023 20:26:21 +0800
Message-Id: <20230414122621.68269-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cC_KCgCHwgFyRjlkR70BAA--.3418S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar48CF1fWr18Ar1fuF4kWFg_yoW8ZFW5pr
        s3Zr9rJw48Xa1UtF4UXw4ktFyqk3Z5trZ8KF1fG3yfu3Z7AFnIkFyDKay8WFW5JFW8Ar9r
        Aw48Zr98GFZYk3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvm14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
        JF0_Jw1lc2xSY4AK67AK6ryUMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r
        4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
        67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
        x0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2
        z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnU
        UI43ZEXa7VUjpnQUUUUUU==
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAwMFAWQ4GlouNgAdsd
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The flower_stats_timer can schedule flower_stats_work and
flower_stats_work can also arm the flower_stats_timer. The
process is shown below:

----------- timer schedules work ------------
ch_flower_stats_cb() //timer handler
  schedule_work(&adap->flower_stats_work);

----------- work arms timer ------------
ch_flower_stats_handler() //workqueue callback function
  mod_timer(&adap->flower_stats_timer, ...);

When the cxgb4 device is detaching, the timer and workqueue
could still be rearmed. The process is shown below:

  (cleanup routine)           | (timer and workqueue routine)
remove_one()                  |
  free_some_resources()       | ch_flower_stats_cb() //timer
    cxgb4_cleanup_tc_flower() |   schedule_work()
      del_timer_sync()        |
                              | ch_flower_stats_handler() //workqueue
                              |   mod_timer()
      cancel_work_sync()      |
  kfree(adapter) //FREE       | ch_flower_stats_cb() //timer
                              |   adap->flower_stats_work //USE

This patch changes del_timer_sync() to timer_shutdown_sync(),
which could prevent rearming of the timer from the workqueue.

Fixes: e0f911c81e93 ("cxgb4: fetch stats for offloaded tc flower flows")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index dd9be229819..d3541159487 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -1135,7 +1135,7 @@ void cxgb4_cleanup_tc_flower(struct adapter *adap)
 		return;
 
 	if (adap->flower_stats_timer.function)
-		del_timer_sync(&adap->flower_stats_timer);
+		timer_shutdown_sync(&adap->flower_stats_timer);
 	cancel_work_sync(&adap->flower_stats_work);
 	rhashtable_destroy(&adap->flower_tbl);
 	adap->tc_flower_initialized = false;
-- 
2.17.1

