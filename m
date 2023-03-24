Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7E06C8397
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbjCXRrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbjCXRr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:47:27 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7122C1A494;
        Fri, 24 Mar 2023 10:47:25 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OH2e8s001024;
        Fri, 24 Mar 2023 10:47:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=fKQ9AlezHJ939j0y5+PygqD2CxDQraZBT2F9Dur/6bM=;
 b=f/0IWH1JHExTCueok2zEujwMX1gGE/zp3kCuS/77+OmkpaG+IKslypQvzeEui0nKcae9
 9b2A2LIeHEpw9Ox0aFkr/K5FxhaHdl4J+BgklxpKxKtowHKN7x7CT0Fh28ETfYjEf7Qj
 bDukZ2GRPdUtEDLfjoHm/aQKE+S825wqO1Ia8mBVpjyfYtdh1SQjb5FVLuLXFrzq4b4M
 +rYcUHnhFmEVUTRi8Yyo76qBesaCclRBir5cpK0l8BqcQyoKZzcMax+TBzCe76r1d5C1
 2nLGPmJyT4ja6iocYl4sSDw6xosTzm3jXto5H3/D9XfHJaJXdyrdZRceQa/d66IVjhXo Ow== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3pgxmfkdpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 10:47:18 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 24 Mar
 2023 10:47:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Fri, 24 Mar 2023 10:47:16 -0700
Received: from sburla-PowerEdge-T630.sclab.marvell.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 13EF73F7040;
        Fri, 24 Mar 2023 10:47:16 -0700 (PDT)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <aayarekar@marvell.com>, <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v5 7/8] octeon_ep: function id in link info and stats mailbox commands
Date:   Fri, 24 Mar 2023 10:47:02 -0700
Message-ID: <20230324174704.9752-8-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20230324174704.9752-1-vburru@marvell.com>
References: <20230324174704.9752-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: o1x2LOlncRwpt_4wv76P0_YOXyeceGpj
X-Proofpoint-ORIG-GUID: o1x2LOlncRwpt_4wv76P0_YOXyeceGpj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update control mailbox API to include function id in get stats and
link info.

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
---
v4 -> v5:
 * no change

v3 -> v4:
 * 0006-xxx.patch in v3 is 0007-xxx.patch in v4.

v2 -> v3:
 * no change

v1 -> v2:
 * no change

 .../marvell/octeon_ep/octep_ctrl_net.c        | 33 +++++++++----------
 .../marvell/octeon_ep/octep_ctrl_net.h        | 24 +++++++++-----
 .../marvell/octeon_ep/octep_ethtool.c         |  9 +++--
 .../ethernet/marvell/octeon_ep/octep_main.c   |  5 ++-
 4 files changed, 40 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
index 465eef2824e3..1cc6af2feb38 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
@@ -19,7 +19,6 @@ static const u32 mtu_sz = sizeof(struct octep_ctrl_net_h2f_req_cmd_mtu);
 static const u32 mac_sz = sizeof(struct octep_ctrl_net_h2f_req_cmd_mac);
 static const u32 state_sz = sizeof(struct octep_ctrl_net_h2f_req_cmd_state);
 static const u32 link_info_sz = sizeof(struct octep_ctrl_net_link_info);
