Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0881E4EEFF9
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347199AbiDAOb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347170AbiDAOaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:30:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9BD286F53;
        Fri,  1 Apr 2022 07:27:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E2BFB82500;
        Fri,  1 Apr 2022 14:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AE1C2BBE4;
        Fri,  1 Apr 2022 14:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823265;
        bh=fOMAEttNRP3JQe3JAD4ElWJ5oYZt9g8F/dp3fJIe+uo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MpX0IOixdktOTWR+T1Bi87dS5RdlhL+gc4kH53vTPoab2vmbiX0TN5tFkgf94ylYu
         Njz56RXTbEuMTCAAbrOTy2oTR2S2i8hT2WHs3sGuvH/WcWrhZQA8W/S8kpJ3pD9exv
         FaPOmeMMSXdEdjBhHGH8ln/07Fva3FWh8T2+izno5d61H35cKglu+GYpcDEQygyxql
         8tRaBs8QKIQpuG5sIjzVTJgtInAJFtIhmRURexvnJ7YA1VDLyXLjIb2T5mc6ytQDIg
         kqVCZAj6ZZpLuAXO1nVlUovs/G1d4c/WURQbRO8G1MEtH9+vjIY9DAMgDYR/oebkmK
         zj2iu16N4QH0g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Greear <greearb@candelatech.com>, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>, lorenzo.bianconi83@gmail.com,
        ryder.lee@mediatek.com, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        sean.wang@mediatek.com, deren.wu@mediatek.com,
        johannes.berg@intel.com, YN.Chen@mediatek.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.17 039/149] mt76: mt7921: fix crash when startup fails.
Date:   Fri,  1 Apr 2022 10:23:46 -0400
Message-Id: <20220401142536.1948161-39-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

[ Upstream commit 827e7799c61b978fbc2cc9dac66cb62401b2b3f0 ]

If the nic fails to start, it is possible that the
reset_work has already been scheduled.  Ensure the
work item is canceled so we do not have use-after-free
crash in case cleanup is called before the work item
is executed.

This fixes crash on my x86_64 apu2 when mt7921k radio
fails to work.  Radio still fails, but OS does not
crash.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 7a8d2596c226..4abb7a6e775a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -273,6 +273,7 @@ static void mt7921_stop(struct ieee80211_hw *hw)
 
 	cancel_delayed_work_sync(&dev->pm.ps_work);
 	cancel_work_sync(&dev->pm.wake_work);
+	cancel_work_sync(&dev->reset_work);
 	mt76_connac_free_pending_tx_skbs(&dev->pm, NULL);
 
 	mt7921_mutex_acquire(dev);
-- 
2.34.1

