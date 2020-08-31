Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922F62574FA
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 10:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgHaIJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 04:09:01 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:44196 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726573AbgHaII7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 04:08:59 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 31261FB2EF1CFF7FDF93;
        Mon, 31 Aug 2020 16:08:56 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Mon, 31 Aug 2020
 16:08:49 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <yanaijie@huawei.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] ath6kl: wmi: remove set but not used 'rate'
Date:   Mon, 31 Aug 2020 16:08:24 +0800
Message-ID: <20200831080824.3249197-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This addresses the following gcc warning with "make W=1":

drivers/net/wireless/ath/ath6kl/wmi.c: In function
‘ath6kl_wmi_bitrate_reply_rx’:
drivers/net/wireless/ath/ath6kl/wmi.c:1204:6: warning: variable ‘rate’
set but not used [-Wunused-but-set-variable]
 1204 |  s32 rate;
      |      ^~~~

The variable 'sgi' is alse removed because after 'rate' is removed, it
is not used too.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 6885d2ded53a..a4339cca661f 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1201,8 +1201,7 @@ static int ath6kl_wmi_pstream_timeout_event_rx(struct wmi *wmi, u8 *datap,
 static int ath6kl_wmi_bitrate_reply_rx(struct wmi *wmi, u8 *datap, int len)
 {
 	struct wmi_bit_rate_reply *reply;
-	s32 rate;
-	u32 sgi, index;
+	u32 index;
 
 	if (len < sizeof(struct wmi_bit_rate_reply))
 		return -EINVAL;
@@ -1211,15 +1210,10 @@ static int ath6kl_wmi_bitrate_reply_rx(struct wmi *wmi, u8 *datap, int len)
 
 	ath6kl_dbg(ATH6KL_DBG_WMI, "rateindex %d\n", reply->rate_index);
 
-	if (reply->rate_index == (s8) RATE_AUTO) {
-		rate = RATE_AUTO;
-	} else {
+	if (reply->rate_index != (s8) RATE_AUTO) {
 		index = reply->rate_index & 0x7f;
 		if (WARN_ON_ONCE(index > (RATE_MCS_7_40 + 1)))
 			return -EINVAL;
-
-		sgi = (reply->rate_index & 0x80) ? 1 : 0;
-		rate = wmi_rate_tbl[index][sgi];
 	}
 
 	ath6kl_wakeup_event(wmi->parent_dev);
-- 
2.25.4

