Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46DA31D38F5
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 20:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgENSNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 14:13:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51299 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgENSNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 14:13:38 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jZIML-0002uD-Qq; Thu, 14 May 2020 18:13:29 +0000
From:   Colin King <colin.king@canonical.com>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] rtw88: 8723d: fix incorrect setting of ldo_pwr
Date:   Thu, 14 May 2020 19:13:29 +0100
Message-Id: <20200514181329.16292-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently ldo_pwr has the LDO25 voltage bits set to zero and then
it is overwritten with the new voltage setting. The assignment
looks incorrect, it should be bit-wise or'ing in the new voltage
setting rather than a direct assignment.

Addresses-Coverity: ("Unused value")
Fixes: 1afb5eb7a00d ("rtw88: 8723d: Add cfg_ldo25 to control LDO25")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8723d.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723d.c b/drivers/net/wireless/realtek/rtw88/rtw8723d.c
index b517af417e0e..2c6e417c5bca 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8723d.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723d.c
@@ -561,7 +561,7 @@ static void rtw8723d_cfg_ldo25(struct rtw_dev *rtwdev, bool enable)
 	ldo_pwr = rtw_read8(rtwdev, REG_LDO_EFUSE_CTRL + 3);
 	if (enable) {
 		ldo_pwr &= ~BIT_MASK_LDO25_VOLTAGE;
-		ldo_pwr = (BIT_LDO25_VOLTAGE_V25 << 4) | BIT_LDO25_EN;
+		ldo_pwr |= (BIT_LDO25_VOLTAGE_V25 << 4) | BIT_LDO25_EN;
 	} else {
 		ldo_pwr &= ~BIT_LDO25_EN;
 	}
-- 
2.25.1

