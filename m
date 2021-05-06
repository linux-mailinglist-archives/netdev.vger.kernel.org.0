Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6A13752D8
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 13:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbhEFLPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 07:15:48 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:22248 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234639AbhEFLPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 07:15:44 -0400
Received: from tomoyo.flets-east.jp ([153.202.107.157])
        by mwinf5d58 with ME
        id 1PEF250013PnFJp03PEjvD; Thu, 06 May 2021 13:14:45 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Thu, 06 May 2021 13:14:45 +0200
X-ME-IP: 153.202.107.157
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [RFC PATCH v1 1/1] can: netlink: add interface for CAN-FD Transmitter Delay Compensation (TDC)
Date:   Thu,  6 May 2021 20:14:12 +0900
Message-Id: <20210506111412.1665835-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210506111412.1665835-1-mailhol.vincent@wanadoo.fr>
References: <20210506111412.1665835-1-mailhol.vincent@wanadoo.fr>
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
 drivers/net/can/dev/Makefile      |   1 +
 drivers/net/can/dev/netlink-tdc.c | 122 ++++++++++++++++++++++++++++++
 drivers/net/can/dev/netlink-tdc.h |  18 +++++
 drivers/net/can/dev/netlink.c     |  15 +++-
 include/uapi/linux/can/netlink.h  |  28 ++++++-
 5 files changed, 179 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/can/dev/netlink-tdc.c
 create mode 100644 drivers/net/can/dev/netlink-tdc.h

diff --git a/drivers/net/can/dev/Makefile b/drivers/net/can/dev/Makefile
index 3e2e207861fc..41f2ef9594fe 100644
--- a/drivers/net/can/dev/Makefile
+++ b/drivers/net/can/dev/Makefile
@@ -5,6 +5,7 @@ can-dev-y			+= bittiming.o
 can-dev-y			+= dev.o
 can-dev-y			+= length.o
 can-dev-y			+= netlink.o
+can-dev-y			+= netlink-tdc.o
 can-dev-y			+= rx-offload.o
 can-dev-y                       += skb.o
 
diff --git a/drivers/net/can/dev/netlink-tdc.c b/drivers/net/can/dev/netlink-tdc.c
new file mode 100644
index 000000000000..b8bd47a956d8
--- /dev/null
+++ b/drivers/net/can/dev/netlink-tdc.c
@@ -0,0 +1,122 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2021 Vincent Mailhol <mailhol.vincent@wanadoo.fr>
+ */
+
+#include <linux/can/dev.h>
+
+#include "netlink-tdc.h"
+
+static const struct nla_policy can_tdc_policy[IFLA_CAN_TDC_MAX + 1] = {
+	[IFLA_CAN_TDC_TDCV_MAX] = { .type = NLA_U32 },
+	[IFLA_CAN_TDC_TDCO_MAX] = { .type = NLA_U32 },
+	[IFLA_CAN_TDC_TDCF_MAX] = { .type = NLA_U32 },
+	[IFLA_CAN_TDC_TDCV] = { .type = NLA_U32 },
+	[IFLA_CAN_TDC_TDCO] = { .type = NLA_U32 },
+	[IFLA_CAN_TDC_TDCF] = { .type = NLA_U32 },
+};
+
+size_t can_tdc_get_size(const struct net_device *dev)
+{
+	struct can_priv *priv = netdev_priv(dev);
+	size_t size = nla_total_size(0) /* IFLA_CAN_TDC */;
+
+	if (priv->tdc_const) {
+		size += nla_total_size(sizeof(u32));	/* IFLA_CAN_TDCV_MAX */
+		size += nla_total_size(sizeof(u32));	/* IFLA_CAN_TDCO_MAX */
+		size += nla_total_size(sizeof(u32));	/* IFLA_CAN_TDCF_MAX */
+	}
+	if (priv->tdc.tdco) {
+		size += nla_total_size(sizeof(u32));	/* IFLA_CAN_TDCV */
+		size += nla_total_size(sizeof(u32));	/* IFLA_CAN_TDCO */
+		size += nla_total_size(sizeof(u32));	/* IFLA_CAN_TDCF */
+	}
+
+	return size;
+}
+
+int can_tdc_changelink(struct net_device *dev, const struct nlattr *nla,
+		       struct netlink_ext_ack *extack)
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
+int can_tdc_fill_info(struct sk_buff *skb, const struct net_device *dev)
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
+	    nla_put_u32(skb, IFLA_CAN_TDC_TDCF_MAX, tdc_const->tdcf_max) ||
+	    nla_put_u32(skb, IFLA_CAN_TDC_TDCV, tdc->tdcv) ||
+	    nla_put_u32(skb, IFLA_CAN_TDC_TDCO, tdc->tdco) ||
+	    nla_put_u32(skb, IFLA_CAN_TDC_TDCF, tdc->tdcf))
+		return -EMSGSIZE;
+
+	nla_nest_end(skb, nest);
+
+	return 0;
+}
diff --git a/drivers/net/can/dev/netlink-tdc.h b/drivers/net/can/dev/netlink-tdc.h
new file mode 100644
index 000000000000..28ad3d7a58e2
--- /dev/null
+++ b/drivers/net/can/dev/netlink-tdc.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2021 Vincent Mailhol <mailhol.vincent@wanadoo.fr>
+ */
+
+#ifndef _CAN_NETLINK_TDC_H
+#define _CAN_NETLINK_TDC_H
+
+#include <net/netlink.h>
+
+size_t can_tdc_get_size(const struct net_device *dev);
+
+int can_tdc_changelink(struct net_device *dev, const struct nlattr *nla,
+		       struct netlink_ext_ack *extack);
+
+int can_tdc_fill_info(struct sk_buff *skb, const struct net_device *dev);
+
+#endif /* !_CAN_NETLINK_TDC_H */
diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index e38c2566aff4..3f4394fda155 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -6,6 +6,7 @@
 
 #include <linux/can/dev.h>
 #include <net/rtnetlink.h>
