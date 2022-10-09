Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C34375F902C
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbiJIWVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbiJIWTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:19:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA00731EC4;
        Sun,  9 Oct 2022 15:17:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1301060CF5;
        Sun,  9 Oct 2022 22:16:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5254FC433B5;
        Sun,  9 Oct 2022 22:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353788;
        bh=ihi/X+jRwStHBrEQc38wWsGR2lD4+0D/n45zAeO5vlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DCASfawybmc53IrzPLWmkFe35lOG+92QUFIhPOAgw/11x0bu3NcktyJ6SL1q9/iXg
         uGJwUtI4qdzBjyJoKAjJicOa6lqYoQnB+BH3kbcSerPqM5MaSPdqYbvqsWCiOdAO03
         qj/VZZfyhu7Yevq1IBLWP5ru1OHGMrRIMBb5N7Q7Q80YM1chjuC2NM0p4LM1JeCyKF
         fkGEHc+/qdu0JqctzZASSpdi1atPOcIie512rrleGobxuQT324uX+Gh+y/nkn8bZmM
         JnJa/BCw/fM1CEfOhjbx8mbk1244PGVJHZ9B2CjotENpryPxnnRXFVweBrF3kxnqql
         iJhB9Crx598+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zong-Zhe Yang <kevin_yang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 24/73] rtw89: ser: leave lps with mutex
Date:   Sun,  9 Oct 2022 18:14:02 -0400
Message-Id: <20221009221453.1216158-24-sashal@kernel.org>
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

[ Upstream commit 8676031bae1c91037d06341214f4150b33707c68 ]

Calling rtw89_leave_lps() should hold rtwdev::mutex.
So, fix it.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220704023453.19935-5-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/ser.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/ser.c b/drivers/net/wireless/realtek/rtw89/ser.c
index 9e95ed972710..5d88200cbd3e 100644
--- a/drivers/net/wireless/realtek/rtw89/ser.c
+++ b/drivers/net/wireless/realtek/rtw89/ser.c
@@ -152,7 +152,10 @@ static void ser_state_run(struct rtw89_ser *ser, u8 evt)
 	rtw89_debug(rtwdev, RTW89_DBG_SER, "ser: %s receive %s\n",
 		    ser_st_name(ser), ser_ev_name(ser, evt));
 
+	mutex_lock(&rtwdev->mutex);
 	rtw89_leave_lps(rtwdev);
+	mutex_unlock(&rtwdev->mutex);
+
 	ser->st_tbl[ser->state].st_func(ser, evt);
 }
 
-- 
2.35.1

