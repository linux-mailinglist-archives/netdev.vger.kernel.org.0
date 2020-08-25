Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22DA251117
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 06:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbgHYE5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 00:57:23 -0400
Received: from smtprelay0117.hostedemail.com ([216.40.44.117]:38492 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728821AbgHYE5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 00:57:14 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 6A42D182CED2A;
        Tue, 25 Aug 2020 04:57:12 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1311:1314:1345:1359:1437:1515:1534:1543:1711:1730:1747:1777:1792:2198:2199:2282:2393:2559:2562:2904:3138:3139:3140:3141:3142:3354:3865:3868:3871:3872:3874:4250:4321:4605:5007:6261:9036:9121:10004:10848:11026:11657:11658:11914:12043:12296:12297:12555:12895:12986:13894:14181:14394:14721:21080:21627:30054,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: soap42_300b81b27059
X-Filterd-Recvd-Size: 4465
Received: from joe-laptop.perches.com (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf08.hostedemail.com (Postfix) with ESMTPA;
        Tue, 25 Aug 2020 04:57:11 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 16/29] 8390: Avoid comma separated statements
Date:   Mon, 24 Aug 2020 21:56:13 -0700
Message-Id: <720727617483779e9831f513bf9b671f59d26d57.1598331149.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1598331148.git.joe@perches.com>
References: <cover.1598331148.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use semicolons and braces.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/8390/axnet_cs.c | 19 ++++++++++++-------
 drivers/net/ethernet/8390/lib8390.c  | 14 +++++++++-----
 drivers/net/ethernet/8390/pcnet_cs.c |  6 ++++--
 3 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/8390/axnet_cs.c b/drivers/net/ethernet/8390/axnet_cs.c
index a00b36f91d9f..d041b6dda012 100644
--- a/drivers/net/ethernet/8390/axnet_cs.c
+++ b/drivers/net/ethernet/8390/axnet_cs.c
@@ -657,8 +657,10 @@ static void block_input(struct net_device *dev, int count,
     outb_p(E8390_RREAD+E8390_START, nic_base + AXNET_CMD);
 
     insw(nic_base + AXNET_DATAPORT,buf,count>>1);
-    if (count & 0x01)
-	buf[count-1] = inb(nic_base + AXNET_DATAPORT), xfer_count++;
+    if (count & 0x01) {
+	buf[count-1] = inb(nic_base + AXNET_DATAPORT);
+	xfer_count++;
+    }
 
 }
 
@@ -1270,10 +1272,12 @@ static void ei_tx_intr(struct net_device *dev)
 			ei_local->txing = 1;
 			NS8390_trigger_send(dev, ei_local->tx2, ei_local->tx_start_page + 6);
 			netif_trans_update(dev);
-			ei_local->tx2 = -1,
+			ei_local->tx2 = -1;
 			ei_local->lasttx = 2;
-		}
-		else ei_local->lasttx = 20, ei_local->txing = 0;	
+		} else {
+			ei_local->lasttx = 20;
+			ei_local->txing = 0;
+		}	
 	}
 	else if (ei_local->tx2 < 0) 
 	{
@@ -1289,9 +1293,10 @@ static void ei_tx_intr(struct net_device *dev)
 			netif_trans_update(dev);
 			ei_local->tx1 = -1;
 			ei_local->lasttx = 1;
+		} else {
+			ei_local->lasttx = 10;
+			ei_local->txing = 0;
 		}
-		else
-			ei_local->lasttx = 10, ei_local->txing = 0;
 	}
 //	else
 //		netdev_warn(dev, "unexpected TX-done interrupt, lasttx=%d\n",
diff --git a/drivers/net/ethernet/8390/lib8390.c b/drivers/net/ethernet/8390/lib8390.c
index babc92e2692e..1f48d7f6365c 100644
--- a/drivers/net/ethernet/8390/lib8390.c
+++ b/drivers/net/ethernet/8390/lib8390.c
@@ -597,10 +597,12 @@ static void ei_tx_intr(struct net_device *dev)
 			ei_local->txing = 1;
 			NS8390_trigger_send(dev, ei_local->tx2, ei_local->tx_start_page + 6);
 			netif_trans_update(dev);
-			ei_local->tx2 = -1,
+			ei_local->tx2 = -1;
 			ei_local->lasttx = 2;
-		} else
-			ei_local->lasttx = 20, ei_local->txing = 0;
+		} else {
+			ei_local->lasttx = 20;
+			ei_local->txing = 0;
+		}
 	} else if (ei_local->tx2 < 0) {
 		if (ei_local->lasttx != 2  &&  ei_local->lasttx != -2)
 			pr_err("%s: bogus last_tx_buffer %d, tx2=%d\n",
@@ -612,8 +614,10 @@ static void ei_tx_intr(struct net_device *dev)
 			netif_trans_update(dev);
 			ei_local->tx1 = -1;
 			ei_local->lasttx = 1;
-		} else
-			ei_local->lasttx = 10, ei_local->txing = 0;
+		} else {
+			ei_local->lasttx = 10;
+			ei_local->txing = 0;
+		}
 	} /* else
 		netdev_warn(dev, "unexpected TX-done interrupt, lasttx=%d\n",
 			    ei_local->lasttx);
diff --git a/drivers/net/ethernet/8390/pcnet_cs.c b/drivers/net/ethernet/8390/pcnet_cs.c
index 164c3ed550bf..9d3b1e0e425c 100644
--- a/drivers/net/ethernet/8390/pcnet_cs.c
+++ b/drivers/net/ethernet/8390/pcnet_cs.c
@@ -1178,8 +1178,10 @@ static void dma_block_input(struct net_device *dev, int count,
     outb_p(E8390_RREAD+E8390_START, nic_base + PCNET_CMD);
 
     insw(nic_base + PCNET_DATAPORT,buf,count>>1);
-    if (count & 0x01)
-	buf[count-1] = inb(nic_base + PCNET_DATAPORT), xfer_count++;
+    if (count & 0x01) {
+	buf[count-1] = inb(nic_base + PCNET_DATAPORT);
+	xfer_count++;
+    }
 
     /* This was for the ALPHA version only, but enough people have been
        encountering problems that it is still here. */
-- 
2.26.0

