Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8B74C0A0F
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 04:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237844AbiBWDPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 22:15:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236490AbiBWDPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 22:15:34 -0500
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3B51B7A0;
        Tue, 22 Feb 2022 19:15:07 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=guoheyi@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V5FxgBc_1645586089;
Received: from fdadf40dcbca.tbsite.net(mailfrom:guoheyi@linux.alibaba.com fp:SMTPD_---0V5FxgBc_1645586089)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 23 Feb 2022 11:15:04 +0800
From:   Heyi Guo <guoheyi@linux.alibaba.com>
To:     linux-kernel@vger.kernel.org
Cc:     Heyi Guo <guoheyi@linux.alibaba.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dylan Hung <dylan_hung@aspeedtech.com>, netdev@vger.kernel.org
Subject: [PATCH 1/3] drivers/net/ftgmac100: refactor ftgmac100_reset_task to enable direct function call
Date:   Wed, 23 Feb 2022 11:14:34 +0800
Message-Id: <20220223031436.124858-2-guoheyi@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220223031436.124858-1-guoheyi@linux.alibaba.com>
References: <20220223031436.124858-1-guoheyi@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is to prepare for ftgmac100_adjust_link() to call reset function
directly, instead of task schedule.

Signed-off-by: Heyi Guo <guoheyi@linux.alibaba.com>

---
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Guangbin Huang <huangguangbin2@huawei.com>
Cc: Hao Chen <chenhao288@hisilicon.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dylan Hung <dylan_hung@aspeedtech.com>
Cc: netdev@vger.kernel.org


---
 drivers/net/ethernet/faraday/ftgmac100.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 691605c152659..1f3eb44314753 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1410,10 +1410,8 @@ static int ftgmac100_init_all(struct ftgmac100 *priv, bool ignore_alloc_err)
 	return err;
 }
 
-static void ftgmac100_reset_task(struct work_struct *work)
+static void ftgmac100_reset(struct ftgmac100 *priv)
 {
-	struct ftgmac100 *priv = container_of(work, struct ftgmac100,
-					      reset_task);
 	struct net_device *netdev = priv->netdev;
 	int err;
 
@@ -1459,6 +1457,14 @@ static void ftgmac100_reset_task(struct work_struct *work)
 	rtnl_unlock();
 }
 
+static void ftgmac100_reset_task(struct work_struct *work)
+{
+	struct ftgmac100 *priv = container_of(work, struct ftgmac100,
+					      reset_task);
+
+	ftgmac100_reset(priv);
+}
+
 static int ftgmac100_open(struct net_device *netdev)
 {
 	struct ftgmac100 *priv = netdev_priv(netdev);
-- 
2.17.1

