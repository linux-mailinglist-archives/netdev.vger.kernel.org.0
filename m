Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9F5551F36
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 16:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244806AbiFTOkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 10:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244710AbiFTOjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 10:39:49 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E99A0BC7
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 06:58:50 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id E1B55320133;
        Mon, 20 Jun 2022 14:58:49 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.95)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1o3HvV-0000oG-LJ;
        Mon, 20 Jun 2022 14:58:49 +0100
Subject: [PATCH net-next 3/8] sfc: Remove netdev init from efx_init_struct
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     jonathan.s.cooper@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Mon, 20 Jun 2022 14:58:49 +0100
Message-ID: <165573352954.2982.2932122889457035658.stgit@palantir17.mph.net>
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

Move functionality involving the struct net_device out of
efx_init_struct so that we can initialise without a net dev
for VDPA operation.

Signed-off-by: Jon Cooper <jonathan.s.cooper@amd.com>
Co-authored-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100.c      |    4 +++-
 drivers/net/ethernet/sfc/efx.c        |    3 ++-
 drivers/net/ethernet/sfc/efx_common.c |    5 +----
 drivers/net/ethernet/sfc/efx_common.h |    3 +--
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100.c b/drivers/net/ethernet/sfc/ef100.c
index 173f0ecebc70..3b8f02b59d31 100644
--- a/drivers/net/ethernet/sfc/ef100.c
+++ b/drivers/net/ethernet/sfc/ef100.c
@@ -469,10 +469,12 @@ static int ef100_pci_probe(struct pci_dev *pci_dev,
 
 	pci_set_drvdata(pci_dev, efx);
 	SET_NETDEV_DEV(net_dev, &pci_dev->dev);
-	rc = efx_init_struct(efx, pci_dev, net_dev);
+	efx->net_dev = net_dev;
+	rc = efx_init_struct(efx, pci_dev);
 	if (rc)
 		goto fail;
 
+	efx->mdio.dev = net_dev;
 	efx->vi_stride = EF100_DEFAULT_VI_STRIDE;
 	netif_info(efx, probe, efx->net_dev,
 		   "Solarflare EF100 NIC detected\n");
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 7f4e96a422e6..955271ff06bb 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1056,9 +1056,10 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 
 	pci_set_drvdata(pci_dev, efx);
 	SET_NETDEV_DEV(net_dev, &pci_dev->dev);
-	rc = efx_init_struct(efx, pci_dev, net_dev);
+	rc = efx_init_struct(efx, pci_dev);
 	if (rc)
 		goto fail1;
+	efx->mdio.dev = net_dev;
 
 	pci_info(pci_dev, "Solarflare NIC detected\n");
 
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 0e0e86a53407..de37d415a6f9 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -978,8 +978,7 @@ void efx_port_dummy_op_void(struct efx_nic *efx) {}
 /* This zeroes out and then fills in the invariants in a struct
  * efx_nic (including all sub-structures).
  */
-int efx_init_struct(struct efx_nic *efx,
-		    struct pci_dev *pci_dev, struct net_device *net_dev)
+int efx_init_struct(struct efx_nic *efx, struct pci_dev *pci_dev)
 {
 	int rc = -ENOMEM;
 
@@ -998,7 +997,6 @@ int efx_init_struct(struct efx_nic *efx,
 	efx->state = STATE_UNINIT;
 	strlcpy(efx->name, pci_name(pci_dev), sizeof(efx->name));
 
-	efx->net_dev = net_dev;
 	efx->rx_prefix_size = efx->type->rx_prefix_size;
 	efx->rx_ip_align =
 		NET_IP_ALIGN ? (efx->rx_prefix_size + NET_IP_ALIGN) % 4 : 0;
@@ -1023,7 +1021,6 @@ int efx_init_struct(struct efx_nic *efx,
 	efx->rps_hash_table = kcalloc(EFX_ARFS_HASH_TABLE_SIZE,
 				      sizeof(*efx->rps_hash_table), GFP_KERNEL);
 #endif
-	efx->mdio.dev = net_dev;
 	INIT_WORK(&efx->mac_work, efx_mac_work);
 	init_waitqueue_head(&efx->flush_wq);
 
diff --git a/drivers/net/ethernet/sfc/efx_common.h b/drivers/net/ethernet/sfc/efx_common.h
index 1d166ca71354..048793a36061 100644
--- a/drivers/net/ethernet/sfc/efx_common.h
+++ b/drivers/net/ethernet/sfc/efx_common.h
@@ -14,8 +14,7 @@
 int efx_init_io(struct efx_nic *efx, int bar, dma_addr_t dma_mask,
 		unsigned int mem_map_size);
 void efx_fini_io(struct efx_nic *efx);
-int efx_init_struct(struct efx_nic *efx, struct pci_dev *pci_dev,
-		    struct net_device *net_dev);
+int efx_init_struct(struct efx_nic *efx, struct pci_dev *pci_dev);
 void efx_fini_struct(struct efx_nic *efx);
 
 #define EFX_MAX_DMAQ_SIZE 4096UL


