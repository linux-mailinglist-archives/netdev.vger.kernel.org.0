Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05741E86C9
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 20:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgE2Shc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 14:37:32 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53541 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727911AbgE2Sh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 14:37:28 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 48EE55C00AE;
        Fri, 29 May 2020 14:37:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 29 May 2020 14:37:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=n6Kej2/GNBT5ODNyUtOMZJ38Wt8SnTGEmsjoWMXkekY=; b=EBsWGUKN
        i6rrpFOgUOIqzXJAl4ILp/xD2/SB2BXnu8KmMe1HbyI1euAo75vWxGtnuzQJEq30
        0y948Xwse4ALDyOaVyGHL5A3nHVW6uckiqMrkRU8E4aGWDXgJHs+pu1GS0lKO9ay
        AHsTvpBv4yn/bezRryKnnaQRmQ4Xo81h8Ph7loVKkUBj1bmcs2ESUfOnSFIA7EwW
        5WcuTyiXCKbSJ8phkXx0MbW/5/LC9up7zQfwe7uvEG3VvW7XI3em4UItF132xiKu
        4VxtymKmuGKfzuUbwTrBYmX40bxTFZNykYzsdm1xKmVu0Jj+n8IXKWT0PqICOO81
        5KISqSJ8fMMTww==
X-ME-Sender: <xms:aFbRXnXdAGBjIAlSgAo6pMqLF-Fd_TRZ6ZDnWB17VCQfMy-X78kBow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvkedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepjeelrddujeeirddvgedruddt
    jeenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:aFbRXvmEJ43kMza28WvmsWr3wWgPnYK9IeGfw3aLF_sYWcew-J3l2w>
    <xmx:aFbRXjasNxZWXt5ad0aDTh2MvfG1-QkLY2WikR-XxwT53JvwcLKrfQ>
    <xmx:aFbRXiVDGFUMtqP6pqs78HJILNmFqeXVn_SJRc8FpMoXop9J4bncRw>
    <xmx:aFbRXhuuhNQLP1-8SIU0ig4TIA0j7CG8siHsxMp_g3RxNqSUWdRQ4w>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0B45330614FA;
        Fri, 29 May 2020 14:37:26 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 05/14] devlink: Add 'control' trap type
Date:   Fri, 29 May 2020 21:36:40 +0300
Message-Id: <20200529183649.1602091-6-idosch@idosch.org>
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

This type is used for traps that trap control packets such as ARP
request and IGMP query to the CPU.

Do not report such packets to the kernel's drop monitor as they were not
dropped by the device no encountered an exception during forwarding.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 Documentation/networking/devlink/devlink-trap.rst | 8 +++++++-
 include/uapi/linux/devlink.h                      | 6 ++++++
 net/core/devlink.c                                | 7 +++++++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
index 5b97327caefc..6c293cfa23ee 100644
--- a/Documentation/networking/devlink/devlink-trap.rst
+++ b/Documentation/networking/devlink/devlink-trap.rst
@@ -55,7 +55,7 @@ The following diagram provides a general overview of ``devlink-trap``::
                           |                |
                           +-------^--------+
                                   |
-                                  |
+                                  | Non-control traps
                                   |
                              +----+----+
                              |         |      Kernel's Rx path
@@ -97,6 +97,12 @@ The ``devlink-trap`` mechanism supports the following packet trap types:
     processed by ``devlink`` and injected to the kernel's Rx path. Changing the
     action of such traps is not allowed, as it can easily break the control
     plane.
+  * ``control``: Trapped packets were trapped by the device because these are
+    control packets required for the correct functioning of the control plane.
+    For example, ARP request and IGMP query packets. Packets are injected to
+    the kernel's Rx path, but not reported to the kernel's drop monitor.
+    Changing the action of such traps is not allowed, as it can easily break
+    the control plane.
 
 .. _Trap-Actions:
 
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 16305932a950..08563e6a424d 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -253,10 +253,16 @@ enum devlink_trap_action {
  *                               control plane for resolution. Trapped packets
  *                               are processed by devlink and injected to
  *                               the kernel's Rx path.
+ * @DEVLINK_TRAP_TYPE_CONTROL: Packet was trapped because it is required for
+ *                             the correct functioning of the control plane.
+ *                             For example, an ARP request packet. Trapped
+ *                             packets are injected to the kernel's Rx path,
+ *                             but not reported to drop monitor.
  */
 enum devlink_trap_type {
 	DEVLINK_TRAP_TYPE_DROP,
 	DEVLINK_TRAP_TYPE_EXCEPTION,
+	DEVLINK_TRAP_TYPE_CONTROL,
 };
 
 enum {
diff --git a/net/core/devlink.c b/net/core/devlink.c
index d6298917b077..47c28e0f848f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8847,6 +8847,13 @@ void devlink_trap_report(struct devlink *devlink, struct sk_buff *skb,
 	devlink_trap_stats_update(trap_item->stats, skb->len);
 	devlink_trap_stats_update(trap_item->group_item->stats, skb->len);
 
+	/* Control packets were not dropped by the device or encountered an
+	 * exception during forwarding and therefore should not be reported to
+	 * the kernel's drop monitor.
+	 */
+	if (trap_item->trap->type == DEVLINK_TRAP_TYPE_CONTROL)
+		return;
+
 	devlink_trap_report_metadata_fill(&hw_metadata, trap_item,
 					  in_devlink_port, fa_cookie);
 	net_dm_hw_report(skb, &hw_metadata);
-- 
2.26.2

