Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA96B512884
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 03:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240121AbiD1BMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 21:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbiD1BMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 21:12:03 -0400
X-Greylist: delayed 555 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 27 Apr 2022 18:08:50 PDT
Received: from mail-m121145.qiye.163.com (mail-m121145.qiye.163.com [115.236.121.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334CF7245B;
        Wed, 27 Apr 2022 18:08:50 -0700 (PDT)
Received: from localhost.localdomain (unknown [58.22.7.114])
        by mail-m121145.qiye.163.com (Hmail) with ESMTPA id 830FE800324;
        Thu, 28 Apr 2022 08:59:30 +0800 (CST)
From:   Jianqun Xu <jay.xu@rock-chips.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com
Cc:     davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jianqun Xu <jay.xu@rock-chips.com>
Subject: [PATCH] ethernet: stmmac: fix for none child queue node for tx node
Date:   Thu, 28 Apr 2022 08:59:28 +0800
Message-Id: <20220428005928.525921-1-jay.xu@rock-chips.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlKS0tKN1dZLVlBSVdZDwkaFQgSH1lBWRlMGEJWSUgdGktITx
        hKThlIVRMBExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktISkNVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MyI6Cyo5FT04OhM1ES41CkM3
        IzEwFBlVSlVKTU5KSktMTkxKSktDVTMWGhIXVREaAlUDDjsJFBgQVhgTEgsIVRgUFkVZV1kSC1lB
        WU5DVUlJVUxVSkpPWVdZCAFZQUlKS0w3Bg++
X-HM-Tid: 0a806dae2479b03akuuu830fe800324
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of nothing to be set for tx node result in no child queue node
for the tx node, this patch init the queue to tx_queues_to_use instead
of 0 to support dt file set no queue node for tx node.

Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 2d8c095f3856..dfe2375bc3c6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -235,7 +235,7 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
 	else
 		plat->tx_sched_algorithm = MTL_TX_ALGORITHM_SP;
 
-	queue = 0;
+	queue = plat->tx_queues_to_use;
 
 	/* Processing individual TX queue config */
 	for_each_child_of_node(tx_node, q_node) {
-- 
2.25.1

