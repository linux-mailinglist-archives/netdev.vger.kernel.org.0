Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E636B5F89
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 19:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbjCKSHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 13:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbjCKSHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 13:07:16 -0500
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A963D6A422;
        Sat, 11 Mar 2023 10:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=YXELY
        QhkSMhCKRXhZ5fp5y3ZjId2tVim6Q6kYlCoa7M=; b=Zq6+HtY+LKoMdn8gyJH66
        PvNEjR9Rx9i+ik6raQMpODircupWNMoJcHjMUzGc18bMIiakzTpOLOnVZkWhXOYR
        2wRHklABN0Vp6044UY3yAOo7srmwIE+Ybn3zKniz7nNnISAxP7E4j8HPMYuXQRR4
        AslrjmnRNuslB/MbcdzZRc=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by zwqz-smtp-mta-g0-0 (Coremail) with SMTP id _____wDnwxQowwxk9fcHDA--.22999S2;
        Sun, 12 Mar 2023 02:06:32 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     s.shtylyov@omp.ru
Cc:     davem@davemloft.net, linyunsheng@huawei.com, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hackerzheng666@gmail.com,
        1395428693sheep@gmail.com, alex000young@gmail.com,
        Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH net v3] net: ravb: Fix possible UAF bug in ravb_remove
Date:   Sun, 12 Mar 2023 02:06:30 +0800
Message-Id: <20230311180630.4011201-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wDnwxQowwxk9fcHDA--.22999S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF1DZF1Dur1Uur45AFyUtrb_yoW8Gr1Dp3
        9xKa4fuws5Jr1UWa1xGws7ZFWrG3WUKrnIgFWxAw4FvasayF1DXr1FgFW0yw1UJrWkta4a
        vrWjvw1xu3WDAa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pEZ2adUUUUU=
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/1tbiXQgvU1WBo4EEqwAAsw
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ravb_probe, priv->work was bound with ravb_tx_timeout_work.
If timeout occurs, it will start the work. And if we call
ravb_remove without finishing the work, there may be a
use-after-free bug on ndev.

Fix it by finishing the job before cleanup in ravb_remove.

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
v3:
- fix typo in commit message
v2:
- stop dev_watchdog so that handle no more timeout work suggested by Yunsheng Lin,
add an empty line to make code clear suggested by Sergey Shtylyov
---
 drivers/net/ethernet/renesas/ravb_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 0f54849a3823..eb63ea788e19 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2892,6 +2892,10 @@ static int ravb_remove(struct platform_device *pdev)
 	struct ravb_private *priv = netdev_priv(ndev);
 	const struct ravb_hw_info *info = priv->info;
 
+	netif_carrier_off(ndev);
+	netif_tx_disable(ndev);
+	cancel_work_sync(&priv->work);
+	
 	/* Stop PTP Clock driver */
 	if (info->ccc_gac)
 		ravb_ptp_stop(ndev);
-- 
2.25.1

