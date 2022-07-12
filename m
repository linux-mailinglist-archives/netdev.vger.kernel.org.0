Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C85E571229
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 08:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiGLGPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 02:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiGLGPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 02:15:01 -0400
Received: from m15114.mail.126.com (m15114.mail.126.com [220.181.15.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8C6212F029
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 23:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=KHpXK
        mRPt8V5xkXDAL39szvQhBsyWS3ZhTUPAF9OC38=; b=e6TAjfv98Ahh6Bio0PrDN
        IU9W8MtlA+WQnoLz377I5drWx281tp/w7WTxq/Rf1gqaCLGYiAb1gfLkw/feS/nj
        rR6HwTwUNocoecfwEYak1amlnltrgbqC6FFxvjaG8P9R3YKtwCtNmlQb+P+i+4jC
        6+dQ699SKkEcCyZs6SP45c=
Received: from localhost.localdomain (unknown [124.16.139.61])
        by smtp7 (Coremail) with SMTP id DsmowACn5vU6Ec1i2x4iEw--.55282S2;
        Tue, 12 Jul 2022 14:14:19 +0800 (CST)
From:   Liang He <windhl@126.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, windhl@126.com
Subject: [PATCH v3] net: ftgmac100: Hold reference returned by  of_get_child_by_name()
Date:   Tue, 12 Jul 2022 14:14:17 +0800
Message-Id: <20220712061417.363145-1-windhl@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsmowACn5vU6Ec1i2x4iEw--.55282S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WF15KryUAF43ZF47uF1DGFg_yoW8CFWDpw
        4UC3y3ur4rt34xuw4vya1rAF9I9w4I93y2gF4fG3s3CF15GFyUZF1xKFy3Z3sIyFyrWry5
        tF4jvF1FyFWDJFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UOeOXUUUUU=
X-Originating-IP: [124.16.139.61]
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbi3Bs8F1pED59PRQAAso
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

Fixes: 39bfab8844a0 ("net: ftgmac100: Add support for DT phy-handle property")
Signed-off-by: Liang He <windhl@126.com>
---
 changelog:

 v3: make the helper return 'bool' and remove 'inline'
 v2: (1) use a helper advised by Jakub (2) add fix tag
 v1: directly hold the reference returned by of_get_xx

 v1 link: https://lore.kernel.org/all/20220704151819.279513-1-windhl@126.com/
 v2 link: https://lore.kernel.org/all/20220710020728.317086-1-windhl@126.com/

 drivers/net/ethernet/faraday/ftgmac100.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 5231818943c6..c03663785a8d 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1764,6 +1764,19 @@ static int ftgmac100_setup_clk(struct ftgmac100 *priv)
 	return rc;
 }
 
+static bool ftgmac100_has_child_node(struct device_node *np, const char *name)
+{
+	struct device_node *child_np = of_get_child_by_name(np, name);
+	bool ret = false;
+
+	if (child_np) {
+		ret = true;
+		of_node_put(child_np);
+	}
+
+	return ret;
+}
+
 static int ftgmac100_probe(struct platform_device *pdev)
 {
 	struct resource *res;
@@ -1883,7 +1896,7 @@ static int ftgmac100_probe(struct platform_device *pdev)
 
 		/* Display what we found */
 		phy_attached_info(phy);
-	} else if (np && !of_get_child_by_name(np, "mdio")) {
+	} else if (np && !ftgmac100_has_child_node(np, "mdio")) {
 		/* Support legacy ASPEED devicetree descriptions that decribe a
 		 * MAC with an embedded MDIO controller but have no "mdio"
 		 * child node. Automatically scan the MDIO bus for available
-- 
2.25.1

