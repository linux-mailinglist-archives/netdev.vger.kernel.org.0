Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70DA5404FD0
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353243AbhIIMWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:22:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350878AbhIIMSM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:18:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09D9861A8D;
        Thu,  9 Sep 2021 11:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188207;
        bh=PkHgKvoyfPY4SUoPcVWWAVmKs/676bv9UplHgoqlefg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=acJ/PVE14ngM6i01wq1GQ9af6M7f/aRgpTj9geCronkXumSHmwXFpTudQRjwQkEeB
         iW4IUb6wcTYJq9qiV6DAkfArcHiIVyL0P4GN86McIrmOSDHsfJ+SrxWwb8MR+hjdw+
         xRBTfQeWRgoYSF1wKIZa43jKPniIicztriWcNoSMlvytgDt54EqlnQQTU9yBNUAWVc
         79flkkIsf9H5kWTvcVMR39rZj+woGJsKIplkUgoJ4E7je8yQB19iXWRHdz8XYcaBAX
         Jt9VtpiW4mWaNXdAqiBKp8WBCjLJem02x2n8xHK8UrZJd1uh5BFhsqEMLPJAskvTjE
         +CKx/tCblV/xQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chin-Yen Lee <timlee@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 164/219] rtw88: use read_poll_timeout instead of fixed sleep
Date:   Thu,  9 Sep 2021 07:45:40 -0400
Message-Id: <20210909114635.143983-164-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chin-Yen Lee <timlee@realtek.com>

[ Upstream commit 02a55c0009a55b204e1e5c17295431f0a9e7d3b6 ]

In current wow flow, driver calls rtw_wow_fw_start and sleep for 100ms,
to wait firmware finish preliminary work and then update the value of
WOWLAN_WAKE_REASON register to zero. But later firmware will start wow
function with power-saving mode, in which mode the value of
WOWLAN_WAKE_REASON register is 0xea. So driver may get 0xea value and
return fail. We use read_poll_timeout instead to check the value to avoid
this issue.

Signed-off-by: Chin-Yen Lee <timlee@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210728014335.8785-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/wow.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/wow.c b/drivers/net/wireless/realtek/rtw88/wow.c
index fc9544f4e5e4..bdccfa70dddc 100644
--- a/drivers/net/wireless/realtek/rtw88/wow.c
+++ b/drivers/net/wireless/realtek/rtw88/wow.c
@@ -283,15 +283,26 @@ static void rtw_wow_rx_dma_start(struct rtw_dev *rtwdev)
 
 static int rtw_wow_check_fw_status(struct rtw_dev *rtwdev, bool wow_enable)
 {
-	/* wait 100ms for wow firmware to finish work */
-	msleep(100);
+	int ret;
+	u8 check;
+	u32 check_dis;
 
 	if (wow_enable) {
-		if (rtw_read8(rtwdev, REG_WOWLAN_WAKE_REASON))
+		ret = read_poll_timeout(rtw_read8, check, !check, 1000,
+					100000, true, rtwdev,
+					REG_WOWLAN_WAKE_REASON);
+		if (ret)
 			goto wow_fail;
 	} else {
-		if (rtw_read32_mask(rtwdev, REG_FE1IMR, BIT_FS_RXDONE) ||
-		    rtw_read32_mask(rtwdev, REG_RXPKT_NUM, BIT_RW_RELEASE))
+		ret = read_poll_timeout(rtw_read32_mask, check_dis,
+					!check_dis, 1000, 100000, true, rtwdev,
+					REG_FE1IMR, BIT_FS_RXDONE);
+		if (ret)
+			goto wow_fail;
+		ret = read_poll_timeout(rtw_read32_mask, check_dis,
+					!check_dis, 1000, 100000, false, rtwdev,
+					REG_RXPKT_NUM, BIT_RW_RELEASE);
+		if (ret)
 			goto wow_fail;
 	}
 
-- 
2.30.2

