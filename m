Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEC8E677C33
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 14:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbjAWNNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 08:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbjAWNNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 08:13:48 -0500
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F152913520;
        Mon, 23 Jan 2023 05:13:47 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.97,239,1669042800"; 
   d="scan'208";a="150308966"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 23 Jan 2023 22:13:46 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 63AA6422F212;
        Mon, 23 Jan 2023 22:13:46 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     s.shtylyov@omp.ru, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net v2 2/2] net: ravb: Fix possible hang if RIS2_QFF1 happen
Date:   Mon, 23 Jan 2023 22:13:31 +0900
Message-Id: <20230123131331.1425648-3-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123131331.1425648-1-yoshihiro.shimoda.uh@renesas.com>
References: <20230123131331.1425648-1-yoshihiro.shimoda.uh@renesas.com>
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

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/ravb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 3f61100c02f4..0f54849a3823 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1101,14 +1101,14 @@ static void ravb_error_interrupt(struct net_device *ndev)
 	ravb_write(ndev, ~(EIS_QFS | EIS_RESERVED), EIS);
 	if (eis & EIS_QFS) {
 		ris2 = ravb_read(ndev, RIS2);
-		ravb_write(ndev, ~(RIS2_QFF0 | RIS2_RFFF | RIS2_RESERVED),
+		ravb_write(ndev, ~(RIS2_QFF0 | RIS2_QFF1 | RIS2_RFFF | RIS2_RESERVED),
 			   RIS2);
 
 		/* Receive Descriptor Empty int */
 		if (ris2 & RIS2_QFF0)
 			priv->stats[RAVB_BE].rx_over_errors++;
 
-		    /* Receive Descriptor Empty int */
+		/* Receive Descriptor Empty int */
 		if (ris2 & RIS2_QFF1)
 			priv->stats[RAVB_NC].rx_over_errors++;
 
-- 
2.25.1

