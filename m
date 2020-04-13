Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85D061A63E4
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 09:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729565AbgDMHzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 03:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:37538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727480AbgDMHzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 03:55:09 -0400
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9F7C008651;
        Mon, 13 Apr 2020 00:55:09 -0700 (PDT)
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BFA22D2CD8AEAA9D66FB;
        Mon, 13 Apr 2020 15:55:07 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Mon, 13 Apr 2020
 15:54:58 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <yanaijie@huawei.com>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] brcmsmac: make brcms_c_stf_ss_update() void
Date:   Mon, 13 Apr 2020 16:21:26 +0800
Message-ID: <20200413082126.22572-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.c:309:5-13:
Unneeded variable: "ret_code". Return "0" on line 328

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.c | 7 ++-----
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.h | 2 +-
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.c
index 0ab865de1491..79d4a7a4da8b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.c
@@ -304,9 +304,8 @@ int brcms_c_stf_txchain_set(struct brcms_c_info *wlc, s32 int_val, bool force)
  * update wlc->stf->ss_opmode which represents the operational stf_ss mode
  * we're using
  */
-int brcms_c_stf_ss_update(struct brcms_c_info *wlc, struct brcms_band *band)
+void brcms_c_stf_ss_update(struct brcms_c_info *wlc, struct brcms_band *band)
 {
-	int ret_code = 0;
 	u8 prev_stf_ss;
 	u8 upd_stf_ss;
 
@@ -325,7 +324,7 @@ int brcms_c_stf_ss_update(struct brcms_c_info *wlc, struct brcms_band *band)
 				    PHY_TXC1_MODE_SISO : PHY_TXC1_MODE_CDD;
 	} else {
 		if (wlc->band != band)
-			return ret_code;
+			return;
 		upd_stf_ss = (wlc->stf->txstreams == 1) ?
 				PHY_TXC1_MODE_SISO : band->band_stf_ss_mode;
 	}
@@ -333,8 +332,6 @@ int brcms_c_stf_ss_update(struct brcms_c_info *wlc, struct brcms_band *band)
 		wlc->stf->ss_opmode = upd_stf_ss;
 		brcms_b_band_stf_ss_set(wlc->hw, upd_stf_ss);
 	}
-
-	return ret_code;
 }
 
 int brcms_c_stf_attach(struct brcms_c_info *wlc)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.h
index ba9493009a33..aa4ab53bf634 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.h
@@ -25,7 +25,7 @@ void brcms_c_stf_detach(struct brcms_c_info *wlc);
 void brcms_c_tempsense_upd(struct brcms_c_info *wlc);
 void brcms_c_stf_ss_algo_channel_get(struct brcms_c_info *wlc,
 				     u16 *ss_algo_channel, u16 chanspec);
-int brcms_c_stf_ss_update(struct brcms_c_info *wlc, struct brcms_band *band);
+void brcms_c_stf_ss_update(struct brcms_c_info *wlc, struct brcms_band *band);
 void brcms_c_stf_phy_txant_upd(struct brcms_c_info *wlc);
 int brcms_c_stf_txchain_set(struct brcms_c_info *wlc, s32 int_val, bool force);
 bool brcms_c_stf_stbc_rx_set(struct brcms_c_info *wlc, s32 int_val);
-- 
2.21.1

