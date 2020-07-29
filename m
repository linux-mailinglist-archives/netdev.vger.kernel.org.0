Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C221E231C10
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 11:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgG2J10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 05:27:26 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47277 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726536AbgG2J1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 05:27:24 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 57C1C5C017C;
        Wed, 29 Jul 2020 05:27:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 29 Jul 2020 05:27:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=OrELT9f6CLdH7PewWbaH0s3UGz4DwgrgQ/rfd0/v8Xc=; b=jYP6Z7vK
        1uHtyEJUub21frsIXt6ot0SwBkEjGLUUdxoCMfD5u1aGsCFEE8YbuUzsvOvfaLho
        co9CHnEwGeBB2hp81LxsjBfGNjHOPZn2jw0DD/u6+0WS1Hqp1iJW8jUJsWE5lfpx
        8VrIFLM4iRHu8rU3zf+jrsbgVBi9ywjm4ofHJUagjApdEuneZvgBzqP+9f0ezV+8
        uFVdsCnh0XJxNDdTdQfeTMjb86cK77MRSFVhIhjXodWV42ubIaRM1+NqadHiDvo4
        Dcu2hdr30gIiaY239awnjddWdW88xOGohNjP8ZeG4aESz2joas6XfPoumUccSfFU
        5HOzOmlCjWqL1A==
X-ME-Sender: <xms:-0AhX5dhsmEBbw7deEb1HA_1JF4WJcKPOk1M9ZV-lql_fe1BKQANdw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrieeggdduiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieehrddufeejrddvhedt
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:-0AhX3NTyw1qXrykjvAplXHQ4C3YB6Mitshqkt-M82ADCX9N_ukqAQ>
    <xmx:-0AhXygy8CsQxhG_sMqZ-qs8jtl313U9zKt_3BfrfAGFD6Q2JuscQg>
    <xmx:-0AhXy-3GLSk5GJevBFUtyLO-o5rXpZFPaDM13nLnCdd1e9mLJC-hA>
    <xmx:-0AhX9L0RDeVRSLal6KxgbqOnDVhH4Aomr3MWlV-BoPNYawWKu40pA>
