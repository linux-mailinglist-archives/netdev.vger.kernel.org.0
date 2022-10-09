Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B0A5F89BA
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 08:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiJIGnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 02:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiJIGnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 02:43:51 -0400
X-Greylist: delayed 345 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 08 Oct 2022 23:43:49 PDT
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [20.232.28.96])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 555B73206C
        for <netdev@vger.kernel.org>; Sat,  8 Oct 2022 23:43:49 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [211.90.237.214])
        by mail-app2 (Coremail) with SMTP id by_KCgBXCWosbEJjh9O9Bg--.26141S2;
        Sun, 09 Oct 2022 14:37:41 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-kernel@vger.kernel.org
Cc:     isdn@linux-pingi.de, kuba@kernel.org, andrii@kernel.org,
        gregkh@linuxfoundation.org, axboe@kernel.dk, davem@davemloft.net,
        netdev@vger.kernel.org, zou_wei@huawei.com,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH] mISDN: hfcpci: Fix use-after-free bug in hfcpci_softirq
Date:   Sun,  9 Oct 2022 14:37:31 +0800
Message-Id: <20221009063731.22733-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: by_KCgBXCWosbEJjh9O9Bg--.26141S2
X-Coremail-Antispam: 1UD129KBjvJXoW7WF1UWr43Xr4xurWUWw4Durg_yoW8XFy8pa
        y5GFyIyr4rZa10kr48X3WDZF95Za1kArW0kF1kGw13Z3Z8XFy5tr1UtryvvFW5GrZ0gF9F
        yF48XFWfGFs8AFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
        JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCY02Avz4vE14v_GF1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
        0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
        17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
        C0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
        6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvj
        DU0xZFpf9x0JU-J5rUUUUU=
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgYSAVZdtb0jdQAGsE
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function hfcpci_softirq() is a timer handler. If it
is running, the timer_pending() will return 0 and the
del_timer_sync() in HFC_cleanup() will not be executed.
As a result, the use-after-free bug will happen. The
process is shown below:

    (cleanup routine)          |        (timer handler)
HFC_cleanup()                  | hfcpci_softirq()
 if (timer_pending(&hfc_tl))   |
   del_timer_sync()            |
 ...                           | ...
 pci_unregister_driver(hc)     |
  driver_unregister            |  driver_for_each_device
   bus_remove_driver           |   _hfcpci_softirq
    driver_detach              |   ...
     put_device(dev) //[1]FREE |
                               |    dev_get_drvdata(dev) //[2]USE

The device is deallocated is position [1] and used in
position [2].

Fix by removing the "timer_pending" check in HFC_cleanup(),
which makes sure that the hfcpci_softirq() have finished
before the resource is deallocated.

Fixes: 009fc857c5f6 ("mISDN: fix possible use-after-free in HFC_cleanup()")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 drivers/isdn/hardware/mISDN/hfcpci.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index af17459c1a5..e964a8dd851 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -2345,8 +2345,7 @@ HFC_init(void)
 static void __exit
 HFC_cleanup(void)
 {
-	if (timer_pending(&hfc_tl))
-		del_timer_sync(&hfc_tl);
+	del_timer_sync(&hfc_tl);
 
 	pci_unregister_driver(&hfc_driver);
 }
-- 
2.17.1

