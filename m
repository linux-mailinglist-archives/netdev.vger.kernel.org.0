Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 772A6181367
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 09:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbgCKIiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 04:38:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:50110 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728585AbgCKIiE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 04:38:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D5CD1B1B4;
        Wed, 11 Mar 2020 08:38:01 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH 3/7] mlx4: Use scnprintf() for avoiding potential buffer overflow
Date:   Wed, 11 Mar 2020 09:37:41 +0100
Message-Id: <20200311083745.17328-4-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200311083745.17328-1-tiwai@suse.de>
References: <20200311083745.17328-1-tiwai@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since snprintf() returns the would-be-output size instead of the
actual output size, the succeeding calls may go beyond the given
buffer limit.  Fix it by replacing with scnprintf().

Cc: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/net/ethernet/mellanox/mlx4/mcg.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/mcg.c b/drivers/net/ethernet/mellanox/mlx4/mcg.c
index 9c481823b3e8..c0217239122d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mcg.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mcg.c
@@ -906,32 +906,32 @@ static void mlx4_err_rule(struct mlx4_dev *dev, char *str,
 	int len = 0;
 
 	mlx4_err(dev, "%s", str);
-	len += snprintf(buf + len, BUF_SIZE - len,
+	len += scnprintf(buf + len, BUF_SIZE - len,
 			"port = %d prio = 0x%x qp = 0x%x ",
 			rule->port, rule->priority, rule->qpn);
 
 	list_for_each_entry(cur, &rule->list, list) {
 		switch (cur->id) {
 		case MLX4_NET_TRANS_RULE_ID_ETH:
-			len += snprintf(buf + len, BUF_SIZE - len,
+			len += scnprintf(buf + len, BUF_SIZE - len,
 					"dmac = %pM ", &cur->eth.dst_mac);
 			if (cur->eth.ether_type)
-				len += snprintf(buf + len, BUF_SIZE - len,
+				len += scnprintf(buf + len, BUF_SIZE - len,
 						"ethertype = 0x%x ",
 						be16_to_cpu(cur->eth.ether_type));
 			if (cur->eth.vlan_id)
-				len += snprintf(buf + len, BUF_SIZE - len,
+				len += scnprintf(buf + len, BUF_SIZE - len,
 						"vlan-id = %d ",
 						be16_to_cpu(cur->eth.vlan_id));
 			break;
 
 		case MLX4_NET_TRANS_RULE_ID_IPV4:
 			if (cur->ipv4.src_ip)
-				len += snprintf(buf + len, BUF_SIZE - len,
+				len += scnprintf(buf + len, BUF_SIZE - len,
 						"src-ip = %pI4 ",
 						&cur->ipv4.src_ip);
 			if (cur->ipv4.dst_ip)
-				len += snprintf(buf + len, BUF_SIZE - len,
+				len += scnprintf(buf + len, BUF_SIZE - len,
 						"dst-ip = %pI4 ",
 						&cur->ipv4.dst_ip);
 			break;
@@ -939,25 +939,25 @@ static void mlx4_err_rule(struct mlx4_dev *dev, char *str,
 		case MLX4_NET_TRANS_RULE_ID_TCP:
 		case MLX4_NET_TRANS_RULE_ID_UDP:
 			if (cur->tcp_udp.src_port)
-				len += snprintf(buf + len, BUF_SIZE - len,
+				len += scnprintf(buf + len, BUF_SIZE - len,
 						"src-port = %d ",
 						be16_to_cpu(cur->tcp_udp.src_port));
 			if (cur->tcp_udp.dst_port)
-				len += snprintf(buf + len, BUF_SIZE - len,
+				len += scnprintf(buf + len, BUF_SIZE - len,
 						"dst-port = %d ",
 						be16_to_cpu(cur->tcp_udp.dst_port));
 			break;
 
 		case MLX4_NET_TRANS_RULE_ID_IB:
-			len += snprintf(buf + len, BUF_SIZE - len,
+			len += scnprintf(buf + len, BUF_SIZE - len,
 					"dst-gid = %pI6\n", cur->ib.dst_gid);
-			len += snprintf(buf + len, BUF_SIZE - len,
+			len += scnprintf(buf + len, BUF_SIZE - len,
 					"dst-gid-mask = %pI6\n",
 					cur->ib.dst_gid_msk);
 			break;
 
 		case MLX4_NET_TRANS_RULE_ID_VXLAN:
-			len += snprintf(buf + len, BUF_SIZE - len,
+			len += scnprintf(buf + len, BUF_SIZE - len,
 					"VNID = %d ", be32_to_cpu(cur->vxlan.vni));
 			break;
 		case MLX4_NET_TRANS_RULE_ID_IPV6:
@@ -967,7 +967,7 @@ static void mlx4_err_rule(struct mlx4_dev *dev, char *str,
 			break;
 		}
 	}
-	len += snprintf(buf + len, BUF_SIZE - len, "\n");
+	len += scnprintf(buf + len, BUF_SIZE - len, "\n");
 	mlx4_err(dev, "%s", buf);
 
 	if (len >= BUF_SIZE)
-- 
2.16.4

