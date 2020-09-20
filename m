Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D319727147F
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 15:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgITN0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 09:26:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:35488 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbgITN0Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 09:26:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4E375ADA8;
        Sun, 20 Sep 2020 13:26:59 +0000 (UTC)
From:   =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Cc:     Chin-Yen Lee <timlee@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-realtek-soc@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
Subject: [PATCH 2/2] rtw88: Fix potential probe error handling race with wow firmware loading
Date:   Sun, 20 Sep 2020 15:26:21 +0200
Message-Id: <20200920132621.26468-3-afaerber@suse.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200920132621.26468-1-afaerber@suse.de>
References: <20200920132621.26468-1-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If rtw_core_init() fails to load the wow firmware, rtw_core_deinit()
will not get called to clean up the regular firmware.

Ensure that an error loading the wow firmware does not produce an oops
for the regular firmware by waiting on its completion to be signalled
before returning. Also release the loaded firmware.

Fixes: c8e5695eae99 ("rtw88: load wowlan firmware if wowlan is supported")
Cc: Chin-Yen Lee <timlee@realtek.com>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 drivers/net/wireless/realtek/rtw88/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index dc48ec4b0a31..cc82c80f0433 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1472,6 +1472,9 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 		ret = rtw_load_firmware(rtwdev, RTW_WOWLAN_FW);
 		if (ret) {
 			rtw_warn(rtwdev, "no wow firmware loaded\n");
+			wait_for_completion(&rtwdev->fw.completion);
+			if (rtwdev->fw.firmware)
+				release_firmware(rtwdev->fw.firmware);
 			return ret;
 		}
 	}
-- 
2.28.0

