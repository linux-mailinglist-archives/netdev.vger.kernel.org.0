Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4954105CA
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 11:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244395AbhIRJ7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 05:59:18 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:63617 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244731AbhIRJ7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Sep 2021 05:59:15 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id RX5Zmuh4X1yYBRX6Lm0kHp; Sat, 18 Sep 2021 11:57:51 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Sat, 18 Sep 2021 11:57:51 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <Stefan.Maetje@esd.eu>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v6 4/6] can: netlink: add interface for CAN-FD Transmitter Delay Compensation (TDC)
Date:   Sat, 18 Sep 2021 18:56:35 +0900
Message-Id: <20210918095637.20108-5-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210918095637.20108-1-mailhol.vincent@wanadoo.fr>
References: <20210918095637.20108-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the netlink interface for TDC parameters of struct can_tdc_const
and can_tdc.

Contrary to the can_bittiming(_const) structures for which there is
just a single IFLA_CAN(_DATA)_BITTMING(_CONST) entry per structure,
here, we create a nested entry IFLA_CAN_TDC. Within this nested entry,
additional IFLA_CAN_TDC_TDC* entries are added for each of the TDC
parameters of the newly introduced struct can_tdc_const and struct
can_tdc.

For struct can_tdc_const, these are:
        IFLA_CAN_TDC_TDCV_MIN
        IFLA_CAN_TDC_TDCV_MAX
        IFLA_CAN_TDC_TDCO_MIN
        IFLA_CAN_TDC_TDCO_MAX
        IFLA_CAN_TDC_TDCF_MIN
        IFLA_CAN_TDC_TDCF_MAX

For struct can_tdc, these are:
        IFLA_CAN_TDC_TDCV
        IFLA_CAN_TDC_TDCO
        IFLA_CAN_TDC_TDCF

This is done so that changes can be applied in the future to the
structures without breaking the netlink interface.

The TDC netlink logic works as follow:

 * CAN_CTRLMODE_FD is not provided:
    - if any TDC parameters are provided: error.

    - TDC parameters not provided: TDC parameters unchanged.

 * CAN_CTRLMODE_FD is provided and is false:
     - TDC is deactivated: both the structure and the
       CAN_CTRLMODE_TDC_{AUTO,MANUAL} flags are flushed.

 * CAN_CTRLMODE_FD provided and is true:
    - CAN_CTRLMODE_TDC_{AUTO,MANUAL} and tdc{v,o,f} not provided: call
      can_calc_tdco() to automatically decide whether TDC should be
      activated and, if so, set CAN_CTRLMODE_TDC_AUTO and uses the
      calculated tdco value.

    - CAN_CTRLMODE_TDC_AUTO and tdco provided: set
      CAN_CTRLMODE_TDC_AUTO and use the provided tdco value. Here,
      tdcv is illegal and tdcf is optional.

    - CAN_CTRLMODE_TDC_MANUAL and both of tdcv and tdco provided: set
      CAN_CTRLMODE_TDC_MANUAL and use the provided tdcv and tdco
      value. Here, tdcf is optional.

    - CAN_CTRLMODE_TDC_{AUTO,MANUAL} are mutually exclusive. Whenever
      one flag is turned on, the other will automatically be turned
      off. Providing both returns an error.

    - Combination other than the one listed above are illegal and will
      return an error.

N.B. above rules mean that whenever CAN_CTRLMODE_FD is provided, the
previous TDC values will be overwritten. The only option to reuse
previous TDC value is to not provide CAN_CTRLMODE_FD.


All the new parameters are defined as u32. This arbitrary choice is
done to mimic the other bittiming values with are also all of type
u32. An u16 would have been sufficient to hold the TDC values.

