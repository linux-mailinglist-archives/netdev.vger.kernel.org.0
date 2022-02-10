Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA9344B08CC
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 09:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbiBJIri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 03:47:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237870AbiBJIrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 03:47:37 -0500
X-Greylist: delayed 2116 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Feb 2022 00:47:35 PST
Received: from plekste.mt.lv (bute.mt.lv [IPv6:2a02:610:7501:2000::195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0DD10B2;
        Thu, 10 Feb 2022 00:47:34 -0800 (PST)
Received: from [2a02:610:7501:feff:1ccf:41ff:fe50:18b9] (helo=localhost.localdomain)
        by plekste.mt.lv with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <gatis@mikrotik.com>)
        id 1nI4Yi-0005NK-8N; Thu, 10 Feb 2022 10:12:08 +0200
From:   Gatis Peisenieks <gatis@mikrotik.com>
To:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com, antons@mikrotik.com,
        eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gatis Peisenieks <gatis@mikrotik.com>
Subject: [PATCH net] atl1c: fix tx timeout after link flap on Mikrotik 10/25G NIC
Date:   Thu, 10 Feb 2022 10:12:01 +0200
Message-Id: <20220210081201.4184834-1-gatis@mikrotik.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If NIC had packets in tx queue at the moment link down event
happened, it could result in tx timeout when link got back up.

Since device has more than one tx queue we need to reset them
accordingly.

Signed-off-by: Gatis Peisenieks <gatis@mikrotik.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index da595242bc13..f50604f3e541 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -900,7 +900,7 @@ static void atl1c_clean_tx_ring(struct atl1c_adapter *adapter,
 		atl1c_clean_buffer(pdev, buffer_info);
 	}
 
-	netdev_reset_queue(adapter->netdev);
+	netdev_tx_reset_queue(netdev_get_tx_queue(adapter->netdev, queue));
 
 	/* Zero out Tx-buffers */
 	memset(tpd_ring->desc, 0, sizeof(struct atl1c_tpd_desc) *
-- 
2.31.1

