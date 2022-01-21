Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E164959FA
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 07:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378713AbiAUGfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 01:35:10 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28522 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378712AbiAUGfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 01:35:09 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20L05kDo029276;
        Thu, 20 Jan 2022 22:34:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=t1E772S0AFRQG4EpxpuvjKnwOFoUTyIzUElSazZw6ko=;
 b=AoGJ1UBlYwaNNrxAXZS6rhH/LGmsZZwvHzVWIs+4GKraI7pxUKG4Tw5PSeoMRmUF0kzr
 O5fZcKFY+D1VFvx5i+sZ4SIUafD7F0ebcuhvGF0/E6QJLgD/uSXYXMWnElNr+LN3e7rS
 yGpJkwxjp9zPyMx7rPLt4SLwFuFNlUF+VCd1UswEnNQCxme2UzNsViXxdqTI8jpv07ou
 4o5xJNRhUQg6tXNWSY9dSkcH19dNqdj3f9wYO9Xoy2a0PG8AZxROHUMRVi19XavL9qNZ
 srmB8Ed+S+6TLCNuGnYULYgMn7AM6OTUyRLDwwNRiGYlfxeShwh6eIdfqehbq4w3CrPD uA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dqj05gxw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 22:34:59 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 20 Jan
 2022 22:34:57 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 20 Jan 2022 22:34:57 -0800
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id E3DAB3F7060;
        Thu, 20 Jan 2022 22:34:53 -0800 (PST)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <sundeep.lkml@gmail.com>
CC:     <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [net PATCH 1/9] octeontx2-af: Do not fixup all VF action entries
Date:   Fri, 21 Jan 2022 12:04:39 +0530
Message-ID: <1642746887-30924-2-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1642746887-30924-1-git-send-email-sbhatta@marvell.com>
References: <1642746887-30924-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: dAYRGrAOjZLiY-F2HRM5kplfnsunx0ea
X-Proofpoint-ORIG-GUID: dAYRGrAOjZLiY-F2HRM5kplfnsunx0ea
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_02,2022-01-20_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

AF modifies all the rules destined for VF to use
the action same as default RSS action. This fixup
was needed because AF only installs default rules with
RSS action. But the action in rules installed by a PF
for its VFs should not be changed by this fixup.
This is because action can be drop or direct to
queue as specified by user(ntuple filters).
This patch fixes that problem.

Fixes: 967db3529eca ("octeontx2-af: add support for multicast/promisc packet")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 22 +++++++++++++++++++---
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 20 ++++++++++++--------
 2 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index c0005a1..91f86d7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -402,6 +402,7 @@ static void npc_fixup_vf_rule(struct rvu *rvu, struct npc_mcam *mcam,
 			      int blkaddr, int index, struct mcam_entry *entry,
 			      bool *enable)
 {
+	struct rvu_npc_mcam_rule *rule;
 	u16 owner, target_func;
 	struct rvu_pfvf *pfvf;
 	u64 rx_action;
@@ -423,6 +424,12 @@ static void npc_fixup_vf_rule(struct rvu *rvu, struct npc_mcam *mcam,
 	      test_bit(NIXLF_INITIALIZED, &pfvf->flags)))
 		*enable = false;
 
+	/* fix up not needed for the rules added by user(ntuple filters) */
+	list_for_each_entry(rule, &mcam->mcam_rules, list) {
+		if (rule->entry == index)
+			return;
+	}
+
 	/* copy VF default entry action to the VF mcam entry */
 	rx_action = npc_get_default_entry_action(rvu, mcam, blkaddr,
 						 target_func);
@@ -489,8 +496,8 @@ static void npc_config_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 	}
 
 	/* PF installing VF rule */
-	if (intf == NIX_INTF_RX && actindex < mcam->bmap_entries)
-		npc_fixup_vf_rule(rvu, mcam, blkaddr, index, entry, &enable);
+	if (is_npc_intf_rx(intf) && actindex < mcam->bmap_entries)
+		npc_fixup_vf_rule(rvu, mcam, blkaddr, actindex, entry, &enable);
 
 	/* Set 'action' */
 	rvu_write64(rvu, blkaddr,
@@ -916,7 +923,8 @@ static void npc_update_vf_flow_entry(struct rvu *rvu, struct npc_mcam *mcam,
 				     int blkaddr, u16 pcifunc, u64 rx_action)
 {
 	int actindex, index, bank, entry;
-	bool enable;
+	struct rvu_npc_mcam_rule *rule;
+	bool enable, update;
 
 	if (!(pcifunc & RVU_PFVF_FUNC_MASK))
 		return;
@@ -924,6 +932,14 @@ static void npc_update_vf_flow_entry(struct rvu *rvu, struct npc_mcam *mcam,
 	mutex_lock(&mcam->lock);
 	for (index = 0; index < mcam->bmap_entries; index++) {
 		if (mcam->entry2target_pffunc[index] == pcifunc) {
+			update = true;
+			/* update not needed for the rules added via ntuple filters */
+			list_for_each_entry(rule, &mcam->mcam_rules, list) {
+				if (rule->entry == index)
+					update = false;
+			}
+			if (!update)
+				continue;
 			bank = npc_get_bank(mcam, index);
 			actindex = index;
 			entry = index & (mcam->banksize - 1);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index ff2b219..19c53e5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -1098,14 +1098,6 @@ static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
 		write_req.cntr = rule->cntr;
 	}
 
-	err = rvu_mbox_handler_npc_mcam_write_entry(rvu, &write_req,
-						    &write_rsp);
-	if (err) {
-		rvu_mcam_remove_counter_from_rule(rvu, owner, rule);
-		if (new)
-			kfree(rule);
-		return err;
-	}
 	/* update rule */
 	memcpy(&rule->packet, &dummy.packet, sizeof(rule->packet));
 	memcpy(&rule->mask, &dummy.mask, sizeof(rule->mask));
@@ -1132,6 +1124,18 @@ static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
 	if (req->default_rule)
 		pfvf->def_ucast_rule = rule;
 
+	/* write to mcam entry registers */
+	err = rvu_mbox_handler_npc_mcam_write_entry(rvu, &write_req,
+						    &write_rsp);
+	if (err) {
+		rvu_mcam_remove_counter_from_rule(rvu, owner, rule);
+		if (new) {
+			list_del(&rule->list);
+			kfree(rule);
+		}
+		return err;
+	}
+
 	/* VF's MAC address is being changed via PF  */
 	if (pf_set_vfs_mac) {
 		ether_addr_copy(pfvf->default_mac, req->packet.dmac);
-- 
2.7.4

