Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 345141499AF
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 10:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgAZJD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 04:03:27 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42316 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgAZJD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 04:03:27 -0500
Received: by mail-pg1-f195.google.com with SMTP id s64so3574181pgb.9
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 01:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=78gUMQZNPVS/+qczHXdqil56Xfsy528oj63pBzGO5to=;
        b=O3WYjE1HroPMzz5WluC5k6bcwX03/sujcOh7ZNwKpUatZEuODwtGKuQnAvVKuRLOq9
         kXrBSNkKcBXo3FvoY4N2Qwo028zw61QgobP1EpTkPEI7GWveG6KR8i1aTLv0utBurfl2
         vMbD+Fmh8ULyd3wwybcQ7hto9QMDM98DBF28w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=78gUMQZNPVS/+qczHXdqil56Xfsy528oj63pBzGO5to=;
        b=K/aEZScbZW92nMjsvIO/MWaAPaGFdno45bD5f9+MBD1KtJsGHam1qZca1R+sP+tSDs
         GqOCFMNHT3kNqQ4xOeu1uYnyhSnhOaaXhJhqPgzQY/rAwUFL0OW4AEm3mDMn+r+L5Rhr
         8lilogAo/Vu/QuJ/wWJFUriH6qoEmJJllLEIj8MSBR0+mbHxP6HlqQ5uUXseKNgP5oPj
         MnQNFLkcVgHrufu0YC0rd7Dt4WzOQVZv2bI0/mHMZFWx7Ge4XV1yII4p4TjSd2p9zXUp
         ZMG++fl29xPSGThrEH+JtyxH9ImF7WPjmm7Dc39+w7FLhCiCyt2L0fvjv2GhjuUO6eCy
         1rzQ==
X-Gm-Message-State: APjAAAUgl2XwknMmtI6/+Husvjj7/XHybxi+8L9o4UU2ctI9FEry9RHq
        IsOZBLg56qnTDHgCWZXmZbl5vlwM258=
X-Google-Smtp-Source: APXvYqyxsWhk4b9QTL5trKVJVJ50ZcDgXwvYAr9rvzCUEY4L7kB13bHndHg6yyVce60o0HwRWCGssQ==
X-Received: by 2002:a63:4a50:: with SMTP id j16mr13813377pgl.323.1580029406146;
        Sun, 26 Jan 2020 01:03:26 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i17sm11856315pfr.67.2020.01.26.01.03.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jan 2020 01:03:25 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Subject: [PATCH net-next 01/16] bnxt_en: Support ingress rate limiting with TC-offload.
Date:   Sun, 26 Jan 2020 04:02:55 -0500
Message-Id: <1580029390-32760-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
References: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>

This patch enables offloading of ingress rate limiting TC-action
on a VF. The driver processes "cls_matchall" filter callbacks to
add and remove ingress rate limiting actions. The driver parses
police action parameter and sends the command to FW to configure
rate limiting for the VF.

For example, to configure rate limiting offload on a VF using OVS,
use the below command on the corresponding VF-rep port. The example
below configures min and max tx rates of 200 and 600 Mbps.

	# ovs-vsctl set interface bnxt0_pf0vf0 \
		ingress_policing_rate=600000 ingress_policing_burst=200000

Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  | 90 +++++++++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h  |  3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c |  2 +
 4 files changed, 96 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index f143354..534bc9e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1069,6 +1069,7 @@ struct bnxt_vf_info {
 	u32	max_tx_rate;
 	void	*hwrm_cmd_req_addr;
 	dma_addr_t	hwrm_cmd_req_dma_addr;
+	unsigned long police_id;
 };
 #endif
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 0cc6ec5..2dfb650 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -10,6 +10,7 @@
 #include <linux/netdevice.h>
 #include <linux/inetdevice.h>
 #include <linux/if_vlan.h>