-static const u32 get_stats_sz = sizeof(struct octep_ctrl_net_h2f_req_cmd_get_stats);
 static atomic_t ctrl_net_msg_id;
 
 static void init_send_req(struct octep_ctrl_mbox_msg *msg, void *buf,
@@ -188,31 +187,29 @@ int octep_ctrl_net_set_mtu(struct octep_device *oct, int vfid, int mtu,
 	return octep_send_mbox_req(oct, &d, wait_for_response);
 }
 
-int octep_ctrl_net_get_if_stats(struct octep_device *oct, int vfid)
+int octep_ctrl_net_get_if_stats(struct octep_device *oct, int vfid,
+				struct octep_iface_rx_stats *rx_stats,
+				struct octep_iface_tx_stats *tx_stats)
 {
 	struct octep_ctrl_net_wait_data d = {0};
 	struct octep_ctrl_net_h2f_req *req = &d.data.req;
-	void __iomem *iface_rx_stats;
-	void __iomem *iface_tx_stats;
+	struct octep_ctrl_net_h2f_resp *resp;
 	int err;
 
-	init_send_req(&d.msg, req, get_stats_sz, vfid);
+	init_send_req(&d.msg, req, 0, vfid);
 	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_GET_IF_STATS;
-	req->get_stats.offset = oct->ctrl_mbox_ifstats_offset;
 	err = octep_send_mbox_req(oct, &d, true);
 	if (err < 0)
 		return err;
 
-	iface_rx_stats = oct->ctrl_mbox.barmem + oct->ctrl_mbox_ifstats_offset;
-	iface_tx_stats = oct->ctrl_mbox.barmem + oct->ctrl_mbox_ifstats_offset +
-			 sizeof(struct octep_iface_rx_stats);
-	memcpy_fromio(&oct->iface_rx_stats, iface_rx_stats, sizeof(struct octep_iface_rx_stats));
-	memcpy_fromio(&oct->iface_tx_stats, iface_tx_stats, sizeof(struct octep_iface_tx_stats));
-
+	resp = &d.data.resp;
+	memcpy(rx_stats, &resp->if_stats.rx_stats, sizeof(struct octep_iface_rx_stats));
+	memcpy(tx_stats, &resp->if_stats.tx_stats, sizeof(struct octep_iface_tx_stats));
 	return 0;
 }
 
-int octep_ctrl_net_get_link_info(struct octep_device *oct, int vfid)
+int octep_ctrl_net_get_link_info(struct octep_device *oct, int vfid,
+				 struct octep_iface_link_info *link_info)
 {
 	struct octep_ctrl_net_wait_data d = {0};
 	struct octep_ctrl_net_h2f_req *req = &d.data.req;
@@ -227,11 +224,11 @@ int octep_ctrl_net_get_link_info(struct octep_device *oct, int vfid)
 		return err;
 
 	resp = &d.data.resp;
-	oct->link_info.supported_modes = resp->link_info.supported_modes;
-	oct->link_info.advertised_modes = resp->link_info.advertised_modes;
-	oct->link_info.autoneg = resp->link_info.autoneg;
-	oct->link_info.pause = resp->link_info.pause;
-	oct->link_info.speed = resp->link_info.speed;
+	link_info->supported_modes = resp->link_info.supported_modes;
+	link_info->advertised_modes = resp->link_info.advertised_modes;
+	link_info->autoneg = resp->link_info.autoneg;
+	link_info->pause = resp->link_info.pause;
+	link_info->speed = resp->link_info.speed;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.h b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.h
index de0759365f13..37880dd79116 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.h
@@ -77,12 +77,6 @@ struct octep_ctrl_net_h2f_req_cmd_mac {
 	u8 addr[ETH_ALEN];
 };
 
-/* get if_stats, xstats, q_stats request */
-struct octep_ctrl_net_h2f_req_cmd_get_stats {
-	/* offset into barmem where fw should copy over stats */
-	u32 offset;
-};
-
 /* get/set link state, rx state */
 struct octep_ctrl_net_h2f_req_cmd_state {
 	/* enum octep_ctrl_net_cmd */
@@ -119,7 +113,6 @@ struct octep_ctrl_net_h2f_req {
 	union {
 		struct octep_ctrl_net_h2f_req_cmd_mtu mtu;
 		struct octep_ctrl_net_h2f_req_cmd_mac mac;
-		struct octep_ctrl_net_h2f_req_cmd_get_stats get_stats;
 		struct octep_ctrl_net_h2f_req_cmd_state link;
 		struct octep_ctrl_net_h2f_req_cmd_state rx;
 		struct octep_ctrl_net_h2f_req_cmd_link_info link_info;
@@ -152,6 +145,12 @@ struct octep_ctrl_net_h2f_resp_cmd_mac {
 	u8 addr[ETH_ALEN];
 };
 
+/* get if_stats, xstats, q_stats request */
+struct octep_ctrl_net_h2f_resp_cmd_get_stats {
+	struct octep_iface_rx_stats rx_stats;
+	struct octep_iface_tx_stats tx_stats;
+};
+
 /* get link state, rx state response */
 struct octep_ctrl_net_h2f_resp_cmd_state {
 	/* enum octep_ctrl_net_state */
@@ -164,6 +163,7 @@ struct octep_ctrl_net_h2f_resp {
 	union {
 		struct octep_ctrl_net_h2f_resp_cmd_mtu mtu;
 		struct octep_ctrl_net_h2f_resp_cmd_mac mac;
+		struct octep_ctrl_net_h2f_resp_cmd_get_stats if_stats;
 		struct octep_ctrl_net_h2f_resp_cmd_state link;
 		struct octep_ctrl_net_h2f_resp_cmd_state rx;
 		struct octep_ctrl_net_link_info link_info;
@@ -286,19 +286,25 @@ int octep_ctrl_net_set_mtu(struct octep_device *oct, int vfid, int mtu,
  *
  * @param oct: non-null pointer to struct octep_device.
  * @param vfid: Index of virtual function.
+ * @param rx_stats: non-null pointer struct octep_iface_rx_stats.
+ * @param tx_stats: non-null pointer struct octep_iface_tx_stats.
  *
  * return value: 0 on success, -errno on failure.
  */
-int octep_ctrl_net_get_if_stats(struct octep_device *oct, int vfid);
+int octep_ctrl_net_get_if_stats(struct octep_device *oct, int vfid,
+				struct octep_iface_rx_stats *rx_stats,
+				struct octep_iface_tx_stats *tx_stats);
 
 /** Get link info from firmware.
  *
  * @param oct: non-null pointer to struct octep_device.
  * @param vfid: Index of virtual function.
+ * @param link_info: non-null pointer to struct octep_iface_link_info.
  *
  * return value: 0 on success, -errno on failure.
  */
-int octep_ctrl_net_get_link_info(struct octep_device *oct, int vfid);
+int octep_ctrl_net_get_link_info(struct octep_device *oct, int vfid,
+				 struct octep_iface_link_info *link_info);
 
 /** Set link info in firmware.
  *
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ethtool.c b/drivers/net/ethernet/marvell/octeon_ep/octep_ethtool.c
index 389042b57787..7d0124b283da 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ethtool.c
@@ -150,9 +150,12 @@ octep_get_ethtool_stats(struct net_device *netdev,
 	rx_packets = 0;
 	rx_bytes = 0;
 
-	octep_ctrl_net_get_if_stats(oct, OCTEP_CTRL_NET_INVALID_VFID);
 	iface_tx_stats = &oct->iface_tx_stats;
 	iface_rx_stats = &oct->iface_rx_stats;
+	octep_ctrl_net_get_if_stats(oct,
+				    OCTEP_CTRL_NET_INVALID_VFID,
+				    iface_rx_stats,
+				    iface_tx_stats);
 
 	for (q = 0; q < oct->num_oqs; q++) {
 		struct octep_iq *iq = oct->iq[q];
@@ -283,11 +286,11 @@ static int octep_get_link_ksettings(struct net_device *netdev,
 	ethtool_link_ksettings_zero_link_mode(cmd, supported);
 	ethtool_link_ksettings_zero_link_mode(cmd, advertising);
 
-	octep_ctrl_net_get_link_info(oct, OCTEP_CTRL_NET_INVALID_VFID);
+	link_info = &oct->link_info;
+	octep_ctrl_net_get_link_info(oct, OCTEP_CTRL_NET_INVALID_VFID, link_info);
 
 	advertised_modes = oct->link_info.advertised_modes;
 	supported_modes = oct->link_info.supported_modes;
-	link_info = &oct->link_info;
 
 	OCTEP_SET_ETHTOOL_LINK_MODES_BITMAP(supported_modes, cmd, supported);
 	OCTEP_SET_ETHTOOL_LINK_MODES_BITMAP(advertised_modes, cmd, advertising);
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 112d3825e544..ba0d5fe3081d 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -763,7 +763,10 @@ static void octep_get_stats64(struct net_device *netdev,
 	int q;
 
 	if (netif_running(netdev))
-		octep_ctrl_net_get_if_stats(oct, OCTEP_CTRL_NET_INVALID_VFID);
+		octep_ctrl_net_get_if_stats(oct,
+					    OCTEP_CTRL_NET_INVALID_VFID,
+					    &oct->iface_rx_stats,
+					    &oct->iface_tx_stats);
 
 	tx_packets = 0;
 	tx_bytes = 0;
-- 
2.36.0

