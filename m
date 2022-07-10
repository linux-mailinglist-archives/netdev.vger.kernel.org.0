Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F6256CC3B
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 04:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiGJCIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 22:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiGJCIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 22:08:11 -0400
Received: from m15112.mail.126.com (m15112.mail.126.com [220.181.15.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 59E3924089
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 19:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=eUhp1
        p94eXV8KkMAhZTBxBjJPlTpKFq8T+dc3Sfb1YA=; b=OJpszw+XiVkFhMmvvTexi
        vhkYe77zSWWWfBezOrv/czr+B5D4u5LvJ7Mqbi5CdQ/HK1zZG8Rqjx2UNeg9jn3R
        WIJ52UjemFJNlCZKlcWBqbMyZOpJ768xbPAfuw23XLqV/GtEYFm4mz0aRyn2YWqB
        fBEQ+9Y5m0N35yajjeU7+g=
Received: from localhost.localdomain (unknown [124.16.139.61])
        by smtp2 (Coremail) with SMTP id DMmowAAnjvphNMpiOwNkEg--.15253S2;
        Sun, 10 Jul 2022 10:07:30 +0800 (CST)
From:   Liang He <windhl@126.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, windhl@126.com, netdev@vger.kernel.org
Subject: [PATCH v2] net: ftgmac100: Hold reference returned by of_get_child_by_name()
Date:   Sun, 10 Jul 2022 10:07:28 +0800
Message-Id: <20220710020728.317086-1-windhl@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMmowAAnjvphNMpiOwNkEg--.15253S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WF15Kry7WF13Zw15CF1fXrb_yoW8CFWDp3
        yUCrW3urWrK347ua1vyan5AFW3uw12g34jgF48G39akFn8GFyUXrn7KFy5Z39xtFyrGFy3
        tr4UZ3WSyFWDArUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zixsqAUUUUU=
X-Originating-IP: [124.16.139.61]
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbi2gM6F1uwMYD4gQAAsX
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

 v2: (1) use a helper advised by Jakub (2) add fix tag
 v1: directly hold the reference returned by of_get_xx

 v1 link: https://lore.kernel.org/all/20220704151819.279513-1-windhl@126.com/

 NOTE: I have used an 'inline' to improve the help performance, similar with:
 https://lore.kernel.org/all/20181212163548.23723-1-tiny.windzz@gmail.com/


 drivers/net/ethernet/faraday/ftgmac100.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 5231818943c6..bcf0767f99fd 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1764,6 +1764,15 @@ static int ftgmac100_setup_clk(struct ftgmac100 *priv)
 	return rc;
 }
 
+static inline struct device_node *ftgmac100_has_child_node(struct device_node *np, const char *name)
+{
+	struct device_node *child_np = of_get_child_by_name(np, "mdio");
+
+	of_node_put(child_np);
+
+	return child_np;
+}
+
 static int ftgmac100_probe(struct platform_device *pdev)
 {
 	struct resource *res;
@@ -1883,7 +1892,7 @@ static int ftgmac100_probe(struct platform_device *pdev)
 
 		/* Display what we found */
 		phy_attached_info(phy);
-	} else if (np && !of_get_child_by_name(np, "mdio")) {
+	} else if (np && !ftgmac100_has_child_node(np, "mdio")) {
 		/* Support legacy ASPEED devicetree descriptions that decribe a
 		 * MAC with an embedded MDIO controller but have no "mdio"
 		 * child node. Automatically scan the MDIO bus for available
-- 
2.25.1

