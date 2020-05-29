Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42191E86CB
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 20:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgE2Shg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 14:37:36 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:39885 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727915AbgE2Sha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 14:37:30 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id A21585C00B6;
        Fri, 29 May 2020 14:37:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 29 May 2020 14:37:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=3a0epmfkuU0jXkBZlAbZqDR71DYji47cWPRHtQJacXs=; b=KXjwI6hp
        C1Euq7OACWzq9gTkUNpuz5i4CcjEVmtD2ayKO/ySpV/z3O5CTnIdkFpK+nTnNR8l
        jc3ihOquoqKV9psiqHM2yKssPZoe4I9blp489TpMt5RDLcZntuL9dWEp2xr+iVYr
        8l3wVaTHm2TlePCFz28Qk+hWgv2drcLVxgVMCBQ3bFYp1drIhtmOEKmBGGEiz+F9
        0635F+QngFPGSmoojY9Fw4+qGdY0fM95Hm6ahpOVCwt8IJlyei0hZIPro3iopSgU
        ++U+VZnHgvf1aDFmAaui2RpPrCmSHOXg+luw/5oohqqjRH7ZTMAJdGov9VVQxZ1o
        dSx0l7WyteAftg==
X-ME-Sender: <xms:aVbRXqOpsGlnPX-BUNXJkK3aHa9CKkD1movC5U4XccZEuR-3NeHxRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvkedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepjeelrddujeeirddvgedruddt
    jeenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:aVbRXo_I2rxhJAIexIaQ1J9ojipdQC41WMeqBTxk-hT73zVfNVpdTQ>
    <xmx:aVbRXhQ3jNZAeS48Gj9kEp84E7BjxdoSkH6yWzLSOtePFxBs3zIV4g>
    <xmx:aVbRXqvXgrZOBqdfpTjeNit4iipsTA8w6Lu3fYhQRx6I22kC04KdeQ>
    <xmx:aVbRXmEN30bgv2L29VJvUZ6mNVeAqErPBhFtD-q-MGGooUx_RsXNCA>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5E1B73060F09;
        Fri, 29 May 2020 14:37:28 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 06/14] devlink: Add layer 2 control packet traps
Date:   Fri, 29 May 2020 21:36:41 +0300
Message-Id: <20200529183649.1602091-7-idosch@idosch.org>
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

Add layer 2 control packet traps such as STP and IGMP query, so that
capable device drivers could register them with devlink. Add
documentation for every added packet trap and packet trap group.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../networking/devlink/devlink-trap.rst       | 45 +++++++++++++++++
 include/net/devlink.h                         | 48 +++++++++++++++++++
 net/core/devlink.c                            | 16 +++++++
 3 files changed, 109 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
index 6c293cfa23ee..e9fc3c9d7d7a 100644
--- a/Documentation/networking/devlink/devlink-trap.rst
+++ b/Documentation/networking/devlink/devlink-trap.rst
@@ -252,6 +252,42 @@ be added to the following table:
    * - ``egress_flow_action_drop``
      - ``drop``
      - Traps packets dropped during processing of egress flow action drop
+   * - ``stp``
+     - ``control``
+     - Traps STP packets
+   * - ``lacp``
+     - ``control``
+     - Traps LACP packets
+   * - ``lldp``
+     - ``control``
+     - Traps LLDP packets
+   * - ``igmp_query``
+     - ``control``
+     - Traps IGMP Membership Query packets
+   * - ``igmp_v1_report``
+     - ``control``
+     - Traps IGMP Version 1 Membership Report packets
+   * - ``igmp_v2_report``
+     - ``control``
+     - Traps IGMP Version 2 Membership Report packets
+   * - ``igmp_v3_report``
+     - ``control``
+     - Traps IGMP Version 3 Membership Report packets
+   * - ``igmp_v2_leave``
+     - ``control``
+     - Traps IGMP Version 2 Leave Group packets
+   * - ``mld_query``
+     - ``control``
+     - Traps MLD Multicast Listener Query packets
+   * - ``mld_v1_report``
+     - ``control``
+     - Traps MLD Version 1 Multicast Listener Report packets
+   * - ``mld_v2_report``
+     - ``control``
+     - Traps MLD Version 2 Multicast Listener Report packets
+   * - ``mld_v1_done``
+     - ``control``
+     - Traps MLD Version 1 Multicast Listener Done packets
 
 Driver-specific Packet Traps
 ============================
@@ -299,6 +335,15 @@ narrow. The description of these groups must be added to the following table:
    * - ``acl_drops``
      - Contains packet traps for packets that were dropped by the device during
        ACL processing
