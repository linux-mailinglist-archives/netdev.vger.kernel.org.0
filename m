Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 529AB6B1A3B
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 04:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjCID5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 22:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjCID5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 22:57:38 -0500
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 485D7D3082;
        Wed,  8 Mar 2023 19:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=uOlqg
        7qHm1VRJbAdquIECP19cN/BzkUoVyyDhvoLGiM=; b=V2p+AtVvV3jpQw8CIIAhV
        7wfI/mK3YfaiSzgepuVWkNnq9e55y+NxrFtr65T0wiAecCoIzdtI/roro/c49RWy
        Vd+0D1qvUdKZs7PZc85stpla5PaPzZ+RYjRFGusd+Da9+g3bfmRfzApYHh2fi9pO
        73t1S5mpXsIYcWW95ms1OA=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by zwqz-smtp-mta-g4-2 (Coremail) with SMTP id _____wBnDLX6WAlk3EWhCg--.54307S2;
        Thu, 09 Mar 2023 11:56:42 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, hackerzheng666@gmail.com,
        1395428693sheep@gmail.com, alex000young@gmail.com,
        Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH] net: calxeda: fix race condition in xgmac_remove due to unfinshed work
Date:   Thu,  9 Mar 2023 11:56:41 +0800
Message-Id: <20230309035641.3439953-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wBnDLX6WAlk3EWhCg--.54307S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jry5Kw1kAF18GF1fCr45Wrg_yoWfuFbEga
        s2vF1xWa1UXF1vkw4vkr4UZry8tF1Dur4rZFW0gryY93sxJr17Xrs7uF9rJF45W3yDGry3
        GFnxArW0yw1UtjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRKBT5JUUUUU==
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/1tbiGgEtU1aEEgnYDwAAs7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In xgmac_probe, the priv->tx_timeout_work is bound with 
xgmac_tx_timeout_work. In xgmac_remove, if there is an 
unfinished work, there might be a race condition that 
priv->base was written byte after iounmap it.

Fix it by finishing the work before cleanup.

Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
---
 drivers/net/ethernet/calxeda/xgmac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index f4f87dfa9687..94c3804001e3 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1831,6 +1831,7 @@ static int xgmac_remove(struct platform_device *pdev)
 	/* Free the IRQ lines */
 	free_irq(ndev->irq, ndev);
 	free_irq(priv->pmt_irq, ndev);
+	cancel_work_sync(&priv->tx_timeout_work);
 
 	unregister_netdev(ndev);
 	netif_napi_del(&priv->napi);
-- 
2.25.1

