Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1F80F34D8
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389615AbfKGQnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:43:23 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:52339 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389585AbfKGQnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:43:22 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C3B2E2104A;
        Thu,  7 Nov 2019 11:43:21 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 07 Nov 2019 11:43:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=ESDRgObSqXKBujF1zoT1VtNlTF/qhwZDa9Pk+/AEjUU=; b=Jrysw4Yj
        f9xFB/aXRz/r/xA27dBHwuW7jJrzusgog7T0RuLWAwR7JaXTCNGY/eqW+kTKUDJv
        fJxCm3wPLNax3gfiF0mTlzBjFh2QPat9R2XWt4i2zrp/M/O7u2CMEQYpomrIdFfQ
        CdwvtMtTO7Q4xQWVnuxRczWowxsLsarXMj9M1u+kEYyvtLaTxv1cDqC9OS7P0Sb2
        o+kQm0vPsNBbBiClQD1qO6sqIpIGg1uMjyvvwvPzPsfVcv8jVxZHXR48XoHdNf2h
        F3Sw3M4F7HzwJaBEcut1YKH+q39f13fYl5hGo6QfFiAuhB1HvVfPlxHtpYOU5zXR
        IM0qwxE2UR3MEA==
X-ME-Sender: <xms:qUnEXa4oVj7qUe86kp5Qt8geDkwTq2yHGlrfxI5ZYykchp8tobHDJw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudduledgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:qUnEXYKbyPh2KgXYILlfK4pn_wahDsRao8uAJ2dr2L4TihXeWOMkow>
    <xmx:qUnEXUfvowJH_OVeqx5Ue4yzhYms5HGqkGkozC_NmODMxZOjQZUkQA>
    <xmx:qUnEXbe0OZ-yLJya8ejYPn6FrJd4C-vfYn7G_GEKqrRB4VyasoAzgA>
    <xmx:qUnEXYLdq3DtFvZThmtGDIMvmH7MEC4AEkk1ytRyQo3lrvNlhqsykw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2D99880063;
        Thu,  7 Nov 2019 11:43:20 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        dsahern@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 06/12] devlink: Add layer 3 generic packet exception traps
Date:   Thu,  7 Nov 2019 18:42:14 +0200
Message-Id: <20191107164220.20526-7-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191107164220.20526-1-idosch@idosch.org>
References: <20191107164220.20526-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Add layer 3 generic packet exception traps that can report trapped
packets and documentation of the traps.

Unlike drop traps, these exception traps also need to inject the packet
to the kernel's receive path. For example, a packet that was trapped due
to unreachable neighbour need to be injected into the kernel so that it
will trigger an ARP request or a neighbour solicitation message.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 Documentation/networking/devlink-trap.rst | 20 ++++++++++++++++++++
 include/net/devlink.h                     | 18 ++++++++++++++++++
 net/core/devlink.c                        |  6 ++++++
 3 files changed, 44 insertions(+)

diff --git a/Documentation/networking/devlink-trap.rst b/Documentation/networking/devlink-trap.rst
index dc3dc87217c9..dc9659ca06fa 100644
--- a/Documentation/networking/devlink-trap.rst
+++ b/Documentation/networking/devlink-trap.rst
@@ -203,6 +203,26 @@ be added to the following table:
      - Traps IPv6 packets that the device decided to drop because they need to
        be routed and their IPv6 multicast destination IP has an interface-local scope
        (i.e., ffx1::/16)
