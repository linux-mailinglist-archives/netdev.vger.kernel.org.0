Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5A9347941
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 14:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbhCXNHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 09:07:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234381AbhCXNHg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 09:07:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E67B619F2;
        Wed, 24 Mar 2021 13:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616591255;
        bh=ipRkHJfSO7gbOj1+Zj4KAE72qEZRW4QoMykE1Mghsjk=;
        h=From:To:Cc:Subject:Date:From;
        b=aIu1IF6BxPI3ZLsSx8wcxgzU/yjCf/1AM9NW1GiG1k4hxH0JsER0b80LwZbhgdjrf
         VZNMLqrf0M1n5pvx1NGxvr12ah9aXrKw4ELo0PtcCdeRK5ix2NjzOWkofkutFq2WIj
         IVkeLd6x38+ijiCHKXw6hJZ+sBdFO+mGKoIzG4hHFb4scFpXWvgOIv4xHAxrydTFpl
         QyilaMTk58IWbvEpUL9aybINMxVNztsmbVAs50Zk3MMwQRhUS3weNGGMbSjxhx18Wi
         8h5Evy4SravyouqCKe2py+5vF1azderK9mUu/gLYgakX/Uwo+ijSnsfh6RsYU0oDjd
         CVAKOrqJNDhkw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Bin Luo <luobin9@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] hinic: avoid gcc -Wrestrict warning
Date:   Wed, 24 Mar 2021 14:07:22 +0100
Message-Id: <20210324130731.1513798-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

With extra warnings enabled, gcc complains that snprintf should not
take the same buffer as source and destination:

drivers/net/ethernet/huawei/hinic/hinic_ethtool.c: In function 'hinic_set_settings_to_hw':
drivers/net/ethernet/huawei/hinic/hinic_ethtool.c:480:9: error: 'snprintf' argument 4 overlaps destination object 'set_link_str' [-Werror=restrict]
  480 |   err = snprintf(set_link_str, SET_LINK_STR_MAX_LEN,
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  481 |           "%sspeed %d ", set_link_str, speed);
      |           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/huawei/hinic/hinic_ethtool.c:464:7: note: destination object referenced by 'restrict'-qualified argument 1 was declared here
  464 |  char set_link_str[SET_LINK_STR_MAX_LEN] = {0};

Rewrite this to avoid the nested sprintf and instead use separate
buffers, which is simpler.

Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: rework according to feedback from Rasmus. This one could
    easily avoid most of the pitfalls
---
 .../net/ethernet/huawei/hinic/hinic_ethtool.c | 25 ++++++++-----------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index c340d9acba80..d7e20dab6e48 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -34,7 +34,7 @@
 #include "hinic_rx.h"
 #include "hinic_dev.h"
 
-#define SET_LINK_STR_MAX_LEN	128
+#define SET_LINK_STR_MAX_LEN	16
 
 #define GET_SUPPORTED_MODE	0
 #define GET_ADVERTISED_MODE	1
@@ -462,24 +462,19 @@ static int hinic_set_settings_to_hw(struct hinic_dev *nic_dev,
 {
 	struct hinic_link_ksettings_info settings = {0};
 	char set_link_str[SET_LINK_STR_MAX_LEN] = {0};
+	const char *autoneg_str;
 	struct net_device *netdev = nic_dev->netdev;
 	enum nic_speed_level speed_level = 0;
 	int err;
 
-	err = snprintf(set_link_str, SET_LINK_STR_MAX_LEN, "%s",
-		       (set_settings & HILINK_LINK_SET_AUTONEG) ?
-		       (autoneg ? "autong enable " : "autong disable ") : "");
-	if (err < 0 || err >= SET_LINK_STR_MAX_LEN) {
-		netif_err(nic_dev, drv, netdev, "Failed to snprintf link state, function return(%d) and dest_len(%d)\n",
-			  err, SET_LINK_STR_MAX_LEN);
-		return -EFAULT;
-	}
+	autoneg_str = (set_settings & HILINK_LINK_SET_AUTONEG) ?
+		      (autoneg ? "autong enable " : "autong disable ") : "";
 
 	if (set_settings & HILINK_LINK_SET_SPEED) {
 		speed_level = hinic_ethtool_to_hw_speed_level(speed);
 		err = snprintf(set_link_str, SET_LINK_STR_MAX_LEN,
-			       "%sspeed %d ", set_link_str, speed);
-		if (err <= 0 || err >= SET_LINK_STR_MAX_LEN) {
+			       "speed %d ", speed);
+		if (err >= SET_LINK_STR_MAX_LEN) {
 			netif_err(nic_dev, drv, netdev, "Failed to snprintf link speed, function return(%d) and dest_len(%d)\n",
 				  err, SET_LINK_STR_MAX_LEN);
 			return -EFAULT;
@@ -494,11 +489,11 @@ static int hinic_set_settings_to_hw(struct hinic_dev *nic_dev,
 	err = hinic_set_link_settings(nic_dev->hwdev, &settings);
 	if (err != HINIC_MGMT_CMD_UNSUPPORTED) {
 		if (err)
-			netif_err(nic_dev, drv, netdev, "Set %s failed\n",
-				  set_link_str);
+			netif_err(nic_dev, drv, netdev, "Set %s%sfailed\n",
+				  autoneg_str, set_link_str);
 		else
-			netif_info(nic_dev, drv, netdev, "Set %s successfully\n",
-				   set_link_str);
+			netif_info(nic_dev, drv, netdev, "Set %s%ssuccessfully\n",
+				   autoneg_str, set_link_str);
 
 		return err;
 	}
-- 
2.29.2

