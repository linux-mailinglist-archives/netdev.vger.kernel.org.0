Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10FA439D86
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbhJYR0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:26:20 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:65466 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234074AbhJYR0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 13:26:10 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id f3gYmY0E4niuxf3hImufL8; Mon, 25 Oct 2021 19:23:46 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Mon, 25 Oct 2021 19:23:46 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v3 4/4] can: netlink: report the CAN controller mode supported flags
Date:   Tue, 26 Oct 2021 02:22:47 +0900
Message-Id: <20211025172247.1774451-5-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211025172247.1774451-1-mailhol.vincent@wanadoo.fr>
References: <20211025172247.1774451-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces a method for the user to check both the
supported and the static capabilities. The proposed method reuses the
existing struct can_ctrlmode and thus do not need a new IFLA_CAN_*
entry.

Currently, the CAN netlink interface provides no easy ways to check
the capabilities of a given controller. The only method from the
command line is to try each CAN_CTRLMODE_* individually to check
whether the netlink interface returns an -EOPNOTSUPP error or not
(alternatively, one may find it easier to directly check the source
code of the driver instead...)

It appears that can_ctrlmode::mask is only used in one direction: from
the userland to the kernel. So we can just reuse this field in the
other direction (from the kernel to userland). But, because the
semantic is different, we use a union to give this field a proper
name: "supported".

Below table explains how the two fields can_ctrlmode::supported and
can_ctrlmode::flags, when masked with any of the CAN_CTRLMODE_* bit
flags, allow us to identify both the supported and the static
capabilities:

 supported &	flags &		Controller capabilities
 CAN_CTRLMODE_*	CAN_CTRLMODE_*
 -----------------------------------------------------------------------
 false		false		Feature not supported (always disabled)
 false		true		Static feature (always enabled)
 true		false		Feature supported but disabled
 true		true		Feature supported and enabled

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
Please refer to below link for the iproute2-next counterpart of this
patch:

https://lore.kernel.org/linux-can/20211003050147.569044-1-mailhol.vincent@wanadoo.fr/T/#t
---
 drivers/net/can/dev/netlink.c    | 5 ++++-
 include/uapi/linux/can/netlink.h | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index 26c336808be5..32e1eb63ee7d 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -475,7 +475,10 @@ static int can_tdc_fill_info(struct sk_buff *skb, const struct net_device *dev)
 static int can_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
 	struct can_priv *priv = netdev_priv(dev);
-	struct can_ctrlmode cm = {.flags = priv->ctrlmode};
+	struct can_ctrlmode cm = {
+		.supported = priv->ctrlmode_supported,
+		.flags = priv->ctrlmode
+	};
 	struct can_berr_counter bec = { };
 	enum can_state state = priv->state;
 
diff --git a/include/uapi/linux/can/netlink.h b/include/uapi/linux/can/netlink.h
index 75b85c60efb2..b846922ac18f 100644
--- a/include/uapi/linux/can/netlink.h
+++ b/include/uapi/linux/can/netlink.h
@@ -88,7 +88,10 @@ struct can_berr_counter {
  * CAN controller mode
  */
 struct can_ctrlmode {
-	__u32 mask;
+	union {
+		__u32 mask;		/* Userland to kernel */
+		__u32 supported;	/* Kernel to userland */
+	};
 	__u32 flags;
 };
 
-- 
2.32.0