+   * - ``mtu_value_is_too_small``
+     - ``exception``
+     - Traps packets that should have been routed by the device, but were bigger
+       than the MTU of the egress interface
+   * - ``unresolved_neigh``
+     - ``exception``
+     - Traps packets that did not have a matching IP neighbour after routing
+   * - ``mc_reverse_path_forwarding``
+     - ``exception``
+     - Traps multicast IP packets that failed reverse-path forwarding (RPF)
+       check during multicast routing
+   * - ``reject_route``
+     - ``exception``
+     - Traps packets that hit reject routes (i.e., "unreachable", "prohibit")
+   * - ``ipv4_lpm_miss``
+     - ``exception``
+     - Traps unicast IPv4 packets that did not match any route
+   * - ``ipv6_lpm_miss``
+     - ``exception``
+     - Traps unicast IPv6 packets that did not match any route
 
 Driver-specific Packet Traps
 ============================
diff --git a/include/net/devlink.h b/include/net/devlink.h
index df7814d55bf9..8d6b5846822c 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -578,6 +578,12 @@ enum devlink_trap_generic_id {
 	DEVLINK_TRAP_GENERIC_ID_IPV4_SIP_BC,
 	DEVLINK_TRAP_GENERIC_ID_IPV6_MC_DIP_RESERVED_SCOPE,
 	DEVLINK_TRAP_GENERIC_ID_IPV6_MC_DIP_INTERFACE_LOCAL_SCOPE,
+	DEVLINK_TRAP_GENERIC_ID_MTU_ERROR,
+	DEVLINK_TRAP_GENERIC_ID_UNRESOLVED_NEIGH,
+	DEVLINK_TRAP_GENERIC_ID_RPF,
+	DEVLINK_TRAP_GENERIC_ID_REJECT_ROUTE,
+	DEVLINK_TRAP_GENERIC_ID_IPV4_LPM_UNICAST_MISS,
+	DEVLINK_TRAP_GENERIC_ID_IPV6_LPM_UNICAST_MISS,
 
 	/* Add new generic trap IDs above */
 	__DEVLINK_TRAP_GENERIC_ID_MAX,
@@ -634,6 +640,18 @@ enum devlink_trap_group_generic_id {
 	"ipv6_mc_dip_reserved_scope"
 #define DEVLINK_TRAP_GENERIC_NAME_IPV6_MC_DIP_INTERFACE_LOCAL_SCOPE \
 	"ipv6_mc_dip_interface_local_scope"
+#define DEVLINK_TRAP_GENERIC_NAME_MTU_ERROR \
+	"mtu_value_is_too_small"
+#define DEVLINK_TRAP_GENERIC_NAME_UNRESOLVED_NEIGH \
+	"unresolved_neigh"
+#define DEVLINK_TRAP_GENERIC_NAME_RPF \
+	"mc_reverse_path_forwarding"
+#define DEVLINK_TRAP_GENERIC_NAME_REJECT_ROUTE \
+	"reject_route"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV4_LPM_UNICAST_MISS \
+	"ipv4_lpm_miss"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV6_LPM_UNICAST_MISS \
+	"ipv6_lpm_miss"
 
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_L2_DROPS \
 	"l2_drops"
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 9bbe2162f22f..ff53f7d29dea 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7611,6 +7611,12 @@ static const struct devlink_trap devlink_trap_generic[] = {
 	DEVLINK_TRAP(IPV4_SIP_BC, DROP),
 	DEVLINK_TRAP(IPV6_MC_DIP_RESERVED_SCOPE, DROP),
 	DEVLINK_TRAP(IPV6_MC_DIP_INTERFACE_LOCAL_SCOPE, DROP),
+	DEVLINK_TRAP(MTU_ERROR, EXCEPTION),
+	DEVLINK_TRAP(UNRESOLVED_NEIGH, EXCEPTION),
+	DEVLINK_TRAP(RPF, EXCEPTION),
+	DEVLINK_TRAP(REJECT_ROUTE, EXCEPTION),
+	DEVLINK_TRAP(IPV4_LPM_UNICAST_MISS, EXCEPTION),
+	DEVLINK_TRAP(IPV6_LPM_UNICAST_MISS, EXCEPTION),
 };
 
 #define DEVLINK_TRAP_GROUP(_id)						      \
-- 
2.21.0

