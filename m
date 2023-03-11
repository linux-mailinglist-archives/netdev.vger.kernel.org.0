Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2298F6B5F7F
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 19:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjCKSEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 13:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbjCKSEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 13:04:38 -0500
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 812AD50996;
        Sat, 11 Mar 2023 10:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=C7fD2
        xpk7NTbx5k6GnhNQoHvfkr24LqkPt+Xv71fq70=; b=oqSt28aNE+4ZKP8FCVlB2
        PH9BOTQS6uYCmhqHN1EwNicuJpNzHHIczkP2TLFmdbHS93VXqUtmm4TWW6s+S4UN
        LXgcuRyw0BHbjPM/78CMuGPWn+IgK6ZrmCLnIaBEcTIFnR69DMA6o+SMOoCgZE9I
        GWZb7JCFMFM/1rbVQSrl9k=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by zwqz-smtp-mta-g2-4 (Coremail) with SMTP id _____wAHVO2WwgxkGhAgDA--.10863S2;
        Sun, 12 Mar 2023 02:04:06 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mkl@pengutronix.de, j.neuschaefer@gmx.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linyunsheng@huawei.com,
        hackerzheng666@gmail.com, 1395428693sheep@gmail.com,
        alex000young@gmail.com, Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH net v2] net: calxedaxgmac: fix race condition in xgmac_remove due to  unfinished work
Date:   Sun, 12 Mar 2023 02:04:04 +0800
Message-Id: <20230311180404.4007176-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wAHVO2WwgxkGhAgDA--.10863S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jry5Kw1kAF18GF1fCr45Wrg_yoWkKwcEga
        s293WxGw4UJF1vka1kCr4UZry8t3Wq9w1rXryIgrWa93sxJr1xXrs7uFy7JF45Ww1DGry7
        WFnIyrWSyw1jqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRKPfHUUUUUU==
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/1tbiGhMvU1aEEiTKVgACsP
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
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

Fixes: 8746f671ef04 ("net: calxedaxgmac: fix race between xgmac_tx_complete and xgmac_tx_err")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
---
v2:
- fix typo,add Fixes label and stop dev_watchdog so that it will handle no more timeout work suggested by Yunsheng Lin
---
 drivers/net/ethernet/calxeda/xgmac.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index f4f87dfa9687..f0880538f6f3 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1832,6 +1832,10 @@ static int xgmac_remove(struct platform_device *pdev)
 	free_irq(ndev->irq, ndev);
 	free_irq(priv->pmt_irq, ndev);
 
+	netif_carrier_off(ndev);
+	netif_tx_disable(ndev);
+	cancel_work_sync(&priv->tx_timeout_work);
+
 	unregister_netdev(ndev);
 	netif_napi_del(&priv->napi);
 
-- 
2.25.1

