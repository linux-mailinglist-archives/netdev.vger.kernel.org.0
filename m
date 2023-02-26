Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4925B6A311F
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 15:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbjBZO4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 09:56:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbjBZOzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 09:55:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08E31B310;
        Sun, 26 Feb 2023 06:51:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A94760C5E;
        Sun, 26 Feb 2023 14:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62801C433D2;
        Sun, 26 Feb 2023 14:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422907;
        bh=YUGhHv54G1+XRv+xazR/2/VBbiQRmwCCo5vKPzJsHYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DAjHSzKmIseAuCDgem45S0WENXvpmHvNk5+UfhKFgp7QbDLE/z97k+DbzS10gdXSS
         cjaex2secqg/O9AVTcRb3yNnpkQOXcNFwH6Lshv2BVqbWjUKVBmFS4L7khBVHcrj0K
         5MWLfAYGp6i2HsdCdL52dbuCx1WZedtmA4wJXMNs/a+7WFfAgqzNzOtmky0LFLrzBA
         RekjaDHQ9qlBjmLvcr3p5ytLqwBQR2FeILEeinCvmyb7ofZLovbwIIqblx6i/vKZkA
         O9R9zdgZRAgrcdNZK4N6DxGEofmZ/Ay5MvQzS4lfUBTv2PgHxtumlkOwXnJ7ev8VFz
         Js/+dQI+jYrgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zong-Zhe Yang <kevin_yang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 44/49] wifi: rtw89: debug: avoid invalid access on RTW89_DBG_SEL_MAC_30
Date:   Sun, 26 Feb 2023 09:46:44 -0500
Message-Id: <20230226144650.826470-44-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144650.826470-1-sashal@kernel.org>
References: <20230226144650.826470-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit c074da21dd346e0cfef5d08b0715078d7aea7f8d ]

Only 8852C chip has valid pages on RTW89_DBG_SEL_MAC_30. To other chips,
this section is an address hole. It will lead to crash if trying to access
this section on chips except for 8852C. So, we avoid that.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230119063529.61563-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/debug.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/debug.c b/drivers/net/wireless/realtek/rtw89/debug.c
index 730e83d54257f..50701c55ed602 100644
--- a/drivers/net/wireless/realtek/rtw89/debug.c
+++ b/drivers/net/wireless/realtek/rtw89/debug.c
@@ -594,6 +594,7 @@ rtw89_debug_priv_mac_reg_dump_select(struct file *filp,
 	struct seq_file *m = (struct seq_file *)filp->private_data;
 	struct rtw89_debugfs_priv *debugfs_priv = m->private;
 	struct rtw89_dev *rtwdev = debugfs_priv->rtwdev;
+	const struct rtw89_chip_info *chip = rtwdev->chip;
 	char buf[32];
 	size_t buf_size;
 	int sel;
@@ -613,6 +614,12 @@ rtw89_debug_priv_mac_reg_dump_select(struct file *filp,
 		return -EINVAL;
 	}
 
+	if (sel == RTW89_DBG_SEL_MAC_30 && chip->chip_id != RTL8852C) {
+		rtw89_info(rtwdev, "sel %d is address hole on chip %d\n", sel,
+			   chip->chip_id);
+		return -EINVAL;
+	}
+
 	debugfs_priv->cb_data = sel;
 	rtw89_info(rtwdev, "select mac page dump %d\n", debugfs_priv->cb_data);
 
-- 
2.39.0

