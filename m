Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8782A1232
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgJaAu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:50:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55822 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbgJaAuT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 20:50:19 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYf5z-004Rie-Ha; Sat, 31 Oct 2020 01:50:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 6/7] drivers: net: smc911x: Fix cast from pointer to integer of different size
Date:   Sat, 31 Oct 2020 01:49:57 +0100
Message-Id: <20201031004958.1059797-7-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201031004958.1059797-1-andrew@lunn.ch>
References: <20201031004958.1059797-1-andrew@lunn.ch>
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
u32 in a meaningful way. Use long instead.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/smsc/smc911x.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/smsc/smc911x.c
index 4ec292563f38..f37832540364 100644
--- a/drivers/net/ethernet/smsc/smc911x.c
+++ b/drivers/net/ethernet/smsc/smc911x.c
@@ -466,9 +466,9 @@ static void smc911x_hardware_send_pkt(struct net_device *dev)
 			TX_CMD_A_INT_FIRST_SEG_ | TX_CMD_A_INT_LAST_SEG_ |
 			skb->len;
 #else
-	buf = (char*)((u32)skb->data & ~0x3);
-	len = (skb->len + 3 + ((u32)skb->data & 3)) & ~0x3;
-	cmdA = (((u32)skb->data & 0x3) << 16) |
+	buf = (char *)((long)skb->data & ~0x3);
+	len = (skb->len + 3 + ((long)skb->data & 3)) & ~0x3;
+	cmdA = (((long)skb->data & 0x3) << 16) |
 			TX_CMD_A_INT_FIRST_SEG_ | TX_CMD_A_INT_LAST_SEG_ |
 			skb->len;
 #endif
-- 
2.28.0

