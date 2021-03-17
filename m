Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A023233F148
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 14:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhCQNga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 09:36:30 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60112 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231317AbhCQNgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 09:36:09 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12HDQIJl006945;
        Wed, 17 Mar 2021 06:36:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=6tgFqoPLqSEHGczlprrDEf7UQFIB9H++OG1ipSoJMzA=;
 b=ZKppk7M0Stot2UrpaYv4UQ8hW2TERPvsdQb9DrPlzpr6XPs6uMOdg9OnBKNTyyNeYiex
 dvMbL3KWNHMw8ZvDptc6Tz1Nzmv4HjRZHVPT3xF8iWrlpoFgtY4KkW29dVumy+1hceRK
 F+KTJJ88/rgNJfhrPkdjHgXWID4X0rCD30bJk+owPjOhzDKSLqB1RpRhoDM+LAqvrBeT
 +iJ64R8whfuddg/pPtkiOrQUK4oLVGHUcMCJ5t8d6F8Lxni+Mjf/jKIT4ArB7NVgY8k5
 TvzCSj8FlAX39lLCBZQVKof+yzT2zBkhF6QnrzMcOV5ZIJq5kEs/bImLNC6rcZZAIX6X ig== 
Received: from dc6wp-exch01.marvell.com ([4.21.29.232])
        by mx0b-0016f401.pphosted.com with ESMTP id 378wsqvf4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 17 Mar 2021 06:36:01 -0700
Received: from DC6WP-EXCH01.marvell.com (10.76.176.21) by
 DC6WP-EXCH01.marvell.com (10.76.176.21) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 17 Mar 2021 09:36:00 -0400
Received: from maili.marvell.com (10.76.176.51) by DC6WP-EXCH01.marvell.com
 (10.76.176.21) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 17 Mar 2021 09:36:00 -0400
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 0043A3F7041;
        Wed, 17 Mar 2021 06:35:56 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <jerinj@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, "Naveen Mamindlapalli" <naveenm@marvell.com>
Subject: [PATCH net-next 4/5] octeontx2-af: Avoid duplicate unicast rule in mcam_rules list
Date:   Wed, 17 Mar 2021 19:05:37 +0530
Message-ID: <20210317133538.15609-5-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20210317133538.15609-1-naveenm@marvell.com>
References: <20210317133538.15609-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-17_07:2021-03-17,2021-03-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

A mcam rule described by mcam_rule struct has all the info
such as the hardware MCAM entry number, match criteria and
corresponding action etc. All mcam rules are stored in a
linked list mcam->rules. When adding/updating a rule to the
mcam->rules it is checked if a rule already exists for the
mcam entry. If the rule already exists, the same rule is
updated instead of creating new rule. This way only one
mcam_rule exists for the only one default unicast entry
installed by AF. But a PF/VF can get different NIXLF
(or default unicast entry number) after a attach-detach-attach
sequence. When that happens mcam_rules list end up with two
default unicast rules. Fix the problem by deleting the default
unicast rule list node always when disabling mcam rules.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 4 +---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 9 ++++++---
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index f2a1c4235f74..a87104121344 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3637,9 +3637,7 @@ int rvu_mbox_handler_nix_lf_stop_rx(struct rvu *rvu, struct msg_req *req,
 	if (err)
 		return err;
 
-	rvu_npc_disable_default_entries(rvu, pcifunc, nixlf);
-
-	npc_mcam_disable_flows(rvu, pcifunc);
+	rvu_npc_disable_mcam_entries(rvu, pcifunc, nixlf);
 
 	return rvu_cgx_start_stop_io(rvu, pcifunc, false);
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 4c3f6432b671..6cce7ecad007 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -988,7 +988,7 @@ void rvu_npc_disable_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
 	struct npc_mcam *mcam = &rvu->hw->mcam;
-	struct rvu_npc_mcam_rule *rule;
+	struct rvu_npc_mcam_rule *rule, *tmp;
 	int blkaddr;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
@@ -998,15 +998,18 @@ void rvu_npc_disable_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 	mutex_lock(&mcam->lock);
 
 	/* Disable MCAM entries directing traffic to this 'pcifunc' */
-	list_for_each_entry(rule, &mcam->mcam_rules, list) {
+	list_for_each_entry_safe(rule, tmp, &mcam->mcam_rules, list) {
 		if (is_npc_intf_rx(rule->intf) &&
 		    rule->rx_action.pf_func == pcifunc) {
 			npc_enable_mcam_entry(rvu, mcam, blkaddr,
 					      rule->entry, false);
 			rule->enable = false;
 			/* Indicate that default rule is disabled */
-			if (rule->default_rule)
+			if (rule->default_rule) {
 				pfvf->def_ucast_rule = NULL;
+				list_del(&rule->list);
+				kfree(rule);
+			}
 		}
 	}
 
-- 
2.16.5

