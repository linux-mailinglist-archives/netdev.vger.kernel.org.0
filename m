Return-Path: <netdev+bounces-9449-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 31FE972922A
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 10:04:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 793B01C210B2
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 08:04:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8516A940;
	Fri,  9 Jun 2023 08:04:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB17A921
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 08:04:23 +0000 (UTC)
X-Greylist: delayed 381 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 09 Jun 2023 01:04:00 PDT
Received: from mint-fitpc2.localdomain (unknown [81.168.73.77])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 83B1F3A82
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 01:04:00 -0700 (PDT)
Received: from palantir17.mph.net (palantir17 [192.168.0.4])
	by mint-fitpc2.localdomain (Postfix) with ESMTP id AD26D320299;
	Fri,  9 Jun 2023 08:57:37 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
	by palantir17.mph.net with esmtp (Exim 4.95)
	(envelope-from <habetsm.xilinx@gmail.com>)
	id 1q7X04-0000ic-OP;
	Fri, 09 Jun 2023 08:57:36 +0100
Subject: [PATCH net-next] sfc: Add devlink dev info support for EF10
From: Martin Habets <habetsm.xilinx@gmail.com>
To: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com
Cc: netdev@vger.kernel.org, ecree.xilinx@gmail.com, linux-net-drivers@amd.com
Date: Fri, 09 Jun 2023 08:57:36 +0100
Message-ID: <168629745652.2744.6477682091656094391.stgit@palantir17.mph.net>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,MAY_BE_FORGED,
	NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL,SPOOFED_FREEMAIL,
	SPOOF_GMAIL_MID,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Reuse the work done for EF100 to add devlink support for EF10.
There is no devlink port support for EF10.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/efx.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index a4f22d8e6ac7..d670a319b379 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -32,6 +32,7 @@
 #include "io.h"
 #include "selftest.h"
 #include "sriov.h"
+#include "efx_devlink.h"
 
 #include "mcdi_port_common.h"
 #include "mcdi_pcol.h"
@@ -877,6 +878,7 @@ static void efx_pci_remove(struct pci_dev *pci_dev)
 	if (efx->type->sriov_fini)
 		efx->type->sriov_fini(efx);
 
+	efx_fini_devlink_lock(efx);
 	efx_unregister_netdev(efx);
 
 	efx_mtd_remove(efx);
@@ -886,6 +888,7 @@ static void efx_pci_remove(struct pci_dev *pci_dev)
 	efx_fini_io(efx);
 	pci_dbg(efx->pci_dev, "shutdown successful\n");
 
+	efx_fini_devlink_and_unlock(efx);
 	efx_fini_struct(efx);
 	free_netdev(efx->net_dev);
 	probe_data = container_of(efx, struct efx_probe_data, efx);
@@ -1025,7 +1028,13 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 				NETDEV_XDP_ACT_REDIRECT |
 				NETDEV_XDP_ACT_NDO_XMIT;
 
+	/* devlink creation, registration and lock */
+	rc = efx_probe_devlink_and_lock(efx);
+	if (rc)
+		pci_err(efx->pci_dev, "devlink registration failed");
+
 	rc = efx_register_netdev(efx);
+	efx_probe_devlink_unlock(efx);
 	if (!rc)
 		return 0;
 



