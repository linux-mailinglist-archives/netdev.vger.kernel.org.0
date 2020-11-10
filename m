Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545522AD373
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 11:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731831AbgKJKT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 05:19:27 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.84]:32990 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731106AbgKJKTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 05:19:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1605003546;
        s=strato-dkim-0002; d=hartkopp.net;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=YvpqB0xJCuWRpBeC2un0LqxQx1LgqTTH8Kl4db4+eNc=;
        b=pmCfNJEySajdqWhZ5zlqC0k50I1X9aaXR0/z0c859GGV54FkH4MOVnqaFZ3gsc+Xpj
        VgnAqWXjtSv1IF86Jh9QGOlID+jvdurgeMoO8PYM/8htX5h6PPL9BqZmQkdG1KXcI0Fe
        4USl+JlnVoLYfnxGlT7lLimOqRkpaNwBy+a6cEEnpzjxsZHgzsfDWpqsgjuf4iVyXJ9/
        AUdUwzPp0eQnwpWGs9mXSiJtebx3IxpOEWLpOBgYg/S8tBL0VkLquJD+5Ct0TXnEDLK5
        lwRvQR1ZRsLO/c9yg94NXQKRiPVi1WfdX2riVfBLdmH6aC/J3ljc/rrP4cIRWJnRita3
        dQHw==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0k+8CejudJywjsi+/Fw=="
X-RZG-CLASS-ID: mo00
Received: from silver.lan
        by smtp.strato.de (RZmta 47.3.3 DYNA|AUTH)
        with ESMTPSA id V0298cwAAAJ4AQk
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 10 Nov 2020 11:19:04 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     linux-can@vger.kernel.org, mkl@pengutronix.de,
        mailhol.vincent@wanadoo.fr
Cc:     netdev@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH v6 7/8] can-dev: introduce helpers to access Classical CAN DLC values
Date:   Tue, 10 Nov 2020 11:18:51 +0100
Message-Id: <20201110101852.1973-8-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201110101852.1973-1-socketcan@hartkopp.net>
References: <20201110101852.1973-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

can_get_cc_dlc: get the data length code for Classical CAN raw DLC access
can_get_cc_len: get len and len8_dlc value for Classical CAN raw DLC access

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 include/linux/can/dev.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index e767a96ae075..9a787f73399e 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -168,10 +168,38 @@ static inline bool can_is_canfd_skb(const struct sk_buff *skb)
 {
 	/* the CAN specific type of skb is identified by its data length */
 	return skb->len == CANFD_MTU;
 }
 
+/* helper to get the data length code (DLC) for Classical CAN raw DLC access */
+static inline u8 can_get_cc_dlc(const u32 ctrlmode, const struct can_frame *cf)
+{
+	/* return len8_dlc as dlc value only if all conditions apply */
+	if ((ctrlmode & CAN_CTRLMODE_CC_LEN8_DLC) &&
+	    (cf->len == CAN_MAX_DLEN) &&
+	    (cf->len8_dlc > CAN_MAX_DLEN && cf->len8_dlc <= CAN_MAX_RAW_DLC))
+		return cf->len8_dlc;
+
+	/* return the payload length as dlc value */
+	return cf->len;
+}
+
+/* helper to get len and len8_dlc value for Classical CAN raw DLC access */
+static inline u8 can_get_cc_len(const u32 ctrlmode, struct can_frame *cf,
+				u8 dlc)
+{
+	/* the caller already ensured that dlc is a value from 0 .. 15 */
+	if ((ctrlmode & CAN_CTRLMODE_CC_LEN8_DLC) && (dlc > CAN_MAX_DLEN))
+		cf->len8_dlc = dlc;
+
+	/* limit the payload length 'len' to CAN_MAX_DLEN */
+	if (dlc > CAN_MAX_DLEN)
+		return CAN_MAX_DLEN;
+
+	return dlc;
+}
+
 /* helper to define static CAN controller features at device creation time */
 static inline void can_set_static_ctrlmode(struct net_device *dev,
 					   u32 static_mode)
 {
 	struct can_priv *priv = netdev_priv(dev);
-- 
2.28.0

