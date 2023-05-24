Return-Path: <netdev+bounces-4864-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A106B70ED72
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 07:57:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D82962811C9
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 05:57:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF6881C06;
	Wed, 24 May 2023 05:57:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF655185D
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:57:28 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2622518E;
	Tue, 23 May 2023 22:57:27 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1134)
	id 2D51020FB9F2; Tue, 23 May 2023 22:57:26 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2D51020FB9F2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1684907846;
	bh=t5dzhOilp7QpFsI2q/pIEVeDMxfw0/HEc1rMQtlFgqk=;
	h=From:To:Cc:Subject:Date:From;
	b=MYTppQc3MP2tIIarrRFPMqgstCxp/wch2FlbAWuwnIfTNrG+L7HqZZS48JWKV7pVr
	 5IUxNkGn94JIQevJFCrjxfUGEO00YhFIlnPBWpNWtxiRr1JklsbNpkZKdX7TilMspQ
	 JwMPO9ChXPz/GKkjwaiYIh73SsnHCKFOzXFvKjrE=
From: Shradha Gupta <shradhagupta@linux.microsoft.com>
To: linux-kernel@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mikelley@microsoft.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH] hv_netvsc: Allocate rx indirection table size dynamically
Date: Tue, 23 May 2023 22:57:24 -0700
Message-Id: <1684907844-23224-1-git-send-email-shradhagupta@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

Allocate the size of rx indirection table dynamically in netvsc
from the value of size provided by OID_GEN_RECEIVE_SCALE_CAPABILITIES
query instead of using a constant value of ITAB_NUM.

