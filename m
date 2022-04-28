Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF4F9512887
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 03:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238064AbiD1BMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 21:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbiD1BMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 21:12:47 -0400
Received: from mail-m121145.qiye.163.com (mail-m121145.qiye.163.com [115.236.121.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C8C72457;
        Wed, 27 Apr 2022 18:09:34 -0700 (PDT)
Received: from localhost.localdomain (unknown [58.22.7.114])
        by mail-m121145.qiye.163.com (Hmail) with ESMTPA id CCD26800371;
        Thu, 28 Apr 2022 09:09:29 +0800 (CST)
From:   Jianqun Xu <jay.xu@rock-chips.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com
Cc:     davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jianqun Xu <jay.xu@rock-chips.com>
Subject: [PATCH RESEND] ethernet: stmmac: fix for none child queue node for tx node
Date:   Thu, 28 Apr 2022 09:09:27 +0800
Message-Id: <20220428010927.526310-1-jay.xu@rock-chips.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlKS0tKN1dZLVlBSVdZDwkaFQgSH1lBWUIeS0NWQhpIH0seHk
        hJSUNLVRMBExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktISkNVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PxQ6Thw5Mz03PhNRLw42CDZN
        KisKFBJVSlVKTU5KSktDSkxLSExNVTMWGhIXVREaAlUDDjsJFBgQVhgTEgsIVRgUFkVZV1kSC1lB
        WU5DVUlJVUxVSkpPWVdZCAFZQUlLTUo3Bg++
X-HM-Tid: 0a806db7496cb03akuuuccd26800371
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

