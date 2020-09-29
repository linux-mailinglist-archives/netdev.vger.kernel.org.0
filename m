Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C824427BF4E
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 10:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727759AbgI2I0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 04:26:07 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:45115 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727731AbgI2I0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 04:26:06 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id A77715807D3;
        Tue, 29 Sep 2020 04:17:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 29 Sep 2020 04:17:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=PF/O5pnw+i550s0SAF+/HzoAXGtkdwSoamgI4EekWok=; b=CX3EuAuz
        z5vzgUXCJcvK1dBVXW2CKKIwW683Q9aaZZBg/K6Rb8jOGAQWqXnkO4UIfK3iGpfS
        PpnY5/T5zv71MwHIpMQp3W0yi6WA09Eay8rV3nHTy2UCLD18KvxAQfBEcoaC+g3g
        pjrgqjFEg9cWKmUlOz3zGS3HBp4xDkx1oaMeP+WJM06nTTioPd88LzCX0FKIgVTw
        C6rIO9GRTskUqDfXptyXzFl5SbyKeuX8cRZxhKYKoQRqm5hMGuHCDHCSdgAhipfA
        QhW561HJLCwpZ++UL7EyOfa/hcgUHlpbnstEltMDnfFI0m+s0qqvm3INnj4A6egl
        USSBQbN+uczLOg==
X-ME-Sender: <xms:hO1yX7I1X9X4IEJah0IgT20cpl8R_Tm0k6EP4D8_MZzGLFuJqoCHcA>
    <xme:hO1yX_Lk1YfalCBC_AysgXVWj90IfUO4_qbLAarTObd3Qw2Xchc3pCjWbaAhMADJX
    t4NMw7BdaGE9Jw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdekgddtvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdefjedrudegkeen
    ucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:hO1yXzs_POSX8Q26bPCiKFGs3doihgGVwby4RkRGFoDupNPa0C2Zhg>
    <xmx:hO1yX0ZavQcfn_sCFKVPxXAsEVbEa9U3aUq23WyENxWly3I7EBmXoQ>
    <xmx:hO1yXyYYhpOYDnIEfNDRjAvG64SB-_La3miXEkqVxnbOqcJK44wYLw>
    <xmx:hO1yX66PKpnO2DLyg_suQ2OMXflHCjKl8yc_rB0BfJu--UISpH9XdA>
Received: from shredder.mtl.com (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id 50E913280059;
        Tue, 29 Sep 2020 04:17:06 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jiri@nvidia.com, roopa@nvidia.com, aroulin@nvidia.com,
        ayal@nvidia.com, masahiroy@kernel.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 6/7] drop_monitor: Filter control packets in drop monitor
Date:   Tue, 29 Sep 2020 11:15:55 +0300
Message-Id: <20200929081556.1634838-7-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200929081556.1634838-1-idosch@idosch.org>
References: <20200929081556.1634838-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Previously, devlink called into drop monitor in order to report hardware
originated drops / exceptions. devlink intentionally filtered control
packets and did not pass them to drop monitor as they were not dropped
by the underlying hardware.

Now drop monitor registers its probe on a generic 'devlink_trap_report'
tracepoint and should therefore perform this filtering itself instead of
having devlink do that.

Add the trap type as metadata and have drop monitor ignore control
packets.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/devlink.h   | 2 ++
 net/core/devlink.c      | 8 +-------
 net/core/drop_monitor.c | 6 ++++++
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 1014294ba6a0..1c286e9a3590 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -630,12 +630,14 @@ struct devlink_health_reporter_ops {
  * @trap_group_name: Trap group name.
  * @input_dev: Input netdevice.
  * @fa_cookie: Flow action user cookie.
+ * @trap_type: Trap type.
  */
 struct devlink_trap_metadata {
 	const char *trap_name;
 	const char *trap_group_name;
 	struct net_device *input_dev;
 	const struct flow_action_cookie *fa_cookie;
+	enum devlink_trap_type trap_type;
 };
 
 /**
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 2ea9fdc0df2d..6f2863e717a9 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9269,6 +9269,7 @@ devlink_trap_report_metadata_set(struct devlink_trap_metadata *metadata,
 	metadata->trap_name = trap_item->trap->name;
 	metadata->trap_group_name = trap_item->group_item->group->name;
 	metadata->fa_cookie = fa_cookie;
+	metadata->trap_type = trap_item->trap->type;
 
 	spin_lock(&in_devlink_port->type_lock);
 	if (in_devlink_port->type == DEVLINK_PORT_TYPE_ETH)
@@ -9294,13 +9295,6 @@ void devlink_trap_report(struct devlink *devlink, struct sk_buff *skb,
 	devlink_trap_stats_update(trap_item->stats, skb->len);
 	devlink_trap_stats_update(trap_item->group_item->stats, skb->len);
 
-	/* Control packets were not dropped by the device or encountered an
-	 * exception during forwarding and therefore should not be reported to
-	 * the kernel's drop monitor.
-	 */
-	if (trap_item->trap->type == DEVLINK_TRAP_TYPE_CONTROL)
-		return;
-
 	if (trace_devlink_trap_report_enabled()) {
 		struct devlink_trap_metadata metadata = {};
 
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 0e4309414a30..a28b743489c5 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -444,6 +444,9 @@ net_dm_hw_trap_summary_probe(void *ignore, const struct devlink *devlink,
 	unsigned long flags;
 	int i;
 
+	if (metadata->trap_type == DEVLINK_TRAP_TYPE_CONTROL)
+		return;
+
 	hw_data = this_cpu_ptr(&dm_hw_cpu_data);
 	spin_lock_irqsave(&hw_data->lock, flags);
 	hw_entries = hw_data->hw_entries;
@@ -937,6 +940,9 @@ net_dm_hw_trap_packet_probe(void *ignore, const struct devlink *devlink,
 	struct sk_buff *nskb;
 	unsigned long flags;
 
+	if (metadata->trap_type == DEVLINK_TRAP_TYPE_CONTROL)
+		return;
+
 	if (!skb_mac_header_was_set(skb))
 		return;
 
-- 
2.26.2

