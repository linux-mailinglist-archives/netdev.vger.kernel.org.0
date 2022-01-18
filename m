Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1516B49162C
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345953AbiARCcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343804AbiARC1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:27:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC3AC06175E;
        Mon, 17 Jan 2022 18:25:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAC0460C8B;
        Tue, 18 Jan 2022 02:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5207AC36AEB;
        Tue, 18 Jan 2022 02:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472718;
        bh=s5IjFqMJ/dT0kIt8h9WrHQlrzu3r9T+bGFdI2o8kycU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cwwK61Rua+hpj7KR55zcFdFP1zDDMAJdDhn9LtkTTp/9qUaTLhuR7Rc4A8Ncdz6Yv
         kCn8VLOz0n/P5KARjsrO5kRInWs1hctIxjojpVCoBh3TH8xxtjGBkjOESYo1YwpQca
         WtDnZXv+BzBqzxoC0Qlj9c19SkCq366+St1eCXMgrkUqw0OZZqS6+HFQP+d4SJzsBh
         GzPo2XvoOzDkBU5lIN1kE9nPnV7/WOmkopk+lP5/KClTpRgMYf4Rwph3iBMZHJoBvz
         bIf6fUKLTXQw4FI7+iRNAYtcNJfAlRkPDm0gzatj0sGKqEyyM5sdGRq+HTZPuaP6NY
         nI5VsDbJiJuCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 111/217] rtw89: don't kick off TX DMA if failed to write skb
Date:   Mon, 17 Jan 2022 21:17:54 -0500
Message-Id: <20220118021940.1942199-111-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit a58fdb7c843a37d6598204c6513961feefdadc6a ]

This is found by Smatch static checker warning:
	drivers/net/wireless/realtek/rtw89/mac80211.c:31 rtw89_ops_tx()
	error: uninitialized symbol 'qsel'.

The warning is because 'qsel' isn't filled by rtw89_core_tx_write() due to
failed to write. The way to fix it is to avoid kicking off TX DMA, so add
'return' to the failure case.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20211201093816.13806-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/mac80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtw89/mac80211.c b/drivers/net/wireless/realtek/rtw89/mac80211.c
index 16dc6fb7dbb0b..e9d61e55e2d92 100644
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -27,6 +27,7 @@ static void rtw89_ops_tx(struct ieee80211_hw *hw,
 	if (ret) {
 		rtw89_err(rtwdev, "failed to transmit skb: %d\n", ret);
 		ieee80211_free_txskb(hw, skb);
+		return;
 	}
 	rtw89_core_tx_kick_off(rtwdev, qsel);
 }
-- 
2.34.1