+#include <linux/pci.h>
 #include <net/flow_dissector.h>
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_gact.h>
@@ -1983,6 +1984,95 @@ static int bnxt_tc_indr_block_event(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
+static inline int bnxt_tc_find_vf_by_fid(struct bnxt *bp, u16 fid)
+{
+	int num_vfs = pci_num_vf(bp->pdev);
+	int i;
+
+	for (i = 0; i < num_vfs; i++) {
+		if (bp->pf.vf[i].fw_fid == fid)
+			break;
+	}
+	if (i >= num_vfs)
+		return -EINVAL;
+	return i;
+}
+
+static int bnxt_tc_del_matchall(struct bnxt *bp, u16 src_fid,
+				struct tc_cls_matchall_offload *matchall_cmd)
+{
+	int vf_idx;
+
+	vf_idx = bnxt_tc_find_vf_by_fid(bp, src_fid);
+	if (vf_idx < 0)
+		return vf_idx;
+
+	if (bp->pf.vf[vf_idx].police_id != matchall_cmd->cookie)
+		return -ENOENT;
+
+	bnxt_set_vf_bw(bp->dev, vf_idx, 0, 0);
+	bp->pf.vf[vf_idx].police_id = 0;
+	return 0;
+}
+
+static int bnxt_tc_add_matchall(struct bnxt *bp, u16 src_fid,
+				struct tc_cls_matchall_offload *matchall_cmd)
+{
+	struct flow_action_entry *action;
+	int vf_idx;
+	s64 burst;
+	u64 rate;
+	int rc;
+
+	vf_idx = bnxt_tc_find_vf_by_fid(bp, src_fid);
+	if (vf_idx < 0)
+		return vf_idx;
+
+	action = &matchall_cmd->rule->action.entries[0];
+	if (action->id != FLOW_ACTION_POLICE) {
+		netdev_err(bp->dev, "%s: Unsupported matchall action: %d",
+			   __func__, action->id);
+		return -EOPNOTSUPP;
+	}
+	if (bp->pf.vf[vf_idx].police_id && bp->pf.vf[vf_idx].police_id !=
+	    matchall_cmd->cookie) {
+		netdev_err(bp->dev,
+			   "%s: Policer is already configured for VF: %d",
+			   __func__, vf_idx);
+		return -EEXIST;
+	}
+
+	rate = (u32)div_u64(action->police.rate_bytes_ps, 1024 * 1000) * 8;
+	burst = (u32)div_u64(action->police.rate_bytes_ps *
+			     PSCHED_NS2TICKS(action->police.burst),
+			     PSCHED_TICKS_PER_SEC);
+	burst = (u32)PSCHED_TICKS2NS(burst) / (1 << 20);
+
+	rc = bnxt_set_vf_bw(bp->dev, vf_idx, burst, rate);
+	if (rc) {
+		netdev_err(bp->dev,
+			   "Error: %s: VF: %d rate: %llu burst: %llu rc: %d",
+			   __func__, vf_idx, rate, burst, rc);
+		return rc;
+	}
+
+	bp->pf.vf[vf_idx].police_id = matchall_cmd->cookie;
+	return 0;
+}
+
+int bnxt_tc_setup_matchall(struct bnxt *bp, u16 src_fid,
+			   struct tc_cls_matchall_offload *cls_matchall)
+{
+	switch (cls_matchall->command) {
+	case TC_CLSMATCHALL_REPLACE:
+		return bnxt_tc_add_matchall(bp, src_fid, cls_matchall);
+	case TC_CLSMATCHALL_DESTROY:
+		return bnxt_tc_del_matchall(bp, src_fid, cls_matchall);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static const struct rhashtable_params bnxt_tc_flow_ht_params = {
 	.head_offset = offsetof(struct bnxt_tc_flow_node, node),
 	.key_offset = offsetof(struct bnxt_tc_flow_node, cookie),
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h
index 10c62b0..963788e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h
@@ -220,6 +220,9 @@ int bnxt_tc_setup_flower(struct bnxt *bp, u16 src_fid,
 int bnxt_init_tc(struct bnxt *bp);
 void bnxt_shutdown_tc(struct bnxt *bp);
 void bnxt_tc_flow_stats_work(struct bnxt *bp);
+int bnxt_tc_setup_matchall(struct bnxt *bp, u16 src_fid,
+			   struct tc_cls_matchall_offload *cls_matchall);
+
 
 static inline bool bnxt_tc_flower_enabled(struct bnxt *bp)
 {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index b010b34..b9d3dae 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -156,6 +156,8 @@ static int bnxt_vf_rep_setup_tc_block_cb(enum tc_setup_type type,
 	switch (type) {
 	case TC_SETUP_CLSFLOWER:
 		return bnxt_tc_setup_flower(bp, vf_fid, type_data);
+	case TC_SETUP_CLSMATCHALL:
+		return bnxt_tc_setup_matchall(bp, vf_fid, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.5.1

