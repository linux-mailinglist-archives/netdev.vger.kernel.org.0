Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D804537F3B
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237656AbiE3Nrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238320AbiE3NpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:45:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9B28FD46;
        Mon, 30 May 2022 06:32:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6003260F6B;
        Mon, 30 May 2022 13:32:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE2BC3411A;
        Mon, 30 May 2022 13:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917561;
        bh=I+5VL4h4/uUKIFvLHkwrzyV1ZwSfo2lBjc7LZAxD4nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=apwZy7wbVNmh2G3J4nlPDdRAROlgMriMnFA6nMJukGUAxRnbIYpGRk0DA4VySEXEY
         OeJ/ZWIGO4lFCkbRDpCI1Y4NBiGnvGABhUsD9d73V/dBYnDX6PO0IOUS4Uv2qOLS4N
         OLoiC679hZNUSzHCuQUKn1ptCpqqLJA2AFH1tP3c0Hn6+lqXSQs8N5WhE5mjGqPrC+
         IWofDyUZu37mNAOMwvonHBom9zeVSJpFoglV1WlST0wWr5SHzZ0yDOO6FDoP47vGtX
         eIszlgQsRUTIlUeNUqN13YRGWC5h3a+ai+7GVoMYB09EcHDv3gjIaCJhu7T6cedqLd
         Eej3qQBSeSymA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Po-Hao Huang <phhuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        tony0620emma@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 025/135] rtw88: fix incorrect frequency reported
Date:   Mon, 30 May 2022 09:29:43 -0400
Message-Id: <20220530133133.1931716-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po-Hao Huang <phhuang@realtek.com>

[ Upstream commit 6723c0cde84fde582a261c186ce84100dcfa0019 ]

We should only fill in frequency reported by firmware during scan.
Add this so frames won't be dropped by mac80211 due to frequency
mismatch.

Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220407095858.46807-3-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rx.c b/drivers/net/wireless/realtek/rtw88/rx.c
index d2d607e22198..84aedabdf285 100644
--- a/drivers/net/wireless/realtek/rtw88/rx.c
+++ b/drivers/net/wireless/realtek/rtw88/rx.c
@@ -158,7 +158,8 @@ void rtw_rx_fill_rx_status(struct rtw_dev *rtwdev,
 	memset(rx_status, 0, sizeof(*rx_status));
 	rx_status->freq = hw->conf.chandef.chan->center_freq;
 	rx_status->band = hw->conf.chandef.chan->band;
-	if (rtw_fw_feature_check(&rtwdev->fw, FW_FEATURE_SCAN_OFFLOAD))
+	if (rtw_fw_feature_check(&rtwdev->fw, FW_FEATURE_SCAN_OFFLOAD) &&
+	    test_bit(RTW_FLAG_SCANNING, rtwdev->flags))
 		rtw_set_rx_freq_by_pktstat(pkt_stat, rx_status);
 	if (pkt_stat->crc_err)
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
-- 
2.35.1

