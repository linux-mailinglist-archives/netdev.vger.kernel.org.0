Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A411E27EB65
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 16:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730104AbgI3OvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 10:51:17 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:47118 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbgI3OvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 10:51:16 -0400
Received: from tomoyo.flets-east.jp ([153.230.197.127])
        by mwinf5d69 with ME
        id aEqx2300T2lQRaH03Er8kM; Wed, 30 Sep 2020 16:51:15 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Wed, 30 Sep 2020 16:51:15 +0200
X-ME-IP: 153.230.197.127
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        linux-usb@vger.kernel.org (open list:USB ACM DRIVER)
Subject: [PATCH v2 2/6] can: dev: add a helper function to get the correct length of Classical frames
Date:   Wed, 30 Sep 2020 23:45:29 +0900
Message-Id: <20200930144602.10290-3-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200926175810.278529-1-mailhol.vincent@wanadoo.fr>
References: <20200926175810.278529-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In classical CAN, the length of the data (i.e. CAN payload) is not
always equal to the DLC! If the frame is a Remote Transmission Request
(RTR), data length is always zero regardless of DLC value and else, if
the DLC is greater than 8, the length is 8. Contrary to common belief,
ISO 11898-1 Chapter 8.4.2.3 (DLC field) do allow DLCs greater than 8
for Classical Frames and specifies that those DLCs shall indicate that
the data field is 8 bytes long.

Above facts are widely unknown and so many developpers uses the "len"
field of "struct canfd_frame" to get the length of classical CAN
frames: this is incorrect!

This patch introduces function get_can_len() which can be used in
remediation. The function takes the SKB as an input in order to be
able to determine if the frame is classical or FD.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 include/linux/can/dev.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 5e3d45525bd3..72a8a60c0094 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -177,6 +177,29 @@ u8 can_dlc2len(u8 can_dlc);
 /* map the sanitized data length to an appropriate data length code */
 u8 can_len2dlc(u8 len);
 
+/*
+ * get_can_len(skb) - get the length of the CAN payload.
+ *
+ * In classical CAN, the length of the data (i.e. CAN payload) is not
+ * always equal to the DLC! If the frame is a Remote Transmission
+ * Request (RTR), data length is always zero regardless of DLC value
+ * and else, if the DLC is greater than 8, the length is 8. Contrary
+ * to common belief, ISO 11898-1 Chapter 8.4.2.3 (DLC field) do allow
+ * DLCs greater than 8 for Classical Frames and specifies that those
+ * DLCs shall indicate that the data field is 8 bytes long.
+ */
+static inline int get_can_len(struct sk_buff *skb)
+{
+	struct canfd_frame *cf = (struct canfd_frame *)skb->data;
+
+	if (can_is_canfd_skb(skb))
+		return min_t(__u8, cf->len, CANFD_MAX_DLEN);
+	else if (cf->can_id & CAN_RTR_FLAG)
+		return 0;
+	else
+		return min_t(__u8, cf->len, CAN_MAX_DLEN);
+}
+
 struct net_device *alloc_candev_mqs(int sizeof_priv, unsigned int echo_skb_max,
 				    unsigned int txqs, unsigned int rxqs);
 #define alloc_candev(sizeof_priv, echo_skb_max) \
-- 
2.26.2

