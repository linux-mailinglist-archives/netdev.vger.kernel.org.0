Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD724C71B8
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 17:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237665AbiB1Qbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 11:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234134AbiB1Qbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 11:31:53 -0500
Received: from m12-18.163.com (m12-18.163.com [220.181.12.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1DFDE51E74;
        Mon, 28 Feb 2022 08:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=z+As3
        SbvcB96uKp9hdSFgy6kCRJqyIuZy1j/CPmCqkQ=; b=nyI6o9SU3JCIhudAzFsCn
        ywybS+8npguQVCXN92/SQmaS9j22AWwCCn4cGnPuPQZ1SWnc5pDNVQjXl/8i55xU
        HhrE0DmYljUlSCQ1R7YHAKB1p5mQyvkSt3vDRQZF53IJTAdLvPAjxhOAPayzurOY
        irSEZe2HxGiu24juwwc5Pg=
Received: from localhost (unknown [113.87.88.40])
        by smtp14 (Coremail) with SMTP id EsCowAAXGVmW+Bxi8Na7FA--.9770S2;
        Tue, 01 Mar 2022 00:30:15 +0800 (CST)
From:   wudaemon <wudaemon@163.com>
To:     davem@davemloft.net, kuba@kernel.org, m.grzeschik@pengutronix.de,
        chenhao288@hisilicon.com, arnd@arndb.de
Cc:     wudaemon@163.com, shenyang39@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: ksz884x: use time_before in netdev_open for compatibility and remove static variable
Date:   Mon, 28 Feb 2022 16:29:55 +0000
Message-Id: <20220228162955.22819-1-wudaemon@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EsCowAAXGVmW+Bxi8Na7FA--.9770S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF45Gr48CF1xZF1UAFyrWFg_yoW8WFy5pF
        WUAay0yr48W3W0gayDJ348ZF15Gw48Ka4xGa4xK34fW34UKr90yFs5KrWjyw4UGrZ7XF1a
        v3yDAr9rCas3Ja7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zE2YLQUUUUU=
X-Originating-IP: [113.87.88.40]
X-CM-SenderInfo: 5zxgtvxprqqiywtou0bp/1tbiUBexbVWBtRhDZwAIsO
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use time_before instead of direct compare for compatibility and remove the static next_jiffies variable

Signed-off-by: wudaemon <wudaemon@163.com>
---
 drivers/net/ethernet/micrel/ksz884x.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index d024983815da..9d445f27abb8 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -5225,7 +5225,6 @@ static irqreturn_t netdev_intr(int irq, void *dev_id)
  * Linux network device functions
  */
 
-static unsigned long next_jiffies;
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
 static void netdev_netpoll(struct net_device *dev)
@@ -5361,7 +5360,7 @@ static int prepare_hardware(struct net_device *dev)
 	struct dev_info *hw_priv = priv->adapter;
 	struct ksz_hw *hw = &hw_priv->hw;
 	int rc = 0;
-
+	unsigned long next_jiffies = 0;
 	/* Remember the network device that requests interrupts. */
 	hw_priv->dev = dev;
 	rc = request_irq(dev->irq, netdev_intr, IRQF_SHARED, dev->name, dev);
@@ -5428,7 +5427,7 @@ static int netdev_open(struct net_device *dev)
 		if (rc)
 			return rc;
 		for (i = 0; i < hw->mib_port_cnt; i++) {
-			if (next_jiffies < jiffies)
+			if (time_before(next_jiffies, jiffies))
 				next_jiffies = jiffies + HZ * 2;
 			else
 				next_jiffies += HZ * 1;
@@ -6566,7 +6565,7 @@ static void mib_read_work(struct work_struct *work)
 	struct ksz_port_mib *mib;
 	int i;
 
-	next_jiffies = jiffies;
+	unsigned long next_jiffies = jiffies;
 	for (i = 0; i < hw->mib_port_cnt; i++) {
 		mib = &hw->port_mib[i];
 
-- 
2.25.1

