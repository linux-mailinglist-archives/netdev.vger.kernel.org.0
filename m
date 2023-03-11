Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8688B6B5F62
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 18:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbjCKRvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 12:51:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjCKRvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 12:51:23 -0500
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DFF5C1D935;
        Sat, 11 Mar 2023 09:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=nEs+j
        bQk2CXHBtfuuqY4p/NZW1T29Vk/1s0r2vqHCWs=; b=Xh7ubRi8IHS3SUq1ux0iS
        5vCsyR42i/q7S253g/abdYDv7NlnLtWB8t/Ts6hMXd0mt4plwBbGriucFesYOv0M
        xEebE2XOWrpaHvloKBzEXF23AnKTdAvMWOrS0rziaj3QLtHN3OpVv8/YW+Sr/dbj
        /WvNB0j6cDDkzQkRxSirio=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by zwqz-smtp-mta-g4-0 (Coremail) with SMTP id _____wD3zFFyuwxk7EH4Cw--.18794S2;
        Sun, 12 Mar 2023 01:33:38 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     s.shtylyov@omp.ru
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hackerzheng666@gmail.com,
        1395428693sheep@gmail.com, alex000young@gmail.com,
        Zheng Wang <zyytlz.wz@163.com>
Subject: [net PATCH v2] net: ravb: Fix possible UAF bug in ravb_remove
Date:   Sun, 12 Mar 2023 01:33:37 +0800
Message-Id: <20230311173337.3958819-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wD3zFFyuwxk7EH4Cw--.18794S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF1DZF1Dur1Uuw13WFWxZwb_yoW8Jw15p3
        9xKa4ruws5tr1UWa1xGws7ZFWrG3WUKr9I9FWxAw4FvasayF1DXr1FgFW0yw1UJrWDtFya
        vrWjvw1xu3WDAa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pElkssUUUUU=
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/1tbiQhMvU1aEEn9-dAAAsZ
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

