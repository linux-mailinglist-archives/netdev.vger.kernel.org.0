Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20425180107
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 16:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbgCJPEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 11:04:16 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:14440 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727749AbgCJPEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 11:04:15 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02AF1eWW007670;
        Tue, 10 Mar 2020 08:04:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=ooQR8R5IrPToVdQAx5t3z3sEiP/z/8ltWN3bsKpV+kQ=;
 b=FgA1FJKPBrp6Xs7bjUWMzVljWSglhfQUQ3NuKKCKsQxHQOcCw98P6H/wBdloI5DZrFCa
 oN2gtH54bAwxp9I8g8pwTTVhsQVY2L4VaBrH/Tj35voUonw3Yy/le6BVhfvJJmTZco4A
 6xY8NzMWxXB0odsjOaLfV5VTkoiMZQMn530WlP5IQxT8sjKrpAOwyWUaaD7GHPIyU+Aj
 Fw76W13SflrhWluRxctxcHkLP6L0lwqbuR1HG3QizLedY20S58xngsUPUwSBj80HIG2o
 SN36VELpUK0JiP/pqsoTwd9hd58R3Oiledwnz+wu2XDm5dFveEBHkLEIaB1gYkjkyqrW ig== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ym9uwpm7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Mar 2020 08:04:13 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Mar
 2020 08:04:11 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 10 Mar 2020 08:04:11 -0700
Received: from NN-LT0019.rdc.aquantia.com (nn-lt0019.marvell.com [10.9.16.69])
        by maili.marvell.com (Postfix) with ESMTP id B42C63F703F;
        Tue, 10 Mar 2020 08:04:10 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [RFC v2 09/16] net: macsec: report real_dev features when HW offloading is enabled
Date:   Tue, 10 Mar 2020 18:03:35 +0300
Message-ID: <20200310150342.1701-10-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200310150342.1701-1-irusskikh@marvell.com>
References: <20200310150342.1701-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_08:2020-03-10,2020-03-10 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch makes real_dev_feature propagation by MACSec offloaded device.

Issue description:
real_dev features are disabled upon macsec creation.

Root cause:
Features limitation (specific to SW MACSec limitation) is being applied
to HW offloaded case as well.
This causes 'set_features' request on the real_dev with reduced feature
set due to chain propagation.

Proposed solution:
Report real_dev features when HW offloading is enabled.
NB! MACSec offloaded device does not propagate VLAN offload features at
the moment. This can potentially be added later on as a separate patch.

Note: this patch requires HW offloading to be enabled by default in order
to function properly.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/macsec.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 58396b5193fd..822380e14093 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2469,6 +2469,10 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 		goto rollback;
 
 	rtnl_unlock();
+	/* Force features update, since they are different for SW MACSec and
+	 * HW offloading cases.
+	 */
+	netdev_update_features(dev);
 	return 0;
 
 rollback:
@@ -3214,9 +3218,16 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
 	return ret;
 }
 
-#define MACSEC_FEATURES \
+#define SW_MACSEC_FEATURES \
 	(NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_FRAGLIST)
 
+/* If h/w offloading is enabled, use real device features save for
+ *   VLAN_FEATURES - they require additional ops
+ *   HW_MACSEC - no reason to report it
+ */
+#define REAL_DEV_FEATURES(dev) \
+	((dev)->features & ~(NETIF_F_VLAN_FEATURES | NETIF_F_HW_MACSEC))
+
 static int macsec_dev_init(struct net_device *dev)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
@@ -3233,8 +3244,12 @@ static int macsec_dev_init(struct net_device *dev)
 		return err;
 	}
 
-	dev->features = real_dev->features & MACSEC_FEATURES;
-	dev->features |= NETIF_F_LLTX | NETIF_F_GSO_SOFTWARE;
+	if (macsec_is_offloaded(macsec)) {
+		dev->features = REAL_DEV_FEATURES(real_dev);
+	} else {
+		dev->features = real_dev->features & SW_MACSEC_FEATURES;
+		dev->features |= NETIF_F_LLTX | NETIF_F_GSO_SOFTWARE;
+	}
 
 	dev->needed_headroom = real_dev->needed_headroom +
 			       MACSEC_NEEDED_HEADROOM;
@@ -3263,7 +3278,10 @@ static netdev_features_t macsec_fix_features(struct net_device *dev,
 	struct macsec_dev *macsec = macsec_priv(dev);
 	struct net_device *real_dev = macsec->real_dev;
 
-	features &= (real_dev->features & MACSEC_FEATURES) |
+	if (macsec_is_offloaded(macsec))
+		return REAL_DEV_FEATURES(real_dev);
+
+	features &= (real_dev->features & SW_MACSEC_FEATURES) |
 		    NETIF_F_GSO_SOFTWARE | NETIF_F_SOFT_FEATURES;
 	features |= NETIF_F_LLTX;
 
-- 
2.17.1

