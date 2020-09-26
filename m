Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF461279B8F
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 19:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbgIZRqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 13:46:22 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:45913 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729997AbgIZRqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 13:46:20 -0400
Received: from tomoyo.flets-east.jp ([153.230.197.127])
        by mwinf5d89 with ME
        id Yhlm230082lQRaH03hmF5X; Sat, 26 Sep 2020 19:46:18 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Sat, 26 Sep 2020 19:46:18 +0200
X-ME-IP: 153.230.197.127
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] can: dev: __can_get_echo_skb(): fix the return length
Date:   Sun, 27 Sep 2020 02:45:33 +0900
Message-Id: <20200926174542.278166-4-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200926174542.278166-1-mailhol.vincent@wanadoo.fr>
References: <20200926174542.278166-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The length of Remote Transmission Request (RTR) frames is always 0
bytes. The DLC represents the requested length, not the actual length
of the RTR. But __can_get_echo_skb() returns the DLC value regardless.

Apply get_can_len() function to retrieve the correct length.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/dev.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index e291fda395a0..8c3e11820e03 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -481,14 +481,9 @@ __can_get_echo_skb(struct net_device *dev, unsigned int idx, u8 *len_ptr)
 	}
 
 	if (priv->echo_skb[idx]) {
-		/* Using "struct canfd_frame::len" for the frame
-		 * length is supported on both CAN and CANFD frames.
-		 */
 		struct sk_buff *skb = priv->echo_skb[idx];
-		struct canfd_frame *cf = (struct canfd_frame *)skb->data;
-		u8 len = cf->len;
 
-		*len_ptr = len;
+		*len_ptr = get_can_len(skb);
 		priv->echo_skb[idx] = NULL;
 
 		return skb;
-- 
2.26.2

