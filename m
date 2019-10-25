Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACE1E4C69
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 15:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504804AbfJYNiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 09:38:13 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5187 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726285AbfJYNiM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 09:38:12 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 32A4A9A46F113C00024D;
        Fri, 25 Oct 2019 21:38:07 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Fri, 25 Oct 2019
 21:37:56 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <epomozov@marvell.com>, <igor.russkikh@aquantia.com>,
        <davem@davemloft.net>, <dmitry.bezrukov@aquantia.com>,
        <sergey.samoilenko@aquantia.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: aquantia: Fix build error wihtout CONFIG_PTP_1588_CLOCK
Date:   Fri, 25 Oct 2019 21:37:26 +0800
Message-ID: <20191025133726.31796-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If PTP_1588_CLOCK is n, building fails:

drivers/net/ethernet/aquantia/atlantic/aq_ptp.c: In function aq_ptp_adjfine:
drivers/net/ethernet/aquantia/atlantic/aq_ptp.c:279:11:
 error: implicit declaration of function scaled_ppm_to_ppb [-Werror=implicit-function-declaration]
           scaled_ppm_to_ppb(scaled_ppm));

Just cp scaled_ppm_to_ppb() from ptp_clock.c to fix this.

Fixes: 910479a9f793 ("net: aquantia: add basic ptp_clock callbacks")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ptp.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
index 3ec0841..80c001d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -262,6 +262,26 @@ static void aq_ptp_tx_timeout_check(struct aq_ptp_s *aq_ptp)
 	}
 }
 
+static s32 scaled_ppm_to_ppb(long ppm)
+{
+	/*
+	 * The 'freq' field in the 'struct timex' is in parts per
+	 * million, but with a 16 bit binary fractional field.
+	 *
+	 * We want to calculate
+	 *
+	 *    ppb = scaled_ppm * 1000 / 2^16
+	 *
+	 * which simplifies to
+	 *
+	 *    ppb = scaled_ppm * 125 / 2^13
+	 */
+	s64 ppb = 1 + ppm;
+	ppb *= 125;
+	ppb >>= 13;
+	return (s32) ppb;
+}
+
 /* aq_ptp_adjfine
  * @ptp: the ptp clock structure
  * @ppb: parts per billion adjustment from base
-- 
2.7.4


