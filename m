Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD08513FC4
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 02:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353540AbiD2Atg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 20:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353180AbiD2Ata (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 20:49:30 -0400
Received: from mail-m121145.qiye.163.com (mail-m121145.qiye.163.com [115.236.121.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660C4888D3;
        Thu, 28 Apr 2022 17:46:12 -0700 (PDT)
Received: from localhost.localdomain (unknown [58.22.7.114])
        by mail-m121145.qiye.163.com (Hmail) with ESMTPA id 74245800280;
        Fri, 29 Apr 2022 08:46:09 +0800 (CST)
From:   Jianqun Xu <jay.xu@rock-chips.com>
To:     kuba@kernel.org, davem@davemloft.net, joabreu@synopsys.com,
        alexandre.torgue@st.com, peppe.cavallaro@st.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Jianqun Xu <jay.xu@rock-chips.com>
Subject: [PATCH V2] ethernet: stmmac: support driver work for DTs without child queue node
Date:   Fri, 29 Apr 2022 08:46:05 +0800
Message-Id: <20220429004605.1010751-1-jay.xu@rock-chips.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220428010927.526310-1-jay.xu@rock-chips.com>
References: <20220428010927.526310-1-jay.xu@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlKS0tKN1dZLVlBSVdZDwkaFQgSH1lBWRlDH0NWS0tMTU1PHx
        hDQx5NVRMBExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktISkNVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MRg6GRw5ED02EBEfIxgJN0of
        TjoKCwhVSlVKTU5KSkJISkxLSk5CVTMWGhIXVREaAlUDDjsJFBgQVhgTEgsIVRgUFkVZV1kSC1lB
        WU5DVUlJVUxVSkpPWVdZCAFZQUlCSE83Bg++
X-HM-Tid: 0a8072c84756b03akuuu74245800280
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver use the value of property 'snps,rx-queues-to-use' to loop
same numbers child nodes as queues, such as:

    gmac {
        rx-queues-config {
            snps,rx-queues-to-use = <1>;
            queue0 {
                // nothing need here.
	    };
	};
    };

Since a patch for dtc from rockchip will delete all node without any
properties or child node, the queue0 node will be deleted, that caused
the driver fail to probe:

    rk_gmac-dwmac: probe of ffa80000.ethernet failed with error -22

This patch try to support driver work well for DTs without setting for
the child queue nodes and then have none child queue nodes.

Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
---
v2:
 - change subject and update commit comment, sugguested by Kicinski

 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 2d8c095f3856..4f01a41c485c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -279,7 +279,7 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
 
 		queue++;
 	}
-	if (queue != plat->tx_queues_to_use) {
+	if (queue != plat->tx_queues_to_use && of_get_child_count(tx_node)) {
 		ret = -EINVAL;
 		dev_err(&pdev->dev, "Not all TX queues were configured\n");
 		goto out;
-- 
2.25.1

