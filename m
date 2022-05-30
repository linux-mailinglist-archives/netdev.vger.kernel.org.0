Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D11DD537BC9
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 15:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236674AbiE3NZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236631AbiE3NY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:24:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC9A82171;
        Mon, 30 May 2022 06:24:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC64760EC6;
        Mon, 30 May 2022 13:24:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA4EC3411C;
        Mon, 30 May 2022 13:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917091;
        bh=wB+eyMgg/Fjs26R7DtFWaZpsqYjiQcyeIh3vo3CFVwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EU/1bkdF6+fjt53Lv5NjlBrEhrlGsEPneExzen77BbTImVfta5hutNk4yCtBTeMLn
         zht3a/rGXJRPsbhtsdyMxA+iha5A1VEC6g/oqg1I4u6PZL6gYZSnsO9CveFkJ9GOwU
         3YCQ9/7/YJ1j8XuDKtlWhQTZFeP6cyoPPhp7VZppRiW7iJetKa2d6DpvXGGFNYItBL
         XRe0NOz+HpycBxgIktNnZU59hFcvF/7rakB8NmLWlv3rwl6Ff/d4Vv8TxOmAEma5RC
         LQK8L3TrpLS1bN28YQZaLIPmwyUxW93m57cvNJfeVliz0IGTWRggxaqaSjlhrgpPRG
         cmZQREfa//vUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Po Hao Huang <phhuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 011/159] rtw89: fix misconfiguration on hw_scan channel time
Date:   Mon, 30 May 2022 09:21:56 -0400
Message-Id: <20220530132425.1929512-11-sashal@kernel.org>
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

From: Po Hao Huang <phhuang@realtek.com>

[ Upstream commit 65ee4971a262a024e239e5d2b7f4dee1b3dff40e ]

Without this patch, hw scan won't stay long enough on DFS/passive
channels. Found previous logic error and fix it.

Signed-off-by: Po Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220401055043.12512-5-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 6deaf8eec6b4..a9b5315a517e 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -2065,7 +2065,7 @@ static void rtw89_hw_scan_add_chan(struct rtw89_dev *rtwdev, int chan_type,
 		ch_info->num_pkt = 0;
 		break;
 	case RTW89_CHAN_DFS:
-		ch_info->period = min_t(u8, ch_info->period,
+		ch_info->period = max_t(u8, ch_info->period,
 					RTW89_DFS_CHAN_TIME);
 		ch_info->dwell_time = RTW89_DWELL_TIME;
 		break;
-- 
2.35.1

