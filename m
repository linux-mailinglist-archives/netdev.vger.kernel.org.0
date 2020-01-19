Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00325141DE7
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 14:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgASNBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 08:01:32 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34211 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727045AbgASNBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 08:01:30 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 733C3210ED;
        Sun, 19 Jan 2020 08:01:29 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 19 Jan 2020 08:01:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=KfPS3RRSy6ySZIfPZuYotZ76Omv1rzV23MV0jNjifOg=; b=Nlh1qjUy
        BtRLGUxDu5+nhTquRSAYqByTQmqUJ5txIkEOBc5AQqdYpw12yZPk1icFQ0rpv9WC
        8tJGzxbJym66zjmgAcZsVeXtCB70xb8AcighXcfrFei+RpcnuKNTuzo2xjwu9Mod
        w+yzo1puifEIqO18Zl4uLsAmGxQBM3B0k9OXvAPFLi0WNY1ggfH10YFYvM3XnAD/
        guIqiAt6dAG87JzWVXbwq3HF8Yp1mncTYO9RxQ2K+iEukXQaEqVmchXkMmEcCk56
        hi4epw1jsIeETNdDRFLpbREFyE3+WylFm9VY+6jzq5sB3lW52SwhxJ2daU8Gv9LO
        T5Aju6jTvjMa4g==
X-ME-Sender: <xms:KVMkXmrKidVt379YUj-m0HsC7HIqaHd2cHQkxQT02_dMY3dekwQkQA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepud
X-ME-Proxy: <xmx:KVMkXsZexOz344xOd_dvnLO9zRwOMqMUlsRJg6wiQs0pYDR2ZVNqfg>
    <xmx:KVMkXpxkvDK94NXj2X0shcmqDdWKGmVYximbOzO8hNtgkXM4XRtBng>
    <xmx:KVMkXgMA_t0JWszpqNzF5Hb3eHenkLhiRB-I8062IbWXdqyDfQK2zQ>
    <xmx:KVMkXo-TpaC5XD4zjMpVAlDpCmeqHfRPIoYPWwaU7hDcK9I7aB7zng>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 28C0A8005A;
        Sun, 19 Jan 2020 08:01:28 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 03/15] devlink: Add non-routable packet trap
Date:   Sun, 19 Jan 2020 15:00:48 +0200
Message-Id: <20200119130100.3179857-4-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200119130100.3179857-1-idosch@idosch.org>
References: <20200119130100.3179857-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Add packet trap that can report packets that reached the router, but are
non-routable. For example, IGMP queries can be flooded by the device in
layer 2 and reach the router. Such packets should not be routed and
instead dropped.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 Documentation/networking/devlink/devlink-trap.rst | 6 ++++++
 include/net/devlink.h                             | 3 +++
 net/core/devlink.c                                | 1 +
 3 files changed, 10 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
index 68245ea387ad..a62e1d6eb3e4 100644
--- a/Documentation/networking/devlink/devlink-trap.rst
+++ b/Documentation/networking/devlink/devlink-trap.rst
@@ -223,6 +223,12 @@ be added to the following table:
    * - ``ipv6_lpm_miss``
      - ``exception``
      - Traps unicast IPv6 packets that did not match any route
+   * - ``non_routable_packet``
+     - ``drop``
+     - Traps packets that the device decided to drop because they are not
+       supposed to be routed. For example, IGMP queries can be flooded by the
+       device in layer 2 and reach the router. Such packets should not be
+       routed and instead dropped
 
 Driver-specific Packet Traps
 ============================
diff --git a/include/net/devlink.h b/include/net/devlink.h
index a6856f1d5d1f..08b757753e1c 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -591,6 +591,7 @@ enum devlink_trap_generic_id {
 	DEVLINK_TRAP_GENERIC_ID_REJECT_ROUTE,
 	DEVLINK_TRAP_GENERIC_ID_IPV4_LPM_UNICAST_MISS,
 	DEVLINK_TRAP_GENERIC_ID_IPV6_LPM_UNICAST_MISS,
+	DEVLINK_TRAP_GENERIC_ID_NON_ROUTABLE,
 
 	/* Add new generic trap IDs above */
 	__DEVLINK_TRAP_GENERIC_ID_MAX,
@@ -659,6 +660,8 @@ enum devlink_trap_group_generic_id {
 	"ipv4_lpm_miss"
 #define DEVLINK_TRAP_GENERIC_NAME_IPV6_LPM_UNICAST_MISS \
 	"ipv6_lpm_miss"
+#define DEVLINK_TRAP_GENERIC_NAME_NON_ROUTABLE \
+	"non_routable_packet"
 
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_L2_DROPS \
 	"l2_drops"
diff --git a/net/core/devlink.c b/net/core/devlink.c
index d30aa47052aa..c10e38d724bc 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7706,6 +7706,7 @@ static const struct devlink_trap devlink_trap_generic[] = {
 	DEVLINK_TRAP(REJECT_ROUTE, EXCEPTION),
 	DEVLINK_TRAP(IPV4_LPM_UNICAST_MISS, EXCEPTION),
 	DEVLINK_TRAP(IPV6_LPM_UNICAST_MISS, EXCEPTION),
+	DEVLINK_TRAP(NON_ROUTABLE, DROP),
 };
 
 #define DEVLINK_TRAP_GROUP(_id)						      \
-- 
2.24.1

