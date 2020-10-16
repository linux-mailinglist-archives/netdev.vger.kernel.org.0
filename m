Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14C1290A84
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 19:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390735AbgJPRV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 13:21:29 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:48659 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390454AbgJPRV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 13:21:29 -0400
Received: from tomoyo.flets-east.jp ([153.230.197.127])
        by mwinf5d44 with ME
        id ghMB2300J2lQRaH03hML2a; Fri, 16 Oct 2020 19:21:26 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Fri, 16 Oct 2020 19:21:26 +0200
X-ME-IP: 153.230.197.127
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH v4 2/4] can: dev: add a helper function to get the correct length of Classical frames
Date:   Sat, 17 Oct 2020 02:20:23 +0900
Message-Id: <20201016172053.229281-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201016171402.229001-1-mailhol.vincent@wanadoo.fr>
References: <20201016171402.229001-1-mailhol.vincent@wanadoo.fr>
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

Changes in v4: None

Changes in v3:
  - Make get_can_len() return u8.
  - Make the skb const.
Reference: https://lkml.org/lkml/2020/9/30/883

Changes in v2: None
---
 include/linux/can/dev.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 41ff31795320..d90890172d2a 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -192,6 +192,29 @@ u8 can_dlc2len(u8 can_dlc);
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
+static inline u8 get_can_len(const struct sk_buff *skb)
+{
+	const struct canfd_frame *cf = (const struct canfd_frame *)skb->data;
+
+	if (can_is_canfd_skb(skb))
+		return min_t(u8, cf->len, CANFD_MAX_DLEN);
+	else if (cf->can_id & CAN_RTR_FLAG)
+		return 0;
+	else
+		return min_t(u8, cf->len, CAN_MAX_DLEN);
+}
+
 struct net_device *alloc_candev_mqs(int sizeof_priv, unsigned int echo_skb_max,
 				    unsigned int txqs, unsigned int rxqs);
 #define alloc_candev(sizeof_priv, echo_skb_max) \
-- 
2.26.2

