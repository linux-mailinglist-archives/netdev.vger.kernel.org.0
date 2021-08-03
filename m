Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426CE3DF0B3
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235674AbhHCOuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:50:07 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:55850
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235368AbhHCOuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 10:50:02 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 7AEE73F0FF;
        Tue,  3 Aug 2021 14:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628002190;
        bh=OSXLs7UOCDaUH/Z2FsCqFS59Zra8YYCA6HkdQfm7sZs=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Type;
        b=Hg+RoLzmfw1V6/+4j87RoskXSf8QvgpdifyL0u9L6WCu0Dfd1NG/wkWZcAdNsIoZM
         /be4sQu/GOR8IZgQn+aZb+Ni6oDufNdQ0pEnm9lSLk1Noje3T6yKt1yZi0jSbS1GNs
         Lr0iwTqtN/uPqcdlxTEd3ZZQ6mb59ctSeEqW4DCw0NtLr0QP93gCC2Px8QZquLs5t3
         u7Cc45+7pyX+rdTKNGtaWG84QP1Di6JwoKWTDNfZ7CNAL9i3CGMPzsGPDI+Z/3BwRZ
         WUAsCd//Q67GcvTbZY9VzC6/nUPUukrmECBHp7wYVW8Lb2HRbnCsTg5Q5PNGMWzzup
         5K+PqEdEtF2mQ==
From:   Colin King <colin.king@canonical.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] rtlwifi: rtl8192de: fix array size limit in for-loop
Date:   Tue,  3 Aug 2021 15:49:49 +0100
Message-Id: <20210803144949.79433-3-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803144949.79433-1-colin.king@canonical.com>
References: <20210803144949.79433-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the size of the entire array is being used in a for-loop
for the element count. While this works since the elements are u8
sized, it is preferred to use ARRAY_SIZE to get the element count
of the array.

Kudos to Joe Perches for spotting this issue.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index 8ae69d914312..e11728622a9e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -1366,7 +1366,7 @@ u8 rtl92d_get_rightchnlplace_for_iqk(u8 chnl)
 	u8 place = chnl;
 
 	if (chnl > 14) {
-		for (place = 14; place < sizeof(channel_all); place++) {
+		for (place = 14; place < ARRAY_SIZE(channel_all); place++) {
 			if (channel_all[place] == chnl)
 				return place - 13;
 		}
-- 
2.31.1

