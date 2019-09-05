Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8222AAA8F4
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 18:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732831AbfIEQ1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 12:27:15 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:46374 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729136AbfIEQ1P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 12:27:15 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 60E7CD4EAD94FA4432E6;
        Fri,  6 Sep 2019 00:27:11 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Fri, 6 Sep 2019 00:27:03 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <kvalo@codeaurora.org>
CC:     <davem@davemloft.net>, <zhongjiang@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] brcmsmac: Use DIV_ROUND_CLOSEST directly to make it readable
Date:   Fri, 6 Sep 2019 00:24:08 +0800
Message-ID: <1567700648-28162-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel.h macro DIV_ROUND_CLOSEST performs the computation (x + d/2)/d
but is perhaps more readable.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 .../net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c   | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
index 07f61d6..3bf152d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
@@ -17748,7 +17748,7 @@ static void wlc_phy_txpwrctrl_pwr_setup_nphy(struct brcms_phy *pi)
 			num = 8 *
 			      (16 * b0[tbl_id - 26] + b1[tbl_id - 26] * idx);
 			den = 32768 + a1[tbl_id - 26] * idx;
-			pwr_est = max(((4 * num + den / 2) / den), -8);
+			pwr_est = max(DIV_ROUND_CLOSEST(4 * num, den), -8);
 			if (NREV_LT(pi->pubpi.phy_rev, 3)) {
 				if (idx <=
 				    (uint) (31 - idle_tssi[tbl_id - 26] + 1))
@@ -26990,8 +26990,8 @@ static void wlc_phy_rxcal_phycleanup_nphy(struct brcms_phy *pi, u8 rx_core)
 				     NPHY_RXCAL_TONEAMP, 0, cal_type, false);
 
 		wlc_phy_rx_iq_est_nphy(pi, est, num_samps, 32, 0);
-		i_pwr = (est[rx_core].i_pwr + num_samps / 2) / num_samps;
-		q_pwr = (est[rx_core].q_pwr + num_samps / 2) / num_samps;
+		i_pwr = DIV_ROUND_CLOSEST(est[rx_core].i_pwr, num_samps);
+		q_pwr = DIV_ROUND_CLOSEST(est[rx_core].q_pwr, num_samps);
 		curr_pwr = i_pwr + q_pwr;
 
 		switch (gainctrl_dirn) {
@@ -27673,10 +27673,10 @@ static int wlc_phy_cal_rxiq_nphy_rev3(struct brcms_phy *pi,
 					wlc_phy_rx_iq_est_nphy(pi, est,
 							       num_samps, 32,
 							       0);
-					i_pwr =	(est[rx_core].i_pwr +
-						 num_samps / 2) / num_samps;
-					q_pwr =	(est[rx_core].q_pwr +
-						 num_samps / 2) / num_samps;
+					i_pwr = DIV_ROUND_CLOSEST(est[rx_core].i_pwr,
+									 num_samps);
+					q_pwr = DIV_ROUND_CLOSEST(est[rx_core].q_pwr,
+									 num_samps);
 					tot_pwr[gain_pass] = i_pwr + q_pwr;
 				} else {
 
-- 
1.7.12.4

