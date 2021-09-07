Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC3D4027C3
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 13:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244885AbhIGLb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 07:31:28 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:12955 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S244596AbhIGLbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 07:31:23 -0400
X-IronPort-AV: E=Sophos;i="5.85,274,1624287600"; 
   d="scan'208";a="93244688"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 07 Sep 2021 20:30:15 +0900
Received: from localhost.localdomain (unknown [10.166.14.185])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id D7E57436CD94;
        Tue,  7 Sep 2021 20:30:15 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     s.shtylyov@omp.ru, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH] net: renesas: sh_eth: Fix freeing wrong tx descriptor
Date:   Tue,  7 Sep 2021 20:29:40 +0900
Message-Id: <20210907112940.967985-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cur_tx counter must be incremented after TACT bit of
txdesc->status was set. However, a CPU is possible to reorder
instructions and/or memory accesses between cur_tx and
txdesc->status. And then, if TX interrupt happened at such a
timing, the sh_eth_tx_free() may free the descriptor wrongly.
So, add wmb() before cur_tx++.
Otherwise NETDEV WATCHDOG timeout is possible to happen.

Fixes: 86a74ff21a7a ("net: sh_eth: add support for Renesas SuperH Ethernet")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/sh_eth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 6c8ba916d1a6..1374faa229a2 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2533,6 +2533,7 @@ static netdev_tx_t sh_eth_start_xmit(struct sk_buff *skb,
 	else
 		txdesc->status |= cpu_to_le32(TD_TACT);
 
+	wmb(); /* cur_tx must be incremented after TACT bit was set */
 	mdp->cur_tx++;
 
 	if (!(sh_eth_read(ndev, EDTRR) & mdp->cd->edtrr_trns))
-- 
2.25.1

