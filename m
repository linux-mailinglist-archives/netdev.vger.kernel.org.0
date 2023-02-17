Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1542469B169
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 17:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjBQQxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 11:53:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjBQQxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 11:53:00 -0500
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C489A12BF2
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 08:52:57 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 1D91E642ECAA;
        Fri, 17 Feb 2023 17:52:55 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id zpqQKmtJs9YN; Fri, 17 Feb 2023 17:52:54 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id A4F00642ECAB;
        Fri, 17 Feb 2023 17:52:54 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 2YCOqKHzqpJC; Fri, 17 Feb 2023 17:52:54 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 828F4642ECAA;
        Fri, 17 Feb 2023 17:52:54 +0100 (CET)
Date:   Fri, 17 Feb 2023 17:52:54 +0100 (CET)
From:   Richard Weinberger <richard@nod.at>
To:     netdev@vger.kernel.org
Cc:     wei.fang@nxp.com, shenwei.wang@nxp.com, xiaoning.wang@nxp.com,
        linux-imx@nxp.com
Message-ID: <1422776754.146013.1676652774408.JavaMail.zimbra@nod.at>
Subject: fec: high latency with imx8mm compared to imx6q
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF97 (Linux)/8.8.12_GA_3809)
Thread-Index: KX6nItb3xzzXXgLsKrBE7F/dfPfNJQ==
Thread-Topic: high latency with imx8mm compared to imx6q
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

I'm investigating into latency issues on an imx8mm system after
migrating from imx6q.
A regression test showed massive latency increases when single/small packets
are exchanged.

A simple test using ping exhibits the problem.
Pinging the very same host from the imx8mm has a way higher RTT than from the imx6.

Ping, 100 packets each, from imx6q:
rtt min/avg/max/mdev = 0.689/0.851/1.027/0.088 ms

Ping, 100 packets each, from imx8mm:
rtt min/avg/max/mdev = 1.073/2.064/2.189/0.330 ms

You can see that the average RTT has more than doubled.
I see the same results with every imx8mm system I got my hands on so far.
Also the kernel version does not matter, I've tried also the NXP tree without success.

All reported numbers have been produced using vanilla Linux v6.2-rc8 with these boards:
PHYTEC phyBOARD-Mira Quad with an i.MX6Q, silicon rev 1.5
FSL i.MX8MM EVK board with an i.MX8MM, revision 1.0

While digging into the fec ethernet driver I noticed that on the imx8mm sending
packet takes extremely long.

I'm measuring the time between triggering transmission start,
arrival of the transmit done IRQ and NAPI done.
Don't get confused by the function names, gcc inlined like hell.

imx6q:
   tst-104     [003] b..3.   217.340689: fec_enet_start_xmit: START skb: 8a68617d
   tst-104     [003] b..3.   217.340702: fec_enet_start_xmit: DONE skb: 8a68617d
<idle>-0       [000] d.h1.   217.340736: fec_enet_interrupt: 
<idle>-0       [000] d.h1.   217.340739: fec_enet_interrupt: scheduling napi
<idle>-0       [000] ..s1.   217.340774: fec_enet_rx_napi: TX DONE skb: 8a68617d

Time between submit and irq: 34us
Time between submit and tx done: 72us

imx8mm:
   tst-95      [000] b..2.   142.713409: fec_enet_start_xmit: START skb: 00000000ad10a62d
   tst-95      [000] b..2.   142.713417: fec_enet_start_xmit: DONE skb: 00000000ad10a62d
<idle>-0       [000] d.h1.   142.714428: fec_enet_interrupt: 
<idle>-0       [000] d.h1.   142.714430: fec_enet_interrupt: scheduling napi
<idle>-0       [000] ..s1.   142.714451: fec_enet_rx_napi: TX DONE skb: 00000000ad10a62d

Time between submit and irq: 1011us
Time between submit and tx done: 1034us 

As you can see, imx8mm's fec needs more than a whole millisecond to send a single packet.
Please note I'm just talking about latency. Throughput is fine, when the transmitter is
kept busy it seems to be much faster.

Is this a known issue?
Does fec need further tweaking for the imx8mm?
Can it be that the ethernet controller is in a sleep mode and needs to wake up each time?

Thanks,
//richard

My debug patch:
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 2341597408d1..7b0d43d76dea 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -565,6 +565,8 @@ static int fec_enet_txq_submit_skb(struct fec_enet_priv_tx_q *txq,
 	unsigned int index;
 	int entries_free;
 
+	trace_printk("START skb: %p\n", skb);
+
 	entries_free = fec_enet_get_free_txdesc_num(txq);
 	if (entries_free < MAX_SKB_FRAGS + 1) {
 		dev_kfree_skb_any(skb);
@@ -674,6 +676,7 @@ static int fec_enet_txq_submit_skb(struct fec_enet_priv_tx_q *txq,
 
 	/* Trigger transmission start */
 	writel(0, txq->bd.reg_desc_active);
+	trace_printk("DONE skb: %p\n", skb);
 
 	return 0;
 }
@@ -1431,6 +1434,7 @@ fec_enet_tx_queue(struct net_device *ndev, u16 queue_id)
 		} else {
 			ndev->stats.tx_packets++;
 			ndev->stats.tx_bytes += skb->len;
+			trace_printk("TX DONE skb: %p\n", skb);
 		}
 
 		/* NOTE: SKBTX_IN_PROGRESS being set does not imply it's we who
@@ -1809,12 +1813,15 @@ fec_enet_interrupt(int irq, void *dev_id)
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	irqreturn_t ret = IRQ_NONE;
 
+	trace_printk("\n");
+
 	if (fec_enet_collect_events(fep) && fep->link) {
 		ret = IRQ_HANDLED;
 
 		if (napi_schedule_prep(&fep->napi)) {
 			/* Disable interrupts */
 			writel(0, fep->hwp + FEC_IMASK);
+			trace_printk("scheduling napi\n");
 			__napi_schedule(&fep->napi);
 		}
 	}
