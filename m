Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0085F9092
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbiJIW0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbiJIWYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:24:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCEB73C8E9;
        Sun,  9 Oct 2022 15:18:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41915B80DEF;
        Sun,  9 Oct 2022 22:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DF1C433D6;
        Sun,  9 Oct 2022 22:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353701;
        bh=xtM5s+f3529j7nQlyo4YPIfMABIDOHknGrVRtsueMpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QDl7/rtQyd0GqtZr5Lv9GtDCTQGZAfCP/sx3l56Q2GXPxU35C3azHaQdOY/YVSRTU
         xwZ5GtQ4oxPxI8tuIdeewIBSprfvkikwgvRXjhMI9wa2eGFyD9ptp3Ars4TYQSfgY+
         IuoUWgDCIa45hbdC+OKPAuevSrVytpJgW4oyzIxx/lMHizDfpK61YhIr8d+c8lI85m
         fWGBT3Jq19kgCix0bOsjwsaQzwiKcKnZmECBkyuOeHOAVj06hVoezw4um5+Oho4eRT
         0tCbfdSGacU1qh3adYpsYrCanrhMKfcNUaBCLtotSmFMdFs9SvnP+vHU35avT+w+oF
         zj02yN6D07wPQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zong-Zhe Yang <kevin_yang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        tony0620emma@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 02/73] wifi: rtw88: phy: fix warning of possible buffer overflow
Date:   Sun,  9 Oct 2022 18:13:40 -0400
Message-Id: <20221009221453.1216158-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221453.1216158-1-sashal@kernel.org>
References: <20221009221453.1216158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit 86331c7e0cd819bf0c1d0dcf895e0c90b0aa9a6f ]

reported by smatch

phy.c:854 rtw_phy_linear_2_db() error: buffer overflow 'db_invert_table[i]'
8 <= 8 (assuming for loop doesn't break)

However, it seems to be a false alarm because we prevent it originally via
       if (linear >= db_invert_table[11][7])
               return 96; /* maximum 96 dB */

Still, we adjust the code to be more readable and avoid smatch warning.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220727065003.28340-5-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/phy.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
index 8982e0c98dac..da1efec0aa85 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -816,23 +816,18 @@ static u8 rtw_phy_linear_2_db(u64 linear)
 	u8 j;
 	u32 dB;
 
-	if (linear >= db_invert_table[11][7])
-		return 96; /* maximum 96 dB */
-
 	for (i = 0; i < 12; i++) {
-		if (i <= 2 && (linear << FRAC_BITS) <= db_invert_table[i][7])
-			break;
-		else if (i > 2 && linear <= db_invert_table[i][7])
-			break;
+		for (j = 0; j < 8; j++) {
+			if (i <= 2 && (linear << FRAC_BITS) <= db_invert_table[i][j])
+				goto cnt;
+			else if (i > 2 && linear <= db_invert_table[i][j])
+				goto cnt;
+		}
 	}
 
-	for (j = 0; j < 8; j++) {
-		if (i <= 2 && (linear << FRAC_BITS) <= db_invert_table[i][j])
-			break;
-		else if (i > 2 && linear <= db_invert_table[i][j])
-			break;
-	}
+	return 96; /* maximum 96 dB */
 
+cnt:
 	if (j == 0 && i == 0)
 		goto end;
 
-- 
2.35.1

