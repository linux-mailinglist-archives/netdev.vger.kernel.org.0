Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADD320D560
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731797AbgF2TQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729673AbgF2TQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:16:20 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5296C061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 12:16:19 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id 9so19484509ljv.5
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 12:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization;
        bh=TTHrT2sadLTHshA5jkNzCj0xSpWURSULHwMV9L26P9E=;
        b=QFvS0WJiz+aF2mf9hmQv8EHCTTMqLTunmgky1hfGMahBn0mxy0sdWfQ3Kr5ydZ9YEm
         QUNuNcBBqHHUo2ggOUKOu5eE/ivn/6+DejAt26HF5PPRjV+YL9azFh81wSTAKl6RfCCJ
         JVkqxNqq2KVLEIjRKwuOGukGFbDqUXphLyPGbIU+/TwWBPr6jQ5elxQDg338/xKRAxVs
         lboFVuEyTxNayXRoWhuC80YPvliS4ku7h7SdsjEhyjn5aQ94SnwTLr3w3owC5CM6iSVY
         c2xlbonLezme9UkLnRmwN7XAfhRrHP+D5IRX3ZS2dM6TWf5wmqqqKcGPczSb6uY6JGoM
         l9gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization;
        bh=TTHrT2sadLTHshA5jkNzCj0xSpWURSULHwMV9L26P9E=;
        b=qvDsECVnV1FS+XuQ+ptNJo92FGBxTS5g7X0JctgRL4X44iFHdfr8BKtkXhXokrCnWs
         IU7CAr5Du7k/wopU0k+G0WZKDtwcip5rtIO1QKlEUpHj2c7O3hYFdKZ1PbOei/i+3dJi
         KTudhbB5MJZAACWS7EVFxBdUSkh1iI6Pj5fiomaDOPdNjAvf+//GG+RMwj8eiUV8IEX2
         fNqtA4OveN8mOB5VDO4saaVP5yfrnM/Th/u9wd1dq3N8CtxUJvF7XvvJbYLM8nT1A+17
         ROulu1emRT31RZVoYKBpCiuo+tNzVS67pamImzfBOUdWizZ1Br4dZRzoeKEGClxS9vWE
         xZrg==
X-Gm-Message-State: AOAM533/Er+fnLacXxjP+stXTOg6ngn1x/jSXim0VUCvV7Ht6qtur2DZ
        jcVUSTG81SdAABkT7YxAvMIr7g==
X-Google-Smtp-Source: ABdhPJx2wIS3LgM57040XfeX2SlEmVYuyqOaH2kY94WUH49OFSL2YczE4z2YJhhWzSGLQMdx3j3Aow==
X-Received: by 2002:a2e:808a:: with SMTP id i10mr3239648ljg.400.1593458178067;
        Mon, 29 Jun 2020 12:16:18 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id a21sm175038ljd.54.2020.06.29.12.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 12:16:17 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, fugang.duan@nxp.com
Subject: [PATCH net] net: ethernet: fec: prevent tx starvation under high rx load
Date:   Mon, 29 Jun 2020 21:16:01 +0200
Message-Id: <20200629191601.5169-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
Organization: Westermo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the ISR, we poll the event register for the queues in need of
service and then enter polled mode. After this point, the event
register will never be read again until we exit polled mode.

In a scenario where a UDP flow is routed back out through the same
interface, i.e. "router-on-a-stick" we'll typically only see an rx
queue event initially. Once we start to process the incoming flow
we'll be locked polled mode, but we'll never clean the tx rings since
that event is never caught.

Eventually the netdev watchdog will trip, causing all buffers to be
dropped and then the process starts over again.

By adding a poll of the active events at each NAPI call, we avoid the
starvation.

Fixes: 4d494cdc92b3 ("net: fec: change data structure to support multiqueue")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 2d0d313ee7c5..f6e25c2d2c8c 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1617,8 +1617,17 @@ fec_enet_rx(struct net_device *ndev, int budget)
 }
 
 static bool
-fec_enet_collect_events(struct fec_enet_private *fep, uint int_events)
+fec_enet_collect_events(struct fec_enet_private *fep)
 {
+	uint int_events;
+
+	int_events = readl(fep->hwp + FEC_IEVENT);
+
+	/* Don't clear MDIO events, we poll for those */
+	int_events &= ~FEC_ENET_MII;
+
+	writel(int_events, fep->hwp + FEC_IEVENT);
+
 	if (int_events == 0)
 		return false;
 
@@ -1644,16 +1653,9 @@ fec_enet_interrupt(int irq, void *dev_id)
 {
 	struct net_device *ndev = dev_id;
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	uint int_events;
 	irqreturn_t ret = IRQ_NONE;
 
-	int_events = readl(fep->hwp + FEC_IEVENT);
-
-	/* Don't clear MDIO events, we poll for those */
-	int_events &= ~FEC_ENET_MII;
-
-	writel(int_events, fep->hwp + FEC_IEVENT);
-	fec_enet_collect_events(fep, int_events);
+	fec_enet_collect_events(fep);
 
 	if ((fep->work_tx || fep->work_rx) && fep->link) {
 		ret = IRQ_HANDLED;
@@ -1674,6 +1676,8 @@ static int fec_enet_rx_napi(struct napi_struct *napi, int budget)
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	int pkts;
 
+	fec_enet_collect_events(fep);
+
 	pkts = fec_enet_rx(ndev, budget);
 
 	fec_enet_tx(ndev);
-- 
2.17.1

