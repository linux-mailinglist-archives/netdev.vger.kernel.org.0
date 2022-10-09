Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8CA5F9210
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbiJIWov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbiJIWn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:43:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0A44333C;
        Sun,  9 Oct 2022 15:22:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD86AB80DDC;
        Sun,  9 Oct 2022 22:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EF0C433C1;
        Sun,  9 Oct 2022 22:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354092;
        bh=tsIbGN8bM3wlp2iJRSm//9ie7hNncGa0aREaO2RU/As=;
        h=From:To:Cc:Subject:Date:From;
        b=HfJKReIdA9w1eKeQGKbWoj0IZuWJ5XPlzV9fJLfDIgLSvpeZmRy7+RiOF9HWby3+9
         L7+akKvXpvmlXY1ROFQAovnKUF1M2QtfRe6FHkix2CUSNiFedp3Wfk1mH62oXFW+Vw
         PUIoaFfxnKzaE8MABJiYB5lMtX9W267ulvhwtmgyM/GE35t+XrS24Rys/86sMB91We
         bnpioGf+nFStW62K9EBX1rvX1p/fKmWkwDX+ozRrgkr0hcIK5VhBEqv3uKmFwwtjy1
         Vm3iAFEqZzKuPLeot3JG7oLGbG/KUXrFEL8BDzhRWpzRlmVAknK44TlQb5r8wJiB+d
         fUElXA3i+ipaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zong-Zhe Yang <kevin_yang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        tony0620emma@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 01/34] wifi: rtw88: phy: fix warning of possible buffer overflow
Date:   Sun,  9 Oct 2022 18:20:55 -0400
Message-Id: <20221009222129.1218277-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
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
index af8b703d11d4..0fc5a893c395 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -604,23 +604,18 @@ static u8 rtw_phy_linear_2_db(u64 linear)
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

