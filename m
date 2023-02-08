Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBCE68F3E0
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 17:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbjBHQ7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 11:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjBHQ7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 11:59:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D203C474D0;
        Wed,  8 Feb 2023 08:59:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72120B81EFB;
        Wed,  8 Feb 2023 16:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AF8C433D2;
        Wed,  8 Feb 2023 16:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675875541;
        bh=Gj5NRKqybItj0xxEFiMe2z728DTC1M/P0sMUgGnY31Q=;
        h=From:To:Cc:Subject:Date:From;
        b=NWTRteUVW2Mk3vP9nLN11PGqd7UGcqecVRENhdWW8VRazXqfApGN7yat4KN+xDeBC
         yji3VPzq7WyERX8ZBYFSU93X7n0U9ppA9RBpoBEd1Qfiv93jbIalOKtUQgT2jsrpKs
         AqE/MGOeerky/nkGQLOOmpaIPyKuv92nDhdOOqfi3CWLnlP2dzxJwp+ir/XeuBGTbE
         jHNFIl+XP7XN7KGowU9rnwlzWUc3QCPC3DqtIHhfK/CtDOW287FEjiZ392two5ifZN
         YsrEPqUiLZtjleeZMeVE4XceNrMCMxVyvUJ9bIZJIo+aCalgpcedn0N1DXaQcpr2V3
         K3NKpnCZOnNCw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        lorenzo.bianconi@redhat.com, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com
Subject: [PATCH bpf-next] sfc: move xdp_features configuration in efx_pci_probe_post_io()
Date:   Wed,  8 Feb 2023 17:58:40 +0100
Message-Id: <9bd31c9a29bcf406ab90a249a28fc328e5578fd1.1675875404.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move xdp_features configuration from efx_pci_probe() to
efx_pci_probe_post_io() since it is where all the other basic netdev
features are initialised.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/sfc/efx.c       | 8 ++++----
 drivers/net/ethernet/sfc/siena/efx.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 18ff8d8cff42..9569c3356b4a 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1025,6 +1025,10 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	net_dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
 	net_dev->features |= efx->fixed_features;
 
+	net_dev->xdp_features = NETDEV_XDP_ACT_BASIC |
+				NETDEV_XDP_ACT_REDIRECT |
+				NETDEV_XDP_ACT_NDO_XMIT;
+
 	rc = efx_register_netdev(efx);
 	if (!rc)
 		return 0;
@@ -1078,10 +1082,6 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 
 	pci_info(pci_dev, "Solarflare NIC detected\n");
 
-	efx->net_dev->xdp_features = NETDEV_XDP_ACT_BASIC |
-				     NETDEV_XDP_ACT_REDIRECT |
-				     NETDEV_XDP_ACT_NDO_XMIT;
-
 	if (!efx->type->is_vf)
 		efx_probe_vpd_strings(efx);
 
diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index a6ef21845224..ef52ec71d197 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -1007,6 +1007,10 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	net_dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
 	net_dev->features |= efx->fixed_features;
 
+	net_dev->xdp_features = NETDEV_XDP_ACT_BASIC |
+				NETDEV_XDP_ACT_REDIRECT |
+				NETDEV_XDP_ACT_NDO_XMIT;
+
 	rc = efx_register_netdev(efx);
 	if (!rc)
 		return 0;
@@ -1048,10 +1052,6 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 
 	pci_info(pci_dev, "Solarflare NIC detected\n");
 
-	efx->net_dev->xdp_features = NETDEV_XDP_ACT_BASIC |
-				     NETDEV_XDP_ACT_REDIRECT |
-				     NETDEV_XDP_ACT_NDO_XMIT;
-
 	if (!efx->type->is_vf)
 		efx_probe_vpd_strings(efx);
 
-- 
2.39.1

