Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B351E86CA
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 20:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgE2Shf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 14:37:35 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:35299 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727941AbgE2Shd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 14:37:33 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 710875C00BE;
        Fri, 29 May 2020 14:37:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 29 May 2020 14:37:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=ezWrrbMB77vkJJj7llTYEX0wi0bfgJV/eNzrbXzCwQg=; b=2E4cIldb
        aHtXatjQWi5HZkI+c5dpPpNwT8SHOd0RJu2/LGAr0r7gDGnb47grlsR2+Fa4VYC4
        qLXuFsWzyrPBDxOkqGGTRjT95pM1+c9rRoJh2cwE6Cgp18qMQU+fOMyTlkcdoLx6
        EJ0GMo9fNpAmgxyd5GsHt4AfK0Iy5JXRh8+HpTMUbqjS3QiB7RDXZmY7ANg6fBgn
        Sr01WlOOZZ8EiR0HYxqRRweVRsNEnw4YhZNL6QlibrmwMp3BtRP1W6842/o/jfrH
        yfdNvDsedx+g622yWN9vqLIcivvbp/ZTsSypwUGwvZe7qapebf8mSoQ/xF5GAQ33
        jSR20a9sQql8kA==
X-ME-Sender: <xms:bFbRXlG4vluMj9XZYVXjxSDnQtgkM_BtV56quXz9mPHAb5ho9EfboA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvkedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepjeelrddujeeirddvgedruddt
    jeenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:bFbRXqVcb9oIQo6xKw7kfYTH4hLZRGfwOvTPJjkFqGMPkvaNmXdNoA>
    <xmx:bFbRXnIII4QU7Ns_QJbRyo6dbMsFgOPaybhOyeIUMYb64u7cLqmxbQ>
    <xmx:bFbRXrFwfKZNJsrAq5lqhEuJ1iTrkZHIwfHtvki9eZpXCIaavHp5EQ>
    <xmx:bFbRXieB9BMAVO4_rUSsfVGCoDOCl3BOqXfPcLg4wQCIGxIdU3yjeg>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 326413060F09;
        Fri, 29 May 2020 14:37:31 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 08/14] devlink: Add ACL control packet traps
Date:   Fri, 29 May 2020 21:36:43 +0300
Message-Id: <20200529183649.1602091-9-idosch@idosch.org>
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

Add packet traps for packets that are sampled / trapped by ACLs, so that
capable drivers could register them with devlink. Add documentation for
every added packet trap and packet trap group.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 Documentation/networking/devlink/devlink-trap.rst | 14 ++++++++++++++
 include/net/devlink.h                             | 12 ++++++++++++
 net/core/devlink.c                                |  4 ++++
 3 files changed, 30 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
index 621b634b16be..1e3f3ffee248 100644
--- a/Documentation/networking/devlink/devlink-trap.rst
+++ b/Documentation/networking/devlink/devlink-trap.rst
@@ -397,6 +397,14 @@ be added to the following table:
      - ``control``
      - Traps PTP general messages (Announce, Follow_Up, Delay_Resp,
        Pdelay_Resp_Follow_Up, management and signaling)
+   * - ``flow_action_sample``
+     - ``control``
+     - Traps packets sampled during processing of flow action sample (e.g., via
+       tc's sample action)
+   * - ``flow_action_trap``
+     - ``control``
+     - Traps packets logged during processing of flow action trap (e.g., via
+       tc's trap action)
 
 Driver-specific Packet Traps
 ============================
@@ -487,6 +495,12 @@ narrow. The description of these groups must be added to the following table:
    * - ``ptp_general``
      - Contains packet traps for PTP general messages (Announce, Follow_Up,
        Delay_Resp, Pdelay_Resp_Follow_Up, management and signaling)
+   * - ``acl_sample``
+     - Contains packet traps for packets that were sampled by the device during
+       ACL processing
+   * - ``acl_trap``
+     - Contains packet traps for packets that were trapped (logged) by the
+       device during ACL processing
 
 Packet Trap Policers
 ====================
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 05a45dea976b..1df6dfec26c2 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -687,6 +687,8 @@ enum devlink_trap_generic_id {
 	DEVLINK_TRAP_GENERIC_ID_IPV6_ROUTER_ALERT,
 	DEVLINK_TRAP_GENERIC_ID_PTP_EVENT,
 	DEVLINK_TRAP_GENERIC_ID_PTP_GENERAL,
+	DEVLINK_TRAP_GENERIC_ID_FLOW_ACTION_SAMPLE,
+	DEVLINK_TRAP_GENERIC_ID_FLOW_ACTION_TRAP,
 
 	/* Add new generic trap IDs above */
 	__DEVLINK_TRAP_GENERIC_ID_MAX,
@@ -719,6 +721,8 @@ enum devlink_trap_group_generic_id {
 	DEVLINK_TRAP_GROUP_GENERIC_ID_IPV6,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_PTP_EVENT,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_PTP_GENERAL,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_ACL_SAMPLE,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_ACL_TRAP,
 
 	/* Add new generic trap group IDs above */
 	__DEVLINK_TRAP_GROUP_GENERIC_ID_MAX,
@@ -868,6 +872,10 @@ enum devlink_trap_group_generic_id {
 	"ptp_event"
 #define DEVLINK_TRAP_GENERIC_NAME_PTP_GENERAL \
 	"ptp_general"
+#define DEVLINK_TRAP_GENERIC_NAME_FLOW_ACTION_SAMPLE \
+	"flow_action_sample"
+#define DEVLINK_TRAP_GENERIC_NAME_FLOW_ACTION_TRAP \
+	"flow_action_trap"
 
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_L2_DROPS \
 	"l2_drops"
@@ -913,6 +921,10 @@ enum devlink_trap_group_generic_id {
 	"ptp_event"
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_PTP_GENERAL \
 	"ptp_general"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_ACL_SAMPLE \
+	"acl_sample"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_ACL_TRAP \
+	"acl_trap"
 
 #define DEVLINK_TRAP_GENERIC(_type, _init_action, _id, _group_id,	      \
 			     _metadata_cap)				      \
diff --git a/net/core/devlink.c b/net/core/devlink.c
index f32854c3d0e7..2cafbc808b09 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8537,6 +8537,8 @@ static const struct devlink_trap devlink_trap_generic[] = {
 	DEVLINK_TRAP(IPV6_ROUTER_ALERT, CONTROL),
 	DEVLINK_TRAP(PTP_EVENT, CONTROL),
 	DEVLINK_TRAP(PTP_GENERAL, CONTROL),
+	DEVLINK_TRAP(FLOW_ACTION_SAMPLE, CONTROL),
+	DEVLINK_TRAP(FLOW_ACTION_TRAP, CONTROL),
 };
 
 #define DEVLINK_TRAP_GROUP(_id)						      \
@@ -8568,6 +8570,8 @@ static const struct devlink_trap_group devlink_trap_group_generic[] = {
 	DEVLINK_TRAP_GROUP(IPV6),
 	DEVLINK_TRAP_GROUP(PTP_EVENT),
 	DEVLINK_TRAP_GROUP(PTP_GENERAL),
+	DEVLINK_TRAP_GROUP(ACL_SAMPLE),
+	DEVLINK_TRAP_GROUP(ACL_TRAP),
 };
 
 static int devlink_trap_generic_verify(const struct devlink_trap *trap)
-- 
2.26.2

