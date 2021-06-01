Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2704396E80
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 10:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbhFAIHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 04:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233056AbhFAIH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 04:07:27 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5ECC06174A;
        Tue,  1 Jun 2021 01:05:45 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lnzPD-000V6C-GZ; Tue, 01 Jun 2021 10:05:43 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     m.chetan.kumar@intel.com, loic.poulain@linaro.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 1/4] iosm: fix stats and RCU bugs in RX
Date:   Tue,  1 Jun 2021 10:05:35 +0200
Message-Id: <20210601100320.48d067d87f3e.I53608f5de5828db7066d29e5774bcf8a19e0f642@changeid>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210601080538.71036-1-johannes@sipsolutions.net>
References: <20210601080538.71036-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_wwan.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
index 02c35bc86674..719c88d9b2e9 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -312,7 +312,8 @@ int ipc_wwan_receive(struct iosm_wwan *ipc_wwan, struct sk_buff *skb_arg,
 		     bool dss, int if_id)
 {
 	struct sk_buff *skb = skb_arg;
-	struct net_device_stats stats;
+	struct net_device_stats *stats;
+	struct iosm_net_link *priv;
 	int ret;
 
 	if ((skb->data[0] & IOSM_IP_TYPE_MASK) == IOSM_IP_TYPE_IPV4)
@@ -325,19 +326,27 @@ int ipc_wwan_receive(struct iosm_wwan *ipc_wwan, struct sk_buff *skb_arg,
 
 	if (if_id < (IP_MUX_SESSION_START - 1) ||
 	    if_id > (IP_MUX_SESSION_END - 1)) {
-		dev_kfree_skb(skb);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto free;
 	}
 
 	rcu_read_lock();
-	skb->dev = rcu_dereference(ipc_wwan->sub_netlist[if_id])->netdev;
-	stats = rcu_dereference(ipc_wwan->sub_netlist[if_id])->netdev->stats;
-	stats.rx_packets++;
-	stats.rx_bytes += skb->len;
+	priv = rcu_dereference(ipc_wwan->sub_netlist[if_id]);
+	if (!priv) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+	skb->dev = priv->netdev;
+	stats = &priv->netdev->stats;
+	stats->rx_packets++;
+	stats->rx_bytes += skb->len;
 
 	ret = netif_rx(skb);
+	skb = NULL;
+unlock:
 	rcu_read_unlock();
-
+free:
+	dev_kfree_skb(skb);
 	return ret;
 }
 
-- 
2.31.1