Received: from shredder.mtl.com (bzq-109-65-137-250.red.bezeqint.net [109.65.137.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id 674C33280059;
        Wed, 29 Jul 2020 05:27:21 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        amitc@mellanox.com, alexve@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 2/6] mlxsw: spectrum: Use different trap group for externally routed packets
Date:   Wed, 29 Jul 2020 12:26:44 +0300
Message-Id: <20200729092648.2055488-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200729092648.2055488-1-idosch@idosch.org>
References: <20200729092648.2055488-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Cited commit mistakenly removed the trap group for externally routed
packets (e.g., via the management interface) and grouped locally routed
and externally routed packet traps under the same group, thereby
subjecting them to the same policer.

This can result in problems, for example, when FRR is restarted and
suddenly all transient traffic is trapped to the CPU because of a
default route through the management interface. Locally routed packets
required to re-establish a BGP connection will never reach the CPU and
the routing tables will not be re-populated.

Fix this by using a different trap group for externally routed packets.

Fixes: 8110668ecd9a ("mlxsw: spectrum_trap: Register layer 3 control traps")
Reported-by: Alex Veber <alexve@mellanox.com>
Tested-by: Alex Veber <alexve@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 Documentation/networking/devlink/devlink-trap.rst  |  4 ++++
 drivers/net/ethernet/mellanox/mlxsw/reg.h          |  1 +
 .../net/ethernet/mellanox/mlxsw/spectrum_trap.c    | 14 +++++++++++---
 include/net/devlink.h                              |  3 +++
 net/core/devlink.c                                 |  1 +
 5 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
index 1e3f3ffee248..2014307fbe63 100644
--- a/Documentation/networking/devlink/devlink-trap.rst
+++ b/Documentation/networking/devlink/devlink-trap.rst
@@ -486,6 +486,10 @@ narrow. The description of these groups must be added to the following table:
      - Contains packet traps for packets that should be locally delivered after
        routing, but do not match more specific packet traps (e.g.,
        ``ipv4_bgp``)
+   * - ``external_delivery``
+     - Contains packet traps for packets that should be routed through an
+       external interface (e.g., management interface) that does not belong to
+       the same device (e.g., switch ASIC) as the ingress interface
    * - ``ipv6``
      - Contains packet traps for various IPv6 control packets (e.g., Router
        Advertisements)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index fcb88d4271bf..8ac987c8c8bc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5536,6 +5536,7 @@ enum mlxsw_reg_htgt_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_MULTICAST,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_NEIGH_DISCOVERY,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_ROUTER_EXP,
+	MLXSW_REG_HTGT_TRAP_GROUP_SP_EXTERNAL_ROUTE,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_IP2ME,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_DHCP,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_EVENT,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 157a42c63066..1e38dfe7cf64 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -328,6 +328,9 @@ mlxsw_sp_trap_policer_items_arr[] = {
 	{
 		.policer = MLXSW_SP_TRAP_POLICER(18, 1024, 128),
 	},
+	{
+		.policer = MLXSW_SP_TRAP_POLICER(19, 1024, 512),
+	},
 };
 
 static const struct mlxsw_sp_trap_group_item mlxsw_sp_trap_group_items_arr[] = {
@@ -421,6 +424,11 @@ static const struct mlxsw_sp_trap_group_item mlxsw_sp_trap_group_items_arr[] = {
 		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_IP2ME,
 		.priority = 2,
 	},
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(EXTERNAL_DELIVERY, 19),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_EXTERNAL_ROUTE,
+		.priority = 1,
+	},
 	{
 		.group = DEVLINK_TRAP_GROUP_GENERIC(IPV6, 15),
 		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6,
@@ -882,11 +890,11 @@ static const struct mlxsw_sp_trap_item mlxsw_sp_trap_items_arr[] = {
 		},
 	},
 	{
-		.trap = MLXSW_SP_TRAP_CONTROL(EXTERNAL_ROUTE, LOCAL_DELIVERY,
+		.trap = MLXSW_SP_TRAP_CONTROL(EXTERNAL_ROUTE, EXTERNAL_DELIVERY,
 					      TRAP),
 		.listeners_arr = {
-			MLXSW_SP_RXL_MARK(RTR_INGRESS0, IP2ME, TRAP_TO_CPU,
-					  false),
+			MLXSW_SP_RXL_MARK(RTR_INGRESS0, EXTERNAL_ROUTE,
+					  TRAP_TO_CPU, false),
 		},
 	},
 	{
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 1df6dfec26c2..95b0322a2a82 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -718,6 +718,7 @@ enum devlink_trap_group_generic_id {
 	DEVLINK_TRAP_GROUP_GENERIC_ID_PIM,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_UC_LB,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_LOCAL_DELIVERY,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_EXTERNAL_DELIVERY,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_IPV6,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_PTP_EVENT,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_PTP_GENERAL,
@@ -915,6 +916,8 @@ enum devlink_trap_group_generic_id {
 	"uc_loopback"
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_LOCAL_DELIVERY \
 	"local_delivery"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_EXTERNAL_DELIVERY \
+	"external_delivery"
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_IPV6 \
 	"ipv6"
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_PTP_EVENT \
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 2cafbc808b09..dc2b18475956 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8567,6 +8567,7 @@ static const struct devlink_trap_group devlink_trap_group_generic[] = {
 	DEVLINK_TRAP_GROUP(PIM),
 	DEVLINK_TRAP_GROUP(UC_LB),
 	DEVLINK_TRAP_GROUP(LOCAL_DELIVERY),
+	DEVLINK_TRAP_GROUP(EXTERNAL_DELIVERY),
 	DEVLINK_TRAP_GROUP(IPV6),
 	DEVLINK_TRAP_GROUP(PTP_EVENT),
 	DEVLINK_TRAP_GROUP(PTP_GENERAL),
-- 
2.26.2

