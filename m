Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97FE75F91B3
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbiJIWkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233289AbiJIWjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:39:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32E340E21;
        Sun,  9 Oct 2022 15:21:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AB3360C2B;
        Sun,  9 Oct 2022 22:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74C4C433C1;
        Sun,  9 Oct 2022 22:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354020;
        bh=5wnxw6C7mEaBmctzT+ji9b0d4mmzMnevfMMXcjoG3Xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bmmg8Pa08vDOskyMYO+KQDnzqVb6fqcYzsF8TB9TIS0i5IRoZMhCj8+lRnholcWro
         ppmNF3y4uRAAeYesgNkg7L9jMnLQdnuEMHd2p2Co+ahKdHrlh115+fH6xxB6wNkSGv
         CwzWESI4HJ/0NL9JpZJO0rQ9fylfgHCR6J9wQf/2QN4bqmU0XXy403Wrqmmptdvuwr
         eWmxGF3z3NfJksqSIbImjW2PwqVpKsVreomeBK+JP31Wzn+LjQjYF7oeaoNhHzaJuo
         f7DaxqXrOK+o4Vkl3jQFDvFYTJRGlCFf2gd4nj9q1R46wHhXzs/5ZucPJAFI5V30VY
         9KDPe1n/+WJwQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Wang <sean.wang@mediatek.com>, YN Chen <YN.Chen@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        lorenzo@kernel.org, ryder.lee@mediatek.com, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com, johannes.berg@intel.com,
        deren.wu@mediatek.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 23/46] wifi: mt76: mt7921: reset msta->airtime_ac while clearing up hw value
Date:   Sun,  9 Oct 2022 18:18:48 -0400
Message-Id: <20221009221912.1217372-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221912.1217372-1-sashal@kernel.org>
References: <20221009221912.1217372-1-sashal@kernel.org>
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
index 6cb65391427f..7b48df301079 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -627,6 +627,7 @@ void mt7921_mac_sta_assoc(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 
 	mt7921_mac_wtbl_update(dev, msta->wcid.idx,
 			       MT_WTBL_UPDATE_ADM_COUNT_CLEAR);
+	memset(msta->airtime_ac, 0, sizeof(msta->airtime_ac));
 
 	mt7921_mcu_sta_update(dev, sta, vif, true, MT76_STA_INFO_STATE_ASSOC);
 
-- 
2.35.1

