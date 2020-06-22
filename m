Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086A82035A5
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 13:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728782AbgFVLZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 07:25:35 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60092 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728101AbgFVLOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 07:14:45 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MB8QWE013162;
        Mon, 22 Jun 2020 04:14:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=WZHlnCSUOi3L2ZMRIAhLFsDjHiKktwSh3Zm00zWEO3s=;
 b=M+b2Im0H0Yz1mPCECwGnZuobiU7MNDtpScWXSvS2IOEFGtwv38VT/2iRZWoMaCnMvoUV
 Y79sqlsE7AFWjK53DRADh2XjKn5k5qykvz909p8isZy1Cyd/iHFcUE9FLO+d543RZFoQ
 pXNu9UOgrDoXANYuDdxL/uSXsKB4ZY2UibjKWbtSTU+ETE8zVJqJxskrcPiNTv3dmC53
 wvzHVGQGdbBVeNkZxLeadz+XAfCik0OB3liz3iysALEGyByBDtmw1uFdjRoUYytp9lkH
 C234mzkwI50XHiXGCL3swQRQjgWjXIWMb/Yq8ynp/+0VE+PGACqqQVFzTlZa/mBaSSW6 qw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 31shynqpav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 04:14:41 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Jun
 2020 04:14:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Jun 2020 04:14:39 -0700
Received: from NN-LT0049.marvell.com (unknown [10.193.39.36])
        by maili.marvell.com (Postfix) with ESMTP id CA3BF3F703F;
        Mon, 22 Jun 2020 04:14:35 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Yuval Mintz <yuval.mintz@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "Ram Amrani" <ram.amrani@marvell.com>,
        Tomer Tayar <tomer.tayar@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 4/9] net: qed: fix NVMe login fails over VFs
Date:   Mon, 22 Jun 2020 14:14:08 +0300
Message-ID: <20200622111413.7006-5-alobakin@marvell.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200622111413.7006-1-alobakin@marvell.com>
References: <20200622111413.7006-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_04:2020-06-22,2020-06-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

25ms sleep cycles in waiting for PF response are excessive and may lead
to different timeout failures.

Start to wait with short udelays, and in most cases polling will end
here. If the time was not sufficient, switch to msleeps.
usleep_range() may go far beyond 100us depending on platform and tick
configuration, hence atomic udelays for consistency.

Also add explicit DMA barriers since 'done' always comes from a shared
request-response DMA pool, and note that in the comment nearby.

Fixes: 1408cc1fa48c ("qed: Introduce VFs")
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_vf.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_vf.c b/drivers/net/ethernet/qlogic/qed/qed_vf.c
index 856051f50eb7..adc2c8f3d48e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_vf.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_vf.c
@@ -81,12 +81,17 @@ static void qed_vf_pf_req_end(struct qed_hwfn *p_hwfn, int req_status)
 	mutex_unlock(&(p_hwfn->vf_iov_info->mutex));
 }
 
+#define QED_VF_CHANNEL_USLEEP_ITERATIONS	90
+#define QED_VF_CHANNEL_USLEEP_DELAY		100
+#define QED_VF_CHANNEL_MSLEEP_ITERATIONS	10
+#define QED_VF_CHANNEL_MSLEEP_DELAY		25
+
 static int qed_send_msg2pf(struct qed_hwfn *p_hwfn, u8 *done, u32 resp_size)
 {
 	union vfpf_tlvs *p_req = p_hwfn->vf_iov_info->vf2pf_request;
 	struct ustorm_trigger_vf_zone trigger;
 	struct ustorm_vf_zone *zone_data;
-	int rc = 0, time = 100;
+	int iter, rc = 0;
 
 	zone_data = (struct ustorm_vf_zone *)PXP_VF_BAR0_START_USDM_ZONE_B;
 
@@ -126,11 +131,19 @@ static int qed_send_msg2pf(struct qed_hwfn *p_hwfn, u8 *done, u32 resp_size)
 	REG_WR(p_hwfn, (uintptr_t)&zone_data->trigger, *((u32 *)&trigger));
 
 	/* When PF would be done with the response, it would write back to the
-	 * `done' address. Poll until then.
+	 * `done' address from a coherent DMA zone. Poll until then.
 	 */
-	while ((!*done) && time) {
-		msleep(25);
-		time--;
+
+	iter = QED_VF_CHANNEL_USLEEP_ITERATIONS;
+	while (!*done && iter--) {
+		udelay(QED_VF_CHANNEL_USLEEP_DELAY);
+		dma_rmb();
+	}
+
+	iter = QED_VF_CHANNEL_MSLEEP_ITERATIONS;
+	while (!*done && iter--) {
+		msleep(QED_VF_CHANNEL_MSLEEP_DELAY);
+		dma_rmb();
 	}
 
 	if (!*done) {
-- 
2.21.0

