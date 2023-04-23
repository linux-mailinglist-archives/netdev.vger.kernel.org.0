Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C27E6EBE5B
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 11:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjDWJzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 05:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbjDWJzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 05:55:20 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3AD01703;
        Sun, 23 Apr 2023 02:55:19 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33N4iPJV009043;
        Sun, 23 Apr 2023 02:55:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=412sMmBPtRwejRkOl3zUwewPWQkjGdbj1oOMq1i3Rhk=;
 b=QYRyRNgOGY22CHuzLwv+5sEZVxiLjpT2xRmBiNTPADyQqnscGpGvimYKcQC9Rh7d/4gu
 KmXTeN82heuU2zKa66f0sWQAdXeX2jfKfMswY7KzKbKOkzHsLcwwVeepLH5d/KHL/mBk
 wvsw2z50T75gp2ErMhUqN65FhBuemtAKdy5iI1dNxvqmcO3AP7gkPgKHmvNdytTlzY6p
 bhzjyyAoS1wT/zLNmb2QH2oj8CGb/gs+L41MyNA9kOor9j3MJCHleQsf1ewXwLeAJMHA
 5s8CvmGHsPAP4gzdE3nfV1QEfXQsr2EtL6deGKftnr5/J1cBT5nzyl+kSbLUDuS4aAx5 9w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q4f3p2pqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 23 Apr 2023 02:55:12 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 23 Apr
 2023 02:55:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sun, 23 Apr 2023 02:55:10 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 205F03F706A;
        Sun, 23 Apr 2023 02:55:06 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net PATCH 3/9] octeontx2-af: mcs: Config parser to skip 8B header
Date:   Sun, 23 Apr 2023 15:24:48 +0530
Message-ID: <20230423095454.21049-4-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230423095454.21049-1-gakula@marvell.com>
References: <20230423095454.21049-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 0M9m84u7VB0sZYsdg4GAR9ksP9_B5beB
X-Proofpoint-GUID: 0M9m84u7VB0sZYsdg4GAR9ksP9_B5beB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-23_06,2023-04-21_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When ptp timestamp is enabled in RPM, RPM will append 8B
timestamp header for all RX traffic. MCS need to skip these
8 bytes header while parsing the packet header, so that
correct tcam key is created for lookup. 
This patch fixes the mcs parser configuration to skip this 
8B header for ptp packets.

Fixes: ca7f49ff8846 ("octeontx2-af: cn10k: Introduce driver for macsec block.")
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
---
 .../ethernet/marvell/octeontx2/af/mcs_reg.h   |  1 +
 .../marvell/octeontx2/af/mcs_rvu_if.c         | 37 +++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  1 +
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   |  2 +
 4 files changed, 41 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h
index c95a8b8f5eaf..7427e3b1490f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h
@@ -97,6 +97,7 @@
 #define MCSX_PEX_TX_SLAVE_VLAN_CFGX(a)          (0x46f8ull + (a) * 0x8ull)
 #define MCSX_PEX_TX_SLAVE_CUSTOM_TAG_REL_MODE_SEL(a)	(0x788ull + (a) * 0x8ull)
 #define MCSX_PEX_TX_SLAVE_PORT_CONFIG(a)		(0x4738ull + (a) * 0x8ull)
+#define MCSX_PEX_RX_SLAVE_PORT_CFGX(a)		(0x3b98ull + (a) * 0x8ull)
 #define MCSX_PEX_RX_SLAVE_RULE_ETYPE_CFGX(a) ({	\
 	u64 offset;					\
 							\
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
index eb25e458266c..dfd23580e3b8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
@@ -11,6 +11,7 @@
 
 #include "mcs.h"
 #include "rvu.h"
+#include "mcs_reg.h"
 #include "lmac_common.h"
 
 #define M(_name, _id, _fn_name, _req_type, _rsp_type)			\
@@ -32,6 +33,42 @@ static struct _req_type __maybe_unused					\
 MBOX_UP_MCS_MESSAGES
 #undef M
 
+void rvu_mcs_ptp_cfg(struct rvu *rvu, u8 rpm_id, u8 lmac_id, bool ena)
+{
+	struct mcs *mcs;
+	u64 cfg;
+	u8 port;
+
+	if (!rvu->mcs_blk_cnt)
+		return;
+
+	/* When ptp is enabled, RPM appends 8B header for all
+	 * RX packets. MCS PEX need to configure to skip 8B
+	 * during packet parsing.
+	 */
+
+	/* CNF10K-B */
+	if (rvu->mcs_blk_cnt > 1) {
+		mcs = mcs_get_pdata(rpm_id);
+		cfg = mcs_reg_read(mcs, MCSX_PEX_RX_SLAVE_PEX_CONFIGURATION);
+		if (ena)
+			cfg |= BIT_ULL(lmac_id);
+		else
+			cfg &= ~BIT_ULL(lmac_id);
+		mcs_reg_write(mcs, MCSX_PEX_RX_SLAVE_PEX_CONFIGURATION, cfg);
+		return;
+	}
+	/* CN10KB */
+	mcs = mcs_get_pdata(0);
+	port = (rpm_id * rvu->hw->lmac_per_cgx) + lmac_id;
+	cfg = mcs_reg_read(mcs, MCSX_PEX_RX_SLAVE_PORT_CFGX(port));
+	if (ena)
+		cfg |= BIT_ULL(0);
+	else
+		cfg &= ~BIT_ULL(0);
+	mcs_reg_write(mcs, MCSX_PEX_RX_SLAVE_PORT_CFGX(port), cfg);
+}
+
 int rvu_mbox_handler_mcs_set_lmac_mode(struct rvu *rvu,
 				       struct mcs_set_lmac_mode *req,
 				       struct msg_rsp *rsp)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index ef721caeac49..d655bf04a483 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -920,6 +920,7 @@ int rvu_get_hwvf(struct rvu *rvu, int pcifunc);
 /* CN10K MCS */
 int rvu_mcs_init(struct rvu *rvu);
 int rvu_mcs_flr_handler(struct rvu *rvu, u16 pcifunc);
+void rvu_mcs_ptp_cfg(struct rvu *rvu, u8 rpm_id, u8 lmac_id, bool ena);
 void rvu_mcs_exit(struct rvu *rvu);
 
 #endif /* RVU_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 438b212fb54a..83b342fa8d75 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -773,6 +773,8 @@ static int rvu_cgx_ptp_rx_cfg(struct rvu *rvu, u16 pcifunc, bool enable)
 	/* This flag is required to clean up CGX conf if app gets killed */
 	pfvf->hw_rx_tstamp_en = enable;
 
+	/* Inform MCS about 8B RX header */
+	rvu_mcs_ptp_cfg(rvu, cgx_id, lmac_id, enable);
 	return 0;
 }
 
-- 
2.25.1

