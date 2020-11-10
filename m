Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD77B2ACB78
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 04:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731192AbgKJDDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 22:03:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44932 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730911AbgKJDDM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 22:03:12 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kcJw4-006D8m-3z; Tue, 10 Nov 2020 04:03:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 net-next 6/7] drivers: net: smc911x: Fix cast from pointer to integer of different size
Date:   Tue, 10 Nov 2020 04:02:47 +0100
Message-Id: <20201110030248.1480413-7-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110030248.1480413-1-andrew@lunn.ch>
References: <20201110030248.1480413-1-andrew@lunn.ch>
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
u32 in a meaningful way. Use uintptr_t instead.

Suggested-by: Nicolas Pitre <nico@fluxnic.net>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/smsc/smc911x.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/smsc/smc911x.c
index ac1a764364fb..22cdbf12c823 100644
--- a/drivers/net/ethernet/smsc/smc911x.c
+++ b/drivers/net/ethernet/smsc/smc911x.c
@@ -465,9 +465,9 @@ static void smc911x_hardware_send_pkt(struct net_device *dev)
 			TX_CMD_A_INT_FIRST_SEG_ | TX_CMD_A_INT_LAST_SEG_ |
 			skb->len;
 #else
-	buf = (char*)((u32)skb->data & ~0x3);
-	len = (skb->len + 3 + ((u32)skb->data & 3)) & ~0x3;
-	cmdA = (((u32)skb->data & 0x3) << 16) |
+	buf = (char *)((uintptr_t)skb->data & ~0x3);
+	len = (skb->len + 3 + ((uintptr_t)skb->data & 3)) & ~0x3;
+	cmdA = (((uintptr_t)skb->data & 0x3) << 16) |
 			TX_CMD_A_INT_FIRST_SEG_ | TX_CMD_A_INT_LAST_SEG_ |
 			skb->len;
 #endif
-- 
2.29.2

