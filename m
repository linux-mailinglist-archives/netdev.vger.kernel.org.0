Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67A9C18F571
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 14:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgCWNPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 09:15:06 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42988 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728426AbgCWNPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 09:15:05 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02ND6Mu3019109;
        Mon, 23 Mar 2020 06:15:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=27XNLfjtBUuh8iOjOQFchNQOTsTcMCRC1b7HI0X+t4M=;
 b=TcV6k5ewDL5VsnFzKnzITzN+uIHMTeKbZfY61HDT6olhA3fFjQyJMqYR2GOGF0mmwvrk
 zXkXfPQkIwTOHupAkW8l/JpYPZBg8/FYv5LtnsA/u6bbcx8iS6CoA03bYNaOYzsgaozp
 KH3a4XaI3JWxDIEuUMXRABtePkUqtSubn5vYqXSi1CEugUjcAOfmbtqb1CLiUdhvBPjb
 M+hfX4BMeZtDHCK2pJHL6bX9MSrU7zZ5vpQlRcH70DP5KfmoNTSJJKXQA6HRw/nTUKUz
 pduCtJxR0CqDdY6GyK4cdriBz2CaWhZqzRXsY6/HPuJu8z/+b8dja7MCUvJmrH3qV+9G Pw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ywvkqmn4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Mar 2020 06:15:02 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Mar
 2020 06:15:00 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 23 Mar 2020 06:14:59 -0700
Received: from localhost.localdomain (unknown [10.9.16.91])
        by maili.marvell.com (Postfix) with ESMTP id 6EFA93F7040;
        Mon, 23 Mar 2020 06:14:58 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH net-next 09/17] net: macsec: report real_dev features when HW offloading is enabled
Date:   Mon, 23 Mar 2020 16:13:40 +0300
Message-ID: <20200323131348.340-10-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200323131348.340-1-irusskikh@marvell.com>
References: <20200323131348.340-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-23_04:2020-03-21,2020-03-23 signatures=0
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
index 59bf7d5f39ff..da2e28e6c15d 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2632,6 +2632,10 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 		goto rollback;
 
 	rtnl_unlock();
+	/* Force features update, since they are different for SW MACSec and
+	 * HW offloading cases.
+	 */
+	netdev_update_features(dev);
 	return 0;
 
 rollback:
@@ -3398,9 +3402,16 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
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
@@ -3417,8 +3428,12 @@ static int macsec_dev_init(struct net_device *dev)
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
@@ -3447,7 +3462,10 @@ static netdev_features_t macsec_fix_features(struct net_device *dev,
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

