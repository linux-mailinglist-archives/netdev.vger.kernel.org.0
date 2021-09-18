Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C84F4105D9
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 11:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244992AbhIRJ75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 05:59:57 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:59027 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244985AbhIRJ7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Sep 2021 05:59:31 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id RX5Zmuh4X1yYBRX6im0kJV; Sat, 18 Sep 2021 11:58:07 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Sat, 18 Sep 2021 11:58:07 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <Stefan.Maetje@esd.eu>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v6 6/6] can: dev: add can_tdc_get_relative_tdco() helper function
Date:   Sat, 18 Sep 2021 18:56:37 +0900
Message-Id: <20210918095637.20108-7-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210918095637.20108-1-mailhol.vincent@wanadoo.fr>
References: <20210918095637.20108-1-mailhol.vincent@wanadoo.fr>
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
Hi Marc,

As Stefan pointed out in:
https://lore.kernel.org/linux-can/79691916e4280970f583a54cd5010ece025a1c53.c
amel@esd.eu/
it seems that no so many CAN devices are using the relative TDCO
(maybe the ESDACC is the only one?). Depending on the output of your
discussion with Microchip and if the mcp25xxfd is indeed using an
absolute tdco, it might make sense to drop this patch from the series.

Yours sincerely,
Vincent
---
 include/linux/can/dev.h | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index b4aa0f048cab..45f19d9db5ca 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -102,6 +102,35 @@ static inline bool can_tdc_is_enabled(const struct can_priv *priv)
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
+	s32 sample_point_in_tc = (CAN_SYNC_SEG + dbt->prop_seg +
+				  dbt->phase_seg1) * dbt->brp;
+
+	return (s32)priv->tdc.tdco - sample_point_in_tc;
+}
+
 /* helper to define static CAN controller features at device creation time */
 static inline void can_set_static_ctrlmode(struct net_device *dev,
 					   u32 static_mode)
-- 
2.32.0

