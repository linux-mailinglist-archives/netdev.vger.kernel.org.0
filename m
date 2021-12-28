Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D43480961
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 14:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbhL1NHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 08:07:09 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:39755 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231980AbhL1NHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 08:07:07 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V06qTd1_1640696823;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V06qTd1_1640696823)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 28 Dec 2021 21:07:04 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH 1/4] net/smc: Introduce net namespace support for linkgroup
Date:   Tue, 28 Dec 2021 21:06:09 +0800
Message-Id: <20211228130611.19124-2-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211228130611.19124-1-tonylu@linux.alibaba.com>
References: <20211228130611.19124-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, rdma device supports exclusive net namespace isolation,
however linkgroup doesn't know and support ibdev net namespace.
Applications in the containers don't want to share the nics if we
enabled rdma exclusive mode. Every net namespaces should have their own
linkgroups.

This patch introduce a new field net for linkgroup, which is standing
for the ibdev net namespace in the linkgroup. The net in linkgroup is
initialized with the net namespace of link's ibdev. It compares the net
of linkgroup and sock or ibdev before choose it, if no matched, create
new one in current net namespace. If rdma net namespace exclusive mode
is not enabled, it behaves as before.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 net/smc/smc_core.c | 24 +++++++++++++++++-------
 net/smc/smc_core.h |  2 ++
 net/smc/smc_ib.h   |  7 +++++++
 net/smc/smc_pnet.c | 21 ++++++++++++++++-----
 4 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 85be94cabb01..05c11bbe4318 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -897,6 +897,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 			smc_wr_free_lgr_mem(lgr);
 			goto free_wq;
 		}
+		lgr->net = smc_ib_net(lnk->smcibdev);
 		lgr_list = &smc_lgr_list.list;
 		lgr_lock = &smc_lgr_list.lock;
 		atomic_inc(&lgr_cnt);
@@ -1570,7 +1571,8 @@ void smcr_port_add(struct smc_ib_device *smcibdev, u8 ibport)
 		if (strncmp(smcibdev->pnetid[ibport - 1], lgr->pnet_id,
 			    SMC_MAX_PNETID_LEN) ||
 		    lgr->type == SMC_LGR_SYMMETRIC ||
-		    lgr->type == SMC_LGR_ASYMMETRIC_PEER)
+		    lgr->type == SMC_LGR_ASYMMETRIC_PEER ||
+		    !rdma_dev_access_netns(smcibdev->ibdev, lgr->net))
 			continue;
 
 		/* trigger local add link processing */
@@ -1729,8 +1731,10 @@ static bool smcr_lgr_match(struct smc_link_group *lgr, u8 smcr_version,
 			   u8 peer_systemid[],
 			   u8 peer_gid[],
 			   u8 peer_mac_v1[],
-			   enum smc_lgr_role role, u32 clcqpn)
+			   enum smc_lgr_role role, u32 clcqpn,
+			   struct net *net)
 {
+	struct smc_link *lnk;
 	int i;
 
 	if (memcmp(lgr->peer_systemid, peer_systemid, SMC_SYSTEMID_LEN) ||
@@ -1738,12 +1742,17 @@ static bool smcr_lgr_match(struct smc_link_group *lgr, u8 smcr_version,
 		return false;
 
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
-		if (!smc_link_active(&lgr->lnk[i]))
+		lnk = &lgr->lnk[i];
+
+		if (!smc_link_active(lnk))
 			continue;
-		if ((lgr->role == SMC_SERV || lgr->lnk[i].peer_qpn == clcqpn) &&
-		    !memcmp(lgr->lnk[i].peer_gid, peer_gid, SMC_GID_SIZE) &&
+		/* use verbs API to check netns, instead of lgr->net */
+		if (!rdma_dev_access_netns(lnk->smcibdev->ibdev, net))
+			return false;
+		if ((lgr->role == SMC_SERV || lnk->peer_qpn == clcqpn) &&
+		    !memcmp(lnk->peer_gid, peer_gid, SMC_GID_SIZE) &&
 		    (smcr_version == SMC_V2 ||
-		     !memcmp(lgr->lnk[i].peer_mac, peer_mac_v1, ETH_ALEN)))
+		     !memcmp(lnk->peer_mac, peer_mac_v1, ETH_ALEN)))
 			return true;
 	}
 	return false;
@@ -1759,6 +1768,7 @@ static bool smcd_lgr_match(struct smc_link_group *lgr,
 int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 {
 	struct smc_connection *conn = &smc->conn;
+	struct net *net = sock_net(&smc->sk);
 	struct list_head *lgr_list;
 	struct smc_link_group *lgr;
 	enum smc_lgr_role role;
@@ -1785,7 +1795,7 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 		     smcr_lgr_match(lgr, ini->smcr_version,
 				    ini->peer_systemid,
 				    ini->peer_gid, ini->peer_mac, role,
-				    ini->ib_clcqpn)) &&
+				    ini->ib_clcqpn, net)) &&
 		    !lgr->sync_err &&
 		    (ini->smcd_version == SMC_V2 ||
 		     lgr->vlan_id == ini->vlan_id) &&
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 59cef3b830d8..69e11ce22725 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -306,6 +306,8 @@ struct smc_link_group {
 			u8			nexthop_mac[ETH_ALEN];
 			u8			uses_gateway;
 			__be32			saddr;
+						/* net namespace */
+			struct net		*net;
 		};
 		struct { /* SMC-D */
 			u64			peer_gid;
diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
index 07585937370e..91a396120dee 100644
--- a/net/smc/smc_ib.h
+++ b/net/smc/smc_ib.h
@@ -69,6 +69,13 @@ static inline __be32 smc_ib_gid_to_ipv4(u8 gid[SMC_GID_SIZE])
 	return cpu_to_be32(INADDR_NONE);
 }
 
