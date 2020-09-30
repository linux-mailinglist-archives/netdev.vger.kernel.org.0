Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A13B27EB71
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 16:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730621AbgI3OxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 10:53:14 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:23786 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730196AbgI3OxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 10:53:13 -0400
Received: from tomoyo.flets-east.jp ([153.230.197.127])
        by mwinf5d69 with ME
        id aEsz2300N2lQRaH03Et73J; Wed, 30 Sep 2020 16:53:12 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Wed, 30 Sep 2020 16:53:12 +0200
X-ME-IP: 153.230.197.127
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-usb@vger.kernel.org (open list:USB ACM DRIVER)
Subject: [PATCH v2 3/6] can: dev: __can_get_echo_skb(): fix the return length
Date:   Wed, 30 Sep 2020 23:45:30 +0900
Message-Id: <20200930144602.10290-4-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200926175810.278529-1-mailhol.vincent@wanadoo.fr>
References: <20200926175810.278529-1-mailhol.vincent@wanadoo.fr>
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

