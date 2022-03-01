Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79BD84C8ED1
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 16:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235626AbiCAPUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 10:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235610AbiCAPUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 10:20:02 -0500
Received: from m12-14.163.com (m12-14.163.com [220.181.12.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D4E5119C2C;
        Tue,  1 Mar 2022 07:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=KI0KE
        HorC5jY80LfL4ZopJ7TIk5kxEutZ4yF14mxFls=; b=HvxCPnP7M1ZyqtHKWiV1Z
        1rv07jtezRywjd3izoymUPqj7QqIg+sKD6YJrKrm5wTWZT+1Zq+AL+2bjWIDHW/6
        m97LmajxZ5qUc7U3JMrBq7RK7roeQQGP/mAWBRE9Ru5o/3EJh20uaE0ooAYVYu4q
        QLofvWzXpM9lKiz312nI90=
Received: from localhost (unknown [113.87.88.41])
        by smtp10 (Coremail) with SMTP id DsCowAAXkDlDOR5iGr3YAg--.1317S2;
        Tue, 01 Mar 2022 23:18:28 +0800 (CST)
From:   wudaemon <wudaemon@163.com>
To:     davem@davemloft.net, kuba@kernel.org, m.grzeschik@pengutronix.de,
        chenhao288@hisilicon.com, arnd@arndb.de
Cc:     wudaemon@163.com, shenyang39@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] net: ksz884x: use time_before in netdev_open for compatibility and remove static variable
Date:   Tue,  1 Mar 2022 15:18:08 +0000
Message-Id: <20220301151808.2855-1-wudaemon@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsCowAAXkDlDOR5iGr3YAg--.1317S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF45Gr48CF4fZF1DuF15Arb_yoW8WrWDpa
        yUAay0yr48W3WjgayDA34kZF15G3y8Ka4xKFyxt34S9w17KryYyFs5KrWYyw45GrZ3XF1S
        v3yvyF9rCas3Ja7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pMmhF-UUUUU=
X-Originating-IP: [113.87.88.41]
X-CM-SenderInfo: 5zxgtvxprqqiywtou0bp/1tbisAS2bVUMRrqbIAAAsx
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
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
 drivers/net/ethernet/micrel/ksz884x.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index d024983815da..ce4f5c99c1ac 100644
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
 
+	next_jiffies = jiffies;
 	priv->multicast = 0;
 	priv->promiscuous = 0;
 
@@ -5428,7 +5429,7 @@ static int netdev_open(struct net_device *dev)
 		if (rc)
 			return rc;
 		for (i = 0; i < hw->mib_port_cnt; i++) {
-			if (next_jiffies < jiffies)
+			if (time_before(next_jiffies, jiffies))
 				next_jiffies = jiffies + HZ * 2;
 			else
 				next_jiffies += HZ * 1;
@@ -6563,6 +6564,7 @@ static void mib_read_work(struct work_struct *work)
 	struct dev_info *hw_priv =
 		container_of(work, struct dev_info, mib_read);
 	struct ksz_hw *hw = &hw_priv->hw;
+	unsigned long next_jiffies;
 	struct ksz_port_mib *mib;
 	int i;
 
-- 
2.25.1

