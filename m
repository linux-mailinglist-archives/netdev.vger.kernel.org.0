Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 760E84D9B3B
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 13:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348314AbiCOMbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 08:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348308AbiCOMbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 08:31:12 -0400
Received: from m12-18.163.com (m12-18.163.com [220.181.12.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6BB7E53724;
        Tue, 15 Mar 2022 05:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=fUx1d
        Hz8QOuYbxTSkHxz9OhPu6LyF9InCSqHJeq1ve0=; b=hR82SILuBzQIHN2h0NZYK
        4e1SRPtxqDAvn6BW+HFFrg5j+ig+As701URoSvEyisrvkykJsyLcB32QibFJwi6F
        HgXiwxwqiKIu+OJh0w1hq1UPWflYd60kntbPZ+ElHcQMF871wGvoKmkxCRYi4fVW
        YwaHXx+tCilS6lj7Sva0no=
Received: from localhost (unknown [116.30.193.133])
        by smtp14 (Coremail) with SMTP id EsCowACX3iSchjBiVp1zAg--.65133S2;
        Tue, 15 Mar 2022 20:29:16 +0800 (CST)
From:   wujunwen <wudaemon@163.com>
To:     davem@davemloft.net, kuba@kernel.org, m.grzeschik@pengutronix.de,
        chenhao288@hisilicon.com, arnd@arndb.de, pabeni@redhat.com
Cc:     wudaemon@163.com, shenyang39@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [net-next PATCH v4] net: ksz884x: optimize netdev_open flow and remove static variable
Date:   Tue, 15 Mar 2022 12:28:57 +0000
Message-Id: <20220315122857.78601-1-wudaemon@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EsCowACX3iSchjBiVp1zAg--.65133S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJryktw1DtFW7Kr45uFWUCFg_yoW8Aryxpa
        y7Aa40vrW8W3WxWayqy3y8ZF15Gw1UKFyxGFyxK34S9347Kr98tFs5KrWYyr45CrZ5XF1S
        v39YvF9rCF93Ja7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U5ucNUUUUU=
X-Originating-IP: [116.30.193.133]
X-CM-SenderInfo: 5zxgtvxprqqiywtou0bp/1tbiUBnEbVWBt4TKGwABsX
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

remove the static next_jiffies variable, and reinitialize next_jiffies 
to simplify netdev_open

Signed-off-by: wujunwen <wudaemon@163.com>
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

