Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680E76BF8DA
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 09:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjCRIHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 04:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCRIHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 04:07:22 -0400
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.216])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B244817CEC;
        Sat, 18 Mar 2023 01:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=NLgcl
        pVGg+cj1T9ME4V3k2q3Xxe+gHdjdWnzy/lpn/8=; b=RkUQVr9EoeST5XJK0HoEL
        25x2KFnRDyRV4gc87XIFyD3t7ntfFZ40mcm9nmKYfgRxdPC7DMKFxU8tktEOLuOY
        eb6yMmURljEWspXllwyn43I0BiIcgUaJUQn/gh+Gcbu2jSWk2+6HeAAISZLzNqu9
        o/YvN2j+a6DhO82uBa2Ra8=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by zwqz-smtp-mta-g1-3 (Coremail) with SMTP id _____wBn1unHcBVkXCVqAQ--.22021S2;
        Sat, 18 Mar 2023 16:05:27 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     timur@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hackerzheng666@gmail.com,
        1395428693sheep@gmail.com, alex000young@gmail.com,
        Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH net v2] net: qcom/emac: Fix use after free bug in emac_remove due to  race condition
Date:   Sat, 18 Mar 2023 16:05:26 +0800
Message-Id: <20230318080526.785457-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wBn1unHcBVkXCVqAQ--.22021S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF4DZrWrCr4ktFWkXr1rtFb_yoW8Wr4kpa
        yDWa4xu34ktF17KF4kJr47tFyUGw4DK34ag3y3Cw4rZ3Z8Cry7KryrKFyrXryfZFZ8Ar4Y
        qr18Z343Ca1kJ3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziaZXrUUUUU=
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/1tbiXAg2U1Xl5+MwYQAAsU
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In emac_probe, &adpt->work_thread is bound with
emac_work_thread. Then it will be started by timeout
handler emac_tx_timeout or a IRQ handler emac_isr.

If we remove the driver which will call emac_remove
  to make cleanup, there may be a unfinished work.

The possible sequence is as follows:

Fix it by finishing the work before cleanup in the emac_remove
and disable timeout response.

CPU0                  CPU1

                    |emac_work_thread
emac_remove         |
free_netdev         |
kfree(netdev);      |
                    |emac_reinit_locked
                    |emac_mac_down
                    |//use netdev
Fixes: b9b17debc69d ("net: emac: emac gigabit ethernet controller driver")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
---
v2:
- cancel the work after unregister_netdev suggested by Jakub
---
 drivers/net/ethernet/qualcomm/emac/emac.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index 3115b2c12898..eaa50050aa0b 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -724,9 +724,15 @@ static int emac_remove(struct platform_device *pdev)
 	struct net_device *netdev = dev_get_drvdata(&pdev->dev);
 	struct emac_adapter *adpt = netdev_priv(netdev);
 
+	netif_carrier_off(netdev);
+	netif_tx_disable(netdev);
+
 	unregister_netdev(netdev);
 	netif_napi_del(&adpt->rx_q.napi);
 
+	free_irq(adpt->irq.irq, &adpt->irq);
+	cancel_work_sync(&adpt->work_thread);
+
 	emac_clks_teardown(adpt);
 
 	put_device(&adpt->phydev->mdio.dev);
-- 
2.25.1

