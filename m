Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346BC3EC6F0
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 05:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234990AbhHODec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 23:34:32 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:54545 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236314AbhHODea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 23:34:30 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by mwinf5d21 with ME
        id hfZ7250050zjR6y03fZyy5; Sun, 15 Aug 2021 05:34:00 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Sun, 15 Aug 2021 05:34:00 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <Stefan.Maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v5 4/7] can: dev: add can_tdc_get_relative_tdco() helper function
Date:   Sun, 15 Aug 2021 12:32:45 +0900
Message-Id: <20210815033248.98111-5-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct can_tdc::tdco represents the absolute offset from TDCV. Some
controllers use instead an offset relative to the Sample Point (SP)
such that:
| SSP = TDCV + absolute TDCO
|     = TDCV + SP + relative TDCO

Consequently:
| relative TDCO = absolute TDCO - SP

The function can_tdc_get_relative_tdco() allow to retrieve this
relative TDCO value.

CC: Stefan Mätje <Stefan.Maetje@esd.eu>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 include/linux/can/dev.h | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 0be982fd22fb..fa75e29182a3 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -93,6 +93,35 @@ static inline bool can_tdc_is_enabled(const struct can_priv *priv)
 	return !!(priv->ctrlmode & CAN_CTRLMODE_TDC_MASK);
 }
 
+/*
+ * can_get_relative_tdco() - TDCO relative to the sample point
+ *
+ * struct can_tdc::tdco represents the absolute offset from TDCV. Some
+ * controllers use instead an offset relative to the Sample Point (SP)
+ * such that:
+ *
+ * SSP = TDCV + absolute TDCO
+ *     = TDCV + SP + relative TDCO
+ *
+ * -+----------- one bit ----------+-- TX pin
+ *  |<--- Sample Point --->|
+ *
+ *                         --+----------- one bit ----------+-- RX pin
+ *  |<-------- TDCV -------->|
+ *                           |<------------------------>| absolute TDCO
+ *                           |<--- Sample Point --->|
+ *                           |                      |<->| relative TDCO
+ *  |<------------- Secondary Sample Point ------------>|
+ */
+static inline s32 can_get_relative_tdco(const struct can_priv *priv)
+{
+	const struct can_bittiming *dbt = &priv->data_bittiming;
+	s32 sample_point_in_tc =  (CAN_SYNC_SEG + dbt->prop_seg +
+				   dbt->phase_seg1) * dbt->brp;
+
+	return (s32)priv->tdc.tdco - sample_point_in_tc;
+}
+
 /* helper to define static CAN controller features at device creation time */
 static inline void can_set_static_ctrlmode(struct net_device *dev,
 					   u32 static_mode)
-- 
2.31.1

