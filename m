Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAE4209B8F
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 10:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390474AbgFYI5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 04:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390330AbgFYI5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 04:57:39 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1A1C061573
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 01:57:39 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id s1so5655465ljo.0
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 01:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization;
        bh=tsxe73CbCDNiZo0VjhYuwdhWqwNcqEIgUe+KxaQ0ns4=;
        b=q/raYAt+gPfBNNt6HHLUJ0Qx3RngpwqslU0ff+6mz555zDkiivqCu9S7lTLrlwIKZO
         VBF4DeeL8ZatBfcGBD7qAvNWlQS/0kO4fHWvSKZAcKcVTNg7PAds5SiWUh1H3KWh/5Sk
         7no72Zu4t5NW55BM2mVngYvPg41ZUNfe+ch0K/O0CuD8JVl8CCDh9gl5MS6mdN6VhMgY
         uvNHixiYJgXvSK4jreBlNxqlVDCafltSf+ThavlwWQom3PjM4L8SJBjA8nF1Vm8o13gn
         /aYShRbNWe5Pz+rNflXUPOw+NHkEo2lZdmEoAbr7JiEJyFGcgReK1LTx3EUmXkryLZzv
         u7UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization;
        bh=tsxe73CbCDNiZo0VjhYuwdhWqwNcqEIgUe+KxaQ0ns4=;
        b=gjfmArEXmNqdtSANOrpuwTm8PYAJPPZ1VkhndRFfx+TsrmK4K8ndEMlTD5xjyRkAx7
         dmG78Z5djZ3U2hAOWx8A8ImQJArpE59NoUoDYwRQPaFYdNeXFtKeUQL5AcYF4igyJzsG
         vP+IV1sIoAmB9MEkipyKJ3qUSqnZ8054xtI/U6jSqfwPoQDc4hon1cUS7CnEGHjvBLL6
         Vq6EJJY547Mofc/FWBepDZm6GHQT0p0IEjja7ANhPdIiOP7EMhufcc6J2mPd4PJnVWB5
         VY9u56d1MVDByiaCaTQYVdB8Mn+v6Cpl8ciWg3TLR5h0G+P1OTRLTC2XZkxyEL5lxgJ4
         JNyQ==
X-Gm-Message-State: AOAM5332IUmrByv38/qcfKQua0IA863S6ujSgNYvLzYSPDEu8fIFzpFr
        w/pNs8kPzEu9tgGnyrBeN5mGE7vFYFQ=
X-Google-Smtp-Source: ABdhPJwTKsursAEoQsbfw8OgmYntZ8p1/YSN91T26j2YMgaMY/t6Yrk2qttcZh4lECqQ/lkdotKGVA==
X-Received: by 2002:a2e:8456:: with SMTP id u22mr15361992ljh.73.1593075457619;
        Thu, 25 Jun 2020 01:57:37 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id c20sm5807374lfb.33.2020.06.25.01.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 01:57:36 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, fugang.duan@nxp.com
Subject: [PATCH net-next] net: ethernet: fec: prevent tx starvation under high rx load
Date:   Thu, 25 Jun 2020 10:57:28 +0200
Message-Id: <20200625085728.9869-1-tobias@waldekranz.com>
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

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 9f80a33c5b16..328fb12ef8db 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1616,8 +1616,17 @@ fec_enet_rx(struct net_device *ndev, int budget)
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
 
@@ -1643,16 +1652,9 @@ fec_enet_interrupt(int irq, void *dev_id)
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
@@ -1673,6 +1675,8 @@ static int fec_enet_rx_napi(struct napi_struct *napi, int budget)
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	int pkts;
 
+	fec_enet_collect_events(fep);
+
 	pkts = fec_enet_rx(ndev, budget);
 
 	fec_enet_tx(ndev);
-- 
2.17.1

