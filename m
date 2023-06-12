Return-Path: <netdev+bounces-9964-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BB6872B7DD
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:04:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A6D81C20A28
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 06:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1512723A2;
	Mon, 12 Jun 2023 06:04:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0393820F1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 06:04:48 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7176AE7B;
	Sun, 11 Jun 2023 23:04:47 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35BLnDkC008077;
	Sun, 11 Jun 2023 23:04:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=OOmvB5+6KgS4oJZrdP1IzUNOUsfYdvY5dutTspC5l1k=;
 b=OHNcXTAfFbiIB1WvXtWMKUP/BNtVCraksijezRUj17Z2k86gIiNU13JNrcJ77TO9Pm/m
 oPsLwFBaIVr7lPB88bTHZ3EVIytPVRzz035LJFRmyzM6XjFYg0qQmQGKoYtMW0Ly+Hs3
 3JH6gxrP6VLOILQbCSFfeD6Wq+MPyN/5Sj3QZOrJn2PoNra0OtGGqoo+BUwRV2eg8Gyw
 PyfJiqQJr+JA+q/YqU4DQrbM3KL6SzWxqIRTWmQqq6bablWAt43RfNSP8TAIhb9s9dG4
 As1vgR/40oNy2mapvBtHjXqAXf1UXhsyNQ8CTgXAcPRtzHtpbVx/SoCYAyjDUw+ywGwF JQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3r4phnc9tt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Sun, 11 Jun 2023 23:04:33 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 11 Jun
 2023 23:04:32 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sun, 11 Jun 2023 23:04:32 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
	by maili.marvell.com (Postfix) with ESMTP id 7D6185B6944;
	Sun, 11 Jun 2023 23:04:29 -0700 (PDT)
From: Naveen Mamindlapalli <naveenm@marvell.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>
CC: Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [net-next PATCH v2 1/6] octeontx2-af: Add devlink option to adjust mcam high prio zone entries
Date: Mon, 12 Jun 2023 11:34:19 +0530
Message-ID: <20230612060424.1427-2-naveenm@marvell.com>
X-Mailer: git-send-email 2.39.0.198.ga38d39a4c5
In-Reply-To: <20230612060424.1427-1-naveenm@marvell.com>
References: <20230612060424.1427-1-naveenm@marvell.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: ax8Y214fj1iFo-5b6QAoUJUzI1kf15nc
X-Proofpoint-ORIG-GUID: ax8Y214fj1iFo-5b6QAoUJUzI1kf15nc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-12_03,2023-06-09_01,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The NPC MCAM entries are currently divided into three priority zones
in AF driver: high, mid, and low. The high priority zone and low priority
zone take up 1/8th (each) of the available MCAM entries, and remaining
going to the mid priority zone.

The current allocation scheme may not meet certain requirements, such
as when a requester needs more high priority zone entries than are
reserved. This patch adds a devlink configurable option to increase the
number of high priority zone entries that can be allocated by requester.
The max number of entries that can be reserved for high priority usage
is 100% of available MCAM entries.

Usage:
1) Change high priority zone percentage to 75%:
devlink -p dev param set pci/0002:01:00.0 name npc_mcam_high_zone_percent \
value 75 cmode runtime

2) Read high priority zone percentage:
devlink -p dev param show pci/0002:01:00.0 name npc_mcam_high_zone_percent

The devlink set configuration is only permitted when no MCAM entries
are assigned, i.e., all MCAM entries are free, indicating that no PF/VF
driver is loaded. So user must unload/unbind PF/VF driver/devices before
modifying the high priority zone percentage.

Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../marvell/octeontx2/af/rvu_devlink.c        | 68 +++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index e4407f09c9d3..548549604c49 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -1438,6 +1438,7 @@ enum rvu_af_dl_param_id {
 	RVU_AF_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
 	RVU_AF_DEVLINK_PARAM_ID_DWRR_MTU,
 	RVU_AF_DEVLINK_PARAM_ID_NPC_EXACT_FEATURE_DISABLE,
+	RVU_AF_DEVLINK_PARAM_ID_NPC_MCAM_ZONE_PERCENT,
 };
 
 static int rvu_af_npc_exact_feature_get(struct devlink *devlink, u32 id,
@@ -1494,6 +1495,67 @@ static int rvu_af_npc_exact_feature_validate(struct devlink *devlink, u32 id,
 	return -EFAULT;
 }
 
+static int rvu_af_dl_npc_mcam_high_zone_percent_get(struct devlink *devlink, u32 id,
+						    struct devlink_param_gset_ctx *ctx)
+{
+	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
+	struct rvu *rvu = rvu_dl->rvu;
+	struct npc_mcam *mcam;
+	u32 percent;
+
+	mcam = &rvu->hw->mcam;
+	percent = (mcam->hprio_count * 100) / mcam->bmap_entries;
+	ctx->val.vu8 = (u8)percent;
+
+	return 0;
+}
+
+static int rvu_af_dl_npc_mcam_high_zone_percent_set(struct devlink *devlink, u32 id,
+						    struct devlink_param_gset_ctx *ctx)
+{
+	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
+	struct rvu *rvu = rvu_dl->rvu;
+	struct npc_mcam *mcam;
+	u32 percent;
+
+	percent = ctx->val.vu8;
+	mcam = &rvu->hw->mcam;
+	mcam->hprio_count = (mcam->bmap_entries * percent) / 100;
+	mcam->hprio_end = mcam->hprio_count;
+	mcam->lprio_count = (mcam->bmap_entries - mcam->hprio_count) / 2;
+	mcam->lprio_start = mcam->bmap_entries - mcam->lprio_count;
+
+	return 0;
+}
+
+static int rvu_af_dl_npc_mcam_high_zone_percent_validate(struct devlink *devlink, u32 id,
+							 union devlink_param_value val,
+							 struct netlink_ext_ack *extack)
+{
+	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
+	struct rvu *rvu = rvu_dl->rvu;
+	struct npc_mcam *mcam;
+
+	/* The percent of high prio zone must range from 12% to 100% of unreserved mcam space */
+	if (val.vu8 < 12 || val.vu8 > 100) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "mcam high zone percent must be between 12% to 100%");
+		return -EINVAL;
+	}
+
+	/* Do not allow user to modify the high priority zone entries while mcam entries
+	 * have already been assigned.
+	 */
+	mcam = &rvu->hw->mcam;
+	if (mcam->bmap_fcnt < mcam->bmap_entries) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "mcam entries have already been assigned, can't resize");
+		return -EPERM;
+	}
+
+	return 0;
+}
+
 static const struct devlink_param rvu_af_dl_params[] = {
 	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_DWRR_MTU,
 			     "dwrr_mtu", DEVLINK_PARAM_TYPE_U32,
@@ -1509,6 +1571,12 @@ static const struct devlink_param rvu_af_dl_param_exact_match[] = {
 			     rvu_af_npc_exact_feature_get,
 			     rvu_af_npc_exact_feature_disable,
 			     rvu_af_npc_exact_feature_validate),
+	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_NPC_MCAM_ZONE_PERCENT,
+			     "npc_mcam_high_zone_percent", DEVLINK_PARAM_TYPE_U8,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     rvu_af_dl_npc_mcam_high_zone_percent_get,
+			     rvu_af_dl_npc_mcam_high_zone_percent_set,
+			     rvu_af_dl_npc_mcam_high_zone_percent_validate),
 };
 
 /* Devlink switch mode */
-- 
2.39.0.198.ga38d39a4c5


