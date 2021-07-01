Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031223B93B7
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 17:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbhGAPM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 11:12:29 -0400
Received: from mga07.intel.com ([134.134.136.100]:60329 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232625AbhGAPM3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 11:12:29 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10032"; a="272404998"
X-IronPort-AV: E=Sophos;i="5.83,314,1616482800"; 
   d="scan'208";a="272404998"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 08:09:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,314,1616482800"; 
   d="scan'208";a="626400963"
Received: from ccgwwan-adlp1.iind.intel.com ([10.224.174.35])
  by orsmga005.jf.intel.com with ESMTP; 01 Jul 2021 08:09:53 -0700
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        krishna.c.sudi@intel.com, linuxwwan@intel.com,
        eric.dumazet@gmail.com
Subject: [PATCH V2 4/5] net: wwan: iosm: fix netdev tx stats
Date:   Thu,  1 Jul 2021 20:39:17 +0530
Message-Id: <20210701150917.1005271-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update tx stats on successful packet consume, drop.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
v2: Backup skb->len to local var & use same for updating tx_bytes.
---
 drivers/net/wwan/iosm/iosm_ipc_wwan.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
index 84e37c4b0f74..e0c19c59c5f6 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -107,6 +107,7 @@ static int ipc_wwan_link_transmit(struct sk_buff *skb,
 {
 	struct iosm_netdev_priv *priv = wwan_netdev_drvpriv(netdev);
 	struct iosm_wwan *ipc_wwan = priv->ipc_wwan;
+	unsigned int len = skb->len;
 	int if_id = priv->if_id;
 	int ret;
 
@@ -123,6 +124,8 @@ static int ipc_wwan_link_transmit(struct sk_buff *skb,
 
 	/* Return code of zero is success */
 	if (ret == 0) {
+		netdev->stats.tx_packets++;
+		netdev->stats.tx_bytes += len;
 		ret = NETDEV_TX_OK;
 	} else if (ret == -EBUSY) {
 		ret = NETDEV_TX_BUSY;
@@ -140,7 +143,8 @@ static int ipc_wwan_link_transmit(struct sk_buff *skb,
 			ret);
 
 	dev_kfree_skb_any(skb);
-	return ret;
+	netdev->stats.tx_dropped++;
+	return NETDEV_TX_OK;
 }
 
 /* Ops structure for wwan net link */
-- 
2.25.1

