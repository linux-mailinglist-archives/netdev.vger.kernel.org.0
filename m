Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E254B290A95
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 19:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391520AbgJPRXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 13:23:11 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:58009 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391301AbgJPRXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 13:23:11 -0400
Received: from tomoyo.flets-east.jp ([153.230.197.127])
        by mwinf5d44 with ME
        id ghNj2300m2lQRaH03hP5Kz; Fri, 16 Oct 2020 19:23:09 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Fri, 16 Oct 2020 19:23:09 +0200
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
Subject: [PATCH v4 3/4] can: dev: __can_get_echo_skb(): fix the return length
Date:   Sat, 17 Oct 2020 02:22:11 +0900
Message-Id: <20201016172240.229359-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201016171402.229001-1-mailhol.vincent@wanadoo.fr>
References: <20201016171402.229001-1-mailhol.vincent@wanadoo.fr>
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

Changes in v2 to v4: None
---
 drivers/net/can/dev.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 73cfcd7e9517..8f91d23c1ca7 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -507,14 +507,9 @@ __can_get_echo_skb(struct net_device *dev, unsigned int idx, u8 *len_ptr)
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

