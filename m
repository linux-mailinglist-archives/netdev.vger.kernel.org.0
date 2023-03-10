Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59DAA6B3D0F
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 11:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjCJK7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 05:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbjCJK6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 05:58:46 -0500
Received: from m12.mail.163.com (m12.mail.163.com [123.126.96.234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7555862DB3;
        Fri, 10 Mar 2023 02:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Owj+M
        BUPPj7JSD6XFwrGK/Dxxkli2/FUahfWV3epWvw=; b=ObP0BI5NU4KI53o1lP1T7
        H5/H9yYVUQsaFHc8eNJDlSVgwmNZottETKBgG0ssL0PrvpCUiBDBGGzgbrjBzlfc
        kZ5e9bdyRYO/yZ1/0VR3XPHqvvJ/LhufYPulcoVtzpIHg1n9EwjzFr76MoBgzhCo
        7l9hXZAbl5Zem2h3z/5Vg4=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by smtp19 (Coremail) with SMTP id R9xpCgB3bKAfDQtkaPFpHA--.3786S2;
        Fri, 10 Mar 2023 18:57:35 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     timur@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hackerzheng666@gmail.com,
        1395428693sheep@gmail.com, alex000young@gmail.com,
        Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH net] net: qcom/emac: Fix use after free bug in emac_remove due to race condition
Date:   Fri, 10 Mar 2023 18:57:34 +0800
Message-Id: <20230310105734.1574078-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: R9xpCgB3bKAfDQtkaPFpHA--.3786S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF4DZrWrCr4ktFWkXr1rtFb_yoW8GF4Dpa
        yDGa4xu34vgF129F4kJr4UtFyUGw4DK34ag3y3Cw4rX3Z8Cr4xWryrKFy8Zry8ZFZ8Jr1a
        qr1UZ343Ca1kJ3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziaZXrUUUUU=
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/1tbiGgAuU1aEEhk-vwAAs+
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/qualcomm/emac/emac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index 3115b2c12898..ddc328f7b96a 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -724,6 +724,9 @@ static int emac_remove(struct platform_device *pdev)
 	struct net_device *netdev = dev_get_drvdata(&pdev->dev);
 	struct emac_adapter *adpt = netdev_priv(netdev);

+	netif_carrier_off(netdev);
+	netif_tx_disable(netdev);
+	cancel_work_sync(&adpt->work_thread);
 	unregister_netdev(netdev);
 	netif_napi_del(&adpt->rx_q.napi);
 
-- 
2.25.1

