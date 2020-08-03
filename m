Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A7723AA3E
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 18:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgHCQMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 12:12:34 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37631 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725945AbgHCQMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 12:12:34 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id DA50C5C00D2;
        Mon,  3 Aug 2020 12:12:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 03 Aug 2020 12:12:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=P2xpEvY//Gix9ZrgLcZu6OVIH9jKePBFABXPwgtvrTM=; b=PNOwhyEY
        pQgVfzwFMQj/k1NK3ohr7L5spldYZqsNWVpIdfa0MJZ5sPEZpuNLw0Fm3ox8U0pI
        X0+siIO/TD6II/GyVW8sUzkfBGYWtdlxsNnfC5HeUcmWYpBYeZzuR0sg/aUF0yKQ
        DZ6eiiyHY3WgDbq/lvYWIg1rkQHiTO4syti8hTr+WRS+AI1L1xVR1aeO45adAZVA
        yuaydPr5sR0YkwzNjZvzYlWXCcsVj8+yw3Yb6elkVUARYtr4eOc1JKUrBQtVe/Da
        BAZRasCmomidW3uFAeBSmu+CZ6dXbJoucu/zlRpZS/kv0dcP5ROvgGvbUNt86khf
        Z2NIMVFHozaP3g==
X-ME-Sender: <xms:cDcoXyinajUScnmh4gv6xWx8dYjth8VBuSO92x2coZa2ZEZzTcBJxA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjeeggdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepjeelrddukedurdeirddvudelnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:cDcoXzA4baGb5X3DtSqGXSxHNU-tkZh48VgmxAooEfVICImecp_mfQ>
    <xmx:cDcoX6FknD8L83q_tfzQeadLXHUSTa0njdwhhRl9N624w7G-_VSKaA>
    <xmx:cDcoX7TqTj-Q8LRtqbTswMBDUIuU1wIqSlY4kiM12qDHGn1tGPfVhg>
    <xmx:cDcoX_9Mc2SD9nJK2p3BokbyfyRKLiGLR525t4gA1G2rTqkObnNP0w>
Received: from shredder.mtl.com (bzq-79-181-6-219.red.bezeqint.net [79.181.6.219])
        by mail.messagingengine.com (Postfix) with ESMTPA id AB0853060067;
        Mon,  3 Aug 2020 12:12:30 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/9] devlink: Add early_drop trap
Date:   Mon,  3 Aug 2020 19:11:33 +0300
Message-Id: <20200803161141.2523857-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200803161141.2523857-1-idosch@idosch.org>
References: <20200803161141.2523857-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Add the packet trap that can report packets that were ECN marked due to RED
AQM.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 Documentation/networking/devlink/devlink-trap.rst | 4 ++++
 include/net/devlink.h                             | 3 +++
 net/core/devlink.c                                | 1 +
 3 files changed, 8 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
index 2014307fbe63..7a798352b45d 100644
--- a/Documentation/networking/devlink/devlink-trap.rst
+++ b/Documentation/networking/devlink/devlink-trap.rst
@@ -405,6 +405,10 @@ be added to the following table:
      - ``control``
      - Traps packets logged during processing of flow action trap (e.g., via
        tc's trap action)
+   * - ``early_drop``
+     - ``drop``
+     - Traps packets dropped due to the RED (Random Early Detection) algorithm
+       (i.e., early drops)
 
 Driver-specific Packet Traps
 ============================
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 0606967cb501..fd3ae0760492 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -703,6 +703,7 @@ enum devlink_trap_generic_id {
 	DEVLINK_TRAP_GENERIC_ID_PTP_GENERAL,
 	DEVLINK_TRAP_GENERIC_ID_FLOW_ACTION_SAMPLE,
 	DEVLINK_TRAP_GENERIC_ID_FLOW_ACTION_TRAP,
+	DEVLINK_TRAP_GENERIC_ID_EARLY_DROP,
 
 	/* Add new generic trap IDs above */
 	__DEVLINK_TRAP_GENERIC_ID_MAX,
@@ -891,6 +892,8 @@ enum devlink_trap_group_generic_id {
 	"flow_action_sample"
 #define DEVLINK_TRAP_GENERIC_NAME_FLOW_ACTION_TRAP \
 	"flow_action_trap"
+#define DEVLINK_TRAP_GENERIC_NAME_EARLY_DROP \
+	"early_drop"
 
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_L2_DROPS \
 	"l2_drops"
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 5fdebb7289e9..bde4c29a30bc 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8801,6 +8801,7 @@ static const struct devlink_trap devlink_trap_generic[] = {
 	DEVLINK_TRAP(PTP_GENERAL, CONTROL),
 	DEVLINK_TRAP(FLOW_ACTION_SAMPLE, CONTROL),
 	DEVLINK_TRAP(FLOW_ACTION_TRAP, CONTROL),
+	DEVLINK_TRAP(EARLY_DROP, DROP),
 };
 
 #define DEVLINK_TRAP_GROUP(_id)						      \
-- 
2.26.2

