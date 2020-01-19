Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E06E5141DEB
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 14:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgASNBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 08:01:35 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50617 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726798AbgASNBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 08:01:31 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C947A21B1B;
        Sun, 19 Jan 2020 08:01:30 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 19 Jan 2020 08:01:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=KjlWYAtFtAlPhpkee/rR4vJPIgDlr9nbQyi0WpKw9VY=; b=Rc4LsOpY
        t0EAubuoIeFAW3huGQ3DE7BizrAjveNqh7vemFzlQkBeqF5QbAFxpAQCE03pBH37
        bW+khH1c7s9Da9zJDrl5uNvfNySClv2+bY5SQ6hTPz17bvu62JaJfZr6TikaxLjO
        QjZJ2iF4SY8WBLezNgr3/7Wg9HHrpkogB4eQ5dKJDcggHyZs0GuvepUIRGBOstOO
        etc/uaMivMU7iy5AwcWIA9xoRmB0Pz3aMeN+js2uYlbjQ9cfKR7MRoUPlrHR7w3p
        ofBXCGgW3pAlDr53RwIBwkLT7M2377TCuBT99SKhZkG1oTNId906rJd+dJhbCFwB
        sKGDiyLpP1DzJw==
X-ME-Sender: <xms:KlMkXpKptkIJm-L3FpLhTEFOZ7Obx79uaChhnv7e4mOwSW0kEhGGnw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepud
X-ME-Proxy: <xmx:KlMkXlgmFr11Hs7Fgyq0crXvdfE_bWWoLM4_Qef9R8tV8gRCqd9fuw>
    <xmx:KlMkXpkp8hDNkBiZTkOCyjoS56S1CP0JjkYT7GOOXE7PnDYYtSSWEw>
    <xmx:KlMkXoEMdAR9npLqP07S6KQfzd7_9QGUMW-MoJLLZyH8zEQ72dA3tQ>
    <xmx:KlMkXlWWxoAv1XPa1MNOcYcOiVV9ahpmtDXFLzbC4MrAOhZmN4SSXA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7D0CB80062;
        Sun, 19 Jan 2020 08:01:29 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 04/15] mlxsw: Add NON_ROUTABLE trap
Date:   Sun, 19 Jan 2020 15:00:49 +0200
Message-Id: <20200119130100.3179857-5-idosch@idosch.org>
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

Add a trap for packets that the device decided to drop because they are
not supposed to be routed. For example, IGMP queries can be flooded by
the device in layer 2 and reach the router. Such packets should not be
routed and instead dropped.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c | 3 +++
 drivers/net/ethernet/mellanox/mlxsw/trap.h          | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 42013fe11131..8706821f5851 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -80,6 +80,7 @@ static struct devlink_trap mlxsw_sp_traps_arr[] = {
 	MLXSW_SP_TRAP_EXCEPTION(IPV6_LPM_UNICAST_MISS, L3_DROPS),
 	MLXSW_SP_TRAP_DRIVER_DROP(IRIF_DISABLED, L3_DROPS),
 	MLXSW_SP_TRAP_DRIVER_DROP(ERIF_DISABLED, L3_DROPS),
+	MLXSW_SP_TRAP_DROP(NON_ROUTABLE, L3_DROPS),
 };
 
 static struct mlxsw_listener mlxsw_sp_listeners_arr[] = {
@@ -114,6 +115,7 @@ static struct mlxsw_listener mlxsw_sp_listeners_arr[] = {
 			       TRAP_EXCEPTION_TO_CPU),
 	MLXSW_SP_RXL_DISCARD(ROUTER_IRIF_EN, L3_DISCARDS),
 	MLXSW_SP_RXL_DISCARD(ROUTER_ERIF_EN, L3_DISCARDS),
+	MLXSW_SP_RXL_DISCARD(NON_ROUTABLE, L3_DISCARDS),
 };
 
 /* Mapping between hardware trap and devlink trap. Multiple hardware traps can
@@ -149,6 +151,7 @@ static u16 mlxsw_sp_listener_devlink_map[] = {
 	DEVLINK_TRAP_GENERIC_ID_IPV6_LPM_UNICAST_MISS,
 	DEVLINK_MLXSW_TRAP_ID_IRIF_DISABLED,
 	DEVLINK_MLXSW_TRAP_ID_ERIF_DISABLED,
+	DEVLINK_TRAP_GENERIC_ID_NON_ROUTABLE,
 };
 
 static int mlxsw_sp_rx_listener(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index 8573cc3a0010..7d07ec8d440b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -67,6 +67,7 @@ enum {
 	MLXSW_TRAP_ID_NVE_ENCAP_ARP = 0xBD,
 	MLXSW_TRAP_ID_ROUTER_ALERT_IPV4 = 0xD6,
 	MLXSW_TRAP_ID_ROUTER_ALERT_IPV6 = 0xD7,
+	MLXSW_TRAP_ID_DISCARD_NON_ROUTABLE = 0x11A,
 	MLXSW_TRAP_ID_DISCARD_ROUTER2 = 0x130,
 	MLXSW_TRAP_ID_DISCARD_ROUTER3 = 0x131,
 	MLXSW_TRAP_ID_DISCARD_ING_PACKET_SMAC_MC = 0x140,
-- 
2.24.1

