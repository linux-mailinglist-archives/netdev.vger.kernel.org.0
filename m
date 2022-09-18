Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9335BBD0A
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiIRJuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiIRJuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:19 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814E614033
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:57 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MVjc03lWLz14QWk;
        Sun, 18 Sep 2022 17:45:52 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:55 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 50/55] net: tap: adjust the prototype of update_features()
Date:   Sun, 18 Sep 2022 09:43:31 +0000
Message-ID: <20220918094336.28958-51-shenjian15@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220918094336.28958-1-shenjian15@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function tap_dev.update_features() using netdev_features_t
as parameters.

For the prototype of netdev_features_t will be extended to be
larger than 8 bytes, so change the prototype of the function,
change the prototype of input features to 'netdev_features_t *'.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ipvlan/ipvtap.c | 4 ++--
 drivers/net/macvtap.c       | 4 ++--
 drivers/net/tap.c           | 2 +-
 include/linux/if_tap.h      | 3 ++-
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ipvlan/ipvtap.c b/drivers/net/ipvlan/ipvtap.c
index ba2730ba5c1f..37988c869f6e 100644
--- a/drivers/net/ipvlan/ipvtap.c
+++ b/drivers/net/ipvlan/ipvtap.c
@@ -63,12 +63,12 @@ static void ipvtap_count_rx_dropped(struct tap_dev *tap)
 }
 
 static void ipvtap_update_features(struct tap_dev *tap,
-				   netdev_features_t features)
+				   const netdev_features_t *features)
 {
 	struct ipvtap_dev *vlantap = container_of(tap, struct ipvtap_dev, tap);
 	struct ipvl_dev *vlan = &vlantap->vlan;
 
-	vlan->sfeatures = features;
+	netdev_features_copy(vlan->sfeatures, *features);
 	netdev_update_features(vlan->dev);
 }
 
diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 14f75986f4c4..1a6cbb987ad2 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -67,12 +67,12 @@ static void macvtap_count_rx_dropped(struct tap_dev *tap)
 }
 
 static void macvtap_update_features(struct tap_dev *tap,
-				    netdev_features_t features)
+				    const netdev_features_t *features)
 {
 	struct macvtap_dev *vlantap = container_of(tap, struct macvtap_dev, tap);
 	struct macvlan_dev *vlan = &vlantap->vlan;
 
-	vlan->set_features = features;
+	netdev_features_copy(vlan->set_features, *features);
 	netdev_update_features(vlan->dev);
 }
 
diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index e3045a7badd8..a13c0479079f 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -985,7 +985,7 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
 	 */
 	tap->tap_features = feature_mask;
 	if (tap->update_features)
-		tap->update_features(tap, features);
+		tap->update_features(tap, &features);
 
 	return 0;
 }
diff --git a/include/linux/if_tap.h b/include/linux/if_tap.h
index 553552fa635c..7f5678f9df09 100644
--- a/include/linux/if_tap.h
+++ b/include/linux/if_tap.h
@@ -44,7 +44,8 @@ struct tap_dev {
 	netdev_features_t	tap_features;
 	int			minor;
 
-	void (*update_features)(struct tap_dev *tap, netdev_features_t features);
+	void (*update_features)(struct tap_dev *tap,
+				const netdev_features_t *features);
 	void (*count_tx_dropped)(struct tap_dev *tap);
 	void (*count_rx_dropped)(struct tap_dev *tap);
 };
-- 
2.33.0

