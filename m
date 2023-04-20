Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99EE16E968B
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbjDTODL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbjDTODI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:03:08 -0400
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [20.228.234.168])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9BDA49DE
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 07:03:05 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [218.12.18.95])
        by mail-app3 (Coremail) with SMTP id cC_KCgDn7w_XRUFkQSOLAA--.3844S2;
        Thu, 20 Apr 2023 22:02:12 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        intel-wired-lan@lists.osuosl.org, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net] ethernet: ixgb: fix use after free bugs caused by circular dependency problem
Date:   Thu, 20 Apr 2023 22:01:57 +0800
Message-Id: <20230420140157.22416-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cC_KCgDn7w_XRUFkQSOLAA--.3844S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar17Xr4fWF48CF17Cw1rZwb_yoW8Ar13p3
        ySva4fJF10qr4YvFyxXr1kJFyrGas7ArWkKF1xCw4ru3Z7ArnYgr9Ykry0gFyrGFZ8ZF43
        AF1F93y5CwnxAwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
        Y2ka0xkIwI1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
        xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
        MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
        0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
        JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHU
        DUUUUU=
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAwMLAWRAA1s8WwAwsh
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The watchdog_timer can schedule tx_timeout_task and tx_timeout_task
can also arm watchdog_timer. The process is shown below:

----------- timer schedules work ------------
ixgb_watchdog() //timer handler
  schedule_work(&adapter->tx_timeout_task)

----------- work arms timer ------------
ixgb_tx_timeout_task() //workqueue callback function
  ixgb_up()
    mod_timer(&adapter->watchdog_timer,...)

When ixgb device is detaching, the timer and workqueue
could still be rearmed. The process is shown below:

  (cleanup routine)           |  (timer and workqueue routine)
ixgb_remove()                 |
                              | ixgb_tx_timeout_task() //workqueue
                              |   ixgb_up()
                              |     mod_timer()
  cancel_work_sync()          |
  free_netdev(netdev) //FREE  | ixgb_watchdog() //timer
                              |   netif_carrier_ok(netdev) //USE

This patch adds timer_shutdown_sync() in ixgb_remove(), which
could prevent rearming of the timer from the workqueue.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 drivers/net/ethernet/intel/ixgb/ixgb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index b4d47e7a76c..6ce3601904b 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -516,6 +516,7 @@ ixgb_remove(struct pci_dev *pdev)
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct ixgb_adapter *adapter = netdev_priv(netdev);
 
+	timer_shutdown_sync(&adapter->watchdog_timer);
 	cancel_work_sync(&adapter->tx_timeout_task);
 
 	unregister_netdev(netdev);
-- 
2.17.1