Signed-off-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
---
 drivers/net/hyperv/hyperv_net.h   |  5 ++++-
 drivers/net/hyperv/netvsc_drv.c   | 11 +++++++----
 drivers/net/hyperv/rndis_filter.c | 23 +++++++++++++++++++----
 3 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index dd5919ec408b..1dbdb65ca8f0 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -74,6 +74,7 @@ struct ndis_recv_scale_cap { /* NDIS_RECEIVE_SCALE_CAPABILITIES */
 #define NDIS_RSS_HASH_SECRET_KEY_MAX_SIZE_REVISION_2   40
 
 #define ITAB_NUM 128
+#define ITAB_NUM_MAX 256
 
 struct ndis_recv_scale_param { /* NDIS_RECEIVE_SCALE_PARAMETERS */
 	struct ndis_obj_header hdr;
@@ -1034,7 +1035,9 @@ struct net_device_context {
 
 	u32 tx_table[VRSS_SEND_TAB_SIZE];
 
-	u16 rx_table[ITAB_NUM];
+	u16 *rx_table;
+
+	int rx_table_sz;
 
 	/* Ethtool settings */
 	u8 duplex;
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 0103ff914024..5b8a7d5f9a15 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1747,7 +1747,9 @@ static u32 netvsc_get_rxfh_key_size(struct net_device *dev)
 
 static u32 netvsc_rss_indir_size(struct net_device *dev)
 {
-	return ITAB_NUM;
+	struct net_device_context *ndc = netdev_priv(dev);
+
+	return ndc->rx_table_sz;
 }
 
 static int netvsc_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
@@ -1766,7 +1768,7 @@ static int netvsc_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
 
 	rndis_dev = ndev->extension;
 	if (indir) {
-		for (i = 0; i < ITAB_NUM; i++)
+		for (i = 0; i < ndc->rx_table_sz; i++)
 			indir[i] = ndc->rx_table[i];
 	}
 
@@ -1792,11 +1794,11 @@ static int netvsc_set_rxfh(struct net_device *dev, const u32 *indir,
 
 	rndis_dev = ndev->extension;
 	if (indir) {
-		for (i = 0; i < ITAB_NUM; i++)
+		for (i = 0; i < ndc->rx_table_sz; i++)
 			if (indir[i] >= ndev->num_chn)
 				return -EINVAL;
 
-		for (i = 0; i < ITAB_NUM; i++)
+		for (i = 0; i < ndc->rx_table_sz; i++)
 			ndc->rx_table[i] = indir[i];
 	}
 
@@ -2638,6 +2640,7 @@ static void netvsc_remove(struct hv_device *dev)
 
 	hv_set_drvdata(dev, NULL);
 
+	kfree(ndev_ctx->rx_table);
 	free_percpu(ndev_ctx->vf_stats);
 	free_netdev(net);
 }
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index eea777ec2541..af031e711cb2 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -927,7 +927,7 @@ static int rndis_set_rss_param_msg(struct rndis_device *rdev,
 	struct rndis_set_request *set;
 	struct rndis_set_complete *set_complete;
 	u32 extlen = sizeof(struct ndis_recv_scale_param) +
-		     4 * ITAB_NUM + NETVSC_HASH_KEYLEN;
+		     4 * ndc->rx_table_sz + NETVSC_HASH_KEYLEN;
 	struct ndis_recv_scale_param *rssp;
 	u32 *itab;
 	u8 *keyp;
@@ -953,7 +953,7 @@ static int rndis_set_rss_param_msg(struct rndis_device *rdev,
 	rssp->hashinfo = NDIS_HASH_FUNC_TOEPLITZ | NDIS_HASH_IPV4 |
 			 NDIS_HASH_TCP_IPV4 | NDIS_HASH_IPV6 |
 			 NDIS_HASH_TCP_IPV6;
-	rssp->indirect_tabsize = 4*ITAB_NUM;
+	rssp->indirect_tabsize = 4 * ndc->rx_table_sz;
 	rssp->indirect_taboffset = sizeof(struct ndis_recv_scale_param);
 	rssp->hashkey_size = NETVSC_HASH_KEYLEN;
 	rssp->hashkey_offset = rssp->indirect_taboffset +
@@ -961,7 +961,7 @@ static int rndis_set_rss_param_msg(struct rndis_device *rdev,
 
 	/* Set indirection table entries */
 	itab = (u32 *)(rssp + 1);
-	for (i = 0; i < ITAB_NUM; i++)
+	for (i = 0; i < ndc->rx_table_sz; i++)
 		itab[i] = ndc->rx_table[i];
 
 	/* Set hask key values */
@@ -1548,6 +1548,21 @@ struct netvsc_device *rndis_filter_device_add(struct hv_device *dev,
 	if (ret || rsscap.num_recv_que < 2)
 		goto out;
 
+	if (rsscap.num_indirect_tabent &&
+		rsscap.num_indirect_tabent <= ITAB_NUM_MAX) {
+		ndc->rx_table_sz = rsscap.num_indirect_tabent;
+	} else {
+		ndc->rx_table_sz = ITAB_NUM;
+	}
+
+	ndc->rx_table = kzalloc(sizeof(u16) * ndc->rx_table_sz,
+				GFP_KERNEL);
+	if (ndc->rx_table) {
+		netdev_err(net, "Error in allocating rx indirection table of size %d\n",
+				ndc->rx_table_sz);
+		goto out;
+	}
+
 	/* This guarantees that num_possible_rss_qs <= num_online_cpus */
 	num_possible_rss_qs = min_t(u32, num_online_cpus(),
 				    rsscap.num_recv_que);
@@ -1558,7 +1573,7 @@ struct netvsc_device *rndis_filter_device_add(struct hv_device *dev,
 	net_device->num_chn = min(net_device->max_chn, device_info->num_chn);
 
 	if (!netif_is_rxfh_configured(net)) {
-		for (i = 0; i < ITAB_NUM; i++)
+		for (i = 0; i < ndc->rx_table_sz; i++)
 			ndc->rx_table[i] = ethtool_rxfh_indir_default(
 						i, net_device->num_chn);
 	}
-- 
2.34.1


