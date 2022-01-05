Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8B44854F9
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241068AbiAEOod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241037AbiAEOoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:44:24 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2AAC061792
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 06:44:24 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n57WY-0004Nf-Tg
        for netdev@vger.kernel.org; Wed, 05 Jan 2022 15:44:22 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 1EE1F6D1B36
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 14:44:12 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 58F636D1AE4;
        Wed,  5 Jan 2022 14:44:07 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id a2c377c7;
        Wed, 5 Jan 2022 14:44:04 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 15/15] can: netlink: report the CAN controller mode supported flags
Date:   Wed,  5 Jan 2022 15:44:02 +0100
Message-Id: <20220105144402.1174191-16-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220105144402.1174191-1-mkl@pengutronix.de>
References: <20220105144402.1174191-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Currently, the CAN netlink interface provides no easy ways to check
the capabilities of a given controller. The only method from the
command line is to try each CAN_CTRLMODE_* individually to check
whether the netlink interface returns an -EOPNOTSUPP error or not
(alternatively, one may find it easier to directly check the source
code of the driver instead...)

This patch introduces a method for the user to check both the
supported and the static capabilities. The proposed method introduces
a new IFLA nest: IFLA_CAN_CTRLMODE_EXT which extends the current
IFLA_CAN_CTRLMODE. This is done to guaranty a full forward and
backward compatibility between the kernel and the user land
applications.

The IFLA_CAN_CTRLMODE_EXT nest contains one single entry:
IFLA_CAN_CTRLMODE_SUPPORTED. Because this entry is only used in one
direction: kernel to userland, no new struct nla_policy are
introduced.

Below table explains how IFLA_CAN_CTRLMODE_SUPPORTED (hereafter:
"supported") and can_ctrlmode::flags (hereafter: "flags") allow us to
identify both the supported and the static capabilities, when masked
with any of the CAN_CTRLMODE_* bit flags:

 supported &	flags &		Controller capabilities
 CAN_CTRLMODE_*	CAN_CTRLMODE_*
 -----------------------------------------------------------------------
 false		false		Feature not supported (always disabled)
 false		true		Static feature (always enabled)
 true		false		Feature supported but disabled
 true		true		Feature supported and enabled

Link: https://lore.kernel.org/all/20211213160226.56219-5-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/netlink.c    | 31 ++++++++++++++++++++++++++++++-
 include/uapi/linux/can/netlink.h | 13 +++++++++++++
 2 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index 26c336808be5..7633d98e3912 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -21,6 +21,7 @@ static const struct nla_policy can_policy[IFLA_CAN_MAX + 1] = {
 	[IFLA_CAN_DATA_BITTIMING_CONST]	= { .len = sizeof(struct can_bittiming_const) },
 	[IFLA_CAN_TERMINATION] = { .type = NLA_U16 },
 	[IFLA_CAN_TDC] = { .type = NLA_NESTED },
+	[IFLA_CAN_CTRLMODE_EXT] = { .type = NLA_NESTED },
 };
 
 static const struct nla_policy can_tdc_policy[IFLA_CAN_TDC_MAX + 1] = {
@@ -383,6 +384,12 @@ static size_t can_tdc_get_size(const struct net_device *dev)
 	return size;
 }
 
+static size_t can_ctrlmode_ext_get_size(void)
+{
+	return nla_total_size(0) +		/* nest IFLA_CAN_CTRLMODE_EXT */
+		nla_total_size(sizeof(u32));	/* IFLA_CAN_CTRLMODE_SUPPORTED */
+}
+
 static size_t can_get_size(const struct net_device *dev)
 {
 	struct can_priv *priv = netdev_priv(dev);
@@ -415,6 +422,7 @@ static size_t can_get_size(const struct net_device *dev)
 				       priv->data_bitrate_const_cnt);
 	size += sizeof(priv->bitrate_max);			/* IFLA_CAN_BITRATE_MAX */
 	size += can_tdc_get_size(dev);				/* IFLA_CAN_TDC */
+	size += can_ctrlmode_ext_get_size();			/* IFLA_CAN_CTRLMODE_EXT */
 
 	return size;
 }
@@ -472,6 +480,25 @@ static int can_tdc_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	return -EMSGSIZE;
 }
 
+static int can_ctrlmode_ext_fill_info(struct sk_buff *skb,
+				      const struct can_priv *priv)
+{
+	struct nlattr *nest;
+
+	nest = nla_nest_start(skb, IFLA_CAN_CTRLMODE_EXT);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (nla_put_u32(skb, IFLA_CAN_CTRLMODE_SUPPORTED,
+			priv->ctrlmode_supported)) {
+		nla_nest_cancel(skb, nest);
+		return -EMSGSIZE;
+	}
+
+	nla_nest_end(skb, nest);
+	return 0;
+}
+
 static int can_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
 	struct can_priv *priv = netdev_priv(dev);
@@ -531,7 +558,9 @@ static int can_fill_info(struct sk_buff *skb, const struct net_device *dev)
 		     sizeof(priv->bitrate_max),
 		     &priv->bitrate_max)) ||
 
-	    (can_tdc_fill_info(skb, dev))
+	    can_tdc_fill_info(skb, dev) ||
+
+	    can_ctrlmode_ext_fill_info(skb, priv)
 	    )
 
 		return -EMSGSIZE;
diff --git a/include/uapi/linux/can/netlink.h b/include/uapi/linux/can/netlink.h
index 75b85c60efb2..02ec32d69474 100644
--- a/include/uapi/linux/can/netlink.h
+++ b/include/uapi/linux/can/netlink.h
@@ -137,6 +137,7 @@ enum {
 	IFLA_CAN_DATA_BITRATE_CONST,
 	IFLA_CAN_BITRATE_MAX,
 	IFLA_CAN_TDC,
+	IFLA_CAN_CTRLMODE_EXT,
 
 	/* add new constants above here */
 	__IFLA_CAN_MAX,
@@ -166,6 +167,18 @@ enum {
 	IFLA_CAN_TDC_MAX = __IFLA_CAN_TDC - 1
 };
 
+/*
+ * IFLA_CAN_CTRLMODE_EXT nest: controller mode extended parameters
+ */
+enum {
+	IFLA_CAN_CTRLMODE_UNSPEC,
+	IFLA_CAN_CTRLMODE_SUPPORTED,	/* u32 */
+
+	/* add new constants above here */
+	__IFLA_CAN_CTRLMODE,
+	IFLA_CAN_CTRLMODE_MAX = __IFLA_CAN_CTRLMODE - 1
+};
+
 /* u16 termination range: 1..65535 Ohms */
 #define CAN_TERMINATION_DISABLED 0
 
-- 
2.34.1


