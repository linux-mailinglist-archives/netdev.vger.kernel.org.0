Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7FD229FE4
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 21:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732493AbgGVTKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 15:10:14 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:48290 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732246AbgGVTKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 15:10:13 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MJ7H7f029263;
        Wed, 22 Jul 2020 12:10:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0818; bh=XJE/qUeMtzzLJdHsiberOEjLSsuJ5PtwBabaRqkvDTQ=;
 b=bZ7eri1jHfx/jKORhfaF4mtENsyJ2ztMsYM9H5y3Gqgv3dgKPZxtFo6dElQSF9wHi1Lo
 BojUwm+EV9xozez9MJuJPOaEYcLSOQRwdbLvyz2zbqv06zUvn/lkTZLWKYvpzst9733Y
 qkVSGQSdmNA7+NbkEKQjGEqNLblIP9TcmlzU0aRD2oI7pGBBwEhF9NUadOcPQXTO00O/
 ttlz0WXMm9Sl+jqRv3K7L8+F24RLw8ViW/uFjZ8xytGobiYsNNpgfDJxjT8mKt5ftngq
 mkNxjFyvN9aMY6jA8EMljSSrGUfV9BSWSnWG1Y4V7hDP3UTrrXrK4dDUdECLtX9ev3c5 hA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 32bxenta2g-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 12:10:11 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 12:10:09 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 12:10:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jul 2020 12:10:08 -0700
Received: from NN-LT0044.marvell.com (NN-LT0044.marvell.com [10.193.54.8])
        by maili.marvell.com (Postfix) with ESMTP id D6DCE3F7043;
        Wed, 22 Jul 2020 12:10:06 -0700 (PDT)
From:   Mark Starovoytov <mstarovoitov@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>, <netdev@vger.kernel.org>,
        "Egor Pomozov" <epomozov@marvell.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>
Subject: [PATCH net] net: atlantic: fix PTP on AQC10X
Date:   Wed, 22 Jul 2020 22:09:58 +0300
Message-ID: <20200722190958.12645-1-mstarovoitov@marvell.com>
X-Mailer: git-send-email 2.26.2.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_10:2020-07-22,2020-07-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Egor Pomozov <epomozov@marvell.com>

This patch fixes PTP on AQC10X.
PTP support on AQC10X requires FW involvement and FW configures the
TPS data arb mode itself.
So we must make sure driver doesn't touch TPS data arb mode on AQC10x
if PTP is enabled. Otherwise, there are no timestamps even though
packets are flowing.

Fixes: 2deac71ac492a ("net: atlantic: QoS implementation: min_rate")
Signed-off-by: Egor Pomozov <epomozov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 14d79f70cad7..135c27ec7c6a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -354,8 +354,13 @@ static int hw_atl_b0_hw_init_tx_tc_rate_limit(struct aq_hw_s *self)
 
 	/* WSP, if min_rate is set for at least one TC.
 	 * RR otherwise.
+	 *
+	 * NB! MAC FW sets arb mode itself if PTP is enabled. We shouldn't
+	 * overwrite it here in that case.
 	 */
-	hw_atl_tps_tx_pkt_shed_data_arb_mode_set(self, min_rate_msk ? 1U : 0U);
+	if (!nic_cfg->is_ptp)
+		hw_atl_tps_tx_pkt_shed_data_arb_mode_set(self, min_rate_msk ? 1U : 0U);
+
 	/* Data TC Arbiter takes precedence over Descriptor TC Arbiter,
 	 * leave Descriptor TC Arbiter as RR.
 	 */
-- 
2.25.1

