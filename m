Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E85F551F2A
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 16:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243780AbiFTOkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 10:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242623AbiFTOjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 10:39:40 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 685C217E0B
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 06:58:38 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 80E25320133;
        Mon, 20 Jun 2022 14:58:37 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.95)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1o3HvJ-0000o6-83;
        Mon, 20 Jun 2022 14:58:37 +0100
Subject: [PATCH net-next 2/8] sfc: Add a PROBED state for EF100 VDPA use.
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     jonathan.s.cooper@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Mon, 20 Jun 2022 14:58:37 +0100
Message-ID: <165573351712.2982.9135500081206138211.stgit@palantir17.mph.net>
In-Reply-To: <165573340676.2982.8456666672406894221.stgit@palantir17.mph.net>
References: <165573340676.2982.8456666672406894221.stgit@palantir17.mph.net>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,NML_ADSP_CUSTOM_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Cooper <jonathan.s.cooper@amd.com>

For VDPA we need to tear down the driver to the point where it
has various control channels like MCDI, but it no longer has
a network device. This adds a state corresponding to
that mode that will be used when VDPA support is added.

Signed-off-by: Jonathan Cooper <jonathan.s.cooper@amd.com>
Co-authored-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_netdev.c |    2 +-
 drivers/net/ethernet/sfc/efx_common.c   |    6 ++++--
 drivers/net/ethernet/sfc/efx_common.h   |    8 ++++----
 drivers/net/ethernet/sfc/net_driver.h   |    3 ++-
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index b9106ce678d9..3bb9a79bad22 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -291,7 +291,7 @@ void ef100_unregister_netdev(struct efx_nic *efx)
 {
 	if (efx_dev_registered(efx)) {
 		efx_fini_mcdi_logging(efx);
-		efx->state = STATE_UNINIT;
+		efx->state = STATE_PROBED;
 		unregister_netdev(efx->net_dev);
 	}
 }
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index f6baebd9d632..0e0e86a53407 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -1222,8 +1222,10 @@ static pci_ers_result_t efx_io_error_detected(struct pci_dev *pdev,
 
 		efx_device_detach_sync(efx);
 
-		efx_stop_all(efx);
-		efx_disable_interrupts(efx);
+		if (efx_net_active(efx->state)) {
+			efx_stop_all(efx);
+			efx_disable_interrupts(efx);
+		}
 
 		status = PCI_ERS_RESULT_NEED_RESET;
 	} else {
diff --git a/drivers/net/ethernet/sfc/efx_common.h b/drivers/net/ethernet/sfc/efx_common.h
index c72e819da8fd..1d166ca71354 100644
--- a/drivers/net/ethernet/sfc/efx_common.h
+++ b/drivers/net/ethernet/sfc/efx_common.h
@@ -43,10 +43,10 @@ void efx_start_monitor(struct efx_nic *efx);
 int __efx_reconfigure_port(struct efx_nic *efx);
 int efx_reconfigure_port(struct efx_nic *efx);
 
-#define EFX_ASSERT_RESET_SERIALISED(efx)		\
-	do {						\
-		if (efx->state != STATE_UNINIT)		\
-			ASSERT_RTNL();			\
+#define EFX_ASSERT_RESET_SERIALISED(efx)					\
+	do {									\
+		if (efx->state != STATE_UNINIT && efx->state != STATE_PROBED)	\
+			ASSERT_RTNL();						\
 	} while (0)
 
 int efx_try_recovery(struct efx_nic *efx);
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 95069125931a..546552d5d86f 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -623,7 +623,8 @@ enum efx_int_mode {
 
 enum nic_state {
 	STATE_UNINIT = 0,	/* device being probed/removed */
-	STATE_NET_DOWN,		/* hardware probed and netdev registered */
+	STATE_PROBED,		/* hardware probed */
+	STATE_NET_DOWN,		/* netdev registered */
 	STATE_NET_UP,		/* ready for traffic */
 	STATE_DISABLED,		/* device disabled due to hardware errors */
 


