Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3CF15DA31
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729575AbgBNPDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:03:38 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:13776 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729567AbgBNPDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:03:37 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EF074F019190;
        Fri, 14 Feb 2020 07:03:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=9bFkcIfpRJG9OvQToyfoUONrgcxkU+1jNGJqQ9l+Ulg=;
 b=uyEwpwSyLi8xRLb+PJrcwOvJSEArPGOWvhM6MIBAhd1LnjuTg1GSoh4MX3r6erRvlMM2
 +g436dFWGs9h7S+TLWyw39b7/wdchem8c3WxEkDBnOk5/6iRlBEwdPDIxxfZFgubrUOy
 VPlvbUDVSfJRMbM3JyKKywzga55lAQkIWzK9S7IU8Bj+Zoy5wGOCa7tO+CVJcO0/By5P
 Uq3uA7KuJFmHfYIZBI9wIp+Fkpk0Qp+A8IA6+P5RE5hJL+f7efrRvcQ59XsOBrvarfv1
 6TLwzJJFEGUn6TcsoFJQhP472mFxViU19dnPy9lJ2HeDsh64ptIn5aR9UH59Zgk1Ok19 dg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2y4be2n5nf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 07:03:34 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:03:32 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:03:32 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 14 Feb 2020 07:03:31 -0800
Received: from NN-LT0019.rdc.aquantia.com (unknown [10.9.16.63])
        by maili.marvell.com (Postfix) with ESMTP id 518BE3F7043;
        Fri, 14 Feb 2020 07:03:30 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [RFC 11/18] net: macsec: report real_dev features when HW offloading is enabled
Date:   Fri, 14 Feb 2020 18:02:51 +0300
Message-ID: <20200214150258.390-12-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200214150258.390-1-irusskikh@marvell.com>
References: <20200214150258.390-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_04:2020-02-12,2020-02-14 signatures=0
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
index 38403037cea0..a3d96fffa84f 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2474,6 +2474,10 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 		goto rollback;
 
 	rtnl_unlock();
+	/* Force features update, since they are different for SW MACSec and
+	 * HW offloading cases.
+	 */
+	netdev_update_features(dev);
 	return 0;
 
 rollback:
@@ -3234,9 +3238,16 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
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
@@ -3253,8 +3264,12 @@ static int macsec_dev_init(struct net_device *dev)
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
@@ -3283,7 +3298,10 @@ static netdev_features_t macsec_fix_features(struct net_device *dev,
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