+   * - ``stp``
+     - Contains packet traps for STP packets
+   * - ``lacp``
+     - Contains packet traps for LACP packets
+   * - ``lldp``
+     - Contains packet traps for LLDP packets
+   * - ``mc_snooping``
+     - Contains packet traps for IGMP and MLD packets required for multicast
+       snooping
 
 Packet Trap Policers
 ====================
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 851388c9d795..c0061542ad65 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -645,6 +645,18 @@ enum devlink_trap_generic_id {
 	DEVLINK_TRAP_GENERIC_ID_OVERLAY_SMAC_MC,
 	DEVLINK_TRAP_GENERIC_ID_INGRESS_FLOW_ACTION_DROP,
 	DEVLINK_TRAP_GENERIC_ID_EGRESS_FLOW_ACTION_DROP,
+	DEVLINK_TRAP_GENERIC_ID_STP,
+	DEVLINK_TRAP_GENERIC_ID_LACP,
+	DEVLINK_TRAP_GENERIC_ID_LLDP,
+	DEVLINK_TRAP_GENERIC_ID_IGMP_QUERY,
+	DEVLINK_TRAP_GENERIC_ID_IGMP_V1_REPORT,
+	DEVLINK_TRAP_GENERIC_ID_IGMP_V2_REPORT,
+	DEVLINK_TRAP_GENERIC_ID_IGMP_V3_REPORT,
+	DEVLINK_TRAP_GENERIC_ID_IGMP_V2_LEAVE,
+	DEVLINK_TRAP_GENERIC_ID_MLD_QUERY,
+	DEVLINK_TRAP_GENERIC_ID_MLD_V1_REPORT,
+	DEVLINK_TRAP_GENERIC_ID_MLD_V2_REPORT,
+	DEVLINK_TRAP_GENERIC_ID_MLD_V1_DONE,
 
 	/* Add new generic trap IDs above */
 	__DEVLINK_TRAP_GENERIC_ID_MAX,
@@ -661,6 +673,10 @@ enum devlink_trap_group_generic_id {
 	DEVLINK_TRAP_GROUP_GENERIC_ID_BUFFER_DROPS,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_TUNNEL_DROPS,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_ACL_DROPS,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_STP,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_LACP,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_LLDP,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_MC_SNOOPING,
 
 	/* Add new generic trap group IDs above */
 	__DEVLINK_TRAP_GROUP_GENERIC_ID_MAX,
@@ -726,6 +742,30 @@ enum devlink_trap_group_generic_id {
 	"ingress_flow_action_drop"
 #define DEVLINK_TRAP_GENERIC_NAME_EGRESS_FLOW_ACTION_DROP \
 	"egress_flow_action_drop"
+#define DEVLINK_TRAP_GENERIC_NAME_STP \
+	"stp"
+#define DEVLINK_TRAP_GENERIC_NAME_LACP \
+	"lacp"
+#define DEVLINK_TRAP_GENERIC_NAME_LLDP \
+	"lldp"
+#define DEVLINK_TRAP_GENERIC_NAME_IGMP_QUERY \
+	"igmp_query"
+#define DEVLINK_TRAP_GENERIC_NAME_IGMP_V1_REPORT \
+	"igmp_v1_report"
+#define DEVLINK_TRAP_GENERIC_NAME_IGMP_V2_REPORT \
+	"igmp_v2_report"
+#define DEVLINK_TRAP_GENERIC_NAME_IGMP_V3_REPORT \
+	"igmp_v3_report"
+#define DEVLINK_TRAP_GENERIC_NAME_IGMP_V2_LEAVE \
+	"igmp_v2_leave"
+#define DEVLINK_TRAP_GENERIC_NAME_MLD_QUERY \
+	"mld_query"
+#define DEVLINK_TRAP_GENERIC_NAME_MLD_V1_REPORT \
+	"mld_v1_report"
+#define DEVLINK_TRAP_GENERIC_NAME_MLD_V2_REPORT \
+	"mld_v2_report"
+#define DEVLINK_TRAP_GENERIC_NAME_MLD_V1_DONE \
+	"mld_v1_done"
 
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_L2_DROPS \
 	"l2_drops"
@@ -739,6 +779,14 @@ enum devlink_trap_group_generic_id {
 	"tunnel_drops"
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_ACL_DROPS \
 	"acl_drops"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_STP \
+	"stp"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_LACP \
+	"lacp"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_LLDP \
+	"lldp"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_MC_SNOOPING  \
+	"mc_snooping"
 
 #define DEVLINK_TRAP_GENERIC(_type, _init_action, _id, _group_id,	      \
 			     _metadata_cap)				      \
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 47c28e0f848f..c91ef1b5f738 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8495,6 +8495,18 @@ static const struct devlink_trap devlink_trap_generic[] = {
 	DEVLINK_TRAP(OVERLAY_SMAC_MC, DROP),
 	DEVLINK_TRAP(INGRESS_FLOW_ACTION_DROP, DROP),
 	DEVLINK_TRAP(EGRESS_FLOW_ACTION_DROP, DROP),
+	DEVLINK_TRAP(STP, CONTROL),
+	DEVLINK_TRAP(LACP, CONTROL),
+	DEVLINK_TRAP(LLDP, CONTROL),
+	DEVLINK_TRAP(IGMP_QUERY, CONTROL),
+	DEVLINK_TRAP(IGMP_V1_REPORT, CONTROL),
+	DEVLINK_TRAP(IGMP_V2_REPORT, CONTROL),
+	DEVLINK_TRAP(IGMP_V3_REPORT, CONTROL),
+	DEVLINK_TRAP(IGMP_V2_LEAVE, CONTROL),
+	DEVLINK_TRAP(MLD_QUERY, CONTROL),
+	DEVLINK_TRAP(MLD_V1_REPORT, CONTROL),
+	DEVLINK_TRAP(MLD_V2_REPORT, CONTROL),
+	DEVLINK_TRAP(MLD_V1_DONE, CONTROL),
 };
 
 #define DEVLINK_TRAP_GROUP(_id)						      \
@@ -8510,6 +8522,10 @@ static const struct devlink_trap_group devlink_trap_group_generic[] = {
 	DEVLINK_TRAP_GROUP(BUFFER_DROPS),
 	DEVLINK_TRAP_GROUP(TUNNEL_DROPS),
 	DEVLINK_TRAP_GROUP(ACL_DROPS),
+	DEVLINK_TRAP_GROUP(STP),
+	DEVLINK_TRAP_GROUP(LACP),
+	DEVLINK_TRAP_GROUP(LLDP),
+	DEVLINK_TRAP_GROUP(MC_SNOOPING),
 };
 
 static int devlink_trap_generic_verify(const struct devlink_trap *trap)
-- 
2.26.2