+#include "netlink-tdc.h"
 
 static const struct nla_policy can_policy[IFLA_CAN_MAX + 1] = {
 	[IFLA_CAN_STATE] = { .type = NLA_U32 },
@@ -19,6 +20,7 @@ static const struct nla_policy can_policy[IFLA_CAN_MAX + 1] = {
 	[IFLA_CAN_DATA_BITTIMING] = { .len = sizeof(struct can_bittiming) },
 	[IFLA_CAN_DATA_BITTIMING_CONST]	= { .len = sizeof(struct can_bittiming_const) },
 	[IFLA_CAN_TERMINATION] = { .type = NLA_U16 },
+	[IFLA_CAN_TDC] = { .type = NLA_NESTED },
 };
 
 static int can_validate(struct nlattr *tb[], struct nlattr *data[],
@@ -46,7 +48,7 @@ static int can_validate(struct nlattr *tb[], struct nlattr *data[],
 			return -EOPNOTSUPP;
 	}
 
-	if (data[IFLA_CAN_DATA_BITTIMING]) {
+	if (data[IFLA_CAN_DATA_BITTIMING] || data[IFLA_CAN_TDC]) {
 		if (!is_can_fd || !data[IFLA_CAN_BITTIMING])
 			return -EOPNOTSUPP;
 	}
@@ -220,6 +222,12 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
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
 
@@ -254,6 +262,7 @@ static size_t can_get_size(const struct net_device *dev)
 		size += nla_total_size(sizeof(*priv->data_bitrate_const) *
 				       priv->data_bitrate_const_cnt);
 	size += sizeof(priv->bitrate_max);			/* IFLA_CAN_BITRATE_MAX */
+	size += can_tdc_get_size(dev);
 
 	return size;
 }
@@ -315,7 +324,9 @@ static int can_fill_info(struct sk_buff *skb, const struct net_device *dev)
 
 	    (nla_put(skb, IFLA_CAN_BITRATE_MAX,
 		     sizeof(priv->bitrate_max),
-		     &priv->bitrate_max))
+		     &priv->bitrate_max)) ||
+
+	    (can_tdc_fill_info(skb, dev))
 	    )
 
 		return -EMSGSIZE;
diff --git a/include/uapi/linux/can/netlink.h b/include/uapi/linux/can/netlink.h
index f730d443b918..fd669db7afcf 100644
--- a/include/uapi/linux/can/netlink.h
+++ b/include/uapi/linux/can/netlink.h
@@ -134,12 +134,34 @@ enum {
 	IFLA_CAN_BITRATE_CONST,
 	IFLA_CAN_DATA_BITRATE_CONST,
 	IFLA_CAN_BITRATE_MAX,
-	__IFLA_CAN_MAX
-};
+	IFLA_CAN_TDC,
 
-#define IFLA_CAN_MAX	(__IFLA_CAN_MAX - 1)
+	/* add new constants above here */
+	__IFLA_CAN_MAX,
+	IFLA_CAN_MAX = __IFLA_CAN_MAX - 1
+};
 
 /* u16 termination range: 1..65535 Ohms */
 #define CAN_TERMINATION_DISABLED 0
 
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
+
 #endif /* !_UAPI_CAN_NETLINK_H */
-- 
2.26.3

