Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0185750BAFF
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 17:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449159AbiDVPDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449255AbiDVPDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:03:25 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 62FAA5C647
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 08:00:31 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 98B5B320133;
        Fri, 22 Apr 2022 16:00:30 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nhulq-0007BR-Dl; Fri, 22 Apr 2022 16:00:30 +0100
Subject: [PATCH net-next 16/28] sfc/siena: Rename functions in mcdi_port.h
 to avoid conflicts with sfc
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Fri, 22 Apr 2022 16:00:30 +0100
Message-ID: <165063963027.27138.5477919663401327059.stgit@palantir17.mph.net>
In-Reply-To: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
References: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,MAY_BE_FORGED,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For siena use efx_siena_ as the function prefix.
efx_mcdi_phy_get_caps() is not used in Siena, so it is removed.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/siena/mcdi_port.c |   13 +++----------
 drivers/net/ethernet/sfc/siena/mcdi_port.h |    7 +++----
 drivers/net/ethernet/sfc/siena/siena.c     |    6 +++---
 3 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena/mcdi_port.c b/drivers/net/ethernet/sfc/siena/mcdi_port.c
index 08d36cdccacc..4259be4674b0 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi_port.c
+++ b/drivers/net/ethernet/sfc/siena/mcdi_port.c
@@ -70,14 +70,7 @@ static int efx_mcdi_mdio_write(struct net_device *net_dev,
 	return 0;
 }
 
-u32 efx_mcdi_phy_get_caps(struct efx_nic *efx)
-{
-	struct efx_mcdi_phy_data *phy_data = efx->phy_data;
-
-	return phy_data->supported_cap;
-}
-
-bool efx_mcdi_mac_check_fault(struct efx_nic *efx)
+bool efx_siena_mcdi_mac_check_fault(struct efx_nic *efx)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LINK_OUT_LEN);
 	size_t outlength;
@@ -93,7 +86,7 @@ bool efx_mcdi_mac_check_fault(struct efx_nic *efx)
 	return MCDI_DWORD(outbuf, GET_LINK_OUT_MAC_FAULT) != 0;
 }
 
-int efx_mcdi_port_probe(struct efx_nic *efx)
+int efx_siena_mcdi_port_probe(struct efx_nic *efx)
 {
 	int rc;
 
@@ -110,7 +103,7 @@ int efx_mcdi_port_probe(struct efx_nic *efx)
 	return efx_mcdi_mac_init_stats(efx);
 }
 
-void efx_mcdi_port_remove(struct efx_nic *efx)
+void efx_siena_mcdi_port_remove(struct efx_nic *efx)
 {
 	efx_mcdi_phy_remove(efx);
 	efx_mcdi_mac_fini_stats(efx);
diff --git a/drivers/net/ethernet/sfc/siena/mcdi_port.h b/drivers/net/ethernet/sfc/siena/mcdi_port.h
index 07863ddbe740..7b4ae250b51f 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi_port.h
+++ b/drivers/net/ethernet/sfc/siena/mcdi_port.h
@@ -10,9 +10,8 @@
 
 #include "net_driver.h"
 
-u32 efx_mcdi_phy_get_caps(struct efx_nic *efx);
-bool efx_mcdi_mac_check_fault(struct efx_nic *efx);
-int efx_mcdi_port_probe(struct efx_nic *efx);
-void efx_mcdi_port_remove(struct efx_nic *efx);
+bool efx_siena_mcdi_mac_check_fault(struct efx_nic *efx);
+int efx_siena_mcdi_port_probe(struct efx_nic *efx);
+void efx_siena_mcdi_port_remove(struct efx_nic *efx);
 
 #endif /* EFX_MCDI_PORT_H */
diff --git a/drivers/net/ethernet/sfc/siena/siena.c b/drivers/net/ethernet/sfc/siena/siena.c
index 6874a4cbd9ec..3cf55b44736a 100644
--- a/drivers/net/ethernet/sfc/siena/siena.c
+++ b/drivers/net/ethernet/sfc/siena/siena.c
@@ -993,8 +993,8 @@ const struct efx_nic_type siena_a0_nic_type = {
 	.map_reset_reason = efx_siena_mcdi_map_reset_reason,
 	.map_reset_flags = siena_map_reset_flags,
 	.reset = efx_siena_mcdi_reset,
-	.probe_port = efx_mcdi_port_probe,
-	.remove_port = efx_mcdi_port_remove,
+	.probe_port = efx_siena_mcdi_port_probe,
+	.remove_port = efx_siena_mcdi_port_remove,
 	.fini_dmaq = efx_farch_fini_dmaq,
 	.prepare_flush = efx_siena_prepare_flush,
 	.finish_flush = siena_finish_flush,
@@ -1007,7 +1007,7 @@ const struct efx_nic_type siena_a0_nic_type = {
 	.stop_stats = efx_siena_mcdi_mac_stop_stats,
 	.push_irq_moderation = siena_push_irq_moderation,
 	.reconfigure_mac = siena_mac_reconfigure,
-	.check_mac_fault = efx_mcdi_mac_check_fault,
+	.check_mac_fault = efx_siena_mcdi_mac_check_fault,
 	.reconfigure_port = efx_mcdi_port_reconfigure,
 	.get_wol = siena_get_wol,
 	.set_wol = siena_set_wol,

