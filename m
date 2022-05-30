Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFE9537BE9
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 15:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236956AbiE3N2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236842AbiE3N1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:27:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8535880DA;
        Mon, 30 May 2022 06:25:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32B38B80AE8;
        Mon, 30 May 2022 13:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50CFC341C0;
        Mon, 30 May 2022 13:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917137;
        bh=I+5VL4h4/uUKIFvLHkwrzyV1ZwSfo2lBjc7LZAxD4nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AWQCDbhQQcpbvK3Q1NBQDtYsatGxH06HVKz0tTDUtX6eOsIcFl/3DHAGfgQ/KHwY+
         r3/CbykLrl435yY7yyjFlU7Sne5PCw1GvsGEMm+ZF9SK9SvXZ5aqJV2qwoNo0XFa9j
         hZY5hrnCazAAg11Ec6x29zDYoOWkKIMJWvC6oxjpZCsn1zEb4XSNvmgbi2BD8ry7kB
         qCVC+qldxtZdepOmHIOJ7u0oGIypeZVKKAFczsj30gijkbHa5TpXeKRM63NYzg8hmm
         IDg2oIfd1aX0TNT/RIBxGynbu/p7OSgHy3rQ86dL6HE8gQ6bCow0bNMbcVTZUaMCyD
         iwxKYFdwsQ38g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Po-Hao Huang <phhuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        tony0620emma@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 029/159] rtw88: fix incorrect frequency reported
Date:   Mon, 30 May 2022 09:22:14 -0400
Message-Id: <20220530132425.1929512-29-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
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

