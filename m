Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F95652B60A
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 11:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbiERJE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 05:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233726AbiERJE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 05:04:26 -0400
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB28713CA0C
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 02:04:24 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed30:1425:89ca:2e9e:5fc1])
        by laurent.telenet-ops.be with bizsmtp
        id Y94M2700H10zdRX0194MBv; Wed, 18 May 2022 11:04:22 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1nrFbR-000oUd-5V; Wed, 18 May 2022 11:04:21 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1nrFbQ-00BX4e-Jh; Wed, 18 May 2022 11:04:20 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guo Zhengkui <guozhengkui@vivo.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] net: smc911x: Fix min() use in debug code
Date:   Wed, 18 May 2022 11:04:19 +0200
Message-Id: <ca032d4122fc70d3a56a524e5944a8eff9a329e8.1652864652.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If ENABLE_SMC_DEBUG_PKTS=1:

    drivers/net/ethernet/smsc/smc911x.c: In function ‘smc911x_hardware_send_pkt’:
    include/linux/minmax.h:20:28: error: comparison of distinct pointer types lacks a cast [-Werror]
       20 |  (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
	  |                            ^~
    drivers/net/ethernet/smsc/smc911x.c:483:17: note: in expansion of macro ‘min’
      483 |  PRINT_PKT(buf, min(len, 64));

Fix this by making the constant unsigned, to match the type of "len".
While at it, replace the other missed ternary operator by min(), too.

Convert the dummy PRINT_PKT() from a macro to a static inline function,
to catch mistakes like this without having to enable debug options
manually.

Fixes: 5ff0348b7f755aac ("net: smc911x: replace ternary operator with min()")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/ethernet/smsc/smc911x.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/smsc/smc911x.c
index 2694287770e6cd8e..24d66af797d465ca 100644
--- a/drivers/net/ethernet/smsc/smc911x.c
+++ b/drivers/net/ethernet/smsc/smc911x.c
@@ -140,7 +140,7 @@ static void PRINT_PKT(u_char *buf, int length)
 	pr_cont("\n");
 }
 #else
-#define PRINT_PKT(x...)  do { } while (0)
+static inline void PRINT_PKT(u_char *buf, int length) { }
 #endif
 
 
@@ -430,7 +430,7 @@ static inline void	 smc911x_rcv(struct net_device *dev)
 		SMC_PULL_DATA(lp, data, pkt_len+2+3);
 
 		DBG(SMC_DEBUG_PKTS, dev, "Received packet\n");
-		PRINT_PKT(data, ((pkt_len - 4) <= 64) ? pkt_len - 4 : 64);
+		PRINT_PKT(data, min(pkt_len - 4, 64U));
 		skb->protocol = eth_type_trans(skb, dev);
 		netif_rx(skb);
 		dev->stats.rx_packets++;
@@ -480,7 +480,7 @@ static void smc911x_hardware_send_pkt(struct net_device *dev)
 	SMC_SET_TX_FIFO(lp, cmdB);
 
 	DBG(SMC_DEBUG_PKTS, dev, "Transmitted packet\n");
-	PRINT_PKT(buf, min(len, 64));
+	PRINT_PKT(buf, min(len, 64U));
 
 	/* Send pkt via PIO or DMA */
 #ifdef SMC_USE_DMA
-- 
2.25.1

