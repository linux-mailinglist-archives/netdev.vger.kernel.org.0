Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C384EF390
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349028AbiDAOxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351066AbiDAOsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:48:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8250B5A598;
        Fri,  1 Apr 2022 07:38:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0561BCE2589;
        Fri,  1 Apr 2022 14:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91837C340EE;
        Fri,  1 Apr 2022 14:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823931;
        bh=ThPeycLj+4C+6ieQIJwKgxtTuow7S0mzR6CtjXU1XN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hNHn7J4Vo6xFK8Gh0ZOV0lIh9/GMPMe2oINeWOq0XmuomjojTlo14JFzTCKuHYWQo
         em4+ftMoruT8nIOartKG4gnjgh0ByOuWp9V8YCZwv2O09ZTYjdLSY58XoHL7tXfvoR
         KvvfF4stSMyNu6WKa6C9ty82mbC8l8CGB9ZsbfJJaJ523XfHRXjWqQxmTg1EMURdWX
         2/KhFtPmdUk9KGbhq7kovf9V65W/OkkcW7rOz25R0zAPF/vSHxwsh+MT/mwx35Vee3
         78zL77XYIp0e5WgyoBqxiyFeieCQone8mTLnt8Rm9NTGHuMAeWvcaf+sFtPp1U3hPG
         4FTQirmpE+Pfg==
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
Subject: [PATCH AUTOSEL 5.15 23/98] mt76: mt7921: fix crash when startup fails.
Date:   Fri,  1 Apr 2022 10:36:27 -0400
Message-Id: <20220401143742.1952163-23-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143742.1952163-1-sashal@kernel.org>
References: <20220401143742.1952163-1-sashal@kernel.org>
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
index 9eb90e6f0103..30252f408ddc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -224,6 +224,7 @@ static void mt7921_stop(struct ieee80211_hw *hw)
 
 	cancel_delayed_work_sync(&dev->pm.ps_work);
 	cancel_work_sync(&dev->pm.wake_work);
+	cancel_work_sync(&dev->reset_work);
 	mt76_connac_free_pending_tx_skbs(&dev->pm, NULL);
 
 	mt7921_mutex_acquire(dev);
-- 
2.34.1

