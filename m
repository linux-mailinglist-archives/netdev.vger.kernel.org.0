Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8C23B886F
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 20:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233209AbhF3SbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 14:31:07 -0400
Received: from mga06.intel.com ([134.134.136.31]:29374 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233084AbhF3SbG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 14:31:06 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10031"; a="269539539"
X-IronPort-AV: E=Sophos;i="5.83,312,1616482800"; 
   d="scan'208";a="269539539"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2021 11:28:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,312,1616482800"; 
   d="scan'208";a="626106904"
Received: from ccgwwan-adlp1.iind.intel.com ([10.224.174.35])
  by orsmga005.jf.intel.com with ESMTP; 30 Jun 2021 11:28:34 -0700
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        krishna.c.sudi@intel.com, linuxwwan@intel.com
Subject: [PATCH 4/5] net: wwan: iosm: fix netdev tx stats
Date:   Wed, 30 Jun 2021 23:57:49 +0530
Message-Id: <20210630182748.3481-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update tx stats on successful packet consume, drop.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_wwan.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
index 84e37c4b0f74..561944a33725 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -123,6 +123,8 @@ static int ipc_wwan_link_transmit(struct sk_buff *skb,
 
 	/* Return code of zero is success */
 	if (ret == 0) {
+		netdev->stats.tx_packets++;
+		netdev->stats.tx_bytes += skb->len;
 		ret = NETDEV_TX_OK;
 	} else if (ret == -EBUSY) {
 		ret = NETDEV_TX_BUSY;
@@ -140,7 +142,8 @@ static int ipc_wwan_link_transmit(struct sk_buff *skb,
 			ret);
 
 	dev_kfree_skb_any(skb);
-	return ret;
+	netdev->stats.tx_dropped++;
+	return NETDEV_TX_OK;
 }
 
 /* Ops structure for wwan net link */
-- 
2.25.1

