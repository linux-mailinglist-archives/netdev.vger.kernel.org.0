Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C245A5F905E
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbiJIWYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbiJIWXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:23:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E2227FC6;
        Sun,  9 Oct 2022 15:17:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25E6F60CA0;
        Sun,  9 Oct 2022 22:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A443C433D7;
        Sun,  9 Oct 2022 22:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353848;
        bh=f2P4qW12vwATxExY6+WR4wROaknevNhDDR2RJccBt28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pK8EsHwJXUJcg9YWuBB9pCOGtegZaypjNlVrQTqn73BjMk5Ey6ohNJSTVUzemRV6j
         Q11AMDg19+Oy5+b0K+8Xv4Unud0+xtKN8F0MrLU6vHJgWMUXkBxr8FvTBuD1CMRmOr
         E1GfopA+wOiL/Ux9vi77G9kqtKZVn6PKpTnATt7DV7DJb3M3s+DHWuEaen5ORt+aL2
         wMpTUa6IV0mhU6f5xfy80Y9cFsrK/PyQguZAcI5hY0r15AOh9uoLpjmuFe3MgEAsb1
         sGAYOcJx3+YHCyYDefikQ6k5qd+VTZ5ROeP9T3NgWQWkpdU60Z7yvTEuoP3h6Zkome
         nSy0KXCTdmzcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Po-Hao Huang <phhuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 40/73] wifi: rtw89: fix rx filter after scan
Date:   Sun,  9 Oct 2022 18:14:18 -0400
Message-Id: <20221009221453.1216158-40-sashal@kernel.org>
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

From: Po-Hao Huang <phhuang@realtek.com>

[ Upstream commit 812825c2b204c491f1a5586c602e4ac75060493a ]

In monitor mode we should be able to received all packets even if it's not
destined to us. But after scan, the configuration was wrongly set, so we
fix it.

Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220916033811.13862-7-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 4718aced1428..e7f86d84d91d 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -2288,6 +2288,7 @@ void rtw89_hw_scan_start(struct rtw89_dev *rtwdev, struct ieee80211_vif *vif,
 {
 	struct rtw89_vif *rtwvif = (struct rtw89_vif *)vif->drv_priv;
 	struct cfg80211_scan_request *req = &scan_req->req;
+	u32 rx_fltr = rtwdev->hal.rx_fltr;
 	u8 mac_addr[ETH_ALEN];
 
 	rtwdev->scan_info.scanning_vif = vif;
@@ -2302,13 +2303,13 @@ void rtw89_hw_scan_start(struct rtw89_dev *rtwdev, struct ieee80211_vif *vif,
 		ether_addr_copy(mac_addr, vif->addr);
 	rtw89_core_scan_start(rtwdev, rtwvif, mac_addr, true);
 
-	rtwdev->hal.rx_fltr &= ~B_AX_A_BCN_CHK_EN;
-	rtwdev->hal.rx_fltr &= ~B_AX_A_BC;
-	rtwdev->hal.rx_fltr &= ~B_AX_A_A1_MATCH;
+	rx_fltr &= ~B_AX_A_BCN_CHK_EN;
+	rx_fltr &= ~B_AX_A_BC;
+	rx_fltr &= ~B_AX_A_A1_MATCH;
 	rtw89_write32_mask(rtwdev,
 			   rtw89_mac_reg_by_idx(R_AX_RX_FLTR_OPT, RTW89_MAC_0),
 			   B_AX_RX_FLTR_CFG_MASK,
-			   rtwdev->hal.rx_fltr);
+			   rx_fltr);
 }
 
 void rtw89_hw_scan_complete(struct rtw89_dev *rtwdev, struct ieee80211_vif *vif,
@@ -2322,9 +2323,6 @@ void rtw89_hw_scan_complete(struct rtw89_dev *rtwdev, struct ieee80211_vif *vif,
 	if (!vif)
 		return;
 
-	rtwdev->hal.rx_fltr |= B_AX_A_BCN_CHK_EN;
-	rtwdev->hal.rx_fltr |= B_AX_A_BC;
-	rtwdev->hal.rx_fltr |= B_AX_A_A1_MATCH;
 	rtw89_write32_mask(rtwdev,
 			   rtw89_mac_reg_by_idx(R_AX_RX_FLTR_OPT, RTW89_MAC_0),
 			   B_AX_RX_FLTR_CFG_MASK,
-- 
2.35.1