+static inline struct net *smc_ib_net(struct smc_ib_device *smcibdev)
+{
+	if (smcibdev && smcibdev->ibdev)
+		return read_pnet(&smcibdev->ibdev->coredev.rdma_net);
+	return NULL;
+}
+
 struct smc_init_info_smcrv2;
 struct smc_buf_desc;
 struct smc_link;
diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index e171cc6483f8..db9825c01e0a 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -977,14 +977,16 @@ static int smc_pnet_determine_gid(struct smc_ib_device *ibdev, int i,
 /* find a roce device for the given pnetid */
 static void _smc_pnet_find_roce_by_pnetid(u8 *pnet_id,
 					  struct smc_init_info *ini,
-					  struct smc_ib_device *known_dev)
+					  struct smc_ib_device *known_dev,
+					  struct net *net)
 {
 	struct smc_ib_device *ibdev;
 	int i;
 
 	mutex_lock(&smc_ib_devices.mutex);
 	list_for_each_entry(ibdev, &smc_ib_devices.list, list) {
-		if (ibdev == known_dev)
+		if (ibdev == known_dev ||
+		    !rdma_dev_access_netns(ibdev->ibdev, net))
 			continue;
 		for (i = 1; i <= SMC_MAX_PORTS; i++) {
 			if (!rdma_is_port_valid(ibdev->ibdev, i))
@@ -1001,12 +1003,14 @@ static void _smc_pnet_find_roce_by_pnetid(u8 *pnet_id,
 	mutex_unlock(&smc_ib_devices.mutex);
 }
 
-/* find alternate roce device with same pnet_id and vlan_id */
+/* find alternate roce device with same pnet_id, vlan_id and net namespace */
 void smc_pnet_find_alt_roce(struct smc_link_group *lgr,
 			    struct smc_init_info *ini,
 			    struct smc_ib_device *known_dev)
 {
-	_smc_pnet_find_roce_by_pnetid(lgr->pnet_id, ini, known_dev);
+	struct net *net = lgr->net;
+
+	_smc_pnet_find_roce_by_pnetid(lgr->pnet_id, ini, known_dev, net);
 }
 
 /* if handshake network device belongs to a roce device, return its
@@ -1015,6 +1019,7 @@ void smc_pnet_find_alt_roce(struct smc_link_group *lgr,
 static void smc_pnet_find_rdma_dev(struct net_device *netdev,
 				   struct smc_init_info *ini)
 {
+	struct net *net = dev_net(netdev);
 	struct smc_ib_device *ibdev;
 
 	mutex_lock(&smc_ib_devices.mutex);
@@ -1022,6 +1027,10 @@ static void smc_pnet_find_rdma_dev(struct net_device *netdev,
 		struct net_device *ndev;
 		int i;
 
+		/* check rdma net namespace */
+		if (!rdma_dev_access_netns(ibdev->ibdev, net))
+			continue;
+
 		for (i = 1; i <= SMC_MAX_PORTS; i++) {
 			if (!rdma_is_port_valid(ibdev->ibdev, i))
 				continue;
@@ -1052,15 +1061,17 @@ static void smc_pnet_find_roce_by_pnetid(struct net_device *ndev,
 					 struct smc_init_info *ini)
 {
 	u8 ndev_pnetid[SMC_MAX_PNETID_LEN];
+	struct net *net;
 
 	ndev = pnet_find_base_ndev(ndev);
+	net = dev_net(ndev);
 	if (smc_pnetid_by_dev_port(ndev->dev.parent, ndev->dev_port,
 				   ndev_pnetid) &&
 	    smc_pnet_find_ndev_pnetid_by_table(ndev, ndev_pnetid)) {
 		smc_pnet_find_rdma_dev(ndev, ini);
 		return; /* pnetid could not be determined */
 	}
-	_smc_pnet_find_roce_by_pnetid(ndev_pnetid, ini, NULL);
+	_smc_pnet_find_roce_by_pnetid(ndev_pnetid, ini, NULL, net);
 }
 
 static void smc_pnet_find_ism_by_pnetid(struct net_device *ndev,
-- 
2.32.0.3.g01195cf9f

