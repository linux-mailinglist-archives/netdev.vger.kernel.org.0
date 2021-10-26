Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2CB43B220
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 14:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234422AbhJZMT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 08:19:29 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:62113 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhJZMT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 08:19:28 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id fLNtm91q8IEdlfLO1mgCDD; Tue, 26 Oct 2021 14:17:03 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Tue, 26 Oct 2021 14:17:03 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v4] can: netlink: report the CAN controller mode supported flags
Date:   Tue, 26 Oct 2021 21:16:51 +0900
Message-Id: <20211026121651.1814251-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
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

The union is tagged as packed to prevent any ABI from adding
padding. In fact, any padding added after the union would change the
offset of can_ctrlmode::flags within the structure and thus break the
UAPI backward compatibility. References:

  - ISO/IEC 9899-1999, section 6.7.2.1 "Structure and union
    specifiers", clause 15: "There may be unnamed padding at the end
    of a structure or union."

  - The -mstructure-size-boundary=64 ARM option in GCC:
    https://gcc.gnu.org/onlinedocs/gcc/ARM-Options.html

  - A similar issue which occurred on struct can_frame:
    https://lore.kernel.org/linux-can/212c8bc3-89f9-9c33-ed1b-b50ac04e7532@hartkopp.net

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
Hi Marc,

Because you already added the series to the testing branch of
linux-can-next, I am only resending the last patch. Please let me know
if you prefer me to resend the full series.


** Changelog **

v3 -> v4:

  - Tag the union in struct can_ctrlmode as packed.

  - Remove patch 1, 2 and 3 from the series because those were already
    added to the testing branch of linux-can-next (and no changes
    occured on those first three patches).

v2 -> v3:

  - Make can_set_static_ctrlmode() return an error and adjust the
    drivers which use this helper function accordingly.

v1 -> v2:

  - Add a first patch to replace can_priv::ctrlmode_static by the
    inline function can_get_static_ctrlmode()

  - Add a second patch to reorder the fields of struct can_priv for
    better packing (save eight bytes on x86_64 \o/)

  - Rewrite the comments of the third patch "can: netlink: report the
    CAN controller mode supported flags" (no changes on the code
    itself).

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
index 75b85c60efb2..091bb78b0406 100644
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
+	} __attribute__((packed));	/* Prevent ABI from adding padding */
 	__u32 flags;
 };
 
-- 
2.32.0

