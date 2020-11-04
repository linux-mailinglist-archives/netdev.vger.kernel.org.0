Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A882A680C
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 16:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730779AbgKDPtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 10:49:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35306 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730059AbgKDPtY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 10:49:24 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kaL2G-005Ebn-4g; Wed, 04 Nov 2020 16:49:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
        David Laight <David.Laight@ACULAB.COM>,
        Lee Jones <lee.jones@linaro.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 6/7] drivers: net: smc911x: Fix cast from pointer to integer of different size
Date:   Wed,  4 Nov 2020 16:48:57 +0100
Message-Id: <20201104154858.1247725-7-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201104154858.1247725-1-andrew@lunn.ch>
References: <20201104154858.1247725-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/ethernet/smsc/smc911x.c: In function ‘smc911x_hardware_send_pkt’:
drivers/net/ethernet/smsc/smc911x.c:471:11: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
  471 |  cmdA = (((u32)skb->data & 0x3) << 16) |

When built on 64bit targets, the skb->data pointer cannot be cast to a
u32 in a meaningful way. Use an temporary variable and cast to
unsigned long.

Suggested-by: David Laight <David.Laight@ACULAB.COM>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/smsc/smc911x.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/smsc/smc911x.c
index ac1a764364fb..5b0041996f1f 100644
--- a/drivers/net/ethernet/smsc/smc911x.c
+++ b/drivers/net/ethernet/smsc/smc911x.c
@@ -448,6 +448,7 @@ static void smc911x_hardware_send_pkt(struct net_device *dev)
 	struct sk_buff *skb;
 	unsigned int cmdA, cmdB, len;
 	unsigned char *buf;
+	int offset;
 
 	DBG(SMC_DEBUG_FUNC | SMC_DEBUG_TX, dev, "--> %s\n", __func__);
 	BUG_ON(lp->pending_tx_skb == NULL);
@@ -465,9 +466,10 @@ static void smc911x_hardware_send_pkt(struct net_device *dev)
 			TX_CMD_A_INT_FIRST_SEG_ | TX_CMD_A_INT_LAST_SEG_ |
 			skb->len;
 #else
-	buf = (char*)((u32)skb->data & ~0x3);
-	len = (skb->len + 3 + ((u32)skb->data & 3)) & ~0x3;
-	cmdA = (((u32)skb->data & 0x3) << 16) |
+	offset = (unsigned long)skb->data & 3;
+	buf = skb->data - offset;
+	len = skb->len + offset;
+	cmdA = (offset << 16) |
 			TX_CMD_A_INT_FIRST_SEG_ | TX_CMD_A_INT_LAST_SEG_ |
 			skb->len;
 #endif
-- 
2.28.0

