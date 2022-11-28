Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386A163A1AF
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 07:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiK1G54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 01:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiK1G5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 01:57:30 -0500
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 901C1165BA;
        Sun, 27 Nov 2022 22:56:47 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.96,199,1665414000"; 
   d="scan'208";a="141430220"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 28 Nov 2022 15:56:46 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 1452540041A5;
        Mon, 28 Nov 2022 15:56:46 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     s.shtylyov@omp.ru, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Tho Vu <tho.vu.wh@renesas.com>
Subject: [PATCH net] net: ethernet: renesas: ravb: Fix promiscuous mode after system resumed
Date:   Mon, 28 Nov 2022 15:56:04 +0900
Message-Id: <20221128065604.1864391-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After system resumed on some environment board, the promiscuous mode
is disabled because the SoC turned off. So, call ravb_set_rx_mode() in
the ravb_resume() to fix the issue.

Reported-by: Tho Vu <tho.vu.wh@renesas.com>
Fixes: 0184165b2f42 ("ravb: add sleep PM suspend/resume support")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/ravb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 36324126db6d..6bc923326268 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -3020,6 +3020,7 @@ static int __maybe_unused ravb_resume(struct device *dev)
 		ret = ravb_open(ndev);
 		if (ret < 0)
 			return ret;
+		ravb_set_rx_mode(ndev);
 		netif_device_attach(ndev);
 	}
 
-- 
2.25.1

