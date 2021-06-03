Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C7839A447
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 17:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbhFCPSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 11:18:23 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:53167 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232152AbhFCPSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 11:18:22 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by mwinf5d75 with ME
        id CfFu2500H0zjR6y03fGaUc; Thu, 03 Jun 2021 17:16:36 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Thu, 03 Jun 2021 17:16:36 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v2 2/2] can: netlink: add interface for CAN-FD Transmitter Delay Compensation (TDC)
Date:   Fri,  4 Jun 2021 00:15:50 +0900
Message-Id: <20210603151550.140727-3-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603151550.140727-1-mailhol.vincent@wanadoo.fr>
References: <20210603151550.140727-1-mailhol.vincent@wanadoo.fr>
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
        IFLA_CAN_TDC_TDCV_MAX
        IFLA_CAN_TDC_TDCO_MAX
        IFLA_CAN_TDC_TDCF_MAX

For struct can_tdc, these are:
        IFLA_CAN_TDC_TDCV
        IFLA_CAN_TDC_TDCO
        IFLA_CAN_TDC_TDCF

This is done so that changes can be applied in the future to the
structures without breaking the netlink interface.

All the new parameters are defined as u32. This arbitrary choice is
done to mimic the other bittiming values with are also all of type
u32. An u16 would have been sufficient to hold the TDC values.

