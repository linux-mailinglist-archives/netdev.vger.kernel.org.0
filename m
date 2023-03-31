Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320276D20EB
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 14:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbjCaMvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 08:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbjCaMux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 08:50:53 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB3522E91
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 05:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=plBc849xsOtPnqcAcEjxdkW2Cs1nzv51Y/9OYbRG0fU=; b=ml82eJzrXq85iraub7m44I1Ah2
        llhmjMDtfswjbPDGY2Q0mpxgEYDfv9cfA64wBxhr3p5ZEYuQyKrWZ4OjBg4fODvpp6JerfNaJqsQV
        FLvlIQvpg4DTDLIRXU/5CQvkER4eXHiBGRYNsyu8BLl1ZqAX539jVEiaTBIJLQMsRQS0=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1piECd-008vM0-K7; Fri, 31 Mar 2023 14:49:59 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Cc:     Frank Wunderlich <frank-w@public-files.de>
Subject: [PATCH net] net: ethernet: mtk_eth_soc: fix remaining throughput regression
Date:   Fri, 31 Mar 2023 14:49:59 +0200
Message-Id: <20230331124959.40468-1-nbd@nbd.name>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on further tests, it seems that the QDMA shaper is not able to
perform shaping close to the MAC link rate without throughput loss.
This cannot be compensated by increasing the shaping rate, so it seems
to be an internal limit.

Fix the remaining throughput regression by detecting that condition and
limiting shaping to ports with lower link speed.

This patch intentionally ignores link speed gain from TRGMII, because
even on such links, shaping to 1000 Mbit/s incurs some throughput
degradation.

Fixes: f63959c7eec3 ("net: ethernet: mtk_eth_soc: implement multi-queue support for per-port queues")
Tested-By: Frank Wunderlich <frank-w@public-files.de>
Reported-by: Frank Wunderlich <frank-w@public-files.de>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 282f9435d5ff..e14050e17862 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -753,6 +753,7 @@ static void mtk_mac_link_up(struct phylink_config *config,
 		 MAC_MCR_FORCE_RX_FC);
 
 	/* Configure speed */
+	mac->speed = speed;
 	switch (speed) {
 	case SPEED_2500:
 	case SPEED_1000:
@@ -3235,6 +3236,9 @@ static int mtk_device_event(struct notifier_block *n, unsigned long event, void
 	if (dp->index >= MTK_QDMA_NUM_QUEUES)
 		return NOTIFY_DONE;
 
+	if (mac->speed > 0 && mac->speed <= s.base.speed)
+		s.base.speed = 0;
+
 	mtk_set_queue_speed(eth, dp->index + 3, s.base.speed);
 
 	return NOTIFY_DONE;
-- 
2.39.0

