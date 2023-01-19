Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9CC6730CF
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 05:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjASE6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 23:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjASE5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 23:57:45 -0500
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F21B75708;
        Wed, 18 Jan 2023 20:49:38 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.97,226,1669042800"; 
   d="scan'208";a="146811650"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 19 Jan 2023 13:39:23 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id CC6344188CFF;
        Thu, 19 Jan 2023 13:39:23 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     s.shtylyov@omp.ru, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net 2/2] net: ravb: Fix possible hang if RIS2_QFF1 happen
Date:   Thu, 19 Jan 2023 13:39:20 +0900
Message-Id: <20230119043920.875280-3-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230119043920.875280-1-yoshihiro.shimoda.uh@renesas.com>
References: <20230119043920.875280-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since this driver enables the interrupt by RIC2_QFE1, this driver
should clear the interrupt flag if it happens. Otherwise, the interrupt
causes to hang the system.

Fixes: a0d2f20650e8 ("Renesas Ethernet AVB PTP clock driver")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/ravb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 3f61100c02f4..bcbb62f90fb7 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1101,7 +1101,7 @@ static void ravb_error_interrupt(struct net_device *ndev)
 	ravb_write(ndev, ~(EIS_QFS | EIS_RESERVED), EIS);
 	if (eis & EIS_QFS) {
 		ris2 = ravb_read(ndev, RIS2);
-		ravb_write(ndev, ~(RIS2_QFF0 | RIS2_RFFF | RIS2_RESERVED),
+		ravb_write(ndev, ~(RIS2_QFF0 | RIS2_QFF1 | RIS2_RFFF | RIS2_RESERVED),
 			   RIS2);
 
 		/* Receive Descriptor Empty int */
-- 
2.25.1

