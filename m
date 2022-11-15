Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280DB62914E
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 05:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbiKOExq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 23:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbiKOExo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 23:53:44 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F25A63D3;
        Mon, 14 Nov 2022 20:53:44 -0800 (PST)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NBDMj2Sc0z15MMt;
        Tue, 15 Nov 2022 12:53:21 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (7.193.23.191) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 12:53:41 +0800
Received: from ubuntu1804.huawei.com (10.67.175.30) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 12:53:40 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <mw@semihalf.com>, <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yusongping@huawei.com>
Subject: [PATCH] net: mdio-ipq4019: fix possible invalid pointer dereference
Date:   Tue, 15 Nov 2022 12:50:28 +0800
Message-ID: <20221115045028.182441-1-tanghui20@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.30]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600005.china.huawei.com (7.193.23.191)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

priv->eth_ldo_rdy is saved the return value of devm_ioremap_resource(),
which !IS_ERR() should be used to check.

Fixes: 23a890d493e3 ("net: mdio: Add the reset function for IPQ MDIO driver")
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/net/mdio/mdio-ipq4019.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/mdio/mdio-ipq4019.c b/drivers/net/mdio/mdio-ipq4019.c
index 4eba5a91075c..d7a1f7c56f97 100644
--- a/drivers/net/mdio/mdio-ipq4019.c
+++ b/drivers/net/mdio/mdio-ipq4019.c
@@ -188,7 +188,7 @@ static int ipq_mdio_reset(struct mii_bus *bus)
 	/* To indicate CMN_PLL that ethernet_ldo has been ready if platform resource 1
 	 * is specified in the device tree.
 	 */
-	if (priv->eth_ldo_rdy) {
+	if (!IS_ERR(priv->eth_ldo_rdy)) {
 		val = readl(priv->eth_ldo_rdy);
 		val |= BIT(0);
 		writel(val, priv->eth_ldo_rdy);
-- 
2.17.1

