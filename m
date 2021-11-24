Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B088A45B3BD
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 06:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhKXFMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 00:12:16 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55816 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229482AbhKXFMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 00:12:15 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1ANNFkNf015555;
        Tue, 23 Nov 2021 21:09:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=Qr0AabrZhUOSwrAqlA9XVKyzhev6tqRlBTU7rYVx7XM=;
 b=TShWHUNAxu5lWO3z7ORstOLkqMvWtZUEXkHM4H4YJGQZ6pnn0dK93LydUou/f1xv5dab
 O8Lq/HGXkzRDIEiQUgdsWyi2dB6eSkBEr2Yvm7NMA2dyJdpYGaoLufJW/VxrlC57CkrL
 6CZXekXaAWzbAjoKo0ebYPjSvzDcxqEs8LF1MlgZiUYAaRSBsAU4d29WE6hswjQdj7ua
 nfkzSdGHj6IDZiuyUruWgZT+gGiwHJVlRzl6+UKvz2/H2wu6Zkz+J0Y3FQK11o6caBn+
 HhWJipDJ+0mFO3Rrcsw3YPisdKxTafjTyXYFnpOIfluuWKlIzEb7CwyEJqOemN84nDCH LA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3ch9tr159q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 21:09:05 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Nov
 2021 21:09:03 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 23 Nov 2021 21:09:03 -0800
Received: from localhost.localdomain (unknown [10.28.34.29])
        by maili.marvell.com (Postfix) with ESMTP id 1418A5B693A;
        Tue, 23 Nov 2021 21:09:01 -0800 (PST)
From:   Shijith Thotton <sthotton@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     Shijith Thotton <sthotton@marvell.com>, <sgoutham@marvell.com>,
        <jerinj@marvell.com>, <netdev@vger.kernel.org>
Subject: [PATCH net-next] octeontx2-af: cn10k: devlink params to configure TIM
Date:   Wed, 24 Nov 2021 10:38:41 +0530
Message-ID: <f2256d3f1a6a44632b04b182f28faf92848642c3.1637730085.git.sthotton@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: xlmndKsMqILMC58vmXQP0Wa44uzpWNKt
X-Proofpoint-GUID: xlmndKsMqILMC58vmXQP0Wa44uzpWNKt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-24_01,2021-11-23_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added devlink parameters to configure the source clock of TIM block.
Supported clocks are TENNS, GPIOS, GTI, PTP, SYNC, BTS, EXT_MIO and
EXT_GTI.

To adjust a given clock, the required delta can be written to the
corresponding tim_adjust_<clock> parameter and tim_adjust_timers
parameter can be used to trigger the adjustment. tim_capture_<clock>
parameter can be used to verify the adjusted values for a clock.

Example using tenns clock source:
To adjust a clock source
 # devlink dev param set pci/0002:01:00.0 name tim_adjust_tenns \
        value "1000" cmode runtime

To trigger adjustment
 # devlink dev param set pci/0002:01:00.0 name tim_adjust_timers \
        value 1 cmode runtime

Signed-off-by: Shijith Thotton <sthotton@marvell.com>
---
 .../networking/devlink/octeontx2.rst          |  59 ++++
 .../marvell/octeontx2/af/rvu_devlink.c        | 257 +++++++++++++++++-
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |  15 +
 3 files changed, 327 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/devlink/octeontx2.rst b/Documentation/networking/devlink/octeontx2.rst
index 610de99b728a..309697b34d57 100644
--- a/Documentation/networking/devlink/octeontx2.rst
+++ b/Documentation/networking/devlink/octeontx2.rst
@@ -40,3 +40,62 @@ The ``octeontx2 AF`` driver implements the following driver-specific parameters.
      - runtime
      - Use to set the quantum which hardware uses for scheduling among transmit queues.
        Hardware uses weighted DWRR algorithm to schedule among all transmit queues.
