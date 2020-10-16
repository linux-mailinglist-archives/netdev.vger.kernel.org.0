Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44882290A6A
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 19:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390356AbgJPRQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 13:16:22 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:59793 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728367AbgJPRQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 13:16:17 -0400
Received: from tomoyo.flets-east.jp ([153.230.197.127])
        by mwinf5d46 with ME
        id ghG42300F2lQRaH03hGCKe; Fri, 16 Oct 2020 19:16:16 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Fri, 16 Oct 2020 19:16:16 +0200
X-ME-IP: 153.230.197.127
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH v4 1/4] can: dev: can_get_echo_skb(): prevent call to kfree_skb() in hard IRQ context
Date:   Sat, 17 Oct 2020 02:13:30 +0900
Message-Id: <20201016171402.229001-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201016171402.229001-1-mailhol.vincent@wanadoo.fr>
References: <20201016171402.229001-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a driver calls can_get_echo_skb() during a hardware IRQ (which is
often, but not always, the case), the 'WARN_ON(in_irq)' in
net/core/skbuff.c#skb_release_head_state() might be triggered, under
network congestion circumstances, together with the potential risk of
a NULL pointer dereference.

The root cause of this issue is the call to kfree_skb() instead of
dev_kfree_skb_irq() in net/core/dev.c#enqueue_to_backlog().

This patch prevents the skb to be freed within the call to netif_rx()
by incrementing its reference count with skb_get(). The skb is finally
freed by one of the in-irq-context safe functions:
dev_consume_skb_any() or dev_kfree_skb_any().  The "any" version is
used because some drivers might call can_get_echo_skb() in a normal
context.

The reason for this issue to occur is that initially, in the core
network stack, loopback skb were not supposed to be received in
hardware IRQ context. The CAN stack is an exeption.

This bug was previously reported back in 2017 in [1] but the proposed
patch never got accepted.

While [1] directly modifies net/core/dev.c, we try to propose here a
smoother modification local to CAN network stack (the assumption
behind is that only CAN devices are affected by this issue).

[1] https://patchwork.ozlabs.org/patch/835236/

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---

Changes in v3 and v4: None

Changes in v2:
 - Minor changes of link format in the changelog.
---
 drivers/net/can/dev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index b70ded3760f2..73cfcd7e9517 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -538,7 +538,11 @@ unsigned int can_get_echo_skb(struct net_device *dev, unsigned int idx)
 	if (!skb)
 		return 0;
 
-	netif_rx(skb);
+	skb_get(skb);
+	if (netif_rx(skb) == NET_RX_SUCCESS)
+		dev_consume_skb_any(skb);
+	else
+		dev_kfree_skb_any(skb);
 
 	return len;
 }
-- 
2.26.2

