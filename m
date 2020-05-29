Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB151E86CC
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 20:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgE2Shh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 14:37:37 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:60855 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727911AbgE2She (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 14:37:34 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id C85FE5C00AA;
        Fri, 29 May 2020 14:37:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 29 May 2020 14:37:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=4W78WeqHqpdUq+rt7HMK3w/LAZxJvxeT3SF3JeA2k3A=; b=DXm63CFA
        vrwekW/NHtQtTNxH1TrOljQ4DDrI8FG880AUjsgpBjARmxdQA5tRm8j9Ue29xaf/
        z99ckAILp8vX7k4+dfGeHDHrD5DNtaMw01nZ3Pm3lS9XQDZ84N44HV8NTQl43SY6
        4QjNFypygZ2Seg477WmjtZveheImc5VHu4VQdjfVYspPUq0OP1geRbOUwomA8ysv
        8esxFoNksv1bhgSYcaHlOb7qS1KX9a/tN20fqJlLu4b778rgDxq1bd799sxq/QLr
        mDxdINvqel4/N+SdVkufnEoJnRmo2P5+XE5uHqCwvJTZVawixfiZuK0VvRN1Zbkh
        pOBD1WE8TlH8Ew==
X-ME-Sender: <xms:bVbRXg6Mqca08upsoxaqfHKWtPIKNebkZDCM7tPIme7qvqvDZcMI1A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvkedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepjeelrddujeeirddvgedruddt
    jeenucevlhhushhtvghrufhiiigvpeeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:bVbRXh5S43JYzerEBAj76F4wcZy5c9Un7SIm5m76htWag8vjfP3KFQ>
    <xmx:bVbRXvdCmdXGSd0lCpH91cXfqp9vw-es8y4XduJr0XI_BVGYNqfVKg>
    <xmx:bVbRXlLZAte15MUrraaNvFetiyd4asSVJ5sIwPw4hC_VloDN1Alojw>
    <xmx:bVbRXuj8iO6dtrRmovB5670a4pbLFR0_PdImj8vIrz0kgo1tGyF8mg>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 85EA33060F09;
        Fri, 29 May 2020 14:37:32 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 09/14] netdevsim: Register control traps
Date:   Fri, 29 May 2020 21:36:44 +0300
Message-Id: <20200529183649.1602091-10-idosch@idosch.org>
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

Register two control traps with devlink. The existing selftest at
tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh iterates
over all registered traps and checks that the action of non-drop traps
cannot be changed. Up until now only exception traps were tested, now
control traps will be tested as well.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/netdevsim/dev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 09d947eff980..ec6b6f7818ac 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -431,6 +431,10 @@ enum {
 	DEVLINK_TRAP_GENERIC(EXCEPTION, TRAP, _id,			      \
 			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
 			     NSIM_TRAP_METADATA)
+#define NSIM_TRAP_CONTROL(_id, _group_id, _action)			      \
+	DEVLINK_TRAP_GENERIC(CONTROL, _action, _id,			      \
+			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
+			     NSIM_TRAP_METADATA)
 #define NSIM_TRAP_DRIVER_EXCEPTION(_id, _group_id)			      \
 	DEVLINK_TRAP_DRIVER(EXCEPTION, TRAP, NSIM_TRAP_ID_##_id,	      \
 			    NSIM_TRAP_NAME_##_id,			      \
@@ -461,6 +465,7 @@ static const struct devlink_trap_group nsim_trap_groups_arr[] = {
 	DEVLINK_TRAP_GROUP_GENERIC(L3_EXCEPTIONS, 1),
 	DEVLINK_TRAP_GROUP_GENERIC(BUFFER_DROPS, 2),
 	DEVLINK_TRAP_GROUP_GENERIC(ACL_DROPS, 3),
+	DEVLINK_TRAP_GROUP_GENERIC(MC_SNOOPING, 3),
 };
 
 static const struct devlink_trap nsim_traps_arr[] = {
@@ -478,6 +483,8 @@ static const struct devlink_trap nsim_traps_arr[] = {
 			   DEVLINK_TRAP_METADATA_TYPE_F_FA_COOKIE),
 	NSIM_TRAP_DROP_EXT(EGRESS_FLOW_ACTION_DROP, ACL_DROPS,
 			   DEVLINK_TRAP_METADATA_TYPE_F_FA_COOKIE),
+	NSIM_TRAP_CONTROL(IGMP_QUERY, MC_SNOOPING, MIRROR),
+	NSIM_TRAP_CONTROL(IGMP_V1_REPORT, MC_SNOOPING, TRAP),
 };
 
 #define NSIM_TRAP_L4_DATA_LEN 100
-- 
2.26.2

