Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD3215F8FB3
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbiJIWMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiJIWLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:11:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6E92982F;
        Sun,  9 Oct 2022 15:09:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB8CB60CA3;
        Sun,  9 Oct 2022 22:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78A8C433D6;
        Sun,  9 Oct 2022 22:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353364;
        bh=Rsz9rKTGJKYtTSkNCLrjg0+4EQ57GBD6604qCTdupwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A9fXsCkE4cOgznKx2T0rOlFXLMxQcY06/FZM6olu9CrfPtpBdai7R+6O/hvLicH6i
         /DXWNcsDCTPYeDxzqMMkyk8k+7UMUYBBSrFiz3Zt9vucYX5oSWbTkjML2vOxxQL6kJ
         1FeMr+yoN7jvQ9dW4OuwKVbSva1wMnm/smvM+mA/5pP8Xf+P88QgOJ4QozjuuX+25m
         EdhHsA4+sUSkxzNX0MBw8vH1d1DtslzEh6DEpHp4njwnoLkr6PP5gKQ7Z1LP2Jkrpd
         m3xUS8ywtrBj4s4U1hvqSFJjOyedHemNTF3YgR4Hrbi2nwkogFo13gvN0rp8abxg6l
         2Pkv2itRNfFQw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zong-Zhe Yang <kevin_yang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 27/77] rtw89: ser: leave lps with mutex
Date:   Sun,  9 Oct 2022 18:07:04 -0400
Message-Id: <20221009220754.1214186-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009220754.1214186-1-sashal@kernel.org>
References: <20221009220754.1214186-1-sashal@kernel.org>
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
index 726223f25dc6..7240364e8f7d 100644
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