+   * - ``tim_capture_timers``
+     - u8
+     - runtime
+     - Trigger capture of cycles count of TIM clock sources. Valid values are:
+        * 0 - capture free running cycle count.
+        * 1 - capture at the software trigger.
+        * 2 - capture at the next rising edge of GPIO.
+   * - ``tim_capture_tenns``
+     - String
+     - runtime
+     - Capture cycle count of tenns clock.
+   * - ``tim_capture_gpios``
+     - String
+     - runtime
+     - Capture cycle count of gpios clock.
+   * - ``tim_capture_gti``
+     - String
+     - runtime
+     - Capture cycle count of gti clock.
+   * - ``tim_capture_ptp``
+     - String
+     - runtime
+     - Capture cycle count of ptp clock.
+   * - ``tim_capture_sync``
+     - String
+     - runtime
+     - Capture cycle count of sync clock.
+   * - ``tim_capture_bts``
+     - String
+     - runtime
+     - Capture cycle count of bts clock.
+   * - ``tim_capture_ext_gti``
+     - String
+     - runtime
+     - Capture cycle count of external gti clock.
+   * - ``tim_adjust_timers``
+     - Boolean
+     - runtime
+     - Trigger adjustment of all TIM clock sources.
+   * - ``tim_adjust_tenns``
+     - String
+     - runtime
+     - Adjustment required in number of cycles for tenns clock.
+   * - ``tim_adjust_gpios``
+     - String
+     - runtime
+     - Adjustment required in number of cycles for gpios clock.
+   * - ``tim_adjust_gti``
+     - String
+     - runtime
+     - Adjustment required in number of cycles for gti clock.
+   * - ``tim_adjust_ptp``
+     - String
+     - runtime
+     - Adjustment required in number of cycles for ptp clock.
+   * - ``tim_adjust_bts``
+     - String
+     - runtime
+     - Adjustment required in number of cycles for bts clock.
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index 70bacd38a6d9..7eb220888b11 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -1364,6 +1364,68 @@ static void rvu_health_reporters_destroy(struct rvu *rvu)
 	rvu_nix_health_reporters_destroy(rvu_dl);
 }
 
