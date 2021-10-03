Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E315941FFD0
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 06:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhJCEm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 00:42:57 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:63837 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhJCEmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 00:42:55 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id WtJ1mh6etsoWhWtJAm9O0T; Sun, 03 Oct 2021 06:41:06 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Sun, 03 Oct 2021 06:41:06 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v1] can: netlink: report the CAN controller mode supported flags
Date:   Sun,  3 Oct 2021 13:40:49 +0900
Message-Id: <20211003044049.568441-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces a method for the user to check both the
supported and the static capabilities.

Currently, the CAN netlink interface provides no easy ways to check
the capabilities of a given controller. The only method from the
command line is to try each CAN_CTRLMODE_ individually to check
whether the netlink interface returns an -EOPNOTSUPP error or not
(alternatively, one may find it easier to directly check the source
code of the driver instead...)

It appears that, currently, the struct can_ctrlmode::mask field is
only used in one direction: from the userland to the kernel. So we can
just reuse this field in the other direction (from the kernel to
userland). But, because the semantic is different, we use a union to
give this field a proper name: supported.

Below table explains how the two fields can_ctrlmode::supported and
can_ctrlmode::flags, when masked with any of the CAN_CTRLMODE_* bit
flags, allow us to identify both the supported and the static
capabilities:

 supported &	flags &		Controller capabilities
 CAN_CTRLMODE_*	CAN_CTRLMODE_*
 ------------------------------------------------------------------------
 false		false		Feature not supported (always disabled)
 false		true		Static feature (always enabled)
 true		false		Feature supported but disabled
 true		true		Feature supported and enabled

N.B.: This patch relies on the fact that a given CAN_CTRLMODE_*
feature can not be set for both can_priv::ctrlmode_supported and
can_priv::ctrlmode_static at the same time. c.f. comments in struct
can_priv [1]. Else, there would be no way to distinguish which
features were statically enabled.

[1] https://elixir.bootlin.com/linux/v5.14/source/include/linux/can/dev.h#61

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
I will send a iproute2-next patch right after to illustrate the idea.
---
 drivers/net/can/dev/netlink.c    | 5 ++++-
 include/uapi/linux/can/netlink.h | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index 80425636049d..480818edccc1 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -264,7 +264,10 @@ static size_t can_get_size(const struct net_device *dev)
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
index f730d443b918..2847ed0dcac3 100644
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

