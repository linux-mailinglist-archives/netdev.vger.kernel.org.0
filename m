Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0D6646DBC
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 12:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiLHLAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 06:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbiLHLAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 06:00:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A192677;
        Thu,  8 Dec 2022 02:55:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A079EB82396;
        Thu,  8 Dec 2022 10:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3DBC433C1;
        Thu,  8 Dec 2022 10:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670496942;
        bh=OtqWu+aDjadxVuvyRi4BAI56AMslW80IYarQiIJA7e0=;
        h=From:To:Cc:Subject:Date:From;
        b=gQijJEMdCmHyZjO0UuTDe3wRIednN+54/3N4FMY+E5t2qjy5gXBf9XSEqfkxz8yG9
         ZPx79XhwHov5QwYIcRZMdK02QVCya3GawEc+CqvbFzQhjUKGm7WUwApylzUblj1cjZ
         OZnY+KTU0xktR5tZ6mnMYnGF+FB0dqgjRHt0vRH63kQItSi9jceqWoivA/61AbNXR+
         2C4y/STnPkrqhwJqC+vDHKJMNL/ViT+AGtm8F6tWTmQkZXJitVVNUSz8DHQ0J86OPt
         rrxCJgWK5n4wRM3HozEMMR2ND26PeMS/FqPVZAbvVtuf8zgA11pjnnqKWQF+M+sGRF
         R0T+E2MV3O9bw==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net, maciej.fijalkowski@intel.com, kuba@kernel.org
Cc:     andrew@lunn.ch, edumazet@google.com, pabeni@redhat.com,
        vigneshr@ti.com, s-vadapalli@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roger Quadros <rogerq@kernel.org>
Subject: [PATCH net-next] net: ethernet: ti: am65-cpsw: Fix PM runtime leakage in am65_cpsw_nuss_ndo_slave_open()
Date:   Thu,  8 Dec 2022 12:55:34 +0200
Message-Id: <20221208105534.63709-1-rogerq@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure pm_runtime_put() is issued in error path.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Roger Quadros <rogerq@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index b8f7080434cb..58c20e4c0e9f 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -573,20 +573,21 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
 	reg = cpsw_sl_reg_read(port->slave.mac_sl, CPSW_SL_SOFT_RESET);
 	if (reg) {
 		dev_err(common->dev, "soft RESET didn't complete\n");
-		return -ETIMEDOUT;
+		ret = -ETIMEDOUT;
+		goto runtime_put;
 	}
 
 	/* Notify the stack of the actual queue counts. */
 	ret = netif_set_real_num_tx_queues(ndev, common->tx_ch_num);
 	if (ret) {
 		dev_err(common->dev, "cannot set real number of tx queues\n");
-		return ret;
+		goto runtime_put;
 	}
 
 	ret = netif_set_real_num_rx_queues(ndev, AM65_CPSW_MAX_RX_QUEUES);
 	if (ret) {
 		dev_err(common->dev, "cannot set real number of rx queues\n");
-		return ret;
+		goto runtime_put;
 	}
 
 	for (i = 0; i < common->tx_ch_num; i++)
@@ -594,7 +595,7 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
 
 	ret = am65_cpsw_nuss_common_open(common);
 	if (ret)
-		return ret;
+		goto runtime_put;
 
 	common->usage_count++;
 
@@ -622,6 +623,10 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
 error_cleanup:
 	am65_cpsw_nuss_ndo_slave_stop(ndev);
 	return ret;
+
+runtime_put:
+	pm_runtime_put(common->dev);
+	return ret;
 }
 
 static void am65_cpsw_nuss_rx_cleanup(void *data, dma_addr_t desc_dma)
-- 
2.34.1