+enum rvu_af_dl_param_id {
+	RVU_AF_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	RVU_AF_DEVLINK_PARAM_ID_DWRR_MTU,
+	RVU_AF_DEVLINK_PARAM_ID_TIM_CAPTURE_TIMERS,
+	RVU_AF_DEVLINK_PARAM_ID_TIM_CAPTURE_TENNS,
+	RVU_AF_DEVLINK_PARAM_ID_TIM_CAPTURE_GPIOS,
+	RVU_AF_DEVLINK_PARAM_ID_TIM_CAPTURE_GTI,
+	RVU_AF_DEVLINK_PARAM_ID_TIM_CAPTURE_PTP,
+	RVU_AF_DEVLINK_PARAM_ID_TIM_CAPTURE_SYNC,
+	RVU_AF_DEVLINK_PARAM_ID_TIM_CAPTURE_BTS,
+	RVU_AF_DEVLINK_PARAM_ID_TIM_CAPTURE_EXT_GTI,
+	RVU_AF_DEVLINK_PARAM_ID_TIM_ADJUST_TIMERS,
+	RVU_AF_DEVLINK_PARAM_ID_TIM_ADJUST_TENNS,
+	RVU_AF_DEVLINK_PARAM_ID_TIM_ADJUST_GPIOS,
+	RVU_AF_DEVLINK_PARAM_ID_TIM_ADJUST_GTI,
+	RVU_AF_DEVLINK_PARAM_ID_TIM_ADJUST_PTP,
+	RVU_AF_DEVLINK_PARAM_ID_TIM_ADJUST_BTS,
+};
+
+static u64 rvu_af_dl_tim_param_id_to_offset(u32 id)
+{
+	u64 offset;
+
+	switch (id) {
+	case RVU_AF_DEVLINK_PARAM_ID_TIM_CAPTURE_TENNS:
+		offset = TIM_AF_CAPTURE_TENNS;
+		break;
+	case RVU_AF_DEVLINK_PARAM_ID_TIM_CAPTURE_GPIOS:
+		offset = TIM_AF_CAPTURE_GPIOS;
+		break;
+	case RVU_AF_DEVLINK_PARAM_ID_TIM_CAPTURE_GTI:
+		offset = TIM_AF_CAPTURE_GTI;
+		break;
+	case RVU_AF_DEVLINK_PARAM_ID_TIM_CAPTURE_PTP:
+		offset = TIM_AF_CAPTURE_PTP;
+		break;
+	case RVU_AF_DEVLINK_PARAM_ID_TIM_CAPTURE_BTS:
+		offset = TIM_AF_CAPTURE_BTS;
+		break;
+	case RVU_AF_DEVLINK_PARAM_ID_TIM_CAPTURE_EXT_GTI:
+		offset = TIM_AF_CAPTURE_EXT_GTI;
+		break;
+	case RVU_AF_DEVLINK_PARAM_ID_TIM_ADJUST_TENNS:
+		offset = TIM_AF_ADJUST_TENNS;
+		break;
+	case RVU_AF_DEVLINK_PARAM_ID_TIM_ADJUST_GPIOS:
+		offset = TIM_AF_ADJUST_GPIOS;
+		break;
+	case RVU_AF_DEVLINK_PARAM_ID_TIM_ADJUST_GTI:
+		offset = TIM_AF_ADJUST_GTI;
+		break;
+	case RVU_AF_DEVLINK_PARAM_ID_TIM_ADJUST_PTP:
+		offset = TIM_AF_ADJUST_PTP;
+		break;
+	case RVU_AF_DEVLINK_PARAM_ID_TIM_ADJUST_BTS:
+		offset = TIM_AF_ADJUST_BTS;
+		break;
+	}
+
+	return offset;
+}
+
 /* Devlink Params APIs */
 static int rvu_af_dl_dwrr_mtu_validate(struct devlink *devlink, u32 id,
 				       union devlink_param_value val,
@@ -1433,10 +1495,128 @@ static int rvu_af_dl_dwrr_mtu_get(struct devlink *devlink, u32 id,
 	return 0;
 }
 
-enum rvu_af_dl_param_id {
-	RVU_AF_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
-	RVU_AF_DEVLINK_PARAM_ID_DWRR_MTU,
-};
+static int rvu_af_dl_tim_capture_timers_get(struct devlink *devlink, u32 id,
+					    struct devlink_param_gset_ctx *ctx)
+{
+	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
+	struct rvu *rvu = rvu_dl->rvu;
+	u64 capt_timers = rvu_read64(rvu, BLKADDR_TIM, TIM_AF_CAPTURE_TIMERS);
+
+	ctx->val.vu8 = (u8)(capt_timers & TIM_AF_CAPTURE_TIMERS_MASK);
+
+	return 0;
+}
+
+static int rvu_af_dl_tim_capture_timers_set(struct devlink *devlink, u32 id,
+					    struct devlink_param_gset_ctx *ctx)
+{
+	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
+	struct rvu *rvu = rvu_dl->rvu;
+
+	rvu_write64(rvu, BLKADDR_TIM, TIM_AF_CAPTURE_TIMERS, (u64)ctx->val.vu8);
+
+	return 0;
+}
+
+static int rvu_af_dl_tim_capture_timers_validate(struct devlink *devlink,
+						 u32 id,
+						 union devlink_param_value val,
+						 struct netlink_ext_ack *extack)
+{
+	if (val.vu8 > TIM_AF_CAPTURE_TIMERS_MASK) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Invalid value to set tim capture timers");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int rvu_af_dl_tim_capture_time_get(struct devlink *devlink, u32 id,
+					  struct devlink_param_gset_ctx *ctx)
+{
+	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
+	struct rvu *rvu = rvu_dl->rvu;
+	u64 time, offset;
+
+	offset = rvu_af_dl_tim_param_id_to_offset(id);
+	time = rvu_read64(rvu, BLKADDR_TIM, offset);
+	snprintf(ctx->val.vstr, sizeof(ctx->val.vstr), "%llu", time);
+
+	return 0;
+}
+
+static int rvu_af_dl_tim_adjust_timers_get(struct devlink *devlink, u32 id,
+					   struct devlink_param_gset_ctx *ctx)
+{
+	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
+	struct rvu *rvu = rvu_dl->rvu;
+	u64 adjust_timer = rvu_read64(rvu, BLKADDR_TIM, TIM_AF_ADJUST_TIMERS);
+
+	if (adjust_timer & TIM_AF_ADJUST_TIMERS_MASK)
+		ctx->val.vbool = true;
+	else
+		ctx->val.vbool = false;
+
+	return 0;
+}
+
+static int rvu_af_dl_tim_adjust_timers_set(struct devlink *devlink, u32 id,
+					   struct devlink_param_gset_ctx *ctx)
+{
+	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
+	struct rvu *rvu = rvu_dl->rvu;
+	u64 adjust_timer = ctx->val.vbool ? BIT_ULL(0) : 0;
+
+	rvu_write64(rvu, BLKADDR_TIM, TIM_AF_ADJUST_TIMERS, adjust_timer);
+
+	return 0;
+}
+
+static int rvu_af_dl_tim_adjust_timer_get(struct devlink *devlink, u32 id,
+					  struct devlink_param_gset_ctx *ctx)
+{
+	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
+	struct rvu *rvu = rvu_dl->rvu;
+	u64 offset, delta;
+
+	offset = rvu_af_dl_tim_param_id_to_offset(id);
+	delta = rvu_read64(rvu, BLKADDR_TIM, offset);
+	snprintf(ctx->val.vstr, sizeof(ctx->val.vstr), "%llu", delta);
+
+	return 0;
+}
+
+static int rvu_af_dl_tim_adjust_timer_set(struct devlink *devlink, u32 id,
+					  struct devlink_param_gset_ctx *ctx)
+{
+	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
+	struct rvu *rvu = rvu_dl->rvu;
+	u64 offset, delta;
+
+	if (kstrtoull(ctx->val.vstr, 10, &delta))
+		return -EINVAL;
+
+	offset = rvu_af_dl_tim_param_id_to_offset(id);
+	rvu_write64(rvu, BLKADDR_TIM, offset, delta);
+
+	return 0;
+}
+
+static int rvu_af_dl_tim_adjust_timer_validate(struct devlink *devlink, u32 id,
+					       union devlink_param_value val,
+					       struct netlink_ext_ack *extack)
+{
+	u64 delta;
+
+	if (kstrtoull(val.vstr, 10, &delta)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Invalid value to set tim adjust timer");
+		return -EINVAL;
+	}
+
+	return 0;
+}
 
 static const struct devlink_param rvu_af_dl_params[] = {
 	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_DWRR_MTU,
@@ -1444,6 +1624,75 @@ static const struct devlink_param rvu_af_dl_params[] = {
 			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
 			     rvu_af_dl_dwrr_mtu_get, rvu_af_dl_dwrr_mtu_set,
 			     rvu_af_dl_dwrr_mtu_validate),
+	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_TIM_CAPTURE_TIMERS,
+			     "tim_capture_timers", DEVLINK_PARAM_TYPE_U8,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     rvu_af_dl_tim_capture_timers_get,
+			     rvu_af_dl_tim_capture_timers_set,
+			     rvu_af_dl_tim_capture_timers_validate),
+	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_TIM_CAPTURE_TENNS,
+			     "tim_capture_tenns", DEVLINK_PARAM_TYPE_STRING,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     rvu_af_dl_tim_capture_time_get, NULL, NULL),
+	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_TIM_CAPTURE_GPIOS,
+			     "tim_capture_gpios", DEVLINK_PARAM_TYPE_STRING,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     rvu_af_dl_tim_capture_time_get, NULL, NULL),
+	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_TIM_CAPTURE_GTI,
+			     "tim_capture_gti", DEVLINK_PARAM_TYPE_STRING,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     rvu_af_dl_tim_capture_time_get, NULL, NULL),
+	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_TIM_CAPTURE_PTP,
+			     "tim_capture_ptp", DEVLINK_PARAM_TYPE_STRING,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     rvu_af_dl_tim_capture_time_get, NULL, NULL),
+	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_TIM_CAPTURE_SYNC,
+			     "tim_capture_sync", DEVLINK_PARAM_TYPE_STRING,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     rvu_af_dl_tim_capture_time_get, NULL, NULL),
+	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_TIM_CAPTURE_BTS,
+			     "tim_capture_bts", DEVLINK_PARAM_TYPE_STRING,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     rvu_af_dl_tim_capture_time_get, NULL, NULL),
+	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_TIM_CAPTURE_EXT_GTI,
+			     "tim_capture_ext_gti", DEVLINK_PARAM_TYPE_STRING,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     rvu_af_dl_tim_capture_time_get, NULL, NULL),
+	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_TIM_ADJUST_TIMERS,
+			     "tim_adjust_timers", DEVLINK_PARAM_TYPE_BOOL,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     rvu_af_dl_tim_adjust_timers_get,
+			     rvu_af_dl_tim_adjust_timers_set, NULL),
+	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_TIM_ADJUST_TENNS,
+			     "tim_adjust_tenns", DEVLINK_PARAM_TYPE_STRING,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     rvu_af_dl_tim_adjust_timer_get,
+			     rvu_af_dl_tim_adjust_timer_set,
+			     rvu_af_dl_tim_adjust_timer_validate),
+	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_TIM_ADJUST_GPIOS,
+			     "tim_adjust_gpios", DEVLINK_PARAM_TYPE_STRING,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     rvu_af_dl_tim_adjust_timer_get,
+			     rvu_af_dl_tim_adjust_timer_set,
+			     rvu_af_dl_tim_adjust_timer_validate),
+	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_TIM_ADJUST_GTI,
+			     "tim_adjust_gti", DEVLINK_PARAM_TYPE_STRING,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     rvu_af_dl_tim_adjust_timer_get,
+			     rvu_af_dl_tim_adjust_timer_set,
+			     rvu_af_dl_tim_adjust_timer_validate),
+	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_TIM_ADJUST_PTP,
+			     "tim_adjust_ptp", DEVLINK_PARAM_TYPE_STRING,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     rvu_af_dl_tim_adjust_timer_get,
+			     rvu_af_dl_tim_adjust_timer_set,
+			     rvu_af_dl_tim_adjust_timer_validate),
+	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_TIM_ADJUST_BTS,
+			     "tim_adjust_bts", DEVLINK_PARAM_TYPE_STRING,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     rvu_af_dl_tim_adjust_timer_get,
+			     rvu_af_dl_tim_adjust_timer_set,
+			     rvu_af_dl_tim_adjust_timer_validate),
 };
 
 /* Devlink switch mode */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 22cd751613cd..ad43957b8798 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -456,6 +456,21 @@
 #define TIM_AF_RVU_LF_CFG_DEBUG		(0x30000)
 #define TIM_AF_BLK_RST			(0x10)
 #define TIM_AF_LF_RST			(0x20)
+#define TIM_AF_ADJUST_TENNS		(0x160)
+#define TIM_AF_ADJUST_GPIOS		(0x170)
+#define TIM_AF_ADJUST_GTI		(0x180)
+#define TIM_AF_ADJUST_PTP		(0x190)
+#define TIM_AF_ADJUST_BTS		(0x1B0)
+#define TIM_AF_ADJUST_TIMERS		(0x1C0)
+#define TIM_AF_ADJUST_TIMERS_MASK	BIT_ULL(0)
+#define TIM_AF_CAPTURE_TENNS		(0x1D0)
+#define TIM_AF_CAPTURE_GPIOS		(0x1E0)
+#define TIM_AF_CAPTURE_GTI		(0x1F0)
+#define TIM_AF_CAPTURE_PTP		(0x200)
+#define TIM_AF_CAPTURE_BTS		(0x220)
+#define TIM_AF_CAPTURE_EXT_GTI		(0x240)
+#define TIM_AF_CAPTURE_TIMERS		(0x250)
+#define TIM_AF_CAPTURE_TIMERS_MASK	GENMASK_ULL(1, 0)
 
 /* CPT */
 #define CPT_AF_CONSTANTS0               (0x0000)
-- 
2.25.1

