Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E99050BB10
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 17:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449194AbiDVPFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449192AbiDVPE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:04:27 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7288F5D5F2
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 08:01:20 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 86E56320133;
        Fri, 22 Apr 2022 16:01:19 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nhumd-0007CL-Az; Fri, 22 Apr 2022 16:01:19 +0100
Subject: [PATCH net-next 20/28] sfc/siena: Inline functions in sriov.h to
 avoid conflicts with sfc
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Fri, 22 Apr 2022 16:01:19 +0100
Message-ID: <165063967919.27138.14706999257258120710.stgit@palantir17.mph.net>
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

The implementation of each is quite short. This means sriov.c is
not needed any more.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/siena/sriov.c |   72 --------------------------------
 drivers/net/ethernet/sfc/siena/sriov.h |   68 ++++++++++++++++++++++++++++--
 2 files changed, 63 insertions(+), 77 deletions(-)
 delete mode 100644 drivers/net/ethernet/sfc/siena/sriov.c

diff --git a/drivers/net/ethernet/sfc/siena/sriov.c b/drivers/net/ethernet/sfc/siena/sriov.c
deleted file mode 100644
index 3f241e6c881a..000000000000
--- a/drivers/net/ethernet/sfc/siena/sriov.c
+++ /dev/null
@@ -1,72 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/****************************************************************************
- * Driver for Solarflare network controllers and boards
- * Copyright 2014-2015 Solarflare Communications Inc.
- */
-#include <linux/module.h>
-#include "net_driver.h"
-#include "nic.h"
-#include "sriov.h"
-
-int efx_sriov_set_vf_mac(struct net_device *net_dev, int vf_i, u8 *mac)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-
-	if (efx->type->sriov_set_vf_mac)
-		return efx->type->sriov_set_vf_mac(efx, vf_i, mac);
-	else
-		return -EOPNOTSUPP;
-}
-
-int efx_sriov_set_vf_vlan(struct net_device *net_dev, int vf_i, u16 vlan,
-			  u8 qos, __be16 vlan_proto)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-
-	if (efx->type->sriov_set_vf_vlan) {
-		if ((vlan & ~VLAN_VID_MASK) ||
-		    (qos & ~(VLAN_PRIO_MASK >> VLAN_PRIO_SHIFT)))
-			return -EINVAL;
-
-		if (vlan_proto != htons(ETH_P_8021Q))
-			return -EPROTONOSUPPORT;
-
-		return efx->type->sriov_set_vf_vlan(efx, vf_i, vlan, qos);
-	} else {
-		return -EOPNOTSUPP;
-	}
-}
-
-int efx_sriov_set_vf_spoofchk(struct net_device *net_dev, int vf_i,
-			      bool spoofchk)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-
-	if (efx->type->sriov_set_vf_spoofchk)
-		return efx->type->sriov_set_vf_spoofchk(efx, vf_i, spoofchk);
-	else
-		return -EOPNOTSUPP;
-}
-
-int efx_sriov_get_vf_config(struct net_device *net_dev, int vf_i,
-			    struct ifla_vf_info *ivi)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-
-	if (efx->type->sriov_get_vf_config)
-		return efx->type->sriov_get_vf_config(efx, vf_i, ivi);
-	else
-		return -EOPNOTSUPP;
-}
-
-int efx_sriov_set_vf_link_state(struct net_device *net_dev, int vf_i,
-				int link_state)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-
-	if (efx->type->sriov_set_vf_link_state)
-		return efx->type->sriov_set_vf_link_state(efx, vf_i,
-							  link_state);
-	else
-		return -EOPNOTSUPP;
-}
diff --git a/drivers/net/ethernet/sfc/siena/sriov.h b/drivers/net/ethernet/sfc/siena/sriov.h
index 747707bee483..fbde67319d87 100644
--- a/drivers/net/ethernet/sfc/siena/sriov.h
+++ b/drivers/net/ethernet/sfc/siena/sriov.h
@@ -11,15 +11,73 @@
 
 #ifdef CONFIG_SFC_SRIOV
 
-int efx_sriov_set_vf_mac(struct net_device *net_dev, int vf_i, u8 *mac);
+static inline
+int efx_sriov_set_vf_mac(struct net_device *net_dev, int vf_i, u8 *mac)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+
+	if (efx->type->sriov_set_vf_mac)
+		return efx->type->sriov_set_vf_mac(efx, vf_i, mac);
+	else
+		return -EOPNOTSUPP;
+}
+
+static inline
 int efx_sriov_set_vf_vlan(struct net_device *net_dev, int vf_i, u16 vlan,
-			  u8 qos, __be16 vlan_proto);
+			  u8 qos, __be16 vlan_proto)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+
+	if (efx->type->sriov_set_vf_vlan) {
+		if ((vlan & ~VLAN_VID_MASK) ||
+		    (qos & ~(VLAN_PRIO_MASK >> VLAN_PRIO_SHIFT)))
+			return -EINVAL;
+
+		if (vlan_proto != htons(ETH_P_8021Q))
+			return -EPROTONOSUPPORT;
+
+		return efx->type->sriov_set_vf_vlan(efx, vf_i, vlan, qos);
+	} else {
+		return -EOPNOTSUPP;
+	}
+}
+
+static inline
 int efx_sriov_set_vf_spoofchk(struct net_device *net_dev, int vf_i,
-			      bool spoofchk);
+			      bool spoofchk)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+
+	if (efx->type->sriov_set_vf_spoofchk)
+		return efx->type->sriov_set_vf_spoofchk(efx, vf_i, spoofchk);
+	else
+		return -EOPNOTSUPP;
+}
+
+static inline
 int efx_sriov_get_vf_config(struct net_device *net_dev, int vf_i,
-			    struct ifla_vf_info *ivi);
+			    struct ifla_vf_info *ivi)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+
+	if (efx->type->sriov_get_vf_config)
+		return efx->type->sriov_get_vf_config(efx, vf_i, ivi);
+	else
+		return -EOPNOTSUPP;
+}
+
+static inline
 int efx_sriov_set_vf_link_state(struct net_device *net_dev, int vf_i,
-				int link_state);
+				int link_state)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+
+	if (efx->type->sriov_set_vf_link_state)
+		return efx->type->sriov_set_vf_link_state(efx, vf_i,
+							  link_state);
+	else
+		return -EOPNOTSUPP;
+}
 #endif /* CONFIG_SFC_SRIOV */
 
 #endif /* EFX_SRIOV_H */