This patch completes below series (c.f. [1]):
  - commit 289ea9e4ae59 ("can: add new CAN FD bittiming parameters:
    Transmitter Delay Compensation (TDC)")
  - commit c25cc7993243 ("can: bittiming: add calculation for CAN FD
    Transmitter Delay Compensation (TDC)")

[1] https://lore.kernel.org/linux-can/20210224002008.4158-1-mailhol.vincent@wanadoo.fr/T/#t

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/dev/netlink.c    | 213 ++++++++++++++++++++++++++++++-
 include/uapi/linux/can/netlink.h |  29 ++++-
 2 files changed, 235 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index e79c9a2ffbfc..c77cc6ae88b6 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -2,6 +2,7 @@
 /* Copyright (C) 2005 Marc Kleine-Budde, Pengutronix
  * Copyright (C) 2006 Andrey Volkov, Varma Electronics
  * Copyright (C) 2008-2009 Wolfgang Grandegger <wg@grandegger.com>
+ * Copyright (C) 2021 Vincent Mailhol <mailhol.vincent@wanadoo.fr>
  */
 
 #include <linux/can/dev.h>
@@ -19,6 +20,19 @@ static const struct nla_policy can_policy[IFLA_CAN_MAX + 1] = {
 	[IFLA_CAN_DATA_BITTIMING] = { .len = sizeof(struct can_bittiming) },
 	[IFLA_CAN_DATA_BITTIMING_CONST]	= { .len = sizeof(struct can_bittiming_const) },
 	[IFLA_CAN_TERMINATION] = { .type = NLA_U16 },
+	[IFLA_CAN_TDC] = { .type = NLA_NESTED },
+};
+
+static const struct nla_policy can_tdc_policy[IFLA_CAN_TDC_MAX + 1] = {
+	[IFLA_CAN_TDC_TDCV_MIN] = { .type = NLA_U32 },
+	[IFLA_CAN_TDC_TDCV_MAX] = { .type = NLA_U32 },
+	[IFLA_CAN_TDC_TDCO_MIN] = { .type = NLA_U32 },
+	[IFLA_CAN_TDC_TDCO_MAX] = { .type = NLA_U32 },
+	[IFLA_CAN_TDC_TDCF_MIN] = { .type = NLA_U32 },
+	[IFLA_CAN_TDC_TDCF_MAX] = { .type = NLA_U32 },
+	[IFLA_CAN_TDC_TDCV] = { .type = NLA_U32 },
+	[IFLA_CAN_TDC_TDCO] = { .type = NLA_U32 },
+	[IFLA_CAN_TDC_TDCF] = { .type = NLA_U32 },
 };
 
 static int can_validate(struct nlattr *tb[], struct nlattr *data[],
@@ -30,6 +44,7 @@ static int can_validate(struct nlattr *tb[], struct nlattr *data[],
 	 * - nominal/arbitration bittiming
 	 * - data bittiming
 	 * - control mode with CAN_CTRLMODE_FD set
+	 * - TDC parameters are coherent (details below)
 	 */
 
 	if (!data)
@@ -37,8 +52,43 @@ static int can_validate(struct nlattr *tb[], struct nlattr *data[],
 
 	if (data[IFLA_CAN_CTRLMODE]) {
 		struct can_ctrlmode *cm = nla_data(data[IFLA_CAN_CTRLMODE]);
+		u32 tdc_flags = cm->flags & CAN_CTRLMODE_TDC_MASK;
 
 		is_can_fd = cm->flags & cm->mask & CAN_CTRLMODE_FD;
+
+		/* CAN_CTRLMODE_TDC_{AUTO,MANUAL} are mutually exclusive */
+		if (tdc_flags == CAN_CTRLMODE_TDC_MASK)
+			return -EOPNOTSUPP;
+		/* If one of the CAN_CTRLMODE_TDC_* flag is set then
+		 * TDC must be set and vice-versa
+		 */
+		if (!!tdc_flags != !!data[IFLA_CAN_TDC])
+			return -EOPNOTSUPP;
+		/* If providing TDC parameters, at least TDCO is
+		 * needed. TDCV is needed if and only if
+		 * CAN_CTRLMODE_TDC_MANUAL is set
+		 */
+		if (data[IFLA_CAN_TDC]) {
+			struct nlattr *tb_tdc[IFLA_CAN_TDC_MAX + 1];
+			int err;
+
+			err = nla_parse_nested(tb_tdc, IFLA_CAN_TDC_MAX,
+					       data[IFLA_CAN_TDC],
+					       can_tdc_policy, extack);
+			if (err)
+				return err;
+
+			if (tb_tdc[IFLA_CAN_TDC_TDCV]) {
+				if (tdc_flags & CAN_CTRLMODE_TDC_AUTO)
+					return -EOPNOTSUPP;
+			} else {
+				if (tdc_flags & CAN_CTRLMODE_TDC_MANUAL)
+					return -EOPNOTSUPP;
+			}
+
+			if (!tb_tdc[IFLA_CAN_TDC_TDCO])
+				return -EOPNOTSUPP;
+		}
 	}
 
 	if (is_can_fd) {
@@ -46,7 +96,7 @@ static int can_validate(struct nlattr *tb[], struct nlattr *data[],
 			return -EOPNOTSUPP;
 	}
 
-	if (data[IFLA_CAN_DATA_BITTIMING]) {
+	if (data[IFLA_CAN_DATA_BITTIMING] || data[IFLA_CAN_TDC]) {
 		if (!is_can_fd)
 			return -EOPNOTSUPP;
 	}
@@ -54,11 +104,60 @@ static int can_validate(struct nlattr *tb[], struct nlattr *data[],
 	return 0;
 }
 
+static int can_tdc_changelink(struct can_priv *priv, const struct nlattr *nla,
+			      struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb_tdc[IFLA_CAN_TDC_MAX + 1];
+	struct can_tdc tdc = { 0 };
+	const struct can_tdc_const *tdc_const = priv->tdc_const;
+	int err;
+
+	if (!tdc_const || !can_tdc_is_enabled(priv))
+		return -EOPNOTSUPP;
+
+	err = nla_parse_nested(tb_tdc, IFLA_CAN_TDC_MAX, nla,
+			       can_tdc_policy, extack);
+	if (err)
+		return err;
+
+	if (tb_tdc[IFLA_CAN_TDC_TDCV]) {
+		u32 tdcv = nla_get_u32(tb_tdc[IFLA_CAN_TDC_TDCV]);
+
+		if (tdcv < tdc_const->tdcv_min || tdcv > tdc_const->tdcv_max)
+			return -EINVAL;
+
+		tdc.tdcv = tdcv;
+	}
+
+	if (tb_tdc[IFLA_CAN_TDC_TDCO]) {
+		u32 tdco = nla_get_u32(tb_tdc[IFLA_CAN_TDC_TDCO]);
+
+		if (tdco < tdc_const->tdco_min || tdco > tdc_const->tdco_max)
+			return -EINVAL;
+
+		tdc.tdco = tdco;
+	}
+
+	if (tb_tdc[IFLA_CAN_TDC_TDCF]) {
+		u32 tdcf = nla_get_u32(tb_tdc[IFLA_CAN_TDC_TDCF]);
+
+		if (tdcf < tdc_const->tdcf_min || tdcf > tdc_const->tdcf_max)
+			return -EINVAL;
+
+		tdc.tdcf = tdcf;
+	}
+
+	priv->tdc = tdc;
+
+	return 0;
+}
+
 static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 			  struct nlattr *data[],
 			  struct netlink_ext_ack *extack)
 {
 	struct can_priv *priv = netdev_priv(dev);
+	u32 tdc_mask = 0;
 	int err;
 
 	/* We need synchronization with dev->stop() */
@@ -138,7 +237,16 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 			dev->mtu = CAN_MTU;
 			memset(&priv->data_bittiming, 0,
 			       sizeof(priv->data_bittiming));
+			priv->ctrlmode &= ~CAN_CTRLMODE_TDC_MASK;
+			memset(&priv->tdc, 0, sizeof(priv->tdc));
 		}
+
+		tdc_mask = cm->mask & CAN_CTRLMODE_TDC_MASK;
+		/* CAN_CTRLMODE_TDC_{AUTO,MANUAL} are mutually
+		 * exclusive: make sure to turn the other one off
+		 */
+		if (tdc_mask)
+			priv->ctrlmode &= cm->flags | ~CAN_CTRLMODE_TDC_MASK;
 	}
 
 	if (data[IFLA_CAN_RESTART_MS]) {
@@ -187,10 +295,26 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 			return -EINVAL;
 		}
 
-		memcpy(&priv->data_bittiming, &dbt, sizeof(dbt));
+		memset(&priv->tdc, 0, sizeof(priv->tdc));
+		if (data[IFLA_CAN_TDC]) {
+			/* TDC parameters are provided: use them */
+			err = can_tdc_changelink(priv, data[IFLA_CAN_TDC],
+						 extack);
+			if (err) {
+				priv->ctrlmode &= ~CAN_CTRLMODE_TDC_MASK;
+				return err;
+			}
+		} else if (!tdc_mask) {
+			/* Neither of TDC parameters nor TDC flags are
+			 * provided: do calculation
+			 */
+			can_calc_tdco(&priv->tdc, priv->tdc_const, &priv->data_bittiming,
+				      &priv->ctrlmode, priv->ctrlmode_supported);
+		} /* else: both CAN_CTRLMODE_TDC_{AUTO,MANUAL} are explicitly
+		   * turned off. TDC is disabled: do nothing
+		   */
 
-		can_calc_tdco(&priv->tdc, priv->tdc_const, &priv->data_bittiming,
-			      &priv->ctrlmode, priv->ctrlmode_supported);
+		memcpy(&priv->data_bittiming, &dbt, sizeof(dbt));
 
 		if (priv->do_set_data_bittiming) {
 			/* Finally, set the bit-timing registers */
@@ -227,6 +351,37 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 	return 0;
 }
 
+static size_t can_tdc_get_size(const struct net_device *dev)
+{
+	struct can_priv *priv = netdev_priv(dev);
+	size_t size;
+
+	if (!priv->tdc_const)
+		return 0;
+
+	size = nla_total_size(0);			/* nest IFLA_CAN_TDC */
+	if (priv->ctrlmode_supported & CAN_CTRLMODE_TDC_MANUAL) {
+		size += nla_total_size(sizeof(u32));	/* IFLA_CAN_TDCV_MIN */
+		size += nla_total_size(sizeof(u32));	/* IFLA_CAN_TDCV_MAX */
+	}
+	size += nla_total_size(sizeof(u32));		/* IFLA_CAN_TDCO_MIN */
+	size += nla_total_size(sizeof(u32));		/* IFLA_CAN_TDCO_MAX */
+	if (priv->tdc_const->tdcf_max) {
+		size += nla_total_size(sizeof(u32));	/* IFLA_CAN_TDCF_MIN */
+		size += nla_total_size(sizeof(u32));	/* IFLA_CAN_TDCF_MAX */
+	}
+
+	if (can_tdc_is_enabled(priv)) {
+		if (priv->ctrlmode & CAN_CTRLMODE_TDC_MANUAL)
+			size += nla_total_size(sizeof(u32));	/* IFLA_CAN_TDCV */
+		size += nla_total_size(sizeof(u32));		/* IFLA_CAN_TDCO */
+		if (priv->tdc_const->tdcf_max)
+			size += nla_total_size(sizeof(u32));	/* IFLA_CAN_TDCF */
+	}
+
+	return size;
+}
+
 static size_t can_get_size(const struct net_device *dev)
 {
 	struct can_priv *priv = netdev_priv(dev);
@@ -258,10 +413,56 @@ static size_t can_get_size(const struct net_device *dev)
 		size += nla_total_size(sizeof(*priv->data_bitrate_const) *
 				       priv->data_bitrate_const_cnt);
 	size += sizeof(priv->bitrate_max);			/* IFLA_CAN_BITRATE_MAX */
+	size += can_tdc_get_size(dev);				/* IFLA_CAN_TDC */
 
 	return size;
 }
 
+static int can_tdc_fill_info(struct sk_buff *skb, const struct net_device *dev)
+{
+	struct nlattr *nest;
+	struct can_priv *priv = netdev_priv(dev);
+	struct can_tdc *tdc = &priv->tdc;
+	const struct can_tdc_const *tdc_const = priv->tdc_const;
+
+	if (!tdc_const)
+		return 0;
+
+	nest = nla_nest_start(skb, IFLA_CAN_TDC);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (priv->ctrlmode_supported & CAN_CTRLMODE_TDC_MANUAL &&
+	    (nla_put_u32(skb, IFLA_CAN_TDC_TDCV_MIN, tdc_const->tdcv_min) ||
+	     nla_put_u32(skb, IFLA_CAN_TDC_TDCV_MAX, tdc_const->tdcv_max)))
+		goto err_cancel;
+	if (nla_put_u32(skb, IFLA_CAN_TDC_TDCO_MIN, tdc_const->tdco_min) ||
+	    nla_put_u32(skb, IFLA_CAN_TDC_TDCO_MAX, tdc_const->tdco_max))
+		goto err_cancel;
+	if (tdc_const->tdcf_max &&
+	    (nla_put_u32(skb, IFLA_CAN_TDC_TDCF_MIN, tdc_const->tdcf_min) ||
+	     nla_put_u32(skb, IFLA_CAN_TDC_TDCF_MAX, tdc_const->tdcf_max)))
+		goto err_cancel;
+
+	if (can_tdc_is_enabled(priv)) {
+		if (priv->ctrlmode & CAN_CTRLMODE_TDC_MANUAL &&
+		    nla_put_u32(skb, IFLA_CAN_TDC_TDCV, tdc->tdcv))
+			goto err_cancel;
+		if (nla_put_u32(skb, IFLA_CAN_TDC_TDCO, tdc->tdco))
+			goto err_cancel;
+		if (tdc_const->tdcf_max &&
+		    nla_put_u32(skb, IFLA_CAN_TDC_TDCF, tdc->tdcf))
+			goto err_cancel;
+	}
+
+	nla_nest_end(skb, nest);
+	return 0;
+
+err_cancel:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
 static int can_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
 	struct can_priv *priv = netdev_priv(dev);
@@ -319,7 +520,9 @@ static int can_fill_info(struct sk_buff *skb, const struct net_device *dev)
 
 	    (nla_put(skb, IFLA_CAN_BITRATE_MAX,
 		     sizeof(priv->bitrate_max),
-		     &priv->bitrate_max))
+		     &priv->bitrate_max)) ||
+
+	    (can_tdc_fill_info(skb, dev))
 	    )
 
 		return -EMSGSIZE;
diff --git a/include/uapi/linux/can/netlink.h b/include/uapi/linux/can/netlink.h
index 004cd09a7d49..75b85c60efb2 100644
--- a/include/uapi/linux/can/netlink.h
+++ b/include/uapi/linux/can/netlink.h
@@ -136,10 +136,35 @@ enum {
 	IFLA_CAN_BITRATE_CONST,
 	IFLA_CAN_DATA_BITRATE_CONST,
 	IFLA_CAN_BITRATE_MAX,
-	__IFLA_CAN_MAX
+	IFLA_CAN_TDC,
+
+	/* add new constants above here */
+	__IFLA_CAN_MAX,
+	IFLA_CAN_MAX = __IFLA_CAN_MAX - 1
 };
 
-#define IFLA_CAN_MAX	(__IFLA_CAN_MAX - 1)
+/*
+ * CAN FD Transmitter Delay Compensation (TDC)
+ *
+ * Please refer to struct can_tdc_const and can_tdc in
+ * include/linux/can/bittiming.h for further details.
+ */
+enum {
+	IFLA_CAN_TDC_UNSPEC,
+	IFLA_CAN_TDC_TDCV_MIN,	/* u32 */
+	IFLA_CAN_TDC_TDCV_MAX,	/* u32 */
+	IFLA_CAN_TDC_TDCO_MIN,	/* u32 */
+	IFLA_CAN_TDC_TDCO_MAX,	/* u32 */
+	IFLA_CAN_TDC_TDCF_MIN,	/* u32 */
+	IFLA_CAN_TDC_TDCF_MAX,	/* u32 */
+	IFLA_CAN_TDC_TDCV,	/* u32 */
+	IFLA_CAN_TDC_TDCO,	/* u32 */
+	IFLA_CAN_TDC_TDCF,	/* u32 */
+
+	/* add new constants above here */
+	__IFLA_CAN_TDC,
+	IFLA_CAN_TDC_MAX = __IFLA_CAN_TDC - 1
+};
 
 /* u16 termination range: 1..65535 Ohms */
 #define CAN_TERMINATION_DISABLED 0
-- 
2.32.0

