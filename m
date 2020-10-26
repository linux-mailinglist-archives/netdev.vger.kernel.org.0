Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443952998AD
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 22:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731656AbgJZVXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 17:23:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731589AbgJZVXb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 17:23:31 -0400
Received: from localhost.localdomain (unknown [192.30.34.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1046D207F7;
        Mon, 26 Oct 2020 21:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603747410;
        bh=1cdNvddUdNByOuemIzD0FWBYLNf7FJXR1LgisTFtu5c=;
        h=From:To:Cc:Subject:Date:From;
        b=fAmEUO8nuXZRXASZgXCPeG5+iN//fc3aROoRzkMVOZkDIAONM1oZaat9MyBjNX9N4
         TllIkCzBqn+TFbd+aQ+zxHjZUquYwSfMZwgmCYH/fosS/dWSYbORZFpbmbOR/NP0UG
         zrEIordMT+Ufgx5Mbkb8lLXaH4BvECr3PKN14YW4=
From:   Arnd Bergmann <arnd@kernel.org>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tzu-En Huang <tehuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Chin-Yen Lee <timlee@realtek.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH\ net] rtw88: fix fw dump support detection
Date:   Mon, 26 Oct 2020 22:22:55 +0100
Message-Id: <20201026212323.3888550-1-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

clang points out a useless check that was recently added:

drivers/net/wireless/realtek/rtw88/fw.c:1485:21: warning: address of array 'rtwdev->chip->fw_fifo_addr' will always evaluate to 'true' [-Wpointer-bool-conversion]
        if (!rtwdev->chip->fw_fifo_addr) {
            ~~~~~~~~~~~~~~~^~~~~~~~~~~~

Apparently this was meant to check the contents of the array
rather than the address, so check it accordingly.

Fixes: 0fbc2f0f34cc ("rtw88: add dump firmware fifo support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/realtek/rtw88/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 042015bc8055..b2fd87834f23 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -1482,7 +1482,7 @@ static bool rtw_fw_dump_check_size(struct rtw_dev *rtwdev,
 int rtw_fw_dump_fifo(struct rtw_dev *rtwdev, u8 fifo_sel, u32 addr, u32 size,
 		     u32 *buffer)
 {
-	if (!rtwdev->chip->fw_fifo_addr) {
+	if (!rtwdev->chip->fw_fifo_addr[0]) {
 		rtw_dbg(rtwdev, RTW_DBG_FW, "chip not support dump fw fifo\n");
 		return -ENOTSUPP;
 	}
-- 
2.27.0

