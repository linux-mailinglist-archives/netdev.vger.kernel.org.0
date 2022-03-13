Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42BC94D7251
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 04:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbiCMD37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 22:29:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiCMD37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 22:29:59 -0500
Received: from m12-18.163.com (m12-18.163.com [220.181.12.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D81589CCF;
        Sat, 12 Mar 2022 19:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Sy7Rm
        cSG+PTDgDj6fw702xJGq1qvAvRQ+nQbeb/4q2A=; b=IjydwheVz3heISDTDLb9j
        egRTMsDczW8AQUt6VWxj0iE02JHn4mFrnPYvSHiqV0Uv47U96VymtdSbeAcaPRUA
        i7E4V3uI5+BKxAvbawgVDa3I28NhXxq74UnaPNxPf9dNDQ5MZGuOYtuGmzwxytv9
        180T/Oau1ImbxaUEy8fVNs=
Received: from localhost (unknown [113.116.156.254])
        by smtp14 (Coremail) with SMTP id EsCowABHjiTJZC1iSdUnAQ--.27734S2;
        Sun, 13 Mar 2022 11:28:09 +0800 (CST)
From:   wudaemon <wudaemon@163.com>
To:     davem@davemloft.net, kuba@kernel.org, m.grzeschik@pengutronix.de,
        chenhao288@hisilicon.com, arnd@arndb.de
Cc:     wudaemon@163.com, shenyang39@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4] net: ksz884x: optimize netdev_open flow and remove static variable
Date:   Sun, 13 Mar 2022 03:27:48 +0000
Message-Id: <20220313032748.3642-1-wudaemon@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EsCowABHjiTJZC1iSdUnAQ--.27734S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF45Gr48CF4DZF4xKryrXrb_yoW8Aryxpa
        y7Aa40vrW8W3WxWayqy348ZF15Gw1UKFyxGFyxK34S9347Kr98tFs5KrWYyr45CrZ5XF1S
        v39YvF9rCas3Ja7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0z_Q6pAUUUUU=
X-Originating-IP: [113.116.156.254]
X-CM-SenderInfo: 5zxgtvxprqqiywtou0bp/1tbisBXBbVUMSB6krwABsM
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

remove the static next_jiffies variable, and reinitialize next_jiffies to simplify netdev_open

Signed-off-by: wudaemon <wudaemon@163.com>
---
 drivers/net/ethernet/micrel/ksz884x.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index d024983815da..2b3eb5ed8233 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -5225,7 +5225,6 @@ static irqreturn_t netdev_intr(int irq, void *dev_id)
  * Linux network device functions
  */
 
-static unsigned long next_jiffies;
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
 static void netdev_netpoll(struct net_device *dev)
@@ -5411,10 +5410,12 @@ static int netdev_open(struct net_device *dev)
 	struct dev_info *hw_priv = priv->adapter;
 	struct ksz_hw *hw = &hw_priv->hw;
 	struct ksz_port *port = &priv->port;
+	unsigned long next_jiffies;
 	int i;
 	int p;
 	int rc = 0;
 
+	next_jiffies = jiffies + HZ * 2;
 	priv->multicast = 0;
 	priv->promiscuous = 0;
 
@@ -5428,10 +5429,7 @@ static int netdev_open(struct net_device *dev)
 		if (rc)
 			return rc;
 		for (i = 0; i < hw->mib_port_cnt; i++) {
-			if (next_jiffies < jiffies)
-				next_jiffies = jiffies + HZ * 2;
-			else
-				next_jiffies += HZ * 1;
+			next_jiffies += HZ * 1;
 			hw_priv->counter[i].time = next_jiffies;
 			hw->port_mib[i].state = media_disconnected;
 			port_init_cnt(hw, i);
@@ -6563,6 +6561,7 @@ static void mib_read_work(struct work_struct *work)
 	struct dev_info *hw_priv =
 		container_of(work, struct dev_info, mib_read);
 	struct ksz_hw *hw = &hw_priv->hw;
+	unsigned long next_jiffies;
 	struct ksz_port_mib *mib;
 	int i;
 
-- 
2.25.1