This patch is the third and last one to introduce TDC in the
kernel. It completes below series:
  - commit 289ea9e4ae59 ("can: add new CAN FD bittiming parameters:
    Transmitter Delay Compensation (TDC)")
  - commit c25cc7993243 ("can: bittiming: add calculation for CAN FD
    Transmitter Delay Compensation (TDC)")

Reference: https://lore.kernel.org/linux-can/20210224002008.4158-1-mailhol.vincent@wanadoo.fr/T/#t

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/dev/netlink.c    | 138 ++++++++++++++++++++++++++++++-
 include/uapi/linux/can/netlink.h |  26 +++++-
 2 files changed, 159 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index 32c603a09809..6134bbf69c10 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -19,6 +19,16 @@ static const struct nla_policy can_policy[IFLA_CAN_MAX + 1] = {
 	[IFLA_CAN_DATA_BITTIMING] = { .len = sizeof(struct can_bittiming) },
 	[IFLA_CAN_DATA_BITTIMING_CONST]	= { .len = sizeof(struct can_bittiming_const) },
 	[IFLA_CAN_TERMINATION] = { .type = NLA_U16 },
+	[IFLA_CAN_TDC] = { .type = NLA_NESTED },
+};
+
+static const struct nla_policy can_tdc_policy[IFLA_CAN_TDC_MAX + 1] = {
+	[IFLA_CAN_TDC_TDCV_MAX] = { .type = NLA_U32 },
+	[IFLA_CAN_TDC_TDCO_MAX] = { .type = NLA_U32 },
+	[IFLA_CAN_TDC_TDCF_MAX] = { .type = NLA_U32 },
+	[IFLA_CAN_TDC_TDCV] = { .type = NLA_U32 },
+	[IFLA_CAN_TDC_TDCO] = { .type = NLA_U32 },
+	[IFLA_CAN_TDC_TDCF] = { .type = NLA_U32 },
 };
 
 static int can_validate(struct nlattr *tb[], struct nlattr *data[],
@@ -46,7 +56,7 @@ static int can_validate(struct nlattr *tb[], struct nlattr *data[],
 			return -EOPNOTSUPP;
 	}
 
-	if (data[IFLA_CAN_DATA_BITTIMING]) {
+	if (data[IFLA_CAN_DATA_BITTIMING] || data[IFLA_CAN_TDC]) {
 		if (!is_can_fd)
 			return -EOPNOTSUPP;
 	}
@@ -54,6 +64,65 @@ static int can_validate(struct nlattr *tb[], struct nlattr *data[],
 	return 0;
 }
 
+static int can_tdc_changelink(struct net_device *dev, const struct nlattr *nla,
+			      struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_CAN_TDC_MAX + 1];
+	struct can_priv *priv = netdev_priv(dev);
+	struct can_tdc *tdc = &priv->tdc;
+	const struct can_tdc_const *tdc_const = priv->tdc_const;
+	int err;
+
+	if (!tdc_const)
+		return -EOPNOTSUPP;
+
+	if (dev->flags & IFF_UP)
+		return -EBUSY;
+
+	err = nla_parse_nested(tb, IFLA_CAN_TDC_MAX, nla,
+			       can_tdc_policy, extack);
+	if (err)
+		return err;
+
+	if (tb[IFLA_CAN_TDC_TDCV]) {
+		u32 tdcv = nla_get_u32(tb[IFLA_CAN_TDC_TDCV]);
+
+		if (tdcv && !tdc_const->tdcv_max)
+			return -EOPNOTSUPP;
+
+		if (tdcv > tdc_const->tdcv_max)
+			return -EINVAL;
+
+		tdc->tdcv = tdcv;
+	}
+
+	if (tb[IFLA_CAN_TDC_TDCO]) {
+		u32 tdco = nla_get_u32(tb[IFLA_CAN_TDC_TDCO]);
+
+		if (tdco && !tdc_const->tdco_max)
+			return -EOPNOTSUPP;
+
+		if (tdco > tdc_const->tdco_max)
+			return -EINVAL;
+
+		tdc->tdco = tdco;
+	}
+
+	if (tb[IFLA_CAN_TDC_TDCF]) {
+		u32 tdcf = nla_get_u32(tb[IFLA_CAN_TDC_TDCF]);
+
+		if (tdcf && !tdc_const->tdcf_max)
+			return -EOPNOTSUPP;
+
+		if (tdcf > tdc_const->tdcf_max)
+			return -EINVAL;
+
+		tdc->tdcf = tdcf;
+	}
+
+	return 0;
+}
+
 static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 			  struct nlattr *data[],
 			  struct netlink_ext_ack *extack)
@@ -220,9 +289,37 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 		priv->termination = termval;
 	}
 
+	if (data[IFLA_CAN_TDC]) {
+		err = can_tdc_changelink(dev, data[IFLA_CAN_TDC], extack);
+		if (err)
+			return err;
+	}
+
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
+	size += nla_total_size(sizeof(u32));		/* IFLA_CAN_TDCV_MAX */
+	size += nla_total_size(sizeof(u32));		/* IFLA_CAN_TDCO_MAX */
+	size += nla_total_size(sizeof(u32));		/* IFLA_CAN_TDCF_MAX */
+
+	if (priv->tdc.tdco) {
+		size += nla_total_size(sizeof(u32));	/* IFLA_CAN_TDCV */
+		size += nla_total_size(sizeof(u32));	/* IFLA_CAN_TDCO */
+		size += nla_total_size(sizeof(u32));	/* IFLA_CAN_TDCF */
+	}
+
+	return size;
+}
+
 static size_t can_get_size(const struct net_device *dev)
 {
 	struct can_priv *priv = netdev_priv(dev);
@@ -254,10 +351,43 @@ static size_t can_get_size(const struct net_device *dev)
 		size += nla_total_size(sizeof(*priv->data_bitrate_const) *
 				       priv->data_bitrate_const_cnt);
 	size += sizeof(priv->bitrate_max);			/* IFLA_CAN_BITRATE_MAX */
-
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
+	if (nla_put_u32(skb, IFLA_CAN_TDC_TDCV_MAX, tdc_const->tdcv_max) ||
+	    nla_put_u32(skb, IFLA_CAN_TDC_TDCO_MAX, tdc_const->tdco_max) ||
+	    nla_put_u32(skb, IFLA_CAN_TDC_TDCF_MAX, tdc_const->tdcf_max))
+		goto err_cancel;
+
+	if (priv->tdc.tdco)
+		if (nla_put_u32(skb, IFLA_CAN_TDC_TDCV, tdc->tdcv) ||
+		    nla_put_u32(skb, IFLA_CAN_TDC_TDCO, tdc->tdco) ||
+		    nla_put_u32(skb, IFLA_CAN_TDC_TDCF, tdc->tdcf))
+			goto err_cancel;
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
@@ -315,7 +445,9 @@ static int can_fill_info(struct sk_buff *skb, const struct net_device *dev)
 
 	    (nla_put(skb, IFLA_CAN_BITRATE_MAX,
 		     sizeof(priv->bitrate_max),
-		     &priv->bitrate_max))
+		     &priv->bitrate_max)) ||
+
+	    (can_tdc_fill_info(skb, dev))
 	    )
 
 		return -EMSGSIZE;
diff --git a/include/uapi/linux/can/netlink.h b/include/uapi/linux/can/netlink.h
index f730d443b918..3e81cad069a1 100644
--- a/include/uapi/linux/can/netlink.h
+++ b/include/uapi/linux/can/netlink.h
@@ -134,10 +134,32 @@ enum {
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
+	IFLA_CAN_TDC_TDCV_MAX,	/* u32 */
+	IFLA_CAN_TDC_TDCO_MAX,	/* u32 */
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
2.31.1

