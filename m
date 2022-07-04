Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C10565A56
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 17:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbiGDPtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 11:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbiGDPtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 11:49:18 -0400
Received: from m15114.mail.126.com (m15114.mail.126.com [220.181.15.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5ED8426CB
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 08:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=hqaU8
        OVI/Rz0nAyZnMnJnIfAzttFpPVih5891VWuJbo=; b=GF0ke97U3q91yxSN5VPx/
        KhX2dJwbAAenRjmnxyww4WwdKbHQ+pdCjK8VChQ3HpCFReG+jgHZbSK5gzCr74vY
        JNeDeQfvrcd1CBi7f+A2SMYsiD22EmpcUkuTEjHe14Bk63GIfcBq7TULPw4TtuCB
        7sXt2SJedtLxLY7l5DJZMQ=
Received: from localhost.localdomain (unknown [124.16.139.61])
        by smtp7 (Coremail) with SMTP id DsmowAA3Lf68BMNi3zuqEQ--.16635S2;
        Mon, 04 Jul 2022 23:18:21 +0800 (CST)
From:   Liang He <windhl@126.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, windhl@126.com, netdev@vger.kernel.org
Subject: [PATCH] ftgmac100: Hold reference returned by of_get_child_by_name()
Date:   Mon,  4 Jul 2022 23:18:19 +0800
Message-Id: <20220704151819.279513-1-windhl@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsmowAA3Lf68BMNi3zuqEQ--.16635S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WF15KryxtF17Aw43WFyrCrg_yoW8XF17p3
        yDC3y5ur4rK347uw10kan5ZFy3uay293y5GF48G39a9a45tFy3XFyrtFW7Ar9xtFWrGw1a
        yr4UZ3WSyFWDZwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zi5l1PUUUUU=
X-Originating-IP: [124.16.139.61]
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbi7R40F1pEAVcksAAAsM
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ftgmac100_probe(), we should hold the refernece returned by
of_get_child_by_name() and use it to call of_node_put() for
reference balance.

Signed-off-by: Liang He <windhl@126.com>
---
 drivers/net/ethernet/faraday/ftgmac100.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 5231818943c6..e50bd7beb09b 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1770,7 +1770,7 @@ static int ftgmac100_probe(struct platform_device *pdev)
 	int irq;
 	struct net_device *netdev;
 	struct ftgmac100 *priv;
-	struct device_node *np;
+	struct device_node *np, *child_np;
 	int err = 0;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -1883,7 +1883,7 @@ static int ftgmac100_probe(struct platform_device *pdev)
 
 		/* Display what we found */
 		phy_attached_info(phy);
-	} else if (np && !of_get_child_by_name(np, "mdio")) {
+	} else if (np && !(child_np = of_get_child_by_name(np, "mdio"))) {
 		/* Support legacy ASPEED devicetree descriptions that decribe a
 		 * MAC with an embedded MDIO controller but have no "mdio"
 		 * child node. Automatically scan the MDIO bus for available
@@ -1901,6 +1901,8 @@ static int ftgmac100_probe(struct platform_device *pdev)
 		}
 
 	}
+	if (child_np)
+		of_node_put(child_np);
 
 	if (priv->is_aspeed) {
 		err = ftgmac100_setup_clk(priv);
-- 
2.25.1

