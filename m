Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0123F119338
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbfLJVID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:08:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:54918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727742AbfLJVIB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:08:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F013924697;
        Tue, 10 Dec 2019 21:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012080;
        bh=G2t14PKQErttC9S3UQM9Sagfp/s0I+3TuRwqFsKUQZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uhO9hmBq2KlhTpoiTwuu5GLlvs9KStOqzW01Usv4kBCEbHjCyuTrwuR5DMHxdYBCe
         w2J7aIB//Q+YQ92VZFIdVJXq0tapH3Luj0VchJCmmtAbQbpyh5kgficVQfHnnP/cBl
         d4nnz/zrj8CuH+ijZaFF1mbmfDXV2XUYxtAyCyYU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 059/350] rtw88: fix NSS of hw_cap
Date:   Tue, 10 Dec 2019 16:02:44 -0500
Message-Id: <20191210210735.9077-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 4f5bb7ff8b8d4bafd91243fc969ed240e67aa1ca ]

8822C is a 2x2 11ac chip, and then NSS must be less or equal to 2. However,
current nss of hw cap is 3, likes
	hw cap: hci=0x0f, bw=0x07, ptcl=0x03, ant_num=7, nss=3

This commit adds constraint to make sure NSS <= rf_path_num, and result
looks like
	hw cap: hci=0x0f, bw=0x07, ptcl=0x03, ant_num=7, nss=2

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 6dd457741b15d..7a3a4911bde2a 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1020,7 +1020,8 @@ static int rtw_dump_hw_feature(struct rtw_dev *rtwdev)
 
 	rtw_hw_config_rf_ant_num(rtwdev, efuse->hw_cap.ant_num);
 
-	if (efuse->hw_cap.nss == EFUSE_HW_CAP_IGNORE)
+	if (efuse->hw_cap.nss == EFUSE_HW_CAP_IGNORE ||
+	    efuse->hw_cap.nss > rtwdev->hal.rf_path_num)
 		efuse->hw_cap.nss = rtwdev->hal.rf_path_num;
 
 	rtw_dbg(rtwdev, RTW_DBG_EFUSE,
-- 
2.20.1

