Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74A975F90C2
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiJIW1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231907AbiJIWZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:25:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88E83E744;
        Sun,  9 Oct 2022 15:18:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 271B1B80E04;
        Sun,  9 Oct 2022 22:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A818FC4347C;
        Sun,  9 Oct 2022 22:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353834;
        bh=3e9UCbg0XtmrjGbgRHnu3bAdc2sCOpxbyJgRQrouSEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KE0mMgdQ3r8kdN7C5iTXBNBSGpz1RLPr9hdSZwTP6q5T1CAJu6VzL6VNeaThv3xlX
         4UwGMZRI62xLyiAmbenLlebN3xkM3syUIU2w1kIFa2CHDFGW/IJspJYTKGIonidFm1
         rusAmv6YinIpPKOI91e1rNPgPtnrAEnT1ClbdRjyT3BH4VTM6qnsiCVn+OJKCMqeT1
         Pzz8xQ2JF6UTVs2iNBbrjUV59w6P/kBbA6WPRc6ce3yQLnYPjZdO6bjXag5mjkGe8C
         S20UOujtzavdaM2xAj2nVzZ8cEeSX09WSE0G8mBWlr+e8/H+bN7Ppn3tP06NuwvrtL
         QKB9OTmuXCN4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 34/73] net: mscc: ocelot: report FIFO drop counters through stats->rx_dropped
Date:   Sun,  9 Oct 2022 18:14:12 -0400
Message-Id: <20221009221453.1216158-34-sashal@kernel.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit cc160fc29a264726b2bfbc2f551081430db3df03 ]

if_link.h says:

 * @rx_dropped: Number of packets received but not processed,
 *   e.g. due to lack of resources or unsupported protocol.
 *   For hardware interfaces this counter may include packets discarded
 *   due to L2 address filtering but should not include packets dropped
 *   by the device due to buffer exhaustion which are counted separately in
 *   @rx_missed_errors (since procfs folds those two counters together).

Currently we report "stats->rx_dropped = dev->stats.rx_dropped", the
latter being incremented by various entities in the stack. This is not
wrong, but we'd like to move ocelot_get_stats64() in the common ocelot
switch lib which is independent of struct net_device.

To do that, report the hardware RX drop counters instead. These drops
are due to policer action, or due to no destinations. When we have no
memory in the queue system, report this through rx_missed_errors, as
instructed.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 27 +++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 330d30841cdc..d7956fd051e6 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -745,7 +745,32 @@ static void ocelot_get_stats64(struct net_device *dev,
 			    s[OCELOT_STAT_RX_1024_1526] +
 			    s[OCELOT_STAT_RX_1527_MAX];
 	stats->multicast = s[OCELOT_STAT_RX_MULTICAST];
-	stats->rx_dropped = dev->stats.rx_dropped;
+	stats->rx_missed_errors = s[OCELOT_STAT_DROP_TAIL];
+	stats->rx_dropped = s[OCELOT_STAT_RX_RED_PRIO_0] +
+			    s[OCELOT_STAT_RX_RED_PRIO_1] +
+			    s[OCELOT_STAT_RX_RED_PRIO_2] +
+			    s[OCELOT_STAT_RX_RED_PRIO_3] +
+			    s[OCELOT_STAT_RX_RED_PRIO_4] +
+			    s[OCELOT_STAT_RX_RED_PRIO_5] +
+			    s[OCELOT_STAT_RX_RED_PRIO_6] +
+			    s[OCELOT_STAT_RX_RED_PRIO_7] +
+			    s[OCELOT_STAT_DROP_LOCAL] +
+			    s[OCELOT_STAT_DROP_YELLOW_PRIO_0] +
+			    s[OCELOT_STAT_DROP_YELLOW_PRIO_1] +
+			    s[OCELOT_STAT_DROP_YELLOW_PRIO_2] +
+			    s[OCELOT_STAT_DROP_YELLOW_PRIO_3] +
+			    s[OCELOT_STAT_DROP_YELLOW_PRIO_4] +
+			    s[OCELOT_STAT_DROP_YELLOW_PRIO_5] +
+			    s[OCELOT_STAT_DROP_YELLOW_PRIO_6] +
+			    s[OCELOT_STAT_DROP_YELLOW_PRIO_7] +
+			    s[OCELOT_STAT_DROP_GREEN_PRIO_0] +
+			    s[OCELOT_STAT_DROP_GREEN_PRIO_1] +
+			    s[OCELOT_STAT_DROP_GREEN_PRIO_2] +
+			    s[OCELOT_STAT_DROP_GREEN_PRIO_3] +
+			    s[OCELOT_STAT_DROP_GREEN_PRIO_4] +
+			    s[OCELOT_STAT_DROP_GREEN_PRIO_5] +
+			    s[OCELOT_STAT_DROP_GREEN_PRIO_6] +
+			    s[OCELOT_STAT_DROP_GREEN_PRIO_7];
 
 	/* Get Tx stats */
 	stats->tx_bytes = s[OCELOT_STAT_TX_OCTETS];
-- 
2.35.1

