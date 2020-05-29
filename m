Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664981E86C8
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 20:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgE2Sha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 14:37:30 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42703 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727890AbgE2Sh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 14:37:27 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id EB0E35C00A7;
        Fri, 29 May 2020 14:37:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 29 May 2020 14:37:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=LwbN8odMRwrfCjsRgAmBcsY8RB2Blhe/oy1GrHzwRZg=; b=kJgG4Xp9
        r1DwuhAx8FZibV/9CioScVodZJUNixFkQtr53QsfVkU5zm2usNvOUb4eS3V1Lvk8
        NGPKIwx/iCjU9JXUbtRGOalcWMlprHDSw+kOwOa1gmC3Ks5hF70QiWMd3SxBj52P
        qEWtA5jTRkNPf3UIy/KiIeQ0UW5f/UU9763/egsIdDW58YUkycv2bGUN5BMmSkzh
        JR1YYp1mJ4w2FQRKOHL1/zb2XlGw6suSBgcUvquDn9Qpfr1xVwBIfZ5sIQaTnfwV
        b9iEkqE27oiTaJ1U+O53f5yDfRY7wOpqJk1dyGWjFSAkHfcuVPE+iZarnUVgBf4A
        6Shdo8ZFCOSTRQ==
X-ME-Sender: <xms:ZlbRXoJxeFeHES2iyRBZ3fk_wHtbgdlTWCqSPLz46QQahnA4uxSYJg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvkedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepjeelrddujeeirddvgedruddt
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:ZlbRXoI8ERwhMeYPNIwFLDiq8cFfnEmNW9JedDenc3qYKTlX1ow_6Q>
    <xmx:ZlbRXovn6-roJ4jWML_u_4hhP-POzxRfxKKZGXqSfIrA01V_7JWysA>
    <xmx:ZlbRXlbkfzt_u5YZMJwkOy0KCpTZVysmHB0MBVyXhgMUr5pXE9IQDQ>
    <xmx:ZlbRXmzkEqBLIro2mFgzTlL51TEfABIBbHTgiQ1EEndiYi-1lNX8sw>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id AC83E3061856;
        Fri, 29 May 2020 14:37:25 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 04/14] devlink: Add 'mirror' trap action
Date:   Fri, 29 May 2020 21:36:39 +0300
Message-Id: <20200529183649.1602091-5-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529183649.1602091-1-idosch@idosch.org>
References: <20200529183649.1602091-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The action is used by control traps such as IGMP query. The packet is
flooded by the device, but also trapped to the CPU in order for the
software bridge to mark the receiving port as a multicast router port.
Such packets are marked with 'skb->offload_fwd_mark = 1' in order to
prevent the software bridge from flooding them again.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 Documentation/networking/devlink/devlink-trap.rst | 2 ++
 include/uapi/linux/devlink.h                      | 3 +++
 net/core/devlink.c                                | 3 ++-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
index 4ca241e70064..5b97327caefc 100644
--- a/Documentation/networking/devlink/devlink-trap.rst
+++ b/Documentation/networking/devlink/devlink-trap.rst
@@ -108,6 +108,8 @@ The ``devlink-trap`` mechanism supports the following packet trap actions:
   * ``trap``: The sole copy of the packet is sent to the CPU.
   * ``drop``: The packet is dropped by the underlying device and a copy is not
     sent to the CPU.
+  * ``mirror``: The packet is forwarded by the underlying device and a copy is
+    sent to the CPU.
 
 Generic Packet Traps
 ====================
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 1ae90e06c06d..16305932a950 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -233,10 +233,13 @@ enum {
  * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy is not
  *                            sent to the CPU.
  * @DEVLINK_TRAP_ACTION_TRAP: The sole copy of the packet is sent to the CPU.
+ * @DEVLINK_TRAP_ACTION_MIRROR: Packet is forwarded by the device and a copy is
+ *                              sent to the CPU.
  */
 enum devlink_trap_action {
 	DEVLINK_TRAP_ACTION_DROP,
 	DEVLINK_TRAP_ACTION_TRAP,
+	DEVLINK_TRAP_ACTION_MIRROR,
 };
 
 /**
diff --git a/net/core/devlink.c b/net/core/devlink.c
index d9fff7083f02..d6298917b077 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5869,7 +5869,8 @@ devlink_trap_action_get_from_info(struct genl_info *info,
 	val = nla_get_u8(info->attrs[DEVLINK_ATTR_TRAP_ACTION]);
 	switch (val) {
 	case DEVLINK_TRAP_ACTION_DROP: /* fall-through */
-	case DEVLINK_TRAP_ACTION_TRAP:
+	case DEVLINK_TRAP_ACTION_TRAP: /* fall-through */
+	case DEVLINK_TRAP_ACTION_MIRROR:
 		*p_trap_action = val;
 		break;
 	default:
-- 
2.26.2

