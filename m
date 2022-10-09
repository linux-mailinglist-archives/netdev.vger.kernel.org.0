Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F205F91BE
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbiJIWkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233430AbiJIWkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:40:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FBE41536;
        Sun,  9 Oct 2022 15:21:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB4DFB80DD6;
        Sun,  9 Oct 2022 22:11:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5177BC433C1;
        Sun,  9 Oct 2022 22:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353467;
        bh=Ltf1k6nZbq/4KQz6xsOUMvd7H8pKv9s2/hbk21ToTPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mFGwaHuiCdUPufA3+pk12DdJJdaFnnMX2FMzvPLv9D+OZbj7Gj9/PgF8XGvcTKsCQ
         sEG3j6JYWYn8IIZDsW1vbqxjRHG0a5TuL/u5z+BWBE7Kf3mBpJk4vucfpKaI+iDRpU
         ayK6uZRIhmbIrJZN07UEcGw5ZpoMgVBfU8qR2yWISYX8rlOOAfzx5EX+CxiEM/s4Cm
         wrTZYyCkSVn21/1UuejTYmZ4bQSo6O/jpAHZU7fK63y288tXcRFmNXVRwzrEglg/KF
         EPmzpuUVw+k0ZUZppq6GAfE/jkuqWJKCFB8dYhWhdY2FgDdcmYjccQyxRpEWlPyhzY
         2yyoRU7nniGkQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Wang <sean.wang@mediatek.com>, YN Chen <YN.Chen@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        lorenzo@kernel.org, ryder.lee@mediatek.com, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com, deren.wu@mediatek.com,
        johannes.berg@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 41/77] wifi: mt76: mt7921: reset msta->airtime_ac while clearing up hw value
Date:   Sun,  9 Oct 2022 18:07:18 -0400
Message-Id: <20221009220754.1214186-41-sashal@kernel.org>
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

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 1bf66dc31032ff5292f4d5b76436653f269fcfbd ]

We should reset mstat->airtime_ac along with clear up the entries in the
hardware WLAN table for the Rx and Rx accumulative airtime. Otherwsie, the
value msta->airtime_ac - [tx, rx]_last may be a negative and that is not
the actual airtime the device took in the last run.

Reported-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 1438a9f8d1fd..33bd64fe5c74 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -752,6 +752,7 @@ void mt7921_mac_sta_assoc(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 
 	mt7921_mac_wtbl_update(dev, msta->wcid.idx,
 			       MT_WTBL_UPDATE_ADM_COUNT_CLEAR);
+	memset(msta->airtime_ac, 0, sizeof(msta->airtime_ac));
 
 	mt7921_mcu_sta_update(dev, sta, vif, true, MT76_STA_INFO_STATE_ASSOC);
 
-- 
2.35.1

