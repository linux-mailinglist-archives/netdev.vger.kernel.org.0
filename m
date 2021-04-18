Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5353637C2
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 23:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232806AbhDRVMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 17:12:25 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35232 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhDRVMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 17:12:25 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id B2F1F63E89;
        Sun, 18 Apr 2021 23:11:25 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, john@phrozen.org,
        nbd@nbd.name, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        dqfext@gmail.com, frank-w@public-files.de
Subject: [PATCH net-next 2/3] net: ethernet: mtk_eth_soc: missing mutex
Date:   Sun, 18 Apr 2021 23:11:44 +0200
Message-Id: <20210418211145.21914-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210418211145.21914-1-pablo@netfilter.org>
References: <20210418211145.21914-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 2ed37183abb7 ("netfilter: flowtable: separate replace, destroy and
stats to different workqueues") splits the workqueue per event type. Add
a mutex to serialize updates.

Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading support")
Reported-by: Frank Wunderlich <frank-w@public-files.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../net/ethernet/mediatek/mtk_ppe_offload.c   | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 4975106fbc42..2759c875c791 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -391,6 +391,8 @@ mtk_flow_offload_stats(struct mtk_eth *eth, struct flow_cls_offload *f)
 	return 0;
 }
 
+static DEFINE_MUTEX(mtk_flow_offload_mutex);
+
 static int
 mtk_eth_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
 {
@@ -398,6 +400,7 @@ mtk_eth_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_pri
 	struct net_device *dev = cb_priv;
 	struct mtk_mac *mac = netdev_priv(dev);
 	struct mtk_eth *eth = mac->hw;
+	int err;
 
 	if (!tc_can_offload(dev))
 		return -EOPNOTSUPP;
@@ -405,18 +408,24 @@ mtk_eth_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_pri
 	if (type != TC_SETUP_CLSFLOWER)
 		return -EOPNOTSUPP;
 
+	mutex_lock(&mtk_flow_offload_mutex);
 	switch (cls->command) {
 	case FLOW_CLS_REPLACE:
-		return mtk_flow_offload_replace(eth, cls);
+		err = mtk_flow_offload_replace(eth, cls);
+		break;
 	case FLOW_CLS_DESTROY:
-		return mtk_flow_offload_destroy(eth, cls);
+		err = mtk_flow_offload_destroy(eth, cls);
+		break;
 	case FLOW_CLS_STATS:
-		return mtk_flow_offload_stats(eth, cls);
+		err = mtk_flow_offload_stats(eth, cls);
+		break;
 	default:
-		return -EOPNOTSUPP;
+		err = -EOPNOTSUPP;
+		break;
 	}
+	mutex_unlock(&mtk_flow_offload_mutex);
 
-	return 0;
+	return err;
 }
 
 static int
-- 
2.20.1

