Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207AA523A2F
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 18:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344700AbiEKQUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 12:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344662AbiEKQU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 12:20:28 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DBAEA237B8D
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 09:20:26 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 265393200F2;
        Wed, 11 May 2022 17:20:26 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nop4b-0000Ds-UA; Wed, 11 May 2022 17:20:25 +0100
Subject: [PATCH net-next 6/6] sfc/siena: Reinstate SRIOV init/fini function
 calls
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Wed, 11 May 2022 17:20:25 +0100
Message-ID: <165228602579.696.13026076797222373028.stgit@palantir17.mph.net>
In-Reply-To: <165228589518.696.7119477411428288875.stgit@palantir17.mph.net>
References: <165228589518.696.7119477411428288875.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,MAY_BE_FORGED,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

They were removed in the first series since they were not used for EF10.
Put that code back for Siena, with the prototypes in siena_sriov.h
since that file is a more applicable place for it.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/siena/efx.c         |   16 ++++++++++++++++
 drivers/net/ethernet/sfc/siena/siena_sriov.h |    3 +++
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index 01809666a3d1..63d999e63960 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -32,6 +32,9 @@
 #include "io.h"
 #include "selftest.h"
 #include "sriov.h"
+#ifdef CONFIG_SFC_SIENA_SRIOV
+#include "siena_sriov.h"
+#endif
 
 #include "mcdi_port_common.h"
 #include "mcdi_pcol.h"
@@ -1271,6 +1274,12 @@ static int __init efx_init_module(void)
 	if (rc)
 		goto err_notifier;
 
+#ifdef CONFIG_SFC_SIENA_SRIOV
+	rc = efx_init_sriov();
+	if (rc)
+		goto err_sriov;
+#endif
+
 	rc = efx_siena_create_reset_workqueue();
 	if (rc)
 		goto err_reset;
@@ -1284,6 +1293,10 @@ static int __init efx_init_module(void)
  err_pci:
 	efx_siena_destroy_reset_workqueue();
  err_reset:
+#ifdef CONFIG_SFC_SIENA_SRIOV
+	efx_fini_sriov();
+ err_sriov:
+#endif
 	unregister_netdevice_notifier(&efx_netdev_notifier);
  err_notifier:
 	return rc;
@@ -1295,6 +1308,9 @@ static void __exit efx_exit_module(void)
 
 	pci_unregister_driver(&efx_pci_driver);
 	efx_siena_destroy_reset_workqueue();
+#ifdef CONFIG_SFC_SIENA_SRIOV
+	efx_fini_sriov();
+#endif
 	unregister_netdevice_notifier(&efx_netdev_notifier);
 
 }
diff --git a/drivers/net/ethernet/sfc/siena/siena_sriov.h b/drivers/net/ethernet/sfc/siena/siena_sriov.h
index 69a7a18e9ba0..50f6e924495e 100644
--- a/drivers/net/ethernet/sfc/siena/siena_sriov.h
+++ b/drivers/net/ethernet/sfc/siena/siena_sriov.h
@@ -60,6 +60,9 @@ static inline bool efx_siena_sriov_enabled(struct efx_nic *efx)
 {
 	return efx->vf_init_count != 0;
 }
+
+int efx_init_sriov(void);
+void efx_fini_sriov(void);
 #else /* !CONFIG_SFC_SIENA_SRIOV */
 static inline bool efx_siena_sriov_enabled(struct efx_nic *efx)
 {

