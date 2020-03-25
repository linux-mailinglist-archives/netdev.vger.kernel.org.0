Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9ED1928F4
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 13:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbgCYMxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 08:53:18 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:65002 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727525AbgCYMxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 08:53:16 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02PCoqZr014609;
        Wed, 25 Mar 2020 05:53:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=27XNLfjtBUuh8iOjOQFchNQOTsTcMCRC1b7HI0X+t4M=;
 b=d+3vuWfs4j14jQMu5vEN8pjh2IjmP5XpfR2g+8P2PMyXIjzvBY7iZOjwHybYWg9Hys2G
 ySnTtPbbscH/vHo7/cVUe4l8gFfXCD4HYt0tDTN4q1WRZ6vLNuLQKMiHdYYtaIIlRzWE
 MuBXXv1JpDHDKOu+ExY9sFdZFHIHixiLvZvY2ENyGJbFOWzWk649KX7aAzcQOnAmQqgA
 H88jMOo48wjn9v3rCJMZA2JKxTget4pY3kLWsm4L/TggyQLpCYUc/d6X/sWBwfoYsVAs
 /3ZUqJjXfi73DDPvraMdZ5wgyGnMfnoq3Qyzq9io4eAVJorS61B56Ik5GwpeTZB8cqDy Eg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3006xkr5pw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Mar 2020 05:53:13 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Mar
 2020 05:53:12 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Mar 2020 05:53:11 -0700
Received: from localhost.localdomain (unknown [10.9.16.55])
        by maili.marvell.com (Postfix) with ESMTP id 837DF3F7041;
        Wed, 25 Mar 2020 05:53:10 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 09/17] net: macsec: report real_dev features when HW offloading is enabled
Date:   Wed, 25 Mar 2020 15:52:38 +0300
Message-ID: <20200325125246.987-10-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200325125246.987-1-irusskikh@marvell.com>
References: <20200325125246.987-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_05:2020-03-24,2020-03-25 signatures=0
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

